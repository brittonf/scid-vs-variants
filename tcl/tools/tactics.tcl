### tactics.tcl: part of Scid.
### Copyright (C) 2007  Pascal Georges
###
######################################################################
### Solve tactics (mate in n moves for example)
# use Site token in pgn notation to store progress
#
# S.A: Updated a little 6 Sept, 2010
# "Show Solution" checkbox now adds solution as PGN for browsing, and pauses main loop
# ... I still havent checked the "Win Won" functionality

namespace eval tactics {

  set infoEngineLabel ""

  set basePath $::scidBasesDir

  set baseList {}
  set solved "problem solved"
  set failed "problem failed"
  set prevScore 0
  set prevLine ""
  set nextEngineMove ""
  set matePending 0
  set cancelScoreReset 0
  set askToReplaceMoves_old 0
  set showSolution 0
  set labelSolution {}
  # set labelSolution {. . . . . . }
  set lastGameLoaded 0
  set prevFen ""
  ### This used to be significant, but now is dynamic, according to which slot "toga" has
  # set engineSlot 5
  # Don't try to find the exact best move but to win a won game (that is a mate in 5 is ok even if there was a pending mate in 2)
  set winWonGame 0


  ### Current base must contain games with Tactics flag and special **** markers
  # (as prepared by the Find Best Move in analysis annotation).
  # The first var should contain the best move (the next best move
  # is at least 1.0 point away.
  # TODO preset the filter on flag == Tactics to speed up searching

  proc findBestMove {} {
    bind .main.board  <Double-Button-1> ::tactics::findBestMove
    set ::gameInfo(hideNextMove) 1
    if {[winfo exists .pgnWin]} {
      destroy .pgnWin
    }

    set found 0

    if {![sc_base inUse] || [sc_base numGames] == 0} {
      tk_messageBox -type ok -icon info -title {Find Best Move} -message "No games in database"      
      return
    }

    busyCursor .
    update
    for {set g [expr [sc_game number] +1] } { $g <= [sc_base numGames]} { incr g} {
      sc_game load $g
      if {[sc_game flag T $g]} {
	# Look for non-std start, or tactical markers ****D->
	if {[sc_game startBoard] || [llength [gotoNextTacticMarker] ] != 0} {
	  set found 1
	  break
	}
      }
    }
    unbusyCursor .

    if { ! $found } {
      tk_messageBox -type ok -icon info -title {Find Best Move} -message "No (more) relevant games found."      
      sc_game load 1
    } else  {
      sideToMoveAtBottom
    }
    updateBoard -pgn
    ::windows::gamelist::Refresh
    updateTitle
  }

  proc gotoNextTacticMarker {} {
    while {![sc_pos isAt end]} {
      set cmt [sc_pos getComment]

      if {[string match {*\*\*\*\*D*->*} $cmt]} {
        # anything non-null
        return $cmt
      }
      sc_move forward
    }
    return {}
  }

  ### Configuration dialog for Mate in N puzzle
  # (Had some associated core dumps here, possibly when scidBasesDir is wrongly set in config S.A)

