### Analysis window: uses a chess engine to analyze the board.
###
### analysis.tcl: part of Scid.
### Copyright (C) 1999-2003  Shane Hudson.
### Copyright (C) 2007  Pascal Georges
### Copyright (C) 2009 - 2014 Steven Atkinson

### Changes by S.A
# Overhauled procedural flow, removed the "two engine" limit and other limits.
# Stop engine spamming (visually) when in end-game positions.
# Added "Hot Keys" (F2 f3 F4) which are explictly changeable in the config widget
# Allow engines to bemoved up/down in order
# Allow UCI engines to be configured from the main widget
# Add a 'Copy' feature to clone an engine
# Overhauled look and feel
# Removed sorting functionality
# Other performance tweaks.

# We aren't using stdout. Windows does not support it.
# set analysis(log_stdout) 0
set analysis(log_auto) 0

set analysisBookSlot 1
set useAnalysisBookName ""
set wentOutOfBook 0

# Todo: these should be in analysis array

set annotate(isBatch) 0
set annotate(batchEnd) 1
set annotate(markExercises) 0
set isOpeningOnly 0
set isOpeningOnlyMoves 10
set stack ""
set finishGameMode 0

proc resetEngines {} {
  for {set i 0} {$i < [llength $::engines(list)]} {incr i} {
    if {[winfo exists .analysisWin$i]} {
      resetEngine $i
    }
  }
}

proc resetEngine {n} {
  global analysis

  set analysis(pipe$n) {}             ;# Communication pipe file channel
  set analysis(seen$n) 0              ;# Seen any output from engine yet?
  set analysis(seenEval$n) 0          ;# Seen evaluation line yet?
  set analysis(score$n) 0             ;# Current score in centipawns
  set analysis(prevscore$n) 0         ;# Immediately previous score in centipawns
  set analysis(prevmoves$n) {}        ;# Immediately previous best line out from engine
  set analysis(nodes$n) 0             ;# Number of (kilo)nodes searched
  set analysis(depth$n) 0             ;# Depth in ply
  set analysis(prevdepth$n) 0         ;# Previous depth
  set analysis(time$n) 0              ;# Time in centisec (or sec; see below)
  set analysis(moves$n) {}            ;# PV (best line) output from engine
  set analysis(seldepth$n) 0
  set analysis(currmove$n) {}         ;# current move output from engine
  set analysis(currmovenumber$n) 0    ;# current move number output from engine
  set analysis(nps$n) 0               ;# nodes per second
  set analysis(movelist$n) {start}    ;# Moves to reach current position
  set analysis(nonStdStart$n) 0       ;# Game has non-standard start
  set analysis(has_analyze$n) 0       ;# Engine has analyze command
  set analysis(has_setboard$n) 0      ;# Engine has setboard command
  set analysis(has_playother$n) 0     ;# Engine has playother command
  set analysis(send_sigint$n) 0       ;# Engine wants INT signal
  set analysis(wants_usermove$n) 0    ;# Engine wants "usermove" before moves
  set analysis(isCrafty$n) 0          ;# Engine appears to be Crafty
  set analysis(wholeSeconds$n) 0      ;# Engine times in seconds not centisec
  set analysis(analyzeMode$n) 0       ;# Scid has started analyze mode
  set analysis(invertScore$n) 1       ;# Score is for side to move, not white
  set analysis(automove$n) 0
  set analysis(automoveThinking$n) 0
  set analysis(automoveTime$n) 3000
  set analysis(lastClicks$n) 0
  set analysis(after$n) {}
  set analysis(log$n) {}              ;# Log file channel
  set analysis(logCount$n) 0          ;# Number of lines sent to log file
  set analysis(wbEngineDetected$n) 0  ;# Is this a special Winboard engine?
  set analysis(priority$n) normal     ;# CPU priority: idle/normal
  set analysis(multiPV$n) {}          ;# multiPV list sorted : depth score moves
  set analysis(multiPVraw$n) {}       ;# same thing but with raw UCI moves
  set analysis(uci$n) 0               ;# UCI engine
  # UCI engine options in format ( name min max ). This is not engine config but its capabilities
  set analysis(uciOptions$n) {}
  # the number of lines in multiPV. If =1 then act the traditional way
  # Sometime the info is processed before this line "set analysis(multiPVCount$n) $current",
  # so we have to set multiPVCount to 1 by default, not 4
  set analysis(multiPVCount$n) 1      ;# number of N-best lines
  set analysis(uciok$n) 0             ;# uciok sent by engine in response to uci command
  set analysis(name$n) {}             ;# engine name
  set analysis(processInput$n) 0      ;# the time of the last processed event
  set analysis(waitForBestMove$n) 0
  set analysis(waitForReadyOk$n) 0
  set analysis(waitForUciOk$n) 0
  set analysis(movesDisplay$n) 1      ;# 0 hide engine lines, 1 no word wrap, 2 word wrap
  set analysis(lastHistory$n) {}      ;# last best line
  set analysis(maxmovenumber$n) 0     ;# the number of moves in this position
  set analysis(lockEngine$n) 0        ;# the engine is locked to current position
  set analysis(side$n) {}
  set analysis(lockPos$n) {} 
  set analysis(lockFen$n) {}
  set analysis(startpos$n) ""         ;# the startpos/fen for game. Uninit-ed
  set analysis(go$n) 0
  set analysis(exclude$n) ""
}

resetEngines

set annotate(Engine) -1	; # $n of engine annotating
set annotate(Button)  0 ; # annotate checkbutton value

### Divides string-represented node count by 1000

proc calculateNodes {{n}} {
  set len [string length $n]
  if { $len < 4 } {
    return 0
  } else {
    set shortn [string range $n 0 [expr {$len - 4}]]
    scan $shortn %d nd
    return $nd
  }
}


# resetAnalysis:
#   Resets the analysis statistics: score, depth, etc.
#
proc resetAnalysis {{n 0}} {
  global analysis

  set analysis(score$n) 0
  set analysis(scoremate$n) 0
  set analysis(nodes$n) 0
  set analysis(prevdepth$n) 0
  set analysis(depth$n) 0
  set analysis(time$n) 0
  set analysis(moves$n) {}
  set analysis(multiPV$n) {}
  set analysis(multiPVraw$n) {}
  set analysis(lastHistory$n) {}
  set analysis(maxmovenumber$n) 0
}

namespace eval enginelist {}

set engines(list) {}

# engine:
#   Global procedure to add an engine to the engine list.
#   Called from the "engines.dat" configuration file

proc engine {arglist} {
  global engines
  array set newEngine {}
  foreach {attr value} $arglist {
    set newEngine($attr) $value
  }
  # Check that required attributes exist:
  if {! [info exists newEngine(Name)] || 
      ! [info exists newEngine(Cmd)]  || 
      ! [info exists newEngine(Dir)]} { return  0 }
  # Fill in optional attributes:
  if {! [info exists newEngine(Args)]} { set newEngine(Args) {} }
  if {! [info exists newEngine(Elo)]} { set newEngine(Elo) 0 }
  if {! [info exists newEngine(Time)]} { set newEngine(Time) 0 }
  if {! [info exists newEngine(URL)]} { set newEngine(URL) {} }
  # puts this option here for compatibility with previous file format (?!)
  if {! [info exists newEngine(UCI)]} { set newEngine(UCI) 0 }
  if {! [info exists newEngine(UCIoptions)]} { set newEngine(UCIoptions) {} }

  lappend engines(list) [list $newEngine(Name) $newEngine(Cmd) \
      $newEngine(Args) $newEngine(Dir) \
      $newEngine(Elo) $newEngine(Time) \
      $newEngine(URL) $newEngine(UCI) $newEngine(UCIoptions)]
  return 1
}


### The analysis engines config file is $HOME/.scidvspc/config/engines.dat on linux and macs

proc ::enginelist::read {} {
  catch {source [scidConfigFile engines]}
}

proc ::enginelist::write {} {
  global engines scidUserDir scidShareDir

  set enginesFile [scidConfigFile engines]
  set enginesBackupFile [scidConfigFile engines.bak]
  # Try to rename old file to backup file and open new file:
  catch {file rename -force $enginesFile $enginesBackupFile}
  if {[catch {open $enginesFile w} f]} {
    catch {file rename $enginesBackupFile $enginesFile}
    return 0
  }

  puts $f "\# Analysis Engines configuration for $::scidName [sc_info version]"
  puts $f {}
  foreach e $engines(list) {
    set name [lindex $e 0]
    set cmd  [lindex $e 1]
    set args [lindex $e 2]
    set dir  [lindex $e 3]
    set elo  [lindex $e 4]
    set time [lindex $e 5]
    set url  [lindex $e 6]
    set uci  [lindex $e 7]
    set opt  [lindex $e 8]
    puts $f "engine {"
      puts $f "  Name [list $name]"
      puts $f "  Cmd  [list $cmd]"
      puts $f "  Args [list $args]"
      puts $f "  Dir  [list $dir]"
      puts $f "  Elo  [list $elo]"
      puts $f "  Time [list $time]"
      puts $f "  URL  [list $url]"
      puts $f "  UCI  [list $uci]"
      puts $f "  UCIoptions [list $opt]"
      puts $f "}"
    puts $f {}
  }
  close $f
  return 1
}

# Read the user Engine List file now:

catch { ::enginelist::read }

if {[llength $engines(list)] == 0} {

  ### No engines, so set up a default engine list with Scidlet, Toga and Phalanx
  # Engine directory names need updating properly

  if {$::windowsOS} {
    ### Windows comes with it's own custom engines.dat, so shoul dnever reach here.
    tk_messageBox -type ok -icon info -title Scid \
		  -message "No engines.dat found. Please reinstall or add engines manually."
    return
  }

  if {$macApp} {
    engine "Name Toga
            Cmd  $scidShareDir/engines/toga/fruit
            Dir  $scidUserDir
            UCI  1"
    engine "Name Phalanx
            Cmd  $scidShareDir/engines/phalanx/phalanx
            Dir  $scidUserDir"
    engine "Name Scidlet
	    Cmd  $scidExeDir/scidlet
	    Dir  $scidUserDir"
  } else {
    engine "Name Toga
            Cmd  fruit
            Dir  $scidUserDir
            UCI  1"
    # use "Cmd phalanx -g /tmp/phalanx_logfile" for debugging
    engine "Name Phalanx
            Cmd  phalanx
            Dir  $scidUserDir"
    engine "Name Scidlet
	    Cmd  scidlet
	    Dir  ."
  }

}

### Given a time in seconds since 1970, returns a formatted date string.

proc ::enginelist::date {time} {
  return [clock format $time -format "%d/%m/%Y"]
}

proc ::enginelist::listEngines {{focus 0}} {
  global engines

  set w .enginelist
  if {! [winfo exists $w]} { return }
  set f $w.list.list
  $f delete 0 end
  set count 0
  foreach engine $engines(list) {
    set name [lindex $engine 0]
    set elo  [lindex $engine 4]
    set time [lindex $engine 5]
    set uci  [lindex $engine 7]
    set date [::enginelist::date $time]
    set text [format "%-24s" [string range $name 0 23]]

    # display any hot key bindings
    if {$engines(F2) == $count} {
      append text "  F2  "
    } elseif {$engines(F3) == $count} {
      append text "  F3  "
    } elseif {$engines(F4) == $count} {
      append text "  F4  "
    } else {
      append text "      "
    }

    if {$uci} {
      append text " uci    "
    } else {
      append text " xboard "
    }

    if {$elo > 0} {
      append text [format "%6u" $elo]
    } else {
      append text "      "
    }

    if {$time > 0} {
      append text "  $date"
    } else {
      append text "  "
    }
    $f insert end $text

    incr count
  }
  if {$focus == -1} {
    set focus [expr $count - 1]
  }
  $f selection set $focus
  $f see $focus

  $w.title configure -state normal
  foreach i {Name Elo Time} {
    $w.title tag configure $i -font font_Fixed -foreground {}
  }
  $w.title configure -state disabled
  focus .enginelist.list.list
}

###  Main Engine Configuration widget
###  rewritten by S.A. July 7 2009  (and beyond :>)

proc ::enginelist::choose {} {
  global engines analysis
  set w .enginelist

  if { [winfo exists $w] } { destroy $w }

  toplevel $w
  setWinLocation $w
  setWinSize $w

  wm title $w "[tr ToolsAnalysis]"
  wm protocol $w WM_DELETE_WINDOW "destroy $w"
  bind $w <F1> { helpWindow Analysis List }
  bind $w <Escape> "destroy $w"
  bind $w <F2> "startAnalysisWin F2"
  bind $w <F3> "startAnalysisWin F3"
  bind $w <F4> "startAnalysisWin F4"

  label $w.flabel -textvar ::tr(EngineList) -font font_Large
  pack $w.flabel -side top -pady 5

  frame $w.buttons
  frame $w.buttons2

  pack $w.buttons2 -side bottom -padx 5 -pady 8 -fill x
  pack $w.buttons -side bottom -padx 5 -pady 3 -fill x

  text $w.title -width 93 -height 1 -font font_Fixed -relief flat \
      -cursor top_left_arrow -background gray95

  $w.title insert end [format "%-24s %4s %5s %8s %8s" \
    $::tr(EngineName) $::tr(EngineKey) $::tr(EngineType) $::tr(EngineElo) $::tr(EngineTime)]

  ### Are these tags (Elo Time) used anywhere ??
  # $w.title insert end "  $::tr(EngineElo)" Elo
  # $w.title insert end "   $::tr(EngineTime)" Time

  $w.title configure -state disabled
  pack $w.title -side top -fill x

  ### list of engines

  pack [frame $w.list -relief flat -borderwidth 0] \
    -side top -expand yes -fill both -padx 4 -pady 3

  listbox $w.list.list -height 10 -selectmode browse -setgrid 1 -highlightthickness 0 \
      -yscrollcommand "$w.list.ybar set" -font font_Fixed -exportselection 0 ; # -bg text_bg_color

  bind $w.list.list <Double-ButtonRelease-1> "$w.buttons2.start invoke; break"
  bind $w.list.list <Return> {
    .enginelist.buttons2.start invoke
    break
  }
  bind $w.list.list <KeyPress> "::enginelist::findEngine %K"
  scrollbar $w.list.ybar -command "$w.list.list yview"

  pack $w.list.ybar -side right -fill y
  pack $w.list.list -side top -fill both -expand yes
  $w.list.list selection set 0

  dialogbutton $w.buttons.add -textvar ::tr(EngineNew) -command {::enginelist::edit -1}

  dialogbutton $w.buttons.edit -textvar ::tr(EngineEdit) -command {
    ::enginelist::edit [lindex [.enginelist.list.list curselection] 0]
  }

  dialogbutton $w.buttons.copy -text [lindex $::tr(CopyGames) 0] -command {
    ::enginelist::edit [lindex [.enginelist.list.list curselection] 0] copy
  }

  # arrow images defined in bookmark.tcl
  button $w.buttons.up   -image bookmark_up   -command {::enginelist::move -1} 
  button $w.buttons.down -image bookmark_down -command {::enginelist::move 1} 
  button $w.buttons.uci  -image uci           -command {
    ::uci::uciConfigN [lindex [.enginelist.list.list curselection] 0] .enginelist
  }
  button $w.buttons.log  -image tb_annotate   -command {engineShowLog [lindex [.enginelist.list.list curselection] 0]}

  dialogbutton $w.buttons.delete -textvar ::tr(Delete) -command {
    ::enginelist::delete [lindex [.enginelist.list.list curselection] 0]
  }

  label $w.buttons2.sep -text "   "

  label $w.buttons2.logengines        -textvar ::tr(LogEngines)
  entry $w.buttons2.logmax            -textvariable analysis(logMax) -width 6
  label $w.buttons2.ply               -textvar ::tr(MaxPly)
  spinbox $w.buttons2.maxply -width 4 -textvariable analysis(maxPly) -from 0 -to 20 -increment 1
  checkbutton $w.buttons2.logname     -variable analysis(logName)     -textvar ::tr(LogName)
  checkbutton $w.buttons2.lowpriority -variable analysis(lowPriority) -textvar ::tr(LowPriority)
  dialogbutton $w.buttons2.start -textvar ::tr(Start) -command {
    makeAnalysisWin [lindex [.enginelist.list.list curselection] 0] settime
  }

  # Right-click inits engine but doesn't start
  bind $w.buttons2.start <Button-3> {
    makeAnalysisWin [lindex [.enginelist.list.list curselection] 0] nostart
  }

  dialogbutton $w.buttons2.close -textvar ::tr(Close) -command {
    destroy .enginelist
  }

  pack $w.buttons.up $w.buttons.down $w.buttons.log $w.buttons.uci $w.buttons.edit $w.buttons.add $w.buttons.copy $w.buttons.delete -side left -expand yes

  pack $w.buttons2.close $w.buttons2.start -side right -padx 5 
  pack $w.buttons2.logengines $w.buttons2.logmax $w.buttons2.ply $w.buttons2.maxply $w.buttons2.logname $w.buttons2.lowpriority -side left -padx 0 

  focus $w.buttons2.start
  # Focus is now set to listbox (in ::enginelist::listEngines) for keyboard shortcuts

  ::enginelist::listEngines
  update
  bind $w <Configure> "recordWinSize $w"
}

# ::enginelist::setTime
#   Sets the last-opened time of the engine specified by its
#   index in the engines(list) list variable.
#   The time should be in standard format (seconds since 1970)
#   and defaults to the current time.
# God knows why this date is always updated, but left in for the moment S.A

proc ::enginelist::setTime {index {time -1}} {
  global engines
  set e [lindex $engines(list) $index]
  if {$time < 0} { set time [clock seconds] }
  set e [lreplace $e 5 5 $time]
  set engines(list) [lreplace $engines(list) $index $index $e]
}

trace variable engines(newElo) w [list ::utils::validate::Integer [sc_info limit elo] 0]

#   Removes an engine from the list.

proc ::enginelist::delete {index} {
  global engines
  if {$index == ""  ||  $index < 0} { return }
  set e [lindex $engines(list) $index]
  set msg "Name: [lindex $e 0]
Command: [lindex $e 1]\n
Confirm delete\n"
  set answer [tk_messageBox -title Scid -icon question -type okcancel \
      -message $msg -parent .enginelist]
  if {$answer == "ok"} {
    set engines(list) [lreplace $engines(list) $index $index]
    foreach f {F2 F3 F4} {
      if {$engines($f) == $index} {
        set engines($f) {}
      } elseif {$engines($f) >= $index} {
        incr engines($f) -1
      }
    }
    ::enginelist::listEngines
    ::enginelist::write
  }
}

#   Opens a dialog for editing an existing engine list entry (if
#   index >= 0), or adding a new entry (if index is -1).

