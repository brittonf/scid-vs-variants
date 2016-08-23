
### file.tcl

# Get confirmation then exit.

proc ::file::Exit {}  {

  # sanity check in case of errant multiple calls
  if {[winfo exists .unsaved]} {return}

  # is OSX recursively calling this proc when tk_dialog exits ?
  wm protocol . WM_DELETE_WINDOW {}

  # Check for altered game in all bases except the clipbase:
  set unsavedCount 0
  set savedBase [sc_base current]
  set msg ""
  set nbases [sc_base count total]
  for {set i 1} {$i < [sc_base count total]} {incr i} {
    sc_base switch $i
    if {[sc_base inUse] && [sc_game altered] && ![sc_base isReadOnly]} {
      if {$unsavedCount == 0} {
        append msg $::tr(ExitUnsaved)
        append msg "\n\n"
      }
      incr unsavedCount
      set fname [file tail [sc_base filename]]
      set g [sc_game number]
      append msg "   $fname "
      append msg "($::tr(game) $g)"
      append msg "\n"
    }
  }
  # Switch back to original database:
  sc_base switch $savedBase

  if {$unsavedCount > 0 || [winfo exists .comp]} {
    if {$unsavedCount == 0} {
      set msg {A Computer Tournament is running.}
    }
    append msg "\n$::tr(ExitDialog)"

    set answer [tk_dialog .unsaved "Scid: Confirm Quit" $msg question {} "   [tr FileExit]   " [tr Cancel]]

    if {$answer != 0} {
      wm protocol . WM_DELETE_WINDOW {::file::Exit}
      return
    }
  }

  if {[winfo exists .glistWin]} {
    ::windows::gamelist::recordWidths
  }
  if {$::optionsAutoSave} {
    # restore askToReplaceMoves if necessary
    if {[winfo exists .tacticsWin]} {
      ::tactics::restoreAskToReplaceMoves
    }
    .menu.options invoke [tr OptionsSave]
  }
  ::recentFiles::save
  ::utils::history::Save
  destroy .
}

proc ::file::ExitFast {} {
  wm protocol . WM_DELETE_WINDOW {}
  if {$::optionsAutoSave} {
    # restore askToReplaceMoves if necessary
    if {[winfo exists .tacticsWin]} {
      ::tactics::restoreAskToReplaceMoves
    }
    .menu.options invoke [tr OptionsSave]
  }
  ::recentFiles::save
  destroy .
}

# ::file::New
#
#   Opens file-save dialog and creates a new database.

proc ::file::New {} {
  if {[sc_base count free] == 0} {
    tk_messageBox -title "Scid" -type ok -icon info \
        -message "Too many databases open; close one first"
    return
  }
  set ftype {
    { "Scid databases, EPD files" {".si960" ".epd"} }
    { "Scid databases" {".si960"} }
    { "EPD files" {".epd"} }
  }
  if {! [file isdirectory $::initialDir(base)] } {
    set ::initialDir(base) $::env(HOME)
  }
  set fName [tk_getSaveFile -initialdir $::initialDir(base) -filetypes $ftype -title "Create a Scid database"]
  if {$fName == {}} {
    return
  } elseif {[file extension $fName] == ".epd"} {
    if {![newEpdWin create $fName]} {
      return
    }
  } else {
    if {[file extension $fName] == ".si960"} {
      set fName [file rootname $fName]
    } 
    if {[catch {sc_base create $fName} result]} {
      tk_messageBox -icon warning -type ok -parent . \
          -title "Scid: error" -message "$result\nCan't create $fName"
      return
    }
    # set default icon
    catch {sc_base type [sc_base current] 1}
    set fName $fName.si960
  }
  set ::glistFlipped([sc_base current]) 0
  ::recentFiles::add $fName
  refreshWindows
  refreshSearchDBs
  updateBoard -pgn
}

### Main file open procedure. If no filename given, shows a file-open dialog