  proc config {} {
    global ::tactics::basePath ::tactics::baseList ::tactics::baseDesc
    set basePath $::scidBasesDir

    set w .tacticsWin
    if {[winfo exists $w]} {
      destroy $w
    }

    set w .configTactics
    if {[winfo exists $w]} {
      raiseWin $w
      return
    }
    update
    toplevel $w
    wm title $w $::tr(ConfigureTactics)
    setWinLocation $w

    if {[sc_base count free] == 0} {
      tk_messageBox -type ok -icon info -title "Scid" -message "Too many databases are open; close one first"
      return
    }

    set prevBase [sc_base current]
    # go through all bases and take descriptions
    set baseList {}
    set baseDesc {}
    set fileList [  lsort -dictionary [ glob -nocomplain -directory $basePath *.si960 ] ]
    foreach file  $fileList {
      if {[sc_base slot $file] == 0} {
        sc_base open [file rootname $file]
        set wasOpened 0
      } else  {
        sc_base switch [sc_base slot $file]
        set wasOpened 1
      }
      
      set solvedCount 0
      for {set g 1 } { $g <= [sc_base numGames]} { incr g} {
        sc_game load $g
        if {[sc_game tags get "Site"] == $::tactics::solved} { incr solvedCount }
      }
      lappend baseList "$file" "[sc_base description]  ($solvedCount/[sc_base numGames])"
      lappend baseDesc [sc_base description]
      if {! $wasOpened } {
        sc_base switch $prevBase
        sc_base close [sc_base slot $file]
      }
    }

    updateMenuStates
    updateStatusBar
    updateTitle

    frame $w.fconfig -relief raised -borderwidth 1
    label $w.fconfig.l1 -text $::tr(ChooseTrainingBase)
    pack $w.fconfig.l1 -pady 3

    frame $w.fconfig.flist

    listbox $w.fconfig.flist.lb -selectmode single -exportselection 0 \
        -yscrollcommand "$w.fconfig.flist.ybar set" -height 10 -width 30
    bind $w.fconfig.flist.lb <Double-Button-1> ::tactics::start

    scrollbar $w.fconfig.flist.ybar -command "$w.fconfig.flist.lb yview"
    pack $w.fconfig.flist.lb $w.fconfig.flist.ybar -side left -fill y
    for {set i 1} {$i<[llength $baseList]} {incr i 2} {
      $w.fconfig.flist.lb insert end [lindex $baseList $i]
    }
    $w.fconfig.flist.lb selection set 0

    frame $w.fconfig.reset
    button $w.fconfig.reset.button -text $::tr(ResetScores) -command {
      set current [.configTactics.fconfig.flist.lb curselection]
      set name [lindex $::tactics::baseList [expr $current * 2 ] ]
      set desc [lindex $::tactics::baseDesc $current]
      if {[tk_messageBox -type yesno -parent .configTactics -icon question \
	     -title {Confirm Reset} -message "Confirm resetting \"$desc\" database"] == {yes}} {
	::tactics::resetScores $name
      }
    }
    pack $w.fconfig.reset.button

    # in order to limit CPU usage, limit time for analysis (this prevents noise on laptops)
    frame $w.fconfig.flimit
    label $w.fconfig.flimit.blimit -text "$::tr(limitanalysis) ($::tr(seconds))" -relief flat
    scale $w.fconfig.flimit.analysisTime -orient horizontal -from 1 -to 30 -length 120 \
      -variable ::tactics::analysisTime -resolution 1
    pack $w.fconfig.flimit.blimit -side top
    pack $w.fconfig.flimit.analysisTime -side bottom

    frame $w.fconfig.fbutton
    dialogbutton $w.fconfig.fbutton.ok -text Ok -command ::tactics::start
    dialogbutton $w.fconfig.fbutton.cancel -text $::tr(Cancel) -command "focus .main ; destroy $w"
    pack $w.fconfig.fbutton.ok $w.fconfig.fbutton.cancel -expand yes -side left -padx 20 -pady 2
    pack $w.fconfig $w.fconfig.flist $w.fconfig.reset -side top

    addHorizontalRule $w.fconfig

    pack $w.fconfig.flimit -pady 5 -side top

    addHorizontalRule $w.fconfig

    pack $w.fconfig.fbutton -pady 5 -side bottom
    bind $w <Configure> "recordWinSize $w"
    bind $w <F1> { helpWindow TacticsTrainer }
  }