proc ::enginelist::edit {index {copy {}}} {
  global engines

  set w .engineEdit
  if {$index == ""} { return }
  if {[winfo exists $w]} {
    destroy $w
    update idletasks
  }


  # This "||  $index >= [llength $engines(list)]"
  # seems erroneous
  if {$index >= 0  ||  $index >= [llength $engines(list)]} {
    set e [lindex $engines(list) $index]
  } else {
    set e [list "" "" "" . 0 0 "" 1]
  }

  set engines(newName)	[lindex $e 0]

  if {$copy == "copy"} {
    # Ok... we've copied the current engine, now pretend we've been called for a new engine
    set index -1
    append engines(newName) {-new}
  }

  set engines(newIndex) $index
  set engines(newCmd)	[lindex $e 1]
  set engines(newArgs)	[lindex $e 2]
  set engines(newDir)	[lindex $e 3]
  set engines(newElo)	[lindex $e 4]
  set engines(newURL)	[lindex $e 6]
  set engines(newUCI)	[lindex $e 7]
  set engines(newUCIoptions) [lindex $e 8]

  toplevel $w
  wm title $w {Configure Engine}
  wm state $w withdrawn

  set f [frame $w.frame]
  pack $f -side top -fill x -expand yes -padx 3 -pady 7
  set row 0
  foreach i {Name Cmd Dir Args URL} {
    label $f.l$i -text $i
    if {[info exists ::tr(Engine$i)]} {
      $f.l$i configure -textvar ::tr(Engine$i)
    }
    entry $f.e$i -textvariable engines(new$i) -width 22
    bindFocusColors $f.e$i
    grid $f.l$i -row $row -column 0 -sticky w -pady 1 -padx 3
    grid $f.e$i -row $row -column 1 -sticky we -pady 1 -padx 3

    # Browse button for choosing an executable file:
    if {$i == "Cmd"} {
      button $f.b$i -textvar ::tr(Browse) -command {
        if {$::windowsOS} {
          set scid_temp(filetype) {
            {"Applications" {".bat" ".exe"} }
            {"All files" {"*"} }
          }
        } else {
          set scid_temp(filetype) {
            {"All files" {"*"} }
          }
        }
        set scid_temp(cmd) [tk_getOpenFile -initialdir $engines(newDir) -parent .engineEdit \
            -title "Scid: Select Executable" -filetypes $scid_temp(filetype)]
        if {$scid_temp(cmd) != ""} {
          set engines(newCmd) $scid_temp(cmd)
          # if {[string first " " $scid_temp(cmd)] >= 0} {
          # The command contains spaces, so put it in quotes:
          # set engines(newCmd) "\"$scid_temp(cmd)\""
          # }
          # Set the directory from the executable path if possible:
          set engines(newDir) [file dirname $scid_temp(cmd)]
          if {$engines(newDir) == ""} [ set engines(newDir) .]
        }
      }
      grid $f.b$i -row $row -column 2 -sticky we -pady 1 -padx 3
    }

    if {$i == "Dir"} {
      button $f.current -text " . " -command {
        set engines(newDir) .
      }
      button $f.user -text "~/.scidvspc" -command {
        set engines(newDir) $scidUserDir
      }
      if {$::windowsOS} {
        $f.user configure -text "scid.exe dir"
      }
      grid $f.current -row $row -column 2 -sticky we -pady 1 -padx 3
      grid $f.user -row $row -column 3 -sticky we -pady 1 -padx 3
    }

    if {$i == "URL"} {
      $f.l$i configure -text Webpage
      button $f.bURL -text [tr FileOpen] -command {
        if {$engines(newURL) != ""} { openURL $engines(newURL) }
      }
      grid $f.bURL -row $row -column 2 -sticky we -pady 1 -padx 3
    }

    incr row
  }

  grid columnconfigure $f 1 -weight 1

  label $f.lUCI -text Protocol
  frame $f.rb
  radiobutton $f.rb.uci -variable engines(newUCI) -value 1 -text UCI \
    -command "checkState ::engines(newUCI) $f.bUCI"
  radiobutton $f.rb.xboard -variable engines(newUCI) -value 0 -text Xboard \
    -command "checkState ::engines(newUCI) $f.bUCI"
  pack $f.rb.uci -side left
  pack $f.rb.xboard -side right
  button $f.bUCI -textvar ::tr(GlistEditField) -command "
    ::uci::uciConfig $index  \$engines(newName) \[toAbsPath \$engines(newCmd)\] \$engines(newArgs) \
                       \[toAbsPath \$engines(newDir)\] \$engines(newUCIoptions)
  "
  checkState ::engines(newUCI) $f.bUCI

  # Mark required fields:
  $f.lName configure -font font_Bold
  $f.lCmd configure -font font_Bold
  $f.lDir configure -font font_Bold
  $f.lUCI configure -font font_Bold

  label $f.lElo -textvar ::tr(EngineElo)
  entry $f.eElo -textvariable engines(newElo) -width 22
  bindFocusColors $f.eElo
  grid $f.lElo -row $row -column 0 -sticky w -pady 1 -padx 3
  grid $f.eElo -row $row -column 1 -sticky we -pady 1 -padx 3

  incr row
  grid $f.lUCI -row $row -column 0 -sticky w -pady 1 -padx 3
  grid $f.rb   -row $row -column 1 -sticky w -pady 1 -padx 3
  grid $f.bUCI -row $row -column 2 -sticky w -pady 1 -padx 3
  incr row

  frame $w.radio
  label $w.radio.label -text {Hot Key}
  radiobutton $w.radio.f2	-text F2 -variable hotkey -value F2
  radiobutton $w.radio.f3	-text F3 -variable hotkey -value F3
  radiobutton $w.radio.f4	-text F4 -variable hotkey -value F4
  radiobutton $w.radio.none	-text none -variable hotkey -value none
  # have to use "none" instead of "" to stop radio button ghosting bug
  bind $w <F2> {set hotkey F2}
  bind $w <F3> {set hotkey F3}
  bind $w <F4> {set hotkey F4}

  $w.radio.none select
  if {$engines(F2) == $engines(newIndex)} {$w.radio.f2 select} 
  if {$engines(F3) == $engines(newIndex)} {$w.radio.f3 select}
  if {$engines(F4) == $engines(newIndex)} {$w.radio.f4 select}

  pack $w.radio -side top -anchor w
  pack $w.radio.label -side left
  pack $w.radio.f2 $w.radio.f3 $w.radio.f4 $w.radio.none -side left -padx 5

  pack [label $w.required -font font_Small -textvar ::tr(EngineRequired)] -side top

  addHorizontalRule $w
  set f [frame $w.buttons]
  dialogbutton $f.ok -text OK -command {
    # remove trailing spaces
    foreach i {newName newCmd newArgs newDir newElo newURL newUCI} {
      set engines($i) [string trim $engines($i)]
    }
    if { $engines(newElo) == "" } { set engines(newElo) 0 }
    if {$engines(newName) == "" || $engines(newCmd) == "" || $engines(newDir) == ""} {
      tk_messageBox -title Scid -icon info -parent .engineEdit \
        -message "The Name, Command and Directory fields must not be empty."
    } else {
      # Ok - now set time to file modification (mtime) of executable
      set engines(newTime) 0
      if {[file executable $engines(newCmd)]} {
	set engines(newTime) [file mtime $engines(newCmd)]
      } else {
	# No such file. Look for it in the path
	catch {
	 set exe [exec which $engines(newCmd)]
	  if {[file executable $exe]} {
	    set engines(newTime) [file mtime $exe]
	  }
	}
      }

      set newEntry [list $engines(newName) $engines(newCmd) \
        $engines(newArgs) $engines(newDir) \
          $engines(newElo) $engines(newTime) \
          $engines(newURL) $engines(newUCI) $::uci::newOptions ]

      set index $engines(newIndex)

      # just disable first in case of multiple selection
      if {$engines(F2) == $index} {set engines(F2) {}}
      if {$engines(F3) == $index} {set engines(F3) {}}
      if {$engines(F4) == $index} {set engines(F4) {}}
      if { $hotkey == "F2" || $hotkey == "F3" || $hotkey == "F4" } {
        # hotkey either F2 or F3 or F4
        set engines($hotkey) $index
      }

      if {$engines(newIndex) < 0} {
        lappend engines(list) $newEntry
	if { $hotkey == "F2" || $hotkey == "F3" || $hotkey == "F4" } {
	  set engines($hotkey) [expr [llength $engines(list)] - 1]
        }
      } else {
        set engines(list) [lreplace $engines(list) \
            $engines(newIndex) $engines(newIndex) $newEntry]
      }
      destroy .engineEdit
      ::enginelist::listEngines $engines(newIndex)
      ::enginelist::write
    }
  }
  dialogbutton $f.help -textvar ::tr(Help) -command {helpWindow Analysis List}
  dialogbutton $f.cancel -textvar ::tr(Cancel) -command "destroy $w"
  pack $f -side bottom
  pack $f.cancel -side right -padx 20 -pady 5
  pack $f.help -side right -padx 20 -pady 5
  pack $f.ok -side left -padx 20 -pady 5

  bind $w <Return> "$f.ok invoke"
  bind $w <Escape> "destroy $w"
  bind $w <F1> { helpWindow Analysis List }

  placeWinOverParent $w .enginelist
  wm state $w normal

  if {$index == -1}  {
    focus $w.frame.eName
  }
  # bind $w <Configure> "recordWinSize $w"
  # wm resizable $w 1 0
  # catch {grab $w}
}

proc ::enginelist::move {dir} {
  global engines

  set current [lindex [.enginelist.list.list curselection] 0]

  if {![checkAllEnginesClosed .enginelist]} {
    return
  }

  set max [llength $engines(list)]
  if {($dir == -1 && $current == 0) || ($dir == 1 && $current == $max-1)} {
    return
  }
  if {$dir == -1} {
    set lead  [lrange $engines(list) 0 [expr $current - 2]]
    set item  [lindex $engines(list) $current]
    set swap  [lindex $engines(list) [expr $current - 1]]
    set trail [lrange $engines(list) [expr $current + 1] end]
    set engines(list) [concat $lead [list $item] [list $swap] $trail]
  } else {
    set lead  [lrange $engines(list) 0 [expr $current - 1]]
    set item  [lindex $engines(list) $current]
    set swap  [lindex $engines(list) [expr $current + 1]]
    set trail [lrange $engines(list) [expr $current + 2] end]
    set engines(list) [concat $lead [list $swap] [list $item] $trail]
  }
  # Update the F2 key bindings
  foreach f {F2 F3 F4} {
    if {$engines($f) == $current} {
     set engines($f) [expr $current + $dir]
    } else {
      if {$engines($f) == $current + $dir} {
       set engines($f) [expr $current]
      }
    }
  }
  ::enginelist::listEngines [expr $current + $dir]
  ::enginelist::write
}

proc checkAllEnginesClosed {parent} {
  global engines

  set flag {}
  for {set i 0} {$i < [llength $engines(list)]} {incr i} {
    if {[winfo exists .analysisWin$i]} {
       set flag "all Engines"
    }
  }
  foreach {win title} {
    .comp         "Computer Tournament" 
    .uciConfigWin "UCI Config window"
    .engineEdit   "Configure Engine window"
    .serGameWin   "UCI Game"
    .coachWin "Phalanx Game"} {
    if {[winfo exists $win]} {
      set flag $title
      break
    }
  }
  if {$flag != {}} {
    if {$parent != ".enginelist"} {
      set message "Due to possible file locking, please close $flag first."
    } else {
      set message "Please close $flag first"
    }
    tk_messageBox -title Scid -icon warning -type ok -parent $parent -message $message
    return 0
  } else {
    return 1
  }
}

proc ::enginelist::findEngine {key} {
  set w .enginelist.list.list

  if {![string is alpha $key]} {
    return
  }

  set curselection [$w curselection]
  if {$curselection == {}} { 
    set i -1
  } else {
    set i [lindex $curselection 0]
  }

  set match 0
  $w selection clear 0 end
  while {$i < [$w index end] && !$match} {
    incr i
    set match [string match -nocase $key* [$w get $i]]
  }
  if {$match} {
    $w selection set $i
    $w see $i
  }
}

proc checkAnnotateControl {w} {
  if {$::annotate(Depth)} {
    set s1 disabled ; set s2 normal
  } else {
    set s1 normal   ; set s2 disabled
  }
  foreach i [winfo children $w.delay] {
    $i configure -state $s1
  }
  foreach i [winfo children $w.depth]  {
    $i configure -state $s2
  }
}

### Annotation configuration widget
### most of the Annotation logic is in main.tcl::autoplay

proc initAnnotation {n} {
  global autoplayDelay tempdelay analysis annotate tr

  set analysis(prevscore$n) 0

  set w .configAnnotation
  if { [winfo exists $w] } {
    set annotate(Button) 1
    raiseWin $w
    return
  }
  if { ! $annotate(Button) } { ; # end annotation
    toggleAutoplay
    return
  }

  if { $analysis(multiPVCount$n) > 1} {
    set analysis(multiPVCount$n) 1
    changePVSize $n
  }

  trace variable annotate(blunder) w {::utils::validate::Regexp {^[0-9]*\.?[0-9]*$}}

  set tempdelay [expr {$autoplayDelay / 1000.0}]
  toplevel $w
  wm state $w withdrawn
  wm title $w $tr(AnnotateTitle)
  wm protocol $w WM_DELETE_WINDOW "$w.buttons.cancel invoke"
  setWinLocation $w
  setWinSize $w

  frame $w.buttons
  pack $w.buttons -side bottom -fill x

  ### pack everything inside a scrolled frame, as this widget gets too tall
  pack [frame $w.f] -side top -expand 1 -fill both

  if {$::windowsOS || $::macOS} {
    bind $w <MouseWheel> {
      if {[expr -%D] < 0} {.configAnnotation.f.sf yview scroll -1 units}
      if {[expr -%D] > 0} {.configAnnotation.f.sf yview scroll +1 units}
    }
  } else {
      bind $w <Button-4> ".configAnnotation.f.sf yview scroll -1 units"
      bind $w <Button-5> ".configAnnotation.f.sf yview scroll +1 units"
  }

  set w $w.f

  ::scrolledframe::scrolledframe $w.sf -yscrollcommand "$w.vs set" -fill both -height 600
  scrollbar $w.vs -command "$w.sf yview" -width 12

  grid $w.sf -row 0 -column 0 -sticky nsew
  grid $w.vs -row 0 -column 1 -sticky ns
  grid rowconfigure $w 0 -weight 1
  grid columnconfigure $w 0 -weight 1

  set w $w.sf.scrolled

  ### Depth

  if  {$analysis(uci$n)} {
    frame $w.choice
    label $w.choice.0 -textvar tr(MoveControl)
    radiobutton $w.choice.1 -variable annotate(Depth) -value 1 -textvar tr(Depth) -command "checkAnnotateControl $w"
    radiobutton $w.choice.2 -variable annotate(Depth) -value 0 -textvar tr(Time)  -command "checkAnnotateControl $w"

    pack $w.choice -side top -pady 3 
    pack $w.choice.0 $w.choice.1 $w.choice.2 -side left -expand 1 -fill x

    frame $w.depth 
    label $w.depth.label -textvar tr(DepthPerMove) -width 22
    spinbox $w.depth.spDepth -width 4 -textvariable annotate(WantedDepth) -from 10 -to 30 -increment 1

    pack $w.depth -side top -pady 3 
    pack $w.depth.label -side left
    pack $w.depth.spDepth -side right -padx 5
  } else {
    set annotate(Depth) 0
  }

  ### Seconds per move

  frame $w.delay
  label $w.delay.label -textvar ::tr(SecondsPerMove) -width 22
  spinbox $w.delay.spDelay -width 4 -textvariable tempdelay -from 1 -to 300 -increment 1

  pack $w.delay -side top
  pack $w.delay.label -side left
  pack $w.delay.spDelay -side right -padx 5 

  if  {$analysis(uci$n)} {
    checkAnnotateControl $w
  }

  pack [frame $w.spacey] -side top -pady 5

  ### Blunder Threshold

  frame $w.blunderbox
  label $w.blunderbox.label -text "$tr(Blunder) $tr(BlundersThreshold)" -width 22
  spinbox $w.blunderbox.spBlunder -width 4 -textvariable annotate(blunder) \
      -from 0.1 -to 3.0 -increment 0.1

  pack $w.blunderbox -side top -padx 5 
  pack $w.blunderbox.label -side left 
  pack $w.blunderbox.spBlunder -side right -padx 5

  frame $w.cutoff
  label $w.cutoff.label -text "$tr(CutOff) $tr(BlundersThreshold)" -width 22
  spinbox $w.cutoff.spBlunder -width 4 -textvariable annotate(cutoff) \
      -from 3.0 -to 10.0 -increment .5

  pack $w.cutoff -side top -padx 5 
  pack $w.cutoff.label -side left
  pack $w.cutoff.spBlunder -side right -padx 5

  addHorizontalRule $w

  ### Annotate Scores

  label $w.scoreslabel -textvar tr(AddScores)
  radiobutton $w.scores_allmoves -textvar ::tr(AnnotateAllMoves) -variable annotate(WithScore) -value allmoves -anchor w
  radiobutton $w.scores_blunders -textvar tr(BlundersNotBest) -variable annotate(WithScore) -value blunders -anchor w
  radiobutton $w.scores_var -textvar ::tr(GlistVariations) -variable annotate(WithScore) -value var -anchor w
  radiobutton $w.scores_none -textvar ::tr(No) -variable annotate(WithScore) -value no -anchor w
  # previously  annotateType

  pack $w.scoreslabel -side top
  pack $w.scores_allmoves $w.scores_blunders $w.scores_var $w.scores_none -side top -fill x

  addHorizontalRule $w

  ### Annotate Variations

  label $w.anlabel -textvar tr(AddVars)
  radiobutton $w.notbest -textvar ::tr(AnnotateNotBest) -variable annotate(WithVars) -value notbest -anchor w
  radiobutton $w.blunders -textvar ::tr(AnnotateBlundersOnly) -variable annotate(WithVars) -value blunders -anchor w
  radiobutton $w.allmoves -textvar ::tr(AnnotateAllMoves) -variable annotate(WithVars) -value allmoves -anchor w
  radiobutton $w.none -textvar ::tr(No) -variable annotate(WithVars) -value no -anchor w

  pack $w.anlabel -side top
  pack $w.notbest $w.blunders -side top -fill x
  pack $w.allmoves $w.none -side top -fill x

  addHorizontalRule $w

  ### Which side

  label $w.avlabel -textvar ::tr(AnnotateWhich)
  radiobutton $w.all -textvar ::tr(AnnotateAll) -variable annotate(Moves) -value all -anchor w
  radiobutton $w.white -textvar ::tr(AnnotateWhite) -variable annotate(Moves) -value white -anchor w
  radiobutton $w.black -textvar ::tr(AnnotateBlack) -variable annotate(Moves) -value black -anchor w

  pack $w.avlabel -side top
  pack $w.all $w.white $w.black -side top -fill x

  addHorizontalRule $w

  ### General options frame

  checkbutton $w.cbAddAnnotatorTag     -textvar ::tr(addAnnotatorTag)    -variable annotate(addTag)     -anchor w
  checkbutton $w.cbAnnotateVar         -textvar ::tr(AnnotateVariations) -variable annotate(isVar)      -anchor w

  frame $w.scoreType
  label $w.scoreType.label -textvar ::tr(ScoreFormat)
  ttk::combobox $w.scoreType.values -width 12 -textvariable annotate(scoreType) -values {{+1.5} {[% +1.5]} {[%eval +1.5]}}

  pack $w.scoreType -fill x
  pack $w.scoreType.label -side left -padx 10
  pack $w.scoreType.values -side right

  pack $w.cbAddAnnotatorTag $w.cbAnnotateVar -anchor w

  # Book

  frame $w.usebook
  pack  $w.usebook -side top -fill x

  checkbutton $w.usebook.cbBook  -textvar ::tr(UseBook) -variable ::useAnalysisBook -command "
    if {!\$::useAnalysisBook} {
      set ::isOpeningOnly 0
    }
    checkState ::useAnalysisBook $w.usebook.comboBooks
    checkState ::useAnalysisBook $w.batch.cbOpeningOnly
    checkState ::useAnalysisBook $w.batch.spOpeningOnly
    checkState ::useAnalysisBook $w.batch.lOpeningOnly"

  # load book names
  set bookPath $::scidBooksDir
  set bookList [ lsort -dictionary [ glob -nocomplain -directory $bookPath *.bin ] ]

  if { [llength $bookList] == 0 } {
      set ::useAnalysisBook 0
      $w.usebook.cbBook configure -state disabled
  }

  set tmp {}
  set idx 0
  set i 0
  foreach file  $bookList {
      lappend tmp [ file tail $file ]
      if {$::book::lastBook1 == [ file tail $file ] } {
	  set idx $i
      }
      incr i
  }

  ttk::combobox $w.usebook.comboBooks -width 12 -values $tmp
  catch { $w.usebook.comboBooks current $idx }

  pack $w.usebook.cbBook -side left 
  pack $w.usebook.comboBooks -side right

  # Batch annotation 

  frame $w.batch
  pack $w.batch -side top -fill x
  set to [sc_base numGames]
  if {$to < 1} {set to 1}
  checkbutton $w.batch.cbBatch -textvar ::tr(AnnotateSeveralGames) -variable annotate(isBatch) \
    -command "checkState ::annotate(isBatch) $w.batch.spBatchEnd"

  spinbox $w.batch.spBatchEnd -width 6 -textvariable annotate(batchEnd) \
      -from 1 -to $to -increment 1 -validate all -vcmd {string is int %P}

  checkState ::annotate(isBatch) $w.batch.spBatchEnd


  # Opening Errors Only

  checkbutton $w.batch.cbOpeningOnly -textvar ::tr(FindOpeningErrors) -variable ::isOpeningOnly \
     -command "checkState ::isOpeningOnly $w.batch.spOpeningOnly"

  spinbox $w.batch.spOpeningOnly -width 2 -textvariable ::isOpeningOnlyMoves \
      -from 5 -to 20 -increment 1 -validate all -vcmd {string is int %P}

  label $w.batch.lOpeningOnly -textvar ::tr(moves)

  checkState ::useAnalysisBook $w.usebook.comboBooks $w.batch.cbOpeningOnly $w.batch.spOpeningOnly $w.batch.lOpeningOnly
  checkState ::isOpeningOnly $w.batch.spOpeningOnly

  # Pack

  grid $w.batch.cbBatch    -column 0 -row 0 -sticky w
  grid $w.batch.spBatchEnd -column 1 -row 0 -columnspan 2 -sticky e
  set annotate(batchEnd) $to

  grid $w.batch.cbOpeningOnly -column 0 -row 1 -sticky w
  grid $w.batch.spOpeningOnly -column 1 -row 1 -padx 5
  grid $w.batch.lOpeningOnly  -column 2 -row 1 -sticky e

  checkbutton $w.batch.cbMarkTactics -textvar ::tr(MarkTacticalExercises) -variable annotate(markExercises)
  grid $w.batch.cbMarkTactics -column 0 -row 2 -sticky w
  if {!$analysis(uci$n)} {
    set annotate(markExercises) 0
    $w.batch.cbMarkTactics configure -state disabled
  }

  set w .configAnnotation

  addHorizontalRule $w
  dialogbutton $w.buttons.cancel -textvar ::tr(Cancel) -command {
    bind .configAnnotation <Destroy> {}
    destroy .configAnnotation
    set annotate(Engine) -1
    set annotate(Button) 0
  }
  dialogbutton $w.buttons.help -textvar ::tr(Help) -command {helpWindow Analysis Annotating}
  dialogbutton $w.buttons.ok -text "OK" -command "okAnnotation $n"

  pack $w.buttons.cancel $w.buttons.help $w.buttons.ok -side right -padx 5 -pady 5
  # focus $w.delay.spDelay


  bind $w <Escape> "$w.buttons.cancel invoke"
  bind $w <Return> "$w.buttons.ok invoke"
  bind $w <Destroy> "$w.buttons.cancel invoke"
  bind $w <Configure> "recordWinSize $w"
  bind $w <F1> {helpWindow Analysis Annotating}
  placeWinOverParent $w .analysisWin$n
  wm state $w normal
  focus -force $w ; # windows bug - doesn't get focus and <Escape> fails
  # have to start engine here for depth based anno niggles
  if {! $analysis(analyzeMode$n)} {
    toggleEngineAnalysis $n
  }
  update
}

