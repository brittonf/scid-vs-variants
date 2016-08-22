### epd.tcl: EPD editing window(s) for Scid.

# Copyright (C) 2000  Shane Hudson
# Copyright (C) 2007  Pascal Georges frigging eedjit

set maxEpd [sc_info limit epd]
set delayEpd 5
array set epdTimer {}


proc storeEpdText {id} {
  sc_epd set $id [.epd$id.text get 1.0 "end-1c"]
  # updateEpdWin $id
}

### Previously use extensively by preMoveCommand, but never called
proc storeEpdTexts {} {
  global maxEpd
  for {set i 1} {$i <= $maxEpd} {incr i} {
    if {[winfo exists .epd$i]} { storeEpdText $i }
  }
}

proc updateEpdWin {id} {
  set w .epd$id
  $w.text delete 1.0 end
  $w.text insert end [sc_epd get $id]

  # Update the EPD window status bar:
  set str "[file tail [sc_epd name $id]]  [sc_epd size $id] positions"
  if {[sc_epd readonly $id]} {
    append str " ($::tr(readonly)) "
  }
  set moves [lsort -ascii [sc_epd moves $id]]
  set len [llength $moves]
  if {$len} {
    append str "  \[[llength $moves]: [join $moves " "]\]"
  } else {
    append str {  [No moves from this position]}
  }
  $w.status configure -text $str
  unset str
}

proc updateEpdWins {} {
  global maxEpd
  for {set i 1} {$i <= $maxEpd} {incr i} {
    if {[winfo exists .epd$i]} { updateEpdWin $i }
  }
}

proc closeEpdWin {id} {
  catch {sc_epd close $id}
}

proc confirmCloseEpd {id} {
  # We no longer get confirmation.
  # Easiest to autosave after every change of <<ListboxSelect>>
  if {! [winfo exists .epd$id]} { return }
  storeEpdText $id
  if {[sc_epd altered $id]  &&  ! [sc_epd readonly $id]} {
    sc_epd write $id
  }
  sc_epd close $id
  focus .main
  destroy .epd$id
  return
}

proc saveEpdWin {id} {
  set w .epd$id
  busyCursor . 1
  set temp_oldcursor [$w.text cget -cursor]
  $w.text configure -cursor watch
  update idletasks
  storeEpdText $id
  sc_epd write $id
  updateEpdWin $id
  $w.text configure -cursor $temp_oldcursor
  busyCursor . 0
}

proc epd_MoveToDeepestMatch {id} {
  if {! [winfo exists .epd$id]} { return }
  sc_move ply [sc_epd deepest $id]
  updateBoard
  return
}

