###
### misc.tcl: part of Scid.
### Copyright (C) 2001  Shane Hudson.
### Copyright (C) 2007  Pascal Georges
###
### Miscellaneous routines called by other Tcl functions

################################################################################
# vwait but will timeout after a delay. Var must be fully qualified (::)
################################################################################
proc vwaitTimed { var {delay 0} {warn "warnuser"} } {

  proc trigger {var warn} {
    if {$warn == "warnuser"} {
      tk_messageBox -type ok -icon error -parent . -title "Protocol error" -message "vwait timeout for $var"
    }
    set $var 1
  }

  if { $delay != 0 } {
    set timerId [after $delay "trigger $var $warn"]
  }

  vwait $var

  if [info exists timerId] { after cancel $timerId }

}

################################################################################
# bindFocusColors:
#   Configures a text or entry widget so it turns lightYellow when it
#   gets the focus, and turns white again when it loses focus.
#
# THIS IS CURRENTLY DISABLED since it works fine with regular entry widgets
# but causes problems with our combobox widgets, not sure why!
#
proc bindFocusColors {w {inColor lightYellow} {outColor white}} {
  $w configure -background $outColor
  #bind $w <FocusIn> "+$w configure -background $inColor"
  #bind $w <FocusOut> "+$w configure -background $outColor"
}


# bindMouseWheel:
#   Given a window and a text frame within that window, binds
#   the mouse wheel to scroll the text frame vertically.
#
proc bindMouseWheel {win text} {
  if {$::windowsOS || $::macOS} {
    bind $win <Shift-MouseWheel> {break}
    bind $win <MouseWheel> "$text yview scroll \[expr -(%D / 120)\] units"
  } else {
    bind $win <Button-4> [list $text yview scroll -1 units]
    bind $win <Button-5> [list $text yview scroll  1 units]
  }
}

# dialogbuttonframe:
#   Creates a frame that will be shown at the bottom of a
#   dialog window. It takes two parameters: the frame widget
#   name to create, and a list of button args. Each element
#   should contain a widget name, and button arguments.
#
proc dialogbuttonframe {frame buttonlist} {
  frame $frame
  set bnames {}
  set maxlength 0
  foreach buttonargs $buttonlist {
    set bname $frame.[lindex $buttonargs 0]
    set bargs [lrange $buttonargs 1 end]
    eval button $bname $bargs
    set bnames [linsert $bnames 0 $bname]
    set length [string length [$bname cget -text]]
    if {$length > $maxlength} { set length $maxlength}
  }
  if {$maxlength < 7} { set maxlength 7 }
  foreach b $bnames {
    $b configure -width $maxlength -padx 4
    pack $b -side right -padx 4 -pady 4
  }
}

# packbuttons
#   Packs a row of dialog buttons to the left/right of their frame
#   with a standard amount of padding.
#
proc packbuttons {side args} {
  eval pack $args -side $side -padx 5 -pady 3
}

# dialogbutton:
#   Creates a button that will be shown in a dialog box, so it
#   is given a minumin width.
#
proc dialogbutton {w args} {
  set retval [eval button $w $args]
  set length [string length [$w cget -text]]
  if {$length < 7} { set length 7 }
  $w configure -width $length -pady 1
  return retval
}

# autoscrollframe
#   Creates and returns a frame containing a widget which is gridded
#   with scrollbars that automatically hide themselves when they are
#   not needed.
#   The frame and widget may already exist; they are created if needed.
#
#   Usage:
#      autoscrollframe [-bars none|x|y|both] frame type w args
#      autoscrollframe                .gameInfoFrame text .gameInfo

proc autoscrollframe {args} {
  global _autoscroll
  set bars both
  if {[lindex $args 0] == "-bars"} {
    set bars [lindex $args 1]
    if {$bars != "x" && $bars != "y" && $bars != "none" && $bars != "both"} {
      return -code error "Invalid parameter: -bars $bars"
    }
    set args [lrange $args 2 end]
  }
  if {[llength $args] < 3} {
    return -code error "Insufficient number of parameters"
  }
  set frame [lindex $args 0]
  set type [lindex $args 1]
  set w [lindex $args 2]
  set args [lrange $args 3 end]

  set retval $frame
  if {! [winfo exists $frame]} {
    frame $frame
    $frame configure -relief sunken -borderwidth 2
  }
  if {! [winfo exists $w]} {
    $type $w
    if {[llength $args] > 0} {
      eval $w configure $args
    }
    $w configure -relief flat -borderwidth 0
  }

  grid $w -in $frame -row 0 -column 0 -sticky news
  set setgrid 0
  catch {set setgrid [$w cget -setgrid]}

  if {$bars == "y"  ||  $bars == "both"} {
    scrollbar $frame.ybar -command [list $w yview] -takefocus 0 -borderwidth 1
    $w configure -yscrollcommand [list _autoscroll $frame.ybar]
    grid $frame.ybar -row 0 -column 1 -sticky ns
    set _autoscroll($frame.ybar) 1
    set _autoscroll(time:$frame.ybar) [clock clicks -milli]
    # set _autoscroll(time:$frame.ybar) 0
    if {! $setgrid} {
      # bind $frame.ybar <Map> [list _autoscrollMap $frame]
    }
  }
  if {$bars == "x"  ||  $bars == "both"} {
    scrollbar $frame.xbar -command [list $w xview] -takefocus 0 \
        -borderwidth 1 -orient horizontal
    $w configure -xscrollcommand [list _autoscroll $frame.xbar]
    grid $frame.xbar -row 1 -column 0 -sticky we
    set _autoscroll($frame.xbar) 1
    set _autoscroll(time:$frame.xbar) [clock clicks -milli]
    if {! $setgrid} {
      # bind $frame.xbar <Map> [list _autoscrollMap $frame]
    }
  }
  grid rowconfigure $frame 0 -weight 1
  grid columnconfigure $frame 0 -weight 1
  grid rowconfigure $frame 1 -weight 0
  grid columnconfigure $frame 1 -weight 0
  return $retval
}