  ################################################################################
  #
  ################################################################################
  proc start {} {
    global ::tactics::analysisEngine ::askToReplaceMoves ::tactics::askToReplaceMoves_old

    set current [.configTactics.fconfig.flist.lb curselection]
    set base [lindex $::tactics::baseList [expr $current * 2]]
    set desc [lindex $::tactics::baseDesc $current]
    destroy .configTactics

    set ::gameInfo(hideNextMove) 1
    if {[winfo exists .pgnWin]} {
      destroy .pgnWin
    }

    set ::tactics::lastGameLoaded 0

    if { ![::tactics::launchengine] } { return }

    set askToReplaceMoves_old $askToReplaceMoves
    set askToReplaceMoves 0

    set w .tacticsWin
    if {[winfo exists $w]} {
      raiseWin $w
      return
    }

    toplevel $w
    wm title $w $desc
    setWinLocation $w
    # because sometimes the 2 buttons at the bottom are hidden
    wm minsize $w 170 170
    frame $w.f1 -relief groove -borderwidth 1
    label $w.f1.labelInfo -textvariable ::tactics::infoEngineLabel -bg linen
    checkbutton $w.f1.cbWinWonGame -text $::tr(WinWonGame) -variable ::tactics::winWonGame
    pack $w.f1.labelInfo $w.f1.cbWinWonGame -expand yes -fill both -side top

    frame $w.clock
    ::gameclock::new $w.clock 1 80 0
    ::gameclock::reset 1
    ::gameclock::start 1

    frame $w.f2 -relief groove
    checkbutton $w.f2.solution -text $::tr(ShowSolution) -variable ::tactics::showSolution \
      -command ::tactics::toggleSolution
    label $w.f2.solved -textvariable ::tactics::labelSolution -wraplength 120
    pack $w.f2.solution $w.f2.solved -expand yes -fill both -side top

    frame $w.buttons -relief groove -borderwidth 1
    pack $w.f1 -expand yes -fill both
    pack $w.clock
    pack $w.f2 $w.buttons -expand yes -fill both

    setInfoEngine $::tr(LoadingBase)

    button $w.buttons.next -text $::tr(Next) -command {
      ::tactics::stopAnalyze
      # mark game as solved if solution shown
      if {$::tactics::showSolution} {
	sc_game tags set -site $::tactics::solved
	sc_game save [sc_game number]
      }
      ::tactics::loadNextGame
    }
    button $w.buttons.close -text Quit -command ::tactics::endTraining
    pack $w.buttons.next $w.buttons.close -expand yes -fill both -padx 20 -pady 2
    bind $w <Destroy> { ::tactics::endTraining }
    bind $w <Configure> "recordWinSize $w"
    bind $w <F1> { helpWindow TacticsTrainer }

    ::tactics::loadBase [file rootname $base]

    setInfoEngine "---"
    ::tactics::loadNextGame
    ::tactics::mainLoop
  }
  ################################################################################
  #
  ################################################################################
  proc endTraining {} {
    set w .tacticsWin
    bind $w <Destroy> {}
    ::tactics::stopAnalyze
    after cancel ::tactics::mainLoop
    ::file::Close

    set ::askToReplaceMoves $::tactics::askToReplaceMoves_old
    focus .main
    destroy $w

    set ::gameInfo(hideNextMove) 0

    catch { ::uci::closeUCIengine $::tactics::engineSlot }
  }
  ################################################################################
  #
  ################################################################################
  proc toggleSolution {} {
    global ::tactics::showSolution ::tactics::labelSolution ::tactics::analysisEngine

    if {$showSolution} {
      # pause main loop
      after cancel ::tactics::mainLoop
      if {![sc_pos isAt start]} {
	# not sure why...but have to move back one
	sc_move back
      }

      # add solution
      sc_move addSan $analysisEngine(moves)

      sc_move start

      set labelSolution $analysisEngine(moves)
      if {$analysisEngine(score) != {-327.0}} {
	append labelSolution "\n(score $analysisEngine(score))"
      }
    } else  {
      # restart this game
      sc_game load $::tactics::lastGameLoaded
      after 1000  ::tactics::mainLoop
      set labelSolution {}
    }
    updateBoard -pgn
    update
  }

