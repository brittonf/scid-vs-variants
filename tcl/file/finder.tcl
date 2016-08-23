
####################
# File finder window

set ::file::finder::data(stop) 0

### Open/Close the finder

proc ::file::finder::Open {} {
  set w .finder

  if {[winfo exists $w]} {
    destroy $w
    return
  }

  toplevel $w
  wm title $w "$::tr(FileFinder)"
  bind $w <F1> {helpWindow Finder}
  setWinLocation $w
  setWinSize $w
  bind $w <Configure> "recordWinSize $w"

  menu $w.menu
  $w configure -menu $w.menu

  $w.menu add cascade -label FinderFile -menu $w.menu.file
  menu $w.menu.file
  $w.menu.file add command -label {Open Directory} -command ::file::finder::OpenDIR
  $w.menu.file add command -label FinderFileClose -command "destroy $w"

  bind $w <Control-o> ::file::finder::OpenDIR

  $w.menu add cascade -label FinderSort -menu $w.menu.sort
  menu $w.menu.sort
  foreach {name value} {Type type Size size Mod mod Filename name Path path} {
    $w.menu.sort add radiobutton -label FinderSort$name \
        -variable ::file::finder::data(sort) -value $value \
        -command {::file::finder::Refresh -fast}
  }

  $w.menu add cascade -label FinderTypes -menu $w.menu.types
  menu $w.menu.types -tearoff 1

  # I'd like to change these to {si4 si3 pgn epd}, but it means changing lots of stuff,
  # including the language FinderTypes entries

  foreach type {Scid Old PGN EPD} {
    $w.menu.types add checkbutton -label FinderTypes$type \
        -variable ::file::finder::data($type) -onvalue 1 -offvalue 0 \
        -command ::file::finder::Refresh
  }

  $w.menu add cascade -label FinderHelp -menu $w.menu.help
  menu $w.menu.help
  $w.menu.help add command -label FinderHelpFinder \
      -accelerator F1 -command {helpWindow Finder}
  $w.menu.help add command -label FinderHelpIndex -command {helpWindow Index}

  pack [frame $w.d -relief flat] -side top -fill x
  label $w.d.label -font font_Bold ;# given a text value below
  pack $w.d.label 

  frame $w.t -relief flat
  frame $w.b
  text $w.t.text -width 70 -height 25 -font font_Small -wrap none \
      -fg black  -yscrollcommand "$w.t.ybar set" -setgrid 1 \
      -cursor top_left_arrow
  scrollbar $w.t.ybar -command "$w.t.text yview" -width 12
  $w.t.text tag configure Up -foreground brown
  $w.t.text tag configure Dir -foreground steelblue
  $w.t.text tag configure Vol -foreground gray25
  $w.t.text tag configure PGN -foreground blue
  $w.t.text tag configure Scid -foreground skyblue
  $w.t.text tag configure Old -foreground black
  $w.t.text tag configure EPD -foreground orange
  $w.t.text tag configure bold -font font_SmallBold
  $w.t.text tag configure center -justify center
  set xwidth [font measure [$w.t.text cget -font] "x"]
  set tablist {}
  #                      name   size   type   date   path
  foreach {tab justify} {       29 r   31 l   50 r   55 l} {
    set tabwidth [expr {$xwidth * $tab} ]
    lappend tablist $tabwidth $justify
  }
  $w.t.text configure -tabs $tablist
  bindMouseWheel $w $w.t.text

  checkbutton $w.b.sub -text [tr FinderFileSubdirs] \
      -variable ::file::finder::data(recurse) -onvalue 1 -offvalue 0 \
      -command ::file::finder::Refresh
  # the stop button seems broke S.A.
  dialogbutton $w.b.stop -textvar ::tr(Stop) -command {set finder(stop) 1 }
  dialogbutton $w.b.help -textvar ::tr(Help) -command {helpWindow Finder}
  dialogbutton $w.b.close -textvar ::tr(Close) -command "destroy $w"
  bind $w <Escape>        "$w.b.close invoke"
  bind $w <Control-slash> "$w.b.close invoke"

  # Bind left button to close ctxt menu:
  bind $w <ButtonPress-1> {
    if {[winfo exists .finder.t.text.ctxtMenu]} {
      destroy .finder.t.text.ctxtMenu
      focus .finder
    }
  }
  pack $w.b -side bottom -fill x
  packbuttons right $w.b.close $w.b.help $w.b.stop
  packbuttons left $w.b.sub
  pack $w.t -side top -fill both -expand yes
  pack $w.t.ybar -side right -fill y
  pack $w.t.text -side left -fill both -expand yes
  ::file::finder::ConfigMenus
  ::file::finder::Refresh
}