array set _autoscroll {}

# _autoscroll
#   This is the "set" command called for auto-scrollbars.
#   If the bar is shown but should not be, it is hidden.
#   If the bar is hidden but should be shown, it is redrawn.
#   Note that once a bar is shown, it will not be removed again for
#   at least a few milliseconds; this is to overcome problematic
#   interactions between the x and y scrollbars where hiding one
#   causes the other to be shown etc. This usually happens because
#   the stupid Tcl/Tk text widget doesn't handle scrollbars well.
#
proc _autoscroll {bar args} {
  global _autoscroll

  if {[llength $args] == 2} {
    set min [lindex $args 0]
    set max [lindex $args 1]
    ### 0.95 should really be 1.0 but because of font size variation (or something !?)
    ### we're using 0.95 to stop shuffling in/and of y scrollbar S.A.
    # eg: _autoscroll .gameInfoFrame.ybar 0.0 1.0
    #     _autoscroll .gameInfoFrame.ybar 0.0 0.9882352941176471
    if {$min > 0.0  ||  $max < 0.97} {
      if {! $_autoscroll($bar)} {
        grid configure $bar
        set _autoscroll($bar) 1
        set _autoscroll(time:$bar) [clock clicks -milli]
      }
    } else {
      if {[clock clicks -milli] > [expr {$_autoscroll(time:$bar) + 100}]} {
	grid remove $bar
	set _autoscroll($bar) 0
      }
    }
    # update idletasks
  }
  # Sometimes lingering _autoscrolls persist after scrollbars are destroyed
  catch {eval $bar set $args}
}

proc _autoscrollMap {frame} {
  # wm geometry [winfo toplevel $frame] [wm geometry [winfo toplevel $frame]]
}


# busyCursor, unbusyCursor:
#   Sets all cursors to watch (indicating busy) or back to their normal
#   setting again.

array set scid_busycursor {}
set scid_busycursorState 0

proc doBusyCursor {w flag} {
  global scid_busycursor
  if {! [winfo exists $w]} { return }
  # The comment editor window "flashes" when its cursor is changed,
  # no idea why but skip over it:
  if {$w == ".commentWin"} { return }
  if {[winfo class $w] == "Menu"} { return }

  if {$flag} {
    if { [ catch { set scid_busycursor($w) [$w cget -cursor] } ] } {
      return
    }
    catch {$w configure -cursor watch}
  } else {
    catch {$w configure -cursor $scid_busycursor($w)} err
  }
  foreach i [winfo children $w] { doBusyCursor $i $flag }
}

proc busyCursor {w {flag 1}} {
  global scid_busycursor scid_busycursorState
  if {$scid_busycursorState == $flag} { return }
  set scid_busycursorState $flag
  doBusyCursor $w $flag
}

proc unbusyCursor {w} {busyCursor $w 0}


# addHorizontalRule, addVerticalRule
#   Add a horizontal/vertical rule frame to a window.
#   The optional parameters [x/y]padding and sunken allow the spacing and
#   appearance of the rule to be specified.
#
set horizRuleCounter 0
set vertRuleCounter 0

proc addHorizontalRule {w {ypadding 5} {relief sunken} {height 2} } {
  global horizRuleCounter
  set f [ frame $w.line$horizRuleCounter -height $height -borderwidth 2 \
      -relief $relief  ]
  pack $f -fill x -pady $ypadding
  incr horizRuleCounter
  return $f
}

proc addVerticalRule {w {xpadding 5} {relief sunken}} {
  global vertRuleCounter
  set f [ frame $w.line$vertRuleCounter -width 2 -borderwidth 2 \
      -relief $relief  ]
  pack $f -fill y -padx $xpadding -side left
  incr vertRuleCounter
  return $f
}


# progressWindow:
#   Creates a window with a label, progress bar, and (if specified),
#   a cancel button and cancellation command.

proc progressWindow {args} {
  set w .progressWin
  if {[winfo exists $w]} { return }
  toplevel $w
  wm withdraw $w
  wm resizable $w 0 0

  if {[llength $args] == 2} {
    set title [lindex $args 0]
    set text [lindex $args 1]
    set b 0
  } elseif {[llength $args] == 4} {
    set title [lindex $args 0]
    set text [lindex $args 1]
    set button [lindex $args 2]
    set command [lindex $args 3]
    set b 1
  } else {
    ::splash::add "progressWindow: wrong number of args" error
    return
  }
  wm title $w $title

  # This is the best way to keep win on top, but
  # has the effect of raising .main after progressWin closes :(
  # We need a parent arg
  wm transient $w .main

  label $w.t -text $text
  pack $w.t -side top
  canvas $w.c -width 400 -height 20  -relief solid -border 1
  $w.c create rectangle 0 0 0 0 -fill $::progcolor -outline $::progcolor -tags bar
  $w.c create text 395 10 -anchor e -font font_Regular -tags time \
      -fill black -text "0:00 / 0:00"
  pack $w.c -side top -pady 10
  if {$b} {
    pack [frame $w.b] -side bottom -fill x
    button $w.b.cancel -text $button -command $command
    pack $w.b.cancel -side right -padx 5 -pady 2
  } else {
    wm protocol $w WM_DELETE_WINDOW {puts {progressWindow Destroy caught}}
  }

  sc_progressBar $w.c bar 401 21 time

  placeWinOverParent $w .
  update idletasks
  wm deiconify $w
  raiseWin $w
  if {$b} {
    catch { grab $w.b.cancel }
  } else {
    grab $w
  }
  # This raises above whole desktop on KDE. Bad!
  # but not sure of best way to do it.
  # Perhaps on other WMs, the problems not so bad
  # bind $w <Visibility> "raiseWin $w"
  # wm attributes $w -topmost 1
  ## This is achieved by transient above

  set ::progressWin_time [clock seconds]
}