  ################################################################################
  #
  ################################################################################
  proc resetScores {name} {
    global ::tactics::cancelScoreReset ::tactics::baseList

    set base [file rootname $name]

    set wasOpened 0

    if {[sc_base count free] == 0} {
      tk_messageBox -type ok -icon info -title "Scid" -message "Too many databases are opened\nClose one first"
      return
    }
    # check if the base is already opened
    if {[sc_base slot $name] != 0} {
      sc_base switch [sc_base slot $name]
      set wasOpened 1
    } else  {
      if { [catch { sc_base open $base }] } {
        tk_messageBox -type ok -icon warning -title "Scid" -message "Unable to open base"
        return
      }
    }

    # reset site tag for each game
    progressWindow "Scid" $::tr(ResettingScore) $::tr(Cancel) "::tactics::sc_progressBar"
    set numGames [sc_base numGames]
    set cancelScoreReset 0
    for {set g 1} { $g <= $numGames } { incr g} {
      if { $cancelScoreReset } { break }
      sc_game load $g
      if { [sc_game tags get "Site"] != ""} {
        sc_game tags set -site ""
        sc_game save [sc_game number]
      }
      if { [expr $g % 100] == 0 } {
        updateProgressWindow $g $numGames
      }
    }
    closeProgressWindow
    if { ! $wasOpened } {
      sc_base close
    }
    # update listbox
    set w .configTactics
    set cs [$w.fconfig.flist.lb curselection]
    set idx [expr $cs * 2 +1]
    set tmp [lindex $baseList $idx]
    regsub "\[(\]\[0-9\]+/" $tmp "(0/" tmp
    lset baseList $idx $tmp
    $w.fconfig.flist.lb delete 0 end
    for {set i 1} {$i<[llength $baseList]} {incr i 2} {
      $w.fconfig.flist.lb insert end [lindex $baseList $i]
    }
    $w.fconfig.flist.lb selection set $cs
  }
  ################################################################################
  # cancel score reset loading
  ################################################################################
  proc sc_progressBar {} {
    set ::tactics::cancelScoreReset 1
  }
  ################################################################################
  #
  ################################################################################
  proc loadNextGame {} {
    ::tactics::resetValues
    setInfoEngine $::tr(LoadingGame)
    set newGameFound 0
    # find a game with site tag != problem solved
    for {set g [ expr $::tactics::lastGameLoaded +1 ] } { $g <= [sc_base numGames]} { incr g} {
      sc_game load $g
      set tag [sc_game tags get "Site"]
      if {$tag != $::tactics::solved} { set newGameFound 1 ; break }
    }
    # it seems we finished the serial
    if {! $newGameFound } {
      tk_messageBox -title "Scid" -icon info -type ok -message $::tr(AllExercisesDone)
      return
    }
    set ::tactics::lastGameLoaded $g

    sideToMoveAtBottom

    ::gameclock::reset 1
    ::gameclock::start 1

    updateBoard -pgn
    set ::tactics::prevFen [sc_pos fen]
    ::windows::gamelist::Refresh
    ::tree::refresh
    ::windows::stats::Refresh
    updateMenuStates
    updateTitle
    updateStatusBar
    ::tactics::startAnalyze
    ::tactics::mainLoop
  }
  ################################################################################
  # flips the board if necessary so the side to move is at the bottom
  ################################################################################
  proc sideToMoveAtBottom {} {
    if { [sc_pos side] == "white" && [::board::isFlipped .main.board] || [sc_pos side] == "black" &&  ![::board::isFlipped .main.board] } {
      toggleRotateBoard
    }
  }

  ################################################################################
  #
  ################################################################################

  # We should probably disable "flip board" button, as it breaks game
  proc isPlayerTurn {} {
    if { [sc_pos side] == "white" &&  ![::board::isFlipped .main.board] || \
         [sc_pos side] == "black" &&  [::board::isFlipped .main.board] } {
      return 1
    } else {
      return 0
    }
  }

  ################################################################################
  #
  ################################################################################
  proc exSolved {} {
    ::tactics::stopAnalyze
    ::gameclock::stop 1
    sc_game tags set -site $::tactics::solved
    sc_game save [sc_game number]
    if {$::tactics::showSolution} {
      return
    }
    tk_messageBox -title "Scid" -icon info -type ok -message $::tr(MateFound)
    ::tactics::loadNextGame
  }
  ################################################################################
  # Handle the case where position was changed not during normal play but certainly with
  # move back / forward / rewind commands
  ################################################################################
  proc abnormalContinuation {} {
    ::tactics::stopAnalyze
    ::tactics::resetValues
    ::windows::gamelist::Refresh
    ::tree::refresh
    ::windows::stats::Refresh
    updateMenuStates
    updateTitle
    updateStatusBar
    if { [sc_pos side] == "white" && [::board::isFlipped .main.board] \
      || [sc_pos side] == "black" &&  ![::board::isFlipped .main.board] } {
      ::board::flip .main.board
    }
    updateBoard -pgn
    set ::tactics::prevFen [sc_pos fen]
    ::tactics::startAnalyze
    ::tactics::mainLoop
  }

