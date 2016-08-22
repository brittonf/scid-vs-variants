### tree.tcl

### (C) 2007 Pascal Georges : multiple Tree windows support
### Originally authored by Shane Hudson. All Mask features by Pascal Georges [S.A.]

### Three coloured bar graphs , mask fixes and other code by Stevenaaus

set ::tree::trainingBase 0
array set ::tree::cachesize {}

proc ::tree::doConfigMenus { baseNumber  { lang "" } } {
  if {! [winfo exists .treeWin$baseNumber]} { return }
  if {$lang == ""} { set lang $::language }
  set m .treeWin$baseNumber.menu
  foreach idx {0 1 2 3 4} tag {File Mask Sort Opt Help} {
    configMenuText $m $idx Tree$tag $lang
  }
  foreach idx {0 1 2 3 4 5 7 9 11} tag {Save Fill FillWithBase FillWithGame SetCacheSize CacheInfo Best Copy Close} {
    configMenuText $m.file $idx TreeFile$tag $lang
  }
  foreach idx {0 1 2 3 4 6 7 8 9 10 11} tag {New Open OpenRecent Save Close FillWithLine FillWithGame FillWithBase Search Info Display} {
    configMenuText $m.mask $idx TreeMask$tag $lang
  }
  foreach idx {0 1 2 3} tag {Alpha ECO Freq Score } {
    configMenuText $m.sort $idx TreeSort$tag $lang
  }
  foreach idx {0 1 3 4 5 6 7 9 10 11} tag {Lock Training SortBest Short ShowBar Automask Autosave Slowmode Fastmode FastAndSlowmode} {
    configMenuText $m.opt $idx TreeOpt$tag $lang
  }
  foreach idx {0 1} tag {Tree Index} {
    configMenuText $m.help $idx TreeHelp$tag $lang
  }
}


proc ::tree::ConfigMenus { { lang "" } } {
  for {set i 1 } {$i <= [sc_base count total]} {incr i} {
    ::tree::doConfigMenus $i $lang
  }
}

proc ::tree::menuCopyToSelection { baseNumber } {
  setClipboard [.treeWin$baseNumber.f.tl get 1.0 end]
}

proc ::tree::treeFileSave {base} {
  if {[catch {sc_tree write $base} result]} {
    tk_messageBox -type ok -icon warning -title "Scid: Error writing file" -message $result -parent .treeWin$base
  }
}

proc ::tree::Open {{baseNumber 0}} {
  global tree helpMessage

  if {!$baseNumber} {
    set baseNumber [sc_base current]
  }
  set w .treeWin$baseNumber

  if {[winfo exists $w]} {
    raiseWin $w
    return
  }

  ::createToplevel $w
  setWinLocation $w
  setWinSize $w

  ::setTitle $w "[lindex "[tr WindowsTree]" 0] \[[file tail [sc_base filename $baseNumber]]\]"

  set tree(base$baseNumber) $baseNumber
  if {$::tree::sortBest} {
    set tree(sortBest$baseNumber) Best
  } else {
    set tree(sortBest$baseNumber) Order
  }
  ### The number of bestgames to display is not configurable anymore (except here) S.A.
  foreach {i j} {
    training	0
    autorefresh	1
    locked	0
    status	""
    adjustfilter 0
    bestMax	100 
    order	frequency
    bestRes	All
  } {
   set tree($i$baseNumber) $j
  }
  trace variable tree(bestMax$baseNumber) w "::tree::doTrace bestMax"
  trace variable tree(bestRes$baseNumber) w "::tree::doTrace bestRes"
  trace variable tree(sortBest$baseNumber) w "::tree::doTrace sortBest"

  ### todo: fix this properly
  # Destroy is handled by "bind $w.f.tl <Destroy>"
  # as $w.f.tl.g (bar graph in text window) is generating Destroy(s)

  bind $w <F1> {helpWindow Tree}
  bind $w <Escape> "
     if {!\[::tree::hideCtxtMenu $baseNumber\]} {
      $w.buttons.close invoke
     }"

  # Bind left button to close ctxt menu:
  bind $w <ButtonPress-1> "::tree::hideCtxtMenu $baseNumber"
  bindWheeltoFixed $w

  standardShortcuts $w

  menu $w.menu
  ::setMenu $w $w.menu
  $w.menu add cascade -label TreeFile -menu $w.menu.file
  $w.menu add cascade -label TreeMask -menu $w.menu.mask
  $w.menu add cascade -label TreeSort -menu $w.menu.sort
  $w.menu add cascade -label TreeOpt  -menu $w.menu.opt
  $w.menu add cascade -label TreeHelp -menu $w.menu.help
  foreach i {file mask sort opt help} {
    menu $w.menu.$i -tearoff 0
  }

  $w.menu.file add command -label TreeFileSave -command "::tree::treeFileSave $baseNumber"
  $w.menu.file add command -label TreeFileFill -command "::tree::prime $baseNumber"
  $w.menu.file add command -label TreeFileFillWithBase -command "::tree::primeWithBase $baseNumber"
  $w.menu.file add command -label TreeFileFillWithGame -command "::tree::primeWithGame"

  menu $w.menu.file.size
  foreach i { 250 500 1000 2000 5000 10000 } {
    $w.menu.file.size add radiobutton -label "$i" -value $i -variable ::tree::cachesize($baseNumber) -command "::tree::setCacheSize $baseNumber $i"
  }

  $w.menu.file add cascade -menu $w.menu.file.size -label TreeFileSetCacheSize
  $w.menu.file add command -label TreeFileCacheInfo -command "::tree::getCacheInfo $baseNumber"

  $w.menu.file add separator

  $w.menu.file add command -label TreeFileBest -command "::tree::best $baseNumber"

  $w.menu.file add separator

  $w.menu.file add command -label TreeFileCopy -command "::tree::menuCopyToSelection $baseNumber"

  $w.menu.file add separator

  $w.menu.file add command -label TreeFileClose -command ".treeWin$baseNumber.buttons.close invoke"
  $w.menu.mask add command -label TreeMaskNew -command "::tree::mask::new $w"
  $w.menu.mask add command -label TreeMaskOpen -command "::tree::mask::open {} $w"

  menu $w.menu.mask.recent
  foreach f $::tree::mask::recentMask {
    $w.menu.mask.recent add command -label $f -command [list ::tree::mask::open $f $w]
  }
  $w.menu.mask add cascade -label TreeMaskOpenRecent -menu $w.menu.mask.recent
  $w.menu.mask add command -label TreeMaskSave -command "::tree::mask::save"
  $w.menu.mask add command -label TreeMaskClose -command "::tree::mask::close $w"
  $w.menu.mask add separator
  $w.menu.mask add command -label TreeMaskFillWithLine -command "::tree::mask::fillWithLine"
  $w.menu.mask add command -label TreeMaskFillWithGame -command "::tree::mask::fillWithGame"
  $w.menu.mask add command -label TreeMaskFillWithBase -command "::tree::mask::fillWithBase $baseNumber"
  $w.menu.mask add command -label TreeMaskSearch -command "::tree::mask::searchMask $baseNumber"
  $w.menu.mask add command -label TreeMaskInfo -command "::tree::mask::infoMask $w"
  $w.menu.mask add command -label TreeMaskDisplay -command "::tree::mask::displayMask"
  $w.menu.mask add command -label Help -command {helpWindow TreeMasks}

  foreach {label value} {
    Alpha alpha
    ECO   eco
    Freq  frequency
    Score score
  } {
    $w.menu.sort add radiobutton -label TreeSort$label \
        -variable tree(order$baseNumber) -value $value -command " ::tree::refresh $baseNumber "
  }

  $w.menu.opt add checkbutton -label TreeOptLock -variable tree(locked$baseNumber) \
      -command "::tree::toggleLock $baseNumber"
  $w.menu.opt add checkbutton -label TreeOptTraining -variable tree(training$baseNumber) -command "::tree::refreshTraining $baseNumber"
  $w.menu.opt add separator
  $w.menu.opt add checkbutton -label TreeOptSortBest -variable ::tree::sortBest
  $w.menu.opt add checkbutton -label TreeOptShort   -variable ::tree::short   -command ::tree::refresh
  $w.menu.opt add checkbutton -label TreeOptShowBar -variable ::tree::showBar -command {
    for {set i 1} {$i <= [sc_base count total]} {incr i} {
      if {[winfo exists .treeWin$i]} {
	set w .treeWin$i
	if {$::tree::showBar} {
	  pack $w.progress -side bottom -before $w.f
	} else {
	  pack forget $w.progress
	}
      }
    }
  }
  $w.menu.opt add checkbutton -label TreeOptAutomask -variable ::tree::mask::autoLoadMask
  $w.menu.opt add checkbutton -label TreeOptAutosave -variable tree(autoSave$baseNumber)

  $w.menu.opt add separator

  $w.menu.opt add radiobutton -label TreeOptSlowmode -value 0 -variable tree(fastmode$baseNumber)
  $w.menu.opt add radiobutton -label TreeOptFastmode -value 1 -variable tree(fastmode$baseNumber)
  $w.menu.opt add radiobutton -label TreeOptFastAndSlowmode -value 2 -variable tree(fastmode$baseNumber)
  set tree(fastmode$baseNumber) 0
  $w.menu.help add command -label TreeHelpTree -accelerator F1 -command {helpWindow Tree}
  $w.menu.help add command -label TreeHelpIndex -command {helpWindow Index}

  ::tree::doConfigMenus $baseNumber

  # Main move widget
  autoscrollframe $w.f text $w.f.tl -wrap none -font font_Fixed -setgrid 1 -exportselection 1 -height 5

  # default tags
  $w.f.tl tag configure greybg -background #fa1cfa1cfa1c
  $w.f.tl tag configure whitebg 
  $w.f.tl tag configure bluefg -foreground blue
  $w.f.tl tag configure movefg -foreground purple2
  $w.f.tl tag configure nextmove -background $::rowcolor
  #   $w.f.tl tag configure nextmove -foreground seagreen3

  canvas $w.progress -width 250 -height 15  -relief solid -border 1
  $w.progress create rectangle 0 0 0 0 -fill $::progcolor -outline $::progcolor -tags bar
  selection handle $w.f.tl "::tree::copyToSelection $baseNumber"

  bind $w.f.tl <Destroy> {
    set basenum ""
    set win [winfo toplevel %W]
    scan $win .treeWin%%d basenum
    if {[string is integer -strict $basenum]} {
      ::tree::closeTree $tree(base$basenum)
    }
    if {[winfo exists $win.ctxtMenu]} {destroy $win.ctxtMenu}
    if {[winfo exists .tooltip]} {wm withdraw .tooltip}
  }

  bind $w <Configure> "recordWinSize $w"

  ### Tree statusbar now unused
  # label $w.status -width 1 -anchor w -font font_Small -relief sunken -textvar tree(status$baseNumber)
  # pack $w.status -side bottom -fill x

  pack [frame $w.buttons -relief sunken] -side bottom -fill x -pady 5
  if {$::tree::showBar} {
    pack $w.progress -side bottom
  }
  pack $w.f -side top -expand 1 -fill both

  button $w.buttons.best -image b_list -command "::tree::toggleBest $baseNumber"
  ::utils::tooltip::Set $w.buttons.best [tr TreeFileBest]

  button $w.buttons.training -image tb_training -command "::tree::toggleTraining $baseNumber"
  ::utils::tooltip::Set $w.buttons.training [tr TreeOptTraining]

  button $w.buttons.short -image tb_info -command "$w.menu.opt invoke 4" ; # TreeOptShort
  ::utils::tooltip::Set $w.buttons.short [tr TreeOptShort]

  set helpMessage($w.buttons.best) TreeFileBest
  set helpMessage($w.buttons.training) TreeOptTraining
  set helpMessage($w.buttons.short) TreeOptTraining

  checkbutton $w.buttons.refresh -text [tr FICSRefresh] -font font_Small \
      -variable tree(autorefresh$baseNumber) -command "::tree::toggleRefresh $baseNumber" 
  checkbutton $w.buttons.adjust -text [tr TreeAdjust] -font font_Small \
      -variable tree(adjustfilter$baseNumber) -command "::tree::toggleAdjust $baseNumber"

  button $w.buttons.close -textvar ::tr(Close) -font font_Small -command "destroy $w"

  pack $w.buttons.best $w.buttons.training $w.buttons.short $w.buttons.refresh $w.buttons.adjust -side left -padx 1

  pack $w.buttons.close -side right -padx 3

  wm minsize $w 40 5

  ### Now caught by <Destroy> above
  # wm protocol $w WM_DELETE_WINDOW ".treeWin$baseNumber.buttons.close invoke"

  ### Autoload Mask if desired
  set mask [lindex $::tree::mask::recentMask 0]
  if {$::tree::mask::autoLoadMask && $::tree::mask::maskFile == {} && $mask != {}} {
    # Using 'autoLoad' for parent, skips interactive error dialog
    ::tree::mask::open $mask autoLoad
  } else {
    ::tree::refresh $baseNumber
  }
  set ::tree::cachesize($baseNumber) [lindex [sc_tree cacheinfo $baseNumber] 1]
}

