###
### windows.tcl: part of Scid.
### Copyright (C) 1999-2003  Shane Hudson.
###


namespace eval ::windows {

    # TODO
}

# recordWinSize:
#   Records window width and height, for saving in options file.
#
#   winX and winY are now offsets to main window, instead of absolute screen x,y
#   except for the main window itself   S.A

proc recordWinSize {win} {

  # This procedure gets called way too often S.A.
  # It shouldnt really be bound to <Configure> , but only called on exit.

  global winWidth winHeight winX winY macOS

  if {![winfo exists $win]} { return }
  # dont record geom of docked windows
  if {$::docking::USE_DOCKING && ($win == "." || ![::docking::isWindow $win])} {
    return
  }
  set geom [wm geometry $win]
  set maingeom [wm geometry .main]

  set n [scan $geom "%dx%d+%d+%d" width height x y]
  scan $maingeom "%dx%d+%d+%d" mainwidth mainheight mainx mainy
  if {$n == 4} {
    if {$win == ".main"} {
      # trick to handle main window
      if {$macOS} {
        # If it goes to 0 0, the whole top bar is under the MacOS menubar and you can't move it
        set mainx 96
        set mainy 22
      } else {
        set mainx 0
        set mainy 0
      }
    }
    set winWidth($win) $width
    set winHeight($win) $height
    set winX($win) [expr $x - $mainx]
    set winY($win) [expr $y - $mainy]
  }
}

proc setWinLocation {win} {
  global winX winY macOS

  if {[info exists winX($win)]  &&  [info exists winY($win)] } {

    set maingeom [wm geometry .main]
    scan $maingeom "%dx%d+%d+%d" mainwidth mainheight mainx mainy

    if {$win == ".main"} {
      # trick to handle main window
      if {$macOS} {
        # If it goes to 0 0, the whole top bar is under the MacOS menubar and you can't move it
        set mainx 96
        set mainy 22
      } else {
        set mainx 0
        set mainy 0
      }
    }

    set x [expr $mainx + $winX($win)]
    set y [expr $mainy + $winY($win)]
    # these reqwidth etc are not getting set right, probably because of an update issue
    set reqwidth [winfo reqwidth $win]
    set reqheight [winfo reqheight $win]
    set max_x [expr [winfo screenwidth .main]]
    set max_y [expr [winfo screenheight .main]]
    if {$macOS} {
      set min_x 0
      set min_y 22
    } else {
      set min_x 0
      set min_y 0
    }

    if {[expr {$x + $reqwidth > $max_x}]} { set x [expr $max_x - $reqwidth] }
    if {[expr {$y + $reqheight > $max_y}]} { set y [expr $max_y - $reqheight] }
    if { $x < $min_x } { set x $min_x }
    if { $y < $min_y } { set y $min_y }
    catch [list wm geometry $win "+$x+$y"]
  }
}

proc setWinSize {win} {
  global winWidth winHeight
  if {[info exists winWidth($win)]  &&  [info exists winHeight($win)]  &&  \
    $winWidth($win) > 0  &&  $winHeight($win) > 0} {
    catch [list wm geometry $win "$winWidth($win)x$winHeight($win)"]
# puts "$win setgeom winWidth $winWidth($win) winHeight $winHeight($win)"
  }
}

# These procs only work ~properly~ if window is updated first
# (preferably in a withdrawn state) S.A

proc placeWinOverParent {w parent {where 0}} {
  # Where does not seem to be used anywhere

  if {!$::docking::USE_DOCKING && $parent == "."} {
    set parent .main
  }
  if {[winfo exists .fdock[string range $parent 1 end]]} {
    set parent .fdock[string range $parent 1 end]
  }

  set reqwidth [winfo reqwidth $w]
  set reqheight [winfo reqheight $w]

  if {[scan [winfo geometry $parent] "%dx%d+%d+%d" width height x y] == 4} {
    if {$where == "bottom"} {
      wm geometry $w "+[expr $x+($width-$reqwidth)/2]+$height"
    } elseif {$where == "top"} {
      wm geometry $w "+[expr $x+($width-$reqwidth)/2]+$y"
    } else {
      set x [expr $x+($width-$reqwidth)/2]
      set y [expr $y+($height-$reqheight)/3]
      set max_x [expr [winfo screenwidth .]]
      set max_y [expr [winfo screenheight .]]
      if {[expr {$x + $reqwidth > $max_x}]} { set x [expr $max_x - $reqwidth] }
      if {[expr {$y + $reqheight > $max_y}]} { set y [expr $max_y - $reqheight] }
      if { $x < 0 } { set x 0 }
      if { $y < 0 } { set y 0 }
      wm geometry $w +$x+$y
    }
  } else {
    puts {placeWinOverParent: scan != 4}
  }

  # wm minsize $w $reqwidth $reqheight; # optional ?
  # wm state $w normal
  # update
}

proc placeWinOverPointer {w} {
  set x [winfo pointerx .]
  set y [winfo pointery .]
  set width [winfo reqwidth $w]
  set height [winfo reqheight $w]
  if {$x>0 && $y>0 } {
    wm geometry $w +[expr $x - $width/2]+[expr $y - $height/2]
  }
}

proc placeWinCenter {w} {
  update idletasks
  set x [expr {[winfo screenwidth $w]/2 - [winfo reqwidth $w]/2 \
        - [winfo vrootx .]}]
  set y [expr {[winfo screenheight $w]/2 - [winfo reqheight $w]/2 \
        - [winfo vrooty .]}]
  wm geom $w +$x+$y
}

# Doesnt like tcl 8.5.4
proc toggleFullScreen {} {
  global dot_w

  if {[wm attributes $dot_w -fullscreen]} {
    wm attributes $dot_w -fullscreen 0
  } else {
    wm attributes $dot_w -fullscreen 1
  }
}



###
### End of file: windows.tcl
###
