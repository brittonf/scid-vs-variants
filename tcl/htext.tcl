###################
# htext.tcl
#
# Hypertext display module for Scid
#
# Implements html-like display in a text widget.
# It is used in Scid for the help, crosstable, game information area and 
# *importantly*, the PGN window. Slowdown occurs with large PGN files,
# and is probably due to the rendering of Tk::text widget with 4000+ char lines.

namespace eval ::htext {}

set helpWin(Stack) {}
set helpWin(yStack) {}
set helpWin(index) -1
set helpWin(len) 0

set helpWin(Indent) 0

# help_PushStack and help_PopStack:
#   Implements a stack (list) of help windows for the Back and Forward buttons

proc help_PushStack {name {heading {}}} {
  global helpWin

  # truncate in case we've been moving forward
  set helpWin(Stack)  [lrange $helpWin(Stack)  0 $helpWin(index)]
  set helpWin(yStack) [lrange $helpWin(yStack) 0 $helpWin(index)]

  lappend helpWin(Stack) $name

    if {[winfo exists .helpWin]} {
      # Before adding a new 0.0, we can set posi of the previous window
      lset helpWin(yStack) end [lindex [.helpWin.text yview] 0]
    }

  # new windows won't have a posi yet
  lappend helpWin(yStack) 0.0

  set helpWin(len) [llength $helpWin(Stack)]
  set helpWin(index) [expr $helpWin(len) - 1]
}

# set ::htext::headingColor "\#990000"
set ::htext::headingColor darkslateblue
array set ::htext:updates {}

proc help_MoveForward {} {
  global helpWin helpText helpName
  incr helpWin(index)
  set name  [lindex $helpWin(Stack)  $helpWin(index)]
  set yview [lindex $helpWin(yStack) $helpWin(index)]
  updateHelpWindow $name
  .helpWin.text yview moveto $yview
}

proc help_PopStack {} {
  global helpWin helpText helpName

  if {$helpWin(index) < 1} { return }

    if {[winfo exists .helpWin]} {
      # Just set posi of this window first
      # bug: there's some window creep upwards as we keep reading/setting yview

      lset helpWin(yStack) $helpWin(index) [lindex [.helpWin.text yview] 0]
    }

  incr helpWin(index) -1
  set name  [lindex $helpWin(Stack)  $helpWin(index)]
  set yview [lindex $helpWin(yStack) $helpWin(index)]
  updateHelpWindow $name
  .helpWin.text yview moveto $yview
}


proc toggleHelp {} {
  if {[winfo exists .helpWin]} {
    destroy .helpWin
  } else {
    helpWindow Contents
  }
}

proc helpWindow {name {heading {}}} {
  help_PushStack $name
  updateHelpWindow $name $heading
  update
}