################################################################################
proc ::tree::hideCtxtMenu { baseNumber } {
  set w .treeWin$baseNumber.f.tl.ctxtMenu
  if {[winfo exists $w]} {
    destroy $w
    focus .treeWin$baseNumber
    return 1
  } else {
    return 0
  }
}
################################################################################
proc ::tree::selectCallback { baseNumber move } {

  if { $::tree(refresh) } {
    return
  }

  if {$::tree(autorefresh$baseNumber)} {
    tree::select $move $baseNumber
  }
}


proc ::tree::closeTree {baseNumber} {
  global tree
  wm protocol .treeWin$baseNumber WM_DELETE_WINDOW {}
  sc_tree search -cancel all

  # Hack to stop rare coredump (closing tree2 when base2 is not open and base1 is)
  if {![sc_base inUse $baseNumber]} {
    sc_base switch clipbase
  }
  ::tree::mask::close .treeWin$baseNumber
  # needs closing explicitly if based open as tree and bestgames is open
  if {[winfo exists .treeBest$baseNumber]} {
    destroy .treeBest$baseNumber
  }

  ::tree::hideCtxtMenu $baseNumber

  # reset progress bar ?
  sc_progressBar

  trace remove variable tree(bestMax$baseNumber) write "::tree::doTrace bestMax"
  trace remove variable tree(bestRes$baseNumber) write "::tree::doTrace bestRes"
  trace remove variable tree(sortBest$baseNumber) write "::tree::doTrace sortBest"

  set ::geometry(treeWin$baseNumber) [wm geometry .treeWin$baseNumber]
  focus .main

  if {$tree(autoSave$baseNumber)} {
    busyCursor .
    catch { sc_tree write $tree(base$baseNumber) } ; # necessary as it will be triggered twice
    unbusyCursor .
  }

  sc_tree clean $baseNumber
  if {$::tree(locked$baseNumber)} {
    ::file::Close $baseNumber
  }

  ::docking::cleanup .treeWin$baseNumber

  ### Implicit
  # destroy .treeWin$baseNumber

  # Hack to stop another unusual coredump.
  # (Save game in clipbase with tree1 open but base1 not in use. Close tree)
  after idle {
    ::windows::gamelist::Refresh
    ::windows::stats::Refresh
  }
}

################################################################################
proc ::tree::doTrace { prefix name1 name2 op} {
  if {[scan $name2 "$prefix%d" baseNumber] !=1 } {
    tk_messageBox -parent . -icon error -type ok -title "Fatal Error" \
        -message "Scan failed in trace code\ndoTrace $prefix $name1 $name2 $op"
    return
  }
  if {[winfo exists .treeBest$baseNumber]} {
    ::tree::best $baseNumber
  }
}

proc ::tree::toggleTraining { baseNumber } {
  global tree
  set tree(training$baseNumber) [expr !$tree(training$baseNumber)]
  ::tree::refreshTraining $baseNumber
}

proc ::tree::refreshTraining { baseNumber } {
  global tree

  # Only one tree training used at a time
  for {set i 1 } {$i <= [sc_base count total]} {incr i} {
    if {! [winfo exists .treeWin$baseNumber] || $i == $baseNumber } { continue }
    set tree(training$i) 0
  }

  if {$tree(training$baseNumber)} {
    set ::tree::trainingBase $baseNumber
  } else {
    set ::tree::trainingBase 0
  }
  ::tree::refresh $baseNumber
}

################################################################################

### This proc is used by the training features in TREE , ANALYSIS ENGINES, and TABLEBASE
### and isn't exclusive to the tree at all
### The engine training only works with engines 1 and 2 (not 0, 3, 4, 5 etc)
### and tablebase and tree training may well be the same &&&
### ... Bit of a fucking undocumented hack mess actually

proc ::tree::doTraining {{n 0}} {
  global tree

  # uses engines 1 and 2 (todo: make work with all engines)
  if {$n != 1  &&  [winfo exists .analysisWin1]  &&  $::analysis(automove1)} {
    automove 1
    return
  }
  if {$n != 2  &&  [winfo exists .analysisWin2]  &&  $::analysis(automove2)} {
    automove 2
    return
  }
  if {[::tb::isopen]  &&  $::tbTraining} {
    ::tb::move
    return
  }

  if {! [winfo exists .treeWin$::tree::trainingBase]} {
    return
  }

  if { $::tree::trainingBase == 0 } {
    return
  }

  # Before issuing a training move, annotate player's move
  if { $::tree::mask::maskFile != ""  } {
    set move_done [sc_game info previousMoveNT]
    if {$move_done != ""} {
      sc_move back
      set fen [ ::tree::mask::toShortFen [sc_pos fen] ]
      sc_move forward
      if { [info exists ::tree::mask::mask($fen)] } {
        set moves [ lindex $::tree::mask::mask($fen) 0 ]
        
        # if move out of Mask, and there exists moves in Mask, set a warning
        if { ! [ ::tree::mask::moveExists $move_done $fen ] } {
          if {[llength $moves] != 0} {
            set txt ""
            foreach elt $moves {
              append txt "[::trans [lindex $elt 0]][lindex $elt 1] "
            }
            sc_pos setComment "[sc_pos getComment] Mask : $txt"
          }
        }
        
        # if move was bad, set a warning
        set nag_played [::tree::mask::getNag $move_done $fen]
        set nag_order { "??" " ?" "?!" $::tree::mask::emptyNag "!?" " !" "!!"}
        set txt ""
        foreach elt $moves {
          set N [lindex $elt 1]
          if { [lsearch $nag_order $nag_played] < [lsearch $nag_order $N]} {
            append txt "[::trans [lindex $elt 0]][lindex $elt 1] "
          }
        }
        if {$txt != ""} {
          sc_pos addNag [string trim $nag_played]
          sc_pos setComment "[sc_pos getComment] Mask : $txt"
        }
        
        # if move was on an exclude line, set a warning (img = ::rep::_tb_exclude)
        if { [::tree::mask::getImage $move_done 0] ==  "::rep::_tb_exclude" || \
              [::tree::mask::getImage $move_done 1] == "::rep::_tb_exclude"} {
          sc_pos setComment "[sc_pos getComment] Mask : excluded line"
        }
      }
    }
  }

  # Must flush tree before calling sc_tree move 
  # is this correct ?
  update idletasks

  set move [sc_tree move $::tree::trainingBase random]
  addSanMove $move -animate -notraining
  updateBoard -pgn
}

proc ::tree::toggleLock { baseNumber } {
  ::tree::refresh $baseNumber
}

proc ::tree::select { move baseNumber } {
  global tree

  if {! [winfo exists .treeWin$baseNumber]} { return }

  catch { addSanMove $move -animate }
}

set tree(refresh) 0

################################################################################

proc ::tree::refresh {{ baseNumber {} }} {

  # set stack [lsearch -glob -inline -all [ wm stackorder . ] ".treeWin*"]
  if {$baseNumber != {} } {
    if {[winfo exists .treeWin$baseNumber]} {
      ::tree::dorefresh $baseNumber
    }
  } else {
    sc_tree search -cancel all
    set count [sc_base count total]
    if {!$::tree::showBar} {
      # disable tree text
      for {set i 1} {$i <= $count} {incr i} {
	if {[winfo exists .treeWin$i]} {
	  .treeWin$i.f.tl tag configure treetext -foreground grey
	}
      }
    }
    for {set i 1} {$i <= $count} {incr i} {
      if {[winfo exists .treeWin$i]} {
        if { [::tree::dorefresh $i] == "canceled" } { break }
      }
    }
  }
}

proc ::tree::dorefresh { baseNumber } {

  global tree glstart glistSize
  set w .treeWin$baseNumber

  if { ! $tree(autorefresh$baseNumber) || $::annotate(Engine) > -1 || $::comp(playing)} {
    return
  }

  # busyCursor .
  sc_progressBar $w.progress bar 251 16

  set tree(refresh) 1

  update idletasks

  if { $tree(fastmode$baseNumber) == 0 } {
    set fastmode 0
  } else {
    set fastmode 1
  }

  set moves [sc_tree search -hide $tree(training$baseNumber) -sort $tree(order$baseNumber) -base $baseNumber \
                            -fastmode $fastmode -adjust $tree(adjustfilter$baseNumber) -short $::tree::short]

  # Tree can be closed in the middle of a search now
  if {![winfo exists $w]} { return }

  catch {$w.f.tl itemconfigure 0 -foreground darkBlue}

  if {!$::tree::showBar} {
    # enable tree
    $w.f.tl tag configure treetext -foreground black
  }

  # unbusyCursor .
  set tree(refresh) 0

  $w.f.tl configure -cursor {}

  # ::tree::status "" $baseNumber
  if {$::tree(adjustfilter$baseNumber)} {
    ::windows::stats::Refresh
    ### See the last game (bind $w <End> from gamelist.tcl)
    set totalSize [sc_filter count]
    set glstart $totalSize
    set lastEntry [expr $totalSize - $glistSize]
    if {$lastEntry < 1} {
      set lastEntry 1
    }
    if {$glstart > $lastEntry} {
      set glstart $lastEntry
    }
    ::windows::gamelist::Refresh last
  }

  # Only the most recent tree_search succeeds
  if { $moves == "canceled" } { return "canceled"}
  displayLines $baseNumber $moves

  if {[winfo exists .treeBest$baseNumber]} {::tree::best $baseNumber}

  # ========================================
  if { $tree(fastmode$baseNumber) == 2 } {
    # ::tree::status "" $baseNumber
    sc_progressBar $w.progress bar 251 16
    set moves [sc_tree search -hide $tree(training$baseNumber) -sort $tree(order$baseNumber) -base $baseNumber -fastmode 0]
    ### todo: should we have "-adjust $tree(adjustfilter$baseNumber)"  here ?

    displayLines $baseNumber $moves
  }
  # ========================================
}

### Insert lines into the tree widget S.A.

