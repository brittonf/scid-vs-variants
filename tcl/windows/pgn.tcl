############################################################
# Start of pgn.tcl
#

namespace eval pgn {

  ################################################################################
  # truetype support
  ################################################################################
  set graphFigurineInComments 0
  set substUnicode(normal)  { "\u2654" "<f>\u2654</f>"
                              "\u2655" "<f>\u2655</f>"
                              "\u2656" "<f>\u2656</f>"
                              "\u2657" "<f>\u2657</f>"
                              "\u2658" "<f>\u2658</f>"
                              "\u2659" "<f>\u2659</f>"
                            }
  set substUnicode(bold)    { "\u2654" "<fb>\u2654</fb>"
                              "\u2655" "<fb>\u2655</fb>"
                              "\u2656" "<fb>\u2656</fb>"
                              "\u2657" "<fb>\u2657</fb>"
                              "\u2658" "<fb>\u2658</fb>"
                              "\u2659" "<fb>\u2659</fb>"
                            }
  set substPlaceHolders     { "\\K\\" "<f>\u2654</f>" "\\Q\\" "<f>\u2655</f>" "\\R\\" "<f>\u2656</f>"
                              "\\B\\" "<f>\u2657</f>" "\\N\\" "<f>\u2658</f>" "\\P\\" "<f>\u2659</f>"
                            }

  ################################################################################
  #
  ################################################################################
  proc ChooseColor {type name} {
    global pgnColor
    set x [tk_chooseColor -initialcolor $pgnColor($type) \
        -title "PGN $name color"  -parent .pgnWin]
    if {$x != ""} { set pgnColor($type) $x; ::pgn::ResetColors }
  }
  ################################################################################
  #
  ################################################################################
  proc ConfigMenus {} {
    if {! [winfo exists .pgnWin]} { return }
    set lang $::language
    set m .pgnWin.menu
    foreach idx {0 1 2 3} tag {PgnFile PgnOpt PgnColor PgnHelp} {
      configMenuText $m $idx $tag $lang
    }
    foreach idx {0 1 3} tag {PgnFilePrint PgnFileCopy PgnFileClose} {
      configMenuText $m.file $idx $tag $lang
    }
    foreach idx {1 2 3 4 5 6 7 8 9 11 12} tag {
      PgnOptShort PgnOptColumn PgnOptColor PgnOptIndentC PgnOptIndentV PgnOptBoldMainLine PgnOptSpace PgnOptSymbols PgnOptStripMarks PgnOptChess PgnOptScrollbar
    } {
      configMenuText $m.opt $idx $tag $lang
    }
    foreach idx {1 2 3 4 5 6} tag {PgnColorHeader PgnColorAnno PgnColorComments PgnColorVars PgnColorBackground PgnColorCurrent} {
      configMenuText $m.color $idx $tag $lang
    }
    foreach idx {0 1} tag {PgnHelpPgn PgnHelpIndex} {
      configMenuText $m.help $idx $tag $lang
    }
  }
  ################################################################################
  #
  ################################################################################
  proc PrepareForDisplay {str} {
    global useGraphFigurine

    if {$useGraphFigurine} {
      global graphFigurineWeight
      variable graphFigurineInComments
      variable substPlaceHolders
      variable substUnicode

      if {$graphFigurineInComments} {
        regsub -all {([KQRBNP])([a-h1-8])?(x)?([a-h][1-8])} $str {\\\1\\\2\3\4} str
        regsub -all {([a-h][1-8]=)([KQRBN])} $str {\1\\\2\\} str
      }

      if {!$::pgn::boldMainLine || $graphFigurineWeight(bold) eq "normal"} {
        set str [string map $substUnicode(normal) $str]
      } else {
        # split into chunks: "..." "<var>...</var>" "..." "<var>...</var>" "..."
        # take nested variations into account
        set chunks {}
        set start 0
        set n1 [string first "<var>" $str]
        while {$n1 >= 0} {
          set n [expr {$n1 + 5}]
          set n2 [string first "<var>"  $str $n]
          set n3 [string first "</var>" $str $n]
          while {$n2 >= 0 && $n2 < $n3} {
            # we have nested variations
            set n2 [string first "<var>"  $str [expr {$n2 + 5}]]
            set n3 [string first "</var>" $str [expr {$n3 + 5}]]
          }
          if {$n3 == -1} {
            # Oops: string is corrupt (should never happen)
            set n1 -1
          } else {
            lappend chunks bold [string range $str $start $n1]
            lappend chunks normal [string range $str [expr {$n1 + 1}] $n3]
            set start [expr {$n3 + 1}]
            set n1 $n2
          }
        }
        lappend chunks bold [string range $str $start end]
        # re-build string concatenating the chunks
        set str ""
        foreach {weight part} $chunks {
          append str [string map $substUnicode($weight) $part]
        }
      }

      if {$graphFigurineInComments} {
        set str [string map $substPlaceHolders $str]
      }
    }

    return $str
  }