proc leftJustifyProgressWindow {} {
  set w .progressWin
  if {! [winfo exists $w]} { return }
  pack configure $w.t -fill x
  $w.t configure -width 1 -anchor w
}

proc changeProgressWindow {newtext} {
  set w .progressWin
  if {[winfo exists $w]} {
    $w.t configure -text $newtext
    update idletasks
  }
}

proc resetProgressWindow {} {
  set w .progressWin
  set ::progressWin_time [clock seconds]
  if {[winfo exists $w]} {
    $w.c coords bar 0 0 0 0
    $w.c itemconfigure time -text "0:00 / 0:00"
    update idletasks
  }
}

proc updateProgressWindow {done total} {
  set w .progressWin
  if {! [winfo exists $w]} { return }
  set elapsed [expr {[clock seconds] - $::progressWin_time}]
  set width 401
  if {$total > 0} {
    set width [expr {int(double($width) * double($done) / double($total))}]
  }
  $w.c coords bar 0 0 $width 21
  set estimated $elapsed
  if {$done != 0} {
    set estimated [expr {int(double($elapsed) * double($total) / double($done))}]
  }
  set t [format "%d:%02d / %d:%02d" \
      [expr {$elapsed / 60}] [expr {$elapsed % 60}] \
      [expr {$estimated / 60}] [expr {$estimated % 60}]]
  $w.c itemconfigure time -text $t
  update idletasks
}

proc closeProgressWindow {} {
  set w .progressWin
  if {! [winfo exists $w]} {
    # puts stderr "Hmm, no progress window -- bug?"
    return
  }
  grab release $w
  destroy $w
  focus .main
}

proc checkState {arg args} {
  if {[set $arg]} {
    set state normal
  } else {
    set state disabled
  }
  foreach widget $args {
    $widget configure -state $state
  }
}

proc setClipboard {string} {

  if {$string == {}} {return}

  # Create a text widget to hold the string so it can be the owner of the current text selection
  set w .clipboard
  if {! [winfo exists $w]} { text $w }
  $w delete 1.0 end
  $w insert end $string sel
  clipboard clear
  clipboard append $string
  selection own $w
  selection get
}

################################################################################
# clock widget
################################################################################
namespace eval gameclock {

  array set data {}

  proc new { parent n { size 100 } {showfall 0} {aspect horizontal} {type both}} {
  # n is either 1 or 2, but extra clocks could be numbered 3,4 (for eg)
  # type can be analog, digital or both 
    global ::gameclock::data
    set data(showfallen$n) $showfall
    set data(id$n) $parent.clock$n
    set data(type$n) $type
    if {$data(type$n) == "digital"} {
      canvas $data(id$n) -height [expr $size/3] -width $size
    } else {
      canvas $data(id$n) -height $size -width $size
    }

    if {$aspect == "horizontal"} {
      if { $n % 2 } {
	  pack $data(id$n) -side left -padx 10 -pady 10
      } else {
	  pack $data(id$n) -side right -padx 10 -pady 10
      }
    } else {
      pack $data(id$n) -side top -anchor center -pady 5
    }

    if {$data(type$n) != "digital"} {
      ### Draw digits 1 to 12 (tagged with "clock")
      # The hands and digitalcounter are drawn in {proc draw}, and tagged "aig"
      # Initially they are both neutral colour, and are given white/black by {proc setColor}

      for {set i 1} {$i<13} {incr i} {
	set a [expr {$i/6.*acos(-1)}]
	set x [expr { ($size/2 + (($size-15)/2)*sin($a) ) }]
	set y [expr { ($size/2 - (($size-15)/2)*cos($a) ) }]
	$data(id$n) create text $x $y -text $i -tag clock -font font_Small
      }
    }
    set data(fg$n) "black"
    set data(running$n) 0
    ::gameclock::reset $n
    ::gameclock::draw $n
    bind $data(id$n) <Button-1> "::gameclock::toggleClock $n"
  }