proc ::tree::displayLines { baseNumber moves } {
  global ::tree::mask::maskFile

  set ::tree::mask::cacheFenIndex [::tree::mask::toShortFen [sc_pos fen]]
  set lMoves {}
  set w .treeWin$baseNumber
  set nextmove [sc_game info nextMove]

  $w.f.tl configure -state normal
  $w.f.tl delete 1.0 end

  if {$moves == "interrupted"} {
    $w.f.tl insert end $::tr(ErrSearchInterrupted)
    return
  }
  set notOpen [expr {$moves == $::tr(ErrNotOpen)}]
  set moves [split $moves "\n"]
  set len [llength $moves]

  if {$notOpen} {
    $w.f.tl insert 0.0 "[lindex $moves 0]\n"
    $w.f.tl configure -state disabled
    return
  }

  foreach t [$w.f.tl tag names] {
    if { [ string match "tagclick*" $t ] || [ string match "tagtooltip*" $t ] } {
      $w.f.tl tag delete $t
    }
  }

  # (Single) Mask position comment at top of move list
  # Making this line word wrap is too hard because it's tough to get the text widget's true width
  set hasPositionComment 0
  if { $maskFile != "" } {
    set posComment [::tree::mask::getPositionComment]
    if {$posComment != ""} {
      set hasPositionComment 1
      set firstLine [ lindex [split $posComment "\n"] 0 ]
      $w.f.tl insert end "$firstLine\n" [ list bluefg tagtooltip_poscomment ]
      ::utils::tooltip::SetTag $w.f.tl $posComment tagtooltip_poscomment
      $w.f.tl tag bind tagtooltip_poscomment <Double-Button-1> "::tree::mask::addComment {} $w"
      # Background colour ??
      # $w.f.tl tag configure tagtooltip_poscomment -background lightskyblue
    }
  }

  # Display the line with column headings
  if { $maskFile != "" } {
    # insert 2 blank images and 4 blank space
    foreach j { 0 1 } {
      $w.f.tl image create end -image ::tree::mask::emptyImage -align center
    }
    $w.f.tl insert end "    "
  }

  $w.f.tl insert end "[lindex $moves 0]\n" treetext
  # blank bargraph in title
  if {$::tree::short} {
    set padding [expr [string length [lrange $::tr(TreeTitleRowShort) 2 end]] + 5]
  } else {
    set padding [expr [string length [lrange $::tr(TreeTitleRow) 2 end]] + 5]
  }
  $w.f.tl window create end-${padding}c -create "canvas %W.g -width 60 -height 12 -highlightthickness 0"

  ### Hmmm - some of the markers (images) might be 17 or 18 width, and they make the
  ### bargraph stick out a little. todo - resize all markers to 16
  
  ### Main Display the lines of the tree

  for { set i 1 } { $i < [expr $len - 3 ] } { incr i } {
    set line [lindex $moves $i]
    if {$line == ""} { continue }
    set move [::untrans [lindex $line 1]]
    lappend lMoves $move

    set tagfg {}

    if { $maskFile != "" && $i > 0 && $i < [expr $len - 3] } {
      if { [::tree::mask::moveExists $move] } {
        set tagfg movefg
      }
    }
    if { $maskFile != "" } {
      if { $i > 0 && $i < [expr $len - 3] && $move != "\[end\]" } {
        # images
        foreach j { 0 1 } {
          set img [::tree::mask::getImage $move $j]
          if {[catch {
	    $w.f.tl image create end -image $img -align center
          }]} {
            $w.f.tl image create end -image ::tree::mask::emptyImage -align center
          }
        }
        # color tag
        set color [::tree::mask::getColor $move]
        if {$color != "white" && $color != "White"} {
          $w.f.tl tag configure color$i -background [::tree::mask::getColor $move]
          $w.f.tl insert end "  " color$i
        } else {
          # disabling color here kind-of depends on getColor returning {white} when it *should* return {White}
          $w.f.tl insert end "  " 
        }
        # NAG tag
        $w.f.tl insert end [::tree::mask::getNag $move]
      } else  {
        $w.f.tl image create end -image ::tree::mask::emptyImage -align center
        $w.f.tl image create end -image ::tree::mask::emptyImage -align center
        $w.f.tl insert end "    "
      }
    }

    # Move and stats
    set tags [list treetext $tagfg tagclick$i tagtooltip$i]

    # Should we add a tag for the Next Move ???
    if {$move == $nextmove} {
      lappend tags nextmove
    }

    # Colour every second line grey
    # if {$i % 2 && $i < $len - 3} { lappend tags greybg } else  { lappend tags whitebg }

    $w.f.tl insert end $line $tags

    ### In each line create a canvas for a little tri-coloured bargraph

    scan [string range $line 26 30] "%f%%" success
    scan [string range $line 32 35] "%f%%" draw
    set wonx  [expr {($success - $draw/2)*0.6 + 1}] ; # win = success - drawn/2
    set lossx [expr {($success + $draw/2)*0.6 + 1}] ; # loss = 100 - win - drawn
    
    if {$::tree::short} {
      $w.f.tl window create end-13c -create [list createCanvas %W.g$i $wonx $lossx $baseNumber $move]
    } else {
      $w.f.tl window create end-37c -create [list createCanvas %W.g$i $wonx $lossx $baseNumber $move]
    }

    ### Mouse bindings

    if {$move != {} && $move != {---} && $move != {[end]} && $i != $len-2 && $i != 0} {
      $w.f.tl tag bind tagclick$i <Button-1> "::tree::selectCallback $baseNumber $move ; break"
      if { $maskFile != {}} {
        ### Bind right button to popup a contextual menu
        # todo: Only display full menu if move is in mask
        $w.f.tl tag bind tagclick$i <ButtonPress-3> "::tree::mask::contextMenu 0 $w.f.tl $move %x %y %X %Y"
        $w.f.tl tag bind tagclick$i <Control-ButtonPress-3> "::tree::mask::contextMenu 1 $w.f.tl $move %x %y %X %Y"
      }
    }

    set commentLength 0
    if { $maskFile != "" } {
      # Move comment
      set comment [::tree::mask::getComment $move]
      if {$comment != ""} {
	set commentLength [string length $comment]
        set firstLine [ lindex [split $comment "\n"] 0 ]
        $w.f.tl insert end " $firstLine" tagtooltip$i
        ::utils::tooltip::SetTag $w.f.tl $comment tagtooltip$i
        # Actually its impossible to double click tooltips now, so this is unused
        $w.f.tl tag bind tagtooltip$i <Double-Button-1> "::tree::mask::op addComment 0 $move $w"
      }
    }
    # This line extends tags to marker1,2
    # But dont extend line bindings to comment, as it overrides double-click sets comment
    $w.f.tl tag add tagclick$i [expr $i +1 + $hasPositionComment].0 "[expr $i + 1 + $hasPositionComment].end - $commentLength chars"
    
    $w.f.tl insert end "\n"
  } ;# end for loop
 
  if {$lMoves != {}} {

  # Display the last two lines  - hypens and total
  for { set i [expr $len - 3 ] } { $i < [expr $len - 1 ] } { incr i } {
    if { $maskFile != "" } {
      $w.f.tl image create end -image ::tree::mask::emptyImage -align center
      $w.f.tl image create end -image ::tree::mask::emptyImage -align center
      $w.f.tl insert end "    "
    }
    $w.f.tl insert end "[lindex $moves $i]\n" treetext
  }

  # blank bargraph in total
  if {$::tree::short} {
    $w.f.tl window create end-13c -create "canvas %W.h -width 60 -height 12 -highlightthickness 0"
  } else {
    $w.f.tl window create end-32c -create "canvas %W.h -width 60 -height 12 -highlightthickness 0"
  }

  }

  ### Add moves present in Mask and not in Tree

  set idx $len
  if { $maskFile != "" } {
    set movesMask [::tree::mask::getAllMoves]
    foreach m $movesMask {
      if {  [ scan [$w.f.tl index end] "%d.%d" currentLine dummy] != 2 } {
        puts "ERROR scan index end [$w.f.tl index end]"
      }
      #  move nag color  comment        marker1_image      marker2_image
      #  d4    {} white {Some comment.} ::rep::_tb_exclude ::tree::mask::imageMainLine

      set maskmove [lindex $m 0]

      if {$maskmove in $lMoves || $maskmove == "null"} {
        continue
      }
      
      $w.f.tl tag bind tagclick$idx <Button-1> "[list ::tree::selectCallback $baseNumber $maskmove] ; break"
      $w.f.tl tag bind tagclick$idx <ButtonPress-3> "::tree::mask::contextMenu 0 $w.f.tl $maskmove %x %y %X %Y"
      $w.f.tl tag bind tagclick$idx <Control-ButtonPress-3> "::tree::mask::contextMenu 1 $w.f.tl $maskmove %x %y %X %Y"

      # Markers
      foreach j {4 5} {
        if {[lindex $m $j] == ""} {
          $w.f.tl image create end -image ::tree::mask::emptyImage -align center
        } else  {
          if {[catch {
	    $w.f.tl image create end -image [lindex $m $j] -align center
          }]} {
	    $w.f.tl image create end -image ::tree::mask::emptyImage -align center
          }
        }
      }
      
      # color tag
      set color [lindex $m 2]
      if {$color != "white" && $color != "White"} {
	$w.f.tl tag configure color$idx -background $color
	$w.f.tl insert end "  " [ list color$idx tagclick$idx ]
      } else {
	$w.f.tl insert end "  " tagclick$idx
      }


      # NAG tag
      $w.f.tl insert end [::tree::mask::getNag $maskmove] tagclick$idx

      # Move
      $w.f.tl insert end "[::trans $maskmove] " [ list movefg tagclick$idx ]

      # Comment
      set comment [lindex $m 3]
      set commentLength [string length $comment]
      set firstLine [ lindex [split $comment "\n"] 0 ]
      $w.f.tl insert end "$firstLine\n" tagtooltip$idx
      $w.f.tl tag bind tagtooltip$idx <Double-Button-1> "::tree::mask::op addComment 0 $maskmove $w"
      ::utils::tooltip::SetTag $w.f.tl $comment tagtooltip$idx

      # Trying to exntend bindings to the markers, doesnt work ???
      # $w.f.tl tag add tagclick$idx [expr $idx +1 + $hasPositionComment].0 "[expr $idx + 1 + $hasPositionComment].end - $commentLength chars"

      incr idx
    }
  }

  $w.f.tl configure -state disabled
}

proc createCanvas {w wonx lossx baseNumber move} {
  canvas $w -width 60 -height 12 -bg grey75

  # duplicate the binding for this line
  bind $w <Button-1> "::tree::selectCallback $baseNumber $move ; break"

  ### There is a 60x13 bargraph coloured white , (grey - canvas bg) and black
  # 0 to $wonx   is coloured white
  # $lossx to 61 is coloured black
  # (There's some +/- 1 to acount for widget borders)

  if {$wonx > 0.1} {
    $w create rectangle 0 0 $wonx 12 -fill white -width 0 ;# limegreen
  }
  if {$lossx < 60.9} {
    $w create rectangle $lossx 0 61 12 -fill grey10 ;# indianred3
  }
  return $w
}

### Currently unused (previously used by getColorScore)

proc ::tree::getLineValues {l} {

  # Returns a list with "ngames freq success eloavg perf" or
  # {} if there was a problem during parsing

  #0         1         2         3         4         5         6
  #0123456789012345678901234567890123456789012345678901234567890
  # 1: Nf3    C34      5115: 77.3%   53.9%  2289  2335  1975   16%
  # 1: e4     B00     37752: 47.1%   54.7%  2474  2513  2002   37%
  # 3: Nc3    C33       128:  1.9%   46.8%  2287  2329  1981  100%
  #                  ngames: freq% success%  elo  perf

  if {[scan [string range $l 14 24] %d:  ngames]  != 1} {return {}}
  if {[scan [string range $l 25 29] %f%% freq]    != 1} {return {}}
  if {[scan [string range $l 33 37] %f%% success] != 1} {return {}}
  if {[scan [string range $l 40 44] %d   eloavg]  != 1} {return {}}
  if {[scan [string range $l 46 50] %d   perf]    != 1} {return {}}

  return [list $ngames $freq $success $eloavg $perf]
}

### Tree statusbar now unused.
### Identical stats are available in other places, and tree widget gets y-crowded

proc ::tree::status { msg baseNumber } {
  global tree
  if {$msg != ""} {
    set tree(status$baseNumber) $msg
    return
  }
  set s "  $::tr(Database)"
  # set base [sc_base current]
  # if {$tree(locked$baseNumber)} { set base $tree(base$baseNumber) }
  set base $baseNumber
  set status "  $::tr(Database): [file tail [sc_base filename $base]]"
  if {$tree(locked$baseNumber)} { append status " ($::tr(TreeLocked))" }
  append status "   $::tr(Filter)"
  append status ": [filterText $base]"
  set tree(status$baseNumber) $status
}

