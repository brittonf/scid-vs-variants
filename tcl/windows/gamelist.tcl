### gamelist.tcl

# Rewritten to use the ttk::treeview widget (man ttk_treeview) by Steven Atkinson

### glistFields: code  name  anchor default-width

#  The game list fields are not user configurable except by altering it here.
#  Field order may be changed by moving their line up or down; and/or deleting/adding lines.
#  The "g" (game number) field MUST appear somewhere. 
#  The four optional fields (at bottom), may be enabled by removing the leading '#'
#  These fields are also handled in PrintGameInfo (src/index.cpp)

set glistFields {
  g Number	e 7
  w White	w 14
  b Black	w 14
  r Result	e 5
  m Length	e 5
  d Date	w 10
  e Event	w 10
  W WElo	e 5
  B BElo	e 5
  n Round	e 5
  s Site	w 10
  D Deleted	e 3
  V Variations	e 3
  C Comments	e 3
  A Annos	e 3
  o ECO		e 5
  O Opening	w 6
  U Flags	e 3
  S Start       e  3
  c Country     e  3
  E EventDate   w  7
  F EndMaterial e  7
}

### Index
# b:  Black player name
# B:  Black Elo. Prints in width of 4, ignoring specified width
# d:  Game date
# e:  Event name
# f:  Game number, filtered (e.g. 1 = first game in filter)
# g:  Game number, actual (ignoring filter)
# m:  Number of moves. Prints "##" if width < 3 and numMoves > 99
# M:  Final position material, e.g. "r1:r" for Rook+Pawn vs Rook
# n:  Round name
# o:  ECO code
# r:  Result. Prints as 1 byte (1/0/=*) or as 3 bytes (1-0, etc)
# s:  Site name
# w:  White player name
# W:  White Elo. Prints in width of 4, ignoring specified width
# y:  Year. Prints in width of 4, ignoring specified width
# ----------------------
# S:  Start position flag. Prints "S" or " " (1 byte) ignoring width
# c:  Country (last 3 chars of Site Name)
# E:  Date of Event (stored relative to)
# F:  Difference of material at game end

set ::windows::gamelist::isOpen 0
set glstart 1
set ::windows::gamelist::findtext {}
set ::windows::gamelist::goto {}

### This trace messes up some other widgets i think S.A.
# trace variable ::windows::gamelist::goto w {::utils::validate::Regexp {^[0-9]*$}}

set glistHeaders {}
set glistSortShortcuts {}
set temp_order {}
set temp_widths {}
set temp_anchors {}
set glistCodes {} 
### glistCodes is a printf format style string. A \n is used to split the main "sc_game list"
# string into a proper list for processing. It is now appended in sc_game_list
set glPieceMapping { "\u2654" "K" "\u2655" "Q" "\u2656" "R" "\u2657" "B" "\u2658" "N" "\u2659" "P" }

set i 0
foreach {code col anchor width} $glistFields {
  lappend glistHeaders $col
  lappend glistSortShortcuts $code
  lappend temp_order $i
  lappend temp_widths [expr {$width * 8}] ; # [font measure [ttk::style lookup [$w.tree cget -style] -font] "X"]
  lappend temp_anchors $anchor
  lappend glistCodes "$code* "
  incr i
}

if {! [info exists glistColOrder]} {
  set glistColOrder $temp_order
}
if {! [info exists glistColWidth]} {
  set glistColWidth $temp_widths
}
if {! [info exists glistColAnchor]} {
  set glistColAnchor $temp_anchors
}

# glistNames is set from glistFields
# Number White Black Result Length Event Round Date WElo BElo Site ECO Deleted Opening Flags Variations Comments Annos Start

# These fields are used by "sc_base sort $col {}" in proc SortBy
# (ECO/Eco case seems to differ, but not matter)
# src/index.cpp: static const char * sortCriteriaNames[] = 
# Date, Event, Site, Round, White, Black, Eco, Result, Length, Rating, WElo, BElo, Country, Month, Deleted, Eventdate, Variations, Comments

proc ::windows::gamelist::FilterText {} {
  global glstart
  variable findtext

  ::utils::history::AddEntry ::windows::gamelist::findtext $findtext
  # clear highlighted text in widget
  .glistWin.b.find selection range end end

  busyCursor .glistWin
  update

  foreach needle [split $findtext +] {
    # temp is number of items removed - currently unused
    #         sc_filter textfilter CASE_FLAG                      TEXT
    set temp [sc_filter textfilter $::windows::gamelist::findcase [string trim $needle]]
  }

  set glstart 1
  ::windows::gamelist::Refresh first
  .glistWin.tree selection set [lindex [.glistWin.tree children {}] 0]

  unbusyCursor .glistWin
}

### Rewrote this ... again. S.A
#
# Find text only matches against White/Black/Event/Site
#
# Previously it would treat "+" as a logical AND... but it's just too slow for tcl.

proc ::windows::gamelist::FindText {} {
  global glstart
  variable findtext

  ::utils::history::AddEntry ::windows::gamelist::findtext $findtext
  .glistWin.b.find selection range end end

  busyCursor .glistWin 
  update
  set temp [sc_filter textfind $::windows::gamelist::findcase $glstart $findtext]
  unbusyCursor .glistWin

  if {$temp < 1} {
    set glstart 1
    ::windows::gamelist::Refresh first
    bell
  } else {
    set glstart $temp
    ::windows::gamelist::Refresh first
    .glistWin.tree selection set [lindex [.glistWin.tree children {}] 0]
  }
}

