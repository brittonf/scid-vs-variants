### tcl/utils/win.tcl

#     DockingFramework
#
#     Code is inspired by
#     http://wiki.tcl.tk/21846
#     which is published under BSD license

image create photo bluetriangle -data {
  R0lGODlhCAAIAKECADNBUEFYb////////yH5BAEKAAIALAAAAAAIAAgAAAINlI8pAe2wHjSs
  JaayKgA7
}

namespace eval docking {
  # associates notebook to paned window
  variable tbs

  # keep tracks of active tab for each notebook
  array set activeTab {}
  # associates notebook with a boolean value indicating the tab has changed
  array set changedTab {}

  variable tbcnt 0
  array set notebook_name {}

  # redraw takes some time : skip some events
  variable lastConfigureEvent 0
  variable deltaConfigureEvent 400
}

################################################################################
proc ::docking::handleConfigureEvent {w} {
  variable lastConfigureEvent
  variable deltaConfigureEvent

  if {!$::docking::USE_DOCKING || $w != ".main"} {return}

  set cmd ::resizeMainBoard

  after cancel "eval $cmd"
  set t [clock clicks -milliseconds]

  if {  [expr $t - $lastConfigureEvent ] < $deltaConfigureEvent } {
    after [ expr $deltaConfigureEvent + $lastConfigureEvent -$t ] "eval $cmd"
  } else  {
    set lastConfigureEvent $t
    eval $cmd
    # Necessary on MacOs to refresh user interface
    # update idletasks
  }
}
################################################################################
# find notebook, corresponding to path
proc ::docking::find_tbn {path} {
  variable tbs

  if {$path==""} { return $path }
  # already a managed notebook?
  if {[info exists tbs($path)]} {
    return $path
  }
  # managed notebooks have the form .toplevel.tbn#
  # pages within notebooks should also have the path .toplevel.page#
  set spath [split $path "."]
  if {[winfo toplevel $path]=="."} {
    set path [join [lrange $path 0 1] "."]
  } else {
    set path [join [lrange $path 0 2] "."]
  }

  # is it a managed notebook?
  if {[info exists tbs($path)]} {
    return $path
  }

  # try to find notebook that manages this page
  foreach tb [array names tbs] {
    if {[get_class $tb] != "TNotebook"} {
      continue
    }
    if {[lsearch -exact [$tb tabs] $path]>=0} {
      return $tb
    }
  }

  return {}
}

################################################################################
# added paned window of other direction, move a notebook there and create a new notebook
proc ::docking::embed_tbn {tbn anchor} {
  variable tbcnt
  variable tbs
  set pw $tbs($tbn)
  if {$anchor=="w" || $anchor=="e"} {
    set orient "horizontal"
  } else {
    set orient "vertical"
  }
  # create new paned window
  set npw [ttk::panedwindow $pw.pw$tbcnt -orient $orient  ]
  incr tbcnt
  # move old notebook
  set i [lsearch -exact [$pw panes] $tbn]
  $pw forget $tbn
  if {$i>=[llength [$pw panes]]} {
    $pw add $npw -weight 1
  } else {
    $pw insert $i $npw -weight 1
  }
  # add new notebook
  set ntb [ttk::notebook [winfo toplevel $pw].tb$tbcnt]
  incr tbcnt
  set tbs($tbn) $npw
  set tbs($ntb) $npw
  # make sure correct order
  if {$anchor=="n" || $anchor=="w"} {
    $npw add $ntb -weight 1
    $npw add $tbn -weight 1
  } else {
    $npw add $tbn -weight 1
    $npw add $ntb -weight 1
  }
  return $ntb
}

################################################################################
# add a new notebook to the side anchor of the notebook tbn
proc ::docking::add_tbn {tbn anchor} {
  variable tbcnt
  variable tbs

  set pw $tbs($tbn)
  set orient [$pw cget -orient]

  # if orientation of the uplevel panedwindow is consistent with anchor, just add the pane
  if {$orient=="horizontal" && ($anchor=="w" || $anchor=="e")} {
    set i [lsearch -exact [$pw panes] $tbn]
    if {$anchor=="e"} { incr i }
    set tbn [ttk::notebook [winfo toplevel $pw].tb$tbcnt]
    incr tbcnt
    set tbs($tbn) $pw
    if {$i>=[llength [$pw panes]]} {
      $pw add $tbn -weight 1
    } else {
      $pw insert $i $tbn -weight 1
    }
  } elseif {$orient=="vertical" && ($anchor=="n" || $anchor=="s")} {
    set i [lsearch -exact [$pw panes] $tbn]
    if {$anchor=="s"} { incr i}
    set tbn [ttk::notebook [winfo toplevel $pw].tb$tbcnt]
    incr tbcnt
    set tbs($tbn) $pw
    if {$i>=[llength [$pw panes]]} {
      $pw add $tbn -weight 1
    } else {
      $pw insert $i $tbn -weight 1
    }
  } else {
    # orientation of the uplevel panedwindow is opposite to the anchor
    # need to add new panedwindow
    set tbn [embed_tbn $tbn $anchor]
  }
  return $tbn
}