### Start Annotation

proc okAnnotation {n} {
  global autoplayDelay tempdelay autoplayMode annotate analysis

  set w .configAnnotation.f.sf.scrolled

  if {$annotate(Engine) > -1} {
    puts "okAnnotation: engine $annotate(Engine) already annotating"
    return
  }
  if {$annotate(isBatch) && [sc_base isReadOnly]} {
    set answer [tk_messageBox -title Tournanment -icon question -type okcancel \
        -message "Database is read only, and batch annotations can't be saved.\n\nContinue ?" -parent .configAnnotation]
    if {$answer != "ok"} {
      return
    }
  }

  set ::useAnalysisBookName [$w.usebook.comboBooks get]
  set ::book::lastBook1 $::useAnalysisBookName
  set ::prevNag {}

  # tactical positions is selected, must be in multipv mode
  if {$annotate(markExercises)} {
    if { $analysis(multiPVCount$n) < 2} {
      set analysis(multiPVCount$n) 4
      changePVSize $n
    }
  }

  if {$tempdelay < 0.1} { set tempdelay 0.1 }
  set autoplayDelay [expr {int($tempdelay * 1000)}]
  bind .configAnnotation <Destroy> {}
  destroy .configAnnotation

  if {[sc_pos isAt vend]} {
    # Starting analysis from game end - probably want to be at start
    sc_move start
    updateBoard  -pgn
  }
  if {[sc_pos isAt start]} {
    set ::wentOutOfBook 0
  } else { 
    set ::wentOutOfBook 1
  }

  set annotate(Engine) $n

  if {$annotate(addTag)} {
    appendTag Annotator "$analysis(name$n)"
    if  {$annotate(Depth)} {
      appendTag Depth "$annotate(WantedDepth)"
    }
  }
  if {$autoplayMode == 0} { toggleAutoplay }
  # Disable pause button, (But perhaps we can enable this. Seems to work in annotate mode now)
  .analysisWin$n.b.startStop configure -state disabled
}

### Part of annotation process
### Check the moves if they are in the book, and add a comment when going out of it

proc bookAnnotation { {n 1} } {
  global analysis annotate

  if {!($annotate(Engine) > -1 && $::useAnalysisBook)} {
    return
  }

  set prevbookmoves {}
  set bn [ file join $::scidBooksDir $::useAnalysisBookName ]

  ### This is getting opened for every game in batch S.A. &&&
  # but is getting closed just below... so should be ok ?

  sc_book load $bn $::analysisBookSlot

  set bookmoves [sc_book moves $::analysisBookSlot]
  while {[string length $bookmoves] != 0 && ![sc_pos isAt vend]} {
    # we are in book, so move immediately forward
    ::move::Forward
    set prevbookmoves $bookmoves
    set bookmoves [sc_book moves $::analysisBookSlot]
  }
  sc_book close $::analysisBookSlot
  set ::wentOutOfBook 1
  # update

  set bookName [file rootname $::useAnalysisBookName]
  set verboseMoveOutOfBook " $::tr(MoveOutOfBook)"
  set verboseLastBookMove " $::tr(LastBookMove)"

  ### Wrong. Compares c4 Bc4
  # if { [ string match -nocase "*[sc_game info previousMoveNT]*" $prevbookmoves ] != 1 }

  if {![sc_game startBoard]} {
  if {[lsearch -exact $prevbookmoves [sc_game info previousMoveNT]] == -1} {
    if {$prevbookmoves != {}} {
      sc_pos setComment "[sc_pos getComment]$verboseMoveOutOfBook ($bookName: $prevbookmoves)"
    } else  {
      sc_pos setComment "[sc_pos getComment]$verboseMoveOutOfBook ($bookName)"
    }
  } else  {
    sc_pos setComment "[sc_pos getComment]$verboseLastBookMove ($bookName)"
  }
  }

  # last move was out of book or the last move in book : it needs to be analyzed, so take back
  ::move::Back
  resetAnalysis $n

  updateBoard -pgn
  ### Animation ??
  # for {set i 0} {$i<100} {incr i} { update ; after [expr $::autoplayDelay / 100] }
  set analysis(prevscore$n) $analysis(score$n)
  set analysis(prevmoves$n) $analysis(moves$n)
  # updateBoard -pgn
}

### Only available for UCI engines
#
# Add a special comment (eg "****D1 0.1->2.9  +2.85 / +0.11") to any position considered as a tactical shot
# Used to generate exercises for "Find best move".
# Move criteria is below, but basically they are non-obvious, unique, winning moves.

proc markExercise { prevscore score } {
  global analysis annotate informant

  set n $annotate(Engine)

  if {! $annotate(markExercises) || ! $analysis(uci$n)} {
    return
  }

  # Check at which depth the tactical shot is found
  # this assumes analysis by an UCI engine

  set deltamove [expr {$score - $prevscore}]
  # filter tactics so only those with high gains are kept
  if { [expr abs($deltamove)] < $informant("+/-") } {
    return
  }
  # dismiss games where the result is already clear (high score,and we continue in the same way)
  if { [expr $prevscore * $score] >= 0} {
    if { [expr abs($prevscore) ] > $informant("++-") } { return }
    if { [expr abs($prevscore)] > $informant("+-") && [expr abs($score) ] < [expr 2 * abs($prevscore)]} { return }
  }

  # The best move is much better than others.
  if { [llength $analysis(multiPV$n)] < 2 } {
    puts "markExercise: error, not enough PV"
    return
  }
  set sc2 [lindex [ lindex $analysis(multiPV$n) 1 ] 1]
  if { [expr abs( $score - $sc2 )] < 1.5 } {
    puts "markExercise: < 1.5"
    return
  }

  # There is no other winning moves (the best move may not win, of course, but
  # I reject exercises when there are e.g. moves leading to +9, +7 and +5 scores)
  if { [expr $score * $sc2] > 0.0 && [expr abs($score)] > $informant("+-") && [expr abs($sc2)] > $informant("+-") } {
    return
  }

  # The best move does not lose position.
  if {$analysis(side$n) == {white} && $score < [expr 0.0 - $informant("+/-")] } { return }
  if {$analysis(side$n) == {black} && $score > $informant("+/-") } { return }

  # Move is not obvious: check that it is not the first move guessed at low depths
  set pv [ lindex [ lindex $analysis(multiPV$n) 0 ] 2 ]
  set bm0 [lindex $pv 0]
  foreach depth {1 2 3} {
    set res [ sc_pos analyze -time 1000 -hashkb 32 -pawnkb 1 -searchdepth $depth ]
    set bm$depth [lindex $res 1]
  }
  if { $bm0 == $bm1 && $bm0 == $bm2 && $bm0 == $bm3 } {
    puts "markExercise: obvious move"
    return
  }

  # find what time is needed to get the solution (use internal analyze function)
  set timer {1 2 5 10 50 100 200 1000}
  # set scorelist {}
  set movelist {}
  for {set t 0} {$t < [llength $timer]} { incr t} {
    set res [sc_pos analyze -time [lindex $timer $t] -hashkb 1 -pawnkb 1 -mindepth 0]
    # set score_analyze [lindex $res 0]
    set move_analyze [lindex $res 1]
    # if {[sc_pos side] == "black"} { set score_analyze [expr 0.0 - $score_analyze] }
    # lappend scorelist $score_analyze
    lappend movelist $move_analyze
  }

  # find at what timing the right move was reliably found
  # only the move is checked, not if the score is close to the expected one
  for {set t [expr [llength $timer] -1]} {$t >= 0} { incr t -1} {
    if { [lindex $movelist $t] != $bm0 } {
      break
    }
  }

  set difficulty [expr $t +2]

  puts "markExercise: flag T pour [sc_game number] difficulty $difficulty"
  sc_game flag T [sc_game number] 1
  sc_pos setComment "****D${difficulty} [format %.1f $prevscore]->[format %.1f $score] [sc_pos getComment]"
  updateBoard
}

proc addScore {n type {novar 0}} {
    global analysis annotate

    if {$annotate(WithScore) == "no" || \
        ($annotate(WithScore) == "var" && $novar) || \
        ($annotate(WithScore) == "blunders" && $novar) || \
        [sc_pos isAt vstart]} {
      return
    }
    # hack to not score last book move
    if {$::wentOutOfBook == 1} {
      incr ::wentOutOfBook
      return
    }

    if { [sc_pos moves] == {} && [sc_pos isAt end]} {
      # Where is there getting called from ?. Hack to not display errant last mated score
      ### Last move , don't attempt to score as it comes out wrong/negative and breaks the score graph
      # But should we use scoreToMate and not score mating moves at all... but it's nice to see the graph maxed out
      return
    }

    switch $type {
      single { set text [format "%+.2f" $analysis(score$n)] }
      both - end  { set text [format "%+.2f / %+.2f" $analysis(score$n) $analysis(prevscore$n)] }
    }

    if {$annotate(Engine) > -1 && $type == "single"} {
      switch $annotate(scoreType) {
        {[% +1.5]} { set text "\[% $text\]" }
        {[%eval +1.5]} { set text "\[%eval $text\]" }
      }

    }

    set prev_comment [sc_pos getComment]

    if {$prev_comment == ""} {
      sc_pos setComment "$text"
    } else {
      sc_pos setComment "$text $prev_comment"
    }
}


proc addAnnotation {tomove} {
  global analysis annotate prevNag

  set n $annotate(Engine)

  if {$n == -1} {
    puts "addAnnotation: annotate(Engine) unset"
    return
  }

  ### Now handled in sendPosToEngineUCI
  # if { ! $::wentOutOfBook && $::useAnalysisBook}

  # Cannot add a variation to an empty variation:
  if {[sc_pos isAt vstart]  &&  [sc_pos isAt vend]} { return }

  if {$annotate(Moves) == {white}  &&  $tomove == {white} ||
    $annotate(Moves) == {black}  &&  $tomove == {black} } {
    set analysis(prevscore$n) $analysis(score$n)
    set analysis(prevmoves$n) $analysis(moves$n)
    return
  }

  # Cannot (yet) add a variation at the end of the game or a variation:
  if {[sc_pos isAt vend]} {
      addScore $n single 1
      updateBoard -pgn
      ::tools::graphs::score::Refresh
      return
  }

  # set text [format "%d:%+.2f" $analysis(depth$n) $analysis(score$n)]
  set moves $analysis(moves$n)

  # if next move is what engine guessed, do nothing
  if { $analysis(prevmoves$n) != {} && ![sc_pos isAt vend] && $annotate(WithVars) != {allmoves}} {
    set move2 [sc_game info previousMoveNT]

    sc_game push copyfast
    set move1 [lindex $analysis(prevmoves$n) 0]
    sc_move back 1
    sc_moveAdd $move1 $n
    set move1 [sc_game info previousMoveNT]
    sc_game pop

    if {$move1 == $move2} {
      set analysis(prevscore$n) $analysis(score$n)
      set analysis(prevmoves$n) $analysis(moves$n)
      if {$annotate(WithScore) == "allmoves"} {
	addScore $n single 1
      }
      updateBoard -pgn
      ::tools::graphs::score::Refresh
      return
    }
  }

  set score $analysis(score$n)
  set prevscore $analysis(prevscore$n)

  set deltamove [expr {$score - $prevscore}]
  set isBlunder 0

  ### Don't process if score above cut-off score,
  # excepting for the case when score goes from -5 to +7 (eg)
if {abs($prevscore) < $annotate(cutoff) || abs($score) < $annotate(cutoff) || \
   (abs($deltamove) > abs($score) && $score*$prevscore < 0)} {
  ### Calculate isBlunder
  if {$annotate(WithVars) != "notbest"} {
    if { $deltamove < [expr 0.0 - $annotate(blunder)] && $tomove == {black} || \
          $deltamove > $annotate(blunder) && $tomove == {white} } {
      set isBlunder 1
    }
    # if the game is dead, and the score continues to go down, don't add any comment
    if { $prevscore > $::informant("++-") && $tomove == {white} || \
          $prevscore < [expr 0.0 - $::informant("++-") ] && $tomove == {black} } {
      set isBlunder 0
    }
  } else { ;# notbest
    if { $deltamove < 0.0 && $tomove == {black} || \
          $deltamove > 0.0 && $tomove == {white} } {
      set isBlunder 1
    }
  }
}


  if {$annotate(WithVars) == "no"} {
    ### Scores only

    if {$annotate(WithScore) == "allmoves"} {
      addScore $n single
    } elseif { $annotate(WithScore) == "blunders" && $isBlunder } {
      addScore $n both
    }

  } elseif {$annotate(WithVars) == "allmoves"} {

    addScore $n single

    set absdeltamove [expr { abs($deltamove) } ]
    if { $deltamove < [expr 0.0 - $annotate(blunder)] && $tomove == {black} || \
	  $deltamove > $annotate(blunder) && $tomove == {white} } {
      if {$absdeltamove > $::informant("?!") && $absdeltamove <= $::informant("?")} {
	sc_pos addNag "?!"
      } elseif {$absdeltamove > $::informant("?") && $absdeltamove <= $::informant("??")} {
	sc_pos addNag "?"
	markExercise $prevscore $score
      } elseif {$absdeltamove > $::informant("??") } {
	sc_pos addNag "??"
	markExercise $prevscore $score
      }
    }

    ### Only show common nags if not the same as previous nag!
    # but this is broke for variations , which arent tested/coded for
    set nag [ scoreToNag $score ]
    if {$nag != {} && $nag != $prevNag} {
      sc_pos addNag $nag
    }
    set prevNag $nag

    if { $analysis(prevmoves$n) != {}} {
      sc_move back
      sc_var create
      set moves $analysis(prevmoves$n)
      sc_moveAdd $moves $n
      set nag [ scoreToNag $prevscore ]
      if {$nag != {}} {
	sc_pos addNag $nag
      }
      sc_var exit
      sc_move forward
    }
  } elseif { $isBlunder } {
    # Add the comment to highlight the blunder
    set absdeltamove [expr { abs($deltamove) } ]

    # if the game was won and the score remains high, don't add comment
    if { $score > $::informant("++-") && $tomove == {black} || \
          $score < [expr 0.0 - $::informant("++-") ] && $tomove == {white} } {
      addScore $n end
    } else  {
      if {$absdeltamove > $::informant("?!") && $absdeltamove <= $::informant("?")} {
        sc_pos addNag "?!"
      } elseif {$absdeltamove > $::informant("?") && $absdeltamove <= $::informant("??")} {
        sc_pos addNag "?"
        markExercise $prevscore $score
      } elseif {$absdeltamove > $::informant("??") } {
        sc_pos addNag "??"
        markExercise $prevscore $score
      }
      
      addScore $n both
    }

    set nag [ scoreToNag $score ]
    if {$nag != {}} {
      sc_pos addNag $nag
    }

    if {$annotate(WithVars) != "no" } {
      # Rewind, request a diagram
      sc_move back
      sc_pos addNag D

      # Add the variation:
      if { $analysis(prevmoves$n) != {}} {
	sc_var create
	set moves $analysis(prevmoves$n)
	# Add as many moves as possible from the engine analysis:
	sc_moveAdd $moves $n
	set nag [ scoreToNag $prevscore ]
	if {$nag != {}} {
	  sc_pos addNag $nag
	}
	sc_var exit
      }
      sc_move forward
    }
  } else {
    addScore $n single 1
  }

  set analysis(prevscore$n) $analysis(score$n)
  set analysis(prevmoves$n) $analysis(moves$n)

  updateBoard -pgn
  ::tools::graphs::score::Refresh
}

proc scoreToNag {score} {
  global informant

  if {$score >= $informant("+-")} {
    return "+-"
  }
  if {$score >= $informant("+/-")} {
    return "+/-"
  }
  if {$score >= $informant("+=")} {
    return "+="
  }
  if { $score >= 0.0 - $informant("+=")} {
    return "="
  }
  if {$score <= 0.0 - $informant("+-")} {
    return "-+"
  }
  if {$score <= 0.0 - $informant("+/-")} {
    return "-/+"
  }
  if {$score <= 0.0 - $informant("+=")} {
    return "-="
  }
}

### Add an extra tag to the game tags
#
# Notably, tag will be Annotator or OpeningBlunder

proc appendTag {tag value} {
  set s [string trim $value]
  set tags [sc_game tags get Extra]

  ### See below for the format of tags

  ### The extra tags are very tough on newlines and lists. Prepare for pain

  set found 0
  set new {}

  foreach {t v} $tags {
    if {$t == $tag} {
      set found 1
      # dont rewrite if value already matches
      if {[string match "*$value*" $v]} {
	append new "$t \"$v\"\n"
      } else {
	append new "$t \"$v , $s\"\n"
      }
    } else {
      append new "$t \"$v\"\n"
    }
  }

  if {!$found} {
      append new "$tag \"$s\"\n"
  }

  ### dog know why this is needed S.A

  sc_game tags set -extra [split $new "\n"]
}

