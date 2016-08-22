### end.tcl: part of Scid.
#
# Mixup of all sorts of stuff
#
# Copyright (C) 2000-2003 Shane Hudson.

# findNovelty:
#   Searches the for first position in the current game not
#   found in the selected database.

set noveltyOlder 0

proc findNovelty {} {
  global refDatabase noveltyOlder
# set refDatabase [sc_base current]
  set w .noveltyWin
  if {[winfo exists $w]} {
    destroy $w
  }

  toplevel $w
  wm withdraw $w
  wm title $w "$::tr(FindNovelty)"

  label $w.help -text [string trim $::tr(NoveltyHelp)]
  pack $w.help -side top

  label $w.title -text $::tr(Database)
  pack $w.title -side top

  set ::listbases {}
  for {set i 1} {$i <= [sc_base count total]} {incr i} {
    if {[sc_base inUse $i]} {
      set basename [file tail [sc_base filename $i]]
      if {[sc_base current] == $i} {
	set current $basename
      }
      lappend ::listbases $basename
    }
  }
  ttk::combobox $w.refdb -textvariable refDatabase -values $::listbases
  $w.refdb set $current
  pack $w.refdb -side top -pady 2

  addHorizontalRule $w

  label $w.which -text $::tr(TwinsWhich)
  pack $w.which -side top
  radiobutton $w.all -text $::tr(SelectAllGames) \
      -variable noveltyOlder -value 0
  radiobutton $w.older -text "$::tr(SelectOlderGames) (< [sc_game info date])" \
      -variable noveltyOlder -value 1
  pack $w.all $w.older -side top -anchor w -padx 10

  addHorizontalRule $w

  label $w.status -text "" -width 1 -font font_Small -relief sunken -anchor w
  pack $w.status -side bottom -fill x
  pack [frame $w.b] -side top -fill x
  dialogbutton $w.b.stop -textvar ::tr(Stop) -state disabled \
      -command sc_progressBar
  dialogbutton $w.b.go -text $::tr(FindNovelty) -command {
    .noveltyWin.b.stop configure -state normal
    .noveltyWin.b.go configure -state disabled
    .noveltyWin.b.close configure -state disabled
    busyCursor .
    .noveltyWin.status configure -text " ... "
    update
    grab .noveltyWin.b.stop

    if {$refDatabase == {[clipbase]}} {
      set noveltyBase 9
    } else {
      set noveltyBase [expr {[.noveltyWin.refdb current] + 1}]
    }

    if {$noveltyOlder} {
      set err [catch {sc_game novelty -older -updatelabel .noveltyWin.status $noveltyBase} result]
    } else {
      set err [catch {sc_game novelty -updatelabel .noveltyWin.status $noveltyBase} result]
    }
    grab release .noveltyWin.b.stop

    if {! $err} { set result "$::tr(Novelty): $result" }
    unbusyCursor .
    .noveltyWin.b.stop configure -state disabled
    .noveltyWin.b.go configure -state normal
    .noveltyWin.b.close configure -state normal
    .noveltyWin.status configure -text $result
    updateBoard
  }
  dialogbutton $w.b.close -textvar ::tr(Close) -command {
    catch {destroy .noveltyWin}
  }
  packbuttons right $w.b.close $w.b.go $w.b.stop
  wm resizable $w 0 0
  focus $w.b.go

  update
  placeWinOverParent $w .
  wm deiconify $w
}


set merge(ply) 40

### Merge game config widget. Merges any game into the current game.

proc mergeGame {{base 0} {gnum 0}} {
  global merge glNumber
  if {$base == 0} {
    if {$glNumber < 1} { return }
    if {$glNumber > [sc_base numGames]} { return }
    set base [sc_base current]
    set gnum $glNumber
  }
  sc_game push copy
  set err [catch {sc_game merge $base $gnum} result]
  sc_game pop
  if {$err} {
    tk_messageBox -title "Scid" -type ok -icon info \
        -message "Unable to merge the selected game:\n$result"
    return
  }
  set merge(base) $base
  set merge(gnum) $gnum
  set w .mergeDialog
  toplevel $w
  wm withdraw $w
  wm title $w "$::tr(MergeGame)"
  bind $w <Escape> "$w.b.cancel invoke"
  bind $w <F1> {helpWindow GameList Browsing}
  label $w.title -text "$::tr(MergeGame) $::tr(Preview)" -font font_Regular
  pack $w.title -side top
  pack [frame $w.b] -side bottom -fill x -pady 3
  frame $w.f
  text $w.f.text  -wrap word -width 60 -height 20 \
      -font font_Regular -yscrollcommand "$w.f.ybar set"
  scrollbar $w.f.ybar -takefocus 0 -command "$w.f.text yview"
  event generate $w.f.text <ButtonRelease-1>
  pack $w.f.ybar -side right -fill y
  pack $w.f.text -side left -fill both -expand yes
  pack $w.f -fill both -expand yes

  label $w.b.label -text "Up to move  " -font font_Regular
  pack $w.b.label -side left -padx 2
  foreach i {5 10 15 20 25 30 35 40} {
    radiobutton $w.b.m$i -text [format "%2i" $i] -variable merge(ply) -value [expr {$i * 2}] \
        -indicatoron 0 -padx 4 -pady 2 -font font_Regular -command updateMergeGame
    pack $w.b.m$i -side left -padx 2
  }
  radiobutton $w.b.all -text [::utils::string::Capital $::tr(all)] \
      -variable merge(ply) -value 1000 -indicatoron 0 -padx 4 -pady 2 \
      -font font_Regular -command updateMergeGame
  pack $w.b.all -side left -padx 2

  dialogbutton $w.b.ok -text "OK" -command {
    sc_game undoPoint
    sc_game merge $merge(base) $merge(gnum) $merge(ply)
    destroy .mergeDialog
    updateBoard -pgn
  }
  dialogbutton $w.b.cancel -text $::tr(Cancel) \
      -command "destroy $w"
  packbuttons right $w.b.cancel $w.b.ok
  updateMergeGame
  placeWinCenter $w 
  wm deiconify $w
}

proc updateMergeGame {args} {
  global merge
  set w .mergeDialog
  if {! [winfo exists $w]} { return }
  sc_game push copy
  sc_game merge $merge(base) $merge(gnum) $merge(ply)

  set pgn [sc_game pgn -indentV 1 -short 1 -width 60]
  sc_game pop
  $w.f.text configure -state normal
  $w.f.text tag configure red -foreground darkRed
  $w.f.text tag configure blue -foreground darkBlue
  $w.f.text delete 1.0 end
  foreach line [split $pgn "\n"] {
    if {[string index $line 0] == " "} {
      $w.f.text insert end $line blue
    } else {
      $w.f.text insert end $line
    }
    $w.f.text insert end "\n"
  }
  $w.f.text tag add red 1.0 4.0
  #$w.f.text insert end $pgn
  $w.f.text configure -state disabled
}

#   Set Export options for PGN, HTML and LaTeX laugh

proc setExportText {exportType} {
  global exportStartFile exportEndFile latexRendering

  set w .setExportText$exportType

  if {[winfo exists $w]} {
    raiseWin $w
    return
  }

  toplevel $w
  wm withdraw $w
  wm title $w "Set $exportType file export text"
  if {$exportType == "Latex"} {
      bind $w <F1> {helpWindow LaTeX}
  }

  frame $w.buttons
  pack $w.buttons -side bottom -fill x -anchor e

  set pane [::utils::pane::Create $w.pane start end 500 400 0.7]
  ::utils::pane::SetRange $w.pane 0.3 0.7
  pack $pane -side top -expand true -fill both
  foreach f [list $pane.start $pane.end] type {start end} {
    label $f.title -font font_Bold -text "Text at $type of $exportType file"
    text $f.text -wrap none  \
        -yscroll "$f.ybar set" -xscroll "$f.xbar set"
    scrollbar $f.ybar -orient vertical -command "$f.text yview"
    scrollbar $f.xbar -orient horizontal -command "$f.text xview"
    grid $f.title -row 0 -column 0 -sticky w
    grid $f.text -row 1 -column 0 -sticky nesw
    grid $f.ybar -row 1 -column 1 -sticky nesw
    grid $f.xbar -row 2 -column 0 -sticky nesw
    grid rowconfig $f 1 -weight 1 -minsize 0
    grid columnconfig $f 0 -weight 1 -minsize 0
  }

  $pane.start.text insert end $exportStartFile($exportType)
  $pane.end.text insert end $exportEndFile($exportType)
  
  # Additional Latex options
  if {$exportType == "Latex"} {
    label $w.descr -font font_Bold -text "LaTeX System Options"
    pack $w.descr -side top

    foreach f {rendering viewer} {
      pack [frame $w.$f] -fill x -side top -pady 3
      pack [label $w.$f.label -text "Command for $f:"] -side left
      pack [entry $w.$f.entry -width 30] -side right -padx 2
    }
    $w.rendering.entry insert 0  $latexRendering(engine)
    $w.viewer.entry    insert 0  $latexRendering(viewer)

    button $w.buttons.default -text "Reset to Default" -command "
      $pane.start.text delete 1.0 end
      $pane.start.text insert end \$default_exportStartFile(Latex)
      $pane.end.text delete 1.0 end
      $pane.end.text insert end \$default_exportEndFile(Latex)
      $w.rendering.entry delete 0 end
      $w.viewer.entry   delete 0 end
      $w.rendering.entry insert 0 \$default_latexRendering(engine)
      $w.viewer.entry   insert 0 \$default_latexRendering(viewer)
    "
    dialogbutton $w.buttons.ok -text "OK" -command "
      set exportStartFile(Latex) \[$pane.start.text get 1.0 end-1c\]
      set exportEndFile(Latex)   \[$pane.end.text get 1.0 end-1c\]
      set latexRendering(engine) \[string trim \[$w.rendering.entry get\]\]
      set latexRendering(viewer) \[string trim \[$w.viewer.entry get\]\]
      focus .main
      destroy $w
    "        
    addHorizontalRule $w
  } else {
    button $w.buttons.default -text "Reset to Default" -command "
    $pane.start.text delete 1.0 end
    $pane.start.text insert end \$default_exportStartFile($exportType)
    $pane.end.text delete 1.0 end
    $pane.end.text insert end \$default_exportEndFile($exportType)
    "
    dialogbutton $w.buttons.ok -text "OK" -command "
    set exportStartFile($exportType) \[$pane.start.text get 1.0 end-1c\]
    set exportEndFile($exportType) \[$pane.end.text get 1.0 end-1c\]
    focus .main
    destroy $w
    "
  }

  dialogbutton $w.buttons.cancel -text $::tr(Cancel) -command "focus .main ; destroy $w"
  pack $w.buttons.default -side left -padx 5 -pady 2
  pack $w.buttons.cancel $w.buttons.ok -side right -padx 5 -pady 2

  placeWinCenter $w 
  wm deiconify $w
}