  ################################################################################
  # waits for the user to play and check the move played
  ################################################################################
  proc mainLoop {} {
    global ::tactics::prevScore ::tactics::prevLine ::tactics::analysisEngine ::tactics::nextEngineMove

    after cancel ::tactics::mainLoop

    if {[sc_pos fen] != $::tactics::prevFen && [sc_pos isAt start]} {
      ::tactics::abnormalContinuation
      return
    }

    # is this player's turn (which always plays from bottom of the board) 
    if { [::tactics::isPlayerTurn] } {
      after 1000  ::tactics::mainLoop
      return
    }

    set ::tactics::prevFen [sc_pos fen]

    # check if player's move is a direct mate : no need to wait for engine analysis in this case
    set move_done [sc_game info previousMove]
    if { [string index $move_done end] == "#"} { ::tactics::exSolved; return }

    # if the engine is still analyzing, wait the end of it
    if {$analysisEngine(analyzeMode)} { vwait ::tactics::analysisEngine(analyzeMode) }

    if {[sc_pos fen] != $::tactics::prevFen  && [sc_pos isAt start]} {
      ::tactics::abnormalContinuation
      return
    }

    # the player moved and analysis is over : check if his move was as good as expected
    set prevScore $analysisEngine(score)
    set prevLine $analysisEngine(moves)
    ::tactics::startAnalyze

    # now wait for the end of analyzis
    if {$analysisEngine(analyzeMode)} { vwait ::tactics::analysisEngine(analyzeMode) }
    if {[sc_pos fen] != $::tactics::prevFen  && [sc_pos isAt start]} {
      ::tactics::abnormalContinuation
      return
    }

    # compare results
    set res [::tactics::foundBestLine]
    if {  $res != ""} {
      tk_messageBox -title "Scid" -icon info -type ok -message "$::tr(BestSolutionNotFound)\n$res"
      # take back last move so restore engine status
      set analysisEngine(score) $prevScore
      set analysisEngine(moves) $prevLine
      sc_game tags set -site $::tactics::failed
      sc_game save [sc_game number]
      sc_move back
      updateBoard -pgn
      set ::tactics::prevFen [sc_pos fen]
    } else  {
      catch { sc_move addSan $nextEngineMove }
      set ::tactics::prevFen [sc_pos fen]
      updateBoard -pgn
      if { $::tactics::matePending } {
        # continue until end of game
      } else  {
        setInfoEngine $::tr(GoodMove)
        sc_game tags set -site $::tactics::solved
        sc_game save [sc_game number]
      }
    }

    after 1000 ::tactics::mainLoop
  }
  ################################################################################
  # Returns "" if the user played the best line, otherwise an explanation about the missed move :
  # - guessed the same next move as engine
  # - mate found in the minimal number of moves
  # - combinaison's score is close enough (within 0.5 point)
  ################################################################################
  proc foundBestLine {} {
    global ::tactics::analysisEngine ::tactics::prevScore ::tactics::prevLine ::tactics::nextEngineMove ::tactics::matePending
    set score $analysisEngine(score)
    set line $analysisEngine(moves)

    set s [ regsub -all "\[\.\]{3} " $line "" ]
    set s [ regsub -all "\[0-9\]+\[\.\] " $s "" ]
    set nextEngineMove [ lindex [ split $s ] 0 ]
    set ply [ llength [split $s] ]

    # check if the player played the same move predicted by engine
    set s [ regsub -all "\[\.\]{3} " $prevLine "" ]
    set s [ regsub -all "\[0-9\]+\[\.\] " $s "" ]
    set prevBestMove [ lindex [ split $s ] 1 ]
    if { [sc_game info previousMoveNT] == $prevBestMove} {
      return ""
    }

    # Case of mate
    if { [string index $prevLine end] == "#"} {
      set matePending 1
      #  Engine may find a mate then put a score != 300 but rather 10
      if {[string index $line end] != "#"} {
        # Engine line does not end with a # but the score is a mate (we can't count plies here)
        if {[sc_pos side] == "white" && $score < -300 || [sc_pos side] == "black" && $score > 300} {
          return ""
        }
        if {! $::tactics::winWonGame } {
          return $::tr(MateNotFound)
        } else  {
          # win won game but still have to find a mate
          if {[sc_pos side] == "white" && $score < -300 || [sc_pos side] == "black" && $score > 300} {
            return ""
          } else  {
            return $::tr(MateNotFound)
          }
        }
      }
      # Engine found a mate, search in how many plies
      set s [ regsub -all "\[\.\]{3} " $prevLine "" ]
      set s [ regsub -all "\[0-9\]+\[\.\] " $s "" ]
      set prevPly [ llength [ split $s ] ]
      if { $ply > [ expr $prevPly - 1 ] && ! $::tactics::winWonGame } {
        return $::tr(ShorterMateExists)
      } else  {
        return ""
      }
    } else  {
      # no mate case
      set matePending 0
      set threshold 0.5
      if {$::tactics::winWonGame} {
        # Only alert when the advantage clearly changes side
        if {[sc_pos side] == "white" && $prevScore < 0 && $score >= $threshold  || \
              [sc_pos side] == "black" &&  $prevScore >= 0 && $score < [expr 0 - $threshold]  } {
          return "$::tr(ScorePlayed) $score\n$::tr(Expected) $prevScore"
        } else  {
          return ""
        }
      }
      if {[ expr abs($prevScore) ] > 3.0 } { set threshold 1.0 }
      if {[ expr abs($prevScore) ] > 5.0 } { set threshold 1.5 }
      # the player moved : score is from opponent side
      if {[sc_pos side] == "white" && $score < [ expr $prevScore + $threshold ] || \
            [sc_pos side] == "black" && $score > [ expr $prevScore - $threshold ] } {
        return ""
      } else  {
        return "$::tr(ScorePlayed) $score\n$::tr(Expected) $prevScore"
      }
    }
  }