proc ::file::finder::Refresh {{newdir ""}} {
  variable data
  set w .finder
  if {! [winfo exists $w]} { return }
  set t $w.t.text

  # When parameter is "-fast", just re-sort the existing data:
  set fastmode 0
  if {$newdir == "-fast"} {
    set fastmode 1
    set newdir ""
  }
  if {$newdir == ".."} { set newdir [file dirname $data(dir)] }
  if {$newdir != ""} { set data(dir) $newdir }

  busyCursor .
  set data(stop) 0
  $w.b.close configure -state disabled
  $w.b.help configure -state disabled
  $w.b.sub configure -state disabled
  $w.b.stop configure -state normal
  catch {grab $w.b.stop}
  $t configure -state normal
  update

  if {$fastmode} {
    set flist $data(flist)
  } else {
    set flist [::file::finder::GetFiles $data(dir)]
    set data(flist) $flist
  }

  switch $data(sort) {
    "none" {}
    "type" { set flist [lsort -decreasing -index 1 $flist] }
    "size" { set flist [lsort -integer -decreasing -index 0 $flist] }
    "name" { set flist [lsort -dict -index 2 $flist] }
    "path" { set flist [lsort -dict -index 3 $flist] }
    "mod"  { set flist [lsort -integer -decreasing -index 4 $flist] }
  }

  set hc $::rowcolor
  $t delete 1.0 end
  set dcount 0
  # $t insert end [string toupper "$::tr(FinderDirs)\n"] {center bold}
  set dlist {}

  # Insert drive letters, on Windows:
  if {$::windowsOS} {
    foreach drive [lsort -dictionary [file volume]] {
      $t insert end " $drive " [list Vol v$drive]
      $t insert end "    "
      $t tag bind v$drive <1> [list ::file::finder::Refresh $drive]
      $t tag bind v$drive <Any-Enter> \
          "$t tag configure [list v$drive] -background $hc"
      $t tag bind v$drive <Any-Leave> \
          "$t tag configure [list v$drive] -background {}"
    }
    $t insert end "\n"
  }

  # Insert parent directory entry:
  lappend dlist ..

  # Generate other directory entries:
  set dirlist [lsort -dictionary [glob -nocomplain [file join $data(dir) *]]]
  foreach dir $dirlist {
    # Don't show directories matching "*_files" (Personal hack for S.A.)
    if {[file isdir $dir] && ![string match {*_files} $dir]} {
      lappend dlist $dir
    }
  }
  foreach dir $dlist {
    if {$dcount != 0} {
      if {$dcount % 3 == 0} {
	$t insert end "\n"
      } else {
	$t insert end "\t\t"
      }
    }
    incr dcount
    if {$dir == ".."} {
      set d ..
      $t insert end " .. ($::tr(FinderUpDir)) " [list Up d..]
    } else {
      set d [file tail $dir]
      $t insert end " $d " [list Dir d$d]
    }
    $t tag bind d$d <1> [list ::file::finder::Refresh $dir]
    $t tag bind d$d <Any-Enter> \
        "$t tag configure [list d$d] -background $hc"
    $t tag bind d$d <Any-Leave> \
        "$t tag configure [list d$d] -background {}"
  }

  # Add File section headings:
  $t insert end "\n\n"
  if {[llength $flist] != 0} {
    foreach i {Name Size Type Mod Path} v {name size type mod path} {
      $t tag configure s$i -font font_SmallBold
      $t tag bind s$i <1> "set ::file::finder::data(sort) $v; ::file::finder::Refresh -fast"
      $t tag bind s$i <Any-Enter> "$t tag config s$i -underline 1"
      $t tag bind s$i <Any-Leave> "$t tag config s$i -underline 0"
    }
    # $t insert end [string toupper "$::tr(FinderFiles)\n"] {center bold}
    $t insert end "[tr FinderSortName]" sName
    $t insert end "\t"
    $t insert end "[tr FinderSortSize]" sSize
    $t insert end "\t"
    $t insert end "[tr FinderSortType]" sType
    $t insert end "\t"
    $t insert end "[tr FinderSortMod]" sMod
    $t insert end "\t"
    $t insert end "[tr FinderSortPath]" sPath
    $t insert end "\n"
  }

  # Add each file:
  foreach i $flist {
    set size [lindex $i 0]
    set type [lindex $i 1]
    set fname [string range [lindex $i 2] 0 15] ; # limit to 16 chars S.A.
    set path [lindex $i 3]
    # If case path has spaces, they break tag bindings, so use this tag
    set pathtag [string map {{ } _} $path]

    set mtime [lindex $i 4]
    set est [lindex $i 5]
    $t insert end "\n "
    $t insert end "$fname\t" f$pathtag
    set esize ""
    if {$est} { set esize "~" }
    append esize [::utils::thousands $size]
    $t insert end "$esize\t" f$pathtag
    $t insert end $type [list $type f$pathtag]
    $t insert end "\t[clock format $mtime -format {%d-%m-%Y}]" f$pathtag
    $t insert end "\t" f$pathtag
    set dir [file dirname $path]
    set tail [file tail $path]
    if {$dir == "."} {
      set fullpath $data(dir)/$tail
    } else  {
      set fullpath $data(dir)/$dir/$tail
    }

    $t tag bind f$pathtag <Double-Button-1> "::file::Open [list $fullpath] $w"
    # Bind right button to popup a contextual menu:
    $t tag bind f$pathtag <ButtonPress-3> "::file::finder::contextMenu .finder.t.text [list $fullpath] %X %Y"

    $t tag bind f$pathtag <Any-Enter> "$t tag configure [list f$pathtag] -background $hc"
    $t tag bind f$pathtag <Any-Leave> "$t tag configure [list f$pathtag] -background {}"
    if {$dir == "."} {
      set fullpath "$data(dir)/$tail"
    } else {
      $t tag configure p$path -foreground darkblue
      $t insert end "$dir/" [list p$path f$pathtag]
    }
    $t tag configure t$path -foreground blue
    $t insert end $tail [list t$path f$pathtag]
  }
  $t configure -state disabled

  $w.d.label configure -text $data(dir)

  catch {grab release $w.b.stop}
  $w.b.stop configure -state disabled
  $w.b.help configure -state normal
  $w.b.close configure -state normal
  $w.b.sub configure -state normal
  unbusyCursor .

}
################################################################################
#
################################################################################
proc ::file::finder::contextMenu {win fullPath x y} {

  update idletasks

  set mctxt $win.ctxtMenu

  if { [winfo exists $mctxt] } { destroy $mctxt }

  menu $mctxt
  # context menus
  $mctxt add command -label [tr FinderCtxOpen ] -command "::file::Open [list $fullPath] .finder"
  $mctxt add command -label [tr FinderCtxBackup ] -command "::file::finder::backup [list $fullPath]"
  $mctxt add command -label [tr FinderCtxCopy ] -command "::file::finder::copy [list $fullPath]"
  $mctxt add command -label [tr FinderCtxMove ] -command "::file::finder::move [list $fullPath]"
  $mctxt add command -label Rename              -command "::file::finder::rename [list $fullPath]"
  $mctxt add separator
  $mctxt add command -label [tr FinderCtxDelete ] -command "::file::finder::delete [list $fullPath]"

  tk_popup $mctxt $x $y

}
################################################################################
# will backup a base in the form name-date.ext
################################################################################
proc ::file::finder::backup { f } {
  set r [file rootname $f]
  set d [clock format [clock seconds] -format "-%Y.%m.%d-%H%M" ]
  set ext [string tolower [file extension $f]]
  if { $ext == ".si960" } {
    if { [catch { file copy "$r.sg960" "$r$d.sg960" ; file copy "$r.sn960" "$r$d.sn960" } err ] } {
      tk_messageBox -title Scid -icon error -type ok -message "File copy error $err"
      return
    }
    catch { file copy "$r.stc" "$r$d.stc" }
  }

  if { [catch { file copy "$r[file extension $f]" "$r$d[file extension $f]" } err ] } {
    tk_messageBox -title Scid -icon error -type ok -message "File copy error $err"
    return
  }

  ::file::finder::Refresh
}
################################################################################
#
################################################################################
proc ::file::finder::copy { f } {
  if {[sc_base slot $f] != 0} {
    tk_messageBox -title Scid -icon error -type ok -message "Close base first" -parent .finder
    return
  }
  set dir [tk_chooseDirectory -initialdir [file dirname $f] -parent .finder]
  if {$dir != ""} {
    if { [string tolower [file extension $f]] == ".si960" } {
      if { [catch { file copy "[file rootname $f].sg960" "[file rootname $f].sn960" $dir } err ] } {
        tk_messageBox -title Scid -icon error -type ok -message "File copy error $err" -parent .finder
        return
      }
      
      catch { file copy "[file rootname $f].stc" $dir }
    }

    if { [catch { file copy $f $dir } err ] } {
      tk_messageBox -title Scid -icon error -type ok -message "File copy error $err" -parent .finder
      return
    }

  }
}
################################################################################
#
################################################################################
proc ::file::finder::move { f } {
  if {[sc_base slot $f] != 0} {
    tk_messageBox -title Scid -icon error -type ok -message "Close base first" -parent .finder
    return
  }
  set dir [tk_chooseDirectory -initialdir [file dirname $f] -parent .finder ]
  if {$dir != ""} {
    if { [string tolower [file extension $f]] == ".si960" } {
      
      if { [catch { file rename "[file rootname $f].sg960" "[file rootname $f].sn960" $dir } err ] } {
        tk_messageBox -title Scid -icon error -type ok -message "File rename error $err" -parent .finder
        return
      }
      catch { file rename "[file rootname $f].stc" $dir }
    }

    if { [catch { file rename $f $dir } err ] } {
      tk_messageBox -title Scid -icon error -type ok -message "File rename error $err" -parent .finder
      return
    }
  }
  ::file::finder::Refresh
}