################################################################################
set tree(standardLines) {
  {}
  {1.c4}
  {1.c4 c5}
  {1.c4 c5 2.Nf3}
  {1.c4 e5}
  {1.c4 Nf6}
  {1.c4 Nf6 2.Nc3}
  {1.d4}
  {1.d4 d5}
  {1.d4 d5 2.c4}
  {1.d4 d5 2.c4 c6}
  {1.d4 d5 2.c4 c6 3.Nf3}
  {1.d4 d5 2.c4 c6 3.Nf3 Nf6}
  {1.d4 d5 2.c4 c6 3.Nf3 Nf6 4.Nc3}
  {1.d4 d5 2.c4 c6 3.Nf3 Nf6 4.Nc3 dxc4}
  {1.d4 d5 2.c4 c6 3.Nf3 Nf6 4.Nc3 e6}
  {1.d4 d5 2.c4 c6 3.Nf3 Nf6 4.Nc3 e6 5.e3}
  {1.d4 d5 2.c4 e6}
  {1.d4 d5 2.c4 e6 3.Nc3}
  {1.d4 d5 2.c4 e6 3.Nc3 Nf6}
  {1.d4 d5 2.c4 e6 3.Nf3}
  {1.d4 d5 2.c4 dxc4}
  {1.d4 d5 2.c4 dxc4 3.Nf3}
  {1.d4 d5 2.c4 dxc4 3.Nf3 Nf6}
  {1.d4 d5 2.Nf3}
  {1.d4 d5 2.Nf3 Nf6}
  {1.d4 d5 2.Nf3 Nf6 3.c4}
  {1.d4 d6}
  {1.d4 d6 2.c4}
  {1.d4 Nf6}
  {1.d4 Nf6 2.c4}
  {1.d4 Nf6 2.c4 c5}
  {1.d4 Nf6 2.c4 d6}
  {1.d4 Nf6 2.c4 e6}
  {1.d4 Nf6 2.c4 e6 3.Nc3}
  {1.d4 Nf6 2.c4 e6 3.Nc3 Bb4}
  {1.d4 Nf6 2.c4 e6 3.Nf3}
  {1.d4 Nf6 2.c4 g6}
  {1.d4 Nf6 2.c4 g6 3.Nc3}
  {1.d4 Nf6 2.c4 g6 3.Nc3 Bg7}
  {1.d4 Nf6 2.c4 g6 3.Nc3 Bg7 4.e4}
  {1.d4 Nf6 2.c4 g6 3.Nc3 Bg7 4.e4 d6}
  {1.d4 Nf6 2.c4 g6 3.Nc3 Bg7 4.e4 d6 5.Nf3}
  {1.d4 Nf6 2.c4 g6 3.Nc3 Bg7 4.e4 d6 5.Nf3 O-O}
  {1.d4 Nf6 2.c4 g6 3.Nc3 Bg7 4.e4 d6 5.Nf3 O-O 6.Be2}
  {1.d4 Nf6 2.c4 g6 3.Nf3}
  {1.d4 Nf6 2.Bg5}
  {1.d4 Nf6 2.Bg5 Ne4}
  {1.d4 Nf6 2.Nf3}
  {1.d4 Nf6 2.Nf3 e6}
  {1.d4 Nf6 2.Nf3 g6}
  {1.e4}
  {1.e4 c5}
  {1.e4 c5 2.c3}
  {1.e4 c5 2.c3 d5}
  {1.e4 c5 2.c3 Nf6}
  {1.e4 c5 2.Nc3}
  {1.e4 c5 2.Nc3 Nc6}
  {1.e4 c5 2.Nf3}
  {1.e4 c5 2.Nf3 d6}
  {1.e4 c5 2.Nf3 d6 3.d4}
  {1.e4 c5 2.Nf3 d6 3.d4 cxd4}
  {1.e4 c5 2.Nf3 d6 3.d4 cxd4 4.Nxd4}
  {1.e4 c5 2.Nf3 d6 3.d4 cxd4 4.Nxd4 Nf6}
  {1.e4 c5 2.Nf3 d6 3.d4 cxd4 4.Nxd4 Nf6 5.Nc3}
  {1.e4 c5 2.Nf3 d6 3.d4 cxd4 4.Nxd4 Nf6 5.Nc3 a6}
  {1.e4 c5 2.Nf3 d6 3.d4 cxd4 4.Nxd4 Nf6 5.Nc3 e6}
  {1.e4 c5 2.Nf3 d6 3.d4 cxd4 4.Nxd4 Nf6 5.Nc3 g6}
  {1.e4 c5 2.Nf3 d6 3.d4 cxd4 4.Nxd4 Nf6 5.Nc3 Nc6}
  {1.e4 c5 2.Nf3 d6 3.Bb5+}
  {1.e4 c5 2.Nf3 e6}
  {1.e4 c5 2.Nf3 Nc6}
  {1.e4 c5 2.Nf3 Nc6 3.d4}
  {1.e4 c5 2.Nf3 Nc6 3.Bb5}
  {1.e4 c6}
  {1.e4 c6 2.d4}
  {1.e4 c6 2.d4 d5}
  {1.e4 c6 2.d4 d5 3.e5}
  {1.e4 c6 2.d4 d5 3.Nc3}
  {1.e4 c6 2.d4 d5 3.Nd2}
  {1.e4 d5}
  {1.e4 d6}
  {1.e4 d6 2.d4}
  {1.e4 d6 2.d4 Nf6}
  {1.e4 d6 2.d4 Nf6 3.Nc3}
  {1.e4 e5}
  {1.e4 e5 2.Nf3}
  {1.e4 e5 2.Nf3 Nc6}
  {1.e4 e5 2.Nf3 Nc6 3.d4}
  {1.e4 e5 2.Nf3 Nc6 3.Bb5}
  {1.e4 e5 2.Nf3 Nc6 3.Bb5 a6}
  {1.e4 e5 2.Nf3 Nc6 3.Bb5 a6 4.Ba4}
  {1.e4 e5 2.Nf3 Nc6 3.Bb5 a6 4.Ba4 Nf6}
  {1.e4 e5 2.Nf3 Nc6 3.Bb5 a6 4.Ba4 Nf6 5.O-O}
  {1.e4 e5 2.Nf3 Nc6 3.Bc4}
  {1.e4 e5 2.Nf3 Nf6}
  {1.e4 e6}
  {1.e4 e6 2.d4}
  {1.e4 e6 2.d4 d5}
  {1.e4 e6 2.d4 d5 3.Nc3}
  {1.e4 e6 2.d4 d5 3.Nc3 Bb4}
  {1.e4 e6 2.d4 d5 3.Nc3 Nf6}
  {1.e4 e6 2.d4 d5 3.Nd2}
  {1.e4 e6 2.d4 d5 3.Nd2 c5}
  {1.e4 e6 2.d4 d5 3.Nd2 Nf6}
  {1.e4 Nf6}
  {1.e4 Nf6 2.e5}
  {1.e4 Nf6 2.e5 Nd5}
  {1.Nf3}
  {1.Nf3 Nf6}
}
# if there is a treecache file source it, otherwise use hard coded
# values above
set scidConfigFiles(treecache) "treecache.dat"
catch {source [scidConfigFile treecache]}

# ::tree::prime
#   Primes the tree for this database, filling it with a number of
#   common opening positions.

proc ::tree::prime { baseNumber } {
  global tree
  if {! [winfo exists .treeWin$baseNumber]} { return }

  set base $baseNumber
  if {$tree(locked$baseNumber)} { set base $tree(base$baseNumber) }
  if {! [sc_base inUse]} { return }
  set fname [sc_base filename $base]
  if {[string index $fname 0] == "\["  ||  [file extension $fname] == ".pgn"} {
    tk_messageBox -parent .treeWin$baseNumber -icon info -type ok -title "Scid" \
        -message "Sorry, only Scid-format database files can have a tree cache file." -parent .treeWin$baseNumber
    return
  }

  set ::interrupt 0
  progressWindow "Scid: [tr TreeFileFill]" "" $::tr(Cancel) {set ::interrupt 1}
  resetProgressWindow
  leftJustifyProgressWindow
  busyCursor .
  sc_game push
  set i 1
  set len [llength $tree(standardLines)]
  foreach line $tree(standardLines) {
    sc_game new
    set text [format "%3d/\%3d" $i $len]
    if {[llength $line] > 0}  {
      sc_move addSan $line
      changeProgressWindow "$text: $line"
    } else {
      changeProgressWindow "$text: start position"
    }

    # sc_tree search -base $base -fastmode 0
    ::tree::mutex_refresh

    updateProgressWindow $i $len
    incr i
    if {$::interrupt} {
      closeProgressWindow
      set ::interrupt 0
      sc_game pop
      unbusyCursor .
      ::tree::refresh $baseNumber
      return
    }
  }
  closeProgressWindow
  if {[catch {sc_tree write $base} result]} {
    #tk_messageBox -type ok -icon warning -title "Scid: Error writing file" -message $result
  } else {
    #set a "$fname.stc: [sc_tree positions] positions, "
    #append a "$result bytes: "
    #set pergame [expr double($result) / double([sc_base numGames])]
    #append a [format "%.2f" $pergame]
    #append a " bytes per game"
    #tk_messageBox -type ok -parent .treeWin -title "Scid" -message $a
  }
  sc_game pop
  unbusyCursor .
  ::tree::refresh $baseNumber
}

### Update the window of best (highest-rated) tree games.

proc ::tree::toggleBest { baseNumber } {
  set w .treeBest$baseNumber
  if {[winfo exists $w]} {
    destroy $w
  } else {
    ::tree::best $baseNumber
  }
}

proc ::tree::OpenBest {baseNumber} {
  set w .treeBest$baseNumber
  if {[winfo exists $w]} {
    raiseWin $w
  } else {
    ::tree::best $baseNumber
  }
}

proc ::tree::best { baseNumber } {
  global tree

  set w .treeBest$baseNumber
  if {! [winfo exists .treeWin$baseNumber]} {
    ::tree::Open $baseNumber
  }
  # Hmmm... listbox widgets seem to clash, so need this hack
  if {[winfo exists .variations]} { return }
  if {! [winfo exists $w]} {
    ::createToplevel $w
    ::setTitle $w "$::tr(TreeBestGames) \[[file tail [sc_base filename $baseNumber]]\]"
    setWinLocation $w
    setWinSize $w
    bind $w <Escape> "destroy $w"
    bind $w <F1> {helpWindow Tree Best}
    bindWheeltoFixed $w
    pack [frame $w.b] -side bottom -fill x
    frame $w.blist
    pack $w.blist -side top -expand true -fill both
    listbox $w.blist.list  -yscrollcommand "$w.blist.ybar set" -font font_Fixed -selectmode single -highlightthickness 0
    scrollbar $w.blist.ybar -command "$w.blist.list yview" -takefocus 0
    pack $w.blist.ybar -side right -fill y
    pack $w.blist.list -side left -fill both -expand yes
    bind $w.blist.list <<ListboxSelect>>  "::tree::bestMenu $baseNumber"

    label $w.b.result -text " $::tr(Result)" -font font_Small
    tk_optionMenu $w.b.res tree(bestRes$baseNumber) All 1-0 0-1 {1-0 0-1} {1/2-1/2}
    $w.b.res configure -font font_Small -direction right

    label $w.b.sort -text " $::tr(Sort)" -font font_Small
    tk_optionMenu $w.b.sortMenu tree(sortBest$baseNumber) Best Order
    $w.b.sortMenu configure -font font_Small -direction right

    button $w.b.close -text $::tr(Close) -command "destroy $w" -width 9 -font font_Small
    pack $w.b.close $w.b.res $w.b.result $w.b.sortMenu $w.b.sort -side right -padx 5 -pady 5
    bind $w <Configure> "recordWinSize $w"
    focus $w.blist.list
    ::createToplevelFinalize $w
  }
  $w.blist.list delete 0 end
  set tree(bestList$baseNumber) {}
  set count 0

  if {! [sc_base inUse]} { return }
# why are we catching this. I think it is because too many unusual cases/chars to be handled in the listbox
catch {
  foreach {idx line} [
      sc_tree best $tree(base$baseNumber) $tree(bestMax$baseNumber) $tree(bestRes$baseNumber) $tree(sortBest$baseNumber)
  ] {
    incr count
    # listbox widget does not like ' character
    set line [ string map { "'" "\'" } $line ]
    $w.blist.list insert end "  $line"
    lappend tree(bestList$baseNumber) $idx
  }
  if {$tree(sortBest$baseNumber) == "Order"} {
    $w.blist.list see end
  }
}
}


proc ::tree::bestMenu { baseNumber } {
      set w .treeBest$baseNumber
      if {![catch {set sel [$w.blist.list curselection]}] && $sel != {}} {
	set gnum [lindex $::tree(bestList$baseNumber) $sel]
	::game::LoadMenu $w.blist.list $baseNumber $gnum [winfo pointerx .] [winfo pointery .]
      }
}

### todo - fix the multiple tree windows, esp. when switching between bases S.A.

proc ::tree::toggleRefresh { baseNumber } {
  global tree

  if {$tree(autorefresh$baseNumber)} {
    ::tree::refresh $baseNumber
  }
}

proc ::tree::toggleAdjust {baseNumber} {
  global tree

  if {$tree(adjustfilter$baseNumber)} {
    ::tree::dorefresh $baseNumber
  } else {
    # User has deselected AdjustFilter, so they probably want the current filter to stay
    # So set dbFilter to the current Filter via overloaded sc_tree_clean
    sc_tree clean $baseNumber updateFilter
  }
}


proc ::tree::setCacheSize { base size } {
  sc_tree cachesize $base $size
}

proc ::tree::getCacheInfo { base } {
  set ci [sc_tree cacheinfo $base]
  tk_messageBox -title "Cache Info" -type ok -icon info \
      -message "Cache used : [lindex $ci 0] / [lindex $ci 1]" -parent .treeWin$base

}

proc ::tree::isCacheFull { base } {
  set ci [sc_tree cacheinfo $base]
  return [expr {[lindex $ci 0] == [lindex $ci 1]}]
}

################################################################################
# will go through all moves of all games of current base

set ::tree::cancelPrime 0

proc ::tree::primeWithBase {base {fillMask 0}} {
  set ::tree::cancelPrime 0
  for {set g 1} { $g <= [sc_base numGames]} { incr g} {
    sc_game load $g
    ::tree::primeWithGame $fillMask
    if {$::tree::cancelPrime } {
      return
    }
  }
}

proc ::tree::primeWithGame { { fillMask 0 } } {
  set ::tree::totalMoves [countBaseMoves "singleGame" ]
  sc_move start
  if {$fillMask} { ::tree::mask::feedMask [ sc_pos fen ] }

  set ::tree::parsedMoves 0
  set ::tree::cancelPrime 0
  progressWindow "Scid: [tr TreeFileFill]" "$::tree::totalMoves moves" $::tr(Cancel) {
    set ::tree::cancelPrime 1
    sc_progressBar
  }
  resetProgressWindow
  leftJustifyProgressWindow
  ::tree::parseGame $fillMask
  closeProgressWindow
  updateBoard -pgn
}

