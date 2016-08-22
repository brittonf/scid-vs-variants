############################################################
### Comment Editor window

namespace eval ::commenteditor {

  namespace export open close update storeComment addNag

  # List of colors and types used to mark a square

  variable  colorList {}  markTypeList {}
  set colorList {red orange yellow green blue skyBlue purple white black}
  set colorRegsub {(red|orange|yellow|green|blue|skyBlue|purple|white|black)}
  # Each list is a set of buttons in the dialog menu:
  set markTypeList {{circle disk full x + - = ? !} {1 2 3 4 5 6 7 8 9}}

  # IO state of the comment editor
  variable  State
  array set State {
	text {}
	pending {}
  }
  if {![info exists State(markColor)]} {
    set State(markColor) purple
  }
  if {![info exists State(markType)]} {
    set State(markType) +
  }

  proc addMark {args} {eval ::board::mark::add $args}
  proc delMark {args} {eval ::board::mark::remove $args}
}

proc ::commenteditor::addNag {nag} {
  if {![winfo exists .commentWin]} { return }
  .commentWin.nf.tf.text insert end "$nag  "
  ::commenteditor::storeComment
  ::pgn::Refresh 1
}

proc ::commenteditor::Open {} {
  global helpMessage
  variable colorList
  variable markTypeList
  variable State

  set w .commentWin
  if {[winfo exists $w]} {
    raiseWin $w
    return
  }

  ::createToplevel $w
  ::setTitle $w "[tr WindowsComment]"
  wm iconname $w "[tr WindowsComment]"
  # wm resizable $w 0 1
  # wm state $w withdrawn

  bind $w <F1> {helpWindow Comment}
  bind $w <Escape> "destroy  $w"
  bind $w <Destroy> ""
  bind $w <Configure> "recordWinSize $w"
  # standardShortcuts $w
  # bind $w <Left> {}
  # bind $w <Right> {}
  # bind $w <Up> {}
  # bind $w <Down> {}
  # bind $w <Control-r> {}
  # bind $w <Control-s> {}

  set mark [frame $w.markFrame]

  ### NAG frame

  frame $w.nf
  frame $w.nf.tf
  entry $w.nf.tf.text -width 20 -highlightthickness 0
  bindFocusColors $w.nf.tf.text

  set nagbox $w.nf.tf.text
  set nagbuttons $w.nf.b
  frame $w.nf.b
  set i 0
  set row 0
  set column 0
  set width [expr {$::windowsOS ? 2 : 1}]
  foreach {nag description} {
    ! GoodMove
    ? PoorMove
    !! ExcellentMove
    ?? Blunder
    !? InterestingMove
    ?! DubiousMove
    +- WhiteDecisiveAdvantage
    -+ BlackDecisiveAdvantage
    +/- WhiteClearAdvantage
    -/+ BlackClearAdvantage
    += WhiteSlightAdvantage
    =+ BlackSlightAdvantage
    = Equality
    ~ Unclear
    N Novelty
    D Diagram
  } {
    button $nagbuttons.b$i -takefocus 0 -text "$nag" -width $width -height 1 -font font_Small \
        -command "$w.nf.tf.text insert end \"$nag  \"
                  focus $w.nf.tf.text" -pady 1
    # set helpMessage(E,$nagbuttons.b$i) $description
    ::utils::tooltip::Set $nagbuttons.b$i $description
    grid $nagbuttons.b$i -row [expr {$i % 2}] -column [expr {int($i / 2)}] -padx 1 -pady 1
    incr i
  }
  ## Unused
  # +-- WhiteCrushing
  # --+ BlackCrushing

  # label $w.nf.label -font font_Regular -textvar ::tr(AnnotationSymbols)
  pack $w.nf -side top -pady 2 -padx 5 -fill x 
  #addHorizontalRule $w

  button $w.nf.tf.help -textvar ::tr(Help) -font font_Small -pady 1 -command {helpWindow Comment Annotation}
  button $w.nf.tf.clear -textvar ::tr(Clear) -font font_Small -pady 1 -command "
    $w.nf.tf.text delete 0 end
    focus $w.nf.tf.text"
  set helpMessage(E,$w.nf.tf.clear) {Clear all symbols for this move}
  # pack $w.nf.label -side top -expand 0
  pack $w.nf.tf -side top -fill x -expand 1
  pack $w.nf.tf.text -side left -fill x -expand 1 -padx 4
  pack $w.nf.tf.help $w.nf.tf.clear -side right -padx 4
  pack $w.nf.b -side top

  # label $w.cflabel -font font_Regular -textvar ::tr(Comment)
  # pack $w.cflabel -side top -pady 2

  ### Comment frame

  frame $w.cf
  text $w.cf.text -width 16 -height 3 -wrap word -font font_Regular \
    -yscrollcommand {.commentWin.cf.scroll set} -setgrid 1 -borderwidth 2 -relief groove -highlightthickness 0
  scrollbar $w.cf.scroll -command ".commentWin.cf.text yview"
  # bindFocusColors $w.cf.text
  # "break" stops subsequent built-in bindings from executing
  bind $w.cf.text <FocusOut> ::commenteditor::storeComment
  bind $w.cf.text <Control-Return> "$w.b.ok invoke ; break"
  bind $w.nf.tf.text <FocusOut> ::commenteditor::storeComment
  bind $w <Control-Left>  {::commenteditor::storeComment; ::move::Back}
  bind $w <Control-Right> {::commenteditor::storeComment; ::move::Forward}
  bind $w <Control-Home> {::commenteditor::storeComment; ::move::Start}
  bind $w <Control-End>  {::commenteditor::storeComment; ::move::End}
  bindWheeltoFont $w

  bind $w.cf.text <Control-a> {.commentWin.cf.text tag add sel 0.0 end-1c ; break}
  bind $w.cf.text <Control-z> {catch {.commentWin.cf.text edit undo} ; break}; # Control-z is default text binding anyway
  bind $w.cf.text <Control-y> {catch {.commentWin.cf.text edit redo} ; break}; # but the others are not
  bind $w.cf.text <Control-r> {catch {.commentWin.cf.text edit redo} ; break}

  pack $w.cf -side top -padx 5 -expand 1 -fill both

  pack $w.cf.scroll -side right -fill y
  pack $w.cf.text -side left -expand 1 -fill both

  # pack nf and makFrame if necessary
  ::commenteditor::toggleBoard

  ### Main buttons

  frame $w.b
  # todo: make this frame more persistant than others
  pack $w.b -side top -ipady 4 -padx 2 -pady 4 -fill x

  button $w.b.hide -image bookmark_down -command {
    set ::commenteditor::showBoard [expr {($::commenteditor::showBoard + 1) % 3}]
    ::commenteditor::toggleBoard
  }

  dialogbutton $w.b.ok -text Ok -font font_Small \
      -command "::commenteditor::storeComment
                focus .main
                destroy .commentWin"
  set helpMessage(E,$w.b.ok) {Apply changes and exit}

  dialogbutton $w.b.apply -textvar ::tr(Apply) -font font_Small -command ::commenteditor::storeComment
  set helpMessage(E,$w.b.apply) {Apply changes}

  dialogbutton $w.b.clear -textvar ::tr(Clear) -font font_Small -pady 1 -command "
      $w.cf.text delete 0.0 end
      focus $w.cf.text"
  set helpMessage(E,$w.b.apply) {Apply Changes}

  frame $w.b.space -width 20
  dialogbutton $w.b.cancel -textvar ::tr(Cancel) -font font_Small \
      -command "focus .main
                destroy .commentWin"
  set helpMessage(E,$w.b.cancel) {Close comment editor window}

  pack $w.b.hide $w.b.clear $w.b.ok $w.b.apply $w.b.cancel -side left -padx 5

  ### Insert-mark frame

  # label $mark.header -font font_Regular -text $::tr(InsertMark)
  # pack $mark.header -side top -ipady 1 -fill x -padx 1

  # pack [frame [set usage $mark.usage]] -side bottom -pady 1 -expand true
  # pack [label [set usage $usage.text] \
      -text [string trim $::tr(InsertMarkHelp)] -justify left]

  # Subframes for insert board , two button rows and arrow options
  pack [frame [set colorButtons $mark.colorButtons]] \
      -side top -pady 1 -anchor n
  pack [frame [set insertBoard $mark.insertBoard]] \
      -side top -pady 1
  pack [frame [set typeButtons $mark.typeButtons]] \
      -side top -pady 5 -anchor s
  pack [frame [set arrowOptions $mark.arrowOptions]] \
      -side top -pady 5 -anchor s

  ### Color (radio)buttons

  foreach color $colorList {
    image create photo markColor_$color -width 18 -height 18
    markColor_$color put $color -to 0 0 18 18
    radiobutton $colorButtons.c$color \
        -image markColor_$color \
        -variable [namespace current]::State(markColor) \
        -value $color \
        -indicatoron 0 \
        -takefocus 0 \
	-relief flat \
        -command [namespace code [list SetMarkColor $color]]
    pack $colorButtons.c$color -side left -padx 1 -pady 4
  }

  ### A small board

  set board [::board::new $insertBoard.board 25]
  if {[::board::isFlipped .main.board]} {
    ::board::flip  $insertBoard.board
  }
  ::board::showMarks $board 1
  set ::board::_mark($board) $::board::_mark(.main.board)
  ::board::update $board
  pack $board -side top
  # TODO?: move this for loop into a new proc (e.g. 'BindSquares')
  for {set square 0} {$square < 64} {incr square} {
    ::board::bind $board $square <ButtonPress-1> [namespace code \
        [list InsertMark $board $square]]
    ::board::bind $board $square <ButtonRelease-1> [namespace code \
        [list ButtonReleased $board %b %x %y]]
    #::board::bind $board $square <ButtonPress-2> [namespace code \
    #        [list InsertMark $board [expr {$square + 64}]]]
    ::board::bind $board $square <ButtonPress-3> [namespace code \
        [list InsertMark $board [expr {$square + 64}]]]
  }

  ### Type/Shape (pseudo-radio)buttons

  set size 20	;# button/rectangle size
  pack [set types [frame $typeButtons.all]] -side left -padx 10
  set row 0
  foreach buttons $markTypeList {
    set column 0
    foreach shape $buttons {
      set color gray70
      # Create and draw a button:
      set button [frame $types.button_${shape} -class PseudoButton]
      grid $button -row $row -column $column -padx 1 -pady 1
      # The "board" is a 1x1 board, containing one single square.
      set board1x1 [canvas $button.bd \
          -height $size -width $size -highlightthickness 0 \
          -borderwidth 1 -relief flat ]
      $board1x1 create rectangle 0 0 $size $size \
          -fill $color -outline "" \
          -tag [list sq0 button${shape}]
      ::board::mark::add $types.button_${shape} \
          $shape 0 $State(markColor) "false"
      pack $board1x1 -padx 1 -pady 1
      bind $board1x1 <Button-1> \
          [namespace code [list SetMarkType $board $shape]]
      incr column
    } ;# foreach shape
    incr row
  } ;# foreach button_line
  # "Press" button:
  SetMarkType $board $State(markType)

  ### Arrow options

  label   $arrowOptions.l1 -text {Arrow: Width}
  spinbox $arrowOptions.width -textvariable ::board::mark::arrowWidth -from 1 -to 10 -increment 1 -width 3 -command updateBoard
  label   $arrowOptions.space -width 1
  label   $arrowOptions.l2 -text {Length}
  spinbox $arrowOptions.length -textvariable ::board::mark::arrowLength -from 0.0 -to 0.9 -increment .1 -width 3 -command updateBoard
  pack $arrowOptions.l1 $arrowOptions.width $arrowOptions.space $arrowOptions.l2 $arrowOptions.length -side left -padx 2

  ### Start editing

  setWinLocation $w
  # Cant set size as it messes with hiding the board widget
  # setWinSize $w
  # wm state $w normal

  ::commenteditor::Refresh

  focus $w.cf.text
  ::createToplevelFinalize $w
}