image create photo htmldiag0 -data {
  R0lGODdhbgBkAIAAAAAAAP///ywAAAAAbgBkAAAC/oyPqcvtD6OctNqLs968+w+G4kiW5omm
  6moAgQu/ckzPdo3fes7vfv5wsYQtBFF2OCqNzCPrs4xEi0mQEyWcApxbqhfpvYa2ZCNZeQ4y
  k122YgqGNs7oMtu+aH9f6XT1vydm5ddCyIenlkB3KAgnePFIJzm5yECkRVmpuPbokflpaLl2
  eKeHCNcRCQo6F3e52qY3Gve04QhbJkvrGYQb+jbrB8sHaJPi25mnGItLvDmRnLwnCpH1luUb
  WGwpLdUsIdaFHLtdHe09bM45Lkw9p4uRXfHKbseFntibnk9fT/4XDR6kb+BKsfrkrFuhc+b2
  OYhh0J+1Z+8U6ltVMGIm/kaTpnnL95DgQzPpMC6RJtCCPArMOmqsNDFjq4YYq5lZGKokxZEc
  Vtok5pIkwl2p0NXsZZDUsmH3fmpIuWxeUKEHy828yo0dT6p5sk3sZrGrP6dWx3kMCRKYykhE
  xcpD1fWpxK1tOX4LK9OtVneuliKjAnEEIqkMA9UrgjctTokCY+4a29fvL6OM2ZabW3co1peH
  rwVb3DmM5lpSRlV2DHryrGPFEidqShrS59azz2Zw/TTyF0e168aG1ps3bRG4bz8pvqmH8h/M
  lztvDj0wVuG7g/sW3Bv48Orbr7Purky3eOpgkMsenxcuX/XHs3NzzzG8NsJQ38EnG2Uq+rWa
  /s7bVrvfRtwBxhIlLHWnEHUCklegfumtpgx5AloHjYHAMTjdahbeB46D+EG4Hoj68YaXh3Sx
  B9IVrADo3TUTHmjVTHA5pFuCR70G4oeSaYZiRTemyGJcw72lIWWj2TckjKLRKN5FKypZHj/B
  iBQZWFS6g2GIVI3Wo15HApljFTMSlKWLP4oyo45L8himkxuq2eJ+nKV0UoUvgvlfhmb2x2FI
  JsL505hPDmjjoDx1qeWWEyK655d6tunMNGbt5N2kaF0Wlop7DejnX9qRJGWj++TnJpMUhVPf
  bJhBOqehWqompmmQgbejT8Bgkup4s8aZ2pU71VGYK4xVp8qqLAJriREXw1LqpaV0xXeoqJ4C
  Uuyuz2g62KvL5tnqmb8uhhS128Imra03iZvtsz2xikU8CFLInXkqvVsavZwyekKZTcArZ5Pt
  6vutvf3GBjC7VrRX1HMKR8fwwg4bo26+/Eq4729FCUyxHEPcO7FpFtvSscC8DJExx9vI+3G/
  JfNK1ncqh4zybyuvLEEBADs=
}

image create photo htmldiag1 -data {
  R0lGODdhbgBkAIQAAAAAAAsLCxYWFiAgICsrKzY2NkBAQEtLS1VVVWBgYGtra3V1dYCAgIuL
  i5WVlaCgoKqqqrW1tcDAwMrKytXV1eDg4Orq6vX19f//////////////////////////////
  /ywAAAAAbgBkAAAF/iAmjmRpnmiqrmzrvnAsz3Rt33iu73zv/8CgcEgsGo/IJBGAYTqb0Kc0
  Sp1aq9irNst9vphLkYWAEFEEkFGEIkIQLJhxGUMhsDGQ9wis7MnNaCducH90diJ5cBgVQ3xC
  AIVnaSMLiHqRh3h6GAgNUCsRBgd3NRIAp3ymqKcMe6gSKQdzkiIScAYKJJh3iW1zLBWoAzGO
  GKqnI8eorSKrsCcAk7QiDG8GAA4kjIa8mwi/xSbKN8oS5g6rpwnm5SvTcAwAA6gFtrrbvZy/
  LgWnk18llKUbSPCZCSbTIBjAEIGgvAQPSEjwNscCrHAmCJzaN0Ogw48GTSQUwMaCgFMH/lAJ
  YJBAwEpFI76JIRChBYJVAmAU8/ixIAoABiZBIDlCAQACFfrJY2Qh3oAJMSsSmIRxBIR0w2zc
  7PmRYwlFQ0lNOLXQwqoEjCaczEZn5j8VFU7i1CnoFLu7eM1tVAEmLIl5AARYMJuu1RkAv8a8
  rYpBabocKV0AONDCL0MMD7juPTwpKCJmKMYSpHsiHoPTqFOnBgD6p2UEEa8JANyVzklSeIhW
  dfwYRzzNy1gguDOoCS+uZdARsEo0BYWPpE38Bs56BZ/iwQrcudazZr+IEZp/KjF9YI7ymlur
  KN6YrEa5HwUHG1bhzrYT3EcDLE2dlXVOmzTUX3AJAEAKAq1g/pSfeb4NqN4JCmwS14DCMARA
  JQDCZMKCvUmGAnpcPVjChYqMgdxHbMijiSIYgYjKeQ7CoJEBGhGUy0etXFPBYKBAt590MfIV
  h0XVmVVAjQQcABVPZGFQYE1xXIQCfAMsEIE5MPYn4ldvPCdBeNk4RUID8WFgWhwEeJLCAqew
  NUNV8Ui25R6yiEDAAC6J0A9UI/Bm3pl1jldCMMtFkAB3OJgo2SYp/HMYA3VEQ4KAKJpC2X0q
  sEkbAyGxEI6JQBkg6qikjnoKoweJsOMiFBAKJSBc6bUQCYzFQ+YpA8xaQ0oUouROJiiEp5le
  GFIQkQrTCWDAadGJQRuFA2hIax28/qg5ggV+gmSKYQLUxBiZNOUAaq+nShtTN4owVSNwFpDZ
  ylQsmGJLA4fq2oIjLlIoIh/5DIeBUf2ZCUBNrzLR1IIDaPQsYyzkGyQK/ZYRzIBOGmiCSQH/
  KDC5q+y7oi8i3KrlPFYlyKZmVc7ZMMcdQ0zRCBOUKvPMuCDSHIcEudlsECSCHOUNzU2mLAMN
  5IVlHzLIhOZbM2CKKQ8M7wCG0orZTNwlZAAilHiCIu3117R2IfYWZI9tdtlo0xBJILldTUjW
  3FhirhFrb42bh3VbLYICB7w9Syb5MBK1DgbDPdIducCQd9snUKAmtXK3YW0Ri1smw2SzsG05
  HUTfB/nH/vo088IDpzUwN1+BHk7C3SxIo3lzjGzlDwYXAP6y4usGxvoKrtutKieDh22b75xU
  IJpKcOBzu+grp1MAaaoXL5oM0SPwPIgGRSxGpyrgHHwJ1V+PzBfV63E8KttEcPsY3rYAYlaS
  lQ/H9DB4xjgGCyygyAPwAWUu1fByQVMG4pUV2M8y+dvfSXQCFq7F4QG5UwlEKCGVfzCsAg3o
  3yqqxCfrNPBuFoDgi2RgmQTAQVhceYouAtg8zRTgaY1qjgkZokG6vKYVlAIOn6qGhwShAGDU
  EYyQbmghBr3gNXpYWArtRLwTTGxACeBdc4qjxO81w18ZMkavTqi3rlGjV8tJ/gFi3KZF/SRt
  ExSQWTqUVar7bO4EDyhVBOVRKsrYBI1qtOInisOjg6zCXiWwjOBa4BGVpSqLfRyRHtuANfuQ
  Ih2AZA5xDCmRgVDSBHzMRH1coZMI+c0MmcjhKdRFvOIED4j06CTW/nYHAcVAf2hi5QjmWIkH
  lBJVK3hiOjrYAljuYpbj81AsQUmK5wwkJ5JkJEwGl68oCvOXZhgh7mRJCYdACYmE4B4KqhiY
  GEBTBCfTIyQMB7iaeK864SHjGDwRNV0OBIY/gSYEzClNF6TOdnD4yEIeoE64xasn2kTBPdHV
  hHp6Shr4tJNDMKTMYTLPOT3ZHTQQSlAMrGsGn8tH/hHXeKBVxkB26QgjDDLKKErRhaTSoqU2
  PkmHiAzOna8ACEpLUKMYzDQOETgNQQZwGoOs7VUoqEBOC0SQBHAKniJJKE51Gsx7YbEXFiAq
  cFYiArZMAyMUyFZPCsDLgzz1ElJdBQ2gOkfN/GIaKDhMr4DaKKw5hDT5EBmFoIJWL/KqV8iE
  RuQwINcOHZFR50wPBg4glC2xDAAB3SsGAquTfKSBdKqJrGQ5RQK/hGOymFUNUqOxicdi9pWK
  QEDicPBGIsCSE6PFwXUqwoALiCACbmrAJJrCJwq0tote/MFqxXBbhugsaRXsYiYz10QlALCU
  OwPCImmwXLqk7blniy50waebXN1qTbgeHd5elfZQsN1Afg5NyPpOJ7UiGOh1/STudqWSIu/i
  AL0Nrdz6WMgz815zitkVb2iD21331gCb4dXcfJlW3zAAWL77dYsZBunf/+KXpfr1GQ/rgNTy
  LuHBARbKgInZ3wbDYBvDvS7ojsvhMJg4xNodMX8/12EPvwDFEQ7d0kqMgMQSzrwwFnCCZxy3
  LDbXxfnVsYQD+Dn2PMK8M1GvihXcYyP/2MUIHjJF40veGy8hyjKecCYyKSUYhAAAOw==
}

### Prompts the user to select exporting options.