set processingTree 0

proc ::tree::mutex_refresh {} {
  global processingTree

  while {$processingTree} {
    vwait processingTree
  }
  set processingTree 1
  ::tree::refresh
  set processingTree 0
}

################################################################################
# parse one game and fill the list

proc ::tree::parseGame {{ fillMask 0 }} {

  if {$::tree::cancelPrime } { return  }

  ::tree::mutex_refresh

  if {$::tree::cancelPrime } { return }
  while {![sc_pos isAt vend]} {
    updateProgressWindow $::tree::parsedMoves $::tree::totalMoves

    # Go through all variants
    for {set v 0} {$v<[sc_var count]} {incr v} {
      # enter each var (beware the first move is played)
      set fen [ sc_pos fen ]
      sc_var enter $v
      if {$fillMask} { ::tree::mask::feedMask $fen }
      if {$::tree::cancelPrime } { return }
      if {$::tree::cancelPrime } { return }
      ::tree::parseVar $fillMask
      if {$::tree::cancelPrime } { return }
    }
    # now treat the main line
    set fen [ sc_pos fen ]
    sc_move forward

    ### In older Scids, tree was updated by updateBoard, but updateBoard (and tree refresh)
    ### is now asynchronous/cancelled so we must update the tree manually after each move
    ::tree::mutex_refresh

    if {$fillMask} { ::tree::mask::feedMask $fen }
    incr ::tree::parsedMoves
    if {$::tree::cancelPrime } { return }
    if {$::tree::cancelPrime } { return }
  }
}

### Recursively parse vars

proc ::tree::parseVar {{ fillMask 0 }} {
  while {![sc_pos isAt vend]} {
    # Go through all variants
    for {set v 0} {$v<[sc_var count]} {incr v} {
      set fen [ sc_pos fen ]
      sc_var enter $v
      if {$fillMask} { ::tree::mask::feedMask $fen }
      if {$::tree::cancelPrime } { return }
      if {$::tree::cancelPrime } { return }
      # we are at the start of a var, before the first move : start recursive calls
      parseVar $fillMask
      if {$::tree::cancelPrime } { return }
    }

    set fen [ sc_pos fen ]
    sc_move forward

    ::tree::mutex_refresh

    if {$fillMask} { ::tree::mask::feedMask $fen }
    incr ::tree::parsedMoves
    updateProgressWindow $::tree::parsedMoves $::tree::totalMoves
    if {$::tree::cancelPrime } { return }
    if {$::tree::cancelPrime } { return }
  }

  sc_var exit
}
################################################################################
# count moves that will fill the cache

proc ::tree::countBaseMoves { {args ""} } {
  set ::tree::total 0

  proc countParseGame {} {
    sc_move start

    while {![sc_pos isAt vend]} {
      for {set v 0} {$v<[sc_var count]} {incr v} {
        sc_var enter $v
        countParseVar
      }
      sc_move forward
      incr ::tree::total
    }
  }

  proc countParseVar {} {
    while {![sc_pos isAt vend]} {
      for {set v 0} {$v<[sc_var count]} {incr v} {
        sc_var enter $v
        countParseVar
        incr ::tree::total
      }
      sc_move forward
      incr ::tree::total
    }
    sc_var exit
  }

  if {$args == "singleGame"} {
    countParseGame
  } else {
    for {set g 1} { $g <= [sc_base numGames]} { incr g} {
      sc_game load $g
      countParseGame
    }
  }
  return $::tree::total
}

################################################################################
#
#                                 Mask namespace
#
#  All function calls with move in english
#  Images are 17x17

namespace eval ::tree::mask {

  # mask(fen) contains data for a position <fen> : ( moves, comment )
  # where moves is ( move nag color move_anno img1 img2 )
  array set mask {}
  set maskSerialized {}
  set maskFile ""
  set defaultColor white
  set emptyNag "  "
  set textComment ""
  set cacheFenIndex -1
  set dirty 0 ; # if Mask data has changed
  # Mask Search
  set searchMask_usenag 0
  set searchMask_usemarker0 0
  set searchMask_usemarker1 0
  set searchMask_usecolor 0
  set searchMask_usemovecomment 0
  set searchMask_useposcomment 0
  set displayMask_showNag 1
  set displayMask_showComment 1
  
  ### These image names are stored in mask files (stm), so we must handle image creation (elsewhere)
  # incase of SCID generated masks, and tb_help_small was previously tb_help (which image we still have somewhere)
  array set marker2image {
    Include	::rep::_tb_include
    Exclude	::rep::_tb_exclude
    MainLine	::tree::mask::imageMainLine
    Bookmark	tb_bkm
    White	::tree::mask::imageWhite
    Black	::tree::mask::imageBlack
    NewLine	tb_new
    ToBeVerified tb_rfilter
    ToTrain	tb_msearch
    Dubious	tb_help_small
    ToRemove	tb_cut
  }
  set maxRecent 10
}

################################################################################

proc ::tree::mask::open { {filename ""} {parent .}} {
  global ::tree::mask::maskSerialized ::tree::mask::mask

  if {$filename == ""} {
    set types {
      {{Tree Mask Files}       {.stm}        }
    }
    if {! [file isdirectory $::initialDir(stm)] } {
      set ::initialDir(stm) $::env(HOME)
    }
    set filename [tk_getOpenFile -initialdir $::initialDir(stm) -filetypes $types -defaultextension ".stm" -parent $parent]
  }

  if {$filename != ""} {
    if {![file readable $filename]} {
      if {$parent == "autoLoad"} {
	::splash::add "Can't read mask file $filename" error
      } else {
	tk_messageBox -title Oops -type ok -icon info -message "Mask: no such file \"$filename\""
      }
    } else {
      set ::initialDir(stm) [file dirname $filename]
      ::tree::mask::askForSave $parent
      array unset ::tree::mask::mask
      array set ::tree::mask::mask {}
      source $filename
      array set mask $maskSerialized
      set maskSerialized {}
      set ::tree::mask::maskFile $filename
      set ::tree::mask::dirty 0
      ::tree::refresh
      ::tree::mask::addRecent $filename
      ::tree::mask::updateDisplayMask
    }
  }
}

proc ::tree::mask::addRecent {filename} {
  global ::tree::mask::recentMask

  set i [lsearch -exact $recentMask $filename]
  while {$i > -1} {
    set recentMask [lreplace $recentMask $i $i]
    set i [lsearch -exact $recentMask $filename]
  }

  set recentMask [ linsert $recentMask 0 $filename]
  if {[llength $recentMask] > $::tree::mask::maxRecent } {
    set recentMask [ lreplace $recentMask  [ expr $::tree::mask::maxRecent -1 ] end ]
  }
  
  # update recent masks menu entry
  for {set i 1} {$i <= [sc_base count total]} {incr i} {
    set w .treeWin$i
    if { [winfo exists $w] } {
      $w.menu.mask.recent delete 0 end
      foreach f $::tree::mask::recentMask {
	$w.menu.mask.recent add command -label $f -command [list ::tree::mask::open $f $w]
      }
    }
  }
}

################################################################################

proc ::tree::mask::askForSave {{parent .}} {
  if {$::tree::mask::dirty} {

    ### Issue here - closing app on linux - execution flows here, but the tk_messageBox fails to show up
    # (?) Issue here - Closing the database breaks the "-parent $parent" for some reason
    # Once we remove the parent option, the tree window stays open (albeit the menu widget gets destroyed!)
    if {![winfo exists $parent]} {
      set parent .
    }

    set answer [tk_messageBox -title Scid -icon warning -type yesno \
      -message "[tr DoYouWantToSaveFirst] [tr TreeMask] $::tree::mask::maskFile ?" -parent $parent]

    if {$answer == "yes"} {
      ::tree::mask::save
    }
  }
}

################################################################################

proc ::tree::mask::new {{parent .}} {

  set types {
    {{Tree Mask Files}       {.stm}        }
  }
  set filename [tk_getSaveFile -filetypes $types -defaultextension ".stm" -parent $parent]

  if {$filename != ""} {
    if {[file writable [file dirname $filename]]} {
      if {[file extension $filename] != ".stm" } {
	append filename ".stm"
      }
      ::tree::mask::askForSave $parent
      set ::tree::mask::dirty 0
      set ::tree::mask::maskFile $filename
      array unset ::tree::mask::mask
      array set ::tree::mask::mask {}
      ::tree::refresh
    } else {
      tk_messageBox -title "Oops" -type ok -icon warning -message "File '$filename' not writeable."
    }
  }
}

################################################################################

proc ::tree::mask::close {{parent .}} {
  if { $::tree::mask::maskFile == "" } {
    return
  }
  ::tree::mask::askForSave $parent
  set ::tree::mask::dirty 0
  array unset ::tree::mask::mask
  array set ::tree::mask::mask {}
  set ::tree::mask::maskFile ""
  catch {
    # We have to close searchmask too
    # It's possible to leave open, but if we switch to another DB, then open tree and performa a searchmask, it uses the wrong base.
    destroy .searchmask
    destroy .displaymask
    destroy .treeMaskAddComment
  }
  ::tree::refresh
}

proc ::tree::mask::save {} {
  if {$::tree::mask::maskFile == ""} {return}
  set f [ ::open $::tree::mask::maskFile w ]
  puts $f "set ::tree::mask::maskSerialized [list [array get ::tree::mask::mask]]"
  ::close $f
  set ::tree::mask::dirty 0
  # In case it's a new mask
  ::tree::mask::addRecent $::tree::mask::maskFile
}

set ::tree::mask::controlButton 0

### Check that the position is in the mask , before calling other mask operations
#   (AddMove, RemoveMove, Marker 1 Marker 2, Color, Nag, Comment Move).
#   If the control button has been pressed, apply the operation to all previous positions leading to this one.
#   This is done in backwards order for simplicity (just like the new book tuning add line feature).
#   Since we are sometimes doing multiple operations, we have to track when to refresh the tree
#   Most operations no longer refresh the tree themselves, but rely on ::tree::mask::op to do it for them.
#   The exception is 'addComment', which is never given refresh==1, because addComment sitll refreshes the tree itself.

proc ::tree::mask::op {op refresh move args} {
  if {$::tree::mask::controlButton} {
    eval ::tree::mask::fillWithLine $op $move $args   
    ::tree::refresh
  } else {
    if {$op != "removeFromMask" && ![::tree::mask::moveExists $move]} {
      ::tree::mask::addToMask $move
    }
    if {$op != "addToMask"} {
      eval $op $move $args
    }
    if {$refresh} {
      ::tree::refresh
    }
  }
  set ::tree::mask::controlButton 0
}

proc ::tree::mask::contextMenu {control win move x y xc yc} {
  update idletasks
  
  set ::tree::mask::controlButton $control

  set mctxt $win.ctxtMenu
  if { [winfo exists $mctxt] } {
    destroy $mctxt
  }
  
  menu $mctxt
  $mctxt add command -label [tr AddToMask] -command [list ::tree::mask::op addToMask 1 $move]
  $mctxt add command -label [tr RemoveFromMask] -command [list ::tree::mask::op removeFromMask 1 $move]
  $mctxt add separator

  foreach j { 0 1 } {
    menu $mctxt.image$j
    $mctxt add cascade -label "[tr Marker] [expr $j +1]" -menu $mctxt.image$j
    foreach e { Include Exclude MainLine Bookmark White Black NewLine ToBeVerified ToTrain Dubious ToRemove } {
      set i  $::tree::mask::marker2image($e)

      $mctxt.image$j add command -label [ tr $e ] -image $i -compound left -command [list ::tree::mask::op setImage 1 $move $i $j]
    }
    $mctxt.image$j add command -label [tr NoMarker] -command [list ::tree::mask::op setImage 1 $move {} $j]
  }
  menu $mctxt.color
  $mctxt add cascade -label [tr ColorMarker] -menu $mctxt.color
  foreach c { "White" "Green" "Yellow" "Blue" "Red"} {
    $mctxt.color add command -label [ tr "${c}Mark" ] -background $c -command [list ::tree::mask::op setColor 1 $move $c]
  }
  
  menu $mctxt.nag
  $mctxt add cascade -label [tr Nag] -menu $mctxt.nag

  foreach nag [ list "!!" " !" "!?" "?!" " ?" "??" " ~" [::tr "None"]  ] {
    $mctxt.nag add command -label $nag -command [list ::tree::mask::op setNag 1 $move $nag]
  }
  
  $mctxt add command -label [ tr CommentMove] -command [list ::tree::mask::op addComment 0 $move $win]

  $mctxt add separator

  $mctxt add command -label [ tr CommentPosition] -command [list ::tree::mask::addComment {} $win]
  
  set lMatchMoves [sc_pos matchMoves ""]

  # remove "OO" from move list
  set extracastling [lsearch -exact $lMatchMoves "OO"]
  if {$extracastling > -1} {
    set lMatchMoves [lreplace $lMatchMoves $extracastling $extracastling]
  }

  menu $mctxt.matchmoves
  $mctxt add cascade -label [ tr AddThisMoveToMask ] -menu $mctxt.matchmoves
  set row 0
  foreach m [sc_pos matchMoves ""] {
    if {$m == "OK"} { set m "O-O" }
    if {$m == "OQ"} { set m "O-O-O" }
    if {$row % 10 == 0} {
      $mctxt.matchmoves add command -label [::trans $m] -command "::tree::mask::addToMask $m ; ::tree::refresh" -columnbreak 1
    } else {
      $mctxt.matchmoves add command -label [::trans $m] -command "::tree::mask::addToMask $m ; ::tree::refresh"
    }
    incr row
  }

  tk_popup $mctxt [winfo pointerx .] [winfo pointery .]

}