################################################################################
proc ::docking::get_class {path} {
  if {![winfo exists $path]} {
    return ""
  }
  return [lindex [bindtags $path] 1]
}

################################################################################
# always keep .pw paned window
proc ::docking::_cleanup_tabs {srctab} {
  variable tbs

  # if srctab is empty, then remove it
  if {[llength [$srctab tabs]]==0} {
    destroy $srctab
    set pw $tbs($srctab)
    unset tbs($srctab)

    while {[llength [$pw panes]]==0} {
      set parent [winfo parent $pw]

      if {$pw == ".pw"} {
        break
      }
      destroy $pw
      set pw $parent
    }

  }
}
################################################################################
# cleans up a window when it was closed without calling the notebook menu

proc ::docking::cleanup { w { origin "" } } {
  variable tbs

  if { ! $::docking::USE_DOCKING } { return }

  # if the destroy event came from a sub-widget, do nothing. Necessary because if a widget is destroyed, it sends a destroy event to
  # its containing window
  if { [ string last "." $origin ] > 0 } {
    return
  }

  set dockw ".fdock[string range $w 1 end]"
  if {![winfo exists $dockw]} { return }

  set tab [::docking::find_tbn $dockw]
  if {$tab != ""} {
    $tab forget $dockw
    ::docking::_cleanup_tabs $tab
    catch { unset ::docking::notebook_name($dockw) }
    ::docking::setTabStatus
  }
  after idle "if {[winfo exists $dockw]} { destroy $dockw }"

}

proc ::docking::isUndocked { w } {
  set f ".fdock[string range $w 1 end]"
  return [info exists ::docking::notebook_name($f)]
}

proc ::docking::isWindow { w } {
  set f ".fdock[string range $w 1 end]"
  return [expr {[winfo exists $w] && ![winfo exists $f]}]
}

proc ::docking::move_tab {srctab dsttab {x {}} {y {}}} {

  variable tbs

  if {$x != {}} {
    set dest [$dsttab index @[expr $x-[winfo rootx $dsttab]],[expr $y-[winfo rooty $dsttab]]]
  }

  # move tab
  set f [$srctab select]
  set o [$srctab tab $f]
  $srctab forget $f
  eval $dsttab add $f $o

  # now place after destination tab if possible
  if {$x != {}} {
    # if {[catch {incr dest}]} { set dest end }
    if {$dest == ""} {
      $dsttab insert end $f
    } else {
      $dsttab insert $dest $f
    }
  }

  raise $f
  if { [ scan $f ".fdockanalysisWin%d" n ] == 1 } {
    after 100 "catch {.analysisWin$n.hist.text yview moveto 1}"
  }
  $dsttab select $f
  _cleanup_tabs $srctab
}

variable ::docking::c_path {}


proc ::docking::start_motion {path x y} {
  variable c_path

  if {[winfo exists .ctxtMenu]} {
    destroy .ctxtMenu
  }

  if {[catch {$path tab @$x,$y}]} {
    # stop errant dragging
    set c_path {}
    return
  }
  # hmmm ??
  if {$path!=$c_path} {
    set c_path [find_tbn $path]
  }
  ### On OS X we have a problem with the buttons not getting -state normal
  # until a transient gets and loses focus, switching back to the app
  # This hack (which is called with Button-Press-1 on tab title) doesnt work
  # if { [scan [$c_path select] ".fdock%s" tl] == 1 } {focus .$tl}
}
################################################################################
proc ::docking::motion {path} {
  variable c_path
  if {$c_path != ""} {
    $c_path configure -cursor fleur ; # box_spiral fleur exchange
  }
}
################################################################################
proc ::docking::end_motion {w x y} {
  variable c_path

  bind TNotebook <ButtonRelease-1> [namespace code {::docking::show_menu %W %x %y}]

  if {$c_path==""} { return }
  $c_path configure -cursor {}

  set path [winfo containing $x $y]
  if {$path == ""} {
    return
  }

  set t [find_tbn $path]
  if {$t!=""} {
    if {$t==$c_path} {
      # we stayed on the same notebook, so try moving it
      set dest [$c_path index @[expr $x-[winfo rootx $c_path]],[expr $y-[winfo rooty $c_path]]]
      if {$dest == {}} {
        set dest end
      }
      $c_path insert $dest [$c_path select]
      # wtf is this here 
      # if {[$c_path identify [expr $x-[winfo rootx $c_path]] [expr $y-[winfo rooty $c_path]]]!=""} 
      # set c_path {}
      # return
    } else {
      move_tab $c_path $t $x $y
    }
  }
  set c_path {}

  setTabStatus
}

