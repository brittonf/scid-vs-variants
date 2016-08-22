###
### book.tcl: part of Scid.
### Copyright (C) 2007  Pascal Georges, Stevenaaus
###

namespace eval book {
  set isOpen 0
  set isReadonly 0
  set bookList ""
  set bookPath ""
  set currentBook1 "" ; # book in form abc.bin
  set currentBook2 ""
  set currentTuningBook ""
  set bookMoves ""
  set cancelBookExport 0
  set exportCount 0
  set exportMax 3000
  set hashList ""

  ### Book Slots
  # I've made a patch to only open bookSlot2 when required. I should apply it, but it complicates code.
  set bookSlot1 0
  set bookSlot2 3
  set bookTuningSlot 2

  ### Slots must/should be unique to avoid conflicts. Other book slots used are:
  # I tried changing bookSlot (sergame.tcl) to 4 ... but sergame books opening then dumps core - unsure why
  # analysisBookSlot 1 (analysis.tcl) 
  # bookSlot         2 (serame.tcl) 
  # engineSlot       5 (tactics.tcl)

  ################################################################################
  # open a book, closing any previously opened one (called by annotation analysis)
  # arg name : gm2600.bin for example
  ################################################################################
  proc scBookOpen {name slot} {
    if {$slot == $::book::bookSlot1} {
      if {$::book::currentBook1 != ""} {
        sc_book close $::book::bookSlot1
      }
      set ::book::currentBook1 $name
    }

    if {$slot == $::book::bookSlot2} {
      if {$::book::currentBook2 != ""} {
        sc_book close $::book::bookSlot2
      }
      set ::book::currentBook2 $name
    }

    if {$slot == $::book::bookTuningSlot} {
      if {$::book::currentTuningBook != ""} {
        sc_book close $::book::bookTuningSlot
      }
      set ::book::currentTuningBook $name
    }

    set bn [ file join $::scidBooksDir $name ]
    set ::book::isReadonly [sc_book load $bn $slot]
  }

  ################################################################################
  # Return a move in book for position fen. If there is no move in book, returns ""
  # Is used by engines, not book windows
  ################################################################################
  proc getMove {book fen slot {n 1}} {
    set tprob 0
    ### Hmmm - why is book opened and closed every move ?
    ::book::scBookOpen $book $slot
    set bookmoves [sc_book moves $slot]
    if {[llength $bookmoves] == 0} {
      return ""
    }
    set r [expr {(int (rand() * 100))} ]
    for {set i 0} {$i<[llength $bookmoves]} {incr i 2} {
      set m [lindex $bookmoves $i]
      set prob [string range [lindex $bookmoves [expr $i + 1] ] 0 end-1 ]
      incr tprob $prob
      if { $tprob >= $r } {
        break
      }
    }
    sc_book close $slot
    return $m
  }
  ################################################################################
  #  Show moves leading to book positions
  ################################################################################
  proc togglePositionsDisplay {} {
    global ::book::oppMovesVisible
    if { $::book::oppMovesVisible} {
      pack .bookWin.1.opptext  ;# -expand yes -fill both
      pack .bookWin.2.opptext  ;# -expand yes -fill both
    } else {
      pack forget .bookWin.1.opptext
      pack forget .bookWin.2.opptext
    }
  }