  proc draw { n } {
    global ::gameclock::data
    if {! [winfo exists $data(id$n)]} { return }

    $data(id$n) delete aig

    set w [$data(id$n) cget -width ]
    set h [$data(id$n) cget -height ]
    set cx [ expr $w / 2 ]
    set cy [ expr $h / 2 ]
    if {$w < $h} {
      set size [ expr $w - 15 ]
    } else  {
      set size [ expr $h - 15 ]
    }

    set sec $data(counter$n)
    if { $sec > 0 && $data(showfallen$n) } {
      set color "red"
    } else  {
      set color $::gameclock::data(fg$n)
    }

    if {$color == "white"} {set fg "black"} else {set fg "white"}

    # Analog hands
    if {$data(type$n) != "digital"} {
      foreach divisor {30 1800 21600} length "[expr $size/2 * 0.8] [expr $size/2 * 0.7] [expr $size/2 * 0.4]" \
	  width {1 2 3} {
	    set angle [expr {$sec * acos(-1) / $divisor}]
	    set x [expr {$cx + $length * sin($angle)}]
	    set y [expr {$cy - $length * cos($angle)}]
	    $data(id$n) create line $cx $cy $x $y -width $width -tags aig -fill $color
	  }
    }

    # Digital
    if {$data(type$n) != "analog"} {
      set m [format "%02d" [expr abs($sec) / 60] ]
      set s [format "%02d" [expr abs($sec) % 60] ]
      if {$data(type$n) == "both"} {
        set y [expr $cy + $size/4]
      } else {
        set y $cy
      }
      set data(time$n) $m:$s

      $data(id$n) create text $cx $y -text $data(time$n) -anchor center -fill $color -tag aig -font font_Regular
    }
  }

  proc every {ms body n} {
    incr ::gameclock::data(counter$n)
    eval $body
    if {[winfo exists $::gameclock::data(id$n)]} {
      set ::gameclock::after$n [after $ms [info level 0]]
    }
  }

  proc getSec { n } {
    return [expr 0 - $::gameclock::data(counter$n)]
  }

  proc setSec { n value } {
    set ::gameclock::data(counter$n) $value
    ::gameclock::draw $n
  }

  proc add { n value } {
    set ::gameclock::data(counter$n) [ expr $::gameclock::data(counter$n) - $value ]
    ::gameclock::draw $n
  }

  proc reset { n } {
    ::gameclock::stop $n
    set ::gameclock::data(counter$n) 0
  }

  proc start { n } {
    if {$::gameclock::data(running$n)} { return }
    set ::gameclock::data(running$n) 1

    set ::gameclock::after$n [after 1000 "::gameclock::every 1000 \"draw $n\" $n"]
  }

  proc stop { n } {
    if {! $::gameclock::data(running$n)} { return }
    set ::gameclock::data(running$n) 0
    after cancel [set ::gameclock::after$n]
  }

  proc toggleClock { n } {
    if { $::gameclock::data(running$n) } {
      stop $n
    } else  {
      start $n
    }
  }

  # Should this be in ::clock::new ?

  proc setColor { n color } {
    if {$color == "white"} {
      set fg "black"
      set bg "white"
    } else {
      set fg "white"
      set bg "black"
    }
    set ::gameclock::data(fg$n) $fg
    $::gameclock::data(id$n) configure -background $bg
    $::gameclock::data(id$n) itemconfigure clock -fill $fg
    $::gameclock::data(id$n) itemconfigure aig -fill $fg
  }
}

################################################################################
# html generation
################################################################################
namespace eval html {
  set data {}
  set idx 0
  set black_square "#7389b6"
  set white_square "#f3f3f3"


  ### Export filter to HTML and Javascript

  proc exportCurrentFilter {} {
    # Check that we have some games to export:
    if {![sc_base inUse]} {
      tk_messageBox -title "Scid: Empty database" -type ok -icon info \
          -message "This is an empty database, there are no games to export."
      return
    }
    if {[sc_filter count] == 0} {
      tk_messageBox -title "Scid: Filter empty" -type ok -icon info \
          -message "The filter contains no games."
      return
    }
    set ftype {
      { "HTML files" {".html" ".htm"} }
      { "All files" {"*"} }
    }
    set idir $::initialDir(html)
    set fName [tk_getSaveFile -initialdir $idir -filetypes $ftype -defaultextension ".html" -title "Create an HTML file"]
    if {$fName == ""} { return }
    set prefix [file rootname [file tail $fName] ]
    set dirtarget [file dirname $fName]
    set sourcedir [file join $::scidShareDir html]
    ### catch copies to ignore overwrite directory errors
    catch { file copy -force [file join $sourcedir bitmaps] $dirtarget }
    catch { file copy -force [file join $sourcedir scid.js] $dirtarget }
    catch { file copy -force [file join $sourcedir scid.css] $dirtarget }
    writeIndex "[file join $dirtarget $prefix].html" $prefix
    progressWindow "Scid" "Exporting games..." $::tr(Stop) "sc_progressBar"
    busyCursor .
    set savedGameNum [sc_game number]
    set gn [sc_filter first]
    set players {}
    set ::html::cancelHTML 0
    set idx 1
    set total [sc_filter count]

    while {$gn != 0 && ! $::html::cancelHTML} {
      updateProgressWindow $idx $total
      sc_game load $gn
      fillData
      set pl "[sc_game tags get White] - [sc_game tags get Black]"
      lappend players $pl
      toHtml $::html::data $idx $dirtarget $prefix $pl [sc_game tags get "Event"] [sc_game tags get "ECO"] [sc_game info result] [sc_game tags get "Date"]
      set gn [sc_filter next]
      incr idx
    }

    navhtml $dirtarget $players $prefix
    closeProgressWindow
    unbusyCursor .
    exportPGN "[file join $dirtarget $prefix].pgn" "filter"
    sc_game load $savedGameNum
  }
  ################################################################################
  proc sc_progressBar {} {
    set ::html::cancelHTML 1
  }

  ### Export current game to HTML and Javascript