proc ::docking::show_menu {path x y} {
  variable c_path

  if {[winfo exists .ctxtMenu]} {
    destroy .ctxtMenu
  }

  if {$path!=$c_path} {
    set c_path [find_tbn $path]
  }

  # HACK ! Because notebooks may also be used inside internal windows
  if {! [info exists ::docking::changedTab($c_path)] } {
    return
  }

  # Check a tab exists under cursor
  if {[catch {$c_path tab @$x,$y}]} {
    return
  }

  # display window's menu (workaround for windows where the menu
  # of embedded toplevels is not displayed. The menu must be of the form $w.menu

  # if the tab has changed, don't display the menu at once (wait a second click)
  if { $::docking::changedTab($c_path) == 1 } {
    set ::docking::changedTab($c_path) 0
  } else  {
    # the tab was already active, show the menu
    set f [$c_path select]
    set m [getMenu $f]
    if { [winfo exists $m] } {
      tk_popup $m [winfo pointerx .] [winfo pointery .]
    }
  }

}
################################################################################
# returns the menu name of a toplevel window (must be in the form $w.menu)
# f is the frame embedding the toplevel (.fdock$w)
proc  ::docking::getMenu  {f} {
  if { [scan $f ".fdock%s" tl] != 1 || $f == ".fdockmain"} {
    return ""
  }
  return ".$tl.menu"
}
################################################################################
# Toggles menu visibility
# f is the frame embedding the toplevel (.fdock$w)
proc ::docking::setMenuVisibility  { f show } {

  if { [scan $f ".fdock%s" tl] != 1 || $f == ".fdockmain"} {
    return
  }
  set tl ".$tl"

  if { $show == "true" || $show == "1" } {
    $tl configure -menu "$tl.menu"
  } else  {
    $tl configure -menu {}
  }

}


proc ::docking::raiseTab {w} {
  set f ".fdock[string range $w 1 end]"
  set tbn [::docking::find_tbn $f]
  if {$w == ".main"} {
    # We dont want to autoraise undocked windows
    bind .fdockmain <Map> {}
    $tbn select $f
    bind .fdockmain <Map> {raiseAllWindows}
  } else {
    $tbn select $f
  }
  set ::docking::activeTab($tbn) $f
  set ::docking::changedTab($tbn) 0
}


proc  ::docking::tabChanged  {path} {
  # HACK ! Because notebooks may also be used inside internal windows
  if { ! [ info exists ::docking::activeTab($path)] } {
    return
  }
  set select [$path select]
  if { $select != $::docking::activeTab($path)} {
    set ::docking::activeTab($path) $select
    set ::docking::changedTab($path) 1
  }
}

################################################################################

bind TNotebook <ButtonRelease-1> {::docking::show_menu %W %x %y}

bind TNotebook <ButtonPress-1> +[ list ::docking::start_motion %W %x %y]

bind TNotebook <B1-Motion> {
  ::docking::motion %W
  bind TNotebook <ButtonRelease-1> {::docking::end_motion %W %X %Y}
}

bind TNotebook <Escape> {
  if {[winfo exists .ctxtMenu]} {
    destroy .ctxtMenu
  }
}

bind TNotebook <ButtonPress-3> {::docking::ctx_menu %W %X %Y}
bind TNotebook <<NotebookTabChanged>> {::docking::tabChanged %W}

proc ::docking::ctx_cmd {path anchor} {
  variable c_path

  if {$path!=$c_path} {
    set c_path [find_tbn $path]
  }

  if {$c_path==""} {
    puts "WARNING c_path null in ctx_cmd"
    return
  }

  set tbn [add_tbn $path $anchor]
  move_tab $c_path $tbn

  set c_path {}

  setTabStatus
}

proc ::docking::ctx_menu {w x y} {

  # HACK ! Because notebooks may also be used inside internal windows
  if {! [info exists ::docking::changedTab($w)] } {
    return
  }

  # Switch to tab under cursor
  if {[catch {$w select @[expr $x-[winfo rootx $w]],[expr $y-[winfo rooty $w]]}]} {
    return
  }

  if { [$w select] == ".fdockmain" } {
    ::contextmenu $x $y
    return
  }

  update idletasks
  set mctxt .ctxtMenu
  if { [winfo exists $mctxt] } {
    destroy $mctxt
  }

  menu $mctxt -tearoff 0
  set state "normal"
  if { [llength [$w tabs]] == "1"} {
    set state "disabled"
  }
  $mctxt add command -label [ ::tr DockTop ] -state $state -command "::docking::ctx_cmd $w n"
  $mctxt add command -label [ ::tr DockBottom ] -state $state -command "::docking::ctx_cmd $w s"
  $mctxt add command -label [ ::tr DockLeft ] -state $state -command "::docking::ctx_cmd $w w"
  $mctxt add command -label [ ::tr DockRight ] -state $state -command "::docking::ctx_cmd $w e"
  $mctxt add separator
  $mctxt add command -label [ ::tr Undock ] -command "::docking::undock $w"
  $mctxt add command -label [ ::tr Close ] -command " ::docking::close $w"
  if {$::macOS} {
    # undocking not implemented in OS X Tk
    $mctxt entryconfigure 5 -state disabled
  }
  tk_popup $mctxt [winfo pointerx .] [winfo pointery .]
}
################################################################################
proc ::docking::close {w} {
  set tabid [$w select]
  $w forget $tabid

  destroy $tabid
  _cleanup_tabs $w
  setTabStatus
}
################################################################################
proc ::docking::undock {srctab} {
  variable tbs
  if {[llength [$srctab tabs]]==1 && [llength [array names tbs]]==1} { return }

  set f [$srctab select]

  set name [$srctab tab $f -text]
  set o [$srctab tab $f]

  $srctab forget $f
  _cleanup_tabs $srctab

  wm manage $f

  setMenuVisibility $f true

  wm title $f $name

  # Uncomment this code to dock windows that have been previously undocked
  # wm protocol $f WM_DELETE_WINDOW [namespace code [list __dock $f]]

  wm deiconify $f
  set ::docking::notebook_name($f) [list $srctab $o]
  setTabStatus

  if {$f eq ".fdockglistWin"} {
	  after idle [list RegisterDropEvents $f]
  }
}