  ################################################################################
  # Loads a base bundled with Scid (in ./bases directory)
  ################################################################################
  proc loadBase { name } {

    if {[sc_base count free] == 0} {
      tk_messageBox -type ok -icon info -title "Scid" -message "Too many databases are open; close one first"
      return
    }
    # check if the base is already opened
    if {[sc_base slot $name] != 0} {
      sc_base switch [sc_base slot $name]
    } else  {
      if { [catch { sc_base open $name }] } {
        tk_messageBox -type ok -icon warning -title "Scid" -message "Unable to open base"
        return
      }
    }

    ::windows::gamelist::Refresh
    ::tree::refresh
    ::windows::stats::Refresh
    updateMenuStates
    updateBoard -pgn
    updateTitle
    updateStatusBar
  }

  ################################################################################
  ## resetValues
  #   Resets global data.
  ################################################################################
  proc resetValues {} {
    set ::tactics::prevScore 0
    set ::tactics::prevLine ""
    set ::tactics::nextEngineMove ""
    set ::tactics::matePending 0
    set ::tactics::showSolution 0
    set ::tactics::labelSolution ""
    set ::tactics::prevFen ""
  }

  ################################################################################
  #
  ################################################################################
  proc  restoreAskToReplaceMoves {} {
    set ::askToReplaceMoves $::tactics::askToReplaceMoves_old
  }

  ################################################################################
  #
  ################################################################################
  proc setInfoEngine { s { color linen } } {
    set ::tactics::infoEngineLabel $s
    .tacticsWin.f1.labelInfo configure -background $color
  }

  ################################################################################
  #  Will start engine
  # in case of an error, return 0, or 1 if the engine is ok
  ################################################################################
  proc launchengine {} {
    global ::tactics::analysisEngine

    set analysisEngine(analyzeMode) 0

    # Use Toga
    set index 0
    foreach e $::engines(list) {
      if { [string equal -nocase -length 4 [lindex $e 0] "toga" ] } {
	# Start engine in analysis mode
        set ::tactics::engineSlot $index
	::uci::startEngine $index
	return 1
      }
      incr index
    }

    # failsafe only ???
    set ::tactics::engineSlot 0

    tk_messageBox -type ok -icon warning -parent . -title "Scid" \
      -message "Unable to find engine.\nPlease configure engine with Toga as name"
    return 0

  }

  # ======================================================================
  # sendToEngine:
  #   Send a command to a running analysis engine.
  # ======================================================================
  proc sendToEngine {text} {
    ::uci::sendToEngine $::tactics::engineSlot $text
  }

  # ======================================================================
  # startAnalyzeMode:
  #   Put the engine in analyze mode
  # ======================================================================
  proc startAnalyze { } {
    global ::tactics::analysisEngine ::tactics::analysisTime
    setInfoEngine "$::tr(Thinking) ..." PaleVioletRed
    .tacticsWin.f2.solution configure -state disabled

    # Check that the engine has not already had analyze mode started:
    if {$analysisEngine(analyzeMode)} {
      ::tactics::sendToEngine  "exit"
    }

    set analysisEngine(analyzeMode) 1
    after cancel ::tactics::stopAnalyze
    ::tactics::sendToEngine "position fen [sc_pos fen]"
    ::tactics::sendToEngine "go infinite"
    after [expr 1000 * $analysisTime] ::tactics::stopAnalyze
  }

  # ======================================================================
  # stopAnalyzeMode:
  #   Stop the engine analyze mode
  # ======================================================================
  proc stopAnalyze { } {
    global ::tactics::analysisEngine ::tactics::analysisTime
    # Check that the engine has already had analyze mode started:
    if {!$analysisEngine(analyzeMode)} { return }

    set pv [lindex $::analysis(multiPV$::tactics::engineSlot) 0]
    set analysisEngine(score) [lindex $pv 1]
    set analysisEngine(moves) [lindex $pv 2]

    set analysisEngine(analyzeMode) 0
    ::tactics::sendToEngine  "stop"
    setInfoEngine $::tr(AnalyzeDone) PaleGreen3
    .tacticsWin.f2.solution configure -state normal
  }

}

###
### End of file: tactics.tcl
###
