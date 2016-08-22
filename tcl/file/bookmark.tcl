###
### bookmark.tcl
###

# Bookmarks, Game History and Recently-used files lists
# The Game History (RefreshMenuGame) makes heavy use of bookmarks, and for simplicity is included here

set bookmarks(data) {}
set bookmarks(subMenus) 0

# Read the bookmarks file if it exists:
catch {source [scidConfigFile bookmarks]}

namespace eval ::bookmarks {}

# ::bookmarks::PostMenu:
#   Posts the bookmarks toolbar menu.
# Currently unused. It's just too clumsy to post menus in the main board
# without an easy way to cancel them

proc ::bookmarks::PostMenu {} {
  tk_popup .main.tb.bkm.menu [winfo pointerx .] [winfo pointery .]
  if {[::bookmarks::CanAdd]} {
    .main.tb.bkm.menu activate 0
  }
}

### Updates all bookmarks and game history submenus

proc ::bookmarks::Refresh {} {
  foreach menu {.menu.file.bookmarks .main.tb.bkm.menu} {
    ::bookmarks::RefreshMenu $menu
  }
  ::bookmarks::RefreshMenuGame .menu.game
}

proc ::bookmarks::RefreshMenu {menu} {
  global bookmarks helpMessage

  ::bookmarks::DeleteChildren $menu
  $menu delete 0 end
  # $menu configure -disabledforeground [$menu cget -foreground]
  set numBookmarkEntries [llength $bookmarks(data)]

  if {[::bookmarks::CanAdd]} {
    $menu add command -label FileBookmarksAdd -command ::bookmarks::AddCurrent
  } else {
    $menu add command -label FileBookmarksAdd -command ::bookmarks::AddCurrent -state disabled
  }
  set helpMessage($menu,0) FileBookmarksAdd

  $menu add command -label FileBookmarksEdit -command ::bookmarks::Edit
  set helpMessage($menu,1) FileBookmarksEdit
  foreach tag {Add Edit} {
    configMenuText $menu FileBookmarks$tag FileBookmarks$tag $::language
  }
  if {$numBookmarkEntries == 0} { return }
  $menu add separator

  # Add each bookmark entry:
  set current $menu
  set inSubMenu 0
  foreach entry $bookmarks(data) {
    if {$entry == ""} { continue }
    set isfolder [::bookmarks::isfolder $entry]

    if {! $bookmarks(subMenus)} {
      if {$isfolder} {
        $current add command -label [::bookmarks::IndexText $entry]
      } elseif {!$isfolder} {
        $current add command -label [::bookmarks::IndexText $entry] \
          -command [list ::bookmarks::Go $entry]
      }
      continue
    }

    # Move out of submenu where necessary:
    if {$isfolder  &&  $inSubMenu} {
      set current [winfo parent $current]
    }

    if {$isfolder} {
      # Menu (folder) entry:
      set current [::bookmarks::NewSubMenu $current $entry]
      set inSubMenu 1
    } else {
      # Bookmark entry:
      $current add command -label [::bookmarks::Text $entry] \
        -command [list ::bookmarks::Go $entry]
    }
  }
}

### Update the Game History Menu

proc ::bookmarks::RefreshMenuGame {menu} {
  global bookmarks helpMessage

  # Remove the old game history
  $menu delete 21 end

  # Trim menus in case the limit has been reduced.
  set bookmarks(gamehistory) [lrange $bookmarks(gamehistory) 0 [expr {$::recentFiles(gamehistory) - 1}]]
  set numBookmarkEntries [llength $bookmarks(gamehistory)]

  if {$numBookmarkEntries == 0} { return }

  $menu add separator

  # Add each bookmark entry:
  foreach entry $bookmarks(gamehistory) {
    if {$entry != ""} {
      set text [::bookmarks::Text $entry]
      set comma [string first , $text]
      if {$comma > 0} {
        set text [string range $text 0 $comma-1]
      }
      # doesnt allow for spaces in name
      # set text [string range [lrange [::bookmarks::Text $entry] 0 3] 0 end-1]
      $menu add command -label $text -command [list ::bookmarks::Go $entry]
    }
  }
}