################################################################################
#
################################################################################
proc pushAnalysisData {lastVar n} {
  global analysis stack
  lappend stack [list $analysis(prevscore$n) $analysis(score$n) \
      $analysis(prevmoves$n) $analysis(moves$n) $lastVar ]
}
################################################################################
#
################################################################################
proc popAnalysisData {n} {
  global analysis stack
  # the start of analysis is in the middle of a variation
  if {[llength $stack] == 0} {
    set analysis(prevscore$n) 0
    set analysis(score$n)     0
    set analysis(prevmoves$n) {}
    set analysis(moves$n)     {}
    set lastVar 0
    return
  }
  set tmp [lindex $stack end]
  set analysis(prevscore$n) [lindex $tmp 0]
  set analysis(score$n)     [lindex $tmp 1]
  set analysis(prevmoves$n) [lindex $tmp 2]
  set analysis(moves$n)     [lindex $tmp 3]
  set lastVar               [lindex $tmp 4]
  set stack [lreplace $stack end end]
  return $lastVar
}


proc addAnalysisVariation {{n -1}} {
  global analysis

  if {$n == -1} {
    set n [findEngine]
    if {$n == -1} {
      return
    }
  }

  if {! [winfo exists .analysisWin$n]} { return }

  sc_game undoPoint

  # if we are at the end of the game, we cannot add variation, so we add the
  # analysis one move before and append the last game move at the beginning of
  # the analysis

  set addAtStart [expr [sc_pos isAt vstart]  &&  [sc_pos isAt vend]]
  set isAt_end [sc_pos isAt end]
  set isAt_vend [sc_pos isAt vend]

  set moves $analysis(moves$n)
  set text [formatAnalysisScore $n]

  if {$isAt_vend} {
    # get the last move of the game
    set lastMove [sc_game info previousMoveUCI]
    # back one move
    sc_move back
  }

  if {!$isAt_vend || $isAt_end} {
    # Add a variation if not already at end of a variation
    # (in which case we append moves to this var)
    set var_count [sc_var count]
    sc_var create
    set create_var 1
  } else {
    set create_var 0
  }

  # Add comment identifying analysis engine if at vstart
  # (perhaps this code belongs just above)
  if {[sc_pos isAt vstart]} {
    set prev_comment [sc_pos getComment]
    if {$prev_comment == ""} {
      sc_pos setComment "$text"
    } else {
      sc_pos setComment "$text $prev_comment"
    }
  }

  if {$isAt_vend} {
    # Add the last move of the game at the beginning of the analysis
    if {$lastMove == {0000} } {
      sc_move addSan null
    } else {
      sc_moveAdd $lastMove $n
    }
  }

  # Add as many moves as possible from the engine analysis:
  if {[sc_moveAdd $moves $n]} {
    # Oops, add move failed
    if {$create_var} {
      sc_var exit
    }
  } else {
    # Now go back to the previous place
    if {$create_var} {
      sc_var exit
    } else {
      sc_move back [llength $moves]
    }

    if {$addAtStart} {
      sc_move start
    } elseif {$isAt_vend && $create_var} {
      ### Automatically goto variation S.A.
      # todo : sould only do this if only a single var exists
      sc_var enter $var_count
    }
  }

  ::pgn::Refresh 1
  updateStatusBar
  updateGameinfo
  ::tools::graphs::score::Refresh
  if {$isAt_vend && ![sc_pos isAt vend]} {
    # sucessfully extended variation
    .main.button.forward configure -state normal
  }
}


proc addAllVariations {{n 1} {rightclick 0}} {
  global analysis

  if {! [winfo exists .analysisWin$n]} { return }

  # Cannot add a variation to an empty variation:
  if {[sc_pos isAt vstart]  &&  [sc_pos isAt vend]} { return }

  sc_game undoPoint

  # if we are at the end of the game, we cannot add variation
  # so we add the analysis one move before and append the last game move at the beginning of the analysis
  set addAtEnd [sc_pos isAt vend]

  if {$rightclick} {
    # Only process second variation
    if {[lindex $analysis(multiPV$n) 1] == {}} {
      # Not enough PV
      return
    }
    # two single item lists with the second variation 
    set v1 [list "[lindex $analysis(multiPVraw$n) 1]"]
    set v2 [list "[lindex $analysis(multiPV$n) 1]"]
  } else {
    # Process all variations
    set v1 $analysis(multiPVraw$n)
    set v2 $analysis(multiPV$n)
  }

  foreach i $v1 j $v2 {
    set moves [lindex $i 2]

    set tmp_moves [ lindex $j 2 ]
    set tmp_scoremate [scoreToMate [lindex $i 1] [lindex $i 3]]
    if {$analysis(logName)} {
      set text [format "\[%s\] %d:%s" $analysis(name$n) [lindex $i 0] $tmp_scoremate]
    } else {
      set text $tmp_scoremate
    }

    if {$addAtEnd} {
      # get the last move of the game
      set lastMove [sc_game info previousMoveUCI]
      sc_move back
    }

    # Add the variation:
    sc_var create
    # Add the comment at the start of the variation:
    sc_pos setComment "[sc_pos getComment] $text"
    if {$addAtEnd} {
      # Add the last move of the game at the beginning of the analysis
      if {$lastMove == {0000} } {
	sc_move addSan null
      } else {
	sc_moveAdd $lastMove $n
      }
    }
    # Add as many moves as possible from the engine analysis:
    sc_moveAdd $moves $n
    sc_var exit

    if {$addAtEnd} {
      #forward to the last move
      sc_move forward
    }

  }

  ::pgn::Refresh 1 
  updateStatusBar
  ::tools::graphs::score::Refresh
}

proc makeAnalysisMove {n} {
  global analysis comp

  set s $analysis(moves$n)
  set res 1

  # Scan over any leading number/etc. This is ugly
  while {1} {
    switch -- [string index $s 0] {
      a - b - c - d - e - f - g - h -
      K - Q - R - B - N - P - O {
        break
      }
    }
    if {$s == {}} {return 0}
    set s [string range $s 1 end]
  }
  if {[scan $s %s move] != 1} { set res 0 }

  if {$move == [sc_game info nextMoveUCI]} {
    ::move::Forward
    return
  }

  if {! [sc_pos isAt vend] && ! $comp(playing)} {
    set action [confirmReplaceMove]
    if {$action == "cancel"} {
      return
    }
  } else {
    set action replace
  }

  if {!$comp(playing)} {
    sc_game undoPoint
  }

  if {$action == "mainline" || $action == "var"} {
    sc_var create
  }

  set analysis(automoveThinking$n) 0
  if { [sc_moveAdd $move $n] } {
    ### Move fail
    set res 0
    # puts "Error adding move $move"
    set analysis(waitForBestMove$n) 1
  } else {
    ::fics::checkAdd
    if {$action == "mainline"} {
      sc_var exit
      sc_var promote [expr {[sc_var count] - 1}]
      sc_move forward 1
    }
  }
    
  update idletasks ; # fixes tournament issues ?

  if {$comp(playing)} {
    if {$comp(animate)} {
      updateBoard -pgn -animate
    } else {
      updateBoard -pgn
    }  
  } else {
    updateBoard -pgn -animate
    ::utils::sound::AnnounceNewMove $move
  }
  return $res
}

### Close an engine, because its analysis window is being destroyed.

proc destroyAnalysisWin {n W} {

  # Is this working properly. We seem to have a process left S.A.

  global windowsOS analysis annotate

  if {[string trim $W] != ".analysisWin$n"} {
    # ignore individual widget destroys
    return
  }

  if {[winfo exists .configAnnotation]} {
    # Is annotation being configured ?
    set annotate(Button) 0
    destroy .configAnnotation
  } elseif {$annotate(Engine) == $n} {
    # Is annotation going ?
    set annotate(Button) 0
    cancelAutoplay
  }

  # Cancel scheduled commands
  if {$analysis(after$n) != ""} {
      after cancel $analysis(after$n)
  }

  trace remove variable analysis(exclude$n) write "excludeToolTip $n"

  # Check the pipe is not already closed:
  if {$analysis(pipe$n) == {}} {
    set ::analysisWin$n 0
    return
  }

  set pid [pid $analysis(pipe$n)]

  # Send interrupt signal if the engine wants it:
  if {(!$windowsOS)  &&  $analysis(send_sigint$n)} {
    catch {exec -- kill -s INT $pid}
  }

  # Some engines in analyze mode may not react as expected to "quit"
  # so ensure the engine exits analyze mode first
  if {$analysis(uci$n)} {
    sendToEngine $n stop
    sendToEngine $n quit
  } else  {
    sendToEngine $n exit
    sendToEngine $n quit
  }
  catch { flush $analysis(pipe$n) }

  # Uncomment the following line to turn on blocking mode before
  # closing the engine (but probably not a good idea!)
  #   fconfigure $analysis(pipe$n) -blocking 1

  # Close the engine, ignoring any errors since nothing can really
  # be done about them anyway -- maybe should alert the user with
  # a message box?
  # catch {close $analysis(pipe$n)}
  close $analysis(pipe$n)

  if {$analysis(log$n) != {}} {
    catch {close $analysis(log$n)}
    set analysis(log$n) {}
  }
  set analysis(pipe$n) {}
  set ::analysisWin$n 0

  # Erroneous if playing tournament, but ::comp(playing) is not always exact, so handled in cleanup
  ::docking::cleanup ".analysisWin$n"


  # Large tournaments can get wrecked by undead processes, so kill it to be sure
  if {(!$windowsOS)} {
    after 100 "catch {exec -- kill -s KILL $pid}"
  } else {
    # todo
  }
}

### Send a command to a running analysis engine
### this is used by all uci and xboard engines when open with their own window (eg F2, tourney)

proc sendToEngine {n text} {

  logEngine $n "Scid  : $text"
  catch {puts $::analysis(pipe$n) $text}
}

### Send a move to a running analysis engine

proc sendMoveToEngine {n move} {

  # Convert "e7e8Q" into "e7e8q" since that is the XBoard/WinBoard
  # standard for sending moves in coordinate notation:
  set move [string tolower $move]

  if {$::analysis(uci$n)} {
    # This proc is never called for UCI engines, and so below command is redundant
    sendToEngine $n "position fen [sc_pos fen] moves $move"
  } else  {
    if {$::analysis(wants_usermove$n)} {
      #  If the engine has indicated (with "usermove=1" on a "feature" line)
      #  that it wants it, send with "usermove " before the move.
      sendToEngine $n "usermove $move"
    } else {
      sendToEngine $n $move
    }
  }
}

#   Log Scid-Engine communication.

proc logEngine {n text} {
  global analysis

  # Print the log message to stdout if applicable:
  # if {$analysis(log_stdout)} { puts stdout "$n $text" }

  if { [ info exists analysis(log$n)] && $analysis(log$n) != {}} {
    puts $analysis(log$n) $text
    catch { flush $analysis(log$n) }

    # Close the log file if the limit is reached:
    incr analysis(logCount$n)
    if {$analysis(logCount$n) >= $analysis(logMax)} {
      puts $analysis(log$n) \
          "Note  : Log file size limit ($analysis(logMax) lines) reached."
      catch {close $analysis(log$n)}
      set analysis(log$n) {}
    }
  }
}

proc logEngineNote {n text} {
  logEngine $n "Note: $text"
}

# What a fucking mess this is. S.A.
# Horrible hopeless design decisions meaning this code hasnt been touched since
# - Sorry Shane ;> (mostly fixed now)
# Hmmm ... Pascal's new features/hacks were the cuplrit

proc startAnalysisWin {FunctionKey} {
  global engines
  set n $engines($FunctionKey)
  if {$n != {}} {
    makeAnalysisWin $n
  } 
}

### toggle analysis engine n

proc makeAnalysisWin {{n 0} {options {}}} {
  global analysisWin$n font_Analysis analysisCommand analysis annotate

  set w .analysisWin$n

  if {$n == -1} {
    ### Make sure an engine is opened (called by toolbar)
    ### Try F2 , then engine 0
    set n $::engines(F2)
    if {$n == {}} {
      set n 0
    }
    set w .analysisWin$n
  }


  if {[winfo exists $w]} {
    ### Stop engine and exit
    destroy $w
    focus .main
    set analysisWin$n 0
    resetEngine $n
    updateStatusBar
    update
    return
  }

  # What an f-ing mess.
  # Previously the engines were sorted , and only engine 1 or 2 (in the sort order)
  # could be used. Engines often got resorted, and the key bindings would change.
  # This was stupid, and very confusing. This rewrite will allow 
  # any engine to be configured to run as engine 1 or 2 (or 3 ...)

  resetEngine $n

  ### Previously engine[0] will run in toplevel .analysisWin1
  ### but now    engine[0] will run in toplevel .analysisWin0

  if {$n == {}  ||  $n < 0} {
    set analysisWin$n 0
    return
  }

  # Only update engine's time when it was chosen in the engines dialog box

  if {$options == {settime}} {
    ::enginelist::setTime $n
    catch {::enginelist::write}
  }

  set engineData [lindex $::engines(list) $n]
  set analysisName [lindex $engineData 0]
  set analysisCommand [ toAbsPath [lindex $engineData 1] ]
  set analysisArgs [lindex $engineData 2]
  set analysisDir [ toAbsPath [lindex $engineData 3] ]
  set analysis(uci$n) [ lindex $engineData 7 ]

  # If the analysis directory is not current dir, cd to it:
  set oldpwd {}
  if {$analysisDir != {.}} {
    set oldpwd [pwd]
    catch {cd $analysisDir}
  }

  if {! $analysis(uci$n) } {
    set analysis(multiPVCount$n) 1
  }

  # Try to execute the analysis program:
  if {[catch {set analysis(pipe$n) [open "| [list $analysisCommand] $analysisArgs" "r+"]} result]} {
    if {$oldpwd != {}} { catch {cd $oldpwd} }
    if {[winfo exists .enginelist]} {
      set parent .enginelist
    } else {
      set parent .
    }
    tk_messageBox -title "Scid: error starting analysis" \
        -icon warning -type ok -parent $parent \
        -message "Unable to start the program:\n$analysisCommand $analysisArgs\n$result"

    set analysisWin$n 0
    resetEngine $n
    return -1
  }

  set analysisWin$n 1

  # Return to original dir if necessary:
  if {$oldpwd != ""} { catch {cd $oldpwd} }

  # Open log file if applicable:
  set analysis(log$n) {}
  if {$analysis(logMax) > 0} {
    if {! [catch {open [file join $::scidLogDir "engine$n.log"] w} log]} {
      set analysis(log$n) $log
      logEngine $n "$::scidName <--> Engine communication log file (engine $n)"
      logEngine $n "Engine: $analysisName"
      logEngine $n "Command: $analysisCommand"
      logEngine $n "Arguments:  $analysisArgs"
      logEngine $n "Directory: $analysisDir"
      logEngine $n "Date: [clock format [clock seconds] -format {%d %b %Y}]"
      logEngine $n ""
    }
  }

  set analysis(name$n) $analysisName

  # Configure pipe for line buffering and non-blocking mode
  fconfigure $analysis(pipe$n) -buffering line -blocking 0

  # Set up the  analysis window:

  if {$::comp(playing)} {
    toplevel $w
    wm iconify $w
  } else {
    ::createToplevel $w
  }
  ::setTitle $w "$analysisName"

  if {$n == 1 && $analysis(mini)} {
    # Run engine in status bar. It is "niced" at procedure end.
    catch {wm state $w withdrawn}
  }

  bind $w <F1> { helpWindow Analysis }

  ### Set initial size of analysis widget
  # not sure why these args seem to be in Char and not Pixels.
  if {![info exists ::winWidth($w)]} {
    set ::winWidth($w) 44
    set ::winHeight($w) 8
  }

  setWinLocation $w
  setWinSize $w
  standardShortcuts $w

  set analysis(showBoard$n) 0

  frame $w.b
  pack  $w.b -side top -fill x
  set relief flat	; # -width 32 -height 32

  # start/stop engine analysis
  button $w.b.startStop -command "toggleEngineAnalysis $n" -relief $relief
  bind $w.b.startStop <Control-Button-1> "toggleEngineAnalysis $n ; break"

  if {$fics::playing == 1 || $fics::playing == -1} {
    set analysis(autostart$n) 0
    $w.b.startStop configure -state disabled
  } else {
    set analysis(autostart$n) [expr {$options != {nostart}}]
  }

  if {$analysis(autostart$n)} {
    $w.b.startStop configure -image tb_pause
    ::utils::tooltip::Set $w.b.startStop "$::tr(StopEngine)"
  } else {
    $w.b.startStop configure -image tb_play
    ::utils::tooltip::Set $w.b.startStop "$::tr(StartEngine)"
  }

  button $w.b.move -image tb_addmove -command "makeAnalysisMove $n" -relief $relief
  ::utils::tooltip::Set $w.b.move $::tr(AddMove)
  bind $w.b.move <Button-3> "addAnalysisScore $n"

  button $w.b.line -image tb_addvar -command "addAnalysisVariation $n" -relief $relief
  ::utils::tooltip::Set $w.b.line $::tr(AddVariation)
  # right click adds second line 
  bind $w.b.line <Button-3> "addAllVariations $n 1"

  button $w.b.alllines -image tb_addallvars -command "addAllVariations $n" -relief $relief
  ::utils::tooltip::Set $w.b.alllines $::tr(AddAllVariations)

  spinbox $w.b.multipv -from 1 -to 8 -increment 1 -textvariable analysis(multiPVCount$n) \
    -width 2 -font font_Small -command "changePVSize $n" 
  ::utils::tooltip::Set $w.b.multipv $::tr(Lines)

  set showAnnoButton 1
  for {set i 0} {$i < [llength $::engines(list)]} {incr i} {
    if {[winfo exists .analysisWin$i.b.annotatebut]} {
      set showAnnoButton 0
    }
  }

  if {$showAnnoButton} {
    checkbutton $w.b.annotatebut -image tb_annotate -indicatoron false -width 32 -height 32 \
      -variable annotate(Button) -command "initAnnotation $n" -relief $relief
    ::utils::tooltip::Set $w.b.annotatebut $::tr(Annotate)
  } else {
    button $w.b.annotatebut 
  }

  checkbutton $w.b.lockengine -image tb_lockengine -indicatoron false -width 32 -height 32 \
    -variable analysis(lockEngine$n) -command "toggleLockEngine $n" -relief $relief
  ::utils::tooltip::Set $w.b.lockengine $::tr(LockEngine)

  button $w.b.exclude -image tb_exclude -command "excludeMovePopup $n" -relief $relief
  ::utils::tooltip::Set $w.b.exclude $::tr(ExcludeMove)
  trace variable analysis(exclude$n) w "excludeToolTip $n"
  if {!$analysis(autostart$n)} {
    $w.b.exclude configure -state disabled
  }

  checkbutton $w.b.priority -image tb_cpu -indicatoron false -variable analysis(priority$n) \
    -onvalue idle -offvalue normal -command "setAnalysisPriority $n" -relief $relief -width 32 -height 32
  ::utils::tooltip::Set $w.b.priority $::tr(LowPriority)

  if {![info exists analysis(showEngineInfo$n)]} {
    set analysis(showEngineInfo$n) 0
  }

  checkbutton $w.b.showinfo -image tb_info -indicatoron false -width 32 -height 32 \
    -variable analysis(showEngineInfo$n) -command "toggleEngineInfo $n" -relief $relief
  ::utils::tooltip::Set $w.b.showinfo $::tr(ShowInfo)

  button $w.b.showboard -image tb_coords -command "toggleAnalysisBoard $n" -relief $relief
  ::utils::tooltip::Set $w.b.showboard $::tr(ShowAnalysisBoard)

  # Xboard only. This button is unpacked later if UCI
  button $w.b.update -image tb_update \
    -command "sendToEngine $n ."  -relief $relief
  ::utils::tooltip::Set $w.b.update $::tr(Update)

  set ::finishGameMode 0
  button $w.b.finishGame -image autoplay_off -command "toggleFinishGame $n"  -relief $relief
  ::utils::tooltip::Set $w.b.finishGame $::tr(FinishGame)

  checkbutton $w.b.training -image tb_training  -indicatoron false -width 32 -height 32 \
    -command "toggleAutomove $n" -variable analysis(automove$n) -relief $relief
  ::utils::tooltip::Set $w.b.training $::tr(Training)

  button $w.b.help -image tb_help  -command {helpWindow Analysis} -relief $relief
  ::utils::tooltip::Set $w.b.help $::tr(Help)
 
  if {$::macOS} {
    $w.b.startStop configure -width 30 -height 30
    $w.b.move      configure -width 30 -height 30
    $w.b.help      configure -width 30 -height 30
  }

  pack $w.b.startStop $w.b.move $w.b.line $w.b.alllines \
       $w.b.multipv $w.b.annotatebut $w.b.lockengine $w.b.exclude $w.b.priority $w.b.showinfo $w.b.showboard \
       $w.b.update $w.b.finishGame -side left
  if {!$showAnnoButton} {
    pack forget $w.b.annotatebut
  }

  if {$n == 1 || $n == 2} {
    # training only works with engines 1 and 2
    pack $w.b.training -side left -pady 2 -padx 1
  }

  pack $w.b.help -side left

  button $w.popup -image tb_popup -height 32 -width 16 -command "popupButtonBar $n" -relief flat
  placePopupButton $n
  

  # pack  $w.b.showinfo 
  if {$analysis(uci$n)} {
    $w.b.multipv configure -state readonly
    pack forget $w.b.update
    $w.b.update  configure -state disabled
    text $w.text -height 2 -font font_Small -wrap none -bg gray95
  } else  {
    # pack forget $w.b.showinfo
    # $w.b.showinfo configure -state disabled

    pack forget $w.b.multipv 
    pack forget $w.b.alllines
    $w.b.multipv configure -state disabled
    $w.b.alllines configure -state disabled
    text $w.text -height 3 -font font_Small -wrap none -bg gray95
  }

  frame $w.hist
  # This "-height 5" is here to facilitate pack/forgeting of $w.text widget
  # and for initial size
  text $w.hist.text -font font_Fixed -height 5 -highlightthickness 0 \
      -wrap none -setgrid 1 -yscrollcommand "$w.hist.ybar set" -xscrollcommand "$w.hist.xbar set"
  $w.hist.text tag configure indent -lmargin2 [font measure font_Small xxxxxxxxxxxxxxxxxx]
  scrollbar $w.hist.ybar -command "$w.hist.text yview" -takefocus 0
  scrollbar $w.hist.xbar -command "$w.hist.text xview" -orient horizontal
  if { $analysis(showEngineInfo$n) } {
    pack $w.text -side bottom -fill both 
  }
  pack $w.hist -side top -expand 1 -fill both
  pack $w.hist.ybar -side right -fill y
  pack $w.hist.xbar -side bottom -expand 0 -fill x
  pack $w.hist.text -side left -expand 1 -fill both
  bind $w.hist.text <ButtonPress-3> "toggleMovesDisplay $n"
  $w.text tag configure blue -foreground blue ; # this only seems used in toggleAutomove ???
  $w.hist.text tag configure gray -foreground grey50 -lmargin2 [font measure font_Small xxxxxxxxxxxxxxxxxx]
  $w.hist.text tag configure blue -foreground darkblue
  $w.text insert end "Please wait a few seconds for engine initialisation \
      (with some engines, you will not see any analysis until the board \
      changes. So if you see this message, try changing the board \
      by moving backward or forward or making a new move.)"
  $w.text configure -state disabled
  bind $w <Destroy> "destroyAnalysisWin $n %W"
  bind $w <Escape> "focus .main ; destroy $w"
  bind $w <Key-a> "$w.b.startStop invoke"
  bind $w <Return> "addAnalysisMove $n"
  bind $w <Control-Return> "addAnalysisVariation $n"
  bind $w <space>  "$w.b.startStop invoke"
  wm minsize $w 25 0
  bindMouseWheel $w $w.hist.text
  bindWheeltoFixed $w

  if {$analysis(uci$n)} {
    fileevent $analysis(pipe$n) readable "::uci::processAnalysisInput $n"
  } else  {
    fileevent $analysis(pipe$n) readable "processAnalysisInput $n"
  }
  after 1000 "checkAnalysisStarted $n"

  # finish MultiPV spinbox configuration
  if {$analysis(uci$n)} {
    # find UCI engine MultiPV capability

    # Wait for uciok
    while { !($analysis(uciok$n)) } { 
      # && [winfo exists .analysisWin$n]
      update
      after 200
    }
    set hasMultiPV 0
    foreach opt $analysis(uciOptions$n) {
      if { [lindex $opt 0] == "MultiPV" } {
        set hasMultiPV 1
        set min [lindex $opt 1]
        set max [lindex $opt 2]
        if {$min == ""} { set min 1}
        if {$max == ""} { set max 8}
        break
      }
    }
    set current -1
    set options  [ lindex $engineData 8 ]
    foreach opt $options {
      if {[lindex $opt 0] == "MultiPV"} { set current [lindex $opt 1] ; break }
    }
    if {$current == -1} { set current 1 }
    set analysis(multiPVCount$n) $current
    #    changePVSize $n
    catch {
      if { $hasMultiPV } {
        $w.b.multipv configure -from $min -to $max -state readonly
      } else  {
        $w.b.multipv configure -from 1 -to 1 -state disabled
	$w.b.alllines configure -state disabled
      }
    }
  } ;# end of MultiPV spinbox configuration

  # We hope the engine is correctly started at that point, so we can send the first analyze command
  # this problem only happens with winboard engine, as we don't know when they are ready
  if { !$analysis(uci$n) } {
    set analysis(side$n) [sc_pos side]
    if {$analysis(autostart$n)} {
      initialAnalysisStart $n
    }
  }
  # necessary on windows because the UI sometimes starves, also keep latest priority setting
  # if ($::windowsOS)
  if {$analysis(priority$n) == {idle} || $analysis(lowPriority) || ($n==1 && $analysis(mini)) } {
    set analysis(priority$n) idle
    setAnalysisPriority $n
  }
  # Use an arbitary window to bind to <Configure>, but some work better than others
  bind $w <Configure> " if {\"%W\" == \"$w.b\"} {recordWinSize $w ; placePopupButton $n}"
  placePopupButton $n
}