  proc exportCurrentGame {} {

    set ftype {
      { "HTML files" {".html" ".htm"} }
      { "All files" {"*"} }
    }
    set idir $::initialDir(html)
    set fName [tk_getSaveFile -initialdir $idir -filetypes $ftype -defaultextension ".html" -title "Create an HTML file"]
    if {$fName == ""} { return }
    set prefix [file rootname [file tail $fName] ]
    set dirtarget [file dirname $fName]
    set sourcedir [file join $::scidShareDir html]
    ### catch copies to ignore overwrite directory errors
    catch { file copy -force [file join $sourcedir bitmaps] $dirtarget }
    catch { file copy -force [file join $sourcedir scid.js] $dirtarget }
    catch { file copy -force [file join $sourcedir scid.css] $dirtarget }
    writeIndex "[file join $dirtarget $prefix].html" $prefix

    fillData
    set players [list "[sc_game tags get White] - [sc_game tags get Black]"]
    navhtml $dirtarget $players $prefix
    toHtml $::html::data 1 $dirtarget $prefix $players \
        [sc_game tags get "Event"] [sc_game tags get "ECO"] \
        [sc_game info result] [sc_game tags get "Date"]
    exportPGN "[file join $dirtarget $prefix].pgn" "current"
  }

  ################################################################################
  proc toHtml { dt game dirtarget prefix {players ""} {event ""} {eco "ECO"} {result "*"} {date ""} } {
    set f [open "[file join $dirtarget $prefix]_${game}.html" w]
    # header
    puts $f "<html>"
    puts $f "<head>"
    puts $f "<meta content=\"text/html; charset=ISO-8859-1\" http-equiv=\"content-type\">"
    puts $f "<title>Scid</title>"
    puts $f "<meta content=\"Scid\" name=\"author\">"
    puts $f "<link rel=\"stylesheet\" type=\"text/css\" href=\"scid.css\">"
    puts $f "<script SRC=\"scid.js\" LANGUAGE=\"JavaScript1.1\"></script>"
    puts $f "</head>"
    puts $f "<body ONLOAD=\"doinit()\" TEXT=\"#000000\" LINK=\"#000000\" VLINK=\"#000000\" ALINK=\"#000000\" BGCOLOR=\"#ECECEC\" onKeyDown=\"handlekey(event)\">"
    puts $f "<p>"
    puts $f "<font COLOR=\"#000000\">"
    puts $f "<script LANGUAGE=\"JavaScript1.1\">"
    puts $f "<!--"
    puts $f "movesArray = new Array("
    for {set i 0} {$i<[llength $dt]} {incr i} {
      array set elt [lindex $dt $i]
      puts -nonewline $f "\"$elt(fen) $elt(prev) $elt(next)\""
      if {$i < [expr [llength $dt] -1]} { puts $f "," }
    }
    puts $f ");"
    puts $f "var current = 0;"
    puts $f "var prefix = \"$prefix\";"
    puts $f "//-->"
    puts $f "</script>"
    puts $f "<NOSCRIPT>You need to have Javascript enabled in your browser to see this page.</NOSCRIPT>"
    # game header
    puts $f "<span class=\"hPlayers\">$players</span>"
    puts $f "<br>"
    puts $f "<span class=\"hEvent\"><br>$event \($date\)</span>"
    if {[sc_game startBoard]} {
      puts $f "<br>"
      puts $f "[sc_game startPos]"
    }
    puts $f "<br><br>"

    # link moves
    set prevdepth 0
    set prevvarnumber 0

    # These 'dots' are purely for use with diagrams
    set dots 0

    for {set i 0} {$i<[llength $dt]} {incr i} {
      array set elt [lindex $dt $i]
      if {$elt(depth) == 0} {
        set class "V0"
      } elseif {$elt(depth) == 1} {
        set class "V1"
      } else  {
        set class "V2"
      }
      if {$prevdepth != $elt(depth) || $prevvarnumber != $elt(var)} {
        if {$prevdepth != 0} { puts $f "\]" }
        puts $f "<br>"
        for {set j 0} {$j<$elt(depth)} {incr j} {puts $f "&nbsp; &nbsp; "}
        if {$elt(depth) != 0} { puts $f "\[" }
      }
      set prevdepth $elt(depth)
      set prevvarnumber $elt(var)
      if {$dots > 0} {
	puts $f "<a href=\"javascript:gotoMove($elt(idx))\" ID=\"$elt(idx)\" class=\"$class\">$dots. ... $elt(move)</a>$elt(nag) <span class=\"VC\">$elt(comment)</span>"
        set dots 0
      } else {
	puts $f "<a href=\"javascript:gotoMove($elt(idx))\" ID=\"$elt(idx)\" class=\"$class\">$elt(move)</a>$elt(nag) <span class=\"VC\">$elt(comment)</span>"
      }
      if {$elt(diag)} {
        insertMiniDiag $elt(fen) $f
	set dots 0
	scan $elt(move) %i. dots
      }
    }
    if {$prevdepth != 0} {puts $f "\]"}

    # <a href="javascript:gotoMove(1)" ID="1" class="V0">1.Rd8</a>
    puts $f "<br><class=\"VH\">$result"
    puts $f "</font>"
    puts $f "</p>"
    puts $f "<font size=-2><a href=\"http://scid.sourceforge.net/\" target=_blank>Created with $::scidName - $::scidVersion</a></font>"
    puts $f "</body>"
    puts $f "</html>"
    close $f
  }
  ################################################################################
  proc colorSq {sq} {
    if { [expr $sq % 2] == 1 && [expr int($sq / 8) %2 ] == 0 || [expr $sq % 2] == 0 && [expr int($sq / 8) %2 ] == 1 } {
      return $::html::black_square
    } else {
      return $::html::white_square
    }
  }
  ################################################################################
  proc piece2gif {piece} {
    if {$piece == "K"} { return "wk" }
    if {$piece == "k"} { return "bk" }
    if {$piece == "Q"} { return "wq" }
    if {$piece == "q"} { return "bq" }
    if {$piece == "R"} { return "wr" }
    if {$piece == "r"} { return "br" }
    if {$piece == "B"} { return "wb" }
    if {$piece == "b"} { return "bb" }
    if {$piece == "N"} { return "wn" }
    if {$piece == "n"} { return "bn" }
    if {$piece == "P"} { return "wp" }
    if {$piece == "p"} { return "bp" }
    if {$piece == " "} { return "sq" }
  }
  ################################################################################
  proc insertMiniDiag {fen f} {

    set square 0
    set space " "
    puts $f "<table Border=0 CellSpacing=0 CellPadding=0><tr>"

    for {set i 0} {$i < [string length $fen]} {incr i} {
      set l [string range $fen $i $i ]
      set res [scan $l "%d" c]
      if {$res == 1} {
        if  { $c >= 1 && $c <= 8 } {
          for { set j 0} {$j < $c} {incr j} {
            puts $f "<td bgcolor= [colorSq $square ] ><img border=0 src=bitmaps/mini/[piece2gif $space].gif </td>"
            incr square
          }
        }
      } elseif {$l == "/"}  {
        puts $f "</tr><tr>"
      } else  {
        puts $f "<td bgcolor= [colorSq $square ] ><img border=0 src=bitmaps/mini/[piece2gif $l].gif </td>"
        incr square
      }
    }

    puts $f "</tr></table>"
    puts $f "</body></html>"
  }