# ::bookmarks::CanAdd:
#   Returns 1 if the current game can be added as a bookmark.
#   It must be in an open database, not a PGN file, and not game number 0.
#
proc ::bookmarks::CanAdd {} {
  if {! [sc_base inUse]} { return 0 }
  if {[sc_game number] == 0} { return 0 }
  if {[sc_base current] == [sc_info clipbase]} { return 0 }
  if {[file pathtype [sc_base filename]] != "absolute"} { return 0 }
  foreach suffix {.pgn .PGN .pgn.gz} {
    if {[string match "*$suffix" [sc_base filename]]} { return 0 }
  }
  return 1
}

### Adds the current game to the bookmarks list.
## (variable 'folder' seems unused)

proc ::bookmarks::AddCurrent {{folder 0}} {
  global bookmarks
  if {! [sc_base inUse]} {
    return
  }
  set text [::bookmarks::New game]
  set len [llength $bookmarks(data)]
  set fcount 0
  for {set i 0} {$i < $len} {incr i} {
    if {[::bookmarks::isfolder [lindex $bookmarks(data) $i]]} {
      if {$fcount == $folder} { break }
      incr fcount
    }
  }
  set bookmarks(data) [linsert $bookmarks(data) $i $text]

  ::bookmarks::Save
  ::bookmarks::Refresh
}

### Add current game to game history

proc ::bookmarks::AddCurrentGame {} {
  global bookmarks
  if {! [sc_base inUse] || [sc_base current] == 9} {
    return
  }
  set text [::bookmarks::New game]
  # Don't remember ply for game history
  lset text 4 1
  set i [lsearch $bookmarks(gamehistory) $text]
  if {$i > -1} {
    set bookmarks(gamehistory) [lreplace $bookmarks(gamehistory) $i $i]
  }

  set bookmarks(gamehistory) [lrange [linsert $bookmarks(gamehistory) 0 $text] 0 $::recentFiles(gamehistory)-1]

  # ::bookmarks::Save
  ::bookmarks::Refresh
}

### Returns a bookmarks list entry for the current game or a new folder.

proc ::bookmarks::New {type} {
  if {$type == "folder"} { return [list "f" "new folder"] }

  ### Bookmark format
  # database: white, black, result, site , ....

  # I changed this text formatting around. Is'ok ? &&& S.A
  set text "[file tail [sc_base filename]]:  "
  append text "[::utils::string::Surname [sc_game info white]] - "
  append text "[::utils::string::Surname [sc_game info black]], "
  append text "[sc_game info result],  [::utils::string::CityName [sc_game info site]] "
  set round [sc_game info round]
  if {$round != ""  &&  $round != "?"} { append text "($round) " }
  append text "[sc_game info year]"
  set list [list "g" $text]
  sc_game pgn
  lappend list [sc_base filename] [sc_game number] [sc_pos pgnOffset]
  lappend list [sc_game info white] [sc_game info black]
  lappend list [sc_game info year] [sc_game info site]
  lappend list [sc_game info round] [sc_game info result]
  return $list
}

### Load selected bookmark