proc ::file::finder::rename { f } {
  if {[sc_base slot $f] != 0} {
    tk_messageBox -title Scid -icon error -type ok -message "Close base first" -parent .finder
    return
  }

  set newname [::file::finder::getname]
  set r [file rootname $f]
  set ext [string tolower [file extension $f]]

  if {$newname == {}} {
    return
  }


  # remove leading directories
  set newname [file tail $newname]

  # remove trailing .extension if the same
  if {[string tolower [file extension $newname]] == [string tolower [file extension $f]]} {
    set newname [file rootname $newname]
  }

  set n "[file dirname $f]/$newname"

  if { [string tolower [file extension $f]] == {.si960} } {
    if {[file exists "$newname.si960"]} {
      tk_messageBox -title Scid -icon error -type ok -message "$newname.si960 already exists" -parent .finder
      return
    }

    if { [catch {
	    file rename "$r.sg960" "$n.sg960"
	    file rename "$r.sn960" "$n.sn960"
	 } err ] } {
      tk_messageBox -title Scid -icon error -type ok -message "File copy error $err"
      return
    }
    catch { file rename "$r.stc" "$n.stc" }
  }
  if { [catch {
          file rename "$r[file extension $f]" "$n[file extension $f]"
       } err ] } {
    tk_messageBox -title Scid -icon error -type ok -message "File copy error $err"
    return
  }

  ::file::finder::Refresh
}