  ################################################################################
  # generate nav.html
  proc navhtml { dirtarget players prefix } {
    set f [open "[file join $dirtarget ${prefix}_nav.html]" w]
    puts $f "<body BGCOLOR=\"#d7d7d7\">"
    puts $f "<table ALIGN='CENTER'>"
    puts $f "<td VALIGN='TOP'>"
    puts $f "<center>"
    puts $f "<form NAME='formgames'>"
    puts $f "<input TYPE='button' VALUE=' o ' ONCLICK='parent.moves.rotate()'>"
    puts $f "<input TYPE='button' VALUE=' |&lt; ' ONCLICK='parent.moves.jump(0)'>"
    puts $f "<input TYPE='button' VALUE=' &lt; '  ONCLICK='parent.moves.moveForward(0)'>"
    puts $f "<input TYPE='button' VALUE=' &gt; '  ONCLICK='parent.moves.moveForward(1)'>"
    puts $f "<input TYPE='button' VALUE=' &gt;| ' ONCLICK='parent.moves.jump(1)'>"
    puts $f "</center>"
    puts $f "</td>"
    puts $f "</table>"

    puts $f "<center>"
    puts $f "<select NAME=\"gameselect\" ID=\"gameselect\" SIZE=1 WIDTH=244 ONCHANGE='parent.moves.gotogame()'>"
    set i 1
    foreach l $players {
      puts $f "<option>$i. $l"
      incr i
    }
    puts $f "</select>"
    puts $f "<nobr>"
    puts $f "<input TYPE=\"button\" VALUE=\"&lt;--\" ONCLICK=\"parent.moves.gotoprevgame()\">"
    puts $f "<input TYPE=\"button\" VALUE=\"--&gt;\" ONCLICK=\"parent.moves.gotonextgame()\">"
    puts $f "</nobr>"
    puts $f "</center>"
    puts $f "</form>"
    puts $f "<br><CENTER><a href=\"${prefix}.pgn\">${prefix}.pgn</a></CENTER>"
    puts $f "</body>"

    close $f
  }
  ################################################################################
  # fill data with { idx FEN prev next move nag comment depth }
  proc fillData {} {
    set ::html::data {}
    set ::html::idx -1
    sc_move start
    parseGame
  }

  ################################################################################
  proc parseGame { {prev -2} {dots unknown} } {
    global ::html::data ::html::idx


    while {1} {

    if {$dots == "unknown"} {
      recordElt $prev 0
      set prev -2
      set dots [expr {[sc_pos side] == "black"}]
    } else {
      recordElt $prev $dots
      set prev -2
      set dots 0
    }
      
      # handle variants
      if {[sc_var count]>0} {
        if { ![sc_pos isAt vend]} {
          sc_move forward
          recordElt
          set lastIdx $idx
          sc_move back
        }
        set dots 1
        for {set v 0} {$v<[sc_var count]} {incr v} {
          sc_var enter $v
          sc_move back
          parseGame $idx unknown
          sc_var exit
        }
        if { ![sc_pos isAt vend] } { sc_move forward }
        #update the "next" token
        array set elt [lindex $data $lastIdx]
        set elt(next) [expr $idx + 1]
        lset data $lastIdx [array get elt]
        #update the "previous" token
        set prev $lastIdx
      }
      
      if {[sc_pos isAt vend]} { break }
      sc_move forward
    }
  }
  ################################################################################
  proc recordElt { {prev -2} {dots 0} } {
    global ::html::data ::html::idx

    array set elt {}

    incr idx
    set elt(idx) $idx
    set elt(fen) [lindex [split [sc_pos fen]] 0]
    if {$prev != -2} {
      set elt(prev) $prev
    } else  {
      set elt(prev) [expr $idx-1]
    }

    set nag [sc_pos getNags]
    if {$nag == "0"} { set nag "" }
    if {[string match "*D *" $nag] || [string match "*# *" $nag]} {
      set elt(diag) 1
    } else  {
      set elt(diag) 0
    }
    set nag [regsub -all "D " $nag "" ]
    set nag [regsub -all "# " $nag "" ]
    set elt(nag) $nag
    set comment [sc_pos getComment]
    set comment [regsub -all "\[\x5B\]%draw (.)+\[\x5D\]" $comment ""]
    set elt(comment) $comment
    set elt(depth) [sc_var level]
    set elt(var) [sc_var number]
    if {![sc_pos isAt vend]} {
      set elt(next) [expr $idx +1 ]
    } else  {
      set elt(next) -1
    }

    set m [sc_game info previousMove]
    set mn [sc_pos moveNumber]

    if {[sc_pos side] == "black" && $m != {}} {
      set elt(move) "$mn.$m"
    } else {
      if {$dots && $m != {}} {
        set elt(move) "[expr $mn -1]. ... $m"
      } else  {
        set elt(move) $m
      }
    }

    lappend ::html::data [array get elt]

  }