################################################################################

proc ::tree::mask::addToMask { move {fen ""} } {
  global ::tree::mask::mask

  if {[::tree::mask::moveExists $move]} {return}

  if {$fen == ""} { set fen $::tree::mask::cacheFenIndex }

  if {![info exists mask($fen)]} {
    set mask($fen) { {} {} }
  }
  set ::tree::mask::dirty 1
  set moves [ lindex $mask($fen) 0 ]
  if {[lsearch $moves $move] == -1} {
    lappend moves [list $move {} $::tree::mask::defaultColor {} {} {}]
    set newpos [lreplace $mask($fen) 0 0 $moves]
    set mask($fen) $newpos
  }
}

################################################################################

proc ::tree::mask::removeFromMask { move {fen ""} } {
  global ::tree::mask::mask

  if {$fen == ""} { set fen $::tree::mask::cacheFenIndex }

  if {![info exists mask($fen)]} {
    return
  }
  set ::tree::mask::dirty 1

  set moves [ lindex $mask($fen) 0 ]
  set idxm [lsearch -regexp $moves "^$move\\+* "]
  if { $idxm != -1} {
    set moves [lreplace $moves $idxm $idxm]
    lset mask($fen) 0 $moves
  }

  # if the position has no move left and no comment, unset it
  if { [llength [lindex $mask($fen) 0] ] == 0 && [lindex $mask($fen) 1] == "" } {
    array unset mask $fen
  }
}

################################################################################
# returns 1 if the move is already in mask

proc ::tree::mask::moveExists { move {fen ""} } {
  global ::tree::mask::mask

  if {$fen == ""} { set fen $::tree::mask::cacheFenIndex }
  if {![info exists mask($fen)] || $move == "\[end\]" } {
    return 0
  }
  set moves [ lindex $mask($fen) 0 ]

  if {[lsearch -regexp $moves "^$move\\+* "] == -1} {
    return 0
  }
  return 1
}

################################################################################
# return the list of moves with their data

proc ::tree::mask::getAllMoves {} {
  global ::tree::mask::mask
  if {![info exists mask($::tree::mask::cacheFenIndex)]} {
    return ""
  }
  set moves [ lindex $mask($::tree::mask::cacheFenIndex) 0 ]
  return $moves
}

################################################################################

proc ::tree::mask::getColor { move {fen ""}} {
  global ::tree::mask::mask

  if {$fen == ""} { set fen $::tree::mask::cacheFenIndex }

  if {![info exists mask($fen)]} {
    return $::tree::mask::defaultColor
  }

  set moves [ lindex $mask($fen) 0 ]
  set idxm [lsearch -regexp $moves "^$move\\+* "]
  if { $idxm == -1} {
    return $::tree::mask::defaultColor
  }
  set col [ lindex $moves $idxm 2 ]

  return $col
}

################################################################################

proc ::tree::mask::setColor { move color {fen ""}} {
  global ::tree::mask::mask

  if {$fen == ""} { set fen $::tree::mask::cacheFenIndex }

  set ::tree::mask::dirty 1
  set moves [ lindex $mask($fen) 0 ]
  set idxm [lsearch -regexp $moves "^$move\\+* "]
  set newmove [lreplace [lindex $moves $idxm] 2 2 $color ]
  set moves [lreplace $moves $idxm $idxm $newmove ]
  set mask($fen) [ lreplace $mask($fen) 0 0 $moves ]
}

################################################################################
# defaults to "  " (2 spaces)

proc ::tree::mask::getNag { move { fen "" }} {
  global ::tree::mask::mask ::tree::mask::emptyNag

  if {$fen == ""} { set fen $::tree::mask::cacheFenIndex }

  if {![info exists mask($fen)]} {
    return $emptyNag
  }
  set moves [ lindex $mask($fen) 0 ]
  set idxm [lsearch -regexp $moves "^$move\\+* "]
  if { $idxm == -1} {
    return $emptyNag
  }
  set nag [ lindex $moves $idxm 1 ]
  if {$nag == ""} {
    set nag $emptyNag
  }
  if { [string length $nag] == 1} { set nag " $nag" }
  return $nag
}

################################################################################

proc ::tree::mask::setNag { move nag {fen ""} } {
  global ::tree::mask::mask

  if { $nag == [::tr "None"] } {
    set nag ""
  }

  if {$fen == ""} { set fen $::tree::mask::cacheFenIndex }

  set ::tree::mask::dirty 1
  set moves [ lindex $mask($fen) 0 ]
  set idxm [lsearch -regexp $moves "^$move\\+* "]
  set newmove [lreplace [lindex $moves $idxm] 1 1 $nag ]
  set moves [lreplace $moves $idxm $idxm $newmove ]
  set mask($fen) [ lreplace $mask($fen) 0 0 $moves ]
}

################################################################################

proc ::tree::mask::getComment { move { fen "" } } {
  global ::tree::mask::mask

  if {$fen == ""} { set fen $::tree::mask::cacheFenIndex }

  if {![info exists mask($fen)] || $move == "" || $move == "\[end\]" } {
    return ""
  }

  set moves [ lindex $mask($fen) 0 ]
  set idxm [lsearch -regexp $moves "^$move\\+* "]
  if { $idxm == -1} {
    return ""
  }
  set comment [ lindex $moves $idxm 3 ]
  if {$comment == ""} {
    set comment "  "
  }
  return $comment
}

################################################################################

proc ::tree::mask::setComment { move comment { fen "" } } {
  global ::tree::mask::mask

  if {$fen == ""} { set fen $::tree::mask::cacheFenIndex }

  set comment [string trim $comment]

  set ::tree::mask::dirty 1
  set moves [ lindex $mask($fen) 0 ]
  set idxm [lsearch -regexp $moves "^$move\\+* "]
  set newmove [lreplace [lindex $moves $idxm] 3 3 $comment ]
  set moves [lreplace $moves $idxm $idxm $newmove ]
  set mask($fen) [ lreplace $mask($fen) 0 0 $moves ]
  ::tree::refresh
}

################################################################################

proc ::tree::mask::getPositionComment {{fen ""}} {
  global ::tree::mask::mask

  if {$fen == ""} { set fen $::tree::mask::cacheFenIndex }

  if { ! [ info exists mask($fen) ] } {
    return ""
  }

  set comment [ lindex $mask($fen) 1 ]
  set comment [ string trim $comment ]

  return $comment
}

################################################################################

proc ::tree::mask::setPositionComment { comment {fen ""} } {
  global ::tree::mask::mask

  if {$fen == ""} { set fen $::tree::mask::cacheFenIndex }
  set comment [ string trim $comment ]
  set ::tree::mask::dirty 1
  # add position automatically
  if {![info exists mask($fen)]} {
    set mask($fen) { {} {} }
  }

  set newpos [ lreplace $mask($fen) 1 1 $comment ]
  set mask($fen) $newpos
  ::tree::refresh
}

################################################################################

proc ::tree::mask::setImage { move img nmr } {
  global ::tree::mask::mask
  set fen $::tree::mask::cacheFenIndex
  set ::tree::mask::dirty 1
  set moves [ lindex $mask($fen) 0 ]
  set idxm [lsearch -regexp $moves "^$move\\+* "]
  set loc [expr 4 + $nmr]
  set newmove [lreplace [lindex $moves $idxm] $loc $loc $img ]
  set moves [lreplace $moves $idxm $idxm $newmove ]
  set mask($fen) [ lreplace $mask($fen) 0 0 $moves ]
}

################################################################################
# nmr = 0 or 1 (two images per line)

proc ::tree::mask::getImage { move nmr } {
  global ::tree::mask::mask

  set fen $::tree::mask::cacheFenIndex
  if {![info exists mask($fen)]} {
    return ::tree::mask::emptyImage
  }
  set moves [ lindex $mask($fen) 0 ]
  set idxm [lsearch -regexp $moves "^$move\\+* "]
  if { $idxm == -1} {
    return ::tree::mask::emptyImage
  }
  set loc [expr 4 + $nmr]
  set img [lindex $moves $idxm $loc]
  if {$img == ""} { set img ::tree::mask::emptyImage }
  return $img
}

################################################################################

proc ::tree::mask::addComment { { move "" } {parent .} } {
  
  if {[string match *.f.tl $parent]} {
    # remove trailing .f.tl
    set parent [string range $parent 0 end-5]
  }

  set w .treeMaskAddComment
  if {[winfo exists $w]} {
    raiseWin $w
    return
  }

  toplevel $w
  placeWinOverParent $w $parent

  ### If move is null, addComment to the position

  if {$move == ""} {
    set oldComment [::tree::mask::getPositionComment]
    wm title $w [::tr CommentPosition]
  } else  {
    set oldComment [::tree::mask::getComment $move ]
    wm title $w [::tr CommentMove]
  }
  set oldComment [ string trim $oldComment ]
  autoscrollframe $w.f text $w.f.e -width 40 -height 5 -wrap word -setgrid 1
  $w.f.e insert end $oldComment
  dialogbutton $w.ok -text OK -command "::tree::mask::updateComment $move ; destroy $w ; ::tree::refresh"
  pack  $w.f  -side top -expand 1 -fill both -padx 3 -pady 3
  pack  $w.ok -side bottom
  focus $w.f.e
}


proc ::tree::mask::updateComment { { move "" } } {
  set e .treeMaskAddComment.f.e
  set newComment [$e get 1.0 end]
  set newComment [ string trim $newComment ]
  set ::tree::mask::dirty 1
  if {$move == ""} {
    ::tree::mask::setPositionComment $newComment
  } else  {
    ::tree::mask::setComment $move $newComment
  }
}


################################################################################

proc ::tree::mask::fillWithLine {{op {}} {move {}} {args {}}} {

  set ::tree::mask::controlButton 0

  if {$::tree::mask::maskFile == ""} {
    tk_messageBox -title "Scid" -type ok -icon warning -message [ tr OpenAMaskFileFirst]
    return
  }

  if {[sc_var level] > 0} {
    tk_messageBox -title "Scid" -type ok -icon warning -message "Can't add lne from inside a variation."
    return
  }

  if {$op == ""} {
    set reply [tk_dialog .booktune $::tr(AddLine) \
      {Add all/white/black moves (to current position) to mask ?} \
      question 0 \
      {  All  } $::tr(White) $::tr(Black) $::tr(Cancel) ]

    if {$reply == 3} {return}
    if {$reply == 1} {set reply white}
    if {$reply == 2} {set reply black}
  }

  sc_game push copy

  if {$op == "removeFromMask"} {
    set direction forward
  } else {
    set direction back
  }

  while {1} {
      if {$op == ""} {
	if {![sc_move back]} {
          break
        }
	set fen [sc_pos fen]
	sc_move forward
	if {$reply != [sc_pos side]} {
	    ::tree::mask::feedMask $fen
	}
	sc_move back
      } else {
	set ::tree::mask::cacheFenIndex [::tree::mask::toShortFen [sc_pos fen]]
        eval ::tree::mask::op $op 0 $move $args
        if {![sc_move $direction]} {
          break
        }
        set move [sc_game info nextMove]
        if {$move == ""} {
          break
        }
      }
  }
  set ::tree::mask::dirty 1
  sc_game pop
  ::tree::refresh
}

proc ::tree::mask::fillWithGame {} {
  if {$::tree::mask::maskFile == ""} {
    tk_messageBox -title "Scid" -type ok -icon warning -message [ tr OpenAMaskFileFirst]
    return
  }
  # primeWithGame is actually filling the tree cache also, slowing this proc down
  # though it would be possible to avoid if desired
  ::tree::primeWithGame 1
  set ::tree::mask::dirty 1
}

################################################################################

proc ::tree::mask::fillWithBase {base} {
  if {$::tree::mask::maskFile == ""} {
    tk_messageBox -title "Scid" -type ok -icon warning -message [ tr OpenAMaskFileFirst]
    return
  }
  ::tree::primeWithBase $base 1
  set ::tree::mask::dirty 1
}