proc ::bookmarks::Go {entry} {
  if {[::bookmarks::isfolder $entry]} { return }
  set fname [lindex $entry 2]
  set gnum [lindex $entry 3]
  set ply [lindex $entry 4]

  # Is the base already open ?
  set slot [sc_base slot $fname]
  if {$slot != 0} {
    sc_base switch $slot
  } else {
    busyCursor .
    ### updateBoard -pgn gets called three times, so try passing "update = 0" to the first two.
    # ::file::Open, ::game::Load, updateBoard -pgn

    if {[catch {set success [::file::Open $fname . 0]} result]} {
      unbusyCursor .
      tk_messageBox -icon warning -type ok -parent . \
        -title "Scid" -message "Unable to load the database:\n$fname\n\n$result"
      return
    }
    unbusyCursor .
    if {$success == -1} {
      return
    }
    ::recentFiles::add "[file rootname $fname].si4"
  }
  # Find and load the best database game matching the bookmark:
  set white [lindex $entry 5]
  set black [lindex $entry 6]
  set year  [lindex $entry 7]
  set site  [lindex $entry 8]
  set round [lindex $entry 9]
  set result [lindex $entry 10]

  set best [sc_game find $gnum $white $black $site $round $year $result]

  # don't reload current game if not necessary
  if {[sc_game number] != $best} {
    if {[catch {set success [::game::Load $best 0]}]} {
      tk_messageBox -icon warning -type ok -parent . -title "Scid" -message "Unable to load game number: $best"
      return
    } else {
      if {$success == -1} {
	return
      }
      sc_move pgn $ply
      flipBoardForPlayerNames

      # show this game in gamelist
      set ::glistStart([sc_base current]) $best
    }
  } else {
    sc_move pgn $ply
    set ::glistStart([sc_base current]) $best

    refreshWindows
  }
  refreshSearchDBs
  ::bookmarks::AddCurrentGame
  updateBoard -pgn
}

### Deletes all submenus of a bookmark menu.

proc ::bookmarks::DeleteChildren {w} {
  foreach child [winfo children $w] {
    ::bookmarks::DeleteChildren $child
    destroy $child
  }
}

# ::bookmarks::NewSubMenu
#
#   Creates a new bookmark submenu.
#
proc ::bookmarks::NewSubMenu {w entry} {
  set i 1
  while {[winfo exists $w.m$i]} { incr i }
  $w add cascade -label [::bookmarks::Text $entry] -menu $w.m$i
  menu $w.m$i -tearoff 0
  return $w.m$i
}

# Globals used for bookmark editing:
#
set bookmarks(edit) ""
set bookmarks(ismenu) 0

# Button images for bookmark editing:

image create photo bookmark_up -data {
R0lGODdhGAAYAMIAALu7uwAAAMzM/5mZ/2ZmzP///zMzZgAAACwAAAAAGAAYAAADRgi63P4w
ykmrvTirEPQKwtBpYChmpUmMVVAI5kCsbfGqMy25dpzPLAfvNij+gBCDUokjLJUUQ9OAkRpn
1Mvz6el6v+AwOAEAOw==
}

image create photo bookmark_down -data {
R0lGODdhGAAYAMIAALu7uzMzZv///8zM/5mZ/2ZmzAAAAAAAACwAAAAAGAAYAAADSQi63P4w
ykmrvRiHzbcWw0AQRfCFY0l1ATiSLGQINCiSRZ4b0UyjOB1PMgvddIXhxABEKinM1C5jkD4v
1WSGYbhuv+CweExeJAAAOw==
}

###  Bookmark Editing toplevel