################################################################################
proc ::docking::__dock {wnd} {
  variable tbs

  setMenuVisibility $wnd false

  set name [wm title $wnd]
  wm withdraw $wnd
  wm forget $wnd

  set d  $::docking::notebook_name($wnd)

  set dsttab [lindex $d 0]
  set o [lindex $d 1]

  if {![winfo exists $dsttab]} {
    set dsttab [lindex [array names tbs] 0]
  }
  eval $dsttab add $wnd $o
  raise $wnd
  $dsttab select $wnd
}


proc ::docking::add_tab {path args} {
  # (args currently unused)
  variable tbs
  set chummy ""
  if { $::docking::layout_dest_notebook == ""} {
    ### Scan all tabs to find the most suitable
    set dsttab {}

  if { [scan $path ".fdocktreeBest%d" base ] == 1 && \
       [set dsttab [::docking::find_tbn .fdocktreeWin$base]] != ""} {
    set chummy .fdocktreeWin$base
    # dsttab is set to .fdocktreeWin$base
  } else {
    foreach tb [array names tbs] {
      # It's possible to have no ".nb" so use this instead of ($tb != ".nb")
      set tabs [$tb tabs]
      set tabcount [llength $tabs]
      set notMainBoard [expr {[lsearch $tabs .fdockmain] == -1}]
      # Note - $x, $y, $h are currently never used as criteria
      set x [winfo rootx $tb]
      set y [winfo rooty $tb]
      set w [winfo width $tb]
      set h [winfo height $tb]

      ### Some windows the largest (widest) pane
      if {($path == ".fdockfics" && $notMainBoard) ||
           $path == ".fdocktbWin" ||
           $path == ".fdockcrosstabWin" ||
           $path == ".fdockglistWin"} {
        set rel {$w > $_w}
      } else {
        ### Others get the least crowded
        # todo: make some get a small/medium sized paned window
        set rel {$tabcount < $_tabcount && $notMainBoard}
      }
      if {$dsttab==""} {
        set dsttab $tb
        set _x $x
        set _y $y
        set _w $w
        set _tabcount $tabcount
        # hack to give fics another tab
        # if {$tb == ".nb"} {set _w 0}
      } elseif { [expr $rel] } {
        set dsttab $tb
        set _x $x
        set _y $y
        set _w $w
        set _tabcount $tabcount
      }
    }
  }
  } else  {
    set dsttab $::docking::layout_dest_notebook
  }

  set title $path
  eval [list $dsttab add $path] $args -text "$title"
  if {$chummy != ""} {
    # Insert path next to it's friend
    # pathname insert pos subwindow options...
    $dsttab insert [expr [$dsttab index $chummy] + 1] $path
  }

  setMenuMark $dsttab $path
  $dsttab select $path
  # Make new tab active
  set ::docking::activeTab($dsttab) $path
  set ::docking::changedTab($dsttab) 0
  update
}

### Display a blue triangle showing the tab has a menu associated

proc ::docking::setMenuMark { nb tab} {
  if { $tab == ".fdockpgnWin" || \
       $tab == ".fdockccWindow" || \
       $tab == ".fdockcrosstabWin" || \
       $tab == ".fdocksgraph" || \
       $tab == ".fdockrgraph" || \
       $tab == ".fdockplayerInfoWin" || \
       [string match "\.fdocktreeWin*" $tab] } {
    $nb tab $tab -image bluetriangle -compound left
  }
}
################################################################################
# Layout management
################################################################################

set ::docking::layout_tbcnt 0

# associates pw -> notebook list
array set ::docking::layout_notebook {}

# associates notebook -> list of tabs
array set ::docking::layout_tabs {}

# the notebook into which to create a new tab
set ::docking::layout_dest_notebook ""