proc ::windows::gamelist::Load {number} {
  # for some reason, number has a trailing "\n"

  set number [string trim $number "\n"]
  set ::windows::gamelist::goto $number
  ::game::Load $number
}

proc ::windows::gamelist::showCurrent {} {
  # Ooops. [sc_game number] returns 0 after sorting, making this widget useless after sorting

  set index [sc_game number]
  set ::windows::gamelist::goto $index
  .glistWin.tree selection set {}
  ::windows::gamelist::showNum $index
}

proc ::windows::gamelist::showNum {index {bell 1}} {
  global glstart glistSize
  set result [sc_filter locate $index]

  # First, check that requested game is not filtered
  if  { [sc_filter index $result] != $index \
     || $result < 1 \
     || $result > [sc_filter count]} {
    if {$bell==1} {
      flashEntryBox .glistWin.b.goto
    }
    .glistWin.tree selection set {}
  } else {
    # See if it's already on the screen
    set found 0
    foreach item [.glistWin.tree children {}] {
      if {[.glistWin.tree set $item Number] == $index} {
	set found 1
	break
      }
    }
    if {$found} {
      if {[sc_game number] != $index} {
	.glistWin.tree selection set $item
      }
    } else {
      set glstart $result

      set totalSize [sc_filter count]
      set lastEntry [expr $totalSize - $glistSize]
      if {$lastEntry < 1} {
	set lastEntry 1
      }
      if {$glstart > $lastEntry} {
	set glstart $lastEntry
      }

      # Highlights CURRENT game if on screen, otherwise game "index"
      # Even when we'd prefer just to highlight "index" :<

      set current_item [::windows::gamelist::Refresh first]
      if {$current_item == {}} {
	# Nasty, nasty recursive call... "found" above will now trigger and highlight this game
	::windows::gamelist::showNum $index $bell
      } else {
        if {[sc_game number] != $index} {
	  .glistWin.tree selection set $current_item
        }
      }
    }
  }
}

proc ::windows::gamelist::recordWidths {} {
  global glistFields glistColWidth

  set widths {}
  if {![catch {
    # Save column widths
    foreach {code col anchor width} $glistFields {
      lappend widths [.glistWin.tree column $col -width]
    }
  }]} {
    set glistColWidth $widths
  }
}

proc ::windows::gamelist::Close {window} {
  # Just do this once. Using .glistWin.tree breaks recordWidths for some reason.
  if {$window == {.glistWin.f}} {
    ::windows::gamelist::recordWidths
    # bind .glistWin <Destroy> {}
    set ::windows::gamelist::isOpen 0
  } 
}