proc exportOptions {exportType {fName {}}} {
  global exportFlags

  set w .exportFlagsWin
  set exportFlags(ok) -1
  toplevel $w
  wm withdraw $w
  wm title $w "[tr OptionsExport] $exportType"
  wm transient $w .main
  wm protocol $w WM_DELETE_WINDOW {set exportFlags(ok) 0}
  bind $w <Escape> "$w.b.cancel invoke"
  bind $w <Return> "$w.b.ok invoke"
  bind $w <F1> {helpWindow Export}

  pack [frame $w.o] -side top -fill x -pady 5 -padx 5

  set row 0
  if {$fName == {}} {
    label $w.o.append -text $::tr(AddToExistingFile)
    radiobutton $w.o.appendOn -text $::tr(Yes) -variable exportFlags(append) -value 1
    radiobutton $w.o.appendOff -text $::tr(No) -variable exportFlags(append) -value 0
    grid $w.o.append    -row $row -column 0 -sticky w
    grid $w.o.appendOn  -row $row -column 1 -sticky w
    grid $w.o.appendOff -row $row -column 2 -sticky w
    incr row
  } else {
    set exportFlags(append) 0
  }

  label $w.o.space -text [tr PgnOptSpace]
  radiobutton $w.o.spaceOn -text $::tr(Yes) -variable exportFlags(space) -value 1
  radiobutton $w.o.spaceOff -text $::tr(No) -variable exportFlags(space) -value 0

  label $w.o.comments -text $::tr(ExportComments)
  radiobutton $w.o.commentsOn -text $::tr(Yes) -variable exportFlags(comments) -value 1
  radiobutton $w.o.commentsOff -text $::tr(No) -variable exportFlags(comments) -value 0

  label $w.o.stripMarks -text $::tr(ExportStripMarks)
  radiobutton $w.o.stripMarksOn -text $::tr(Yes) -variable exportFlags(stripMarks) -value 1
  radiobutton $w.o.stripMarksOff -text $::tr(No) -variable exportFlags(stripMarks) -value 0
  # We don't save this value, instead ...
  if {$exportType != "PGN"} {
    set exportFlags(stripMarks) 1
  }


  label $w.o.indentc -text $::tr(IndentComments)
  radiobutton $w.o.indentcOn -text $::tr(Yes) -variable exportFlags(indentc) -value 1
  radiobutton $w.o.indentcOff -text $::tr(No) -variable exportFlags(indentc) -value 0

  label $w.o.vars -text $::tr(ExportVariations)
  radiobutton $w.o.varsOn -text $::tr(Yes) -variable exportFlags(vars) -value 1
  radiobutton $w.o.varsOff -text $::tr(No) -variable exportFlags(vars) -value 0

  label $w.o.indentv -text $::tr(IndentVariations)
  radiobutton $w.o.indentvOn -text $::tr(Yes) -variable exportFlags(indentv) -value 1
  radiobutton $w.o.indentvOff -text $::tr(No) -variable exportFlags(indentv) -value 0

  label $w.o.column -text $::tr(ExportColumnStyle)
  radiobutton $w.o.columnOn -text $::tr(Yes) -variable exportFlags(column) -value 1
  radiobutton $w.o.columnOff -text $::tr(No) -variable exportFlags(column) -value 0

  label $w.o.symbols -text $::tr(ExportSymbolStyle)
  radiobutton $w.o.symbolsOn -text "! +=" -variable exportFlags(symbols) -value 1
  radiobutton $w.o.symbolsOff -text {$2 $14} -variable exportFlags(symbols) -value 0

  foreach i {space comments stripMarks indentc vars indentv column} {
    grid $w.o.${i}    -row $row -column 0 -sticky w
    grid $w.o.${i}On  -row $row -column 1 -sticky w
    grid $w.o.${i}Off -row $row -column 2 -sticky w
    incr row
  }
  label $w.o.space2 -text ""
  grid $w.o.space2      -row $row -column 0 -sticky w
  incr row
  grid $w.o.symbols    -row $row -column 0 -sticky w
  grid $w.o.symbolsOn  -row $row -column 1 -sticky w
  grid $w.o.symbolsOff -row $row -column 2 -sticky w
  incr row

  # Extra option for PGN format: handling of null moves
  if {$exportType == "PGN"} {
    label $w.o.nullMoves -text "Convert null moves to comments"
    radiobutton $w.o.convertNullMoves -text $::tr(Yes) -variable exportFlags(convertNullMoves) -value 1
    radiobutton $w.o.keepNullMoves -text $::tr(No) -variable exportFlags(convertNullMoves) -value 0
    grid $w.o.nullMoves        -row $row -column 0 -sticky w
    grid $w.o.convertNullMoves -row $row -column 1 -sticky w
    grid $w.o.keepNullMoves    -row $row -column 2 -sticky w
    incr row

    label $w.o.utf8 -text "Character encoding"
    radiobutton $w.o.utf8True -text Utf-8 -variable exportFlags(utf8) -value 1
    radiobutton $w.o.utf8False -text Latin-1 -variable exportFlags(utf8) -value 0
    grid $w.o.utf8       -row $row -column 0 -sticky w
    grid $w.o.utf8True   -row $row -column 1 -sticky w
    grid $w.o.utf8False  -row $row -column 2 -sticky w
    incr row
  }

  # Extra option for HTML format: diagram image set
  if {$exportType == "HTML"} {
    label $w.o.space3 -text ""
    label $w.o.hdiag -text "Diagram"
    radiobutton $w.o.hb0 -text "bitmaps" -variable exportFlags(htmldiag) -value 0
    radiobutton $w.o.hb1 -text "bitmaps2" -variable exportFlags(htmldiag) -value 1
    label $w.o.hl0 -image htmldiag0
    label $w.o.hl1 -image htmldiag1
    grid $w.o.space3 -row $row -column 0
    incr row
    grid $w.o.hdiag  -row $row -column 0 -sticky w
    grid $w.o.hb0    -row $row -column 1 -sticky w
    grid $w.o.hb1    -row $row -column 2 -sticky w
    incr row
    grid $w.o.hl0    -row $row -column 1
    grid $w.o.hl1    -row $row -column 2
    incr row
  }

  addHorizontalRule $w
  pack [frame $w.b] -side top
  dialogbutton $w.b.ok -text "OK" -command {
    set exportFlags(ok) 1
  }
  dialogbutton $w.b.cancel -text $::tr(Cancel) -command {
    set exportFlags(ok) 0
  }
  dialogbutton $w.b.help -text $::tr(Help) -command {helpWindow Export}
  pack $w.b.ok $w.b.help $w.b.cancel -side left -padx 5 -pady 5

  update
  placeWinOverParent $w .
  wm deiconify $w

  tkwait variable exportFlags(ok)

  destroy $w
  return $exportFlags(ok)
}

### Export current game or all filtered games to a new PGN, LaTeX or Html file.

proc exportGames {selection exportType {fName {}}} {
  global ::pgn::moveNumberSpaces exportStartFile exportEndFile exportFlags initialDir

  set exportFilter [expr {$selection == "filter"}]
  if {$exportFilter} {
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
  }

  if {[exportOptions $exportType $fName] == 0} { return 0 }

  switch -- $exportType {
    "PGN" {
      set ftype {
        { "PGN files" {".pgn"} }
        { "All files" {"*"} }
      }
      set title "a PGN file"
      set idir $initialDir(pgn)
      set default ".pgn"
    }
    "HTML" {
      sc_info html $exportFlags(htmldiag)
      set ftype {
        { "HTML files" {".html" ".htm"} }
        { "All files" {"*"} }
      }
      set title "an HTML file"
      set idir $initialDir(html)
      set default ".html"
    }
    "Latex" {
      set ftype {
        { "LaTeX files" {".tex" ".ltx"} }
        { "All files" {"*"} }
      }
      set title "a LaTeX file"
      set idir $initialDir(tex)
      set default ".tex"
    }
    default { return }
  }

  if {$exportFlags(append)} {
    set getfile tk_getOpenFile
    set title "Add games to $title"
  } else {
    set getfile tk_getSaveFile
    set title "Create $title"
  }
  if {$fName == ""} {
    set fName [$getfile -initialdir $idir -filetypes $ftype \
	-defaultextension $default -title $title]
  }
  if {$fName == ""} {
    return
  }
  if {![string match *$default $fName]} {
      append fName $default
  }
  set initialDir(pgn) [file dirname $fName]

  if {$exportFilter} {
    progressWindow "Scid" "Exporting games..." $::tr(Cancel) "sc_progressBar"
  }
 # tk_messageBox -title "Debug" -type ok -icon error -message "Export Type $exportType" 
  busyCursor .
  set error [catch {
  sc_base export $selection $exportType $fName -append $exportFlags(append) \
      -starttext $exportStartFile($exportType) \
      -endtext $exportEndFile($exportType) \
      -comments $exportFlags(comments) -variations $exportFlags(vars) \
      -space $exportFlags(space) -symbols $exportFlags(symbols) \
      -indentC $exportFlags(indentc) -indentV $exportFlags(indentv) \
      -column $exportFlags(column) -noMarkCodes $exportFlags(stripMarks) \
      -convertNullMoves $exportFlags(convertNullMoves) -utf8 $exportFlags(utf8)
  }]

  if {$exportFilter} {
    closeProgressWindow
  }
  unbusyCursor .

  if {$error} {
    tk_messageBox -title "Scid: Oops" -type ok -icon error -message "File export/save failed."
  }

  if {$exportType == "HTML"} {
    set sourcedir [file nativename $::scidShareDir/bitmaps/]
    catch { file copy -force $sourcedir [file dirname $fName] }
  }

}

proc openExportGList {} {
  global glexport

  if {[sc_filter count] < 1} {
    tk_messageBox -type ok -icon info -title "Scid" \
      -message "There are no games in the filter." -parent .glistWin
    return
  }

  set w .glexport

  if {[winfo exists $w]} {
    raiseWin $w
    updateExportGList
    return
  }

  toplevel $w
  wm state $w withdrawn
  wm title $w "Save Game List"
  wm resizable $w 1 0

  pack [frame $w.format] -side top -fill x -expand 1 -pady 5
  label $w.format.lfmt -text "Format" -font font_Bold
  pack $w.format.lfmt -side left -padx 5
  entry $w.format.fmt -textvar glexport -font font_Fixed
  pack $w.format.fmt -side right -fill x -expand 1 -padx 3

  text $w.tfmt -width 1 -height 5 -font font_Fixed -wrap none -relief flat
  pack $w.tfmt -side top -fill x
  $w.tfmt insert end \
"w White            b Black            W White Elo        B Black Elo
m Moves count      r Result           y Year             d Date
e Event            s Site             n Round            o ECO code
g Game number      f Filtered number  F Final material   S Non-std start pos
D Deleted flag     U User flags       C Comments flag    V Variations flag  \n"

  $w.tfmt configure -cursor top_left_arrow -state disabled
  label $w.lpreview -text $::tr(Preview) -font font_Bold
  pack $w.lpreview -side top
  text $w.preview -width 80 -height 5 -font font_Fixed \
    -wrap none -setgrid 1 -xscrollcommand "$w.xbar set"
  scrollbar $w.xbar -orient horizontal -command "$w.preview xview"
  pack $w.preview -side top -fill x
  pack $w.xbar -side top -fill x
  pack [frame $w.b] -side bottom -fill x -pady 5
  dialogbutton $w.b.default -text "Default" -command {set glexport $glexportDefault}
  dialogbutton $w.b.ok -text "OK" -command saveExportGList
  dialogbutton $w.b.close -textvar ::tr(Cancel) -command "destroy $w"
  bind $w <Escape> "destroy $w"
  pack $w.b.close $w.b.ok -side right -padx 10
  pack $w.b.default -side left -padx 10
  focus $w.format.fmt
  $w.format.fmt icursor end
  updateExportGList

  update
  placeWinOverParent $w .glistWin
  wm state $w normal
}

trace variable glexport w updateExportGList

proc updateExportGList {args} {
  global glexport
  set w .glexport
  if {! [winfo exists $w]} { return }
  set text [sc_game list 1 5 "$glexport "]
  # remove trailing "\n"
  set text [string range $text 0 end-1]

  $w.preview configure -state normal
  $w.preview delete 1.0 end
  $w.preview insert end $text
  $w.preview configure -state disabled
}

proc saveExportGList {} {
  global glexport env
  set ftypes {{"Text files" {.txt}} {"All files" *}}
  set fname [tk_getSaveFile -filetypes $ftypes -parent .glexport \
               -title "Save Game List" -initialdir $env(HOME)]
  if {$fname == ""} { return }
  set showProgress 0
  if {[sc_filter count] >= 20000} { set showProgress 1 }
  if {$showProgress} {
    progressWindow "Scid" "Saving game list..." $::tr(Cancel) sc_progressBar
  }
  busyCursor .
  set res [catch {sc_game list 1 $::MAX_GAMES "$glexport\n" $fname} err]
  unbusyCursor .
  if {$showProgress} { closeProgressWindow }
  if {$res} {
    tk_messageBox -type ok -icon warning -title "Scid" -message $err
    return
  }
  destroy .glexport
}

### Global variables used in gameSave

set date 0; set year 0; set month 0; set day 0; set white 0; set black 0
set resultVal 0; set event 0; set site 0; set round 0
set whiteElo 0; set blackElo 0; set eco 0; set extraTags ""
set whiteRType "Elo"; set blackRType "Elo"
set edate 0; set eyear 0; set emonth 0; set eday 0

# Traces on game-save dialog variables to ensure sane values:

trace variable resultVal w  ::utils::validate::Result
trace variable whiteElo w {::utils::validate::Integer [sc_info limit elo] 0}
trace variable blackElo w {::utils::validate::Integer [sc_info limit elo] 0}
trace variable year w {::utils::validate::Integer [sc_info limit year] 1}
trace variable month w {::utils::validate::Integer 12 1}
trace variable day w {::utils::validate::Integer 31 1}
trace variable eyear w {::utils::validate::Integer [sc_info limit year] 1}
trace variable emonth w {::utils::validate::Integer 12 1}
trace variable eday w {::utils::validate::Integer 31 1}

set gsaveNum 0
set i 0; set j 0
set temp 0

array set nameMatches {}
set nameMatchCount 0

### Called from gameSave (and name editor) to update the matching name list
#   as the user types a player/site/event/round name.
#   The el and op fields don't do anything but may be needed because of args being appended by a bind