proc updateHelpWindow {name {heading {}}} {
  global helpWin helpText helpTitle windowsOS language helpName
  set w .helpWin

  set helpName $name ; # used by forward stack
  set slist [split $name " "]
  if {[llength $slist] > 1} {
    set name [lindex $slist 0]
    set heading [lindex $slist 1]
  }

  if {[info exists helpText($language,$name)] && [info exists helpTitle($language,$name)]} {
    set title $helpTitle($language,$name)
    set helptext $helpText($language,$name)
  } elseif {[info exists helpText($name)] && [info exists helpTitle($name)]} {
    set title $helpTitle($name)
    set helptext $helpText($name)
  } else {
    return
  }

  if {![winfo exists $w]} {
    toplevel $w
    # wm geometry $w -10+0
    # wm minsize $w 40 5
    setWinLocation $w
    setWinSize $w
    text $w.text -setgrid yes -wrap word -width $::winWidth($w) \
        -height $::winHeight($w) -relief sunken -yscroll "$w.scroll set"
    scrollbar $w.scroll -relief sunken -command "$w.text yview" -width 12

    frame $w.b -relief raised 
    pack $w.b -side bottom -fill x
    button $w.b.contents -textvar ::tr(Contents) -width 6 -command { helpWindow Contents }
    button $w.b.index -textvar ::tr(Index) -width 6 -command { helpWindow Index }
    button $w.b.back -text "  << " -command { help_PopStack }
    button $w.b.forward -text "  >> " -command { help_MoveForward }
    # button $w.b.font -text Font -width 6 -command "FontDialogRegular $w"

    ### Help Widget Find
    entry $w.b.find -width 10 -textvariable ::helpWin(find) -highlightthickness 0
    configFindEntryBox $w.b.find helpWin .helpWin.text

    button $w.b.close -textvar ::tr(Close) -width 6 -command {
      set ::helpWin(Stack) {}
      set ::helpWin(yStack) {}
      set ::helpWin(index) -1
      set ::helpWin(len) 0
      destroy .helpWin
    }

    pack $w.b.back $w.b.contents $w.b.index $w.b.forward -side left -padx 3 -pady 2
    pack $w.b.close -side right -padx 3 -pady 2
    pack $w.b.find -side right -padx 3 -pady 2 -ipady 2
    pack $w.scroll -side right -fill y -pady 2
    pack $w.text -fill both -expand 1 -padx 1

    $w.text configure -font font_Regular
    ::htext::init $w.text
    bind $w <Configure> "recordWinSize $w"
    bind $w <F1> toggleHelp
  } else {
    raiseWin $w
  }

  $w.text configure -cursor top_left_arrow
  $w.text configure -state normal
  $w.text delete 0.0 end

  $w.b.index configure -state normal
  if {$name == "Index"} { $w.b.index configure -state disabled }
  $w.b.contents configure -state normal
  if {$name == "Contents"} { $w.b.contents configure -state disabled }

  if {$helpWin(index) < 1} {
    $w.b.back configure -state disabled
  } else {
    $w.b.back configure -state normal
  }

  if {$helpWin(len) == [expr $helpWin(index) + 1]} {
    $w.b.forward configure -state disabled
  } else {
    $w.b.forward configure -state normal
  }

  wm title $w "Help: $title"
  wm iconname $w "Scid help"

  $w.text delete 0.0 end
  bind $w <Up> "$w.text yview scroll -1 units"
  bind $w <Down> "$w.text yview scroll 1 units"
  bind $w <Prior> "$w.text yview scroll -1 pages"
  bind $w <Next> "$w.text yview scroll 1 pages"
  bind $w <Key-Home> "$w.text yview moveto 0"
  bind $w <Key-End> "$w.text yview moveto 0.99"
  bind $w <Escape> "$w.b.close invoke"
  # bind $w <Key-b> "$w.b.back invoke"
  bind $w <Alt-Left> "$w.b.back invoke"
  bind $w <Alt-Right> "$w.b.forward invoke"
  # bind $w <Key-i> "$w.b.index invoke"

  bindWheeltoFont $w
  ::htext::display $w.text $helptext $heading 0
  focus $w
}

### Now unused... big slowdown for what purpose ?
proc ::htext::updateRate {w rate} {
  set ::htext::updates($w) $rate
}