proc ::commenteditor::toggleBoard {} {

  set w .commentWin

  if { $::commenteditor::showBoard == 0} {
    # show everything
    if {[winfo exists $w.markFrame.insertBoard.board]} {
      ::board::update $w.markFrame.insertBoard.board [sc_pos board]
    }
    pack $w.nf -side top -pady 2 -padx 5 -fill x -before $w.cf
    pack $w.markFrame -side right -fill both -padx 5 -anchor n -before .commentWin.nf
  } else {
    if { $::commenteditor::showBoard == 1} {
      # hide board
      catch {pack forget $w.markFrame}
    } else {
      # hide notation frame
      catch {pack forget $w.nf}
    }
  }
}

# ::commenteditor::SetMarkColor --
#
#	Called when a color is selected.
#
# Arguments:
#	color	The selected color.
# Results:
#	TODO
#
proc ::commenteditor::SetMarkColor {color} {
  variable   markTypeList
  variable   State
  set path   .commentWin.markFrame.typeButtons.all
  set square 0	;# square number of a 1x1-board
  foreach buttons $markTypeList {
    foreach shape $buttons {
      set button $path.button_${shape}
      if {$shape == "square"} {
        $button.bd itemconfigure sq$square \
            -fill $color -outline $color
      } else {
        $button.bd delete mark
        addMark $button $shape $square $color "false"
      }
    }
  }
  set State(markColor) $color
  set ::commentColour $color
}