proc newEpdWin {cmd {fname ""}} {
  global maxEpd
  set showErrors 1
  if {$cmd == "openSilent"} {
    set showErrors 0
    set cmd open
  }
  if {$fname == ""} { set showErrors 1 }
  if {[sc_epd available] < 1} {
    if {$showErrors} {
      tk_messageBox -type ok -icon info -title "Too many EPD files open" \
          -message "You already have $maxEpd EPD files open; close one first."
    }
    return 0
  }
  set new_types { {"EPD files" {".epd"} } }
  set open_types $new_types
  if {[sc_info gzip]} {
    set open_types { {"EPD files" {".epd" ".epd.gz"} } }
  }
  if {$fname == ""} {
    if {! [file isdirectory $::initialDir(epd)] } {
      set ::initialDir(epd) $::env(HOME)
    }
    if {$cmd == "create"} {
      set fname [tk_getSaveFile -initialdir $::initialDir(epd) -filetypes $new_types -title "Create an EPD file"]
    } elseif {$cmd == "open"} {
      set fname [tk_getOpenFile -initialdir $::initialDir(epd) -filetypes $open_types -title "Open an EPD file"]
    } else {
      return 0
    }
  }
  if {$fname == ""} {
    return 0
  }

  busyCursor . 1
  if {[catch {sc_epd $cmd $fname} result]} {
    if {$showErrors} {
      busyCursor . 0
      tk_messageBox -type ok -icon error -title "Scid: EPD file error" \
          -message $result
    }
    return 0
  }
  busyCursor . 0

  # id is 1 for first epd window, 2 for second...
  set id $result
  set w .epd$id

  toplevel $w
  wm withdraw $w
  setWinLocation $w
  setWinSize $w

  wm title $w "Scid EPD: [file tail $fname]"
  wm minsize $w 40 1
  bind $w <Destroy> "closeEpdWin $id"
  bind $w <F1> { helpWindow EPD }

  frame $w.grid
  text $w.text  -font font_Regular -width 60 -height 7 \
      -wrap none -setgrid 1 -yscrollcommand "$w.ybar set" \
      -xscrollcommand "$w.xbar set" -undo 1
  # (Previously handled by preMoveCommand and storeEpdTexts)
  # we need to storeEpdText to set whether [sc_epd altered]
  bind $w.text <KeyRelease> "storeEpdText $id"

  bind $w.text <Control-a> "$w.text tag add sel 0.0 end-1c ; break"
  bind $w.text <Control-z> "catch \"$w.text edit undo\" ; break"
  bind $w.text <Control-y> "catch \"$w.text edit redo\" ; break"
  bind $w.text <Control-r> "catch \"$w.text edit redo\" ; break"

  scrollbar $w.ybar -takefocus 0 -command "$w.text yview"
  scrollbar $w.xbar -orient horizontal -takefocus 0 -command "$w.text xview"
  label $w.status -width 1 -anchor w -font font_Small -relief sunken
  listbox $w.lb  -font font_Regular -width 60 -height 7 -setgrid 1 -yscrollcommand "$w.ybar2 set" \
      -xscrollcommand "$w.xbar2 set" -selectmode single
  scrollbar $w.ybar2 -takefocus 0 -command "$w.lb yview"
  scrollbar $w.xbar2 -orient horizontal -takefocus 0 -command "$w.lb xview"

  frame $w.menu -borderwidth 3 -relief raised
  pack $w.menu  -side top -fill x
  menubutton $w.menu.file -text File -menu $w.menu.file.m -underline 0
  menubutton $w.menu.edit -text Edit -menu $w.menu.edit.m -underline 0
  menubutton $w.menu.tools -text Tools -menu $w.menu.tools.m -underline 0
  menubutton $w.menu.help -text Help -menu $w.menu.help.m -underline 0

  foreach i {file edit tools help} {
    menu $w.menu.$i.m -tearoff 0
    pack $w.menu.$i -side left
  }
  pack $w.menu.help -side right

  set m $w.menu.file.m
  $m add command -label "New" -acc "Ctrl+N" -underline 0 \
      -command {newEpdWin create}
  bind $w <Control-n> {newEpdWin create}
  $m add command -label "Open" -acc "Ctrl+O" -underline 0 \
      -command {newEpdWin open}
  bind $w <Control-o> {newEpdWin open}
  $m add command -label "Close" -acc "Ctrl+Q" -underline 0 \
      -command "confirmCloseEpd $id"
  bind $w <Control-q> "confirmCloseEpd $id"
  wm protocol $w WM_DELETE_WINDOW "confirmCloseEpd $id"

  set m $w.menu.edit.m
  $m add command -label "Cut" -acc "Ctrl+X" -underline 2 -command "tk_textCut $w.text"
  $m add command -label "Copy" -acc "Ctrl+C" -underline 0 -command "tk_textCopy $w.text"
  $m add command -label "Paste" -acc "Ctrl+V" -underline 0 -command "tk_textPaste $w.text"

  ### Now already the default bindings
  # bind $w <Control-x> "tk_textCut $w.text; break"
  # bind $w <Control-c> "tk_textCopy $w.text; break"
  # bind $w <Control-v> "tk_textPaste $w.text; break"
  # bind $w <Control-a> "$w.text tag add sel 1.0 end; break"

  $m add command -label "Select All" -acc "Ctrl+A" -underline 7 \
      -command "$w.text tag add sel 1.0 end"
  $m add separator
  # todo - Make some sort of undo. This is borked
  $m add command -label "Revert" -acc "Ctrl+R" -underline 0 \
      -command "updateEpdWin $id"
  bind $w <Control-r> "updateEpdWin $id; break"
  $m add command -label "Sort lines" -accel "Ctrl+Shift+S" \
      -underline 0 -command "epd_sortLines $w.text $id"
  bind $w <Control-Down> "nextEpd $id ; break"
  bind $w <Control-Up> "prevEpd $id; break"

  set m $w.menu.tools.m

  $m add command -label "Paste Analysis" -accelerator "Ctrl+Shift+A" \
      -underline 6 -command "epd_pasteAnalysis $w.text ; storeEpdText $id"
  bind $w <Control-A> "epd_pasteAnalysis $w.text ; storeEpdText $id ; break"
  $m add command -label "Annotate Positions" -command "epd_Analyse $w.text $id"
  $m add command -label "Strip field" -underline 0 -command "epd_chooseStripField $id"
  $m add command -label "Find Deepest Game Position" -underline 5 -command "epd_MoveToDeepestMatch $id"

  $w.menu.help.m add command -label "EPD Help" -underline 0 -acc "F1" -command "helpWindow EPD"
  $w.menu.help.m add command -label Index -underline 0 -command "helpWindow Index"

  pack $w.status -side bottom -fill x
  pack $w.grid -fill both -expand yes
  grid $w.text -in $w.grid -row 0 -column 0 -sticky news
  grid $w.ybar -in $w.grid -row 0 -column 1 -sticky news
  grid $w.xbar -in $w.grid -row 1 -column 0 -sticky news
  grid $w.lb -in $w.grid -row 2 -column 0 -sticky news
  grid $w.ybar2 -in $w.grid -row 2 -column 1 -sticky news
  grid $w.xbar2 -in $w.grid -row 3 -column 0 -sticky news

  grid rowconfig $w.grid 0 -weight 1 -minsize 0
  grid rowconfig $w.grid 2 -weight 2 -minsize 0
  grid columnconfig $w.grid 0 -weight 1 -minsize 0

  # Right-mouse button cut/copy/paste menu:
  menu $w.text.edit -tearoff 0
  $w.text.edit add command -label "Cut"  -command "tk_textCut $w.text"
  $w.text.edit add command -label "Copy" -command "tk_textCopy $w.text"
  $w.text.edit add command -label "Paste" -command "tk_textPaste $w.text"
  bind $w.text <ButtonPress-3> "tk_popup $w.text.edit %X %Y"

  updateEpdWin $id

  loadEpdLines $id

  bind $w.lb <<ListboxSelect>> "refreshEpd $id"

  bind $w <Configure> "recordWinSize $w"
  wm state $w normal

  return 1
}