proc ::htext::init {w} {
  global graphFigurineAvailable

  set cyan {#007000}
  set maroon {#990000}
  set green {#008b00}

  # set ::htext::updates($w) 100
  $w tag configure black -fore black
  $w tag configure white -fore white
  $w tag configure red -fore red
  $w tag configure blue -fore blue
  $w tag configure darkblue -fore darkBlue
  $w tag configure green -fore $green
  $w tag configure cyan -fore $cyan
  $w tag configure yellow -fore yellow
  $w tag configure maroon -fore $maroon
  $w tag configure gray -fore gray50

  $w tag configure gbold -font font_Bold
  # hmmm... salmon4 rosybrown4 royalblue royalblue2 chartreuse4 springgreen4

  $w tag configure bgBlack -back black
  $w tag configure bgWhite -back white
  $w tag configure bgRed -back red
  $w tag configure bgBlue -back blue
  $w tag configure bgLightBlue -back lightBlue
  $w tag configure bgGreen -back $green
  $w tag configure bgCyan -back $cyan
  $w tag configure bgYellow -back yellow

  $w tag configure tab -lmargin2 50
  $w tag configure li -lmargin2 50
  $w tag configure center -justify center
  $w tag configure left -justify left
  $w tag configure right -justify right

  if {[$w cget -font] == "font_Small"} {
    $w tag configure b -font font_SmallBold
    $w tag configure i -font font_SmallItalic
  } else {
    $w tag configure b -font font_Bold
    $w tag configure i -font font_Italic
  }
  $w tag configure bi -font font_BoldItalic
  $w tag configure tt -font font_Fixed
  $w tag configure u -underline 1
  $w tag configure h1 -font {Arial 24 normal} -fore $::htext::headingColor -justify center
  $w tag configure h2 -font font_H2 -fore $::htext::headingColor
  $w tag configure h3 -font font_H3 -fore $::htext::headingColor
  $w tag configure h4 -font font_H4 -fore $::htext::headingColor
  $w tag configure ht -font font_Bold -fore $::htext::headingColor -justify center
  $w tag configure footer -font font_Small -justify center

  $w tag configure term -font font_BoldItalic -fore $::htext::headingColor
  $w tag configure menu -font font_Bold -fore $cyan

  # PGN-window-specific tags:
  $w tag configure tag -fore $::pgnColor(Header)
  if { $::pgn::boldMainLine } {
    $w tag configure nag -fore $::pgnColor(Nag) -font font_Regular
    $w tag configure var -fore $::pgnColor(Var) -font font_Regular
  } else {
    $w tag configure nag -fore $::pgnColor(Nag)
    $w tag configure var -fore $::pgnColor(Var)
  }
  $w tag configure ip1 -lmargin1 25 -lmargin2 25
  $w tag configure ip2 -lmargin1 50 -lmargin2 50
  $w tag configure ip3 -lmargin1 75 -lmargin2 75
  $w tag configure ip4 -lmargin1 100 -lmargin2 100

  if {$graphFigurineAvailable} {
    $w tag configure f -font font_Figurine(normal)
    $w tag configure fb -font font_Figurine(bold)
  }
}

proc ::htext::isLinkTag {tagName} {
  return [strIsPrefix {a } $tagName]
}

proc ::htext::extractLinkName {tagName} {
  if {[::htext::isLinkTag $tagName]} {
    return [lindex [split [string range $tagName 2 end] { }] 0]
  }
  return {}
}

proc ::htext::extractSectionName {tagName} {
  if {[::htext::isLinkTag $tagName]} {
    return [lindex [split [string range $tagName 2 end] { }] 1]
  }
  return {}
}

set ::htext::interrupt 0

### Some tcl string optimisations by S.A. 5/12/2009, 06/09/2010

proc ::htext::display {w helptext {section {}} {fixed 1}} {
  global helpWin
  # set start [clock clicks -milli]
  set helpWin(Indent) 0
  set ::htext::interrupt 0
  $w mark set insert 0.0
  $w configure -state normal
  set linkName {}

  set count 0
  set str $helptext
  # Conflict here between pgn and help markup.
  # In pgn we don't want to do this regsub
  if {$fixed == 1} {
    regsub -all \n\n $str <p> str
    regsub -all \n $str { } str
  } elseif {$fixed == 0} {
    regsub -all "\[ \n\]+" $str { } str
    regsub -all ">\[ \n\]+" $str {> } str
    regsub -all "\[ \n\]+<" $str { <} str
  } ; # else fixed == 2 (pgn.tcl), don't convert newlines in comments

  set tagType {}
  set seePoint {}

  # Loop through the text finding the next formatting tag

  while {1} {
    set startPos [string first < $str]
    if {$startPos < 0} { break }
    set endPos [string first > $str]
    if {$endPos < 1} { break }

    set tagName [string range $str [expr {$startPos + 1}] [expr {$endPos - 1}]]

    # starting tag (no "/" at the start)

    if {![strIsPrefix {/} $tagName]} {
      
      if {[strIsPrefix m_ $tagName]} {
        # Move tag &&&
        set moveTag $tagName
        set tagName m
        # Too many bindings! 
        $w tag bind $moveTag <ButtonPress-1> [list ::pgn::move $moveTag]
        $w tag bind $moveTag <ButtonPress-3> [list ::pgn::move $moveTag]
        $w tag bind $moveTag <Any-Enter> [list u1 $w $moveTag]
        $w tag bind $moveTag <Any-Leave> [list u0 $w $moveTag]
      } elseif {[strIsPrefix {a } $tagName]} {
	# link tag
        set linkName [::htext::extractLinkName $tagName]
        set sectionName [::htext::extractSectionName $tagName]
        set linkTag "link ${linkName} ${sectionName}"
        set tagName a
        $w tag configure $linkTag -fore dodgerblue3
        $w tag bind $linkTag <ButtonRelease-1> "helpWindow $linkName $sectionName"
        $w tag bind $linkTag <Any-Enter> [list uh1 $w $linkTag]
        $w tag bind $linkTag <Any-Leave> [list uh0 $w $linkTag]
      } elseif {[strIsPrefix {url } $tagName]} {
        # URL tag
        set urlName [string range $tagName 4 end]
        set urlTag "url $urlName"
        set tagName url
        $w tag configure $urlTag -fore darkred
        $w tag bind $urlTag <ButtonRelease-1> "openURL {$urlName}"
        $w tag bind $urlTag <Any-Enter> [list uh1 $w $urlTag]
        $w tag bind $urlTag <Any-Leave> [list uh0 $w $urlTag]
      } elseif {[strIsPrefix {run } $tagName]} {
        # Tcl command tag, also used extensively in statistics windows
        set runName [string range $tagName 4 end]
        set runTag "run $runName"
        set tagName run
        $w tag bind $runTag <ButtonRelease-1> "catch {$runName}"
        $w tag bind $runTag <Any-Enter> [list bh1 $w $runTag]
        $w tag bind $runTag <Any-Leave> [list bh0 $w $runTag]
      } elseif {[strIsPrefix {go } $tagName]} {
        # Goto tag
        # (is this used ??)
        set goName [string range $tagName 3 end]
        set goTag "go $goName"
        set tagName go
        $w tag bind $goTag <ButtonRelease-1> \
            "catch {$w see \[lindex \[$w tag nextrange $goName 1.0\] 0\]}"
        $w tag bind $goTag <Any-Enter> \
            "$w tag configure \"$goTag\" -fore gray
             $w tag configure \"$goTag\" -back maroon
             $w configure -cursor hand2"
        $w tag bind $goTag <Any-Leave> \
            "$w tag configure \"$goTag\" -fore {}
             $w tag configure \"$goTag\" -back {}
             $w configure -cursor {}"
      } elseif {[strIsPrefix {pi } $tagName]} {
        # Player info tag
        set playerTag $tagName
        set playerName [string range $playerTag 3 end]
        set tagName pi
        # $w tag configure "$playerTag" -fore Blue
        $w tag bind $playerTag <ButtonRelease-1> [list playerInfo $playerName raise]
        ### Hmmm - seen pgn that have the ELO in the playername like "surname [1234] christian"
        $w tag bind $playerTag <Any-Enter> \
            "catch {$w tag configure \"$playerTag\" -back gray85}
             $w configure -cursor hand2"
        $w tag bind $playerTag <Any-Leave> \
            "catch {$w tag configure \"$playerTag\" -back {}}
             $w configure -cursor {}"
      } elseif {[strIsPrefix g_ $tagName]} {
        # Game-load tag
        set gameTag $tagName
        set tagName g
        set gnum [string range $gameTag 2 end]
        set glCommand "::game::LoadMenu $w [sc_base current] $gnum %X %Y"
        $w tag bind $gameTag <ButtonPress-1> $glCommand
        # right-click browses game, but too annoying in crosstable
        # $w tag bind $gameTag <ButtonPress-3>  "::gbrowser::new [sc_base current] $gnum"
        $w tag bind $gameTag <Any-Enter> \
            "$w tag configure $gameTag
             $w tag configure $gameTag -back gray85
             $w configure -cursor hand2"
        $w tag bind $gameTag <Any-Leave> \
            "$w tag configure $gameTag -fore {}
             $w tag configure $gameTag -back {}
             $w configure -cursor {}"
      } elseif {[strIsPrefix c_ $tagName]} {
        # Comment tag
        set commentTag $tagName
        set tagName c
        if { $::pgn::boldMainLine } {
          $w tag configure $commentTag -fore $::pgnColor(Comment) -font font_Regular
        } else {
          $w tag configure $commentTag -fore $::pgnColor(Comment)
        }
        $w tag bind $commentTag <ButtonRelease-1> [list ::pgn::comment $commentTag]
        $w tag bind $commentTag <Any-Enter> [list u1 $w $commentTag]
        $w tag bind $commentTag <Any-Leave> [list u0 $w $commentTag]
      }
      
      if {$tagName == {h1}} {$w insert end \n}
    }

    # Now insert the text up to the formatting tag
    $w insert end [string range $str 0 [expr {$startPos - 1}]]

    # Check if it is a name tag matching the section we want
    if {$section != {}  &&  [strIsPrefix {name } $tagName]} {
      set sect [string range $tagName 5 end]
      if {$section == $sect} { set seePoint [$w index insert] }
    }

    if {[string index $tagName 0] == {/}} {
      ### process tag close, e.g. </menu>
      # Get rid of initial "/" character
      set tagName [string range $tagName 1 end]
      switch -- $tagName {
        m {}
        h1 - h2 - h3 - h4 - ht - p  { $w insert end \n }
        menu { $w insert end \] }
        ul   {
	      incr helpWin(Indent) -4
	      $w insert end \n
             }
      }
      if {[info exists startIndex($tagName)]} {
        switch -- $tagName {
          m  {$w tag add $moveTag $startIndex(m) [$w index insert]}
          a  {$w tag add $linkTag $startIndex(a) [$w index insert]}
          g  {$w tag add $gameTag $startIndex(g) [$w index insert]}
          c  {$w tag add $commentTag $startIndex(c) [$w index insert]}
          pi {$w tag add $playerTag $startIndex(pi) [$w index insert]}
          url {$w tag add $urlTag $startIndex(url) [$w index insert]}
          run {$w tag add $runTag $startIndex(run) [$w index insert]}
          go {$w tag add $goTag $startIndex(go) [$w index insert]}
          default {$w tag add $tagName $startIndex($tagName) [$w index insert]}
        }
        unset startIndex($tagName)
      }
    } else {
      switch -- $tagName {
        m {}
        ul {incr helpWin(Indent) 4}
        li {
          $w insert end \n
          for {set space 0} {$space < $helpWin(Indent)} {incr space} {
            $w insert end { }
          }
        }
        q  {$w insert end \"}
        lt {$w insert end <}
        gt {$w insert end >}
        h2 - h3 - h4 - ht - p - br  {$w insert end \n}
      }
      # Set the start index for this type of tag
      set startIndex($tagName) [$w index insert]
      # menu is now unused i think - S.A.
      if {$tagName == {menu}} {$w insert end \[}
    }

    if {$tagName != {m}} {
      if {[strIsPrefix {img } $tagName]} {
	set imgName [string range $tagName 4 end]
	set winName $w.$imgName
	while {[winfo exists $winName]} { append winName a }
	label $winName -image $imgName -relief flat -borderwidth 0
	$w window create end -window $winName
      }

      if {[strIsPrefix {button } $tagName]} {
	set imgName [lindex $tagName 1]
	set imgSize [lindex $tagName 2]
	set winName $w.$imgName
	while {[winfo exists $winName]} { append winName a }
	button $winName -image $imgName
	if {[string is integer -strict $imgSize]} {
	  $winName configure -width $imgSize -height $imgSize
	}
	$w window create end -window $winName
      }

      if {[strIsPrefix {window } $tagName]} {
	set winName [string range $tagName 7 end]
	$w window create end -window $winName
      }
    }

    # Eliminate the processed text from the string

    # Used to cause unicode bug in eco string, but scid.eco is now utf8
    # and this is faster for the crosstable (some tcl bug i think S.A)
    set str [string range $str $endPos+1 end] 
    # set str [string replace $str 0 $endPos]
    incr count

    ### This is meant to allow interrupts, but doesnt work
    ### but is very bad for performance with big pgn files
    # if {$count == $::htext::updates($w)} {
    #   update idletasks
    #   set count 1
    # }
    # if {$::htext::interrupt} {
    #   $w configure -state disabled
    #   return
    # }
  }

  # Add any remaining text
  if {! $::htext::interrupt} { $w insert end $str }

  if {$seePoint != {}} { $w yview $seePoint }
  $w configure -state disabled
  # set elapsed [expr {[clock clicks -milli] - $start}]
}

# Get some speed from optimising these into procs (?) S.A
# u - underline
# uh - underline+hand
# bh - background+hand

proc u1 {w tag} {
  $w tag configure $tag -background gray80
}
proc u0 {w tag} {
  $w tag configure $tag -background {}
}
proc uh1 {w tag} {
  $w tag configure $tag -underline 1
  $w configure -cursor hand2
}
proc uh0 {w tag} {
  $w tag configure $tag -underline 0
  $w configure -cursor {}
}
proc bh1 {w tag} {
  $w tag configure $tag -back gray85
  $w configure -cursor hand2
}
proc bh0 {w tag} {
  $w tag configure $tag -back {}
  $w configure -cursor {}
}

### Open a webpage in the user's (configured?) web browser

proc openURL {url} {
  global windowsOS macOS
  busyCursor .

  if {$windowsOS} {
    # On Windows, use the "start" command:
    if {[string match $::tcl_platform(os) "Windows NT"]} {
      catch {exec $::env(COMSPEC) /c start \"$url\" &}
    } else {
      catch {exec start $url &}
    }
  } elseif {$macOS} {
    if {[catch {exec /bin/sh -c "open -a Firefox \"$url\""}]} {
      catch {exec /bin/sh -c "open -a Safari \"$url\"" &}
    }
  } else {
    # The problem with the code commented out is it will leave two tabs  
    # open as the first will start firefox but fail the tab because of
    # the invalid switch and string. 
    # then the second call will open a second tab in the already 
    # running firefox. - R.A.

    #if {[catch {exec /bin/sh -c "firefox -remote 'openURL($url)'"}]} {
    #  # Now try a new firefox process
    #  catch {exec /bin/sh -c "firefox '$url'" &}
    #}
    
    # This implementation ... seems broke to me :( S.A.
    # if {[catch {exec /bin/sh -c "xdg-open '$url'" &}]} 

    catch {exec /bin/sh -c "firefox '$url'" &}
  }
  unbusyCursor .
}