################################################################################
# Take current position information and fill the mask (move, nag, comments, etc)

proc ::tree::mask::feedMask { fen } {
  set stdNags { "!!" "!" "!?" "?!" "??" "~"}
  set fen [toShortFen $fen]
  set move [sc_game info previousMoveNT]
  set comment [sc_pos getComment $fen ]
  
  if {$move == ""} {
    set move "null"
  }
  
  # add move if not in mask
  if { ![moveExists $move $fen]} {
    addToMask $move $fen
  }
  
  if {$move == "null"} {
    set comment "$comment [getPositionComment]"
    setPositionComment $comment $fen
    return
  }
  
  # NAG
  set nag [string trim [sc_pos getNags]]
  if {$nag == 0} { set nag "" }
  if {$nag != ""} {
    # append the NAGs to comment if not standard
    if {[lsearch $stdNags $nag ] == -1 } {
      set comment "$nag $comment"
      set nag ""
    } else  {
      set oldNag [getNag $move]
      if {$oldNag != $::tree::mask::emptyNag && $oldNag != $nag} {
        set comment "<$oldNag>(?!?) $comment"
      }
      setNag $move $nag $fen
    }
  }
  
  # append comment
  set oldComment [getComment $move $fen]
  if { $oldComment != "" && $oldComment != $comment } {
    set comment "$oldComment\n$comment"
  }
  setComment $move $comment $fen
  
}

################################################################################
#  trim the fen to keep position data only

proc ::tree::mask::toShortFen {fen} {
  set ret [lreplace $fen end-1 end]
  return $ret
}

################################################################################

proc ::tree::mask::infoMask {{parent .}} {
  global ::tree::mask::mask
  
  set npos [array size mask]
  # set nmoves 0
  set nmoves [lindex [ split [array statistics mask] "\n" ] end ]
  # foreach pos $mask {
  # incr nmoves [llength [lindex $pos 1]]
  # }
  tk_messageBox -title "Mask info" -type ok -icon info -message "Mask : $::tree::mask::maskFile\n[tr Positions] : $npos\n[tr Moves] : $nmoves" -parent $parent
}

################################################################################
# Dumps mask content in a tree view widget
# The current position is the reference base

proc ::tree::mask::displayMask {} {
  global ::tree::mask::mask
  
  set w .displaymask
  if { [winfo exists $w] } {
    focus $w
    return
  }
  toplevel $w
  setWinLocation $w
  setWinSize $w
  
  frame $w.f
  
  frame $w.fcb
  pack $w.fcb -fill x -side bottom

  checkbutton $w.fcb.nag -text [::tr "Nag"] -variable ::tree::mask::displayMask_showNag -command ::tree::mask::updateDisplayMask
  checkbutton $w.fcb.comment -text [::tr "Comments"] -variable ::tree::mask::displayMask_showComment -command ::tree::mask::updateDisplayMask

  dialogbutton $w.fcb.bupdate -text [::tr "Update"] -command ::tree::mask::updateDisplayMask
  dialogbutton $w.fcb.close -text [::tr Close] -command {destroy .displaymask}

  pack $w.fcb.nag $w.fcb.comment -side left
  pack $w.fcb.close $w.fcb.bupdate -side right -padx 2 -pady 2

  pack $w.f -fill both -expand 1
  
  ttk::treeview $w.f.tree -yscrollcommand "$w.f.ybar set" -xscrollcommand "$w.f.xbar set" -show tree -selectmode browse
  # workaround for a bug in treeview (xscrollbar does not get view size)
  $w.f.tree column #0 -minwidth 1200
  scrollbar $w.f.xbar -command "$w.f.tree xview" -orient horizontal
  scrollbar $w.f.ybar -command "$w.f.tree yview"
  
  pack $w.f.xbar -side bottom -fill x
  pack $w.f.ybar -side right -fill y
  pack $w.f.tree -side left -expand 1 -fill both
  
  updateDisplayMask
  
  bind $w <Escape> { destroy  .displaymask }
  bind $w <Configure>  {
    recordWinSize .displaymask
  }
  
  $w.f.tree tag bind dblClickTree <Double-Button-1> {::tree::mask::maskTreeUnfold }
}

################################################################################
### Update the extra "mask map" window if open

proc ::tree::mask::updateDisplayMask {} {
  global ::tree::mask::mask
  
  set w .displaymask
  if { ![winfo exists $w] } { return }

  wm title $w "[::tr DisplayMask] [file tail $::tree::mask::maskFile]"

  set tree  $w.f.tree
  $tree delete [ $tree children {} ]
  set fen [toShortFen [sc_pos fen] ]
  # use clipbase to enter a dummy game
  set currentbase [sc_base current]
  sc_base switch clipbase
  sc_game push copyfast
  
  if {[catch {sc_game startBoard $fen} err]} {
    puts "sc_game startBoard $fen => $err"
  }
  if { [info exists mask($fen) ] } {
    set moves [lindex $mask($fen) 0]
    ::tree::mask::populateDisplayMask $moves {} $fen {} [lindex $mask($fen) 1]
  }
  sc_game pop
  
  sc_base switch $currentbase
}

################################################################################
# creates a new image whose name is name1_name2, and concatenates two images.
# parameters are the markers, not the images names

proc ::tree::mask::createImage {marker1 marker2} {
  
  if {[lsearch [image names] "$marker1$marker2" ] != -1} {
    return
  }
  set img1 $::tree::mask::marker2image($marker1)
  set img2 $::tree::mask::marker2image($marker2)
  set w1 [image width $img1]
  set w2 [image width $img2]
  set h1 [image height $img1]
  set h2 [image height $img2]
  set margin 2
  image create photo $marker1$marker2 -height $h1 -width [expr $w1 + $w2 + $margin]
  $marker1$marker2 copy $img1 -from 0 0 -to 0 0
  $marker1$marker2 copy $img2 -from 0 0 -to [expr $w1 +$margin] 0
}

################################################################################

proc  ::tree::mask::maskTreeUnfold {} {
  set t .displaymask.f.tree
  
  proc unfold {id} {
    set t .displaymask.f.tree
    foreach c [$t children $id] {
      $t item $c -open true
      unfold $c
    }
  }
  
  set id [$t selection]
  unfold $id
}

################################################################################
# returns the first line of multi-line string (separated with \n)

proc ::tree::mask::trimToFirstLine {s} {
  set s [ lindex [ split $s "\n" ] 0 ]
  return $s
}


proc ::tree::mask::populateDisplayMask { moves parent fen fenSeen posComment} {
  global ::tree::mask::mask
  
  set posComment [ trimToFirstLine $posComment ]
  
  if { $posComment != ""} {
    set posComment "\[$posComment\] "
  }
  
  set tree .displaymask.f.tree
  
  foreach m $moves {
    set move [lindex $m 0]
    if {$move == "null"} { continue }
    set img ""
    if {[lindex $m 4] != "" && [lindex $m 5] == ""} {
      set img [lindex $m 4]
    }
    if {[lindex $m 4] == "" && [lindex $m 5] != ""} {
      set img [lindex $m 5]
    }
    if {[lindex $m 4] != "" && [lindex $m 5] != ""} {
      set l [array get ::tree::mask::marker2image]
      set idx [ lsearch $l [lindex $m 4] ]
      set mark1 [lindex $l [expr $idx -1 ] ]
      set idx [ lsearch $l [lindex $m 5] ]
      set mark2 [lindex $l [expr $idx -1 ] ]
      createImage $mark1 $mark2
      set img $mark1$mark2
    }
    
    set nag ""
    if { $::tree::mask::displayMask_showNag } {
      set nag [lindex $m 1]
    }
    
    if {[lindex $m 3] != "" && $::tree::mask::displayMask_showComment} {
      set move_comment " [lindex $m 3]"
      set move_comment [ trimToFirstLine $move_comment ]
    } else  {
      set move_comment ""
    }
    if { ! $::tree::mask::displayMask_showComment} {
      set posComment ""
    }
    set id [ $tree insert $parent end -text "$posComment[::trans $move][set nag]$move_comment" -image $img -tags dblClickTree ]
    if {[catch {sc_game startBoard $fen} err]} {
      puts "ERROR sc_game startBoard $fen => $err"
    }
    sc_move addSan $move
    
    set newfen [toShortFen [sc_pos fen] ]
    if {[lsearch $fenSeen $newfen] != -1} { return }
    if { [info exists mask($newfen) ] } {
      set newmoves [lindex $mask($newfen) 0]
      
      while { [llength $newmoves] == 1 } {
        lappend fenSeen $newfen
        sc_move addSan [ lindex $newmoves { 0 0 } ]
        set newfen [toShortFen [sc_pos fen] ]
        if {[lsearch $fenSeen $newfen] != -1} { return }
        lappend fenSeen $newfen
        if {[lindex $newmoves 0 3] != "" && $::tree::mask::displayMask_showComment } {
          set move_comment " [lindex $newmoves 0 3]"
          set move_comment [ trimToFirstLine $move_comment ]
        } else  {
          set move_comment ""
        }
        
        if {[lindex $newmoves 1] != "" && $::tree::mask::displayMask_showComment } {
          set pos_comment " \[[lindex $newmoves 1]\]"
          set pos_comment [ trimToFirstLine $pos_comment ]
        } else  {
          set pos_comment ""
        }
        set nag ""
        if { $::tree::mask::displayMask_showNag } {
          set nag [ lindex $newmoves { 0 1 }  ]
        }
        $tree item $id -text "[ $tree item $id -text ] $pos_comment[::trans [ lindex $newmoves { 0 0 }  ] ][ set nag  ]$move_comment"
        if { ! [info exists mask($newfen) ] } {
          break
        }
        set newmoves [lindex $mask($newfen) 0]
      }
      
      if { [info exists mask($newfen) ] } {
        set newmoves [lindex $mask($newfen) 0]
        ::tree::mask::populateDisplayMask $newmoves $id $newfen $fenSeen [lindex $mask($newfen) 1]
      }
    }
  }
  
}


proc ::tree::mask::searchMask { baseNumber } {
  
  set w .searchmask
  if { [winfo exists $w] } {
    # in case we are trying to open two search masks for different trees, best close the old one first
    destroy $w
  }

  toplevel $w
  wm title $w "[::tr SearchMask] \[[file tail [sc_base filename $baseNumber]]\]"

  frame $w.f1
  frame $w.f2
  pack $w.f1 -side top -fill both -expand 0 -padx 5 -pady 3
  pack $w.f2 -side top -fill both -expand 1 -padx 2 -pady 3
  
  ttk::button $w.f1.search -text [tr Search] -command "::tree::mask::performSearch $baseNumber"
  grid $w.f1.search -column 0 -row 0 -rowspan 2 -padx 5
  
  # NAG selection
  checkbutton $w.f1.nagl -text [tr Nag] -variable ::tree::mask::searchMask_usenag
  menu $w.f1.nagmenu
  ttk::menubutton $w.f1.nag -textvariable ::tree::mask::searchMask_nag -menu $w.f1.nagmenu 
  set ::tree::mask::searchMask_nag  [::tr "None"]
  foreach nag [ list "!!" " !" "!?" "?!" " ?" "??" " ~" [::tr "None"]  ] {
    $w.f1.nagmenu add command -label $nag -command "set ::tree::mask::searchMask_nag $nag"
  }
  grid $w.f1.nagl -column 1 -row 0 -pady 2
  grid $w.f1.nag  -column 1 -row 1 -padx 2
  
  # Markers 1 & 2
  foreach j { 0 1 } {
    checkbutton $w.f1.ml$j -text "[tr Marker] [expr $j +1]" -variable ::tree::mask::searchMask_usemarker$j
    menu $w.f1.menum$j
    ttk::menubutton $w.f1.m$j -textvariable ::tree::mask::searchMask_trm$j -menu $w.f1.menum$j 
    set ::tree::mask::searchMask_trm$j [tr "Include"]
    set ::tree::mask::searchMask_m$j $::tree::mask::marker2image(Include)
    foreach e { Include Exclude MainLine Bookmark White Black NewLine ToBeVerified ToTrain Dubious ToRemove } {
      set i $::tree::mask::marker2image($e)
      $w.f1.menum$j add command -label [ tr $e ] -image $i -compound left -command "
         set ::tree::mask::searchMask_trm$j \"[tr $e ]\"
         set ::tree::mask::searchMask_m$j $i
      "
      # I don't think menubuttons can use image AND text at the same time
      # $w.f1.m$j configure -image $i
    }
    grid $w.f1.ml$j -column [expr 2 + $j] -row 0 -pady 2
    grid $w.f1.m$j  -column [expr 2 + $j] -row 1 -padx 2
  }
  
  # Color
  checkbutton $w.f1.colorl -text [tr ColorMarker] -variable ::tree::mask::searchMask_usecolor
  menu $w.f1.colormenu
  ttk::menubutton $w.f1.color -textvariable ::tree::mask::searchMask_trcolor -menu $w.f1.colormenu 
  set ::tree::mask::searchMask_trcolor  [::tr "White"]
  set ::tree::mask::searchMask_color "White"
  foreach c { "White" "Green" "Yellow" "Blue" "Red"} {
    $w.f1.colormenu add command -label [ tr "${c}Mark" ] \
        -command "set ::tree::mask::searchMask_trcolor [ tr ${c}Mark ] ; set ::tree::mask::searchMask_color $c"
  }
  grid $w.f1.colorl -column 4 -row 0 -pady 2
  grid $w.f1.color  -column 4 -row 1 -padx 2
  
  # Move annotation
  checkbutton $w.f1.movecommentl -text "Move comment" -variable ::tree::mask::searchMask_usemovecomment
  entry $w.f1.movecomment -textvariable ::tree::mask::searchMask_movecomment -width 12
  grid $w.f1.movecommentl -column 5 -row 0 -padx 2 -pady 2
  grid $w.f1.movecomment  -column 5 -row 1 -padx 2
  
  # Position annotation
  checkbutton $w.f1.poscommentl -text "Position comment" -variable ::tree::mask::searchMask_useposcomment
  entry $w.f1.poscomment -textvariable ::tree::mask::searchMask_poscomment -width 12
  grid $w.f1.poscommentl -column 6 -row 0 -padx 2 -pady 2
  grid $w.f1.poscomment  -column 6 -row 1 -padx 2
  
  # display search result
  text $w.f2.text -yscrollcommand "$w.f2.ybar set" -xscrollcommand "$w.f2.xbar set" -height 20 -font font_Fixed -wrap none
  scrollbar $w.f2.ybar -command "$w.f2.text yview"
  scrollbar $w.f2.xbar -command "$w.f2.text xview" -orient horizontal
  pack $w.f2.ybar -side right -fill y
  pack $w.f2.xbar -side bottom -fill x
  pack $w.f2.text -side left -fill both -expand yes

  setWinLocation $w
  setWinSize $w
  
  bind $w.f2.text <ButtonPress-1> " ::tree::mask::searchClick %x %y %W $baseNumber "
  bind $w <Escape> {destroy .searchmask}
  bind $w <Configure> "recordWinSize $w"
  bind $w <F1> {helpWindow TreeMasks}
}