proc updateMatchList { tw nametype maxMatches name el op } {
  global nameMatches nameMatchCount
  global $name editNameType

  if {![winfo exists $tw]} return

  if {$nametype == ""} { set nametype $editNameType }
  if {$nametype == "rating"} { set nametype "player" }
  set val [set $name]
  $tw configure -state normal
  $tw delete 0.0 end
  set matches {}
  catch {set matches [sc_name match $nametype $val $maxMatches]}


  ### Set-up the autocomplete text button bindings

  set i 1
  # hmm... Unicode is broken for some reason (above also)

  set entrywidget [focus]

  foreach {count string} $matches {
    # mouse binding

    if {[string trim $string] != {}} {
      set nameMatches($i) $string
      $tw tag bind tag$i <ButtonRelease-1> [list set $name $string]
      $tw tag bind focus$i <Any-Enter> "$tw tag configure focus$i -back gray85"
      $tw tag bind focus$i <Any-Leave> "$tw tag configure focus$i -back {}"

      $tw insert end "$count\t$string\n" [list tag$i focus$i]
    }

    # Control-N key binding
    bind $entrywidget <Control-Key-$i> "
      set $name \"$string\"
      if {\[catch {$entrywidget icursor end}\]} {
        puts \"Oops: $entrywidget is not an entry widget\"
      }"

    incr i
  }
  $tw configure -state disabled

}

proc clearMatchList { tw } {
  global nameMatches nameMatchCount
  set nameMatchCount 0
  $tw configure -state normal
  $tw delete 0.0 end
  $tw configure -state disabled
}

# Traces to update the match list as names are typed in:

trace variable event w { updateMatchList .save.g.list e 9 }
trace variable site  w { updateMatchList .save.g.list s 9 }
trace variable white w { updateMatchList .save.g.list p 9 }
trace variable black w { updateMatchList .save.g.list p 9 }
trace variable round w { updateMatchList .save.g.list r 9 }

set editName ""
set editNameNew ""
set editNameType "player"
set editNameSelect "all"
set editNameRating ""
set editNameRType "Elo"
set editDate ""
set editDateNew ""

trace variable editNameRating w {::utils::validate::Integer [sc_info limit elo] 0}
trace variable editName w { updateMatchList .nedit.g.list "" 9 }
trace variable editDate w ::utils::validate::Date
trace variable editDateNew w ::utils::validate::Date

proc editNameNewProc { tw nametype maxMatches name el op } {
  global editNameNew
  if {! [winfo exists .nedit]} { return }
  if {[string compare $editNameNew ""]} {
    .nedit.buttons.replace configure -state normal
  } else {
    .nedit.buttons.replace configure -state disabled
  }
  catch {updateMatchList $tw $nametype $maxMatches $name $el $op}
}

trace variable editNameNew w { editNameNewProc .nedit.g.list "" 9 }


proc setNameEditorType {type} {
  if {! [winfo exists .nedit]} { return }
  catch {.nedit.typeButtons.$type invoke}
}

proc nameEditor {} {
  global editName editNameType editNameNew editNameSelect
  global editNameRating editDate editDateNew

  set w .nedit
  if {[winfo exists $w]} {
    raiseWin $w
    return
  }
  toplevel $w
  wm title $w "[tr ToolsMaintNameEditor]"
  setWinLocation $w
  bind $w <Configure> "recordWinSize $w"

  label $w.typeLabel -textvar ::tr(NameEditType) -font font_Bold
  frame $w.typeButtons
  pack $w.typeLabel $w.typeButtons -side top -pady 5
  foreach i { "Player" "Event" "Site" "Round"} {
    set j [string tolower $i]
    radiobutton $w.typeButtons.$j -textvar ::tr($i) -variable editNameType \
        -value $j -indicatoron false -pady 5 -padx 5 -command {
          grid remove .nedit.g.ratingE
          grid remove .nedit.g.rtype
          grid remove .nedit.g.fromD
          grid remove .nedit.g.toD
          grid .nedit.g.toL -row 1 -column 1 -sticky e
          grid .nedit.g.fromE -row 0 -column 2 -sticky w
          grid .nedit.g.toE -row 1 -column 2 -sticky w
          checkNeditReplace
        }
    pack $w.typeButtons.$j -side left -padx 5
  }
  radiobutton $w.typeButtons.rating -textvar ::tr(Rating) -variable editNameType \
      -value rating -indicatoron false -pady 5 -padx 5 -command {
        grid remove .nedit.g.toE
        grid remove .nedit.g.toL
        grid remove .nedit.g.fromD
        grid remove .nedit.g.toD
        grid .nedit.g.fromE -row 0 -column 2 -sticky w
        grid .nedit.g.rtype -row 1 -column 0 -columnspan 2 -sticky e -padx 5
        grid .nedit.g.ratingE -row 1 -column 2 -sticky w
        checkNeditReplace
      }
  radiobutton $w.typeButtons.date -textvar ::tr(Date) -variable editNameType \
      -value date -indicatoron false -pady 5 -padx 5 -command {
        grid remove .nedit.g.toE
        grid remove .nedit.g.fromE
        grid remove .nedit.g.ratingE
        grid remove .nedit.g.rtype
        grid .nedit.g.fromD -row 0 -column 2 -sticky w
        grid .nedit.g.toL -row 1 -column 1 -sticky e
        grid .nedit.g.toD -row 1 -column 2 -sticky w
        checkNeditReplace
      }
  radiobutton $w.typeButtons.edate -textvar ::tr(EventDate) \
      -variable editNameType -value edate -indicatoron false -pady 5 -padx 5 \
      -command {
        grid remove .nedit.g.toE
        grid remove .nedit.g.fromE
        grid remove .nedit.g.ratingE
        grid remove .nedit.g.rtype
        grid .nedit.g.fromD -row 0 -column 2 -sticky w
        grid .nedit.g.toL -row 1 -column 1 -sticky e
        grid .nedit.g.toD -row 1 -column 2 -sticky w
        checkNeditReplace
      }
  pack $w.typeButtons.rating $w.typeButtons.date $w.typeButtons.edate \
      -side left -padx 5

  addHorizontalRule .nedit

  label $w.selectLabel -textvar ::tr(NameEditSelect) -font font_Bold
  frame $w.selectButtons
  pack $w.selectLabel $w.selectButtons -side top -pady 5
  foreach i {all filter crosstable} row {0 1 2} text {
    SelectAllGames
    SelectFilterGames
    SelectTournamentGames
  } {
    radiobutton $w.selectButtons.$i -textvar ::tr($text) -variable editNameSelect -value $i
    grid $w.selectButtons.$i -row $row -column 0 -sticky w
  }

  addHorizontalRule $w

  pack [frame $w.g] -side top
  label $w.g.fromL -textvar ::tr(NameEditReplace) -anchor e
  entry $w.g.fromE -width 29  -relief sunken -textvariable editName
  entry $w.g.fromD -width 15  -relief sunken -textvariable editDate
  grid $w.g.fromL -row 0 -column 1 -sticky e -padx 10
  grid $w.g.fromE -row 0 -column 2 -sticky we

  label $w.g.toL -textvar ::tr(NameEditWith)
  entry $w.g.toE -width 29  -relief sunken -textvariable editNameNew
  entry $w.g.toD -width 15  -relief sunken -textvariable editDateNew
  grid $w.g.toL -row 1 -column 1 -sticky e  -padx 10
  grid $w.g.toE -row 1 -column 2 -sticky we

  entry $w.g.ratingE -width 5  -relief sunken -textvariable editNameRating -justify right
  eval tk_optionMenu $w.g.rtype editNameRType [sc_info ratings]
  $w.g.rtype configure -pady 2 -relief flat

  text $w.g.list -height 9 -width 40 -relief sunken \
      -background grey90 -tabs {2c left} -wrap none

  grid $w.g.list -row 2 -column 1 -rowspan 9 -columnspan 2 -sticky n -pady 5

  updateMatchList $w.g.list "" 9 editName "" w
 # $tw tag bind tag$i <ButtonRelease-1> [list set $name $string]

  # Update fromE and to entries automatch , when clicked in
  bind $w.g.fromE <FocusIn> "updateMatchList $w.g.list {} 9 editName {} w"
  bind $w.g.toE <FocusIn> "updateMatchList $w.g.list {} 9 editNameNew {} w"

  grid rowconfigure $w.g 0 -pad 5
  grid rowconfigure $w.g 1 -pad 5
  grid columnconfigure $w.g 1 -pad 20
  grid columnconfigure $w.g 2 -pad 5

  addHorizontalRule $w

  frame $w.buttons
  dialogbutton $w.buttons.replace -textvar ::tr(NameEditReplace) -command {
    if {$editNameType == "rating"} {
      set err [catch {sc_name edit $editNameType $editNameSelect $editName $editNameRating $editNameRType} result]
    } elseif {$editNameType == "date"  ||  $editNameType == "edate"} {
      set err [catch {sc_name edit $editNameType $editNameSelect $editDate $editDateNew} result]
    } else {
      set err [catch {sc_name edit $editNameType $editNameSelect $editName $editNameNew} result]
      # Refresh Player Info if old player name matches
      if {$editNameType == "player" && [winfo exists .playerInfoWin] && $playerInfoName == $editName} {
        playerInfo $editNameNew
      }
    }
    if {$err} {
      tk_messageBox -type ok -icon info -parent .nedit -title "Scid" \
          -message $result
    } else {
      .nedit.status configure -text $result
      pack .nedit.status -side bottom -fill x
    }
    sc_game tags reload
    updateBoard -pgn
    ::windows::gamelist::Refresh
  }

  dialogbutton $w.buttons.help -textvar ::tr(Help) -command {helpWindow Maintenance Editing}
  dialogbutton $w.buttons.cancel -textvar ::tr(Close) -command "destroy $w"
  pack $w.buttons -side top -pady 5
  pack $w.buttons.replace $w.buttons.help $w.buttons.cancel -side left -padx 10

  label $w.status -text "" -width 1 -font font_Small -relief sunken -anchor w

  wm resizable $w 0 0
  bind $w <Escape> "destroy $w"
  bind $w <Return> "$w.buttons.replace invoke"
  bind $w <Destroy> { if {"%W" == ".nedit"} {focus .main ; destroy .nedit}}
  bind $w <F1> {helpWindow Maintenance Editing}
  focus $w
  $w.typeButtons.$editNameType invoke
  checkNeditReplace
}

proc checkNeditReplace {} {
  global editNameNew editNameType
  if {$editNameType == "rating" || $editNameNew != ""} {
    .nedit.buttons.replace configure -state normal
  } else {
    .nedit.buttons.replace configure -state disabled
  }
}

# Scid's main game save dialog - used for adding and replacing games.
#   gnum == 0: add a new game
#   gnum >  0: replace game number gnum.
#   gnum <  0: dont save game, merely change game info