### Dock/undock Engine1 in statusbar

proc toggleMini {} {

  global analysisWin1 analysis

  if {![winfo exists .analysisWin1]} { return }

  set analysis(mini) [expr !$analysis(mini)]

  if {$analysis(mini)} {
    # make window small
    catch {wm state .analysisWin1 withdrawn}
    update
    set analysis(priority1) idle ; # nice priority
  } else {
    # make window big
    catch {wm state .analysisWin1 normal}
    updateStatusBar
    update
    .analysisWin1.hist.text yview moveto 1
    set analysis(priority1) normal ; # normal priority
  }
  setAnalysisPriority 1
}


proc findEngine {} {
  for {set i 0} {$i < [llength $::engines(list)]} {incr i} {
    if {[winfo exists .analysisWin$i]} {
      return $i
    }
  }
  return -1
}

### Add move from analysis engine n (or first analysis window, if any)

proc addAnalysisMove {{n -1}} {

  if {$n == -1} {
    set n [findEngine]
    if {$n == -1} {
      return
    }
  }

  if {$::analysis(analyzeMode$n)} {
    makeAnalysisMove $n
    # .analysisWin$n.b.move invoke
  }
}

proc addAnalysisScore {n} {
  global analysis

  set text [formatAnalysisScore $n]
  sc_game undoPoint
  sc_pos setComment "$text [sc_pos getComment]"
  updateBoard -pgn
}

proc formatAnalysisScore {n} {
  global analysis

  if {$analysis(uci$n)} {
    set tmp_moves [ lindex [ lindex $analysis(multiPV$n) 0 ] 2 ]
    set tmp_scoremate [scoreToMate $analysis(score$n) $analysis(scoremate$n)]
    if {$analysis(logName)} {
      set text [format "\[%s\] %d:%s" $analysis(name$n) $analysis(depth$n) $tmp_scoremate]
    } else {
      set text [format "%d:%s" $analysis(depth$n) $tmp_scoremate]
    }
  } else  {
    if {$analysis(logName)} {
      set text [format "\[%s\] %d:%+.2f" $analysis(name$n) $analysis(depth$n) $analysis(score$n)]
    } else {
      set text [format "%d:%+.2f" $analysis(depth$n) $analysis(score$n)]
    }
  }
  return $text
}

### Toggle whether Move History is shown (now also controls line wrap)

proc toggleMovesDisplay {n} {
  global analysis

  set analysis(movesDisplay$n) [expr {($analysis(movesDisplay$n) + 1) % 3}]
  set h .analysisWin$n.hist.text
  $h configure -state normal
  $h delete 1.0 end
  $h configure -state disabled

  if {$analysis(movesDisplay$n)} {
    if {$analysis(movesDisplay$n) == 2} {
      $h configure -wrap word
    } else {
      $h configure -wrap none
    }
    updateAnalysisText $n
  } else {
    $h configure -state normal
    $h delete 0.0 end
    $h insert end "\n\n\n     Right click to see moves\n" blue
    updateAnalysisBoard $n {}
    $h configure -state disabled
  }
}

################################################################################
# will truncate PV list if necessary and tell the engine to send N best lines
################################################################################

proc changePVSize { n } {

  global analysis

  if { $analysis(multiPVCount$n) < [llength $analysis(multiPV$n)] } {
    set analysis(multiPV$n) {}
    set analysis(multiPVraw$n) {}
  }
  if {$analysis(multiPVCount$n) == 1} {
    set h .analysisWin$n.hist.text
    catch {
      # engine may not have a gui
      $h configure -state normal
      $h delete 0.0 end
      $h configure -state disabled
    }
    set analysis(lastHistory$n) {}
  }
  if { $analysis(uci$n) } {
    # if the UCI engine was analysing, stop and restart
    if {$analysis(analyzeMode$n)} {
      # Fulvio's analysis rewrite
      stopAnalyzeMode $n
      set analysis(waitForReadyOk$n) 1
      sendToEngine $n "isready"
      set dont_stuck [ after 60000 "set ::analysis(waitForReadyOk$n) 0" ]
      vwait analysis(waitForReadyOk$n)
      after cancel $dont_stuck
      sendToEngine $n "setoption name MultiPV value $analysis(multiPVCount$n)"
      startAnalyzeMode $n
    } else  {
      sendToEngine $n "setoption name MultiPV value $analysis(multiPVCount$n)"
    }
  }
}


proc excludeMovePopup {n} {

  if {!$::analysis(analyzeMode$n)} {
    return
  }

  global excludeMove analysis

  # OS X doesnt manage the transient properly
  catch {wm withdraw .tooltip}
  set w [toplevel .excludeMove]
  wm title $w "Scid"
  wm state $w withdrawn

  label $w.label -textvar ::tr(ExcludeMove)
  pack $w.label -side top -pady 5 -padx 5

  entry $w.entry  -width 10 -textvariable excludeMove
  bind $w.entry <Escape> { .excludeMove.buttons.cancel invoke }
  bind $w.entry <Return> { .excludeMove.buttons.load invoke }
  pack $w.entry -side top -pady 5

  if {$analysis(exclude$n) != ""} {
    set excludeMove $analysis(exclude$n)
  }
  $w.entry icursor end

  set b [frame $w.buttons]
  pack $b -side top -fill x
  dialogbutton $b.load -text "OK" -command "
    excludeMove $n
    focus .main
    destroy .excludeMove
    return
  "
  dialogbutton $b.cancel -text $::tr(Cancel) -command {
    destroy .excludeMove
    focus .main
    return
  }
  packbuttons right $b.cancel $b.load

  wm geometry $w +[expr {[winfo pointerx .] - 60}]+[expr {[winfo pointery .] - 40}]
  wm state $w normal
  update
  focus $w.entry
}

proc excludeMove {n} {
  global analysis ::uci::uciInfo excludeMove

  set exclude $excludeMove
  if {$exclude == ""} {
    set allmoves ""
    set exclude ""
  } else {
    set allmoves [sc_pos movesUci]
    # remove each move from movelist
    foreach move $exclude {
      sc_game push copyfast
      if {[catch {
	sc_move addSan $move
      }]} {
	 sc_game pop
	 return
      }
      set moveUCI [lindex [sc_game moves coord] end]
      sc_game pop
      set i [lsearch -exact $allmoves $moveUCI]
      set allmoves [lreplace $allmoves $i $i]
    }
  }
  set analysis(exclude$n) $exclude
  set uciInfo(searchmoves$n) $allmoves
  updateAnalysis $n 0
}

proc excludeToolTip {n args} {
    if {$::analysis(exclude$n) == ""} {
      ::utils::tooltip::Set .analysisWin$n.b.exclude $::tr(ExcludeMove)
    } else {
      ::utils::tooltip::Set .analysisWin$n.b.exclude $::analysis(exclude$n)
    }
}
    

################################################################################
# setAnalysisPriority
#   Sets the priority class (in Windows) or nice level (in Unix)
#   of a running analysis engine.
# Note: once a process is niced on Unix, a normal user can't renice it back to 0
################################################################################

proc setAnalysisPriority {n} {
  global analysis

  # Get the process ID of the analysis engine:
  if {$analysis(pipe$n) == {}} { return }
  set pidlist [pid $analysis(pipe$n)]
  if {[llength $pidlist] < 1} { return }
  set pid [lindex $pidlist 0]

  # Set the priority class (idle or normal):
  if {$::windowsOS} {
    catch {sc_info priority $pid $analysis(priority$n)}
  } else {
    if {$analysis(priority$n) == {idle}} {
      set priority 15
    } else {
      set priority 0
    }
    catch {sc_info priority $pid $priority}
  }

  # Re-read the priority class for confirmation:
  if {[catch {sc_info priority $pid} newpriority]} { return }
  if {$::windowsOS} {
    if {$newpriority == {idle}  ||  $newpriority == {normal}} {
      set analysis(priority$n) $newpriority
    }
  } else {
    set priority normal
    if {$newpriority > 0} { set priority idle }
    set analysis(priority$n) $priority
  }
}

################################################################################
# checkAnalysisStarted
#   Called a short time after an analysis engine was started
#   to send it commands if Scid has not seen any output from
#   it yet.
################################################################################

proc checkAnalysisStarted {n} {
  global analysis
  if {$analysis(seen$n)} { return }
  # Some Winboard engines do not issue any output when
  # they start up, so the fileevent above is never triggered.
  # Most, but not all, of these engines will respond in some
  # way once they have received input of some type.  This
  # proc will issue the same initialization commands as
  # those in processAnalysisInput below, but without the need
  # for a triggering fileevent to occur.

  logEngineNote $n {Quiet engine (still no output); sending it initial commands.}

  if {$analysis(uci$n)} {
    # in order to get options
    sendToEngine $n uci
    # engine should respond uciok

    ### Why does SCID send isready here ?
    # sendToEngine $n isready

    set analysis(seen$n) 1
  } else  {
    sendToEngine $n xboard
    sendToEngine $n "protover 2"
    sendToEngine $n "easy"
    sendToEngine $n post
    # Prevent some engines from making an immediate "book"
    # reply move as black when position is sent later:
    sendToEngine $n force
    set analysis(side$n) [sc_pos side]
  }
}

proc initialAnalysisStart {n} {

  ### Xboard only
  # With Xboard engines we don't know when the startup phase is over and when the
  # engine is ready : so wait for the end of initial output and take some margin
  # to issue an analyze command

  global analysis comp

  # hack to stop initialAnalysisStart when playing a comp
  if {$comp(playing)} {
    return
  }

  update

  if { $analysis(processInput$n) == 0 } {
    after 500 initialAnalysisStart $n
    return
  }
  set cl [clock clicks -milliseconds]
  if {[expr $cl - $analysis(processInput$n)] < 1000} {
    after 200 initialAnalysisStart $n
    return
  }
  after 200 startAnalyzeMode $n 1
}

proc processAnalysisInput {n} {

  ### Xboard only
  # (see also ::uci::processAnalysisInput)
  # Called from a fileevent whenever there is a line of input
  # from an analysis engine waiting to be processed.

  global analysis comp

  # Get one line from the engine:
  set line [gets $analysis(pipe$n)]

  ### Gaviota sends nasty characters...
  ### but still doesnt work
  # set line [string map {\" {} \} {} \{ {}} [gets $analysis(pipe$n)]]


  # this is only useful at startup but costs less than 10 microseconds
  set analysis(processInput$n) [clock clicks -milliseconds]

  if {$line == {}} { return }

  logEngine $n "Engine: $line"

  if {![checkEngineIsAlive $n]} { return }

  if {! $analysis(seen$n)} {
    set analysis(seen$n) 1
    if {!$comp(playing)} {
      # First line of output from the program, so send initial commands:
      logEngineNote $n {First line from engine seen; sending it initial commands now.}
      sendToEngine $n xboard
      sendToEngine $n {protover 2}
      sendToEngine $n {easy}
      sendToEngine $n post
    }
  }

  # Check for "feature" commands so we can determine if the engine
  # has the setboard and analyze commands:

  if {[string match {feature*} $line]} {
    if {[string match {*analyze=1*} $line]} { set analysis(has_analyze$n) 1 }
    if {[string match {*setboard=1*} $line]} { set analysis(has_setboard$n) 1 }
    if {[string match {*playother=1*} $line]} { set analysis(has_playother$n) 1 }
    if {[string match {*usermove=1*} $line]} { set analysis(wants_usermove$n) 1 }
    if {[string match {*sigint=1*} $line]} { set analysis(send_sigint$n) 1 }
    if {[string match {*myname=*} $line] } {
      if { !$analysis(wbEngineDetected$n) } {
        detectWBEngine $n $line
      }
      # No need to further process detectWBEngine
      set analysis(wbEngineDetected$n) 1 

      if { [regexp "myname=\"(\[^\"\]*)\"" $line dummy name]} {
        catch {::setTitle .analysisWin$n "$name"}
      }
    }
    return
  }

  if {$comp(playing)} {

    ### Should be careful not to use $line as a list as it can contain funny chars

    switch -glob $line {
      {*y move is*} {
		 # "my move is", "My move is:"
		 set analysis(moves$n) [lrange $line 3 end]
		 set analysis(waitForBestMove$n) 0
               }
      {move *} {
		 set analysis(moves$n) [lrange $line 1 end]
		 set analysis(waitForBestMove$n) 0
	       }
      {*. ... *} {
                 # old xboard move format ? used by phalanx, Comet
                 # phalanx also uses "my move is", but doesnt seem to break tourney !?
		 set analysis(moves$n) [lrange $line 2 end]
		 set analysis(waitForBestMove$n) 0
               }
      {* mates*} {
		 # 1-0 {White mates}
		 # Ooops!
               }
      {1-0*} - {0-1*} - {resign*} {
		if {$n == $comp(white)} {
		  sc_game tags set -result 0
		  sc_pos setComment "White resigns"
		} else {
		  sc_game tags set -result 1
		  sc_pos setComment "Black resigns"
		}
		set comp(playing) 0

		### We have to send signals to both engines
		# This is to handle the case where engines move then resign/declare draw immediately,
		# eg Engine: move g2g3
		#    Engine: 1/2-1/2 {Insufficient material}
		# as we set comp(playing) to 0, and the other engines final move is never processed

		# set analysis(waitForBestMove$n) 0
		set analysis(waitForBestMove$comp(move)) 0
		set analysis(waitForBestMove$comp(nextmove)) 0
	      }

      {1/2-1/2*} {
		sc_game tags set -result =
		if {$n == $comp(white)} {
		  sc_pos setComment "White declares draw"
		} else {
		  sc_pos setComment "Black declares draw"
		}
		set comp(playing) 0

		# set analysis(waitForBestMove$n) 0
		set analysis(waitForBestMove$comp(move)) 0
		set analysis(waitForBestMove$comp(nextmove)) 0
	      }
    }

    # (Other)
    # Scid  : g2g3
    # Scid  : go
    # Engine: Error (command not legal now): g2g3

    ### Quit processAnalysisInput when playing a computer tournament
    ### Hmmm... stops proper detecting of winboard engines if they don't have protover 2
    return

  }

  # Scan the line from the engine for the analysis data

  set res [scan $line "%d%c %d %d %s %\[^\n\]\n" \
      temp_depth dummy temp_score \
      temp_time temp_nodes temp_moves]
  if {$res == 6} {
    if {$analysis(invertScore$n) && $analysis(side$n) == "black"} {
      set temp_score [expr { 0.0 - $temp_score } ]
    }
    if {$analysis(maxPly) > 0} {
      set temp_moves [lrange $temp_moves 0 [expr {$analysis(maxPly) - 1}]]
    }
    set analysis(depth$n) $temp_depth
    set analysis(score$n) $temp_score
    # Convert score to pawns from centipawns:
    set analysis(score$n) [expr {double($analysis(score$n)) / 100.0} ]
    set analysis(moves$n) [formatAnalysisMoves $temp_moves]
    set analysis(time$n) $temp_time
    set analysis(nodes$n) [calculateNodes $temp_nodes]

    # Convert time to seconds from centiseconds
    if {! $analysis(wholeSeconds$n)} {
      set analysis(time$n) [expr {double($analysis(time$n)) / 100.0} ]
    }

    updateAnalysisText $n

    if {! $analysis(seenEval$n)} {
      # This is the first evaluation line seen, so send the current
      # position details to the engine:
      set analysis(seenEval$n) 1
    }

    return
  }


  # Check for a "stat01:" line, the reply to the "." command:

  if {! [string compare [string range $line 0 6] "stat01:"]} {
    if {[scan $line "%s %d %s %d" \
          dummy temp_time temp_nodes temp_depth] == 4} {
      set analysis(depth$n) $temp_depth
      set analysis(time$n) $temp_time
      set analysis(nodes$n) [calculateNodes $temp_nodes]
      # Convert time to seconds from centiseconds:
      if {! $analysis(wholeSeconds$n)} {
        set analysis(time$n) [expr {double($analysis(time$n)) / 100.0} ]
      }
      updateAnalysisText $n
    }
    return
  }

  # Check for other engine-specific lines:
  # The following checks are intended to make Scid work with
  # various WinBoard engines that are not properly configured
  # by the "feature" line checking code above (probably because the do not have protover 2 support)
  if { !$analysis(wbEngineDetected$n) } {
    detectWBEngine $n $line
  }

}