  ################################################################################
  #  Open a window to select book and display book moves
  # arg name : gm2600.bin for example
  ################################################################################
  proc Open {} {
    global ::book::bookList ::book::bookPath ::book::currentBook1 ::book::currentBook2 ::book::lastBook1 ::book::lastBook2

    set w .bookWin

    if {[winfo exists $w]} {
      raiseWin $w
      return
    }

    ::createToplevel $w
    ::setTitle $w $::tr(Book)
    wm minsize $w 50 200
    wm resizable $w 0 1

    setWinLocation $w
    # setWinSize $w
    bind $w <F1> {helpWindow Book}
    standardShortcuts $w

    bind $w <Button-4> ::move::Back
    bind $w <Button-5> ::move::Forward
    frame $w.main 
    pack $w.main -fill both -side left

    set name1 $lastBook1
    set name2 $lastBook2

    set bookPath $::scidBooksDir
    set bookList [ lsort -dictionary [ glob -nocomplain -directory $bookPath *.bin ] ]

    if { [llength $bookList] == 0 } {
      # No book found
      destroy $w
      set ::book::currentBook1 {}
      set ::book::currentBook2 {}
      tk_messageBox -title "Scid" -type ok -icon error -message "No books found in books directory \"$bookPath\""
      return
    }

    set i 0
    set idx1 0
    set idx2 0
    set tmp {}
    foreach file  $bookList {
      set f [ file tail $file ]
      lappend tmp $f
      if {$name1 == $f} { set idx1 $i }
      if {$name2 == $f} { set idx2 $i }
      incr i
    }
    ttk::combobox $w.main.combo1 -width 12 -values $tmp
    ttk::combobox $w.main.combo2 -width 12 -values $tmp

    catch { $w.main.combo1 current $idx1 }
    catch { $w.main.combo2 current $idx2 }

    pack $w.main.combo1 -side top -pady 5
    pack $w.main.combo2 -side top -pady 5

    if {!$::book::showTwo} {
      $w.main.combo2 configure -state disabled
    }
    
    checkbutton $w.main.alpha -text {Alphabetical} -variable ::book::sortAlpha  -command ::book::refresh

    checkbutton $w.main.showtwo -text {Two Books} -variable ::book::showTwo  -command {
      if {$::book::showTwo} {
        .bookWin.main.combo2 configure -state normal
	pack .bookWin.2 -fill both -side right
      } else {
        .bookWin.main.combo2 configure -state disabled
        pack forget .bookWin.2
      }
      ::book::refresh
    }

    checkbutton $w.main.showopp -text {Opponent's Book} -variable ::book::oppMovesVisible \
       -command { ::book::togglePositionsDisplay }
    ::utils::tooltip::Set $w.main.showopp {Moves to which the opponent has a reply}

    pack $w.main.alpha   -side top -anchor w -pady 5
    pack $w.main.showtwo     -side top -anchor w -pady 5
    pack $w.main.showopp -side top -anchor w -pady 5

    frame $w.main.buttons
    pack $w.main.buttons -side bottom -pady 10

    button $w.main.buttons.back -image tb_prev -command ::move::Back -relief flat
    button $w.main.buttons.next -image tb_next -command ::move::Forward -relief flat

    pack $w.main.buttons.back -side left  -padx 3
    pack $w.main.buttons.next -side right -padx 3

    dialogbutton $w.main.help -textvariable ::tr(Help) -command {helpWindow Book}
    dialogbutton $w.main.close -textvariable ::tr(Close) -command "destroy $w"

    pack $w.main.close -side bottom -pady 5
    pack $w.main.help -side bottom -pady 5

    frame $w.1
    frame $w.2
    
    pack $w.1 -fill both -side left
    pack $w.2 -fill both -side right

    if {!$::book::showTwo} {
      pack forget $w.2
    }

    # The width of "12" is not enough for larger fonts ?!

    label $w.1.label -font font_Fixed
    label $w.2.label -font font_Fixed 
    text $w.1.booktext -wrap none -state disabled -width 10 -cursor top_left_arrow -font font_Fixed
    text $w.2.booktext -wrap none -state disabled -width 10 -cursor top_left_arrow -font font_Fixed

    pack $w.1.label -side top
    pack $w.2.label -side top

    pack $w.1.booktext -expand yes -fill both
    pack $w.2.booktext -expand yes -fill both
    
    text $w.1.opptext -wrap none -state disabled -height 6 -width 10 -cursor top_left_arrow -font font_Fixed
    text $w.2.opptext -wrap none -state disabled -height 6 -width 10 -cursor top_left_arrow -font font_Fixed

    bind $w.main.combo1 <<ComboboxSelected>> {::book::bookSelect}
    bind $w.main.combo2 <<ComboboxSelected>> {::book::bookSelect}
    bind $w <Destroy> "::book::closeMainBook"
    bind $w <Escape> {destroy .bookWin}
    bind $w <Left> ::move::Back 
    bind $w <Right> ::move::Forward

# Why
if {0} {
    # we make a redundant check here, another one is done a few line above
    if { [catch {bookSelect} ] } {
      tk_messageBox -title "Scid" -type ok -icon error -message "No books found. Check books directory"
      set ::book::currentBook1 ""
      set ::book::currentBook2 ""
      destroy  .bookWin
    }
}
    ::createToplevelFinalize $w
    bind $w <Configure> "recordWinSize $w"
    ::book::bookSelect
  }

  ################################################################################
  #
  ################################################################################
  proc closeMainBook {} {
    focus .main
    if { $::book::currentBook1 != "" } {
      sc_book close $::book::bookSlot1
      set ::book::currentBook1 ""
    }
    if { $::book::currentBook2 != "" } {
      sc_book close $::book::bookSlot2
      set ::book::currentBook2 ""
    }
  }
  ################################################################################
  #   updates book display when board changes
  ################################################################################
  proc refresh {} {
    global ::book::bookMoves

    set height 0
    set nextmove [sc_game info nextMove]

    set moves1 [sc_book moves $::book::bookSlot1]

    if {$::book::showTwo} {
      # Two books !
      set games {1 2}
      # this can be slow, so only do it if necessary
      set moves2 [sc_book moves $::book::bookSlot2]
    } else {
      set games 1
      set moves2 {}
    }

    if {$::book::sortAlpha} {
      if {$::book::showTwo} {
	### Parse the moves to insert empty lines and make the moves line up
	# should be doing this in C
	set m1 {}
	set m2 {}
	array set a1 $moves1
	array set a2 $moves2
	set ids [lsort -unique [concat [array names a1] [array names a2]]]
	foreach id $ids {
	  if {[info exists a1($id)]} {
	    lappend m1 $id $a1($id)
	    if {[info exists a2($id)]} {
	      lappend m2 $id $a2($id)
	    } else {
	      lappend m2 {} {}
	    }
	  } else {
	    lappend m1 {} {}
	    lappend m2 $id $a2($id)
	  }
	}
	set moves1 $m1
	set moves2 $m2
      } else {
	set m1 {}
	array set a1 $moves1
	set ids [lsort -unique [array names a1]]
	foreach id $ids {
	    lappend m1 $id $a1($id)
	}
	set moves1 $m1
      }
    }

    foreach z $games {
      foreach t [.bookWin.$z.booktext tag names] {
	  .bookWin.$z.booktext tag delete $t
      }
      foreach t [.bookWin.$z.opptext tag names] {
	  .bookWin.$z.opptext tag delete $t
      }

      set bookMoves [set moves$z]

      .bookWin.$z.booktext configure -state normal
      .bookWin.$z.booktext delete 1.0 end
      set line 1
      foreach {x y} $bookMoves {
        if {$x == {}} {
	  .bookWin.$z.booktext insert end [format "%5s %3s\n" $x $y]
          incr line
          continue
        }
        if {[string length $y] < 3} {set y " $y"}
	if {$x == $nextmove} {
	  ### (why do i have to configure this here and not above ?)
	  .bookWin.$z.booktext tag configure nextmove -background $::rowcolor
	  .bookWin.$z.booktext insert end [format "%5s %3s\n" [::trans $x] $y] nextmove
	} else {
	  .bookWin.$z.booktext insert end [format "%5s %3s\n" [::trans $x] $y]
	  # .bookWin.$z.booktext insert end "[::trans $x]\t$y\n"
	}
	.bookWin.$z.booktext tag add bookMove$line $line.0 $line.end
	.bookWin.$z.booktext tag add $x            $line.0 $line.end
	if {$x == $nextmove} {
	  .bookWin.$z.booktext tag bind bookMove$line <ButtonPress-1> ::move::Forward
        } else {
	  .bookWin.$z.booktext tag bind bookMove$line <ButtonPress-1> "::book::makeBookMove $x"
        }
	.bookWin.$z.booktext tag bind bookMove$line <Any-Enter> "
	  .bookWin.$z.booktext tag configure bookMove$line -background grey
	  .bookWin.1.booktext tag configure $x -background grey
	  .bookWin.2.booktext tag configure $x -background grey"
	.bookWin.$z.booktext tag bind bookMove$line <Any-Leave> "
	  .bookWin.$z.booktext tag configure bookMove$line -background {}
	  .bookWin.1.booktext tag configure $x -background {}
	  .bookWin.2.booktext tag configure $x -background {}"
	incr line
      }
      incr height [llength $bookMoves]

      set oppBookMoves [sc_book positions [set ::book::bookSlot$z]]
      .bookWin.$z.opptext configure -state normal
      .bookWin.$z.opptext delete 1.0 end

      set line 1
      foreach x $oppBookMoves {
	.bookWin.$z.opptext insert end [format "%5s\n" [::trans $x]]
	.bookWin.$z.opptext tag add bookMove$line $line.0 $line.end
	.bookWin.$z.opptext tag bind bookMove$line <ButtonPress-1> "::book::makeBookMove $x"
	incr line
      }

      .bookWin.$z.opptext configure -state disabled
      togglePositionsDisplay
    }
    set height [expr $height / 4]
    .bookWin.1.booktext configure -state disabled -height $height
    .bookWin.2.booktext configure -state disabled -height $height

  }


  proc makeBookMove { move } {
    if {[sc_pos isAt vend]} {
      set action replace
    } else {
      set action [confirmReplaceMove]
    }

    if {$action == "replace"} {
      sc_move addSan $move
      ::fics::checkAdd
    } elseif {$action == "var"} {
      sc_var create
      sc_move addSan $move
    } elseif {$action == "mainline"} {
      sc_var create
      sc_move addSan $move
      sc_var exit
      sc_var promote [expr {[sc_var count] - 1}]
      sc_move forward 1
    }
    updateBoard -pgn -animate
    ::utils::sound::AnnounceNewMove $move
    if {$action == "replace"} { ::tree::doTraining }
  }


  proc bookSelect {} {
    set w .bookWin
    set ::book::lastBook1 [$w.main.combo1 get]
    set ::book::lastBook2 [$w.main.combo2 get]
    $w.1.label configure -text [file rootname $::book::lastBook1]
    $w.2.label configure -text [file rootname $::book::lastBook2]
    scBookOpen [$w.main.combo1 get] $::book::bookSlot1
    scBookOpen [$w.main.combo2 get] $::book::bookSlot2
    refresh
  }

  ################################################################################
  #
  ################################################################################
  proc tuning {} {
    global ::book::bookList ::book::bookPath ::book::currentBook

    set w .bookTuningWin

    if {[winfo exists $w]} {
      return
    }

    ::createToplevel $w
    ::setTitle $w "$::tr(Book) Tuning"
    # wm resizable $w 0 0

    bind $w <F1> { helpWindow BookTuningWindow }
    setWinLocation $w

    frame $w.left
    frame $w.f

    pack $w.left -side left -pady 5 -expand 1 -fill both
    pack $w.f -side right -pady 5 -anchor n

    # load book names
    set bookPath $::scidBooksDir
    set bookList [  lsort -dictionary [ glob -nocomplain -directory $bookPath *.bin ] ]
    # No book found
    if { [llength $bookList] == 0 } {
      tk_messageBox -title "Scid" -type ok -icon error -message "No books found. Check books directory"
      set ::book::currentBook ""
      destroy $w
      return
    }

    set i 0
    set idx 0
    set tmp {}
    foreach file  $bookList {
      set f [ file tail $file ]
      lappend tmp $f
      if {$::book::lastTuning == $f} {
        set idx $i
      }
      incr i
    }

    ttk::combobox $w.left.combo -width 12 -values $tmp
    catch { $w.left.combo current $idx }

    menubutton $w.left.add -text $::tr(AddMove) -menu $w.left.add.otherMoves -indicatoron 1
    menu $w.left.add.otherMoves

    menubutton $w.left.remove -text "$::tr(GlistRemoveThisGameFromFilter) $::tr(GlistMoveField)" -menu $w.left.remove.otherMoves -indicatoron 1
    menu $w.left.remove.otherMoves

    button $w.left.addline -text $::tr(AddLine) -relief flat -command ::book::addLine
    button $w.left.remline -text $::tr(RemLine) -relief flat -command ::book::remLine
    
    # frame $w.left.space1 -height 60
    dialogbutton $w.left.export -text $::tr(Export) -command ::book::export
    dialogbutton $w.left.save -text $::tr(Save) -command ::book::save
    frame $w.left.space2 -height 10
    dialogbutton $w.left.help -text $::tr(Help) -command {helpWindow BookTuning}
    dialogbutton $w.left.close -text $::tr(Close) -command "destroy $w"
    
    pack $w.left.combo $w.left.add $w.left.remove -side top -padx 3 -pady 1
    pack $w.left.save -side top -padx 3 -pady 3
    pack $w.left.addline $w.left.remline -side top -padx 3 -pady 1
    pack $w.left.export -side top -padx 3 -pady 3
    pack $w.left.close $w.left.help $w.left.space2 -side bottom -padx 3 -pady 3

    bind $w.left.combo <<ComboboxSelected>> ::book::bookTuningSelect
    bind $w <Destroy> {
      if {"%W" == ".bookTuningWin"} {
        ::book::closeTuningBook
      }
    }
    bind $w <Escape> { destroy  .bookTuningWin }
    bind $w <F1> {helpWindow BookTuning}
    ::createToplevelFinalize $w
    bind $w <Configure> "recordWinSize $w"
    bookTuningSelect
  }


  proc closeTuningBook {} {
    if { $::book::currentTuningBook == "" } { return }
    focus .main
    sc_book close $::book::bookTuningSlot
    set ::book::currentTuningBook ""
  }


  proc bookTuningSelect {} {
    set w .bookTuningWin

    set ::book::lastTuning [$w.left.combo get]

    scBookOpen $::book::lastTuning $::book::bookTuningSlot

    if { $::book::isReadonly > 0 } {
      $w.left.save    configure -state disabled
      $w.left.add     configure -state disabled
      $w.left.addline configure -state disabled
      $w.left.remove  configure -state disabled
    } else {
      $w.left.save    configure -state normal
      $w.left.add     configure -state normal
      $w.left.addline configure -state normal
      $w.left.remove  configure -state normal
    }
    refreshTuning
  }


  proc addBookMove { move } {
    global ::book::bookTuningMoves

    if { $::book::isReadonly > 0 } { return }

    set w .bookTuningWin

    # first check this move doesn't already exists in ::book::bookTuningMoves and has been forgotten
    set count [lsearch $::book::bookTuningMoves $move]
    if {$count == -1} {
      set children [winfo children $w.f]
      set count [expr [llength $children] / 2]

      label $w.f.m$count -text [::trans $move]
      bind $w.f.m$count <ButtonPress-1> " ::book::makeBookMove $move"
      spinbox $w.f.sp$count -from 0 -to 100 -width 3 -font font_Fixed
      $w.f.sp$count set 0
      grid $w.f.m$count -row $count -column 0 -sticky e -pady 2
      grid $w.f.sp$count -row $count -column 1 -sticky w -pady 2
    } else {
      $w.f.sp$count set 0
      grid $w.f.m$count
      grid $w.f.sp$count
    }

    $w.left.add.otherMoves delete [::trans $move]
    $w.left.remove.otherMoves add command -label [::trans $move] -command "::book::removeBookMove $move $count"
    lappend ::book::bookTuningMoves $move
  }

  proc removeBookMove { move row } {
    global ::book::bookTuningMoves

    if { $::book::isReadonly > 0 } { return }

    set w .bookTuningWin

    ### set probability to -1 and forget from grid

    grid remove $w.f.m$row
    grid remove $w.f.sp$row
    $w.f.sp$row set -1
    $w.left.remove.otherMoves delete [::trans $move]
    $w.left.add.otherMoves add command -label [::trans $move] -command "::book::addBookMove $move"
  }

  ### Update book display when board changes

  proc refreshTuning {} {
    
    #unfortunately we need this as the moves on the widgets are translated
    #and widgets have no clientdata in tcl/tk
    global ::book::bookTuningMoves
    set ::book::bookTuningMoves {}
    set moves [sc_book moves $::book::bookTuningSlot]
    set nextmove [sc_game info nextMove]

    set w .bookTuningWin
    # erase previous children
    set children [winfo children $w.f]
    foreach c $children {
      destroy $c
    }

    $w.left.remove.otherMoves delete 0 end

    set row 0
    foreach {x y} $moves {
      lappend ::book::bookTuningMoves $x
      label $w.f.m$row -text [::trans $x] -justify right -anchor e -width 5 -font font_Fixed
      if {$x == $nextmove} {
        $w.f.m$row configure -background $::rowcolor
	bind $w.f.m$row <ButtonPress-1> ::move::Forward
      } else {
	bind $w.f.m$row <ButtonPress-1> "::book::makeBookMove $x"
      }

      spinbox $w.f.sp$row -from 0 -to 100 -width 3 -font font_Fixed
      if { $::book::isReadonly > 0 } {
	$w.f.sp$row configure -state disabled
      }
      set pct $y
      set value [string map {% {}} $pct]
      $w.f.sp$row set $value
      grid $w.f.m$row  -row $row -column 0 -sticky w -pady 1
      grid $w.f.sp$row -row $row -column 1 -sticky w -pady 1 -padx 4

      if {$row % 10 == 0} {
	$w.left.remove.otherMoves add command -label [::trans $x] -command "::book::removeBookMove $x $row" -columnbreak 1
      } else {
	$w.left.remove.otherMoves add command -label [::trans $x] -command "::book::removeBookMove $x $row"
      }
      incr row
    }

    ### Load legal moves
    $w.left.add.otherMoves delete 0 end
    # $w.left.add.otherMoves add command -label $::tr(None)

    set moveList [ sc_pos moves ]
    set row 0
    foreach move $moveList {
      if { [ lsearch  $moves $move ] == -1 } {
	if {$row % 10 == 0} {
	  $w.left.add.otherMoves add command -label [::trans $move] -command "::book::addBookMove $move" -columnbreak 1
	} else {
	  $w.left.add.otherMoves add command -label [::trans $move] -command "::book::addBookMove $move"
	}
	incr row
      }
    }
  }

  ################################################################################
  # sends to book the list of moves and probabilities.
  ################################################################################
  proc save {} {
    global ::book::bookTuningMoves
    if { $::book::isReadonly > 0 } { return }

    set prob {}
    set bookMoves {}
    set w .bookTuningWin
    set children [winfo children $w.f]
    set count [expr [llength $children] / 2]
    for {set row 0} {$row < $count} {incr row} {
      set t [$w.f.sp$row get]
      ### removeBookMove pack forgets deleted move, and sets it's probablility to -1
      if {$t != -1 } {
        lappend prob $t
        lappend bookMoves [lindex $::book::bookTuningMoves $row]
      }
    }
    set tempfile [file join $::scidUserDir tempfile.[pid]]
    sc_book movesupdate $bookMoves $prob $::book::bookTuningSlot $tempfile
    file delete $tempfile
    if {  [ winfo exists .bookWin ] } {
      ::book::refresh
    }
  }

  proc addLine {} {
    ### Move back to start, adding each move to book if necessary.
    # 'sc_book movesupdate' writes a new book each call, so not very optimal, but polyglot books are monsters.
    # Also relies on tempfile being zeroed by f=fopen(tempfile,"wb+") in book.cpp

    global ::book::bookTuningMoves
    if { $::book::isReadonly > 0 } { return }

    set reply [tk_dialog .booktune $::tr(AddLine) \
      {Add all/white/black moves (to current position) to book ?} \
      question 0 \
      {  All  } $::tr(White) $::tr(Black) $::tr(Cancel) ]

    if {$reply == 3} {return}
    if {$reply == 1} {set reply white}
    if {$reply == 2} {set reply black}

    busyCursor .
    update idletasks

    sc_game push copyfast
    set tempfile [file join $::scidUserDir tempfile.[pid]]

    while {![sc_pos isAt vstart]} {
      set move [sc_game info previousMove]
      
      # Skip black or white moves
      if {$reply == [sc_pos side]} {
        sc_move back
        set move [sc_game info previousMove]
      }

      if {[sc_move back]} {
      
        set moves [string map {% {}} [sc_book moves $::book::bookTuningSlot]]
        set bookMoves {}
        set prob {}
        # e4 46% d4 36% Nf3 10% c4 7% g3 1% b3 0% f4 0% Nc3 0% b4 0% e3 0% a3 0% c3 0% d3 0%
        foreach {x y} $moves {
          lappend bookMoves $x
          lappend prob $y
        }

        set count [lsearch $bookMoves $move]
        if {$count == -1} {
          lappend bookMoves $move
          lappend prob 0
          sc_book movesupdate $bookMoves $prob $::book::bookTuningSlot $tempfile
          # sc_book movesupdate d5 c5 Ba3 92 8 0 2 /home/steven/.scidvspc/tempfile.9403
        }
      }
    }

    file delete $tempfile
    sc_game pop
    unbusyCursor .
    updateBoard
  }

  proc remLine {} {
    ### Remove all book moves from next move

    global ::book::bookTuningMoves
    if { $::book::isReadonly > 0 } { return }

    set reply [ tk_messageBox -title $::tr(AddLine) -type yesno -icon info -parent .bookTuningWin -message \
     {Remove this line (from current position onwards) ?} ]
    if {$reply != {yes}} {return}

    busyCursor .
    update idletasks
    sc_game push copyfast
    set tempfile [file join $::scidUserDir tempfile.[pid]]

    while {![sc_pos isAt vend]} {
      set moves [string map {% {}} [sc_book moves $::book::bookTuningSlot]]
      # e4 46% d4 36% Nf3 10% c4 7% g3 1% b3 0% f4 0% Nc3 0% b4 0% e3 0% a3 0% c3 0% d3 0%
      set move [sc_game info nextMove]
      set bookMoves {}
      set prob {}
      set inBook 0
      foreach {x y} $moves {
        if {$x == $move} {
          set inBook 1
        } else {
          lappend bookMoves $x
          lappend prob $y
        }
      }
      if {$inBook} {
        sc_book movesupdate $bookMoves $prob $::book::bookTuningSlot $tempfile
        # sc_book movesupdate d5 c5 Ba3 92 8 0 2 /home/steven/.scidvspc/tempfile.9403
      }

      sc_move forward
    }

    file delete $tempfile
    sc_game pop
    unbusyCursor .
    updateBoard
  }

  ### Export all book moves from current position into the current game

  proc export {} {

    ::windows::gamelist::Refresh
    updateTitle

    set reply [
      tk_dialog .export_ok Scid {Export will attempt to insert all book moves (from the current position) into this game.} question 1 $::tr(Export) $::tr(Cancel)
    ]
    if {$reply != 0} {return}

    # set reply [ tk_messageBox -title $::tr(Export) -type okcancel -icon info -parent .bookTuningWin -message {Export will attempt to insert all book moves (from the current position) into this game.} ]
    # if {$reply != {ok}} {return}

    progressWindow "Scid" "ExportingBook..." $::tr(Cancel) "::book::sc_progressBar"
    set ::book::cancelBookExport 0
    set ::book::exportCount 0
    ::book::book2pgn
    set ::book::hashList ""
    closeProgressWindow
    if { $::book::exportCount >= $::book::exportMax } {
      tk_messageBox -title Scid -type ok -icon info \
          -message "$::tr(Movesloaded)  $::book::exportCount\n$::tr(BookPartiallyLoaded)"
    } else  {
      tk_messageBox -title "Scid" -type ok -icon info -message "$::tr(Movesloaded)  $::book::exportCount"
    }
    updateBoard -pgn
  }

  # Perform recursive book export

  proc book2pgn { } {
    global ::book::hashList

    if {$::book::cancelBookExport} { return  }
    if { $::book::exportCount >= $::book::exportMax } {
      return
    }
    set hash [sc_pos hash]
    if {[lsearch -sorted -integer -exact $hashList $hash] != -1} {
      return
    } else  {
      lappend hashList $hash
      set hashList [lsort -integer -unique $hashList]
    }

    updateBoard -pgn

    set bookMoves [sc_book moves $::book::bookTuningSlot]
    incr ::book::exportCount
    if {[expr $::book::exportCount % 50] == 0} {
      updateProgressWindow $::book::exportCount $::book::exportMax
      update
    }
    if {[llength $bookMoves] == 0} { return }

    for {set i 0} {$i<[llength $bookMoves]} {incr i 2} {
      set move [lindex $bookMoves $i]
      if {$i == 0} {
        sc_move addSan $move
        book2pgn
        sc_move back
      } else  {
        sc_var create
        sc_move addSan $move
        book2pgn
        sc_var exit
      }
    }

  }

  # Cancel book export

  proc sc_progressBar {} {
    set ::book::cancelBookExport 1
  }
}
###
### End of file: book.tcl
###