proc ::tree::mask::performSearch  { baseNumber } {
  global ::tree::mask::mask
  set t .searchmask.f2.text
  $t configure -state normal

  # contains the search result (FEN)
  set res {}
  
  set pos_count 0
  set move_count 0
  set pos_total 0
  set move_total 0
  
  $t delete 1.0 end
  
  # Display FEN + moves and comments. Clicking on a line starts filtering current base
  foreach fen [array names mask] {
    incr pos_total
    
    # Position comment
    set poscomment [ lindex $mask($fen) 1 ]
    if { $::tree::mask::searchMask_useposcomment  } {
      if { [string match -nocase "*$::tree::mask::searchMask_poscomment*"  $poscomment] } {
	lappend res [format "%6s %-20s %s" {} [string range [string map {"\n" ""} $poscomment] 0 19] $fen]
        incr pos_count
      } else  {
        continue
      }
    }
    
    set moves [ lindex $mask($fen) 0 ]
    foreach m $moves {
      incr move_total
      
      # NAG
      if { $::tree::mask::searchMask_usenag } {
        set nag $::tree::mask::searchMask_nag
        if { $nag == [::tr "None"] } {  set nag ""  }
        if { [ string trim [lindex $m 1] ] != $nag } {
          continue
        }
      }
      
      # Markers 1 & 2
      if { $::tree::mask::searchMask_usemarker0 } {
        if { $::tree::mask::searchMask_m0 != [lindex $m 4] } {
          continue
        }
      }
      if { $::tree::mask::searchMask_usemarker1 } {
        if { $::tree::mask::searchMask_m1 != [lindex $m 5] } {
          continue
        }
      }
      
      # Color
      if { $::tree::mask::searchMask_usecolor } {
        if { [ string compare -nocase $::tree::mask::searchMask_color [lindex $m 2] ] != 0 } {
          continue
        }
      }
      
      # Move annotation
      set movecomment [lindex $m 3]
      if { $::tree::mask::searchMask_usemovecomment } {
        if {  ! [string match -nocase "*$::tree::mask::searchMask_movecomment*"  $movecomment]  } {
          continue
        }
      }
      
      lappend res [format "%6s %-20s %s" [::trans [lindex $m 0]] [string range [string map {"\n" ""} $movecomment] 0 19] $fen]
      incr move_count
    }
  }
  
  # output the result
  foreach l $res {
    $t insert end "$l\n"
  }
  wm title .searchmask "[::tr SearchMask] \[[file tail [sc_base filename $baseNumber]]\] [::tr Positions] $pos_count/$pos_total - [::tr moves] $move_count/$move_total"

  $t configure -state disabled
}


proc  ::tree::mask::searchClick {x y win baseNumber} {
  global tree

  set idx [ $win index @$x,$y ]
  if { [ scan $idx "%d.%d" l c ] != 2 } {
    # should never happen
    return
  }
  set elt [$win get $l.0 $l.end]
  set fen [string range $elt 28 end]

  if {[llength $fen] < 4} {
    return
  }
  
  # load the position in a temporary game (in clipbase), update the Trees then switch to Tree's base
  sc_base switch clipbase
  sc_game push copyfast
  
  if {[catch {sc_game startBoard $fen} err]} {
    puts "sc_game startBoard $fen => $err"
  } else  {
    # todo - call sc_search board maybe wiser ?
    # was  ::tree::refresh

    sc_tree search -cancel all
    sc_tree search -hide $tree(training$baseNumber) -sort $tree(order$baseNumber) -base $baseNumber \
      -fastmode $tree(fastmode$baseNumber) -adjust 1

    # updateBoard -pgn
  }
  
  sc_game pop
  sc_base switch $baseNumber

  # load the first best game 
  if {[sc_filter first != 0]} {
    ::game::Load [sc_filter first]
  } else  {
    updateBoard -pgn
  }

  set game [sc_filter first]
  # set game [lindex [sc_tree best $baseNumber 1 All] 0]
  # if {[string is integer -strict $game]}
  if {$game != 0} {
    ::game::Load $game
  } else  {
    updateBoard -pgn
  }
  
}


image create photo ::tree::mask::emptyImage -data {
R0lGODlhEAAQAIAAAP///////yH5BAEKAAEALAAAAAAQABAAAAIOjI+py+0P
o5y02ouzPgUAOw==
}
image create photo ::tree::mask::imageWhite -data {
  R0lGODlhEQARAMIEAAAAAD8/P39/f7+/v////////////////yH5BAEKAAcALAAAAAARABEA
  AANBeLrcrkOI8RwYA9QGCNHbAkhgGAieEISq551b60rhmJaV0BHwFgQu3uohC6oeu6AHB0Ep
  U4KG5AmVAq7YbDS0SQAAOw==
}
image create photo ::tree::mask::imageBlack -data {
  R0lGODlhEQARAMIEAAAAAD8/P39/f7+/v////////////////yH5BAEKAAQALAAAAAARABEA
  AAM0SLrcrkOI8Ry4oDac9eKeEnCBJ3CXoJ2oqqHdyrnViJYPC+MbjDkDH4bC0PloCiMMGWok
  AAA7
}

if {!$png_image_support} {
  image create photo ::tree::mask::imageMainLine -data {
    R0lGODlhEQARAOfzAAAAAAIAAAMAAAYAAAUFBRIMCw4ODisLBBQUFCUSDiIXFR8fHygoKDg4
    OE9BFVpQLlxQK2FWL2JWN2FXOGVZMGZaMrs3GWxfNGFhYWdjWcBGK8FGKm9rY8NMMd9CHsRU
    O3R0cnV0cs9SNcdXPtxQMN9PLnx4b3p6d9xWOHx7echhSslkS4CAf4GAf4KBfuNdP4OCgN9f
    QYODgYSDgYaFgt9jRsxtWIiIhZCKgeVpTuJrUN9yWNB4ZZOTkJSUkd94X916Y5qVipuVit96
    YpuWipiXlJeXl5iXl52Xi5mYkeh5YJ2XjJmYl56Yjed7Y5uZl5+ZjZ+Zjpqal5qamZual5+a
    jqCajpubmaGbj6GbkJycnKGckOeBa6OdkaOdkp6enp+enKOekueDbaSek5+fnqGfnKGgnaGh
    oKGhodeQfaWjoKSko+qMd+KPfamppqqppquqp6urqqyrqKurq6yrqa2rqa2sqe2kPq+vrrCv
    rbCvrrGwrrOyr+eejbOysfCpP7Ozs7SzsbSzsrS0steudLW0srW0s7W1s7W1tLW1tba1tLe2
    tbi3tPOvQrm3tri4trm4uLm5ubq5t/SyRO+0Tbu7ufe1RPK2Tfe1Rb29vO6rm8C/vMDAwMPC
    vsXEwcnJx8rKyM3LyPbSNs3My83Nzc/OytDOyvjYN9DQz9LRzdHR0dPSzvncONTTz9PT0tPT
    09XTztbU0PnfOdfV0dfW0dbW1tjW0djW0tnX09nX1PrkOtrZ1dvZ1fvnO9za1tza2Nzb2Nzb
    2fzpO9zc2t3c2N3c2t7d2fzrPd/e2uDe2t/f3eDf2+Hf2+Hf3OHg3ODg3+Hg3eLh3ePi4OTj
    4OXj4OXk4eTk5Obl4ufm4+jn5Ofn5+np6evq6Ozr6e3s6u3t6+3t7e/v7vDw7vDw8PHw7vLy
    8vPy8fTz8vT09Pb19Pb29vj39vj49/n5+Pn5+fr6+fv7+/z8+/7+/v//////////////////
    /////////////////////////////////yH5BAEKAP8ALAAAAAARABEAAAj7AP8J/JdAwIAD
    AxMOBPBKnaY+QFbUctdOm7UFCQGomyfmx44Rtea1w7MNUIOF8+ZxqVGjAxpOmdaMQzeHgEAA
    KZV48GCBTKZMZxzNAADg5jx5OnmiWtfu2S8AvS4ZfccmRw4Vo86dMwcA04Wi/3CyY8ODh40p
    jxAB0DWBqNFzAFgwAXBkEABKFZ6YAIvznLJP5IoFA3CKAgA7OPjOE4fokCBBAETdAQDCUxDF
    3PboyUPHAVEXPXZlUYzt2jVqwAAUodJpFS4ofMFBc7bMWCo+m0LxwjULCV9VzJAZI5bLVCxe
    vm7BEsI3SRgvXbZgsWIlC5QlRDKAVchdYUAAOw==
  }
} else {
  image create photo ::tree::mask::imageMainLine -data {
    iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QA/wD/AP+gvaeTAAAACXBI
    WXMAAAsSAAALEgHS3X78AAAAB3RJTUUH0wkWEisFOaTQ6wAAAB10RVh0Q29tbWVudABDcmVhdGVk
    IHdpdGggVGhlIEdJTVDvZCVuAAABqklEQVR42oWTz0sbQRTHP6alPy49BBfM0VuuvQiN6G5zlFIP
    8Q/w0EPBsxbZP6B/gaciVbQklIoNHpdslkAOkUJLdSEHQeKyjI2HQjY1ypodD3a32bWuDx7z3sx7
    n5n5MgP/TD4AmQH5CCR3+6uRHsZGAaeri1Ey8X6DIAhuFqTEcRw6nQ6qqgIsADsAGRI2aJkMWiYA
    nufheR79fh/HcSgUClQqFYAv4UkekmKmaUZxEATouo4QAk3TsCxrDxhLBRSLxegKvV6PdruNbR9g
    WVZY8joVUKvVYnk+n0fXdXwxzeB7lmdze9VUgKZpsTybzXJ1NoO//5ilD8fcq0G9Xo/iUqnE1a9p
    /P0nLH/+zdbXQ4DnqQBVVZFSoigKl8cvuGg95d3ukLXNb2HJj8x9GiiKwvnPKc7tcd6uC9Y+mhiG
    EdXcAkyaJxz98WMadI5mWfnksF21EULcuaEEZKPRiD3d+ZdKFJfLZem6rjQMI5yLizgcDul2uwgh
    yOVyAFTrZ7iuG70HKWVs11sihkXJpmTjfwHNZhPf92Ow0TG0v3A7CVsi/Rsn/Q3ANdGG5Icao+xt
    AAAAAElFTkSuQmCC
  }
}

### Extra images in tcl/tools/reper.tcl

### end of tree.tcl