proc refreshEpd { id } {
  if {[sc_epd altered $id]  &&  ! [sc_epd readonly $id]} {
    sc_epd write $id 
  }

  set w .epd$id
  set idx [ expr [$w.lb curselection] +1 ]
  # This fails if it's a new epd file without entries, so catch it
  catch {
    sc_epd load $id $::selection($id) $idx
    set ::selection($id) $idx
  }
  updateBoard -pgn
}

### idx starts at 1, while curselection starts at 0

proc prevEpd {id} {
  set w .epd$id
  set idx [ expr [$w.lb curselection] +1 ]
  if {$idx > 1} {
    incr idx -1
    sc_epd load $id $::selection($id) $idx
    set ::selection($id) $idx
    updateBoard -pgn
    $w.lb selection clear 0 end
    $w.lb selection set [expr $idx - 1]
  }
}

proc nextEpd {id} {
  set w .epd$id
  set idx [ expr [$w.lb curselection] +1 ]
  if {$idx < [$w.lb index end]} {
    incr idx 1
    sc_epd load $id $::selection($id) $idx
    set ::selection($id) $idx
    updateBoard -pgn
    $w.lb selection clear 0 end
    $w.lb selection set [expr $idx - 1]
  }
}

### Used to be

# proc nextEpd {id} 
#   sc_epd next $id
#   switchEpd $id 1

proc loadEpdLines { id } {
  set w .epd$id
  set size [sc_epd size $id ]
  for { set i 1 } { $i <= $size } { incr i } {
    sc_epd next $id
    set line [sc_epd get $id]
    set line [string map {"\n" "; "} $line]
    set fen [string range [sc_pos fen] 0 end-4]

    ### Simplify the listbox display. The additional information is displayed on it's own anyway.
    ### Any issues ?
    # $w.lb insert end "$i $fen $line"
    $w.lb insert end "$i    $fen"
  }
  $w.lb selection set 0
  if {! [catch {sc_epd load $id $size 1} ]} {
    set ::selection($id) 1
    updateBoard -pgn
  }
}

proc epd_sortLines {textwidget id} {
  if {! [winfo exists $textwidget]} { return }
  set text [$textwidget get 1.0 "end-1c"]
  set fieldlist [split $text "\n"]
  set sortedlist [lsort $fieldlist]
  set newtext {}
  foreach i $sortedlist {
    if {$i != ""} {
      append newtext "$i\n"
    }
  }
  if {! [string compare $text $newtext]} { return }
  $textwidget delete 1.0 end
  $textwidget insert end "$newtext"
  storeEpdText $id
}

###  Pastes current chess engine analysis into this EPD file position.