proc gameSave {gnum {focus {}}} {
  global date year month day white black resultVal event site round
  global whiteElo blackElo whiteRType blackRType eco extraTags gsaveNum
  global edate eyear emonth eday

  if {![sc_base inUse]} {
    # We can't load a game, no database is open
    tk_messageBox -title "Scid: No database open" -type ok -icon info \
        -message "No database is open; open or create one first."
    return
  }

  if {[sc_base isReadOnly]} {
    tk_messageBox -type ok -icon error -title "Scid: Oops" \
      -message "Database \"[file tail [sc_base filename]]\" is read-only."
    return
  }

  if {$::trialMode} {
    tk_messageBox -type ok -icon error -title "Scid: Trial Mode" \
      -message "Game Saves disabled in Trial Mode."
    return
  }

  set w .save

  if {[winfo exists $w]} {
    raiseWin $w
    return
  }

  toplevel $w
  wm withdraw $w

  if {$gnum == 0} {
    wm title $w "[file tail [sc_base filename]]: [tr GameAdd]"
  } elseif {$gnum > 0} {
    wm title $w "[file tail [sc_base filename]]: [tr GameReplace] $gnum"
  } else {
    wm title $w {Set Game Information}
  }

  set gsaveNum $gnum
  # Trial and error shows it's probably best to grab the app for game saves.
  catch {
    # this is pretty useless, but the best
    # bind $w <FocusOut> "raiseWin $w ; focus $w"
    # ::ttk::grabWindow $w
    grab $w
  }

  # frame $f holds everything except save/cancel buttons 
  set f [frame $w.g]
  pack $f -side top -expand 1 -fill both

  # Get current values of tags:
  set year [sc_game tag get Year];    set eyear [sc_game tag get EYear]
  set month [sc_game tag get Month];  set emonth [sc_game tag get EMonth]
  set day [sc_game tag get Day];      set eday [sc_game tag get EDay]
  set white [sc_game tag get White];  set black [sc_game tag get Black]
  set event [sc_game tag get Event];  set site [sc_game tag get Site]
  set resultVal [sc_game tag get Result];  set round [sc_game tag get Round]
  set whiteElo [sc_game tag get WhiteElo]
  set blackElo [sc_game tag get BlackElo]
  set whiteRType [sc_game tag get WhiteRType]
  set blackRType [sc_game tag get BlackRType]
  set eco [sc_game tag get ECO];  set extraTags [sc_game tag get Extra]

  # Use question marks instead of zero values in date:
  if {$year == 0} { set year "????" }
  if {$month == 0} { set month "??" }
  if {$day == 0} { set day "??" }
  if {$eyear == 0} { set eyear "????" }
  if {$emonth == 0} { set emonth "??" }
  if {$eday == 0} { set eday "??" }

  addGameSaveEntry white 0 ::tr(White:) p
  addGameSaveEntry black 1 ::tr(Black:) p
  addGameSaveEntry event 2 ::tr(Event:) e
  addGameSaveEntry site  3 ::tr(Site:)  s
  addGameSaveEntry round 4 ::tr(Round:) r

  frame $f.dateframe
  label $f.datelabel -textvar ::tr(Date:)
  entry $f.dateyear -width 6  -relief sunken -textvariable year -justify right
  label $f.datedot1 -text "."
  entry $f.datemonth -width 3  -relief sunken -textvariable month -justify right
  label $f.datedot2 -text "."
  entry $f.dateday -width 3  -relief sunken -textvariable day -justify right
  grid $f.datelabel -row 5 -column 0 -sticky w
  grid $f.dateframe -row 5 -column 1 -columnspan 5 -sticky w
  button $f.datechoose -image ::utils::date::calendar -command {
    set newdate [::utils::date::chooser "$year-$month-$day" .save]
    if {[llength $newdate] == 3} {
      set year [lindex $newdate 0]
      set month [lindex $newdate 1]
      set day [lindex $newdate 2]
    }
  }
  button $f.today -textvar ::tr(Today) -command {
    set year [::utils::date::today year]
    set month [::utils::date::today month]
    set day [::utils::date::today day]
  }
  pack $f.dateyear $f.datedot1 $f.datemonth $f.datedot2 $f.dateday \
      -in $f.dateframe -side left
  pack $f.datechoose -in $f.dateframe -side left -padx 3
  pack $f.today -in $f.dateframe -side left

  frame $f.edateframe
  label $f.edatelabel -textvar ::tr(EventDate:)
  entry $f.edateyear -width 6  -relief sunken \
      -textvariable eyear -justify right
  label $f.edatedot1 -text "."
  entry $f.edatemonth -width 3  -relief sunken \
      -textvariable emonth -justify right
  label $f.edatedot2 -text "."
  entry $f.edateday -width 3  -relief sunken \
      -textvariable eday -justify right
  grid $f.edatelabel -row 6 -column 0 -sticky w
  grid $f.edateframe -row 6 -column 1 -columnspan 5 -sticky w
  button $f.edatechoose -image ::utils::date::calendar -command {
    set newdate [::utils::date::chooser "$eyear-$emonth-$eday" .save]
    if {[llength $newdate] == 3} {
      set eyear [lindex $newdate 0]
      set emonth [lindex $newdate 1]
      set eday [lindex $newdate 2]
    }
  }
  button $f.esame -text "=$::tr(Date)" -command {
    set eyear $year
    set emonth $month
    set eday $day
  }
  pack $f.edateyear $f.edatedot1 $f.edatemonth $f.edatedot2 $f.edateday \
      -in $f.edateframe -side left
  pack $f.edatechoose -in $f.edateframe -side left -padx 3
  pack $f.esame -in $f.edateframe -side left

  # Game result

  label $f.reslabel -textvar ::tr(Result:)
  ttk::combobox $f.resentry -values {1 0 = *} -width 7 \
    -textvariable resultVal -state readonly
  grid $f.reslabel -row 7 -column 0 -sticky w
  grid $f.resentry -row 7 -column 1 -sticky w

  # White/Black Elo

  label $f.welolabel -text "$::tr(White:) "
  ttk::combobox $f.wrtype -values [sc_info ratings] -width 7 \
    -textvariable whiteRType -state readonly
  ttk::entry $f.weloentry -width 6 -textvariable whiteElo -justify right
  
  label $f.belolabel -text "$::tr(Black:) "
  ttk::combobox $f.brtype -values [sc_info ratings] -width 7 \
    -textvariable blackRType -state readonly
  ttk::entry $f.beloentry -width 6 -textvariable blackElo -justify right

  grid $f.welolabel -row 8 -column 0 -sticky sw
  grid $f.wrtype -row 8 -column 1 -sticky sw
  grid $f.weloentry -row 8 -column 2 -sticky sw
  grid $f.belolabel -row 9 -column 0 -sticky w
  grid $f.brtype -row 9 -column 1 -sticky w
  grid $f.beloentry -row 9 -column 2 -sticky w

  # Eco

  label $f.ecolabel -text "ECO Code:"
  ttk::entry $f.ecoentry -width 6  -textvariable eco -justify right
  grid $f.ecolabel -row 10 -column 0 -sticky w
  grid $f.ecoentry -row 10 -column 2 -sticky w

  button $f.ecob -textvar ::tr(Classify) -command {set eco [sc_eco game]} -width 8 -takefocus 0
  grid $f.ecob -row 10 -column 1 -sticky w

  # Autocomplete text widget and label

  text $f.list -height 9 -width 30 -relief sunken -background grey90 \
      -tabs {2c left} -wrap none -cursor arrow
  clearMatchList $f.list

  # label $f.title -textvar ::tr(NameEditMatches) -font font_Italic
  # grid $f.title -row 7           -column 8 -columnspan 2 -sticky n -padx 10

  grid $f.list -row 0 -rowspan 6 -column 8 -columnspan 2 -sticky nsew -padx 10
  # 6 rows seem enough to show the 9 autocompletions

  # Extra tags label+button

  label $f.extralabel -textvar ::tr(tagsDescript) -font font_Italic
  grid $f.extralabel -row 6 -column 8  -sticky n -pady 3

  button $f.extrabutton -textvar ::tr(prevTags) -command {
    set extraTags [sc_game tag get -last Extra]
    .save.g.extratext delete 1.0 end
    .save.g.extratext insert 1.0 $extraTags

    foreach {i j} {White white Black black} {
      set value [set $j]
      if {$value == "?" || $value == ""} {
	set $j [sc_game tag get -last $i]
	set ${j}Elo   [sc_game tag get -last ${i}Elo]
	set ${j}RType [sc_game tag get -last ${i}RType]
      }
    }
    foreach {i j} {Event event Site site} {
      set value [set $j]
      if {$value == "?" || $value == ""} {
	set $j [sc_game tag get -last $i]
      }
    }

    if {$year == "????" && $month == "??" && $day == "??" } {
      set year [sc_game tag get -last Year]
      set month [sc_game tag get -last Month]
      set day [sc_game tag get -last Day]
      if {$year == 0} { set year "????" }
      if {$month == 0} { set month "??" }
      if {$day == 0} { set day "??" }
    }
    if {$eyear == "????" && $emonth == "??" && $eday == "??" } {
      set eyear [sc_game tag get -last EYear]
      set emonth [sc_game tag get -last EMonth]
      set eday [sc_game tag get -last EDay]
      if {$eyear == 0} { set eyear "????" }
      if {$emonth == 0} { set emonth "??" }
      if {$eday == 0} { set eday "??" }
    }

  }

  # if {$gnum == 0} 
  grid $f.extrabutton -row 6 -column 9 -sticky ew -pady 3

  # Extra tags text widget+scrollbar (in frame)

  frame $f.extra
  grid $f.extra -row 7 -rowspan 3 -column 8 -columnspan 2 -padx 10 -pady 2 -sticky nsew
  grid rowconfigure $f 8 -weight 1
  grid columnconfigure $f 8 -weight 1

  text $f.extratext -height 2 -width 40 -wrap none -yscrollcommand "$f.extrascroll set"
  # Override tab-binding for this text widget
  bind $f.extratext <Key-Tab> "[bind all <Key-Tab>]; break"
  $f.extratext insert 1.0 $extraTags

  scrollbar $f.extrascroll -command "$f.extratext yview" -takefocus 0

  pack $f.extratext   -in $f.extra -side left -fill both -expand 1
  pack $f.extrascroll -in $f.extra -side right -fill y

  ### Custom extratags combobox 

  frame $f.custom

  ttk::combobox $f.custom.box -textvariable customTags -width 25
  bind $f.custom.box <<ComboboxSelected>> {
    # Move this tag to the history top
    ::utils::history::AddEntry customTags $customTags
  }
  ::utils::history::SetCombobox customTags $f.custom.box
  ::utils::history::SetLimit customTags  10
  grid $f.custom      -row 10 -column 8 -columnspan 2 -padx 10 -pady 2 -sticky nsew
  pack $f.custom.box -side left -padx 5

  button $f.custom.ok -textvar ::tr(GlistAddField) -command {
    catch {
      .save.g.extratext insert end "$customTags\n"
      .save.g.extratext see end
      ::utils::history::AddEntry customTags $customTags
    }
  }

  pack $f.custom.ok -side right -padx 5

  # <Return> invokes "save"

  foreach i {entryevent entrysite dateyear datemonth dateday \
	     entryround entrywhite entryblack resentry \
	     weloentry beloentry ecoentry edateyear edatemonth edateday} {
    bind $f.$i <Return> "$w.buttons.save invoke"
  }

  # Divider
  pack [frame $w.bar -height 2 -borderwidth 1 -relief sunken] -fill x -pady 5

  # Save/Cancel buttons

  frame $w.buttons
  if {$gnum == 0} {
    button $w.buttons.prev -text "As last game" -command {
    }
  }
  dialogbutton $w.buttons.save -textvar ::tr(Save) -underline 0 -command {
    if {[string is integer -strict $eyear] && ![string is integer -strict $year]} {
      tk_messageBox -type ok -icon error -title "Scid: Oops" \
	-message "Event date can't exist without Game date." -parent .save
    } else {
      set extraTags [.save.g.extratext get 1.0 end-1c]
      if {[gsave $gsaveNum]} {
        destroy .save
        updateMenuStates
      }
    }
  }

  if {$gsaveNum < 0} {
    $w.buttons.save configure -textvar {} -text Ok 
  }

  dialogbutton $w.buttons.cancel -textvar ::tr(Cancel) -command "destroy $w"
  pack $w.buttons -side bottom -pady 8
  if {$gnum == 0} {
    #pack .save.buttons.prev -side left -padx 10
  }
  pack $w.buttons.cancel $w.buttons.save -side right -padx 20

  bind $w <Alt-s> "
    $w.buttons.save invoke
    break
  "

  bind $w <Escape> {
    focus .main
    destroy .save
  }


  update
  placeWinOverParent $w .
  wm deiconify $w

  switch -- $focus {
    {} {
       }
    "date" {
         $f.dateyear selection range 0 end
         focus $f.dateyear
       }
    default {
         .save.g.entry$focus selection range 0 end
         focus .save.g.entry$focus
       }
   }
    
  if {$gnum > 0} { focus .save.buttons.save }
}

# Used above for setting up the simpler labels and entry boxes.