### Returns 0 if engine died abruptly or 1 otherwise
### this is used by all uci and xboard engines when open with their own window (eg F2, tourney)

proc checkEngineIsAlive {n} {
  global analysis comp errorCode

  if {![eof $analysis(pipe$n)]} {
    return 1
  }

  fileevent $analysis(pipe$n) readable {}

  set exit_status 0
  if {[catch {close $analysis(pipe$n)}  standard_error] != 0} {
    if {[lindex $errorCode 0] == "CHILDSTATUS"} {
	set exit_status [lindex $errorCode 2]
    }
  }

  set analysis(pipe$n) {}
  logEngineNote $n {Engine terminated without warning.}

  if {[winfo exists .comp] && $comp(playing)} {
    puts "Engine $n terminated without warning. Game over"
    compGameEnd [expr {!($n == $comp(white))}] {Engine crashed}
  } else {
    catch {destroy .analysisWin$n}
    if {[winfo exists .enginelist]} {
      set parent .enginelist
    } else {
      set parent .
    }
    if { $exit_status != 0 } {
	logEngineNote $n {Engine terminated with exit code $exit_status: "\"$standard_error\""}
	tk_messageBox -type ok -icon info -parent $parent -title "Scid" \
		      -message "The analysis engine terminated with exit code $exit_status: \"$standard_error\""
    } else {
	logEngineNote $n {Engine terminated without exit code: "\"$standard_error\""}
	tk_messageBox -type ok -icon info -parent $parent -title "Scid" \
		      -message "The analysis engine terminated without exit code: \"$standard_error\""
    }

  }
  return 0
}

### Xboard only
#   Given the text at the end of a line of analysis data from an engine,
#   this proc tries to strip out some extra stuff engines add to make
#   the text more compatible for adding as a variation.

proc formatAnalysisMoves {text} {

  # Trim any initial or final whitespace:
  set text [string trim $text]

  # Crafty adds "<HT>" for a hash table comment. Change it to "{HT}"
  # Could probably remove this hack and it'd work fine, but leave it in i guess - S.A.
  regsub <HT> $text {{HT}} text

  return $text
}

### Engine plays game till the end

proc toggleFinishGame {n} {
  global analysis annotate

  set b ".analysisWin$n.b.finishGame"

  if { $annotate(Button) || $::autoplayMode || !$analysis(analyzeMode$n) } {
    return
  }
  if {! [sc_pos isAt vend]} {
      sc_var create
  }

  set ::finishGameMode [expr ! $::finishGameMode]
  if {$::finishGameMode} {
    $b configure -image autoplay_on
    after $::autoplayDelay autoplayFinishGame $n
  } else  {
    $b configure -image autoplay_off
    after cancel autoplayFinishGame
  }
}