proc epd_Analyse { textwidget id } {
  global analysis

  if {! [winfo exists $textwidget]} { return }

  # choose analysis time
  set y .epdDelay

  toplevel $y
  wm title $y "Scid EPD"
  placeWinOverParent $y .epd$id

  label $y.label -text $::tr(AnnotateTime:)
  pack $y.label -side top -pady 5 -padx 5
  spinbox $y.spDelay  -width 8 -textvariable ::delayEpd -from 1 -to 300 -increment 1 -validate all -vcmd {string is int %P}
  pack $y.spDelay -side top -pady 5
  dialogbutton $y.ok -text OK -command "
    destroy $y
    epd_LaunchAnalysis $id $textwidget"
  dialogbutton $y.cancel -text $::tr(Cancel) -command "destroy $y"
  pack $y.ok $y.cancel -side left -padx 3 -pady 5
  focus $y.spDelay
  update ; # or grab will fail
  grab $y

}

###  strips all fields that will be pasted from analysis window

proc epd_clearEpdFields {id} {
  foreach field { "acd" "acn" "ce" "pv" } {
    set result [sc_epd strip $id $field]
    updateEpdWin $id
  }
}

proc epd_LaunchAnalysis {id textwidget} {
  ### todo: make epd annotation work with a specified engine (instead of engine 0)
  if {! [winfo exists .analysisWin0]} {
    makeAnalysisWin 0
  } else {
    if {!$::analysis(analyzeMode0)} {
      toggleEngineAnalysis 0
    }
  }
  epd_clearEpdFields $id
  set w .epd$id
  set size [sc_epd size $id ]
  set ::epdTimer($id) 0
  for { set i 1 } { $i <= $size } { incr i } {
    $w.lb selection clear [expr $::selection($id) - 1]
    $w.lb selection set [expr $i -1]
    $w.lb see [expr $i -1]
    refreshEpd $id
    after [expr $::delayEpd * 1000 ] "set ::epdTimer($id) 1"
    vwait ::epdTimer($id)
    epd_pasteAnalysis $textwidget
    saveEpdWin $id
    if {! [winfo exists .analysisWin0] || !$::analysis(analyzeMode0)} {
      return
    }
  }
  toggleEngineAnalysis 0
}

###  Pastes current chess engine analysis into this EPD file position.

proc epd_pasteAnalysis {textwidget} {
  global analysis
  if {! [winfo exists $textwidget]} { return }

  set win -1
  # find an open analysis window
  for {set i 0} {$i < [llength $::engines(list)]} {incr i} {
    if {[winfo exists .analysisWin$i]} {
      set win $i
      break
    }
  }
  if {$win == -1} {
    return
  }

  $textwidget insert insert "acd $analysis(depth$win)\n"
  $textwidget insert insert "acn $analysis(nodes$win)\n"
  set ce [expr {int($analysis(score$win) * 100)} ]
  if {[sc_pos side] == "black"} { set ce [expr {0 - $ce} ] }
  $textwidget insert insert "ce $ce\n"
  $textwidget insert insert "pv $analysis(moves$win)\n"
}

set epd_stripField ""

proc epd_chooseStripField {id} {
  global epd_stripField
  if {! [winfo exists .epd$id]} { return }
  set w [toplevel .epdStrip]
  wm title $w "Scid: Strip EPD field"
  placeWinOverParent $w .epd$id
  wm resizable $w false false
  label $w.label -text "Enter the name of the EPD field you want\n\
      removed from all positions in this file:"
  entry $w.e -width 10  -textvariable epd_stripField
  pack $w.label $w.e -side top -pady 5 -padx 5
  addHorizontalRule $w
  set b [frame $w.buttons]
  pack $b -side bottom -pady 5
  button $b.ok -text "Strip EPD field" \
      -command "epd_stripEpdField $id \$epd_stripField"
  button $b.cancel -text $::tr(Cancel) -command "focus .epd$id; destroy $w"
  pack $b.ok $b.cancel -side left -padx 5
  bind $w <Return> "$b.ok invoke"
  bind $w <Escape> "$b.cancel invoke"
  focus .epdStrip.e
  grab .epdStrip
}

proc epd_stripEpdField {id field} {
  if {! [winfo exists .epdStrip]} { return }
  if {! [string compare $field ""]} { return }
  set result [sc_epd strip $id $field]
  updateEpdWin $id
  destroy .epdStrip
  update
  tk_messageBox -type ok -icon info -title "Scid: EPD field stripped" \
      -message "Scid found and stripped an EPD field named \"$field\" from\
      $result positions." -parent  .epd$id
}

### end of f-ing epd.tcl
