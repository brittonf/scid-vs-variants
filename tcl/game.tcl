# game.tcl: part of Scid

#   Prompts the user if they want to discard the changes to the
#   current game. Returns :
# 0 -> saves then continue
# 1 -> discard changes and continue
# 2 -> cancel action

proc ::game::ConfirmDiscard {} {
  # This should be rewritten with tk_dialog and "return answer"
  # rather than "::game::answer" S.A.

  # This is not correct. We can have an altered game , then start Trial mode.
  # Instead, we should [setTrialMode 0], then check [sc_game altered], but needs lots of testing
  if {$::trialMode || [sc_base isReadOnly] || ![sc_game altered]} {
    return 1
  }

  set w .confirmDiscard
  toplevel $w
  wm state $w withdrawn
  wm title $w Scid
  set ::game::answer 2
  pack [frame $w.top] -side top
  addHorizontalRule $w
  pack [frame $w.bottom] -expand 1 -fill x -side bottom

  # label $w.top.icon -bitmap question
  # pack $w.top.icon -side left -padx 20 -pady 5

  label $w.top.txt -text $::tr(ClearGameDialog)
  pack $w.top.txt -padx 5 -pady 5 -side right

  button $w.bottom.b1 -width 10 -text $::tr(Save)     -command {destroy .confirmDiscard ; set ::game::answer 0}
  button $w.bottom.b2 -width 10 -text $::tr(DontSave) -command {destroy .confirmDiscard ; set ::game::answer 1}
  button $w.bottom.b3 -width 10 -text $::tr(Cancel)   -command {destroy .confirmDiscard ; set ::game::answer 2}
  pack $w.bottom.b1 $w.bottom.b2 $w.bottom.b3 -side left -padx 10 -pady 5

  bind $w <Destroy> {set ::game::answer 2}
  bind $w <Right> "event generate $w <Tab>"
  bind $w <Left> "event generate $w <Shift-Tab>"

  update
  placeWinOverParent $w .
  wm state $w normal

  catch { grab $w }

  focus $w.bottom.b2
  vwait ::game::answer
  return $::game::answer
}

### New Game
#   Clears the active game, checking first if it is altered.
#   Updates any affected windows.

proc ::game::Clear {} {
  set confirm [::game::ConfirmDiscard]
  if {$confirm == 2} { return }
  if {$confirm == 0} {
    ::game::Save
  }

  setTrialMode 0
  sc_game new
  updateBoard -pgn
  updateTitle
  updateMenuStates
}

#   Strips all comments or variations from a game

proc ::game::Strip {type {parent .}} {
  sc_game undoPoint

  if {[catch {sc_game strip $type} result]} {
    tk_messageBox -parent $parent -type ok -icon info -title "Scid" -message $result
    return
  }
  updateBoard -pgn
  updateTitle
}

proc ::game::TruncateBegin {} {
  sc_game undoPoint

  if {[catch {sc_game truncate -start} result]} {
    tk_messageBox -parent . -type ok -icon info -title "Scid" -message $result
    return
  }
  updateBoard -pgn
  updateTitle
}

proc ::game::Truncate {} {
  sc_game undoPoint

  if {[catch {sc_game truncate} result]} {
    tk_messageBox -parent . -type ok -icon info -title "Scid" -message $result
    return
  }
  updateBoard -pgn
  updateTitle
}

proc ::game::Delete {} {
  sc_game flag delete [sc_game number] invert
  updateBoard
  ::windows::gamelist::Refresh
}

#   Loads the next or previous filtered game in the database.
#   The parameter <action> should be "previous" , "next", "first" or "last"

proc ::game::LoadNextPrev {action {raise 1}} {
  global pgnWin statusBar
  if {![sc_base inUse]} {
    set statusBar "  There is no $action game: this is an empty database."
    return
  }
  set number [sc_filter $action]
  if {$number == 0} {
    set statusBar "  There is no $action game in the current filter."
    return
  }
  if {$number == [sc_game number]} {
    set statusBar "  Game $number already loaded."
    return
  }
  ::game::Load $number 1 $raise
}

#   Reloads the current game.

proc ::game::Reload {} {
  if {![sc_base inUse]} { return }
  if {[sc_game number] < 1} { return }
  ::game::Load [sc_game number]
}

#   Loads a random game from the database.

proc ::game::LoadRandom {} {
  set ngames [sc_filter size]
  if {$ngames == 0} { return }
  set r [expr {(int (rand() * $ngames)) + 1} ]
  set gnumber [sc_filter index $r]
  ::game::Load $gnumber
}


# ::game::LoadNumber
#
#    Prompts for the number of the game to load.

set ::game::entryLoadNumber ""
trace variable ::game::entryLoadNumber w {::utils::validate::Regexp {^[0-9]*$}}