################################################################################
# saves layout (bail out if some windows cannot be restored like FICS)
proc ::docking::layout_save { slot } {
  if {[winfo exists .fics]} {
    tk_messageBox -title Scid -icon question -type ok -message "Cannot save layout with FICS opened"
    return
  }

  # on Windows the geometry is false if the window was maximized (x and y offsets are the ones before the maximization)
  set geometry [wm geometry .]
  if {$::windowsOS && [wm state .] == "zoomed"} {
    if { [scan $geometry "%dx%d+%d+%d" w h x y] == 4 } {
      set geometry "${w}x${h}+0+0"
    }
  }

  set layout [layout_save_pw .pw]

  set tree_count [regexp -all {fdocktreeWin([0-9]*)}  $layout tree1 tree2]
  set best_count [regexp -all {fdocktreeBest([0-9]*)} $layout best1 best2]

  if {$tree_count > 1} {
    tk_messageBox -title Scid -icon question -type ok -message "Cannot save layout with multiple Trees."
    return
  }

  if {$best_count && [string first fdocktreeBest $layout] < [string first fdocktreeWin $layout]} {
    tk_messageBox -title Scid -icon question -type ok -message "Cannot save layout: Tree must precede Best Games."
    return
  }

  set ::docking::layout_list($slot) [list [list "MainWindowGeometry" $geometry] ]
  lappend ::docking::layout_list($slot) $layout
}

################################################################################
proc ::docking::layout_save_pw {pw} {
  set ret {}

  # record sash position for each panes
  set sashpos {}
  for {set i 0} {$i < [ expr [llength [$pw panes]] -1]} {incr i} {
    lappend sashpos [$pw sashpos $i]
  }
  lappend ret [list $pw [$pw cget -orient ] $sashpos ]

  foreach p [$pw panes] {
    if {[get_class $p] == "TNotebook"} {
      lappend ret [list "TNotebook" $p [$p tabs] ]
    }
    if {[get_class $p] == "TPanedwindow"} {
      lappend ret [ list "TPanedwindow" [layout_save_pw $p] ]
    }
  }
  return $ret
}

################################################################################
# restores paned windows and internal notebooks
proc ::docking::layout_restore_pw { data } {

  foreach elt $data {
    update idletasks

    set type [lindex $elt 0]

    if {$type == "MainWindowGeometry"} {
      wm geometry . [lindex $elt 1]
      layout_restore_pw [lindex $data 1]
      break
    } elseif {$type == "TPanedwindow"} {
      layout_restore_pw [lindex $elt 1]

    } elseif {$type == "TNotebook"} {
      set name [lindex $elt 1]
      set tabs [lindex $elt 2]
      ::docking::layout_restore_nb $pw $name $tabs

    } else {

      set pw [lindex $elt 0]
      set orient [lindex $elt 1]
      # we have sash geometry
      if {[llength $elt] > 2} {
        lappend ::docking::sashpos [ list $pw [lindex $elt 2] ]
      }
      if { $pw == ".pw"} { continue }
      # build a new pw
      ttk::panedwindow $pw -orient $orient

      set parent [string range $pw 0 [expr [string last "." $pw ]-1 ] ]
      $parent add $pw -weight 1
    }

  }
}

################################################################################
# Sash position
################################################################################
proc ::docking::restoreGeometry {} {
  if {$::windowsOS} {
    ### fixme
    # Hack to make windows work.
    wm deiconify .
    update
  }
  foreach elt $::docking::sashpos {
    update idletasks
    set pw [lindex $elt 0]
    set sash [lindex $elt 1]
    set i 0
    foreach pos $sash {
      $pw sashpos $i $pos
      incr i
    }
  }
}
################################################################################
# restores a notebook in a pre-existing panedwindow
# panewindow -> pw
# widget name -> name
# data to make tabs -> data (list of names wich can be used to trigger the correct windows)
proc ::docking::layout_restore_nb { pw name tabs} {
  variable tbcnt
  variable tbs

  set nb [ttk::notebook $name]
  incr tbcnt
  if {[scan $name ".tb%d" tmp] == 1} {
    if {$tmp >= $tbcnt} {
      set tbcnt [ expr $tmp +1]
    }
  }

  set tbs($nb) $pw

  $pw add $nb -weight 1

  set ::docking::tbs($nb) $pw

  set ::docking::layout_dest_notebook $nb

  foreach d $tabs {

    if { $d == ".fdockmain" } {
      $nb add $d -text $::tr(Board)
      raise $d
    }
    if {$d == ".fdockpgnWin"}        {::pgn::Open ; continue}
    if {$d == ".fdockbaseWin"}       {::windows::switcher::Open ; continue}
    if {$d == ".fdocktbWin"}         {::tb::Open ; continue}
    if {$d == ".fdockcommentWin"}    {set ::commentWin 1 ; ::commenteditor::Open ; continue}
    if {$d == ".fdockglistWin"}      {::windows::gamelist::Open ; continue}
    if {$d == ".fdockccWindow"}      {::CorrespondenceChess::CCWindow ; continue}
    if {$d == ".fdockplayerInfoWin"} {::playerInfo ; continue}
    if {$d == ".fdockcrosstabWin"}   {::crosstab::Open ; continue}
    if {$d == ".fdockbookWin"}       {::book::Open ; continue}
    if {$d == ".fdockbookTuningWin"} {::book::tuning ; continue}
    if {$d == ".fdockrgraph"}        {::tools::graphs::rating::Refresh}
    if {$d == ".fdocksgraph"}        {::tools::graphs::score::Init}
    if { [ scan $d ".fdocktreeWin%d" base ] == 1 } {::tree::Open $base ; continue}
    if { [ scan $d ".fdocktreeBest%d" base ] == 1 } {::tree::best $base ; continue}
    if { [ scan $d ".fdockanalysisWin%d" n ] == 1 } {
      # dont auto start engine
      if {[::makeAnalysisWin $n nostart] == -1} {
        puts "::docking::layout_restore_nb: failed to start engine $n"
	scan $d .fdock%s blank
	::createToplevel .$blank
	::setTitle .$blank Error
	# pack [ label .$blank.text -text "Failed to start engine $n" ]
	::createToplevelFinalize .$blank
      }
    }
  }

  # force the selection of first tab
  $nb select [ lindex [ $nb tabs] 0 ]

  set ::docking::layout_dest_notebook ""
}