proc addGameSaveEntry {name row textname nametype} {
  label .save.g.label$name -textvar $textname
  entry .save.g.entry$name -width 30  -relief sunken -textvariable $name
  grid .save.g.label$name -row $row -column 0 -sticky w
  grid .save.g.entry$name -row $row -column 1 -columnspan 7 -sticky w

  # New FocusIn binding for gameSave. Correct ??? S.A
  bind .save.g.entry$name <FocusIn> "updateMatchList .save.g.list $nametype 9 $name {} {}"
}

#    Called by gameSave when the user presses the "Save" button
#    (If gnum < 0 dont actually save game - just set game tags)

proc gsave { gnum } {

  global date year month day white black resultVal event site round
  global whiteElo blackElo whiteRType blackRType eco extraTags
  global edate eyear emonth eday

  set date [format "%s.%s.%s" $year $month $day]
  set edate [format "%s.%s.%s" $eyear $emonth $eday]
  set extraTagsList [split $extraTags "\n"]

  foreach i {white black event site round} {
    set $i [string trim [set $i]]
    if {[set $i] == ""} {
      set $i "?"
    }
    if {[string bytelength [set $i]] > 255} {
      tk_messageBox -type ok -icon info -parent .save -title "Oops" -message "\"[string totitle $i]\" is larger than 255 bytes."
      return 0
    }
    foreach j $extraTagsList {
      if {[string trim $j] != {} && ![regexp {^[^ ]*  *".*"$} [string trim $j]]} {
	tk_messageBox -type ok -icon info -parent .save -title "Oops" -message \
        "Tag\n  $j\nis not in format\n  TagName \"TagData\""
	return 0
      }
    }
  }

  sc_game undoPoint
  sc_game tags set -event $event -site $site -date $date -round $round \
      -white $white -black $black -result $resultVal \
      -whiteElo $whiteElo -whiteRatingType $whiteRType \
      -blackElo $blackElo -blackRatingType $blackRType \
      -eco $eco -eventdate $edate -extra $extraTagsList

  ### Dont save game if gnum < 0
  if {$gnum < 0} {
    sc_game setaltered 1
  } else {
    set res [sc_game save $gnum]

    if {$res != {}} {
      tk_messageBox -type ok -icon info -parent .save -title "Scid" -message $res
    } else {
      if {$gnum == 0} {
	# add new game to history
	::bookmarks::AddCurrentGame
      }
    }
  }

  updateBoard -pgn
  ::windows::gamelist::Refresh
  updateTitle
  return 1
}

proc gameAdd {} {
  gameSave 0
}

# Current game number should be nonzero.

proc gameReplace {} {
  gameSave [sc_game number]
}

proc gameQuickSave {} {
  set gnum [sc_game number]
  if {$gnum == 0} {
    gameAdd
  } else {
    sc_game save [sc_game number]
    updateBoard -pgn
  } 
}


# Pascal Georges : allow the drawing of markers directly on the board (not through comment editor)

set startArrowSquare ""

proc addMarker {sq color} {
  set to [::board::san $sq]
  set oldComment [sc_pos getComment]

  # check if the square is already of the same color
  set erase [regexp "\[\x5B\]%draw full,$to,$color\[\x5D\]" $oldComment]
  regsub "\[\x5B\]%draw full,$to,$::commenteditor::colorRegsub\[\x5D\]" $oldComment "" newComment
  set newComment [string trim $newComment]
  if {!$erase} {
    append newComment " \[%draw full,$to,$color\]"
  }
  sc_pos setComment $newComment
  ::pgn::Refresh 1
  updateBoard
}

proc drawArrow {sq color} {
  global startArrowSquare
  if {$startArrowSquare == ""} {
    set startArrowSquare [::board::san $sq]
  } else  {
    set oldComment [sc_pos getComment]
    set to [::board::san $sq]
    if {$startArrowSquare != $to } {
      set erase [regexp "\[\x5B\]%draw arrow,$startArrowSquare,$to,$color\[\x5D\]" $oldComment]
      regsub "\[\x5B\]%draw arrow,$startArrowSquare,$to,$::commenteditor::colorRegsub\[\x5D\]" $oldComment "" newComment
      set newComment [string trim $newComment]
      if {!$erase} {
        append newComment " \[%draw arrow,$startArrowSquare,$to,$color\]"
      }
      sc_game undoPoint
      sc_pos setComment $newComment
      ::pgn::Refresh 1
      updateBoard
    }
    set startArrowSquare ""
  }
}

###
### Keyboard and Mouse Bindings
###

# Todo: change pressSquare to "pressSquare $w" and make it usable by other boards.
for {set i 0} { $i < 64 } { incr i } {
  ::board::bind .main.board $i <Enter> "enterSquare $i"
  ::board::bind .main.board $i <Leave> "leaveSquare $i"
  ::board::bind .main.board $i <ButtonPress-1> "pressSquare $i 0"
  ::board::bind .main.board $i <ButtonPress-2> "pressSquare $i 1"
  ::board::bind .main.board $i <Control-ButtonPress-1> "drawArrow $i \$::::commenteditor::State(markColor)"
  # ::board::bind .main.board $i <Control-ButtonPress-2> "drawArrow $i yellow"
  # ::board::bind .main.board $i <Control-ButtonPress-3> "drawArrow $i red"
  ::board::bind .main.board $i <Shift-ButtonPress-1> "addMarker $i \$::::commenteditor::State(markColor)"
  # ::board::bind .main.board $i <Shift-ButtonPress-2> "addMarker $i yellow"
  # ::board::bind .main.board $i <Shift-ButtonPress-3> "addMarker $i red"

  ### Too dangerous. (backSquare deprecated for ::move::Back) S.A.
  # Pascal Georges : this should be removed because I find it too dangerous for people with cats ??
  # ::board::bind .main.board $i <ButtonPress-3> backSquare
}

# These binds must be moved back into for loop
# if we want to use the above "addMarker" bindings
bind .main.board.bd <B1-Motion> {::board::dragPiece .main.board %x %y}
bind .main.board.bd <ButtonRelease-1> {releaseSquare .main.board %x %y}
bind .main.board.bd <ButtonRelease-2> {releaseSquare .main.board %x %y}

foreach i {o q r n k O Q R B N K} {
  bind .main <$i> "moveEntry_Char [string toupper $i]"
}
foreach i {a b c d e f g h 1 2 3 4 5 6 7 8} {
  bind .main <Key-$i> "moveEntry_Char $i"
}

if {$::macOS} {
  bind .main <BackSpace> ::game::Truncate
  # Hmm - OS X doesn't remember the focus state. Any others ??
  bind . <FocusIn> {focus .main}
} else {
  bind .main <BackSpace> ::move::Back
}

bind .main <Escape> "moveEntry_Clear 1"
bind .main <Tab> {raiseAllWindows 1}

bind .main <Return> addAnalysisMove
bind .main <Control-Return> addAnalysisVariation
bind .main <space>  toggleEngineAnalysis

bind .main <v> showVars
bind .main <z> {.main.button.exitVar invoke}
bind .main <Control-a> {.main.button.addVar invoke}
bind .main <Control-f> {
  if {!$tree(refresh)} {toggleRotateBoard}
}
bind .main <minus><minus> "addMove null null"

# MouseWheel in main window:
if {$windowsOS || $macOS} {
  bind .main <MouseWheel> {
    if {[expr -%D] < 0} { ::move::Back }
    if {[expr -%D] > 0} { ::move::Forward }
  }
  bind .main <Shift-MouseWheel> {
    if {[expr -%D] < 0} { ::move::Back 10 }
    if {[expr -%D] > 0} { ::move::Forward 10}
  }
  if { $::docking::USE_DOCKING } {
    bindWheeltoFont .main
  } else {
    bind .main <Control-MouseWheel> {
      if {[expr -%D] < 0} {::board::resize .main.board +1}
      if {[expr -%D] > 0} {::board::resize .main.board -1}
    }
  }
} else {
  bind .main <Button-4> ::move::Back
  bind .main <Button-5> ::move::Forward
  bind .main <Shift-Button-4> {::move::Back 10}
  bind .main <Shift-Button-5> {::move::Forward 10}
  if { $::docking::USE_DOCKING } {
    bindWheeltoFont .main
  } else {
    bind .main <Control-Button-4> {::board::resize .main.board +1}
    bind .main <Control-Button-5> {::board::resize .main.board -1}
  }
}
bindWheeltoFont .splash

proc standardShortcuts {w} {
  bind $w <Control-o> ::file::Open
  bind $w <Control-w> ::file::Close
  bind $w <Control-slash> ::file::finder::Open
  bind $w <Control-m> ::maint::Open
  bind $w <Control-q> ::file::Exit
  bind $w <Control-g> ::game::GotoMoveNumber
  bind $w <Control-u> ::game::LoadNumber
  bind $w <Control-G> ::search::header
  bind $w <Control-M> ::search::material
  bind $w <Control-e> ::commenteditor::Open
  bind $w <Control-B> ::setupBoard
  bind $w <Control-b> ::chooseBoardColors
  bind $w <Control-l> ::windows::gamelist::Open
  bind $w <Control-p> ::pgn::Open
  bind $w <Control-T> ::tourney::Open
  bind $w <Control-P> ::plist::Open
  bind $w <Control-i> ::toggleGameInfo
  bind $w <Control-t> ::tree::Open
  bind $w <Control-A> ::enginelist::choose
  bind $w <Control-X> ::crosstab::Open
  bind $w <Control-Z> ::tools::graphs::score::Toggle
  bind $w <Control-I> importPgnGame

  ### These should probably be moved to a different proc/place - S.A.
  # as we are often resolving conflicts *after* calling standardShortcuts
  bind $w <Home>  ::move::Start
  bind $w <Up> {
    if {[sc_var level] > 0} {
      .main.button.exitVar invoke
    } else  {
      ::move::Back 10
    }
  }
  bind $w <Left>  ::move::Back
  bind $w <Down>  {::move::Forward 10}
  bind $w <Right> ::move::Forward
  bind $w <End>   ::move::End
  bind $w <F2>    {::startAnalysisWin F2}
  bind $w <F3>    {::startAnalysisWin F3}
  bind $w <F4>    {::startAnalysisWin F4}

  bind $w <Control-C> ::copyFEN
  bind $w <Control-V> ::pasteFEN
  bind $w <Control-s> ::gameReplace
  bind $w <Control-S> ::gameAdd

  bind $w <F11>  toggleFullScreen
  bind $w <Control-Shift-Left>  {::board::resize .main.board -1}
  bind $w <Control-Shift-Right> {::board::resize .main.board +1}
  standardGameShortcuts $w
}

proc standardGameShortcuts {w} {
  bind $w <Control-Home> {::game::LoadNextPrev first}
  bind $w <Control-End> {::game::LoadNextPrev last}
  bind $w <Control-Down> {::game::LoadNextPrev next}
  bind $w <Control-Up> {::game::LoadNextPrev previous}
  bind $w <Control-question> ::game::LoadRandom
}

standardShortcuts .main

proc shortcutAddNag {nag} {
  sc_game undoPoint
  sc_pos addNag $nag
  updateBoard -pgn
}

foreach {i j} {
  <exclam><Return>         !
  <exclam><exclam><Return> !!
  <question><Return>       ?
  <plus><minus>            +-
  <plus><slash>            +/-
  <plus><equal>            +=
  <equal><Return>          =
  <minus><plus>            -+
  <minus><slash>           -/+
  <equal><plus>            =+
  <asciitilde><Return>     ~
  <exclam><question><Return>   !?
  <question><question><Return> ??
  <question><exclam><Return>   ?!
  <asciitilde><equal><Return>  ~=
} {
  bind .main $i "shortcutAddNag $j"
}

if { 0 && $::docking::USE_DOCKING} {
  ttk::frame .main.space
  grid .main.space -row 4 -column 0 -columnspan 3 -sticky nsew
  grid rowconfigure .main 4 -weight 1
}

### Status Bar

