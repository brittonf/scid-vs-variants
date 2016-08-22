
####################
# Recent files list:

set recentFiles(limit) 10   ;# Maximum number of recent files to remember.
set recentFiles(menu)   5   ;# Maximum number of files to show in File menu.
set recentFiles(extra)  5   ;# Maximum number of files to show in extra menu.
set recentFiles(gamehistory) 5 ;# Maximum number of files to show in Game History
set recentFiles(playernames) 10
set recentFiles(data)  {}   ;# List of recently used files.

catch {source [scidConfigFile recentfiles]}

namespace eval ::recentFiles {}

### Saves the recent-file-list file, reporting any error in a message box if reportError is true.

proc ::recentFiles::save {{reportError 0}} {
  global recentFiles

  set f {}
  set filename [scidConfigFile recentfiles]
  if  {[catch {open $filename w} f]} {
    if {$reportError} {
      tk_messageBox -title "Scid" -type ok -icon warning \
          -message "Unable to write file: $filename\n$f"
    }
    return
  }
  puts $f "# $::scidName recent files list\n"
  foreach i {limit menu extra gamehistory playernames data} {
    puts $f "set recentFiles($i) [list [set recentFiles($i)]]"
    puts $f ""
  }
  close $f
}

proc ::recentFiles::remove {fname} {
  ::recentFiles::add $fname 1
}

### Add a file to the recent files list, or move it to the front if file is already in the list.

proc ::recentFiles::add {fname {delete 0}} {
  global recentFiles
  set list $recentFiles(data) 

  # Remove file to be added from its current place in the list (if any)
  while {1} {
    set idx [lsearch -exact $list $fname]
    if {$idx < 0} { break }
    set list [lreplace $list $idx $idx]
  }

  if {!$delete} {
    # Insert the current file at the start of the list:
    set list [linsert $list 0 $fname]

    # Trim the list to thrice the limit (arbitary)
    set limit [expr {3 * $recentFiles(limit)}]
    if {[llength $list] > $limit} {
      set list [lrange $list 0 [expr {$limit - 1}]]
    }
  }

  set recentFiles(data) $list
  # ::recentFiles::save

  # The finder and ::file::Open will now use this dir as their initial one
  set ::file::finder::data(dir) [file dirname $fname]
}

###  Load the selected recent file, or switch to its database slot if already open.

proc ::recentFiles::load {fname} {
  set rname $fname
  if {[file extension $rname] == ".si4"} {
    set rname [file rootname $rname]
  }
  for {set i 1} {$i <= [sc_base count total]} {incr i} {
    if {$rname == [sc_base filename $i]} {
      ::file::SwitchToBase $i
      ::recentFiles::add $fname
      return
    }
  }
  ::file::Open $fname
}

proc ::recentFiles::treeshow {menu} {
  global recentFiles

  set list $recentFiles(data)
  $menu delete 0 end
  set menuLength [llength $list]
  if {$menuLength > $recentFiles(limit)} {
    set menuLength $recentFiles(limit)
  }

  for {set i 0} {$i<$menuLength} {incr i} {
    set name [lindex $list $i]
    $menu add command -label "[file tail $name]" -command [list ::file::openBaseAsTree $name]
  }
}

### Add the recent files to the end of the specified menu.
# Returns the number of menu entries added (for the purpose of deciding if we need a separator)

proc ::recentFiles::show {menu} {
  global recentFiles

  set idx [$menu index end]
  incr idx
  set list $recentFiles(data)
  set menuLength [llength $list]
  set secondMenuLength [expr {$menuLength - $recentFiles(menu)} ]
  if {$menuLength > $recentFiles(menu)} {
    set menuLength $recentFiles(menu)
  }

  # Add menu commands for the most recent files:

  for {set i 0} {$i < $menuLength} {incr i} {
    set fname [lindex $list $i]
    set num [expr {$i + 1} ]
    set underline -1
    if {$num <= 9} { set underline 0 }
    if {$num == 10} { set underline 1 }
    $menu add command -label "$num: [file tail $fname]" -underline $underline \
        -command [list ::recentFiles::load $fname]
    set ::helpMessage($menu,$idx) "  [file nativename $fname]"
    incr idx
  }

  # If no extra submenu of recent files is needed, return
  if {$secondMenuLength <= 0} {
    return $menuLength
  }
  if {$secondMenuLength > $recentFiles(extra)} {
    set secondMenuLength $recentFiles(extra)
  }

  catch {destroy $menu.recentFiles}
  menu $menu.recentFiles
  $menu add cascade -label ". . ." -menu $menu.recentFiles
  set i $menuLength
  for {set extra 0} {$extra < $secondMenuLength} {incr extra} {
    set fname [lindex $list $i]
    incr i
    $menu.recentFiles add command -label "[file tail $fname]" -command [list ::recentFiles::load $fname]
    set ::helpMessage($menu.recentFiles,$extra) "  $fname"
  }
  return [expr {$menuLength + 1} ]
}

### Configure the number of recent files to display in a few history menus

proc ::recentFiles::configure {} {
  global recentFiles

  set w .recentFilesDlg
  if {[winfo exists $w]} {
    raiseWin $w
    return
  }

  toplevel $w
  wm withdraw $w
  wm title $w "Scid: [tr OptionsRecent]"

  set recentFiles(temp_menu) $recentFiles(menu)
  set recentFiles(temp_extra) $recentFiles(extra)
  set recentFiles(temp_gamehistory) $recentFiles(gamehistory)
  set recentFiles(temp_playernames) $recentFiles(playernames)

  label $w.lmenu -text $::tr(RecentFilesMenu)
  scale $w.menu -variable recentFiles(temp_menu) -from 0 -to 20 -length 250 \
      -orient horizontal -showvalue 0 -tickinterval 2 -font font_Small

  frame $w.sep -height 4

  label $w.lextra -text $::tr(RecentFilesExtra)
  scale $w.extra -variable recentFiles(temp_extra) -from 0 -to 20 -length 250 \
      -orient horizontal -showvalue 0 -tickinterval 2 -font font_Small

  frame $w.sep2 -height 4

  label $w.lgames -text {Number of games in Game History}
  scale $w.games -variable recentFiles(temp_gamehistory) -from 0 -to 20 -length 250 \
      -orient horizontal -showvalue 0 -tickinterval 2 -font font_Small

  frame $w.sep3 -height 4

  label $w.lplayers -text {Number of players in History}
  scale $w.players -variable recentFiles(temp_playernames) -from 0 -to 20 -length 250 \
      -orient horizontal -showvalue 0 -tickinterval 2 -font font_Small

  pack $w.lmenu $w.menu $w.sep $w.lextra $w.extra $w.sep2 $w.lgames $w.games $w.sep3 $w.lplayers $w.players -side top -padx 10
  addHorizontalRule $w
  pack [frame $w.b] -side bottom

  dialogbutton $w.b.ok -text "OK" -command {
    set recentFiles(menu) $recentFiles(temp_menu)
    set recentFiles(extra) $recentFiles(temp_extra)
    set recentFiles(gamehistory) $recentFiles(temp_gamehistory)
    set recentFiles(playernames) $recentFiles(temp_playernames)
    destroy .recentFilesDlg
    ::recentFiles::save
    updateMenuStates
    ::bookmarks::RefreshMenuGame .menu.game
  }

  dialogbutton $w.b.cancel -text $::tr(Cancel) -command "destroy $w"

  pack $w.b.cancel $w.b.ok -side right -padx 5 -pady 5

  placeWinOverParent $w .
  wm state $w normal
}