proc ::file::finder::getname {} {
  set w .rename
  toplevel $w
  wm title $w "Scid: Rename"
  grab $w

  label $w.label -text {New name}
  pack $w.label -side top -pady 5 -padx 5

  entry $w.entry -width 16 -borderwidth 0
  bind $w.entry <Escape> { .rename.buttons.cancel invoke }
  bind $w.entry <Return> { .rename.buttons.ok invoke }
  pack $w.entry -side top -pady 5

  set b [frame $w.buttons]
  pack $b -side top -fill x
  dialogbutton $b.ok -text OK -command {
    grab release .rename
    focus .main
    set ::tmp [.rename.entry get]
    destroy .rename
  }
  dialogbutton $b.cancel -text $::tr(Cancel) -command {
    focus .main
    grab release .rename
    set ::tmp {}
    destroy .rename
    focus .main
  }
  packbuttons right $b.cancel $b.ok
  placeWinOverParent $w .finder
  focus $w.entry
  tkwait window $w
  return "$::tmp"
}

################################################################################
#
################################################################################

proc ::file::finder::delete { f } {
  if {[sc_base slot $f] != 0} {
    tk_messageBox -title Scid -icon error -type ok -message "Close base first" -parent .finder
    return
  }
  set answer [tk_messageBox -title Scid -icon warning -type yesno -parent .finder \
                -message "Do you want to permanently delete $f ?"]
  if {$answer == "yes"} {
    if { [string tolower [file extension $f]] == ".si960" } {
      file delete "[file rootname $f].sg960" "[file rootname $f].sn960" "[file rootname $f].stc"
    }
    file delete $f
  }
  ::file::finder::Refresh
}