label .main.statusbar -textvariable statusBar -relief sunken -anchor w -width 1 -font font_Small
label .main.statusbarpady -text {} -relief flat

# double-left-click starts/stops engine 1
bind .main.statusbar <Double-Button-1> {
  makeAnalysisWin 1
  if {[winfo exists .analysisWin1] && $::analysis(mini)} {
    set ::statusBar "   [lindex $::analysis(name1) 0]:"
    update
  }
}

# todo mac button patch
bind .main.statusbar <Button-2> {::file::SwitchToNextBase ; break}

# Right-click toggles window size
bind .main.statusbar <Button-3>  {
  toggleMini
  if {[winfo exists .analysisWin1] && $::analysis(mini)} {
    set ::statusBar "   [lindex $::analysis(name1) 0]:"
    update
  }
  break
}

############################################################
### Grid the main window &&&

grid .main.statusbar -row 4 -column 0 -columnspan 3 -sticky we

if {!$::gameInfo(showStatus)} {
  grid remove .main.statusbar
}

#frame .sep -width 2 -borderwidth 2 -relief groove
#frame .panels
#grid .main.boardframe -row 1 -column 0 -columnspan 3 -sticky news
#grid .sep -row 1 -column 1 -rowspan 3 -sticky ns -padx 4
#grid .panels -row 1 -column 2 -rowspan 3 -sticky news -pady 2

grid columnconfigure .main 0 -weight 1

### game info widget only gets its requested size

if { $::docking::USE_DOCKING } {
  # Needs weight 2 ?
  grid rowconfigure .main 3 -weight 1
} 

grid .main.button -row 1 -column 0 -pady 3 -padx 5

if {!$::gameInfo(showButtons)} {
  grid remove .main.button
}

grid .main.board -row 2 -column 0 -sticky we -padx 5 -pady 5

showGameInfo

#set p .panels
#::utils::pane::Create $p.pane top bottom 200 100 0.3
#pack $p.pane -side top -fill both -expand yes
#label $p.pane.top.db -font font_Bold -foreground white -background darkBlue -text "Databases" -anchor w
#pack $p.pane.top.db -side top -fill x
#autoscrollframe -bars y $p.pane.top.f canvas $p.pane.top.f.c
#pack $p.pane.top.f -side top -fill both -expand yes

#label $p.pane.bottom.title -font font_Bold -foreground white -background darkBlue -text "Notation" -anchor w
#pack $p.pane.bottom.title -side top -fill x
#autoscrollframe -bars y $p.pane.bottom.f text $p.pane.bottom.f.text -width 0
#pack $p.pane.bottom.f -side top -fill both -expand yes
#::htext::init $p.pane.bottom.f.text

redrawToolbar

### Wish 8.5 has a nice fullscreen feature.
### just press F11 in KDE , or use [wm attribute . -fullscreen 1]
# wm resizable . 0 1
# wm minsize . 0 0
wm iconname . Scid

#################
# Open files and databases:

# Check for arguments starting with "-" (or "/" on Windows):

set fastDBopen 0 ; # fast database opens
set loadAtStart(spell) 1
set loadAtStart(eco) 1
set loadAtStart(tb) 1

proc getCommandLineOptions {} {
  global argc argv windowsOS loadAtStart

  if { $::macOS && ([string first "-psn" [lindex $argv 0]] == 0)} {
    # Remove Process Serial Number from argument list:
    set argv [lrange $argv 1 end]
    incr argc -1
  } elseif { $windowsOS && [string match "*scid.gui" [lindex $argv 0]]} {
    # Remove "$PATH/scid.gui" from argument list
    set argv [lrange $argv 1 end]
    incr argc -1
  }

  while {$argc > 0} {
    set arg [lindex $argv 0]
    set firstChar [string index $arg 0]
    if {$firstChar == "-"  ||  ($windowsOS  &&  $firstChar == "/")} {
      # Seen option argument:
      incr argc -1
      set argv [lrange $argv 1 end]
      
      # Special argument "--" means no more options:
      if {$arg == "--"} { return }
      
      # Check for known option names:
      #   -f (/f), -fast (/fast): Fast start with no tablebases, etc.
      #   -xeco, -xe: Do not load ECO file.
      #   -xspell, -xs: Do not load spellcheck file.
      #   -xtb, -xt: Do not check tablebase directory.
      
      set argName [string range $arg 1 end]

      switch -glob -- $argName {
        -*   {
         puts "
$::scidName Version $::scidVersion ($::scidVersionDate)
Based on: Shane's Chess Information Database
Using Tcl/Tk version: [info patchlevel]

Author: Shane Hudson
Contribution: Pascal Georges
$::scidName: Steven Atkinson
Email: stevenaaus@yahoo.com
Http://scidvspc.sourceforge.net
"
          exit
        }
        "f"    -
        "fast" {
          ::splash::add "Fast start: Database fast opens enabled, and no tablebases, ECO or spelling file loaded."
          set ::fastDBopen 1
          set loadAtStart(spell) 0
          set loadAtStart(eco) 0
          set loadAtStart(tb) 0
        }
        "xt" -
        "xtb" {
          set loadAtStart(tb) 0
        }
        "xe" -
        "xeco" {
          set loadAtStart(eco) 0
        }
        "xs" -
        "xspell" {
          set loadAtStart(spell) 0
        }
        "s1"  { set ::boardSize 21 }
        "s2"  { set ::boardSize 25 }
        "s3"  { set ::boardSize 29 }
        "s4"  { set ::boardSize 33 }
        "s5"  { set ::boardSize 37 }
        "s6"  { set ::boardSize 40 }
        "s7"  { set ::boardSize 45 }
        "s8"  { set ::boardSize 49 }
        "s9"  { set ::boardSize 54 }
        "s10" { set ::boardSize 58 }
        "s11" { set ::boardSize 64 }
        "s12" { set ::boardSize 72 }
        "dock" -
        "nodock" {} ; # handled later
        default {
          ::splash::add "Warning: unknown option: \"$arg\"" error
        }
      }
    } else {
      # Seen first non-option argument:
      return
    }
  }
}

getCommandLineOptions

if {[catch {
  setLanguage $language
}]} {
  setLanguage E
}

updateTitle
updateBoard
updateStatusBar
update idle

# Try to find tablebases:
if {$loadAtStart(tb)} {
  if {[sc_info tb]} {
    ::splash::add "Checking for endgame tablebase files."
    set tbDirs {}
    foreach i {1 2 3 4} {
      if {$initialDir(tablebase$i) != ""} {
        if {$tbDirs != ""} { append tbDirs ";" }
        append tbDirs [file nativename $initialDir(tablebase$i)]
      }
    }
    if {$tbDirs == ""} {
      set result 0
    } else {
      set result [sc_info tb $tbDirs]
    }
    if {$result == 0} {
      ::splash::add "    No tablebases were found."
    } else {
      ::splash::add "    Tablebases with up to $result pieces were found."
    }
  }
}

# Try to open the ECO classification file:
set result 0
set ecoFile_fullname [file nativename $ecoFile]

if {$loadAtStart(eco)} {
  if {[catch { sc_eco read $ecoFile_fullname } result]} {
    # Hmmm - failed. So try "scid.eco" in the current directory:
    if {[catch {sc_eco read "scid.eco"} result]} {
      ::splash::add "Unable to open the ECO file: $ecoFile" error
    } else {
      ::splash::add "ECO file \"./scid.eco\" loaded: $result positions."
    }
  } else {
    ::splash::add "ECO file \"$ecoFile_fullname\"  loaded: $result positions."
  }
}

### Try to load the spellcheck file:

set spellCheckFileExists 0
if {$loadAtStart(spell)} {
  if {[catch {sc_name read $spellCheckFile} result]} {
    ::splash::add "Unable to load the default spellcheck file: $spellCheckFile" error
  } else {
    ::splash::add "Spellcheck file \"$spellCheckFile\" loaded:"
    ::splash::add "    [lindex $result 0] players, [lindex $result 1] events, [lindex $result 2] sites, [lindex $result 3] rounds."
    set spellCheckFileExists 1
  }
}

#   Returns a file's canonical name.

proc fullname {fname} {
  # http://wiki.tcl.tk/10078
  return [file dirname [file normalize $fname/__]]
}

# Loading a database if specified on the command line:
# Need to check file type: .epd, .pgn, .pgn.gz, etc