proc ::game::LoadNumber {} {
  set ::game::entryLoadNumber ""
  if {![sc_base inUse]} { return }

  set confirm [::game::ConfirmDiscard]
  if {$confirm == 2} { return }
  if {$confirm == 0} {
    ::game::Save
  }

  if {[sc_base numGames] < 1} { return }

  set w [toplevel .glnumDialog]
  wm title $w "Scid: [tr GameNumber]"
  wm state $w withdrawn

  label $w.label -text $::tr(LoadGameNumber)
  pack $w.label -side top -pady 5 -padx 5

  entry $w.entry  -width 10 -textvariable ::game::entryLoadNumber
  bind $w.entry <Escape> { .glnumDialog.buttons.cancel invoke }
  bind $w.entry <Return> { .glnumDialog.buttons.load invoke }
  pack $w.entry -side top -pady 5

  set b [frame $w.buttons]
  pack $b -side top -fill x
  dialogbutton $b.load -text "OK" -command {
    # todo: Can we integrate this into ::file::Open
    if {[catch {sc_game load $::game::entryLoadNumber} result]} {
      tk_messageBox -type ok -icon info -title "Scid" -message $result
    }
    focus .main
    destroy .glnumDialog
    flipBoardForPlayerNames
    updateBoard -pgn
    refreshWindows
    ::bookmarks::AddCurrentGame 
  }
  dialogbutton $b.cancel -text $::tr(Cancel) -command {
    destroy .glnumDialog
    focus .main
  }
  packbuttons right $b.cancel $b.load

  placeWinOverParent $w .
  update
  wm state $w normal
  focus $w.entry
}

### Loads a specified game from the active database.

proc ::game::Load { selection {update 1} {raise 1}} {
  # If an invalid game number, just return:
  if {$selection < 1 || $selection > [sc_base numGames]} {
    return
  }
  if {[winfo exists .fics] && $::fics::mainGame > -1} {
    ### Handle cases where fics playing and observing
    if {($::fics::playing==1 || $::fics::playing==-1)} {
      ::fics::updateConsole "Scid: game loads disabled while playing a game"
      return 
    }
    ::fics::demote_mainGame
    set ::fics::mainGame -1
    set ::fics::autoload {}
  } else {
    set confirm [::game::ConfirmDiscard]
    if {$confirm == 2} { return -1 }
    if {$confirm == 0} {
      ::game::Save
    }
  }

  setTrialMode 0
  sc_game load $selection
  flipBoardForPlayerNames
  if {$update} {
    updateBoard -pgn
  }
  if {$raise && \
      ![winfo exists .tourney] && \
      ![winfo exists .twinchecker] && \
      ![winfo exists .sb] && \
      ![winfo exists .sh] && \
      ![winfo exists .bmedit] && \
      ![winfo exists .sm] } {
    raiseWin .
  }
  refreshWindows
  ::bookmarks::AddCurrentGame
}

### Replaces numerous 'sc_game save [sc_game number]' around the place.
# New saved games are added to Game History

proc ::game::Save {} {
    set n [sc_game number]
    sc_game save $n
    if {$n == 0} {
      # add new game to history
      ::bookmarks::AddCurrentGame
    }
}

#   Produces a popup dialog for loading a game or other actions
#   such as merging it into the current game.

proc ::game::LoadMenu {w base gnum x y} {
  set m $w.gLoadMenu
  if {! [winfo exists $m]} {
    menu $m
    $m add command -label $::tr(BrowseGame)
    $m add command -label $::tr(LoadGame)
    $m add command -label $::tr(MergeGame)
  }
  $m entryconfigure 0 -command "::gbrowser::new $base $gnum"
  $m entryconfigure 1 -command "
    if {\[sc_base current\] != $base} {
      sc_base switch $base
    }
    ::game::Load $gnum"
  $m entryconfigure 2 -command "mergeGame $base $gnum"
  # could also use tk_popup here, but this seems ok
  event generate $w <ButtonRelease-1>
  $m post $x $y
  event generate $m <ButtonPress-1>
}


#   Entry variable for GotoMoveNumber dialog.
set ::game::moveEntryNumber ""
trace variable ::game::moveEntryNumber w {::utils::validate::Regexp {^[0-9]*$}}

#    Prompts for the move number to go to in the current game.

proc ::game::GotoMoveNumber {} {
  set ::game::moveEntryNumber ""
  set w [toplevel .mnumDialog]
  wm title $w "Scid: [tr GameGotoMove]"

  label $w.label -text $::tr(GotoMoveNumber)
  pack $w.label -side top -pady 5 -padx 5

  entry $w.entry -width 8 -textvariable ::game::moveEntryNumber -borderwidth 0 ; # -justify right
  bind $w.entry <Escape> { .mnumDialog.buttons.cancel invoke }
  bind $w.entry <Return> { .mnumDialog.buttons.load invoke }
  pack $w.entry -side top -pady 5

  set b [frame $w.buttons]
  pack $b -side top -fill x
  dialogbutton $b.load -text "OK" -command {
    if {$::game::moveEntryNumber > 0} {
      catch {sc_move ply [expr {($::game::moveEntryNumber - 1) * 2}] ; sc_move forward}
    }
    focus .main
    destroy .mnumDialog
    # updateBoard -pgn
    updateBoard
  }
  dialogbutton $b.cancel -text $::tr(Cancel) -command {
    focus .main
    destroy .mnumDialog
    focus .main
  }
  packbuttons right $b.cancel $b.load

  placeWinOverParent $w .

  focus $w.entry
}

### End of file: game.tcl