proc autoplayFinishGame {n} {
  if {!$::finishGameMode || ![winfo exists .analysisWin$n]} {return}
  .analysisWin$n.b.move invoke
  if { [string index [sc_game info previousMove] end] == {#}} {
    toggleFinishGame $n
    return
  }
  after $::autoplayDelay autoplayFinishGame $n
}

### Start/stop engine analysis

proc toggleEngineAnalysis {{n -1}} {
  global analysis annotate

  if {$n == -1} {
    if {$fics::playing == 1 || $fics::playing == -1} {
      return
    }
    set n [findEngine]
    if {$n == -1} {
      return
    }
    raiseWin .analysisWin$n
  }

  set b .analysisWin$n.b.startStop
  set analysis(lastHistory$n) hmmm

  if {$analysis(analyzeMode$n)} {
    stopAnalyzeMode $n
    $b configure -image tb_play
    if {[sc_pos moves] == {}} {
      # remove checkmate/stalemate text
      set h .analysisWin$n.hist.text
      $h configure -state normal
      $h delete 1.0 end
      $h configure -state disabled
    } 
    ::utils::tooltip::Set $b "$::tr(StartEngine)"
    .analysisWin$n.b.exclude configure -state disabled
    set analysis(exclude$n) ""
  } else  {
    startAnalyzeMode $n
    $b configure -image tb_pause
    ::utils::tooltip::Set $b "$::tr(StopEngine)"
    .analysisWin$n.b.exclude configure -state normal
  }
}

###   Put the engine in analyze mode.

proc startAnalyzeMode {{n 0} {force 0}} {
  global analysis

  # Check that the engine has not already had analyze mode started:
  if {$analysis(analyzeMode$n) && ! $force } {
    return
  }
  set analysis(analyzeMode$n) 1
  if { $analysis(uci$n) } {
    updateAnalysis $n
  } else  {
    if {$analysis(has_setboard$n)} {
      sendToEngine $n "setboard [sc_pos fen]"
    }
    if { $analysis(has_analyze$n) } {
      # why is this commented out. It crashes engine when re-instated S.A
      #updateAnalysis $n
      sendToEngine $n analyze
    } else  {
      updateAnalysis $n ;# in order to handle special cases (engines without setboard and analyse commands)
    }
  }
}

proc stopAnalyzeMode { {n 0} } {
  global analysis
  if {! $analysis(analyzeMode$n)} { return }
  set analysis(analyzeMode$n) 0
  if { $analysis(uci$n) } {
    if {$analysis(after$n) != ""} {
      after cancel $analysis(after$n)
      set analysis(after$n) ""
    }
    sendToEngine $n stop
    set analysis(go$n) 0
  } else  {
    sendToEngine $n exit
  }
  set analysis(startpos$n) ""
}

### Called when analysis 'lock' button is pressed (which toggles analysis(lockEngine$n))

proc toggleLockEngine {n} {
  global analysis

  if { $analysis(lockEngine$n) } {
    set state disabled
    set analysis(lockN$n)    [sc_pos moveNumber]
    set analysis(side$n)     [sc_pos side] ; # do we need this here. It is set in updateAnalysis
    set analysis(lockPos$n)  [sc_pos board]
    set analysis(lockFen$n)  [sc_pos fen]
    if {[winfo exists .analysisWin$n.bd]} {
      ::board::update .analysisWin$n.bd $analysis(lockPos$n)
    }
    ::utils::tooltip::Set .analysisWin$n.b.lockengine "[file tail [sc_base filename]], game [sc_game number]"
  } else {
    set state normal
    ::utils::tooltip::Set .analysisWin$n.b.lockengine $::tr(LockEngine)
  }
  set w .analysisWin$n
  foreach b {move line exclude alllines training annotatebut finishGame} {
    $w.b.$b configure -state $state
  }
  if {$analysis(uci$n)} {
    $w.b.multipv configure -state $state
  }
  updateAnalysis $n
}

### Update the text in an analysis window.

proc updateAnalysisText {n} {
  global analysis

  if {!$analysis(movesDisplay$n)} {
    return
  }

  if {$analysis(currmovenumber$n) > $analysis(maxmovenumber$n) } {
    set analysis(maxmovenumber$n) $analysis(currmovenumber$n)
  }

  if {$analysis(time$n) > 0.0} {
    set nps [expr {round($analysis(nodes$n) / $analysis(time$n))} ]
  } else {
    set nps 0
  }

  set score $analysis(score$n)

  set t .analysisWin$n.text

  if {$analysis(showEngineInfo$n)} {

    $t configure -state normal
    $t delete 0.0 end

    if { $analysis(uci$n) } {
      if { [expr abs($score)] >= 327.0 } {
	if { [catch { set tmp [format "M%d" $analysis(scoremate$n)]} ] } {
	  set tmp [format "%+.2f " $score]
	}
      } else {
	set tmp [format "%+.2f " $score]
      }
      $t insert end "\[$tmp\]  "

      $t insert end "[tr Depth]: "
      if {$analysis(showEngineInfo$n) && $analysis(seldepth$n) != 0} {
	$t insert end [ format "%2u/%u  " $analysis(depth$n) $analysis(seldepth$n)]
      } else {
	$t insert end [ format "%2u  " $analysis(depth$n) ]
      }
      $t insert end "[tr Nodes]: "
      $t insert end [ format "%6uK (%u kn/s) " $analysis(nodes$n) $nps ]
      $t insert end "[tr Time]: "
      $t insert end [ format "%6.2f s" $analysis(time$n) ]
      $t insert end \n
      $t insert end "NPS: [format "%u " $analysis(nps$n)] "
      $t insert end "Hash: $::uci::uciInfo(hashfull$n)  "
      $t insert end "Load: $::uci::uciInfo(cpuload$n) "
      $t insert end "TB hits: $::uci::uciInfo(tbhits$n) "
      $t insert end "[tr Current]: "
      $t insert end [ format "%s (%s/%s) " [::trans $analysis(currmove$n)] $analysis(currmovenumber$n) $analysis(maxmovenumber$n)]
    } else {
      set newStr [format "Depth:   %6u      Nodes: %6uK (%u kn/s)\n" $analysis(depth$n) $analysis(nodes$n) $nps]
      append newStr [format "Score: %+8.2f      Time: %9.2f seconds\n" $score $analysis(time$n)]
      $t insert 1.0 $newStr
    }
  } ; #  if {showEngineInfo}

  if {$analysis(automove$n)} {
    # todo : hmmm S.A &&&
    if {$analysis(automoveThinking$n)} {
      set moves {   Thinking..... }
    } else {
      set moves {   Your move..... }
    }

    if { ! $analysis(uci$n) } {
      $t insert end $moves blue
    }
    $t configure -state disabled
    updateAnalysisBoard $n {}
    return
  }

  if { $analysis(uci$n) } {
    set moves [ lindex [ lindex $analysis(multiPV$n) 0 ] 2 ]
  } else  {
    set moves $analysis(moves$n)
  }

  if {$moves == {}} {
    return
  }

  set h .analysisWin$n.hist.text

  $h configure -state normal
  set cleared 0
  if { $analysis(depth$n) < $analysis(prevdepth$n)  || $analysis(prevdepth$n) == 0 } {
    $h delete 1.0 end
    set analysis(lastHistory$n) hmmm
    set cleared 1
  }

  # Skip update if no change in movelist since last analysis (and no MultiPV)

  if {$analysis(lastHistory$n) != $moves || $analysis(multiPVCount$n) != 1} {

    set analysis(lastHistory$n) $moves
    set line {}

    if { $analysis(uci$n) } {
      if {$cleared} {
        set analysis(multiPV$n) {}
        set analysis(multiPVraw$n) {}
      }
      if {$analysis(multiPVCount$n) == 1} {
	set newhst [format {%2d [%s]  %s} \
		  $analysis(depth$n) \
		  [scoreToMate $score $analysis(scoremate$n)]  \
		  [addMoveNumbers $n [::trans $moves]]]

	append line [format "%s (%.2f)\n" $newhst $analysis(time$n)]
      } else {
	# MultiPV

	$h delete 1.0 end
	# First line is in bold. Other diffs ??
	set pv [lindex $analysis(multiPV$n) 0]
	catch { set newStr [format "%2d \[%s\]  " [lindex $pv 0] [scoreToMate $score [lindex $pv 3]] ] }

	$h insert end {1. } blue
	append newStr "[addMoveNumbers $n [::trans [lindex $pv 2]]]\n"
	$h insert end $newStr indent

	set lineNumber 1
	foreach pv $analysis(multiPV$n) {
	  if {$lineNumber == 1} { incr lineNumber ; continue }
	  $h insert end "$lineNumber. " blue
	  set score [scoreToMate [lindex $pv 1] [lindex $pv 3]]
	  $h insert end [format "%2d \[%s\]  %s\n" [lindex $pv 0] $score [addMoveNumbers $n [::trans [lindex $pv 2]]] ] gray
	  incr lineNumber
	}
      }
    } else  {
      # Original Scid analysis display
      append line [format "%2d \[%+5.2f\]  %s (%.2f)\n" $analysis(depth$n) $score [::trans $moves] $analysis(time$n)] 
    }

    if { $n == 1 && $analysis(mini) } {
      # show in status bar
      if {[string is ascii -strict %s]} {
	set s [string range $line [string first {[} $line] 50]
	if {$s != {}} {
	  set ::statusBar "   [lindex $analysis(name1) 0]: [string map {\n {}} $s]"
	}
      }
    } 

    ### Should we truncate line so it only takes up one line ? S.A.
    $h insert end $line indent
    # $h see end-1c
    set pos [lindex [ .analysisWin$n.hist.ybar get ] 1]
    if {$pos == 1.0} {
      $h yview moveto 1
    }
  } else {
  }

  $h configure -state disabled
  set analysis(prevdepth$n) $analysis(depth$n)
  if { ! $analysis(uci$n) } {
    $t insert end [::trans $moves] blue
  }
  $t configure -state disabled

  updateAnalysisBoard $n $analysis(moves$n)
}


### returns Mx if score-to-mate set, or (formatted) original score otherwise
# The old scoreToMate took the pv and looked for a trailing "#",
# but this failed when engines didn't give the full PV even when mate-in-N is known.
# Now, the full PV to mate may not be given, but the returned Mx is correct more often, (plus major speed bump!)

proc scoreToMate {score scoremate} {
  if {$scoremate != 0 && $scoremate != {}} {
    return M[expr {abs($scoremate)}]
  } else {
    return [format "%+5.2f" $score]
  }
}

### Returns the PV with move numbers added

proc addMoveNumbers { e pv } {
  global analysis

  if { $analysis(lockEngine$e) } {
    set n $analysis(lockN$e)
  } else {
    set n [sc_pos moveNumber]
  }
    set turn $analysis(side$e)

  # space between number and move
  if {$::pgn::moveNumberSpaces} {
    set spc { }
  } else {
    set spc {}
  }
  set start 0
  if {$turn == {black}} {
    set ret "$n.$spc... [lindex $pv 0] "
    incr start 
    incr n
  } else {
    set ret {}
  }

  for {set i $start} {$i < [llength $pv]} {incr i} {
    set m [lindex $pv $i]
    if { [expr $i % 2] == 0 && $start == 0 || [expr $i % 2] == 1 && $start == 1 } {
      append ret "$n.$spc$m "
    } else  {
      append ret "$m "
      incr n
    }
  }
  return $ret
}

###  Toggle whether the small analysis board is shown

proc toggleAnalysisBoard {n} {
  global analysis
  set w .analysisWin$n

  # init if doesnt exist
  if {![winfo exists $w.bd]} {
    ::board::new $w.bd 25 0 $::board::_flip(.main.board)
    $w.bd configure -relief solid -borderwidth 1
  }
  if {$analysis(lockEngine$n)} {
    ::board::update $w.bd $analysis(lockPos$n)
  }

  if { $analysis(showBoard$n) } {
    set analysis(showBoard$n) 0
    pack forget $w.bd
    # setWinSize .analysisWin$n
    # bind $w <Configure> "recordWinSize $w"
  } else {
    # bind $w <Configure> {}
    set analysis(showBoard$n) 1
    pack $w.bd -side bottom -before $w.hist 
    update
    $w.hist.text configure -setgrid 1
    $w.text configure -setgrid 1
  }
}

proc toggleEngineInfo {n} {
  global analysis

  # Note - CPUload and Hashfull don't seem to work for many engines

  if { $analysis(showEngineInfo$n) } {
    pack .analysisWin$n.text -side bottom -fill both
  } else {
    pack forget .analysisWin$n.text
  }
  updateAnalysisText $n
}

### Update the small analysis board in the analysis window,

proc updateAnalysisBoard {n moves} {
  global analysis

  if {!$analysis(showBoard$n)} {
    return
  }

  set bd .analysisWin$n.bd
  if {$::board::_flip($bd) != $::board::_flip(.main.board)} {
    ::board::flip $bd
  }

  if {$analysis(lockEngine$n)} {
    return
  }

  # Push a temporary copy of the current game:
  sc_game push copyfast

  # Make the engine moves and update the board:
  sc_moveAdd $moves $n
  ::board::update $bd [sc_pos board]

  # Pop the temporary game:
  sc_game pop
}

# Fulvio's analysis rewrite

################################################################################
#   Wait for the engine to be ready then send position and go infinite
#   delay: delay the commands - INTERNAL - DON'T USE OUTSIDE sendPosToEngineUCI
################################################################################

proc sendPosToEngineUCI {n  {delay 0}} {

    global analysis ::uci::uciInfo

    if {$analysis(after$n) != ""} {
	after cancel $analysis(after$n)
	set analysis(after$n) ""
    }


    if {$analysis(waitForReadyOk$n) } {
        # If too slow something is wrong: give up
        if {$delay > 250} {
          return
        }
        # Engine is not ready: process events, idle tasks and then call me back
        incr delay
        set cmd "set ::analysis(after$n) "
        append cmd { [ } " after $delay sendPosToEngineUCI $n $delay " { ] }
        set analysis(after$n) [eval [list after idle $cmd]]
    } else {
        if {[sc_pos moves] == {}} {
	  set h .analysisWin$n.hist.text
	  $h configure -state normal
	  $h delete 1.0 end
          if {[sc_pos isCheck]} {
	    $h insert 1.0 ($::tr(checkmate))
          } else {
	    $h insert 1.0 ($::tr(stalemate))
          }
          # $h insert 1.0 "[tr No] [tr Moves]"
	  $h configure -state disabled
          return
        }
        ### Dont send position if annotating and in book
	if { $::annotate(Engine) == $n && ! $::wentOutOfBook && $::useAnalysisBook} {
	  bookAnnotation
	  return
        }

	if {$analysis(movelist$n) == {}} {
	  sendToEngine $n "position $analysis(startpos$n)"
	} else {
	  sendToEngine $n "position $analysis(startpos$n) moves $analysis(movelist$n)"
	}

        if {$uciInfo(searchmoves$n) == ""} {
	  sendToEngine $n "go infinite"
        } else {
	  sendToEngine $n "go infinite searchmoves $uciInfo(searchmoves$n)"
        }
        set analysis(go$n) 1

	# Should we issue "ucinewgame" when we move between games/bases ? S.A.
	#
	#  this is sent to the engine when the next search (started with "position" and "go") will be from
	#  a different game. This can be a new game the engine should play or a new game it should analyse but
	#  also the next position from a testsuite with positions only.
	#  If the GUI hasn't sent a "ucinewgame" before the first "position" command, the engine shouldn't
	#  expect any further ucinewgame commands as the GUI is probably not supporting the ucinewgame command.
	#  So the engine should not rely on this command even though all new GUIs should support it.
	#  As the engine's reaction to "ucinewgame" can take some time the GUI should always send "isready"
	#  after "ucinewgame" to wait for the engine to finish its operation.

	if {$n == $::annotate(Engine) && $::pause} {
	  set ::pause 0
	}
    }
}

proc updateAnalysisWindows {} {
  for {set i 0} {$i < [llength $::engines(list)]} {incr i} {
    if {[winfo exists .analysisWin$i]} {
      updateAnalysis $i
    }
  }
}

###   Update an analysis window by sending the current board

proc updateAnalysis {{n 0} {reset 1}} {

  global analysis analysisWin windowsOS

  if {$analysis(lockEngine$n)} {
    return
  }

  set analysis(side$n) [sc_pos side]

  if {$::comp(playing) ||
      $analysis(pipe$n) == {} ||
      !$analysis(seen$n) ||
      !$analysis(analyzeMode$n) } {
    return
  }
  # analysis(seen$n)        - output has been seen from the analysis program yet
  # analysis(analyzeMode$n) - analysis is running
  # analysis(lockEngine$n) -  engine is locked

  set old_movelist $analysis(movelist$n)
  set movelist [sc_game moves coord]

  ### seems erroneous... what about vars/backtracking ??
  # if {$movelist == $old_movelist} { return }

  if {$movelist == "0000"} {
    # null move in this line, so just go by fen
    set movelist ""
    set nonStdStart 1
    set analysis(startpos$n) "fen [sc_pos fen]"
  } else {
    # these should probably be set somewhere else, but this
    # proc is called for any change in board position (including new games, and simple moves)
    set nonStdStart [sc_game startBoard]
    if {$nonStdStart} {
      sendToEngine $n "setoption name UCI_Chess960 value true"
      set analysis(startpos$n) "fen [sc_game startPos]"
    } else {
      set analysis(startpos$n) startpos
    }
  }
  # puts $movelist
  set analysis(movelist$n) $movelist
  set analysis(nonStdStart$n) $nonStdStart

  if {$n == $::annotate(Engine)} {
    # update engine annotation
    # todo - test if we need this
    # update idletasks
  }

  if { $analysis(uci$n) } {

    ### UCI

    if {$reset} {
      set analysis(exclude$n) ""
      set ::uci::uciInfo(searchmoves$n) {}

    }
    if {$analysis(after$n) == "" } {
       if { $analysis(startpos$n) != "" && $analysis(go$n)} {
         sendToEngine $n "stop"
	 set analysis(go$n) 0
       }
       set analysis(waitForReadyOk$n) 1
       sendToEngine $n "isready"
       set analysis(after$n) [after idle "sendPosToEngineUCI $n"]
    }
    # todo fix non-standard starts S.A

    set analysis(maxmovenumber$n) 0

  } else {

    ### Xboard

    if { $::annotate(Engine) == $n && ! $::wentOutOfBook && $::useAnalysisBook} {
      bookAnnotation
      return
    }

    #TODO: remove 0.3s delay even for other engines

    # If too close to the previous update, and no other future update is
    # pending, reschedule this update to occur in another 0.3 seconds:

    if {[catch {set clicks [clock clicks -milliseconds]}]} {
      set clicks [clock clicks]
    }
    set analysis(side$n) [sc_pos side]
    set diff [expr {$clicks - $analysis(lastClicks$n)} ]
    if {$diff < 300  &&  $diff >= 0} {
      if {$analysis(after$n) == {}} {
	set analysis(after$n) [after 300 updateAnalysis $n]
      }
      return
    }
    set analysis(lastClicks$n) $clicks
    set analysis(after$n) {}
    after cancel updateAnalysis $n

    if {$analysis(has_analyze$n)} {

      ### Xboard engine supports "analyze"

      # Get out of analyze mode, to send moves.
      sendToEngine $n "exit"
      
      ### Try living without this Crafty hack S.A.
      # On Crafty, "force" command has different meaning when not in
      # XBoard mode, and some users have noticed Crafty not being in
      # that mode at this point -- although I cannot reproduce this.
      # So just re-send "xboard" to Crafty to make sure:
      # if {$analysis(isCrafty$n)} { sendToEngine $n xboard }
      
      # Stop engine replying to moves.
      sendToEngine $n "force"

      # Check if the setboard command must be used -- that is, if the
      # previous or current position arose from a non-standard start.
      
      ### Use "setboard" if supported, and return (this is provides less error prone behavior)

      if {$analysis(has_setboard$n)} {
	sendToEngine $n "setboard [sc_pos fen]"

	# "mn" command is specific to crafty
	if {$analysis(isCrafty$n)} {
          sendToEngine $n "mn [sc_pos moveNumber]"
        }
	sendToEngine $n analyze
	return
      }
      
      ### Ok- no "setboard"

      if {$nonStdStart} {
        set analysis(moves$n) "  Sorry, this game has a non-standard start position."
        updateAnalysisText $n
        return
      }
      
      set oldlen [llength $old_movelist]
      set newlen [llength $movelist]
      
      # Check for optimization to minimize the commands to be sent:
      # Scid sends "undo" to backup wherever possible, and avoid "new" as
      # on many engines this would clear hash tables, causing poor
      # hash table performance.
      
      # Send just the new move if possible (if the new move list is exactly
      # the same as the previous move list, with one extra move):
      if {($newlen == $oldlen + 1) && ($old_movelist == [lrange $movelist 0 [expr {$oldlen - 1} ]])} {
	sendMoveToEngine $n [lindex $movelist $oldlen]
	
      } elseif {($newlen + 1 == $oldlen) && ($movelist == [lrange $old_movelist 0 [expr {$newlen - 1} ]])} {
	# Here the new move list is the same as the old list but with one
	# less move, just send one "undo":
	sendToEngine $n undo
	
      } elseif {$newlen == $oldlen  &&  $old_movelist == $movelist} {
	
	# Here the board has not changed, so send nothing
	
      } else {
	
	# Otherwise, undo and re-send all moves:
	for {set i 0} {$i < $oldlen} {incr i} {
	  sendToEngine $n undo
	}
	foreach m $movelist {
	  sendMoveToEngine $n $m
	}
	
      }
      
      sendToEngine $n analyze
      
    } else {

      ### Xboard engine doesn't support "analyze"
      
      # In this case, Scid just sends "new", "force" and a bunch
      # of moves, then sets a very long search time/depth and
      # sends "go". This is not ideal but it works OK for engines
      # without "analyze" that I have tried.
      
      # If Unix OS and engine wants it, send an INT signal:
      if {(!$windowsOS)  &&  $analysis(send_sigint$n)} {
	catch {exec -- kill -s INT [pid $analysis(pipe$n)]}
      }
      sendToEngine $n new
      sendToEngine $n force
      if { $nonStdStart && ! $analysis(has_setboard$n) } {
	set analysis(moves$n) "  Sorry, this game has a non-standard start position."
	updateAnalysisText $n
	return
      }
      if {$analysis(has_setboard$n)} {
	sendToEngine $n "setboard [sc_pos fen]"
      } else  {
	foreach m $movelist {
	  sendMoveToEngine $n $m
	}
      }
      # Set engine to be white or black:
      sendToEngine $n $analysis(side$n)
      # Set search time and depth to something very large and start search:
      sendToEngine $n {st 120000}
      sendToEngine $n {sd 50}
      sendToEngine $n post
      sendToEngine $n go
    }
  }
}

set temptime 0
trace variable temptime w {::utils::validate::Regexp {^[0-9]*\.?[0-9]*$}}

proc setAutomoveTime {{n 0}} {
  global analysis temptime dialogResult
  set ::tempn $n
  set temptime [expr {$analysis(automoveTime$n) / 1000.0} ]
  set w .apdialog
  toplevel $w
  #wm transient $w .analysisWin
  wm state $w withdrawn
  wm title $w "Engine thinking time"
  wm resizable $w 0 0
  label $w.label -textvar ::tr(AnnotateTime)
  pack $w.label -side top -pady 5 -padx 5
  entry $w.entry -width 10 -textvariable temptime -justify center -relief flat
  pack $w.entry -side top -pady 5
  bind $w.entry <Escape> { .apdialog.buttons.cancel invoke }
  bind $w.entry <Return> { .apdialog.buttons.ok invoke }

  addHorizontalRule $w

  set dialogResult {}
  set b [frame $w.buttons]
  pack $b -side top -fill x
  dialogbutton $b.cancel -textvar ::tr(Cancel) -command {
    focus .main
    catch {grab release .apdialog}
    destroy .apdialog
    focus .main
    set dialogResult Cancel
  }
  dialogbutton $b.ok -text OK -command {
    catch {grab release .apdialog}
    if {$temptime < 0.1} { set temptime 0.1 }
    set analysis(automoveTime$tempn) [expr {int($temptime * 1000)} ]
    focus .main
    catch {grab release .apdialog}
    destroy .apdialog
    focus .main
    set dialogResult OK
  }

  pack $b.cancel $b.ok -side right -padx 5 -pady 5
  placeWinOverParent $w .analysisWin$n
  wm state $w normal
  focus $w.entry
  update
  catch {grab .apdialog}
  tkwait window .apdialog
  if {$dialogResult != "OK"} {
    return 0
  }
  return 1
}

proc toggleAutomove {n} {
  global analysis
  if {! $analysis(automove$n)} {
    cancelAutomove $n
  } else {
    set analysis(automove$n) 0
    if {! [setAutomoveTime $n]} {
      return
    }
    set analysis(automove$n) 1
    automove $n
  }
}

proc cancelAutomove {n} {
  global analysis
  set analysis(automove$n) 0
  after cancel "automove $n"
  after cancel "automoveGo $n"
}

proc automove {n} {
  global analysis autoplayDelay
  if {! $analysis(automove$n)} { return }
  after cancel "automove $n"
  set analysis(automoveThinking$n) 1
  after $analysis(automoveTime$n) "automoveGo $n"
}

proc automoveGo {n} {
  global analysis
  if {$analysis(automove$n)} {
    if {[makeAnalysisMove $n]} {
      set analysis(autoMoveThinking$n) 0
      updateBoard -pgn
      after cancel "automove $n"
      ::tree::doTraining $n
    } else {
      after 1000 "automove $n"
    }
  }
}


proc sc_moveAdd { moves n } {
  if { $::analysis(uci$n) } {
    return [ catch { sc_move addUCI $moves } ]
  } else  {
    return [ catch { sc_move addSan $moves } ]
  }
}

### Analysis widget icons

image create photo tb_cpu -data {
R0lGODlhGAAYAOeiAAAAAAABAQECAgICAgIDAwUFBQYGBgYHCAgICDE1JzI1JzI2JzM3KDU5
Kjg8LTk9Ljk9Lzo+MDs/MTtALDxAMj1AMjxCLTxCLj1BMj5CND9FMEJIMkNKM0VMNE5VPFFX
P1ZfQlheR11mR15TuWBmUGFqSWJoU2FrSmNtS2RtTGNZvGRuTGVvTWVbvWZwTWdxTmddvmlv
Wml0UGp0UGthwGx2Umx2U2x3Um50YG1jwW14U255U255VG55VW9lwm96VG96VXB7VXB7VnF8
V3J8WHN5ZnJ9V3J9WHNpxHN+WXR/WnaAXHeBXXl+bHeCXnp/bXlvx3iDX3qAbXuAbnqEYXyB
b3txyHuFYn2CcHyGY3yGZH1zyX2HZX6HZYGCgYCFdH92yn+JZ4CKaIF4y4GLaYOId4KMa4WO
boaQcId+zomSc4qTdYuD0IyVd42Vd4+H0pCZe5WUipWVjJKK05KbfpSM1JaO1ZefhJiR1pqT
152V2KKhmJ+Y2aGa2qOd26af3Kii3a2to6+p4LGs4bax47iz5L29tr245sDAwMTDusXFvMnI
wMzLw9jSm9nTnNDQx9rTnN7Xn9bVzuLcouTdpOXepOfgpujhpt7e1+nip+rjqODf2uDf3ODg
3OHg3O3mqu3mq+3mrP//////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
/////////////////////////////////yH5BAEKAP8ALAAAAAAYABgAAAj+AP8JHEiwoMGD
CBMqRAigoUMABh9K/AdAlMWLoiASBNBD0xFQH4mEoojxosaBAG5UqkHphqUZk0iWzLiRwYIG
DypEkABhgcySEB0ykFJmyhcpRXDEIEERkdOniIKCytTgyR06a9SYMXNFyU+MQZPocIAFzpks
YboYCfLjq0mKmjI9qOLGDJdOnjY94uHWYtAhQDBgaSNGCydJjBLpoOilsWMvQT9dotAEjZMo
mBYp2iPjX4FDhAgVKjRIT9AjQjLgIEMliaFAcuKs+GeAECBAfvTgSRNZrokuSYKw1cHiBO1B
fvrosWNnS9AlNhiEYLJDRooSIkCAoC2oT546deZwQAnakMEHDx04aLAw4cKGfwi62wH/BsnJ
8gsS5Few/98BQHiAVwcbNJwkEAAyROICJC84gkIj/wjwR4BzvDFGDgEUBEAQn3Do4Sf/EMAH
GySCYQUMBlIkkUP/DGAFEj7A0IIKI6S40IoNLaTjjjsGBAA7
}

image create photo tb_training -data {
R0lGODlhHgAeAOffAAEBAQUFBAgIBwsLCgsLCw8PDRERDxISEBUVExgYFSAg
HiIiIiMjHiUlISoqKC0tKy0tLC4uLTY2Mjw8NkZGQ0hIRUtLSUxMS1BPSldT
RlhVSVpVRVdXV1lZWFtaUWJaQFxcWF5eWWNfTWBgXmJhYGVkYGplTGVlX2hl
V2VlYGZmZmhoYmtqZGxraHZtSHVuVHVvVW9vbnhwTnFxb3JyanJycHh4dHl5
eXp6dX59en9/fouAUomAYoSAdYKCgISEhIeGf4eGg5WHVImJiZSKY5CQjaCT
XZOTj5WTj6SWZJ6Zhpqal5ycnKOdiJ+elKyfdqGhn6Ojobanaqampripb7ap
erWpfqmpprusaq6tqa6ursSxbL2yiLOzs8e1b7W1tbm5tsq8iM69d8q+ksm+
lb6+vtLAdb+/v9TCdNXCdtHCisTExNnGd8XFxcbGxMjIxt3KedvKgsvLyMvL
y9/NhMzMzNrOos/PzePRhefUiOfUitXV1erXiOjXm9fX1OvYkNfX1+rZjezZ
jfHbjPHciPHcie7ck+3dk/HdkfHfjvLflvHglfPgkN/f3/PhkfXhk/XikPHi
nPTilfXjkvTjleHh4fXjlfLjnvXjmPPkn/Xknfblk/flkePj4/Xlovbml/jm
kvfln/PlrfLmrPLmrvjnmvbno/bnpfXnqvnomvXoqPjpqffqrvfqr/jqsfXq
u/nrrPXqxPjrtPXrxPXryevr6+zs7Pftye3t7e7u7vfvz/rwxfjw1fnxyvrx
y/nx2fLy8fLy8vnz2frz2vnz4PPz8/rz3/nz4/r03Pn04vn04/n05fT09Pn1
4/n15vr15Pr15fr15vn25vr25fr26Pb29vr36/v36/r6+vv7+/z8/P39/P39
/f7+/f7+/v//////////////////////////////////////////////////
////////////////////////////////////////////////////////////
/////////////////////yH5BAEKAP8ALAAAAAAeAB4AAAj+AP8JHEiwoMGD
CBMqXMiw4UJvECN6c3gwYrZatrBJpDgQYrUpKkiwKPGjEjeIHCGeaVHFkCZL
f9Qk6dHopEOIlUqMUSSrF6xSlPRY0dEJJUNvzG7YeXTr2TVrvlJByvMkiNGH
gIAMCmWsGTRnwlZxSiRGBK6JR9s0KdQKWjRlxHShAjWJDY8uaB+uUUKIFTVr
0pLNUvVJEhwiWvIq9AYoByJT05xF2/Vq1CZGaFzMUZyQG7MhYTAhW/bLFalL
jvhg2RCMc8JtuV54GnYsVqZIh+ik2YHk6sJtwGSc4kVL1KJAccxIQVHH90Iw
H7iQ6SMIjxcjMDCUsUlxhY0sTkxsUNkiRAOTPd6+cfznAASNK3JCZPCgZVs3
1wwn+HGDI0WNCF8Uo816Ai0AwQlFvOGDBRQQSJACS9xxxAkzXMCBgwMBwEAF
UETRgQQYEhRAAg2MEAMBIQ5kAAIFNPBAigMdMIAAMNZo4404NhQQADs=
}

image create photo tb_addmove -data {
R0lGODlhGwAbAOMPAM0AI80AJ80CKc4HLs4NMs8WOc8WOtFCXdRxhNR0htN9
jdV8jdjCxtjCx9r38v///yH+FUNyZWF0ZWQgd2l0aCBUaGUgR0lNUAAh+QQB
CgAPACwAAAAAGwAbAAAEX/DJSau9OOvNu/9gKFJNM1aKYSjnhAAA0kpJECSz
swjC4ogKRGJxGAwOiwSC1WkYAAHBgEAYCAIAg8cJlVKtWK0nOCwek0uRjueb
1W6zxysWVxQKzBmDEe/7/4CBgiMRADs=
}

image create photo tb_update -data {
R0lGODlhGAAYAOfCAEm5Sly3Sme+Qmi/Q2a9XnG/RHTAPXLARXPBRnHBTXLCTnzAP2vCY3fD
QXbDSH3BQHTDT3zBR3DBaXnEQnfESX7CQXLEV3jFSnbFUYDDQnTFWILEO2/GZnjDXoHEQ4PF
PHbEZonDO4LFRITGPX7FU3zFWnrFYIrEPIPGRXvDbH/GVHvGYYbHPovFPYTHRnbHbn7HXIfI
P4zGPoXIR3fIb3zIYnrIaY/HN4nGTo3HQIPGYoHGaZDIOIfKSYTHY3nKcYDKXpHJOYvIUH3I
d5LKOn7JeJfIOoHJcZDKQ4jKX5PLPIbKZY3KUoTKbJjJO5XMNIjIcZDLTJTMPYXLbYnJcpjK
RJzLNJXNPprLPZHNTZ3MNYjLe57NNp/ON4rNfYjNg43Nd6DPOaLQMKXNOI7LgqfOL47OeKbO
OZHMfajPMKfPOqnQMpPOf6rRM6fQRK3SKazSNJPQh5DTgrHRNbTSK6/VLLLSNrXTLa7VN5XT
ibTTN53Td7bULrfVL7vTL5rTkbzUMKnTbJbWk7jXMZ3WgL7VMcDWJ7fXO7nYMp/VjZ3Vk7/W
MsHXKLjYPJ7WlMDXNKTXiMHYNcPZK8XbH7/cLKDYlr7YRsnYLL3YTr/ZR6bXlsPbOKrYkcnZ
OMvaL6bbk8HbSsfdL63ZjKvZks7cJczbMMvbO83cMcXdQ8feO7Lbh8beRdDfKM7eM7PciK/a
oM3ePbnaibjdfdXdNdHgNdbeNq/dqtXeQNHhQb7ehbzejNniQ7nfrdvjO9jiTNrjRdvkRuTm
Sv//////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
/////////////////////////////////yH+FUNyZWF0ZWQgd2l0aCBUaGUgR0lNUAAh+QQB
CgD/ACwAAAAAGAAYAAAI/gD/CRxIsKDBgwSLNGEiRBBChENWRMEELBgoCQ8J/jARJZOvXaYe
dQLFIKNAEpaC3erkZ5CfQ49MBRj4goQGgzbc3HrUBxGfPn4erQIgkEwjXLd6OCoYB4epTnai
3rFkioNAGLf4WGo1w6AgLKb8RLVDxxQagVNm+XlDdUXBJqHw2Hn0SK4pMwJfeWhFZ26Ygkge
tWlTatCsQaWODNRU5dEcO546DLRRx8+cR1WOSCFVSwdBKpTsqOnkYSCNR2fGkCrxT5GKNzsI
yhEzZ86gGAPNMBrDhVFsgVQUFXxiZ8ygJwO9+MGC5ZLih07aYJmDZCCBOm5u9Lnw8EsbLUro
mZQeGMRKDixjUiDE4CdHjjmsB0KY02LEmg1sDO4QEySEkTBeEJSCEjlsgEMYOYBAhkBbQBCG
ERlEEUYEBpXAxQYZZBAEF0GgMAJ6IiwwQRUfQHEQCVZkUIADEUzwgQgqGpBEILIId9ArCRgR
QgE8FiAACTrsEUssvJjUgQM5nJBBEnuIokssoxRpEoNgQMKJKJzYYsuUXBoUEAA7
}

image create photo tb_annotate -data {
R0lGODlhGgAaAOfoAE9BFUdGRk9PT1pQLlxQK2FWL2JWN2FXOGVZMGZaMrs3
GWxfNGFhYWdjWcBGK8FGKmpqam9rY8NMMd9CHsRUO3R0cnV0cs9SNcdXPtxQ
MN9PLnx4b3p6d9xWOHx7echhSslkS4CAf4GAf4KBfuNdP4OCgN9fQYODgYSD
gYaFgt9jRsxtWIiIhZCKgeVpTuJrUN9yWNB4ZZOTkJSUkd94X916Y5qVipuV
it96YpuWipiXlJeXl5iXl52Xi5mYkeh5YJ2XjJmYl56Yjed7Y5uZl5+ZjZ+Z
jpqal5qamZual5+ajqCajpubmaGbj6GbkJycnKGckOeBa6OdkaOdkp6enp+e
nKOekueDbaSek5+fnqGfnKGgnaGhoKGhodeQfaWjoKSko+qMd+KPfamppqqp
pquqp6urqqyrqKurq6yrqa2rqa2sqe2kPq+vrrCvrbCvrrGwrrOyr+eejbOy
sfCpP7Ozs7SzsbSzsrS0steudLW0srW0s7W1s7W1tLW1tba1tLe2tbi3tPOv
Qrm3tri4trm4uLm5ubq5t/SyRO+0Tbu7ufe1RPK2Tfe1Rb29vO6rm8C/vMDA
wMPCvsXEwcnJx8rKyM3LyPbSNs3My83Nzc/OytDOyvjYN9DQz9LRzdHR0dPS
zvncONTTz9PT0tPT09XTztbU0PnfOdfV0dfW0dbW1tjW0djW0tnX09nX1Prk
OtrZ1dvZ1fvnO9za1tza2Nzb2Nzb2fzpO9zc2t3c2N3c2t7d2fzrPd/e2uDe
2t/f3eDf2+Hf2+Hf3OHg3ODg3+Hg3eLh3ePi4OTj4OXj4OXk4eTk5Obl4ufm
4+jn5Ofn5+np6evq6Ozr6e3s6u3t6+3t7e/v7vDw7vDw8PHw7vLy8vPy8fTz
8vT09Pb19Pb29vj39vj49/n5+Pn5+fr6+fv7+/z8+/7+/v//////////////
////////////////////////////////////////////////////////////
/////////////////////yH5BAEKAP8ALAAAAAAaABoAAAj+AP8JHEiwoMGD
BSEoVIiw4b+FLzpk6HBh4UIBDBpCIPUNwiM5YmqAgKBqnDhxz5ZlgoAQwjd0
EK7QwAEDQwBV6MRZawMNXR2WBiGggxlFhQkVEgJ0ieTIDxhs6LqhAUpQKMwh
GrI+gDCqnDhtVCxSHWgVwo8JaBVAyOLIkSEug06gYJgQ3TmzaCeo7QRO3DZi
tChBkMVo7EN05iCEIcGYAoQnigoB+rMHAq9FBAwLJafYhecPEDBxG70Nwq1G
CwwfDqc4BoQYKyAgIdTHDoRXiA7QrYrOGwQvEMxAcAChUrZpEE4JMgAhgmqh
3JBACLEjCAQRPPBACJUoAQQiG57Uo+O27RclXNl0HbIFgRMdBBCYrGkh/lqf
Pnz03LkzB8IlNgNAUEEJk9ggHjXTSKNgNM4cA0EeBUBwBBmSiGKEeNHAAccb
briRBgQAKGTBCDJsAYsT4jXDzIrKJFOLQjokUYYkoLTSShHPjYNMGmeoscYY
VbDAgQcpzKDFF1+wIsRz1RQjzDDAGLOLJ4HEAYklpsTSyiqo9PDcJ8H40ssu
wOTiiiabZBnLLKykUsoNz/lgBRZTSDEFFE0oscQSThRRBBBA5NCAag+JZaih
DiWq6KIOBQQAOw==
}

image create photo tb_play -data {
R0lGODlhGAAYAKUjAAAAAGxranJxcHt7en18e39+fYKBgIaFg4mIhoyLiY+OjJCPjZmZlp2c
mqGfnaGgnqWkoaemo6mopbCvrLSzsbWzsba0srm2tLm3tLq5try6t728ucPCv8XDwMfGw8fG
xNDOzNLRztjX1f//////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////yH+FUNyZWF0ZWQg
d2l0aCBUaGUgR0lNUAAh+QQBCgA/ACwAAAAAGAAYAAAGXsCfcEgsGo/IpHLJbDoBziQAGjUC
BNTqEDAIZLWAAoPwjQIMjcmi3AQcHhQLhL0EICCYjIYDGJkTEhsdIH1VAAoVHiGFhg0XIoyG
Dh+RhhGVhpiGflpEnJ2goaKjSEEAOw==
}

image create photo tb_pause -data {
R0lGODlhGAAYAIQcAAAAAHNzcn5+fYSEg4WEg4iIh5GQjqSko6aloqalpKinpqqpp66tqa+u
rLKwrbWzsLW0s7u6t7+9usC/vsPBvsrKyNHPzNTT0tfV09nY1t7d2/Pz8///////////////
/yH+FUNyZWF0ZWQgd2l0aCBUaGUgR0lNUAAh+QQBCgAfACwAAAAAGAAYAAAFeOAnjmRpnmiq
rmzrviYgy9xMs0AwFECt8xycQHHoAYbF4OqYgBgFzR6OsJgYqValCmBoVIzdrzbF9YLNY1RZ
vJYuEZGLES5PnwD0edy9ZUgwRn6AdjEOFBlGhoiEJQAPFhpGj5GMJDZGNpUjHJycG52dMKKj
pKUsIQA7
}

image create photo tb_addallvars -data {
R0lGODlhHgAeAMZFAAAAAAQEBAcHBwkJCQsLCwwMDA0NDQ8PDxERERQUFBYW
FhcXFxgYGBkZGRsbGxwcHCIiIi4uLjo6Os0AI80AJ80CKUREREZGRs4HLs4N
Mk5OTk9PT88WOc8WOlJSUlVVVVdXV1lZWVxcXGBgYGFhYWJiYmNjY2dnZ9FC
XXNzc39/f4ODg4mJiYuLi9RxhNR0hpOTk5aWlpeXl9N9jdV8jZqamp2dnaCg
oKOjo6SkpKampqenp6mpqaqqqqurq6ysrLi4uMLCwtjCxtjCx9r38v//////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
/////////////////////////////////////////////////yH+FUNyZWF0
ZWQgd2l0aCBUaGUgR0lNUAAh+QQBCgB/ACwAAAAAHgAeAAAH/oB/goOEhYaH
iImKi4yNjo+QkZKTgyMAlzuHLJc4jjuXACOHFgAIkAqXDIcCAB6HQ0OFsB6g
PIUwlzKGMx0dM4O8EzOgJIUaAAOHLhMTLoPLwrQADYUGABeGRDQVFTREf9rc
MymgPYM2ly2EMy40KBgYKDQuM+/xNKAlgyAAAYRDHSZUwJAhA4YKEzoQNIhB
moNBCQBI+BdwYMGDCRfCwwDKxx8dl1QUYucOnjx69uThu2TiD4lLQQ6F6/Zt
prcUBy49+PMAQIRE0JwJCipIGoAVl1IkmsGBwy9BTJ0KqgGqwCUgioQIKaSV
kDVQECgR2gAKwAmxg2KU/YF2EIFLDAvayp1Lt67du4UCAQA7
}

image create photo tb_lockengine -data {
R0lGODlhHgAeAOeZAAAAAHxrR4BuSH9vToFyUYJyUoN1VYR3WYN4XYN4XoJ6
ZIJ7Z4F9dI9+XZiEXF+NzmqMu4yIdI6IcJuHXZiHZpuHXpyIX4+Jf4eLkJuJ
aJ6KY52ManiTtqKNZKKOZZCQjKCObaSPZ3yVtX6VtIGWsaOTcqOTc5KWlZSX
mqWWd4OdwKeZfKiZfJ+akKKbiHGj5amcgoqhv5OgsY+huZ2fo5ahsJSitaug
h6ygiJ6joZWktnSq85aluLaheKijma2jjaSkpHis86KlqaWnoqKnraaopLym
e6GruLyogKars6KvwbCxssayiMayismziMmzicqzici0jrW3uci1kMi2ksi2
lbi4uMi3lc23jcu4lM64jbq6ure8wry8vL29vdK8kr2/wdW+ksHBwdfBl9vE
mMfHx8bIysXIzd3In8rKyuDJnd/KosvNz83Nzc7Ozs7Oz+HOqePOpubQptLS
0tTU1OjSqeXUs9bW1ufVs+rXsevXsevXstnZ2tra2tvb2+navdzc3N3d3e3c
vd7e3u/evPHfu+3hx+Li4vDhxOPj4+/iyPTkx/Tlx/TmzPHn0fbq0/js0u3t
7frt0/ju2fju2u/v7/nw3fLy8vzz3f//////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
/////////////////////yH5BAEKAP8ALAAAAAAeAB4AAAj+AP8JHEiwoMGD
CBMqXMiw4UIuEKVAdIiwhpQzgy5dSnQmSQ2KBGUkiaSxpEYuRPqA5CKjJEcu
dxJVunSECEgMhy5FOoMBBYaebDRiEOPwyBGNbDAQKcMUBQo3l4igCNQQw5lL
h2SgKANI4B0UNCrRYeCmKp1LgzAsKTvQaZ9LDMqYjTQHwxaDKOZEiluVTaI3
dvG2ScSX4dA+ZRh4MYihTB8GRBdaQDKlCpUnTqBAceLkyZMoV7I0CQFlYQUj
YcjEEdRokiVKlB49QrRHjhYPSBTeOZ1aTZ1CkjBBgsSIESE9tj3AuJNwN2oy
voELJ248T/LlzXlD/x18eHFC1m+Qu2COkI/26N2pg09+gU9COue5T1+0aP3t
D3QSmn+Ofn798B584B5CfcQnnXfVsacSQmIYmN534XUgYEJiTMCffMPRZ5+E
+THoQA9YfDHGGngo4oghhvzxhx1woMGEBhMyOEADGWwAggks4PDDDTfAAMMK
KZRAQQF3KSSGGGWIwQaSRx65xRZNItkhSFRWyVBAADs=
}

image create photo uci -data {
R0lGODlhGAAYAMZLACBKhzRlpF9fXmpnZ1hthEVxqVtxiU50pGB2j2B3kVR8
rmN7lVl9q39/f2WErGyFoYGKlXWQroGTqYKXso2YpYSctpCmvpGmvpeltpmt
w6SttqKuvJ2wyq+vr6exvaG0yJ22zp240qS60LvByMHBwbDG28zMzM/NysDR
4tjY19zc3NPf6t/f39fi7ePi4ePj4uTj4d/n8Ofm5Ojn5Ovp5+rq6uzq6O3r
6e3r6u3y9vLx7+7z9vPy8fPz8vD09/T09Pb29fj39vj49/j4+Pn49/n59/n5
+Pr6+fr6+vv7+/7+/v//////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
/////////////////////////////////////////////////yH5BAEKAH8A
LAAAAAAYABgAAAfvgH+Cg4SFhoeCAwOIjIQDJEYNi42MA0E8KZOGEwGNAzZG
moQBSwedg4qTDTihhqQmHQ6OMzWKLzZHooIBKh2ngw0kOjc2NMatgwFIAb+E
DSdCRkVGxkSTAUrNhpKKDUbFQA0BQ9qU3jIjBT/llH8DHAEsDA3thAD3AT8K
Gkm6jAARRFgAEMADCRdK/BkCuGIDiAUABigxlrARgAotKCwIkQCAOyXFKh4C
kCGGBAIhIhjw+JGiPwAfdkhAkHKlIyUwBIgUBOCCDww0VbK82YOEKAAlckCo
ObRQqkIAHoRAccFmPXsPHkC8uvAe16+NAgEAOw==
}

image creat photo tb_info -data {
R0lGODlhHgAeAIQXAERq5ERu5FR25FR65Fx+5GSG5HSS7HyW7Iyi7Iym7JSq
7JSu7Jyu7KS69Ky69Ky+9LTC9LzK9MTS9NTi/Ozy/PT2/Pz+/P//////////
/////////////////////////yH5BAEKAB8ALAAAAAAeAB4AAAVi4CeOZGme
aKqubOu+7EMISAWjEKADx30WOx3FVwIGh8RRI1hIkiyMAMCAdI4sFqt2NYl4
I5KtIkgQk7eJ4MC8W2vTbbbObR3H32o5gO6Ez/V8SX57WxIKCwkLDluMjY6P
IyEAOw==
}

image creat photo tb_exclude -data {
R0lGODlhHgAeAMZGANnZ2WBgYAAAAKenp4mJiaOjo0RERBEREdjCxxYWFhgY
GAcHB1JSUtN9jc8WOlxcXKmpqZOTk5eXl9RxhM0AI6SkpGFhYU5OTgkJCdR0
hs0AJxQUFBkZGQ0NDUZGRtr38tV8jc0CKVlZWaqqqp2dnYuLi9FCXc4HLqCg
oGJiYldXVwQEBM4NMhsbGzo6OlVVVaurq6ampn9/f2NjY8LCwg8PDxwcHC4u
LoODg3Nzc5qamgwMDLi4uM8WOSIiItjCxk9PT2dnZ5aWlqysrAsLCxcXF///
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
/////////////////////////////////////////////////yH+EUNyZWF0
ZWQgd2l0aCBHSU1QACH5BAEAAH8ALAAAAAAeAB4AAAdPgH+Cg4SFhoeIiYqL
jI2Oj5CRkpOUlZaXmJmakg0TGSCfGRMNog2SDhQaIScsLCchGhQOp6mrra+x
s5Gdn6CjvqabwsPExcbHyMnKy8zMgQA7
}

image create photo tb_popup -data {
R0lGODlhDAAgAIABAAAAAP///yH5BAEKAAEALAAAAAAMACAAAAIdjI+py+0P
o5y0VgAMXjv01H1a5pFHaFrqyrbu6xQAOw==
}

### Make a little toplevel text widget to display an engine log

proc engineShowLog {n} {
  global analysis

  if {$n == {}} {
    return
  }
  set analysis(logfile) $n

  set w .enginelog

  if {[winfo exists $w]} {
    $w.log delete 0.0 end
    raiseWin $w
  } else {
    toplevel $w
    wm minsize $w 300 180
    setWinLocation $w
    setWinSize $w

    frame $w.buttons
    pack $w.buttons -side bottom 

    # autoscroll can bug out with this big text file, so don't use it.
    frame $w.frame
    text $w.log -width 80 -height 40 -font font_Regular -wrap none \
      -yscrollcommand "$w.ybar set" -xscrollcommand "$w.xbar set"
    scrollbar $w.ybar -command "$w.log yview"
    scrollbar $w.xbar -command "$w.log xview" -orient horizontal

    pack $w.frame -side top -fill both -expand yes
    grid $w.log  -in $w.frame -row 0 -column 0 -sticky news
    grid $w.ybar -in $w.frame -row 0 -column 1 -sticky ns
    grid $w.xbar -in $w.frame -row 1 -column 0 -sticky we
    grid rowconfigure    $w.frame 0 -weight 1
    grid columnconfigure $w.frame 0 -weight 1
    grid rowconfigure    $w.frame 1 -weight 0
    grid columnconfigure $w.frame 1 -weight 0
    
    checkbutton $w.buttons.auto -text Auto -variable analysis(log_auto) -command engineAutoLog
    dialogbutton $w.buttons.update -textvar ::tr(Update) -command engineUpdateLog

    entry $w.buttons.find -width 10 -textvariable analysis(find) -highlightthickness 0
    configFindEntryBox $w.buttons.find analysis .enginelog.log

    dialogbutton $w.buttons.ok -textvar ::tr(Close) -command "destroy $w"

    pack $w.buttons.auto $w.buttons.update -padx 15 -side left
    pack $w.buttons.ok $w.buttons.find -padx 15 -side right

    bind $w <Configure> "recordWinSize $w"
  }
  wm title $w "Engine Log: [lindex [lindex $::engines(list) $n] 0]"
  engineAutoLog
  bind $w <Escape> "destroy $w"
  bind $w <F1> { helpWindow Analysis }
  $w.buttons.update invoke
  .enginelog.log see 0.0
}

### Open the log file for reading
### $analysis(log$n) may already be open... but we'll ignore this fil descriptor and creat our own i think

proc engineUpdateLog {} {

  set n $::analysis(logfile)
  if {$n == {}} {return}
  .enginelog.log delete 1.0 end
  if {! [catch {open [file join $::scidLogDir engine$n.log] r} fd]} {
    # while {![eof $fd]} 
    while {[gets $fd line] >= 0 && ![eof $fd]} {
      .enginelog.log insert end "$line\n"
    }
    close $fd
  }
  .enginelog.log see end
}

### Automatically refreshes the engine log window
# (Note it rereads the whole file every update. Obviously would be better
# to run a tail on it, and probably not hard to do under Linux)

proc engineAutoLog {} {
  if {[winfo exists .enginelog] && $::analysis(log_auto)} {
    .enginelog.buttons.update invoke
    after 1000 engineAutoLog
  } else {
    after cancel engineAutoLog
  }
}

### Make a transient toplevel button bar

proc popupButtonBar {n} {

  if {[winfo exists .t]} {
    return
  }

  toplevel .t
  wm withdraw .t
  set w .analysisWin$n.b

  pack [frame .t.f -relief solid -borderwidth 1]
  set t .t.f
  catch {wm transient .t [winfo toplevel .main]}
  wm overrideredirect .t 1

  set offset [expr {16 + ($n >= 10)}]
  foreach b [winfo children $w] {
    if {![catch {pack info $b}]} {
      eval "pack \[[string tolower [winfo class $b]] $t.[string range $b $offset end]\] -side left"
    }
  }
  foreach button [winfo children $w] {
    set b [string range $button $offset end]
    foreach opt [$w.$b configure] {
      set o [lindex $opt 0]
      catch {
        $t.$b  configure $o [$w.$b cget $o]
      }
    }
  }

  bind .t <ButtonRelease-1> {destroy .t}
  bind .t <Leave> {if {"%W" == ".t"} {destroy .t}}
  bind $w <Destroy> +[list destroy .t]

  # handle case when up against right side of screen
  update
  set X [expr [winfo rootx $w] - 1]
  set space [expr {[winfo screenwidth .main] - ($X + [winfo reqwidth .t])}]
  if {$space < 0} {
    incr X $space
  }
  if {$::windowsOS} {
    wm state .t normal
    raise .t
    wm geometry .t +$X+[expr [winfo rooty $w] - 1]
  } else {
    wm geometry .t +$X+[expr [winfo rooty $w] - 1]
    wm state .t normal
  }
}

proc placePopupButton {n} {
  set w .analysisWin$n
  catch {
    place forget $w.popup
    if {[winfo reqwidth $w.b] > [winfo width $w.b]} {
      place $w.popup -in $w -anchor ne -x [winfo width $w]
    }
  }
}

### end of analysis.tcl