while {$argc > 0} {
  set arg [lindex $argv 0]

  # remove any "file://"
  if {[string match {file://*} $arg]} {
    set arg [string range $arg 7 end]
  }

  set startbase [fullname $arg]
  if {! [catch {sc_game startBoard $startbase}]} {
    set argc 0
    break
  }
  if {! [catch {sc_game startBoard [join $argv " "]}]} {
    set argc 0
    break
  }
  if {[string match "*.epd*" $startbase]} {
    ::splash::add "Opening EPD file: $startbase..."
    if {![newEpdWin openSilent $startbase]} {
      ::splash::add "   Error opening EPD file: $startbase" error
    }
    set initialDir(epd) [file dirname $startbase]
  } elseif {[string match "*.sso" $startbase]} {
    ::splash::add "Opening filter file: $startbase..."
    if {[catch {uplevel "#0" source $startbase} err]} {
      ::splash::add "   Error opening $startbase: $err" error
    } else {
      switch -- $::searchType {
        "Material" {
          sc_search material \
            -wq [list $pMin(wq) $pMax(wq)] -bq [list $pMin(bq) $pMax(bq)] \
            -wr [list $pMin(wr) $pMax(wr)] -br [list $pMin(br) $pMax(br)] \
            -wb [list $pMin(wb) $pMax(wb)] -bb [list $pMin(bb) $pMax(bb)] \
            -wn [list $pMin(wn) $pMax(wn)] -bn [list $pMin(bn) $pMax(bn)] \
            -wm [list $pMin(wm) $pMax(wm)] -bm [list $pMin(bm) $pMax(bm)] \
            -wp [list $pMin(wp) $pMax(wp)] -bp [list $pMin(bp) $pMax(bp)] \
            -flip $ignoreColors -filter $::search::filter::operation \
            -range [list $minMoveNum $maxMoveNum] \
            -length $minHalfMoves -bishops $oppBishops \
            -diff [list $minMatDiff $maxMatDiff] \
            -patt "$pattBool(1) $pattPiece(1) $pattFyle(1) $pattRank(1)" \
            -patt "$pattBool(2) $pattPiece(2) $pattFyle(2) $pattRank(2)" \
            -patt "$pattBool(3) $pattPiece(3) $pattFyle(3) $pattRank(3)" \
            -patt "$pattBool(4) $pattPiece(4) $pattFyle(4) $pattRank(4)" \
            -patt "$pattBool(5) $pattPiece(5) $pattFyle(5) $pattRank(5)" \
            -patt "$pattBool(6) $pattPiece(6) $pattFyle(6) $pattRank(6)" \
            -patt "$pattBool(7) $pattPiece(7) $pattFyle(7) $pattRank(7)" \
            -patt "$pattBool(8) $pattPiece(8) $pattFyle(8) $pattRank(8)" \
            -patt "$pattBool(9) $pattPiece(9) $pattFyle(9) $pattRank(9)" \
            -patt "$pattBool(10) $pattPiece(10) $pattFyle(10) $pattRank(10)"
            ::splash::add "   Material/Pattern filter file $startbase correctly applied"
        }
        "Header"   {
          set sPgnlist {}
          foreach i {1 2 3} {
            set temp [string trim $sPgntext($i)]
            if {$temp != ""} { lappend sPgnlist $temp }
          }
          set wtitles {}
          set btitles {}
          foreach i $sTitleList {
            if $sTitles(w:$i) { lappend wtitles $i }
            if $sTitles(b:$i) { lappend btitles $i }
          }
          sc_search header -white $sWhite -black $sBlack \
            -event $sEvent -site $sSite -round $sRound \
            -date [list $sDateMin $sDateMax] \
            -results [list $sResWin $sResDraw $sResLoss $sResOther] \
            -welo [list $sWhiteEloMin $sWhiteEloMax] \
            -belo [list $sBlackEloMin $sBlackEloMax] \
            -delo [list $sEloDiffMin $sEloDiffMax] \
            -eco [list $sEcoMin $sEcoMax $sEco] \
            -length [list $sGlMin $sGlMax] \
            -toMove $sSideToMove \
            -gameNumber [list $sGnumMin $sGnumMax] \
            -flip $sIgnoreCol -filter $::search::filter::operation \
            -fStdStart $sHeaderFlags(StdStart) \
            -fPromotions $sHeaderFlags(Promotions) \
            -fUnderPromo $sHeaderFlags(UnderPromo) \
            -fComments $sHeaderFlags(Comments) \
            -fVariations $sHeaderFlags(Variations) \
            -fAnnotations $sHeaderFlags(Annotations) \
            -fDelete $sHeaderFlags(DeleteFlag) \
            -fWhiteOp $sHeaderFlags(WhiteOpFlag) \
            -fBlackOp $sHeaderFlags(BlackOpFlag) \
            -fMiddlegame $sHeaderFlags(MiddlegameFlag) \
            -fEndgame $sHeaderFlags(EndgameFlag) \
            -fNovelty $sHeaderFlags(NoveltyFlag) \
            -fPawnStruct $sHeaderFlags(PawnFlag) \
            -fTactics $sHeaderFlags(TacticsFlag) \
            -fKingside $sHeaderFlags(KsideFlag) \
            -fQueenside $sHeaderFlags(QsideFlag) \
            -fBrilliancy $sHeaderFlags(BrilliancyFlag) \
            -fBlunder $sHeaderFlags(BlunderFlag) \
            -fUser $sHeaderFlags(UserFlag) \
            -pgn $sPgnlist -wtitles $wtitles -btitles $btitles \
            -ignoreCase $sPgncase -gameend $sGameEnd \
            ::splash::add "   Header filter file $startbase correctly applied"
        }
      }
      set glstart 1
      # needed ?
      ::windows::gamelist::Refresh
      ::windows::stats::Refresh
    }
  } else {
    busyCursor .
    ::splash::add "Opening database: $startbase ..."
    set err 0
    set errMessage ""
    if {[string match "*.pgn" $startbase] || \
          [string match "*.PGN" $startbase] || \
          [string match "*.pgn.gz" $startbase]} {
      set err [catch {sc_base create $startbase true} errMessage]
      if {$err == 0} {
        set err [catch {
                  doPgnFileImport $startbase "Opening [file tail $startbase] read-only.\n"
                 } errMessage]
        if {!$err} {
	  sc_base type [sc_base current] 3
        }
      }
    } else {
      set err [catch { ::file::Open $startbase} errMessage]
    }
    if {$err} {
      ### Above err and errMessage should be shown as dialog messages S.A.
      ### Umm... they are. ? S.A.
      set errMessage "$errMessage\nCould not open database \"$startbase\""
      ::splash::add $errMessage error
      tk_messageBox -title "Scid: Oops" -type ok -icon error -message $errMessage
    } else {
      ::splash::add "   Database \"$startbase\" opened: [sc_base numGames] games."
      set initialDir(base) [file dirname $startbase]
      set initialDir(file) [file tail $startbase]
      # this sets initialDir(file) for all files, not just pgn... 
      # but initialDir(file) is only (currently) used when saving pgn S.A.
      catch {sc_game load auto}
      flipBoardForPlayerNames
    }
  }
  unbusyCursor .
  incr argc -1
  set argv [lrange $argv 1 end]
}

##################################
### Main window initialisation ###
##################################

updateBoard
updateStatusBar
updateTitle
updateLocale
updateMenuStates
update
bind $dot_w <Configure> {recordWinSize $dot_w}

### Bindings to map/unmap all windows when main window is mapped
# Dammit - how do we 

if { $::docking::USE_DOCKING } {
  bind .pw <Map> {raiseAllWindows}
  bind .pw  <Unmap> {showHideAllWindows iconify}
} else {
  # Bind this to the main canvas as statusbar can now be hidden
  bind .main.board.bd <Map> { raiseAllWindows }
  bind .main.board.bd <Unmap> { showHideAllWindows iconify}
}

# showHideAllWindows:
#   Arranges for all major Scid windows to be shown/hidden
#   type = "iconify" or "deiconify"

proc showHideAllWindows {type} {
  if {! $::autoIconify} { return }

  # Some window managers like KDE generate Unmap events for other
  # situations like switching to another desktop, etc.
  # So if the main window is still mapped, do not iconify others:

  if {($type == "iconify")  && ([winfo ismapped .] == 1)} { return }

  foreach w [getTopLevel $type] {
    if {[winfo exists $w] && $w != ".main"} { catch {wm $type $w} }
  }
}

proc raiseAllWindows {{force 0}} {
  if {! $::autoRaise && !$force} { return }

  foreach w [getTopLevel deiconify] {
    if {[winfo exists $w]} {
      catch {
	wm deiconify $w
	raise $w
      }
    }
  }
  # raise .
  # Treat .splash differently as it is persistant
  if {[winfo ismapped .splash]} {
    raise .splash
  }
  
}

### Scid main windows are below, but we use [winfo children .] to gather info
#   .baseWin .glistWin .pgnWin .tourney .maintWin \
#   .ecograph .crosstabWin .treeWin .analysisWin1 .anslysisWin2 \
#   .playerInfoWin .commentWin .repWin .statsWin .tbWin \
#   .sb .sh .sm .noveltyWin .emailWin .oprepWin .plist \
#   .rgraph .sgraph .importWin .helpWin .tipsWin .comp

### Return a list of all toplevels, except some utilities

proc getTopLevel {{type {}}} {

  set topl {}
  set exclude {.splash .tooltip .glistExtra .menu . .pgnPopup .ctxtMenu}
  foreach c [winfo children .] {
    if { $c != [winfo toplevel $c] } { continue }
    # Tk report .__tk_filedialog as toplevel window even if the window has been closed
    if { [ lsearch $topl $c ] == -1 && [ lsearch $exclude $c ] == -1 && ![string match "\.__tk*" $c] } {
      ### Dont deiconify analysis widgets if tournament is running, or engine1 is in docked mode
      if {!($type == "deiconify" && [winfo exists .comp] && [string match .analysisWin* $c]) &&
          ($c != ".analysisWin1" || !$::analysis(mini))} {
	  lappend topl $c
      }
    }
  }

  ### Place .glistWin, .pgnWin last so raiseAllWindows places them on top. Side effects ?

  foreach win {.pgnWin .glistWin .analysisWin*}  {
    set pos [lsearch $topl $win]
    set win [lindex $topl $pos] ; #defrefence globbing for analysisWinN
    if {$pos >=0} {
      set topl [lreplace $topl $pos $pos]
      lappend topl $win
    }
  }
  return $topl
}

### Hack to extract gif images out of Scid

proc dumpImagesBase64 {dir} {
  puts "Dumping images as base64 to $dir"
  package require base64
  file mkdir $dir
  set images [image names]
  puts "dumpImagesBase64: found images $images"

  foreach i $images {
    set data [string trim [$i cget -data]]
    if {$data == ""} { continue }
    if {[catch {set d [::base64::decode $data]}]} { continue }
    regsub -all {:} $i {_} i
    set fname [file join $dir $i.gif]
  puts "Dumping image $i into file $fname"
    set f [open $fname w]
    fconfigure $f -translation binary -encoding binary
    puts -nonewline $f $d
    close $f
  }
}

proc dumpImages {dir} {
  puts "Dumping images to $dir"
  file mkdir $dir
  set images [image names]
  puts "dumpImagesGif: found images $images"
  foreach i $images {
    if {$::windowsOS} {
      # windows doesnt like stray ':' in filenames
      set fname [file join $dir [string map {:: _} $i].gif]
    } else {
      set fname [file join $dir $i.gif]
    }
    if {[catch {$i write $fname -format gif}]} {
      file delete $fname
      if {$::windowsOS} {
        set fname [file join $dir [string map {:: _} $i].png]
      } else {
        set fname [file join $dir $i.png]
      }
      if {[catch {
        $i write $fname -format png
      } message]} {
        puts "$i write throws error '$message'"
      }
    }
  }
}

# hmm... Control-Shift-F7 doesn't work for me ???
bind .main <Control-Shift-F7> {
    dumpImagesBase64 [file join $::env(HOME) ScidImages64]
}

bind .main <Control-Shift-F8> {
    dumpImages [file join $::env(HOME) ScidImages]
}

# Opening files by drag & drop on Scid icon on Mac
# Todo: implement for Windows and Linux (haha!)

if {$::macOS} {
  # We opened for a drag & drop request, process it now:
  set isopenBaseready 1
  if {$dndargs != 0} {
    set isopenBaseready 2
    catch {::tk::mac::OpenDocument $dndargs} errmsg
    #::splash::add "Opening file(s)...\$dndargs"    
  }
}


wm protocol $dot_w WM_DELETE_WINDOW { ::file::Exit }

# wm focusmodel . active
# Trying to grab focus from the windowmanager after a drop event, but this doesnt work

proc initDragDrop {} {
  after idle { RegisterDropEvents .main.gameInfoFrame }
  after idle { RegisterDropEvents .main.gameInfo }
  after idle { RegisterDropEvents .main.board.bd}
}

if { $::docking::USE_DOCKING } {
  setTitle .main [ ::tr "Board" ]
  # restore geometry
  wm minsize $dot_w 360 320
  setWinLocation $dot_w
  setWinSize $dot_w

  # when main board pane is resized, auto-size it
  bind .main <Configure> { ::docking::handleConfigureEvent %W }

  if { $::autoLoadLayout } {
    ::docking::layout_restore 1
  } else {
    # Hack to use default layout without altering anything
    set ::docking::layout_list(0) {{MainWindowGeometry 834x640+80+50} {{.pw vertical {}} {TPanedwindow {{.pw.pw0 horizontal 564} {TNotebook .nb .fdockmain} {TNotebook .tb1 .fdockpgnWin}}}}}
    ::docking::layout_restore 0
  }

  standardShortcuts TNotebook

  if {!$macOS} {
    ### Must be done after the toplevel window has been mapped.
    #  bind . <Map> ..... doesn't work on MS Windows
    after idle {
      initDragDrop
      if {[tk windowingsystem] eq "x11"} {
	### This wrapper is required for GNOME support. It supplies
	### a wrapper window for the dnd handling, because the GNOME
	### handling will be confused by embedded top level windows.
	after idle { ::tkdnd::xdnd::registerWrapper . }
      }
    }
  }
} else {
  setWinLocation $dot_w
  initDragDrop
}

wm deiconify $dot_w
focus .main

### Raise pgn import window if open
if {[winfo exists .ipgnWin]} {
  raiseWin .ipgnWin
}

.splash.t yview moveto 0
if {$::splash::keepopen} {
  after 100 {raiseWin .splash}
} else {
  after 500 { wm withdraw .splash }
}

# Init start-up windows

if { $::docking::USE_DOCKING } {
  # In docked mode, reopen only the windows that are not dockable
  set startup_windows {
    stats      ::windows::stats::Open
    crosstable ::crosstab::Open
    finder     ::file::finder::Open
    book       ::book::Open
    fics       ::fics::config
    tip		::tip::show
  }
} else {
  set startup_windows {
    switcher   ::windows::switcher::Open
    pgn        ::pgn::Open
    gamelist   ::windows::gamelist::Open
    tree       ::tree::Open
    stats      ::windows::stats::Open
    crosstable ::crosstab::Open
    finder     ::file::finder::Open
    book       ::book::Open
    tip		::tip::show
  }
}
foreach {type action} $startup_windows {
  if {$startup($type)} {
    $action
  }
}

### End of file: end.tcl