################################################################################
proc ::docking::layout_restore { slot } {
  variable tbcnt
  variable tbs
  bind TNotebook <<NotebookTabChanged>> {}

  # if no layout recorded, return
  if { $::docking::layout_list($slot) == {} } {
    return
  }

  closeAll {.pw}
  set tbcnt 0
  array set ::docking::notebook_name {}
  array set ::docking::tbs {}
  set ::docking::sashpos {}

  layout_restore_pw $::docking::layout_list($slot)

  ::docking::restoreGeometry

  array set ::docking::activeTab {}
  setTabStatus

  bind TNotebook <<NotebookTabChanged>> {::docking::tabChanged %W}

}

### For every notebook, update the last selected tab. Used to see if the local menu can be popped up or not

proc ::docking::setTabStatus { } {
  variable tbs

  array set ::docking::activeTab {}
  array set ::docking::changedTab {}

  foreach nb [array names tbs] {
    set select [$nb select]
    set ::docking::activeTab($nb) $select
    set ::docking::changedTab($nb) 0
  }

}
################################################################################
# erase all mapped windows, except .main
proc ::docking::closeAll {pw} {

  foreach p [$pw panes] {
    if {[get_class $p] == "TPanedwindow"} {
      ::docking::closeAll $p
    }

    if {[get_class $p] == "TNotebook"} {
      foreach tabid [$p tabs] {
        catch {
	  $p forget $tabid
        }
        if {$tabid != ".fdockmain"} {
          destroy $tabid
        }
        catch {
	  _cleanup_tabs $p
        }
      }
    }
  }

}


if {$::docking::USE_DOCKING} {
  ::splash::add "Docking mode enabled."
  pack [ttk::panedwindow .pw -orient vertical] -fill both -expand true
  .pw add [ttk::notebook .nb] -weight 1
  set docking::tbs(.nb) .pw
}

createToplevel .main
::docking::setTabStatus

if {!$::docking::USE_DOCKING} {
  ::splash::add "Docking mode disabled."
  wm withdraw .main ; # gets remapped later
}

### Scrolledframe.tcl

namespace eval ::scrolledframe {
  # beginning of ::scrolledframe namespace definition

  namespace export scrolledframe

  # ==============================
  #
  # scrolledframe
  set version 0.9.1
  set (debug,place) 0
  #
  # a scrolled frame
  #
  # (C) 2003, ulis
  #
  # NOL licence (No Obligation Licence)
  #
  # Changes (C) 2004, KJN
  #
  # NOL licence (No Obligation Licence)
  # ==============================
  #
  # Hacked package, no documentation, sorry
  # See example at bottom
  #
  # ------------------------------
  # v 0.9.1
  #  automatic scroll on resize
  # ==============================

  package provide Scrolledframe $version

  # --------------
  #
  # create a scrolled frame
  #
  # --------------
  # parm1: widget name
  # parm2: options key/value list
  # --------------
  proc scrolledframe {w args} \
      {
        variable {}
        # create a scrolled frame
        frame $w
        # trap the reference
        rename $w ::scrolledframe::_$w
        # redirect to dispatch
        interp alias {} $w {} ::scrolledframe::dispatch $w
        # create scrollable internal frame
        frame $w.scrolled -highlightt 0 -padx 0 -pady 0
        # place it
        place $w.scrolled -in $w -x 0 -y 0
        if {$(debug,place)} { puts "place $w.scrolled -in $w -x 0 -y 0" } ;#DEBUG
        # init internal data
        set ($w:vheight) 0
        set ($w:vwidth) 0
        set ($w:vtop) 0
        set ($w:vleft) 0
        set ($w:xscroll) ""
        set ($w:yscroll) ""
        set ($w:width)    0
        set ($w:height)   0
        set ($w:fillx)    0
        set ($w:filly)    0
        # configure
        if {$args != ""} { uplevel 1 ::scrolledframe::config $w $args }
        # bind <Configure>
        bind $w <Configure> [namespace code [list resize $w]]
        bind $w.scrolled <Configure> [namespace code [list resize $w]]
        # return widget ref
        return $w
      }