  ################################################################################
  proc writeIndex {fn prefix} {
    set f [open $fn w]
    puts $f "<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">"
    puts $f "<html>"
    puts $f "<head>"
    puts $f "<meta content=\"text/html; charset=ISO-8859-1\" http-equiv=\"content-type\">"
    puts $f "<title>Scid</title>"
    puts $f "<meta content=\"Scid\" name=\"author\">"
    puts $f "</head>"
    puts $f "<frameset BORDER=\"0\" FRAMEBORDER=\"0\" FRAMESPACING=\"0\" COLS=\"380,*\">"
    puts $f "<frameset BORDER=\"0\" FRAMEBORDER=\"0\" FRAMESPACING=\"0\" ROWS=\"380,*\">"
    puts $f "<frame NAME=\"diagram\" SCROLLING=\"Auto\">"
    puts $f "<frame NAME=\"nav\" SRC=\"${prefix}_nav.html\" SCROLLING=\"Auto\">"
    puts $f "</frameset>"
    puts $f "<frame NAME=\"moves\" SRC=\"${prefix}_1.html\" SCROLLING=\"Auto\">"
    puts $f "</frameset>"
    puts $f "</html>"
    close $f
  }
  ################################################################################
  proc exportPGN { fName selection } {
    if {$selection == "filter"} {
      progressWindow "Scid" "Exporting games..." $::tr(Stop) "sc_progressBar"
    }
    busyCursor .
    sc_base export $selection "PGN" $fName -append 0 -starttext "" -endtext "" -comments 1 -variations 1 \
        -space 1 -symbols 1 -indentC 0 -indentV 0 -column 0 -noMarkCodes 1 -convertNullMoves 1
    unbusyCursor .
    if {$selection == "filter"} {
      closeProgressWindow
    }
  }  
} 
# end of html namespace

### Merges ::optable::previewLaTeX and ::preport::previewLaTeX
#   TODO : test on windows and OS X

proc previewLatex {filename command parent} {
  
  busyCursor $parent
  update
  
  # config file names
  set tmpdir $::scidLogDir    
  set texfile $filename.tex
  set dvifile $filename.dvi    
  set fname [file join $tmpdir $filename]
  set pdffile "$fname.pdf"
  set latexLog "$fname.log"

  # Null command means that $filename.tex is already generated.
  if {$command != ""} {
    file delete $fname.tex
    
    if {[catch {set filedes [open $fname.tex w]}]} {
      tk_messageBox -title "Scid: Error writing report" -type ok -icon warning \
	  -message "Unable to write the file: $fname.tex" -parent pw
      unbusyCursor .
      return
    }

    puts $filedes [eval $command]
    close $filedes
  }

  # Defaults are set in tcl/start.tcl

  if {$::latexRendering(engine) == ""} {
    set latexEngine $::default_latexRendering(engine)
  } else {
    set latexEngine $::latexRendering(engine)
  }

  if {$::latexRendering(viewer) == ""} {
    set latexViewer $::default_latexRendering(viewer)
  } else {
    set latexViewer $::latexRendering(viewer)
  }

  set err_engine "Unable to generate the report with command \"$latexEngine\".\n
Edit Options->Exporting->Latex to change the engine.\n
See $fname.log for details."

  set err_viewer "Unable to view the report with viewer \"$latexViewer\".\n
Edit Options->Exporting->Latex to change viewer.\n
See $fname.log for details."


  if {$::windowsOS} {
      if {[catch {exec $::env(ComSpec) /c "cd '$tmpdir'  & $latexEngine '$texfile'" >& $latexLog }]} {             
        tk_messageBox -title "Scid Error" -icon warning -type ok -parent $parent -message $err_engine
      } else {
        if {[catch {exec $::env(ComSpec) /c "$latexViewer $pdffile" >& $latexLog &}]} {
            tk_messageBox -title "Scid Error" -icon warning -type ok -parent $parent -message $err_viewer
        }
      }      
  } else {
    # Linux / OS X
    if {[catch {exec /bin/sh -c "cd '$tmpdir' ; $latexEngine '$texfile'" >& $latexLog }]} {             
      unbusyCursor .  
      tk_messageBox -title "Scid Error" -icon warning -type ok -parent $parent -message $err_engine
    } else {
      if {[catch {exec /bin/sh -c "$latexViewer $pdffile" >& $latexLog &}]} {
	  unbusyCursor .  
	  tk_messageBox -title "Scid Error" -icon warning -type ok -parent $parent -message $err_viewer
      }
    }      
  }     
  unbusyCursor .  
}