# This proc should return an error status... (so do it gradually)
# But it is used everywhere, and will take some time to fix

proc ::file::Open {{fName ""} {parent .} {update 1}} {
  if {[sc_base count free] == 0} {
    tk_messageBox -type ok -icon info -title "Scid" \
        -message "Too many databases are open; close one first" -parent $parent
    return
  }

  if {[sc_info gzip]} {
    set ftype {
      { {All Scid files} {.si960 .si4 .pgn .PGN .pgn.gz .epd .epd.gz} }
      { {Scid databases} {.si960 .si4} }
      { {PGN files} {.pgn .PGN .pgn.gz} }
      { {EPD files} {.epd .EPD .epd.gz} }
    }
  } else {
    set ftype {
      { {All Scid files} {.si960 .si4 .pgn .PGN .epd} }
      { {Scid databases} {.si960 .si4} }
      { {PGN files} {.pgn .PGN} }
      { {EPD files} {.epd .EPD} }
    }
  }
  if {$fName == ""} {
    if {! [file isdirectory $::file::finder::data(dir)] } {
      set ::file::finder::data(dir) $::env(HOME)
    }
    set fName [tk_getOpenFile -initialdir $::file::finder::data(dir) -filetypes $ftype \
                 -title "Open a Scid file" -parent $parent]
    if {$fName == ""} { return }
  }

  setTrialMode 0 0

  set ext [file extension $fName]
  if {$ext == "" || [file readable "$fName.si960"]} {
    set fName "$fName.si960"
    set ext .si960
  }

  if {$ext == ".sg960" || $ext == ".sn960"} {
    set fName "[file rootname $fName].si960"
    set ext .si960
  }

  if {$ext == ".si4" && [file exists $fName]} {
    ::file::Upgrade [file rootname $fName]
    return
  }

  set fName [fullname $fName]

  set slot [sc_base slot $fName]
  if {$slot != 0} {
    sc_base switch $slot
    refreshWindows
    updateBoard -pgn
    return
  }

  # The ::recentFiles::remove and ::recentFiles::add should probably be 
  # handled when "if {err == 0}"

  set err 0
  busyCursor .

  if {$ext == ".si960"} {
    set fName [file rootname $fName]
    if {[catch {openBase $fName} result]} {
      set err 1
      if {![string match {*doesn't exist*} $result]} {
        set result "$result\nCan't open $fName."
      }
      unbusyCursor .
      tk_messageBox -icon warning -type ok -parent $parent \
          -title "Scid: Error opening file" -message "$result"
      ::recentFiles::remove "$fName.si960"
      return -1
    } else {
      set ::initialDir(base) [file dirname $fName]
      ::recentFiles::add "$fName.si960"
    }
  } elseif {[string match "*.epd" [string tolower $fName]]} {
    # EPD file:
    if {[newEpdWin open $fName]} {
      ::recentFiles::add $fName
    } else {
      ::recentFiles::remove $fName
    }
  } else {
    if {![file exists $fName]} {
      set err 1
      ::recentFiles::remove $fName
      unbusyCursor .
      tk_messageBox -icon warning -type ok -parent $parent \
          -title "Scid: Error opening file" -message "File $fName doesn't exist."
    } else {
      if {$ext != ".pgn" && $ext != ".PGN"} {
	puts {Unknown file type, assuming PGN.}
      }
      ## note : .zip isn't supported by zlib. Only .pgn.gz is supported.

      set result "File $fName is not readable."
      if {(![file readable $fName])  || \
	    [catch {sc_base create $fName true} result]} {
	set err 1
	unbusyCursor .
	tk_messageBox -icon warning -type ok -parent $parent \
	    -title "Scid: Error opening file" -message $result
      } else {
	doPgnFileImport $fName "Opening [file tail $fName] read-only\n"
	sc_base type [sc_base current] 3
	::recentFiles::add $fName
	set ::initialDir(pgn) [file dirname $fName]
	set ::initialDir(file) [file tail $fName]
      }
    }
  }

  set ::glstart 1
  if {$err == 0} {
    catch {sc_game load auto}
    flipBoardForPlayerNames
    set ::glistFlipped([sc_base current]) $::flippedForPlayer
    if {[sc_game number] != 1 && [winfo exists .glistWin]} {
      ::windows::gamelist::showCurrent
    }
  }
  unbusyCursor .

  ### Hmmm - Check if tree/bestgames exists for this base, and update tab name
  set current [sc_base current]
  if {[winfo exists .treeWin$current]} {
    ::setTitle .treeWin$current "[tr Tree] \[[file tail [sc_base filename $current]]\]"
  }
  if {[winfo exists .treeBest$current]} {
    ::setTitle .treeBest$current "$::tr(TreeBestGames) \[[file tail [sc_base filename $current]]\]"
  }

  if {$update} {
    refreshWindows
    refreshSearchDBs
    ::bookmarks::AddCurrentGame
    updateBoard -pgn
  }
  # else bookmarks will call refreshWindows after correct game loaded
}

proc refreshWindows {} {
  ::windows::gamelist::Reload
  # done in updateBoard
  # ::tree::refresh
  ::windows::stats::Refresh
  ::tools::graphs::score::Refresh
  # too slow to refresh all the time
  # ::crosstab::Refresh
  ::plist::refresh
  ::tourney::refresh
  updateMenuStates
  updateTitle
  updateStatusBar
  refreshCustomFlags
}

### Update a few widgets with the Custom Flags
### (Only needs to be done after DB switch/open/close)

proc refreshCustomFlags {} {

  global maintFlag maintFlags maintFlaglist glistFlag

  ### maintenance window

  set w .maintWin
  if {[winfo exists $w]} {

      for {set i 1} { $i < 7} { incr i} {
	set desc [sc_game flag $i description]
	$w.title.cust.text$i configure -text $desc
      }

      ### Update the CustomFlag menubutton menus

      for {set idx 12} {$idx < 18} {incr idx} {
	set flag [ lindex $maintFlaglist $idx]
	set tmp [sc_game flag $flag description]
        if {$tmp == "" } {
          set tmp "Custom $flag"
        } else {
          set tmp "$tmp ($flag)"
        }
	.maintWin.mark.title.m entryconfigure $idx -label "$tmp"
      }

      ### Update the CustomFlag menubutton title
      # [Dont translate CustomFlag1 (etc)]

      if {$maintFlag ni {1 2 3 4 5 6}} {
	set tmp $::tr($maintFlags($maintFlag))
      } else  {
	set tmp [sc_game flag $maintFlag description]
	if {$tmp == "" } {
	  set tmp "Custom $maintFlag"
	} else {
	  set tmp "$tmp ($maintFlag)"
	}
      }
      set flagname $tmp
      # set flagname "$::tr($maintFlags($maintFlag)) [string tolower $::tr(Flag)]"
      $w.mark.title configure -text "$flagname"
      $w.title.mark configure -text "$flagname"
      $w.title.desc.text configure -text [sc_base description]
  }
}

proc refreshSearchDBs {} {
  ### header search
  #   (todo)
  set w .sh
  if {[winfo exists $w]} {
  }

  ### board search
  set w .sb
  if {[winfo exists $w]} {
      set ::listbases {}

      # populate the combobox
      for {set i 1} {$i <= [sc_base count total]} {incr i} {
	if {[sc_base inUse $i]} {
	  lappend ::listbases [file tail [sc_base filename $i]]
	}
      }
      $w.refdb.lb configure -values $::listbases
      $w.refdb.lb current 0

      checkState ::searchRefBase $w.refdb.lb
  }
}

# ::file::Upgrade
#
#   Upgrades an old (version 4) Scid database to version 960.
#
proc ::file::Upgrade {name} {
  if {[file readable "$name.si960"]} {
    set msg [string trim $::tr(ConfirmOpenNew)]
    set res [tk_messageBox -title "Scid" -type yesno -icon info -message $msg]
    if {$res == "no"} { return }
    ::file::Open "$name.si960"
    return
  }

  set msg [string trim $::tr(ConfirmUpgrade)]
  set res [tk_messageBox -title "Scid" -type yesno -icon info -message $msg]
  if {$res == "no"} { return }
  set err [catch {sc_base upgrade $name} res]
  if {$err} {
    tk_messageBox -title "Scid" -type ok -icon warning \
        -message "Unable to upgrade the database:\n$res"
    return
  } else  {
    # rename game and name files, delete old .si4
    file rename "$name.sg4"  "$name.sg960"
    file rename "$name.sn4"  "$name.sn960"
    file rename "$name.si4"  "$name.si960"
  }
  ::file::Open "$name.si960"
}

# openBase:
#    Opens a Scid database, showing a progress bar in a separate window
#    if the database is around 5 Mb or larger in size.
#   ::file::Open should be used if the base is not already in si960 format

proc openBase {name} {

  # This check should probably be done somewhere else
  # But fixing issue/all scenarios is very painful , so leave it here steven!
  if {![file exists $name.si960]} {
    return -code error "File \"$name.si960\" doesn't exist."
  }

  # Depending on how file is opened, windows can have "\" file separators
  # We don't want to open this twice somehow

  if {$::windowsOS && [string range $name 1 2] == ":\\"} {
    ::splash::add "Translating \"\\\" filename separators for $name"
    set name [string map {\\ /} $name]
  }

  set bsize 0

  ### wrong i think
  # set gfile "[file rootname $name].sg960" 
  set gfile "$name.sg960"

  if {! [catch {file size $gfile} err]} { set bsize $err }
  set showProgress 0
  if {$bsize > 5000000} { set showProgress 1 }
  if {$showProgress} {
    progressWindow "Scid" "$::tr(OpeningTheDatabase): [file tail $name]"
  }
  if {$::fastDBopen} {
    set err [catch {sc_base open -fast $name} result]
  } else {
    set err [catch {sc_base open $name} result]
  }
  if {$showProgress} { closeProgressWindow }
  if {$err} {
    return -code error $result
  } else {
    return $result
  }
}


#   Close the active base.

proc ::file::Close {{base -1}} {
  # Remember the current base
  set current [sc_base current]
  if {$base < 0} { set base $current }
  # Switch to the base which will be closed, and check for changes:
  sc_base switch $base
  if {[sc_base inUse]} {
    set confirm [::game::ConfirmDiscard]
    if {$confirm == 2} { return }
    if {$confirm == 0} {
      ::game::Save
    }
    setTrialMode 0
    sc_base close

    bind . <Control-Key-$base> {}

    ### Need these here, as otherwise a db "open base as tree" window won't close. S.A.
    ## (hmmm - this line is making us switch to empty base instead of clipbase when tree is closed and is locked)
    # but placing it before the (following) ::file::SwitchToBase commands seems to fix eveything.
    if {[winfo exists .treeWin$base]} { destroy .treeWin$base }

    # If closing current base - reset current game and switch to clipbase
    if { $current == $base } {
      setTrialMode 0 0
      sc_game new
      ::file::SwitchToBase clipbase
    } else {
      ::file::SwitchToBase $current
    }
    
    if {[winfo exists .emailWin]} { destroy .emailWin }
  } else {
    updateMenuStates
    updateStatusBar
    updateTitle
  }
  refreshSearchDBs
  set ::glistStart($current) 1
}


proc ::file::SwitchToBase {b} {
  setTrialMode 0 0
  sc_base switch $b

  # Close Email windows whenever a base is closed/switched:
  # if {[winfo exists .treeWin$b]} { destroy .treeWin$b }
  if {[winfo exists .emailWin]} { destroy .emailWin }

  updateBoard -pgn

  refreshWindows
}

proc ::file::SwitchToNextBase {{dir 1}} {
  set b [sc_base current]
  set clipbase [sc_info clipbase]

  ### Rotate between bases until we find an open one.
  ### Switching to unopen bases seems silly, but this is old and tested (?) code from SCID
  while {1} {
    incr b $dir
    if {$b > $clipbase} {
      set b 1
    } elseif {$b < 1} {
      set b $clipbase
    }
    sc_base switch $b
    if {[sc_base inUse]} { break }
  }
  SwitchToBase $b
}


proc ::file::openBaseAsTree { { fName "" } } {
  setTrialMode 0 0
  set oldbase [sc_base current]

  if {[sc_base count free] == 0} {
    tk_messageBox -type ok -icon info -title "Scid" \
        -message "Too many databases are open; close one first"
    return
  }

  if {$fName == ""} {
    if {[sc_info gzip]} {
      set ftype {
        { "Scid databases, PGN files" {".si960" ".si4" ".pgn" ".PGN" ".pgn.gz"} }
        { "Scid databases" {".si960" ".si4"} }
        { "PGN files" {".pgn" ".PGN" ".pgn.gz"} }
      }
    } else {
      set ftype {
        { "Scid databases, PGN files" {".si960" ".si4" ".pgn" ".PGN"} }
        { "Scid databases" {".si960" ".si4"} }
        { "PGN files" {".pgn" ".PGN"} }
      }
    }
    if {! [file isdirectory $::initialDir(base)] } {
      set ::initialDir(base) $::env(HOME)
    }
    set fName [tk_getOpenFile -initialdir $::initialDir(base) -filetypes $ftype -title "Open a Scid file"]
    if {$fName == ""} { return }

    set fName [fullname $fName]
    set ::initialDir(base) [file dirname $fName]
    set ::initialDir(file) [file tail $fName]
  }


  if {[file extension $fName] == ""} {
    set fName "$fName.si960"
  }

  if {[file extension $fName] == ".si4" && [file exists $fName]} {
    ::file::Upgrade [file rootname $fName]
    return
  }

  ### Check it is not already open
  # Name handling is a little clumsy, but is tested
  if {[file extension $fName] == ".si960"} {
    set rName [file rootname $fName]
  } else {
    set rName $fName
  }
  for {set i 1} {$i <= [sc_base count total]} {incr i} {
    if {$rName == [sc_base filename $i]} {
      ::tree::Open $i
      return
    }
  }

  set err 0
  busyCursor .
  if {[file extension $fName] == ".si960"} {
    set fName [file rootname $fName]
    if {[catch {openBase $fName} result]} {
      unbusyCursor .
      set err 1
      tk_messageBox -icon warning -type ok -parent . -title "Scid: Error opening file" -message $result
      return
    } else {
      set ::initialDir(base) [file dirname $fName]
      set ::initialDir(file) [file tail $fName]
      ::recentFiles::add "$fName.si960"
    }
  } else {
    # PGN file:
    set result "This file is not readable."
    if {(![file readable $fName])  || \
          [catch {sc_base create $fName true} result]} {
      unbusyCursor .
      set err 1
      tk_messageBox -icon warning -type ok -parent . -title "Scid: Error opening file" -message $result
      return
    } else {
      doPgnFileImport $fName "Opening [file tail $fName] read-only\n"
      sc_base type [sc_base current] 3
      set ::initialDir(pgn) [file dirname $fName]
      set ::initialDir(file) [file tail $fName]
      ::recentFiles::add $fName
    }
  }
  unbusyCursor .

  set current [sc_base current]
  set ::glistFlipped([sc_base current]) 0
  ::tree::Open
  set ::tree(locked$current) 1

  ::file::SwitchToBase $oldbase
  refreshSearchDBs
}

### Scidb's Drag and Drop by Gregor Cramer
#   ported by Stevenaaus

proc RegisterDropEvents {target} {
  if {$::macOS} {return}
  ::tkdnd::drop_target register $target DND_Files
  bind $target <<DropEnter>> { HandleDropEvent enter %W}
  bind $target <<DropLeave>> { HandleDropEvent leave %W}
  bind $target <<Drop>> { HandleDropEvent %D %W}
}

proc HandleDropEvent {action window} {
  variable Defaults

  switch $action {
    enter  {}
    leave  {}
    default {
      # It is important that HandleDropEvent is returning as fast as possible.
      after idle [namespace code [list OpenUri $window $action]]
    }
  }

  return copy
}

proc OpenUri {window uriFiles} {

  if {[string match .glistWin* $window]} {
	 raiseWin .glistWin
  } else {
	 raiseWin .
  }
  update idletasks

  set errorList {}
  set rejectList {}
  set databaseList {}
  set filelist $uriFiles

  foreach file $filelist {
    set uri [string trimright $file]
    set file $uri
    if {[string length $file]} {
      if {[string equal -length 5 $file "file:"]} {
        if {[string equal -length 17 $file "file://localhost/"]} {
          # correct implementation
          set file [string range $file 16 end]
        } elseif {[string equal -length 8 $file "file:///"]} {
          # no hostname, but three slashes - nearly correct
          set file [string range $file 7 end]
        } elseif {[string index $file 5] eq "/"} {
          # theoretically, the hostname should be the first, but no one implements it
          set file [string range $uri 5 end]
          for {set n 1} {$n < 5} {incr n} { if {[string index $file $n] eq "/"} { break } }
          set file [string range $uri [expr {$n - 1}] end]
          
          if {![file exists $file]} {
            # perhaps a correct implementation with hostname?
            set i [string first "/" $file 1]
            if {$i >= 0} {
              set f [string range $file $i end]
              if {[file exists $f]} {
                # it seems so
                set file $f
              }
            }
          }
        } else {
          # no slash after "file:" - what is that for a crappy program?
          set file [string range $file 5 end]
        }
      }

      set file [file normalize $file]
    }

    if {[file exists $file]} {
      lappend databaseList $file
    } else {
      puts "Dnd: no such file $file"
    }
  }

  foreach file $databaseList {
    ::file::Open $file
  }

  if {[llength $errorList]} {
    if {[string match file:* $uriFiles] && [llength $databaseList] == 0} {
      set message [tr CannotOpenUri]
      if {[llength $errorList] > 10} {
        append message \n\n [join [lrange $errorList 0 9] \n]
        append message \n...
      } else {
        append message \n\n [join $errorList \n]
      }
    } else {
      set message [tr InvalidUri]
    }
    tk_messageBox -icon warning -type ok -parent . -message $message
  }

  if {[llength $rejectList]} {
    set message [tr UriRejected]
    if {[llength $rejectList] > 10} {
      append message \n\n [join [lrange $rejectList 0 9] \n]
      append message \n...
    } else {
      append message \n\n [join $rejectList \n]
    }
    set detail [tr UriRejectedDetail]
    append detail " .sci, .si960, .si4, .cbh, .pgn, .pgn.gz, .zip"
    tk_messageBox -icon info -type ok -parent . -message $message -detail $detail
  }

  if {[llength $databaseList] + [llength $rejectList] + [llength $errorList] == 0} {
    set message [tr EmptyUriList]
    tk_messageBox -icon info -type ok -parent . -message $message
  }
}


proc bgerror {err} {
  if {$err eq "selection owner didn't respond"} {
    set parent [::tkdnd::get_drop_target]
    if {[llength $parent] == 0} { set parent . }
    after idle [list tk_messageBox \
      -icon error \
      -parent $parent \
      -message [tr SelectionOwnerDidntRespond] \
    ]
  } elseif {[string match {*selection doesn't exist*} $err]} {
    # ignore this stupid message. this message appears
    # in case of empty strings. this is not an error!
  } else {
    ::tk::dialog::error::bgerror $err
  }
}

### end of file.tcl