  # --------------
  #
  # dispatch the trapped command
  #
  # --------------
  # parm1: widget name
  # parm2: operation
  # parm2: operation args
  # --------------
  proc dispatch {w cmd args} \
      {
        variable {}
        switch -glob -- $cmd \
        {
          con*    { uplevel 1 [linsert $args 0 ::scrolledframe::config $w] }
          xvi*    { uplevel 1 [linsert $args 0 ::scrolledframe::xview  $w] }
          yvi*    { uplevel 1 [linsert $args 0 ::scrolledframe::yview  $w] }
          default { uplevel 1 [linsert $args 0 ::scrolledframe::_$w    $cmd] }
        }
      }

  # --------------
  # configure operation
  #
  # configure the widget
  # --------------
  # parm1: widget name
  # parm2: options
  # --------------
  proc config {w args} \
      {
        variable {}
        set options {}
        set flag 0
        foreach {key value} $args \
        {
          switch -glob -- $key \
          {
            -fill   \
            {
              # new fill option: what should the scrolled object do if it is smaller than the viewing window?
              if {$value == "none"} {
                set ($w:fillx) 0
                set ($w:filly) 0
              } elseif {$value == "x"} {
                set ($w:fillx) 1
                set ($w:filly) 0
              } elseif {$value == "y"} {
                set ($w:fillx) 0
                set ($w:filly) 1
              } elseif {$value == "both"} {
                set ($w:fillx) 1
                set ($w:filly) 1
              } else {
                error "invalid value: should be \"$w configure -fill value\", where \"value\" is \"x\", \"y\", \"none\", or \"both\""
              }
              resize $w force
              set flag 1
            }
            -xsc*   \
            {
              # new xscroll option
              set ($w:xscroll) $value
              set flag 1
            }
            -ysc*   \
            {
              # new yscroll option
              set ($w:yscroll) $value
              set flag 1
            }
            default { lappend options $key $value }
          }
        }
        # check if needed
        if {!$flag || $options != ""} \
        {
          # call frame config
          uplevel 1 [linsert $options 0 ::scrolledframe::_$w config]
        }
      }

  # --------------
  # resize proc
  #
  # Update the scrollbars if necessary, in response to a change in either the viewing window
  # or the scrolled object.
  # Replaces the old resize and the old vresize
  # A <Configure> call may mean any change to the viewing window or the scrolled object.
  # We only need to resize the scrollbars if the size of one of these objects has changed.
  # Usually the window sizes have not changed, and so the proc will not resize the scrollbars.
  # --------------
  # parm1: widget name
  # parm2: pass anything to force resize even if dimensions are unchanged
  # --------------
  proc resize {w args} \
      {
        variable {}
        set force [llength $args]

        set _vheight     $($w:vheight)
        set _vwidth      $($w:vwidth)
        # compute new height & width
        set ($w:vheight) [winfo reqheight $w.scrolled]
        set ($w:vwidth)  [winfo reqwidth  $w.scrolled]

        # The size may have changed, e.g. by manual resizing of the window
        set _height     $($w:height)
        set _width      $($w:width)
        set ($w:height) [winfo height $w] ;# gives the actual height of the viewing window
        set ($w:width)  [winfo width  $w] ;# gives the actual width of the viewing window

        if {$force || $($w:vheight) != $_vheight || $($w:height) != $_height} {
          # resize the vertical scroll bar
          yview $w scroll 0 unit
          # yset $w
        }

        if {$force || $($w:vwidth) != $_vwidth || $($w:width) != $_width} {
          # resize the horizontal scroll bar
          xview $w scroll 0 unit
          # xset $w
        }
      } ;# end proc resize

  # --------------
  # xset proc
  #
  # resize the visible part
  # --------------
  # parm1: widget name
  # --------------
  proc xset {w} \
      {
        variable {}
        # call the xscroll command
        set cmd $($w:xscroll)
        if {$cmd != ""} { catch { eval $cmd [xview $w] } }
      }

  # --------------
  # yset proc
  #
  # resize the visible part
  # --------------
  # parm1: widget name
  # --------------
  proc yset {w} \
      {
        variable {}
        # call the yscroll command
        set cmd $($w:yscroll)
        if {$cmd != ""} { catch { eval $cmd [yview $w] } }
      }