# ::commenteditor::SetMarkType --
#
# Arguments:
#	board	The frame variable of the board.
#	type	The selected type/shape, e.g. "circle", "1", etc.
# Results:
#	TODO
#
proc ::commenteditor::SetMarkType {board type} {
  variable State
  set cur_type $State(markType)
  set path .commentWin.markFrame.typeButtons.all
  $path.button_${cur_type}.bd configure -relief raised
  $path.button_${type}.bd configure -relief sunken
  set State(markType) $type
}

#	Called when a square is selected on the insert board.
#
#	board	The frame variable of the board.
#	square	Number (0-63) of the selected square
#		(+64 if right mouse button used).

proc ::commenteditor::InsertMark {board square} {
  variable State
  set textwin .commentWin.cf.text
  if {![string length $State(pending)]} {
    set State(pending) $square
    return
  }
  # Right mouse click results in square-no + 64:
  set from [expr {$State(pending) % 64}]
  set to   [expr {$square         % 64}]

  set key $::board::mark::Command
  array set tag [list remove 0 value {}]
  if {$square == $State(pending)} {
    if {$square >= 64} { return }
    if {[lsearch [$textwin tag names] $square] >= 0} {
      array set tag [list remove 1 value $square]
      delMark $board $square
    } else {
      set tag(value) $square
      addMark $board $State(markType) $square $State(markColor)
      set to [::board::san $square]
      set State(text) "\[%$key $State(markType),$to,$State(markColor)\]"
    }
  } else {
    if {($square & 64) != ($State(pending) & 64)} {
      if {$square < 64} { set State(pending) $square }
      return
    }
    if {[lsearch [$textwin tag names] ${from}:${to}] >= 0} {
      set tag(remove) 1
      set tag(value)  [list ${from}:${to} ${to}:${from}]
      delMark $board $from $to
    } else {
      set tag(value) [list ${from}:${to} ${to}:${from}]
      addMark $board arrow $from $to $State(markColor)
      set from [::board::san $from]
      set to   [::board::san $to]
      set State(text) "\[%$key arrow,$from,$to,$State(markColor)\]"
    }
  }
  set State(pending) ""

  if {$tag(remove)} {
    set remove [lindex $tag(value) 0]
    if [llength [$textwin tag range $remove]] {
      $textwin delete $remove.first $remove.last
    }
    eval $textwin tag delete $tag(value)
  } else {
    $textwin insert insert $State(text) $tag(value)
  }
}