namespace eval chess960 {}

proc ::chess960::Outermost {side col} {
	variable board	;# is array[2] of { LHS King RHS }

	set index [expr {[lindex $board $side 1] ? 2 : 0}]
	set c [lindex $board $side $index]

	if {$c == 0 || ($index == 0 ? $col < $c : $c < $col)} {
		lset board $side $index $col
	}
}


proc ::chess960::Setup {str} {
	variable board	;# is array[2] of { LHS King RHS }

	set row 1
	set col 1

	foreach ch [split $str ""] {
		if {[string is digit $ch]} {
			incr col [expr {[scan $ch "%c"] - 48}] ;# "0" has ASCII 48
		} else {
			switch $ch {
				"/" { incr row; set col 0 }
				"R" { if {$row == 8} { Outermost 0 $col } }
				"r" { if {$row == 1} { Outermost 1 $col } }
				"K" { if {$row == 8} { lset board 0 1 $col } }
				"k" { if {$row == 1} { lset board 1 1 $col } }
			}

			incr col
		}
	}

	if {[lindex $board 0 1] == 0 && [lindex $board 1 1] == 0} {
		return 0
	}

	return 1
}


proc ::chess960::MapPiece {side index ch} {
	variable board	;# is array[2] of { LHS King RHS }

	set col [lindex $board $side $index]
	if {$col} {
		return [format "%c" [expr {$col + ($side ? 96 : 64)}]] ;# 64 is 'A'-1; 96 is 'a'-1
	}
	return $ch
}


# Convert X-FEN to Shredder-FEN.
#
# This function expects a valid FEN, otherwise the result is undetermined.
# It doesn't matter if the given FEN is already a Shredder-FEN.
proc ::chess960::convertToShredder {fen} {
	variable board	;# is array[2] of { LHS King RHS }

	if {[llength $fen] < 3} {
		return $fen
	}

	set board {{0 0 0} {0 0 0}}

	if {![Setup [lindex $fen 0]]} {
		return $fen
	}

	set rights ""

	foreach ch [split [lindex $fen 2] ""] {
		switch $ch {
			"K" { append rights [MapPiece 0 2 "K"] }
			"Q" { append rights [MapPiece 0 0 "Q"] }
			"k" { append rights [MapPiece 1 2 "k"] }
			"q" { append rights [MapPiece 1 0 "q"] }

			default { append rights $ch }
		}
	}

	lset fen 2 $rights
	return $fen
}


# Convert Shredder-FEN to X-FEN.
#
# This function expects a valid FEN, otherwise the result is undetermined.
# It doesn't matter if the given FEN is already a X-FEN.
proc ::chess960::convertToXFEN {fen} {
	variable board	;# is array[2] of { LHS King RHS }

	if {[llength $fen] < 3} {
		return $fen
	}

	set board {{0 0 0} {0 0 0}}

	if {![Setup [lindex $fen 0]]} {
		return $fen
	}

	set rights ""

	foreach ch [split [lindex $fen 2] ""] {
		if {[string is upper $ch]} {
			set file [expr {[scan $ch "%c"] - 64}] ;# 64 is 'A'-1

			if {$file == [lindex $board 0 0]} {
				append rights "Q"
			} elseif {$file == [lindex $board 0 2]} {
				append rights "K"
			} else {
				append rights $ch
			}
		} elseif {[string is lower $ch]} {
			set file [expr {[scan $ch "%c"] - 96}] ;# 96 is 'a'-1

			if {$file == [lindex $board 1 0]} {
				append rights "q"
			} elseif {$file == [lindex $board 1 2]} {
				append rights "k"
			} else {
				append rights $ch
			}
		} else {
			append rights $ch
		}
	}

	lset fen 2 $rights
	return $fen
}


proc ::chess960::numberToFEN {number} {
	set KRN {"NNRKR" "NRNKR" "NRKNR" "NRKRN" "RNNKR" "RNKNR" "RNKRN" "RKNNR" "RKNRN" "RKRNN"}
	set pattern "XXXXXXXX"
	set number [expr {$number%960}]

	set r [expr {$number%4}]
	set q [expr {$number/4}]
	set m [expr {$r*2 + 1}]
	set r [expr {$q%4}]
	set q [expr {$q/4}]
	set n [expr {$r*2}]
	set r [expr {$q%6}]
	set q [expr {$q/6}]

	set pattern [string replace $pattern $m $m "B"]
	set pattern [string replace $pattern $n $n "B"]

	for {set i 0} {$i < 8} {incr i} {
		set ch [string index $pattern $i]
		if {$ch eq "X" && [incr r -1] == -1} {
			break;
		}
	}
	set pattern [string replace $pattern $i $i "Q"]

	set n 0
	set krn [lindex $KRN $q]
	for {set i 0} {$i < 8} {incr i} {
		set ch [string index $pattern $i]
		if {$ch eq "X"} {
			set pattern [string replace $pattern $i $i [string index $krn $n]]
			incr n
		}
	}

	append fen [string tolower $pattern]
	append fen "/pppppppp/8/8/8/8/PPPPPPPP/"
	append fen $pattern
	append fen " w KQkq - 0 1"

	return $fen
}

# end of misc.tcl