  # -------------
  # xview
  #
  # called on horizontal scrolling
  # -------------
  # parm1: widget path
  # parm2: optional moveto or scroll
  # parm3: fraction if parm2 == moveto, count unit if parm2 == scroll
  # -------------
  # return: scrolling info if parm2 is empty
  # -------------
  proc xview {w {cmd ""} args} \
      {
        variable {}
        # check args
        set len [llength $args]
        switch -glob -- $cmd \
        {
          ""      {set args {}}
          mov*    \
          { if {$len != 1} { error "wrong # args: should be \"$w xview moveto fraction\"" } }
          scr*    \
          { if {$len != 2} { error "wrong # args: should be \"$w xview scroll count unit\"" } }
          default \
          { error "unknown operation \"$cmd\": should be empty, moveto or scroll" }
        }
        # save old values:
        set _vleft $($w:vleft)
        set _vwidth $($w:vwidth)
        set _width  $($w:width)
        # compute new vleft
        set count ""
        switch $len \
        {
          0       \
          {
            # return fractions
            if {$_vwidth == 0} { return {0 1} }
            set first [expr {double($_vleft) / $_vwidth}]
            set last [expr {double($_vleft + $_width) / $_vwidth}]
            if {$last > 1.0} { return {0 1} }
            return [list [format %g $first] [format %g $last]]
          }
          1       \
          {
            # absolute movement
            set vleft [expr {int(double($args) * $_vwidth)}]
          }
          2       \
          {
            # relative movement
            foreach {count unit} $args break
            if {[string match p* $unit]} { set count [expr {$count * 9}] }
            set vleft [expr {$_vleft + $count * 0.1 * $_width}]
          }
        }
        if {$vleft + $_width > $_vwidth} { set vleft [expr {$_vwidth - $_width}] }
        if {$vleft < 0} { set vleft 0 }
        if {$vleft != $_vleft || $count == 0} \
        {
          set ($w:vleft) $vleft
          xset $w
          if {$($w:fillx) && ($_vwidth < $_width || $($w:xscroll) == "") } {
            # "scrolled object" is not scrolled, because it is too small or because no scrollbar was requested
            # fillx means that, in these cases, we must tell the object what its width should be
            place $w.scrolled -in $w -x [expr {-$vleft}] -width $_width
            if {$(debug,place)} { puts "place $w.scrolled -in $w -x [expr {-$vleft}] -width $_width" } ;#DEBUG
          } else {
            place $w.scrolled -in $w -x [expr {-$vleft}] -width {}
            if {$(debug,place)} { puts "place $w.scrolled -in $w -x [expr {-$vleft}] -width {}" } ;#DEBUG
          }

        }
      }

  # -------------
  # yview
  #
  # called on vertical scrolling
  # -------------
  # parm1: widget path
  # parm2: optional moveto or scroll
  # parm3: fraction if parm2 == moveto, count unit if parm2 == scroll
  # -------------
  # return: scrolling info if parm2 is empty
  # -------------
  proc yview {w {cmd ""} args} \
      {
        variable {}
        # check args
        set len [llength $args]
        switch -glob -- $cmd \
        {
          ""      {set args {}}
          mov*    \
          { if {$len != 1} { error "wrong # args: should be \"$w yview moveto fraction\"" } }
          scr*    \
          { if {$len != 2} { error "wrong # args: should be \"$w yview scroll count unit\"" } }
          default \
          { error "unknown operation \"$cmd\": should be empty, moveto or scroll" }
        }
        # save old values
        set _vtop $($w:vtop)
        set _vheight $($w:vheight)
        #    set _height [winfo height $w]
        set _height $($w:height)
        # compute new vtop
        set count ""
        switch $len \
        {
          0       \
          {
            # return fractions
            if {$_vheight == 0} { return {0 1} }
            set first [expr {double($_vtop) / $_vheight}]
            set last [expr {double($_vtop + $_height) / $_vheight}]
            if {$last > 1.0} { return {0 1} }
            return [list [format %g $first] [format %g $last]]
          }
          1       \
          {
            # absolute movement
            set vtop [expr {int(double($args) * $_vheight)}]
          }
          2       \
          {
            # relative movement
            foreach {count unit} $args break
            if {[string match p* $unit]} { set count [expr {$count * 9}] }
            set vtop [expr {$_vtop + $count * 0.1 * $_height}]
          }
        }
        if {$vtop + $_height > $_vheight} { set vtop [expr {$_vheight - $_height}] }
        if {$vtop < 0} { set vtop 0 }
        if {$vtop != $_vtop || $count == 0} \
        {
          set ($w:vtop) $vtop
          yset $w
          if {$($w:filly) && ($_vheight < $_height || $($w:yscroll) == "")} {
            # "scrolled object" is not scrolled, because it is too small or because no scrollbar was requested
            # filly means that, in these cases, we must tell the object what its height should be
            place $w.scrolled -in $w -y [expr {-$vtop}] -height $_height
            if {$(debug,place)} { puts "place $w.scrolled -in $w -y [expr {-$vtop}] -height $_height" } ;#DEBUG
          } else {
            place $w.scrolled -in $w -y [expr {-$vtop}] -height {}
            if {$(debug,place)} { puts "place $w.scrolled -in $w -y [expr {-$vtop}] -height {}" } ;#DEBUG
          }
        }
      }

  # end of ::scrolledframe namespace definition
}