# ::commenteditor::ClearComments --
#
#	Called when the 'Clear' button is pressed.
#
# Arguments:
#	win	The window variable.
# Results:
#	Clears text area and chess board of the comment editor.
#
proc ::commenteditor::ClearComments {win} {
  ${win}.cf.text delete 0.0 end
  set board ${win}.markFrame.insertBoard.board
  ::board::mark::clear $board
  ::board::update $board
}

# ::commenteditor::ButtonReleased --
#
#	Auxiliary routine:
#	Called when a button is released over a square.
#
# Arguments:
#	board	The frame variable of the board.
#	button	The number (%b) of the button that was released.
#	x 	The x (%x) from the event.
#	y 	The y (%y) from the event.
# Results:
#
proc ::commenteditor::ButtonReleased {board button x y} {
  set square [::board::getSquare $board $x $y]
  if {$square < 0}  {
    set State(pending) ""
    return
  }
  if {$button != 1} {set square [expr {$square + 64}]}
  InsertMark $board $square
}

# Append arg as a comment
proc ::commenteditor::appendComment {arg} {
  set comment [sc_pos getComment]

  sc_game undoPoint
  if {$comment == {}} {
    sc_pos setComment "$arg"
  } else {
    sc_pos setComment "$comment\n$arg"
  }
  updateStatusBar
  updateBoard -pgn
}