  proc Open {} {
    global pgnHeight pgnWidth pgnColor
    set w .pgnWin

    if {[winfo exists $w]} {
      raiseWin $w
      return
    }

    ::createToplevel $w

    wm minsize $w 18 4
    setWinLocation $w
    setWinSize $w

    menu $w.menu
    ::setMenu $w $w.menu

    foreach i {file opt color help} label {PgnFile PgnOpt PgnColor PgnHelp} tear {0 1 1 0} {
      $w.menu add cascade -label $label -menu $w.menu.$i -underline 0
      menu $w.menu.$i -tearoff $tear
    }
    # alter ConfigMenus if changing tearoffs S.A

    $w.menu.file add command -label PgnFilePrint -command "::pgn::savePgn $w"

    $w.menu.file add command -label PgnFileCopy -command ::pgn::copyPgn

    $w.menu.file add separator

    $w.menu.file add command -label PgnFileClose -accelerator Esc \
        -command "focus .main ; destroy $w"

    $w.menu.opt add checkbutton -label PgnOptShort \
        -variable ::pgn::shortHeader -command {updateBoard -pgn}
    $w.menu.opt add checkbutton -label PgnOptColumn \
        -variable ::pgn::columnFormat -command {updateBoard -pgn}
    $w.menu.opt add checkbutton -label PgnOptColor \
        -variable ::pgn::showColor -command {updateBoard -pgn}
    $w.menu.opt add checkbutton -label PgnOptIndentC \
        -variable ::pgn::indentComments -command {updateBoard -pgn}
    $w.menu.opt add checkbutton -label PgnOptIndentV \
        -variable ::pgn::indentVars -command {updateBoard -pgn}
    $w.menu.opt add checkbutton -label PgnOptBoldMainLine -variable ::pgn::boldMainLine -command {
      if { $::pgn::boldMainLine } {
        .pgnWin.text configure -font font_Bold
        # unhandled
        # .pgnWin.text tag configure c -fore $::pgnColor(Comment) -font font_Regular
        .pgnWin.text tag configure nag -fore $::pgnColor(Nag) -font font_Regular
        .pgnWin.text tag configure var -fore $::pgnColor(Var) -font font_Regular
      } else {
        .pgnWin.text configure -font font_Regular
        .pgnWin.text tag configure nag -fore $::pgnColor(Nag)
        .pgnWin.text tag configure var -fore $::pgnColor(Var)
      }
    }
    $w.menu.opt add checkbutton -label PgnOptSpace \
        -variable ::pgn::moveNumberSpaces -command {updateBoard -pgn}
    $w.menu.opt add checkbutton -label PgnOptSymbols \
        -variable ::pgn::symbolicNags -command {updateBoard -pgn}
    $w.menu.opt add checkbutton -label PgnOptStripMarks \
        -variable ::pgn::stripMarks -command {updateBoard -pgn}

    $w.menu.opt add separator

    if {$::graphFigurineAvailable} {
      $w.menu.opt add checkbutton -label PgnOptChess \
	  -variable ::useGraphFigurine -command {updateBoard -pgn}
    } else {
      $w.menu.opt add checkbutton -label PgnOptChess \
	  -variable ::useGraphFigurine -command {updateBoard -pgn} -state disabled
    }

    $w.menu.opt add checkbutton -variable ::pgn::showScrollbar -label PgnOptScrollbar -command ::pgn::packScrollbar 

    $w.menu.opt add command -label [tr OptionsFonts] -command "FontDialogRegular $w" -underline 0

    $w.menu.color add command -label PgnColorHeader \
        -command {::pgn::ChooseColor Header "header text"}
    $w.menu.color add command -label PgnColorAnno \
        -command {::pgn::ChooseColor Nag annotation}
    $w.menu.color add command -label PgnColorComments \
        -command {::pgn::ChooseColor Comment comment}
    $w.menu.color add command -label PgnColorVars \
        -command {::pgn::ChooseColor Var variation}
    $w.menu.color add command -label PgnColorBackground \
        -command {::pgn::ChooseColor Background background}
    $w.menu.color add command -label PgnColorCurrent \
        -command {::pgn::ChooseColor Current current}

    $w.menu.help add command -label PgnHelpPgn \
        -accelerator F1 -command {helpWindow PGN}
    $w.menu.help add command -label PgnHelpIndex -command {helpWindow Index}

    ::pgn::ConfigMenus

    text $w.text -width $::winWidth($w) -height $::winHeight($w) -wrap word \
        -cursor {} -setgrid 1 -yscrollcommand "$w.ybar set"
    configTabs
    if {$pgnColor(Background) != {white} && $pgnColor(Background) != {#ffffff}} {
	$w.text configure -background $pgnColor(Background)
    }
    if { $::pgn::boldMainLine } {
      $w.text configure -font font_Bold
    }

    scrollbar $w.ybar -orient vertical -command "$w.text yview" -width 12

    pack $w.text -side left -fill both -expand yes

    ::pgn::packScrollbar

    bind $w <Destroy> {}


    # # Middle button popups a PGN board
    bind $w.text <ButtonPress-2> "::pgn::ShowBoard .pgnWin.text %x %y %X %Y"
    bind $w <ButtonRelease-2> ::pgn::HideBoard

    # Right button draws context menu
    bind $w <ButtonPress-3> "::pgn::contextMenu .pgnWin.text %x %y %X %Y"

    if {$::macOS} {
      bind .pgnWin <Control-Button-1> {event generate .pgnWin <Button-3> -x %x -y %y -button 3}
    }

    bind $w <F1> { helpWindow PGN }
    bind $w <Escape> {
      if {[winfo exists .pgnWin.text.ctxtMenu]} {
        destroy .pgnWin.text.ctxtMenu
        focus .pgnWin
      } else {
        focus .main
        destroy .pgnWin
      }
    }
    standardShortcuts $w
    bind $w <Control-z> {sc_game undo ; updateBoard -pgn}
    bind $w <Control-y> {sc_game redo ; updateBoard -pgn}
    bind $w <Delete> ::game::Truncate
    bind $w <Control-Delete> ::game::Delete
    bindMouseWheel $w $w.text
    bind $w <Control-s> "::pgn::savePgn $w"

    # Add variation navigation bindings:
    bind $w <KeyPress-v> [bind . <KeyPress-v>]
    bind $w <KeyPress-z> [bind . <KeyPress-z>]
    bindWheeltoFont $w
    bind $w <Configure> "recordWinSize $w"

    $w.text tag add Current 0.0 0.0

    # Populate text widget &&&
    ::pgn::ResetColors

    ::createToplevelFinalize $w
  }

  ### Set the tab stops for the pgn window (only used in column mode)

  proc configTabs {} {
    global fd_size

    if {![winfo exists .pgnWin]} {return}

    # Column mode tabbing is broke for large fonts
    # The problem is lots spaces (in lieu of nags) are mixed with the tabs
    # We have to change tab spacing according to font size

    set t1 [expr $fd_size / 10.0]c
    set t2 [expr $fd_size / 8.0]c
    set t3 [expr ($fd_size - 8) / 3.5 + 3 + 0.5*($fd_size > 13)]c 
    .pgnWin.text configure  -tabs "$t1 right $t2 $t3"
  }

  proc packScrollbar {} {
    if {$::pgn::showScrollbar} {
      pack .pgnWin.ybar -before .pgnWin.text -side right -fill y
    } else {
      pack forget .pgnWin.ybar
    }
  }

  proc savePgn {parent} {
    global env

    set ftype {
      { "PGN files"  {".pgn"} }
      { "Text files" {".txt"} }
      { "All files"  {"*"}    }
    }

    ### Only suggest a filename if this is not a multiple pgn file
    if {[info exists ::initialDir(file)] && [sc_filter count] <= 1} {
      set tail $::initialDir(file)
    } else {
      set tail {}
    }
    if {! [file isdirectory $::initialDir(pgn)] } {
      set ::initialDir(pgn) $::env(HOME)
    }
    set fname [tk_getSaveFile -parent $parent \
                 -initialdir $::initialDir(pgn) -initialfile $tail \
                 -filetypes $ftype -defaultextension .pgn -title {Save PGN}]
    if {$fname != ""} {
      if {[file extension $fname] != ".txt" && [file extension $fname] != ".pgn" } {
	append fname ".pgn"
      }
      if {[catch {set tempfile [open $fname w]}]} {
	tk_messageBox -title "Scid: Error saving file" -parent $parent -type ok \
                      -icon warning -message "Unable to save file $fname\n\n"
      } else {
        ### This currently only saves a single game,
        ### ... possibily/easily overwriting a multiple game pgn file S.A
	setLanguageTemp E
	puts $tempfile \
	    [sc_game pgn -width 75 -symbols $::pgn::symbolicNags \
	    -indentVar $::pgn::indentVars -indentCom $::pgn::indentComments \
	    -space $::pgn::moveNumberSpaces -format plain -column $::pgn::columnFormat \
	    -markCodes $::pgn::stripMarks -stripbraces 1]
	close $tempfile
	setLanguageTemp $::language
        ::recentFiles::add $fname
        set ::initialDir(file) [file tail $fname]
        updateMenuStates
      }
      set initialDir(pgn) [file dirname $fname]
    }
  }

  proc copyPgn {} {
    setLanguageTemp E
    set pgnStr [sc_game pgn -indentComments $::pgn::indentComments \
	-indentVariations $::pgn::indentVars -space $::pgn::moveNumberSpaces -stripbraces 1]
    setLanguageTemp $::language
    
    setClipboard $pgnStr
  }

  # These two bindings are done in a bad way in htext.tcl.
  # Each text object has separate bindings, but they should 
  # be handled in a general bind to the pgn text widget ala
  # contextMenu

  proc move {moveTag} {
    set ::pause 1
    sc_move pgn [string range $moveTag 2 end]
    updateBoard
  }

  proc comment {commentTag} {
    sc_move pgn [string range $commentTag 2 end]
    updateBoard
    ::commenteditor::Open
  }

  proc contextMenu {win x y xc yc} {
    # x y xc yc -  unused

    update idletasks

    set mctxt $win.ctxtMenu
    if { [winfo exists $mctxt] } { destroy $mctxt }
    if {[sc_var level] == 0} {
      set state disabled
    } else  {
      set state normal
    }
    set varnum [sc_var number]
    menu $mctxt
    $mctxt add command -label [tr EditDelete] -state $state -command "::pgn::deleteVar $varnum"
    $mctxt add command -label [tr EditFirst] -state $state -command "::pgn::firstVar $varnum"
    $mctxt add command -label [tr EditMain] -state $state -command "::pgn::mainVar $varnum"
    $mctxt add separator
    $mctxt add command -label "[tr EditStrip] [tr EditStripBegin]" -command ::game::TruncateBegin
    $mctxt add command -label "[tr EditStrip] [tr EditStripEnd]" -command ::game::Truncate
    $mctxt add separator
    $mctxt add command -label "[tr EditStrip] [tr EditStripComments]" -command {::game::Strip comments .pgnWin}
    $mctxt add command -label "[tr EditStrip] [tr EditStripVars]" -command {::game::Strip variations .pgnWin}
    $mctxt add separator
    $mctxt add command -label "[tr WindowsComment]" -command ::commenteditor::Open

    ### Offset the menu a little so as to not obstruct move
    # [expr [winfo pointerx .] + 15] [expr [winfo pointery .] + 0]
    ### tk_popup is better than post. No need to explicitly handle unposts
    tk_popup $mctxt [winfo pointerx .] [winfo pointery .]
  }

  proc deleteVar { var } {
    sc_game undoPoint

    sc_var exit
    sc_var delete $var
    updateBoard -pgn
  }

  proc firstVar { var } {
    sc_game undoPoint

    sc_var exit
    sc_var first $var
    updateBoard -pgn
  }

  proc mainVar { var } {
    sc_game undoPoint

    sc_var exit
    sc_var promote $var
    updateBoard -pgn
  }

  proc getMoveNumber {win lastpos} {
    if {[scan $lastpos "%d.%d" lastline lastcol] != 2} {
      return 0
    }
    set tags [$win tag names $lastline.$lastcol]
    if {$tags == {}} {
      return 0
    }
    set tag [lindex $tags end]
    set movenum [string range $tag 2 end]
    if {![string is integer -strict $movenum]} {
      return 0
    } else {
      return $movenum
    }
  }

  ### Produces a popup window showing the board position in the
  ### game at the current mouse location in the PGN window.

  proc ShowBoard {win x y xc yc} {
    global lite dark

    # unpost context menu
    set mctxt $win.ctxtMenu
    if { [winfo exists $mctxt] } { destroy $mctxt }

    # extract movenumber from pgn widget tag 

    set moveTag m_[getMoveNumber $win [ $win index @$x,$y]]
    if {$moveTag == "m_0"} {
      return
    }
    set movenum [string trim [lindex [split [$win tag bind $moveTag <1>] _] end]]
   
    # Do these pushes/pops break anything elsewhere ?
    sc_game push copyfast
    sc_move pgn $movenum
    set bd [sc_pos board]
    sc_game pop

    if {[::board::isFlipped .main.board]} {
      set bd [string reverse [lindex $bd 0]]
    }

    set w .pgnPopup
    set psize 35
    if {$psize > $::boardSize} { set psize $::boardSize }

    if {! [winfo exists $w]} {
      toplevel $w -relief solid -borderwidth 2
      wm withdraw $w
      wm overrideredirect $w 1
      ::board::new $w.bd $psize
      pack $w.bd -side top -padx 2 -pady 2
    }
    ::board::update $w.bd $bd

    # Make sure the popup window can fit on the screen:
    incr xc 5
    incr yc 5
    update idletasks
    set dx [winfo reqwidth $w]
    set dy [winfo reqheight $w]
    if {($xc+$dx) > [winfo screenwidth $w]} {
      set xc [expr {[winfo screenwidth $w] - $dx}]
    }
    if {($yc+$dy) > [winfo screenheight $w]} {
      set yc [expr {[winfo screenheight $w] - $dy}]
    }
    wm geometry $w "+$xc+$yc"
    wm deiconify $w
    raiseWin $w
  }

  proc HideBoard {} {
    if {[winfo exists .pgnPopup]} {
      wm withdraw .pgnPopup
      focus .pgnWin
    }
  }

  ################################################################################
  # # ::pgn::ResetColors
  #
  #    Reconfigures the pgn Colors, after a color is changed by the user
  #
  ################################################################################
  proc ResetColors {} {
    global pgnColor
    if {![winfo exists .pgnWin]} { return }
    .pgnWin.text tag configure Current -background $pgnColor(Current)
    ::htext::init .pgnWin.text
    ::pgn::Refresh 1
    if {$pgnColor(Background) != {white} && $pgnColor(Background) != {#ffffff}} {
	.pgnWin.text configure -background $pgnColor(Background)
	.pgnWin.text tag configure Current -background $pgnColor(Current)
    }
  }
  ################################################################################
  # ::pgn::Refresh
  #
  #    Updates the PGN window. If $pgnNeedsUpdate == 0, then the
  #    window text is not regenerated; only the current and next move
  #    tags will be updated.
  ################################################################################
  proc Refresh {{pgnNeedsUpdate 0}} {
	 global useGraphFigurine

    if {![winfo exists .pgnWin]} {
      return
    }

    if {$::pgn::showColor} {
      set format color
    } else {
      set format plain
    }

    set pgnStr [sc_game pgn -symbols $::pgn::symbolicNags \
        -indentVar $::pgn::indentVars -indentCom $::pgn::indentComments \
        -space $::pgn::moveNumberSpaces -format $format -column $::pgn::columnFormat \
        -short $::pgn::shortHeader -markCodes $::pgn::stripMarks \
        -unicode $useGraphFigurine]
    # debug puts $pgnStr

    if {$pgnNeedsUpdate} {
      ::setTitle .pgnWin PGN
      .pgnWin.text configure -state normal
      .pgnWin.text delete 0.0 end
      if {$::pgn::showColor} {
        if {$::pgn::indentComments} {
	  ::htext::display .pgnWin.text [PrepareForDisplay $pgnStr] {} 2
        } else {
	  ::htext::display .pgnWin.text [PrepareForDisplay $pgnStr]
        }
	.pgnWin.text configure -state normal
      } else {
        .pgnWin.text insert 1.0 $pgnStr
      }
    }

    if {$::pgn::showColor} {
      ### set Current tag and adjust text window view if necessary

      .pgnWin.text tag remove Current 1.0 end

      set offset [sc_pos pgnOffset]
      set moveRange [.pgnWin.text tag nextrange m_$offset 1.0]
      if {[llength $moveRange] == 2} {
       .pgnWin.text tag add Current [lindex $moveRange 0] [lindex $moveRange 1]

       ### There's a bottleneck here when large pgn files are shown on one line
       ### Slowdown is internal to Tk. (from the text manpage)
       # <q> Very  long  text  lines  can be expensive, especially if they have
       # many marks and tags within them. </q>

       .pgnWin.text see [lindex $moveRange 0]
       # Better is -
       # see "[lindex $moveRange 0] + 1 lines"
       # but the damn thing doesnt work on actual lines, only text lines
       ### Necessary for (eg 23. (\n) Qa5
       .pgnWin.text see [lindex $moveRange 1]
      } else {
       # .pgnWin.text yview moveto 0
      }
    } else {
      # Highlight current move in text only widget

      # This is not going to work because generally [sc_pos pgnOffset] returns
      # 2 * (move number), but when we have variations this is not the case!
      # Needs some magic somehow.

      set move [sc_pos pgnOffset].
      # seek to after first blank line
      set offset [expr [string first \n\n $pgnStr] + 2]
      #.pgnWin.text tag add Current UMMMM....

    }
    .pgnWin.text configure -state disabled
  }
}

### End of pgn.tcl