proc ::bookmarks::Edit {} {
  global bookmarks

  set w .bmedit
  if {[winfo exists $w]} {
    raiseWin $w
    return
  }
  set bookmarks(old) $bookmarks(data)

  toplevel $w
  wm title $w "[tr FileBookmarksEdit]"
  setWinSize $w
  wm withdraw $w
  # wm transient $w .

  bind $w <F1> {helpWindow Bookmarks}
  entry $w.e -width 60 -foreground black  \
    -textvariable bookmarks(edit) -font font_Small -exportselection 0
  # bind $w.e <FocusIn>  {.bmedit.e configure -background lightYellow}
  # bind $w.e <FocusOut> {.bmedit.e configure -background white}

  trace variable bookmarks(edit) w ::bookmarks::EditRefresh
  pack [frame $w.b2] -side bottom -fill x -pady 2
  pack [frame $w.b1] -side bottom -fill x -pady 2
  pack $w.e -side bottom -fill x
  pack [frame $w.f] -side top -fill both -expand 1
  listbox $w.f.list -height 10 -yscrollcommand "$w.f.ybar set" \
    -exportselection 0 -font font_Small -setgrid 1
  scrollbar $w.f.ybar -takefocus 0 -command "$w.f.list yview"
  bind $w.f.list <<ListboxSelect>>  ::bookmarks::EditSelect
  bind $w.f.list <Double-Button-1>  {
    ::bookmarks::Go [lindex $bookmarks(data) [lindex [.bmedit.f.list curselection] 0]]
    if {[::bookmarks::CanAdd]} { .bmedit.b1.newGame configure -state normal }
  }
  bind $w.f.list <Up> "$w.b1.up invoke ; break"
  bind $w.f.list <Down> "$w.b1.down invoke ; break"
  bind $w.f.list <Delete> ::bookmarks::EditDelete
  pack $w.f.ybar -side right -fill y
  pack $w.f.list -side left -fill both -expand yes
  foreach entry $bookmarks(data) {
    $w.f.list insert end [::bookmarks::IndexText $entry]
  }
  dialogbutton $w.b1.newFolder -text $::tr(NewSubmenu) \
    -command {::bookmarks::EditNew folder}
  dialogbutton $w.b1.newGame -text [tr FileBookmarksAdd] \
    -command {::bookmarks::EditNew game}
  if {! [::bookmarks::CanAdd]} { $w.b1.newGame configure -state disabled }

  dialogbutton $w.b1.delete -text $::tr(Delete)  -command ::bookmarks::EditDelete
  button $w.b1.up -image bookmark_up -command {::bookmarks::EditMove up} -borderwidth 1
  button $w.b1.down -image bookmark_down -command {::bookmarks::EditMove down}

  checkbutton $w.b2.displaytype -text {Nest Folders} -var bookmarks(subMenus) -command ::bookmarks::Refresh

  dialogbutton $w.b2.ok     -text OK -command ::bookmarks::EditDone
  dialogbutton $w.b2.help   -text $::tr(Help) -command {helpWindow Bookmarks}
  dialogbutton $w.b2.cancel -text $::tr(Cancel) -command {
    set bookmarks(data) $bookmarks(old)
    catch {grab release .bmedit}
    destroy .bmedit
  }

  pack $w.b1.up $w.b1.down $w.b1.newGame $w.b1.newFolder $w.b1.delete -side left -padx 2 -pady 2
  # pack $w.b1.up $w.b1.down -side left -padx 2 -pady 2
  pack $w.b2.displaytype -side left
  pack $w.b2.cancel $w.b2.help $w.b2.ok -side right -padx 2 -pady 2
  set bookmarks(edit) ""

  update idletasks
  placeWinOverParent $w .
  bind $w <Configure> "recordWinSize $w"
  wm deiconify $w
  update
}

# ::bookmarks::EditDone
#
#    Updates the bookmarks and closes the bookmark editing window.
#
proc ::bookmarks::EditDone {} {
  # catch {grab release .bmedit}
  destroy .bmedit
  ::bookmarks::Save
  ::bookmarks::Refresh
}

# ::bookmarks::EditRefresh
#
#   Updates the bookmarks whenever the contents of the bookmark
#   editing entry box are changed.
#
proc ::bookmarks::EditRefresh {args} {
  global bookmarks
  set list .bmedit.f.list
  set sel [lindex [$list curselection] 0]
  if {$sel == ""} { return }
  set text $bookmarks(edit)
  set e [lindex $bookmarks(data) $sel]
  set e [::bookmarks::SetText $e $text]
  set text [::bookmarks::IndexText $e]
  set bookmarks(data) [lreplace $bookmarks(data) $sel $sel $e]
  $list insert $sel $text
  $list delete [expr {$sel + 1} ]
  $list selection clear 0 end
  $list selection set $sel
}

# ::bookmarks::EditSelect
#
#   Sets the bookmark editing entry box when a bookmark is selected.
#
proc ::bookmarks::EditSelect {{sel ""}} {
  global bookmarks

  set list .bmedit.f.list
  set sel [lindex [$list curselection] 0]
  if {$sel == ""} {
    .bmedit.e delete 0 end
    return
  }
  if {$sel >= [llength $bookmarks(data)]} {
    $list selection clear 0 end
    set bookmarks(edit) ""
    return
  }
  set e [lindex $bookmarks(data) $sel]
  set bookmarks(ismenu) [::bookmarks::isfolder $e]
  set bookmarks(edit) [::bookmarks::Text $e]
}