# ::commenteditor::storeComment --
#
#	Set the comment of the current position to
#	the text of the commenteditor.

proc ::commenteditor::storeComment {} {
  if {![winfo exists .commentWin]} { return }
  set nag [sc_pos getNags]
  if {$nag == "0"} { set nag "" }
  if { $nag != [.commentWin.nf.tf.text get] } {
    sc_game undoPoint
    sc_pos clearNags
    foreach i [split [.commentWin.nf.tf.text get] " "] {
      sc_pos addNag $i
    }
    updateBoard  -pgn
  }

  # The "end-1c" below is because Tk adds a newline to text contents:
  set newComment [.commentWin.cf.text get 1.0 end-1c]
  set oldComment [sc_pos getComment]
  if {[string compare $oldComment $newComment]} {
    sc_game undoPoint
    sc_pos setComment $newComment
    updateStatusBar
    updateBoard -pgn
  }
}

### (Re)builds textwindow and board of the comment editor.

proc ::commenteditor::Refresh {} {
  if {![winfo exists .commentWin]} { return }

  # Zero undo stack... re-enabling it when Refresh is finished (there's still issues though)
  if {[catch {
    .commentWin.cf.text configure -undo 0
  }]} {
    # Under certain conditions (docked OS X only?), Refresh can get called before comment window
    # init is complete, so exit gracefully
    return
  }

  set nag [sc_pos getNags]
  .commentWin.nf.tf.text configure -state normal
  .commentWin.nf.tf.text delete 0 end
  if {$nag != "0"} {
    .commentWin.nf.tf.text insert end $nag
  }

  # if at vstart, disable NAG codes
  if {[sc_pos isAt vstart]} {
    set state "disabled"
  } else  {
    set state "normal"
  }
  foreach c [winfo children .commentWin.nf.tf] {
    $c configure -state $state 
  }
  foreach c [winfo children .commentWin.nf.b] {
    $c configure -state $state
  }

  # Rewrite text window, tag embedded commands,
  # and draw marks according to text window commands.
  set text  .commentWin.cf.text
  set board .commentWin.markFrame.insertBoard.board
  set comment [sc_pos getComment]
  set offset  0
  ::board::mark::clear $board
  $text delete 1.0 end
  foreach {mark pos} [::board::mark::getEmbeddedCmds $comment] {
    foreach {type square arg color} $mark {begin end} $pos {break}  ;# set
    set square [::board::sq $square]
    regsub -all -- {[^[:alnum:]]} $color {_} _color
    switch -- $type {
      arrow   { set arg  [::board::sq $arg]
        set tags [list ${square}:${arg} ${arg}:${square} \
            ${square}:${arg}:$_color]
      }
      default { set tags [list $square ${square}:$type:$_color] }
    }
    $text insert insert [string range $comment $offset [expr {$begin-1}]]
    $text insert insert [string range $comment $begin $end] $tags
    set offset [expr {$end + 1}]
    addMark $board $type $square $arg $color 1
  }
  $text insert insert [string range $comment $offset end]
  $text mark set insert 1.0 ; # Set cursor to the top

  .commentWin.cf.text configure -undo 1
  if { $::commenteditor::showBoard == 0} {
    set bd [sc_pos board]
    ::board::update $board $bd
  }
}

### End of namespace ::commenteditor