proc ::windows::gamelist::Open {} {

  ### ttk::style theme use alt
  # default classic alt clam

  global highcolor helpMessage
  global glistSortedBy glSortReversed glistSize

  set w .glistWin

  if {[winfo exists $w]} {
    raiseWin $w
    return
  }

  ::createToplevel $w

  wm iconname $w "[tr WindowsGList]"
  wm minsize $w 300 160

  ### Hmmm - throws errors on OSX, windows
  if {!$::docking::USE_DOCKING || !$::macOS}  {
    catch {wm withdraw $w}
  }

  setWinLocation $w
  setWinSize $w
  ::windows::gamelist::SetSize

  standardShortcuts $w
  bind $w <F1> { helpWindow GameList }
  bind $w <Destroy> { ::windows::gamelist::Close %W}
  bind $w <Control-Tab> {::file::SwitchToNextBase ; break}
  bind $w <Control-c> copyGame
  bind $w <Control-v> pasteGame
  catch {
    if {$::windowsOS} {
      bind $w <Shift-Tab> {::file::SwitchToNextBase -1 ; break}
    } else {
      bind $w <ISO_Left_Tab> {::file::SwitchToNextBase -1 ; break}
    }
  }
  bind $w <Control-Key-quoteleft> {::file::SwitchToBase 9}
  bind $w <Escape> "destroy $w"

  set ::windows::gamelist::isOpen 1

  ### Frames

  frame $w.b
  frame $w.f
  ttk::treeview $w.tree -columns $::glistHeaders -displaycolumns $::glistColOrder -show headings -xscroll "$w.hsb set"
    # -yscroll "$w.vsb set" -xscroll "$w.hsb set"

  # title font isn't working &&& I don't think it's configurable !
  $w.tree tag configure treetitle -font font_H1

  # this font is working, but doesn't affect how many entries fit on a screen, and isn't enabled
  $w.tree tag configure treefont -font font_Regular
  bind $w.tree <Button-2> {
    set ::windows::gamelist::showButtons [expr {!$::windows::gamelist::showButtons}]
    ::windows::gamelist::displayButtons
  }
  bind $w.tree <Button-3> {
    ::windows::gamelist::Popup %W %x %y %X %Y
  }
  $w.tree tag bind click2 <Double-Button-1> {::windows::gamelist::Load [%W set [%W focus] Number]}
  $w.tree tag configure deleted -foreground gray50
  $w.tree tag configure current_deleted -foreground SteelBlue
  $w.tree tag configure error -foreground red
  # bind $w.tree <ButtonRelease-1> { parray ::ttk::treeview::State}

  # Hmm... seems no way to change the deafult blue bg colour for selected items
  # without using (extra) tags. So this colour must look ok with a blue background

  ::windows::gamelist::checkAltered

  if {$::enableBackground} {
    ::ttk::style configure Treeview -background $::defaultBackground
    ::ttk::style configure Treeview -fieldbackground $::defaultBackground
  }

  # $w.tree tag configure colour -background $::defaultBackground
  # $w.tree tag bind click1 <Button-1> {}

  if {$::buggyttk} {
    # Using tk::scale has a hiccup because the line "set glstart $::glistStart($b)" in gamelist::Reload fails
    # So switching between bases with wish-8.5.10 doesn't remember which games we're looking at
    # Also, "find" doesn't find things on the last page.
    scale  $w.vsb -from 1 -orient vertical -variable glstart -showvalue 0 -command ::windows::gamelist::SetStart -bigincrement $glistSize -relief flat
  } else {
    ttk::scale $w.vsb -orient vertical -command ::windows::gamelist::SetStart -from 1 -variable glstart
    # -sliderlength 200  ; It'd be nice to make the slider big sometimes, but unsupported in ttk::scale
  }

  # -borderwidth 0
  ttk::scrollbar $w.hsb -orient horizontal -command "$w.tree xview"

  pack $w.f -fill both -expand 1
  ::windows::gamelist::displayButtons 

  grid $w.tree $w.vsb -in $w.f -sticky nsew
  grid $w.hsb         -in $w.f -sticky nsew
  grid column $w.f 0 -weight 1
  grid row    $w.f 0 -weight 1

  ### Init the ttk_treeview column titles

  set font [ttk::style lookup [$w.tree cget -style] -font]

  foreach col $::glistHeaders width $::glistColWidth anchor $::glistColAnchor {
      # No sort implemented for these columns
      if {[lsearch {Number Opening Flags Annos Start EndMaterial} $col] == -1} {
	$w.tree heading $col -command [list SortBy $w.tree $col]
      } 
      $w.tree column $col -width $width -anchor $anchor -stretch 0
  }

  ::windows::gamelist::setColumnTitles

  set glistSortedBy {}
  set glSortReversed 0

  bind $w <Left>  {}
  bind $w <Right> {}
  bind $w <Up>  {}
  bind $w <Down> {}
  bind $w.tree <Left>  "$w.tree xview scroll -40 units ; break"
  bind $w.tree <Right> "$w.tree xview scroll 40 units ; break"
  bind $w.tree <Up>    {::windows::gamelist::Scroll -1 ; break}
  bind $w.tree <Down>  {::windows::gamelist::Scroll  1 ; break}
  bind $w <Prior> {::windows::gamelist::Scroll -$glistSize}
  bind $w <Control-a> {.glistWin.tree selection set [.glistWin.tree children {}]}
  bind $w <Home> {
    set glstart 1
    ::windows::gamelist::Refresh first
  }
  bind $w <End> {
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
  bind $w <Next>  {
    incr glstart $glistSize
    set totalSize [sc_filter count]
    set lastEntry [expr $totalSize - $glistSize]
    if {$lastEntry < 1} {
      set lastEntry 1
    }
    if {$glstart > $lastEntry} {
      set glstart $lastEntry
    }
    ::windows::gamelist::Refresh first
  }
  # MouseWheel bindings:
  # bind $w <MouseWheel> {::windows::gamelist::Scroll [expr {- (%D / 120)}]}
  if {$::windowsOS || $::macOS} {
    # Does this work fine on OSX ?
    # http://sourceforge.net/tracker/?func=detail&aid=2931538&group_id=12997&atid=112997
    bind $w <Shift-MouseWheel> {break}
    bind $w <MouseWheel> {
      if {[expr -%D] < 0} { ::windows::gamelist::Scroll -1}
      if {[expr -%D] > 0} { ::windows::gamelist::Scroll 1}
    }
    bind $w <Control-MouseWheel> {
      if {[expr -%D] < 0} { ::windows::gamelist::Scroll -$glistSize}
      if {[expr -%D] > 0} { ::windows::gamelist::Scroll $glistSize}
    }
  } else {
    bind $w <Shift-Button-4> "$w.tree xview scroll -40 units"
    bind $w <Shift-Button-5> "$w.tree xview scroll 40 units"
    bind $w <Button-4> {::windows::gamelist::Scroll -1}
    bind $w <Button-5> {::windows::gamelist::Scroll 1}
    bind $w <Control-Button-4> {::windows::gamelist::Scroll -$glistSize}
    bind $w <Control-Button-5> {::windows::gamelist::Scroll $glistSize}
  }

  bind $w <Control-r> ::search::filter::reset
  bind $w <Control-n> ::search::filter::negate

  foreach i { <Control-Home> <Control-End> <Control-Down> <Control-Up> <Control-question>} {
    bind .glistWin $i +::windows::gamelist::showCurrent
  }

  ### One row of buttons, etc

  button $w.b.save -image tb_save -relief flat -command {
    if {[sc_game number] != 0} {
      gameReplace
    } else {
      gameAdd
    }
  }
  # Quick save is right click
  bind $w.b.save <Button-3> {
    if {[%W cget -state] != "disabled"} {gameQuickSave}
  }


  button $w.b.bkm -relief flat -image tb_bkm
  bind   $w.b.bkm <ButtonPress-1> "tk_popup .main.tb.bkm.menu %X %Y ; break"

  button $w.b.gfirst -image tb_gfirst -relief flat -command "
    event generate $w.tree <Home>
    ::game::LoadNextPrev first 0"
  button $w.b.gprev -image tb_gprev -relief flat -command {::game::LoadNextPrev previous 0 ; ::windows::gamelist::showCurrent}
  button $w.b.gnext -image tb_gnext -relief flat -command {::game::LoadNextPrev next 0 ; ::windows::gamelist::showCurrent}
  button $w.b.glast -image tb_glast -relief flat -command "
    event generate $w.tree <End>
   ::game::LoadNextPrev last 0"

  set ::windows::gamelist::goto {}

  button $w.b.select -textvar ::tr(SetFilter) -font font_Small -relief flat -command {
    set items [.glistWin.tree selection]
    if { "$items" == "" } {
      bell
    } else {
      sc_filter reset
      # remove the select items (Hmmm... will reset ply value though :-( )
      foreach i $items {
	sc_filter remove [.glistWin.tree set $i Number]
      }
      sc_filter negate
      set glstart 1
      ::windows::gamelist::Refresh
    }
  }

  ### Filter items
  button $w.b.remove -textvar ::tr(GlistRemoveThisGameFromFilter) -font font_Small -relief flat -command ::windows::gamelist::Remove
  # Trim extra space from this crowded frame
  if {!$::windowsOS} {
    $w.b.remove configure -width 5
    $w.b.select configure -width 5
  }
  bind $w.tree <Delete> "::windows::gamelist::Remove 1"
  bind $w.tree <Control-Delete> "$w.b.delete invoke"

  button $w.b.removeabove -text Rem -image arrow_up -compound right -font font_Small -relief flat -command {::windows::gamelist::removeFromFilter up}
  button $w.b.removebelow -text Rem -image arrow_down -compound right -font font_Small -relief flat -command {::windows::gamelist::removeFromFilter down}
  button $w.b.reset -textvar ::tr(Reset) -font font_Small -relief flat -command ::search::filter::reset
  button $w.b.negate -text [lindex [tr SearchNegate] 0] -font font_Small -relief flat -command ::search::filter::negate

  ### Filter items against the find entry widget
  button $w.b.filter -font font_Small -relief flat -textvar ::tr(Filter) \
    -command {::windows::gamelist::FilterText}

  # button $w.b.findlabel -font font_Small -relief flat -textvar ::tr(GlistFindText) \
  #   -command {::windows::gamelist::FindText}

  # button $w.b.findall -font font_Small -relief flat -text "Find All" \
  #   -command {::windows::gamelist::FindText}

  ttk::combobox $w.b.find -width 10 -font font_Small -textvariable ::windows::gamelist::findtext
  ::utils::history::SetCombobox ::windows::gamelist::findtext $w.b.find
  bind $w <Control-f> "focus $w.b.find"

  # didn't use to work
  # ::utils::history::SetLimit ::windows::gamelist::findtext 5
  # ::utils::history::PruneList ::windows::gamelist::findtext

  bind $w.b.find <Control-Return> {::game::Load $::glstart}
  bind $w.b.find <Return> {::windows::gamelist::FindText}
  bind $w.b.find <Home> "$w.b.find icursor 0; break"
  bind $w.b.find <End> "$w.b.find icursor end; break"

  checkbutton $w.b.findcase -textvar ::tr(IgnoreCase) -font font_Small \
    -variable ::windows::gamelist::findcase -onvalue 1 -offvalue 0

  entry $w.b.goto -width 8 -justify right -textvariable ::windows::gamelist::goto -font font_Small -highlightthickness 0
  bind $w.b.goto <Return> {
    ::windows::gamelist::showNum $::windows::gamelist::goto
  }
  bind $w.b.goto <Control-Return> {
    ::windows::gamelist::showNum $::windows::gamelist::goto
    .glistWin.b.load invoke
  }
  dialogbutton $w.b.browse -text $::tr(Browse) -font font_Small -command {
    set selection [.glistWin.tree selection]
    if { $selection != {} } {
      ::gbrowser::new 0 [.glistWin.tree set [lindex $selection 0] Number]
    }
  }

  dialogbutton $w.b.current -font font_Small -textvar ::tr(Current) -command ::windows::gamelist::showCurrent

  # no longer packed, but still used as Control-Enter binding
  dialogbutton $w.b.load -text Load -font font_Small -command {
    set selection [.glistWin.tree selection]
    if { $selection != {} } {
      ::windows::gamelist::Load [.glistWin.tree set [lindex $selection 0] Number]
    }
  }

  dialogbutton $w.b.delete -text $::tr(Delete) -font font_Small -command {
    ::windows::gamelist::ToggleFlag D
    ::windows::gamelist::Refresh
    configDeleteButtons
  }

  dialogbutton $w.b.compact -text [lindex $::tr(CompactDatabase) 0] -font font_Small -command "compactGames $w ; configDeleteButtons"
  configDeleteButtons

  dialogbutton $w.b.help  -textvar ::tr(Help) -width 5 -font font_Small -command { helpWindow GameList }
  dialogbutton $w.b.close -textvar ::tr(Close) -font font_Small -command { focus .main ; destroy .glistWin }

  pack $w.b.close $w.b.findcase $w.b.find $w.b.filter $w.b.negate $w.b.reset -side right
  pack $w.b.save $w.b.bkm $w.b.gfirst $w.b.gprev $w.b.gnext $w.b.glast -side left

  pack $w.b.current $w.b.goto -side left -padx 3
  pack $w.b.compact -side right -padx 3

  if {$::windowsOS} {
    # cant focus entry combo on windows as it hogs the wheelmouse
    focus $w.tree
  } else {
    # focus entry box
    focus $w.b.find
  }

  # hacks to disable the down/page-down keys for combobox
  bind  $w.b.find <Down> "focus $w.tree ; event generate $w.tree <Down> ; break"
  bind  $w.b.find <End>  "focus $w.tree ; event generate $w.tree <End> ; break"

  # Try to show the current game if opening for the first time - but not working yet.
  # (Also look at how bookmakrs are opened)
  if {0} {
    if {$::windows::gamelist::goto == {}} {
      ::windows::gamelist::showCurrent
    } else {
      set ::windows::gamelist::goto 1
    }
  }

  set ::windows::gamelist::goto 1

  ::windows::gamelist::Refresh
  ::windows::switcher::Open
  catch {wm state $w normal}
  ::createToplevelFinalize $w

  bind $w <Configure> {::windows::gamelist::Configure %W }
}

proc ::windows::gamelist::setColumnTitles {} {
  foreach {code col anchor null} $::glistFields {
    if {[info exists ::tr(Glist$col)]} {
      set name $::tr(Glist$col)
    } else {
      set name $col
    }
    .glistWin.tree heading $col -text $name
  }
}

proc ::windows::gamelist::Popup {w x y X Y} {

  global maintFlags maintFlaglist glistHeaders

  # Identify region requires at least tk 8.5.9 (?)

  if { [catch {set region [$w identify region $x $y] }] } {
    if {[$w identify row $x $y] == "" } {
      set region "heading"
    } else {
      set region ""
    }
  }

  if { $region == "heading" } {

    ### Titles context menu

    set w .glistWin.tree
    set col [$w identify column $x $y]
    set col_idx [lsearch -exact $::glistHeaders [$w column $col -id] ]

    set menu .glistWin.context
    if { [winfo exists $menu] } {destroy $menu}
    if { [winfo exists $menu.addcol] } {destroy $menu.addcol}
    menu $menu -tearoff 0
    menu $menu.addcol -tearoff 0

    # Column menus
    $menu.addcol delete 0 end
    set i 0
    foreach h $::glistHeaders {
        $menu.addcol add command -label $::tr(Glist$h) -command "::windows::gamelist::insertCol $w $i $col"
      incr i
    }
    $menu add cascade -label $::tr(GlistAddField) -menu $menu.addcol
    $menu add command -label $::tr(GlistRemoveThisGameFromFilter) -command "::windows::gamelist::removeCol $w $col"

    $menu add separator

    $menu add command -label $::tr(GlistAlignL) \
		   -command "$w column $col -anchor w; lset ::glistColAnchor $col_idx w"
    $menu add command -label $::tr(GlistAlignR) \
		   -command "$w column $col -anchor e; lset ::glistColAnchor $col_idx e"
    $menu add command -label $::tr(GlistAlignC) \
		   -command "$w column $col -anchor c; lset ::glistColAnchor $col_idx c"

    $menu add separator
    $menu add command -label $::tr(Reset) -command "::windows::gamelist::resetCols $w"

    tk_popup $menu $X $Y

  } else {

    ### Gamelist context menus

    set row [$w identify row $x $y]
    set selection [$w selection]

    if {$row == "" } {
      return
    }

    if {[lsearch $selection $row] == -1 || [llength $selection] == 1} {
      set menutype full
      event generate $w <ButtonPress-1> -x $x -y $y
    } else {
      set menutype short
    }

    # set number [$w set [$w focus] Number]
    # set number [string trim $number "\n"]

    ### nb - redefined $w here

    set w .glistWin
    set menu .glistWin.context

    if { [winfo exists $menu] } {
      destroy $menu
    }

    menu $menu -tearoff 0

    if {$menutype == "short"} {
    $menu add command -label $::tr(GlistRemoveThisGameFromFilter) -command ::windows::gamelist::Remove
    $menu add command -label $::tr(GlistDeleteField) -command "$w.b.delete invoke"
    $menu add cascade -label $::tr(Flag)      -menu $menu.flags
    $menu add command -label $::tr(SetFilter) -command "$w.b.select invoke"
    $menu add separator
    $menu add command -label $::tr(Reset) -command "$w.b.reset invoke"
    } else {
    $menu add command -label $::tr(LoadGame) -command "$w.b.load invoke"
    $menu add command -label $::tr(Browse) -command "$w.b.browse invoke"
    $menu add command -label $::tr(GlistDeleteField) -command "$w.b.delete invoke"
    $menu add cascade -label $::tr(Flag)      -menu $menu.flags
    $menu add command -label $::tr(SetFilter) -command "$w.b.select invoke"
    $menu add separator
    $menu add command -label $::tr(GlistRemoveThisGameFromFilter) -command ::windows::gamelist::Remove
    $menu add command -label $::tr(GlistRemoveGameAndAboveFromFilter) -command "$w.b.removeabove invoke"
    $menu add command -label $::tr(GlistRemoveGameAndBelowFromFilter) -command "$w.b.removebelow invoke"
    $menu add command -label $::tr(Reset) -command "$w.b.reset invoke"
    }
    menu $menu.flags -tearoff -1
    foreach flag $maintFlaglist  {
      # dont translate CustomFlag (todo)
      if {$flag ni {1 2 3 4 5 6}} {
	set tmp $::tr($maintFlags($flag))
      } else {
	set tmp [sc_game flag $flag description]
	if {$tmp == "" } {
	  set tmp "Custom $flag"
	} else {
	  set tmp "$tmp ($flag)"
	}
      }
      $menu.flags add command -label "$tmp" -command "::windows::gamelist::ToggleFlag $flag"
    }

    tk_popup $menu [winfo pointerx .] [winfo pointery .]
  }
}

# These two procs and related snippets derived from SCID, copyright (C) Fulvio Benini

proc ::windows::gamelist::insertCol {w col after} {
  set b [expr [string trimleft $after {#}]]
  set d [lsearch -exact $::glistColOrder $col]
  set ::glistColOrder [linsert $::glistColOrder $b $col]
  if {$d > -1} {
    if {$d > $b} {
      incr d
    }
    set ::glistColOrder [lreplace $::glistColOrder $d $d]
  }
  $w configure -displaycolumns $::glistColOrder
}

proc ::windows::gamelist::removeCol {w col} {
  set d [expr [string trimleft $col {#}] -1]
  set ::glistColOrder [lreplace $::glistColOrder $d $d]
  $w configure -displaycolumns $::glistColOrder
}

proc ::windows::gamelist::resetCols {w} {
  global glistColOrder glistColWidth glistColAnchor

  set i 0
  set glistColOrder {}
  set glistColWidth {}
  set glistColAnchor {}
  foreach {code col anchor width} $::glistFields {
    lappend glistColOrder $i
    lappend glistColWidth [expr {$width * 8}]
    lappend glistColAnchor $anchor
    $w column $col -anchor $anchor
    incr i
  }
  $w configure -displaycolumns $glistColOrder
}


proc ::windows::gamelist::Remove {{shownext 0}} {
  set w .glistWin.tree
  set items [$w selection]
  foreach i $items {
    sc_filter remove [$w set $i Number]
  }
  set gl_num [$w set [$w next [lindex $items end]] Number]
  $w delete $items

  ::windows::stats::Refresh
  ::windows::gamelist::Refresh
  if {$shownext} {
    ::windows::gamelist::showNum $gl_num nobell
  }
}

proc ::windows::gamelist::displayButtons {} {
  set w .glistWin
  if {$::windows::gamelist::showButtons} {
    pack $w.b -side bottom -fill x -padx 5 -before $w.f
  } else {
    pack forget $w.b
  }
}

proc ::windows::gamelist::Configure {window} {
  if {$window == {.glistWin.tree}} {
    recordWidths
    recordWinSize .glistWin
    ::windows::gamelist::Refresh
  }
}

proc ::windows::gamelist::checkAltered {} {
  set w .glistWin.tree
  if {![winfo exists $w]} {
    return
  }
  if {[sc_game number] == 0} {
    catch {
      # wish <= 8.5.8 doesnt have treeview tag remove
      $w tag remove current
    }
  }
  if {[sc_game altered]} {
    # It is impossible to signify the current game with a red foreground and blue background
    # because internally it is part of treeviews "selection", which may span multiple childs
    $w tag configure current -foreground red
    $w tag configure current_deleted -foreground indianred3
  } else {
    if {$::macOS} {
      # Hmmm - now we arent highlighting current games with selection, use blue2 to work with deleted tag
      # OSX treeview selection colour is different
    }
    $w tag configure current -foreground blue2
    $w tag configure current_deleted -foreground SteelBlue
  }
}

proc configDeleteButtons {} {
  # also check the Flag button
  set w .glistWin
  # debug puts [sc_base current] &&&
  if {[sc_base current] == [sc_info clipbase]} {
    ### Can't compact clipbase
    $w.b.compact configure -state disabled
    $w.b.delete configure -state normal
  } elseif {[sc_base isReadOnly]} {
    $w.b.delete configure -state disabled
    $w.b.compact configure -state disabled
  } else {

    ### do we want to always check the delete and flag buttons ? &&&
    #  if {[.glistWin.tree selection] == ""} disable delete, flag
    # $w.tree tag bind click <Button-1> {configDeleteButtons}

    $w.b.delete configure -state normal
    $w.b.compact configure -state normal
  }
}

proc ::windows::gamelist::Scroll {nlines} {
  global glstart

  incr glstart $nlines
  if {$nlines < 0} {
  ::windows::gamelist::Refresh last
  } else {
  ::windows::gamelist::Refresh first
  }
}

proc ::windows::gamelist::SetSize {} {
  global glistSize glFontHeight 

  ### Figure out how many lines of text in the treeview widget
  ### This is probably broke on some platforms

  ### "treeview configure -rowheight" might work better, but is only in cvs
  ### also consider "[$w bbox [lindex [$w children {}] 0]]" 

  set w .glistWin.tree
  if {![winfo exists $w]} {return}

if {0} {
  if {![info exists glFontHeight]} {
    set fontspace [font metrics [ttk::style lookup [$w cget -style] -font] -linespace]
    # Nasty hack to make things work
    if {$::windowsOS} {
      set glFontHeight [expr $fontspace*125/72]
    } elseif {$::macOS} {
      set glFontHeight [expr $fontspace*92/72]
    } else {
      set glFontHeight [expr $fontspace*106/72]
    }
  }
  # $glFontHeight ~ 22 linux

  # set glistSize [expr {[winfo height $w] / $glFontHeight +([winfo height $w]-300)/200}]
}
  # hardcoded in ttkTreeview.c to (20 pixels high + 1 pixel padding ) - 1 row for title.
  set glistSize [expr {int([winfo height $w] / 21)-1}]

  # debugging voodoo
  # puts "glistSize $glistSize , winfo height [winfo height $w]"
  # 700 = +2 # 100 = -1
}

image create photo arrow_up -format gif -data {
R0lGODlhCgAKAIABAAAAAP///yH5BAEKAAEALAAAAAAKAAoAAAIPjI+pq8AA
G4xnWmMz26gAADs=
}

image create photo arrow_down -format gif -data {
R0lGODlhCgAKAIABAAAAAP///yH5BAEKAAEALAAAAAAKAAoAAAIPjI+pa+D/
GnRoqrgA26wAADs=
}

image create photo arrow_updown -format gif -data {
R0lGODlhCgAKAKECAAAAAIKCgv///////yH5BAEKAAIALAAAAAAKAAoAAAIU
lAVxC63c3DJpnmrRsxjGTUkcWAAAOw==
}

image create photo arrow_close -format gif -data {
R0lGODlhDAAMAIABAAAAAP///yH5BAEKAAEALAAAAAAMAAwAAAIVjI+pCQjt
4FtvrmBp1SYf2IHXSI4FADs=
}

### Array recording which databases have been sorted, and which field and order

array set glistSortColumn {}
array set glistStart {}
array set glistFlipped {} ; # should actually be named isFlipped... but is used similarly to glistStart
set glistFlipped([sc_info clipbase]) 0

# There is no other mechanism to remember last database sort, but there should
# probably be one in "tkscid.h::struct scidBaseT".
# "glistSortColumn" is currently not persistent.  It could be done, but isn't
# trivial as a problem with having a history is that it gets complicated when
# handling read-only PGNs

proc SortBy {tree col} {
    global glistSortedBy glstart glSortReversed glistSortColumn

    set w .glistWin

    # hmmm. a few fields are not valid sorting.

    # if {[sc_base numGames] > 200000} 
    if {![sc_base isReadOnly] && [sc_base current] != [sc_info clipbase]} {
      if {[info exists ::tr(Glist$col)]} {
        set name $::tr(Glist$col)
      } else {
        set name $col
      }
      set answer [tk_messageBox -parent $w -title "Scid" -type yesno -default yes -icon question \
          -message "[tr GlistSort] \"[file tail [sc_base filename]]\" by $name ?"]
      if {$answer != "yes"} { return }
    }

    if {$col == $glistSortedBy} {
      set glSortReversed [expr !$glSortReversed]
    } else {
      set glSortReversed 0

      # clear previous arrows
      if {$glistSortedBy != {} } {
	$w.tree heading $glistSortedBy -image {}
      }

      set glistSortedBy $col
    }

    set glistSortColumn([sc_base current]) [list $col $glSortReversed]

    if {$glSortReversed} {
      sc_base sortdown
    } else {
      sc_base sortup
    }

    busyCursor .
    update

    # This catch is annoying, but if we remove it, how do we unbusyCursor when sort fails ?
    catch {sc_base sort $col {}}

    unbusyCursor .
    updateBoard
    set glstart 1
    ::windows::gamelist::Refresh
}


proc setGamelistTitle {} {
  set fname [file tail [sc_base filename]]
  if {![string match {\[*\]} $fname]} {
    set fname "\[$fname\]"
  }

  setTitle .glistWin "[tr WindowsGList]: $fname [sc_filter count]/[sc_base numGames] $::tr(games)" 
}

# called by file.tcl when db is changed

proc ::windows::gamelist::Reload {} {
  global glistSortedBy glstart

  set b [sc_base current]

  if {[info exists ::glistStart($b)]} {
    set glstart $::glistStart($b)
  }
  if {[info exists ::glistFlipped($b)]} {
    if {$::glistFlipped($b) != [::board::isFlipped .main.board]} {
      toggleRotateBoard
    }
  } else {
    # puts "Oops - glistFlipped($b) not intialised"
  }

  set w .glistWin
  if {![winfo exists $w]} {return}

  if {$glistSortedBy != {} } {
    $w.tree heading $glistSortedBy -image {}
  }

  set glistSortedBy {}
  sc_base sortup
  ::windows::gamelist::Refresh
}

# Returns the treeview item for current game (if it is shown in widget)

proc ::windows::gamelist::Refresh {{see {}}} {
  global glistCodes glstart glistSize glistSortColumn glistSortedBy glistStart glPieceMapping

  set w .glistWin
  if {![winfo exists $w]} {return}

  set b [sc_base current]

  if {[info exists glistSortColumn($b)]} {

    foreach {col glSortReversed} $glistSortColumn($b) {}
    set glistSortedBy $col
    if {$glSortReversed} {
	$w.tree heading $col -image arrow_down
    } else {
	$w.tree heading $col -image arrow_up
    }
  } else {
    # clear previous arrows
    if {$glistSortedBy != {} } {
      $w.tree heading $glistSortedBy -image {}
    }
  }

  ::windows::gamelist::SetSize

  updateStatusBar
  $w.tree delete [$w.tree children {}]

  # check boundries !
  set totalSize [sc_filter count]

  if {$glstart < 1} {
    set glstart 1
  }
  if {$glstart == 1} {
    set see first
  }
  if {$glstart > $totalSize} {
    set glstart $totalSize
  }
  set glistStart($b) $glstart

  set glistEnd [expr $glstart + $glistSize]
  if { $glistEnd > $totalSize} {
    set glistEnd $totalSize
  }

  set current_item {}
  set current [sc_game number]

  ### sc_game_list now returns a string with NEWLINES which we use to split into a list
  ### It will probably break/misbehave if somehow a NEWLINE gets into the database.

  if {$glistEnd < $glstart} {
    set glistEnd $glstart
  }

  set c [expr $glistEnd - $glstart + 1]

  set chunk [sc_game list $glstart $c $glistCodes]
  # remove trailing "\n"
  set chunk [string range $chunk 0 end-1]

  set  VALUES [split $chunk "\n"]
  set i [llength $VALUES]

  # reverse insert for speed-up

  for {set line $glistEnd} {$line >= $glstart} {incr line -1} {
    incr i -1
    set values [lindex $VALUES $i]
    # Substitute figurine letters, because
    # - convertFrom will destroy the content
    # - standard figurine pieces are looking ugly
    set values [string map $glPieceMapping $values]
    set values [encoding convertfrom $values]

    if {[catch {set thisindex [lindex $values 0]}]} {
      ### Mismatched brace in game values. Bad!
      # Scid's gamelist handles it ok, but game causes errors in other places
      set thisindex [string range $values 1 [string first " " $values]]
      $w.tree insert {} 0 -values [list $thisindex {Unmatched brace} {in game}] -tag [list click2 error]
    } else {
      if {$thisindex == "$current "} {
	if {[lindex $values 11] == {D }} {
	  set current_item [$w.tree insert {} 0 -values $values -tag [list click2 current_deleted]]
        } else {
	  set current_item [$w.tree insert {} 0 -values $values -tag [list click2 current]]
        }
      } elseif {[lindex $values 11] == {D }} {
	$w.tree insert {} 0 -values $values -tag [list click2 deleted] ;#treefont
      } else {
	$w.tree insert {} 0 -values $values -tag click2
      }
    }
  }

  ## first and last attempts to work around it's hard to know how many lines fit in ttk::treeview
  ## but isnt working properly S.A
  # if {$see == {first}} 

  $w.tree see [lindex [.glistWin.tree children {}] 0]

  # if {$see == {last}} { $w.tree see [lindex [.glistWin.tree children {}] end] } 

  setGamelistTitle

  set to [expr $totalSize - $glistSize]
  if {$to < 1} {
    set to 1
  }
  $w.vsb configure -to $to

  configDeleteButtons
  ::windows::switcher::Refresh
}

proc ::windows::gamelist::SetStart {unit} {
  global glstart

  set glstart [expr {int($unit)}]

  after cancel {::windows::gamelist::Refresh first}
  after idle {::windows::gamelist::Refresh first}
}

proc ::windows::gamelist::ToggleFlag {flag} {
  set current [sc_game number]
  set current_changed 0

  set sel [.glistWin.tree selection]
  if { "$sel" == "" } {
    bell
  } else {
    foreach item $sel {
      # mark item as "flag"
      # (very slow doing them one at a time)
      # (todo: change sc_game_flag to allow multiple games (?))
      set number [.glistWin.tree set $item Number]
      if {"$number" == "$current"} {
        set current_changed 1
      }
      catch {sc_game flag $flag $number invert}

      if {$flag == {D}} {
	# toggle treeview delete field
	set deleted [.glistWin.tree set $item Deleted]
	if {$deleted == {D }} {
	  set deleted {  }
	} else {
	  set deleted {D }
	}
	.glistWin.tree set $item Deleted $deleted
      } else {
	.glistWin.tree set $item Flags "[string map {D {}} [sc_flags $number]] "
      }
    }
    # ::windows::gamelist::Refresh
    if {$current_changed} {
      updateStatusBar
    }
  }
}

### Remove from filter all games above or below the selected item(s)

proc ::windows::gamelist::removeFromFilter {dir} {

  set i [.glistWin.tree selection]

  set gl_num [.glistWin.tree set $i Number]

  if {$gl_num < 1} { return }
  if {$gl_num > [sc_base numGames]} { return }
  if {$dir == {up}} {
    sc_filter remove 1 [expr $gl_num - 1]
  } else {
    sc_filter remove [expr $gl_num + 1] $::MAX_GAMES
  }

  ::windows::stats::Refresh
  ::windows::gamelist::Refresh
  ::windows::gamelist::showNum $gl_num nobell
}


### end of gamelist.tcl