################################################################################
#
################################################################################
proc ::file::finder::ConfigMenus {{lang ""}} {
  if {! [winfo exists .finder]} { return }
  if {$lang == ""} { set lang $::language }
  set m .finder.menu
  foreach idx {0 1 2 3} tag {File Sort Types Help} {
    configMenuText $m $idx Finder$tag $lang
  }
  foreach idx {1} tag {Close} {
    configMenuText $m.file $idx FinderFile$tag $lang
  }
  foreach idx {0 1 2 3 4} tag {Type Size Mod Name Path} {
    configMenuText $m.sort $idx FinderSort$tag $lang
  }
  foreach idx {1 2 3 4} tag {Scid Old PGN EPD} {
    configMenuText $m.types $idx FinderTypes$tag $lang
  }
  foreach idx {0 1} tag {Finder Index} {
    configMenuText $m.help $idx FinderHelp$tag $lang
  }
}

proc ::file::finder::GetFiles {dir {len -1}} {
  variable data
  set dlist {}
  set flist {}
  if {$len < 0} {
    set len [expr {[string length $dir] + 1} ]
  }

  foreach f [glob -nocomplain [file join $dir *]] {
    if {[file isdir $f]} {
      lappend dlist $f
    } elseif {[file isfile $f]} {
      set ext [string tolower [file extension $f]]
      if {[catch {set mtime [file mtime $f]}]} { set mtime 0 }
      set showFile 0
      set rootname [file rootname $f]
      set type PGN
      if {$ext == ".si960"} {
        set showFile 1
        set type Scid
      } elseif {$ext == ".si4"} {
        set showFile 1
        set type Old
      } elseif {$ext == ".epd"} {
        set type EPD
        set showFile 1
      } elseif {$ext == ".pgn"} {
        set showFile 1
      } elseif {$ext == ".gz"} {
        set rootname [file rootname $rootname]
        if {[regexp {\.epd\.gz} $f]} { set showFile 1; set type EPD }
        if {[regexp {\.pgn\.gz} $f]} { set showFile 1 }
      }
      if {$showFile  &&  [info exists data($type)]  &&  $data($type)} {
        set path [string range $f $len end]
        set est 0
        if {[catch {set size [sc_info fsize $f]}]} {
          # Could not determine file size, probably a PGN or EPD file
          # that the user does not have permission to read.
          set est 1
          set size 0
        }
        if {$size < 0} {
          set est 1
          set size [expr {0 - $size}]
        }
        if {[file dirname $path] == "."} { set path "./$path" }
        lappend flist [list $size $type [file tail $rootname] $path $mtime $est]
      }
    }
    update
    if {$data(stop)} { break }
  }
  if {$data(recurse)} {
    foreach f $dlist {
      foreach i [::file::finder::GetFiles $f $len] {
        lappend flist $i
        update
        if {$data(stop)} { break }
      }
    }
  }
  return $flist
}

proc ::file::finder::OpenDIR {} {
  # borrowed from file/maint.tcl
  set w .finderdir ;#.bdesc
  if {[winfo exists $w]} { return }
  toplevel $w
  wm title $w "Scid: Open"
  wm withdraw $w

  set font font_Small
  entry $w.entry -width 50 -relief sunken 
  pack $w.entry -side top -pady 4
  frame $w.b
  dialogbutton $w.b.ok -text OK -command {
    if {[file isdir [.finderdir.entry get]]} {
      set dir [.finderdir.entry get]
      # silly hacks to fix up finder bug with "~"
      if {$dir == {~}} {
        set dir $::env(HOME)
      } elseif {[string range $dir 0 1] == {~/}} {
        set dir "$::env(HOME)/[string range $dir 2 end]"
      }
      ::file::finder::Refresh $dir
    }
    grab release .finderdir
    destroy .finderdir
  }
  dialogbutton $w.b.cancel -text $::tr(Cancel) -command "grab release $w; destroy $w"
  pack $w.b -side bottom -fill x
  pack $w.b.cancel $w.b.ok -side right -padx 2 -pady 2
  bind $w.entry <Return> "$w.b.ok invoke"
  bind $w <Escape> "$w.b.cancel invoke"
  focus $w.entry

  placeWinOverParent $w .finder
  wm state $w normal
  wm resizable $w 0 0
  catch {grab $w}
}