# ::bookmarks::isfolder:
#   Returns 1 if this bookmark entry is a folder (submenu).
#
proc ::bookmarks::isfolder {entry} {
  if {[lindex $entry 0] == "f"} { return 1 }
  return 0
}

# ::bookmarks::Text:
#   Returns the entry text of a bookmark.
#
proc ::bookmarks::Text {entry} {
  return [lindex $entry 1]
}

proc ::bookmarks::IndexText {entry} {
  set text ""
  if {[lindex $entry 0] == "f"} {
    append text "\[[lindex $entry 1]\]"
  } else {
    append text "    [lindex $entry 1]"
  }
  return $text
}

proc ::bookmarks::SetText {entry text} {
  return [lreplace $entry 1 1 $text]
}

# ::bookmarks::EditMove
#
#   Moves the selected bookmark "up" or "down" one place.
#
proc ::bookmarks::EditMove {{dir "up"}} {
  global bookmarks
  set w .bmedit
  set list $w.f.list
  set sel [lindex [$list curselection] 0]
  if {$sel == ""} { return }
  set e [lindex $bookmarks(data) $sel]
  set text [::bookmarks::IndexText $e]
  set newsel $sel
  if {$dir == "up"} {
    incr newsel -1
    if {$newsel < 0} { return }
  } else {
    incr newsel
    if {$newsel >= [$list index end]} { return }
  }
  set bookmarks(data) [lreplace $bookmarks(data) $sel $sel]
  set bookmarks(data) [linsert $bookmarks(data) $newsel $e]
  $list selection clear 0 end
  $list delete $sel
  $list insert $newsel $text
  $list selection set $newsel
  $list see $newsel
}

# ::bookmarks::EditDelete
#
#   Deletes the selected bookmark.
#
proc ::bookmarks::EditDelete {} {
  global bookmarks
  set w .bmedit
  set list $w.f.list
  set sel [lindex [$list curselection] 0]
  if {$sel == ""} { return }
  set bookmarks(data) [lreplace $bookmarks(data) $sel $sel]
  $list selection clear 0 end
  $list delete $sel
  set bookmarks(edit) ""
  focus .bmedit.f.list
}

# ::bookmarks::EditNew
#
#   Inserts a new entry ("folder" for a submenu or "game" for the
#   current game) after the selected bookmark.
#
proc ::bookmarks::EditNew {{type "folder"}} {
  global bookmarks
  set w .bmedit
  set list $w.f.list
  if {[string index $type 0] == "f"} {
    set entry [::bookmarks::New folder]
  } else {
    set entry [::bookmarks::New game]
  }
  set sel [lindex [$list curselection] 0]
  if {$sel == ""} {
    lappend bookmarks(data) $entry
    set sel [$list index end]
    $list insert end [::bookmarks::IndexText $entry]
    $list selection clear 0 end
    $list selection set $sel
    $list see $sel
    ::bookmarks::EditSelect
    return
  }
  incr sel
  set bookmarks(data) [linsert $bookmarks(data) $sel $entry]
  $list insert $sel [::bookmarks::IndexText $entry]
  $list selection clear 0 end
  $list selection set $sel
  $list see $sel
  focus .bmedit.e
  ::bookmarks::EditSelect
}

### Saves the bookmarks file, reporting any error in a message box if reportError is true.

proc ::bookmarks::Save {{reportError 0}} {
  global bookmarks
  set f {}
  set filename [scidConfigFile bookmarks]
  if  {[catch {open $filename w} f]} {
    if {$reportError} {
      tk_messageBox -title "Scid" -type ok -icon warning \
        -message "Unable to write bookmarks file: $filename\n$f"
    }
    return
  }
  puts $f "# $::scidName bookmarks file\n"
  foreach i {subMenus data} {
    puts $f "set bookmarks($i) [list [set bookmarks($i)]]"
    puts $f ""
  }
  close $f
}


# End of file: bookmark.tcl
