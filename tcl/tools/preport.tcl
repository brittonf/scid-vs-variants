# preport.tcl: Player reports.
# Part of Scid. Copyright 2003 Shane Hudson

namespace eval ::preport {}
array set ::preport::_data {}

set preport(MaxGames) 400

set ::preport::_player ""
set ::preport::_color white
set ::preport::_pos start
set ::preport::_clipbase 0

# preportDlg
#   Present a dialog allowing the user to select the
#   player and color for which to generate a player report.

proc ::preport::preportDlg {{player {}}} {

  if {[sc_base numGames] == 0} {
    tk_messageBox -title "Scid" -type ok -icon warning -message "No games in current base"
    return
  }

  if {$player != {}} {
    set ::preport::_player $player
    if {$player == [sc_game info white]} {
      set ::preport::_color white
    } elseif {$player == [sc_game info black]} {
      set ::preport::_color black
    }
  }

  set w .preportDlg
  if {[winfo exists $w]} {
    raiseWin $w
    return
  }
  toplevel $w
  wm withdraw $w
  wm title $w "[tr ToolsPlayerReport]"

  pack [label $w.plabel -text "Generate Player Report"]
  pack [frame $w.space -height 10]
  pack [frame $w.g] -side top -fill x -expand yes -padx 2

  label $w.g.where -text "Player:"
  grid $w.g.where -row 0 -column 0 -sticky w
  ttk::combobox $w.g.player -width 30 -textvariable ::preport::_player

  set tmp $::preport::_player
  ::utils::history::SetCombobox ::preport::_player $w.g.player
  set ::preport::_player $tmp

  grid $w.g.player -row 0 -column 1 -columnspan 2 -padx 10

  label $w.g.has -text "Color:"
  grid $w.g.has -row 1 -column 0 -sticky w
  radiobutton $w.g.white -text $::tr(White) -variable ::preport::_color -value white
  radiobutton $w.g.black -text $::tr(Black) -variable ::preport::_color -value black
  grid $w.g.white -row 1 -column 1 -sticky w
  grid $w.g.black -row 1 -column 2 -sticky w

  label $w.g.pos -text "Start position:"
  grid $w.g.pos -row 2 -column 0
  radiobutton $w.g.start -text "Game start" -variable ::preport::_pos -value start
  radiobutton $w.g.current -text "Current position" -variable ::preport::_pos -value current
  grid $w.g.start   -row 2 -column 1 -sticky w
  grid $w.g.current -row 2 -column 2 -sticky w

  pack [frame $w.b2] -side top -fill x
  pack [checkbutton $w.clipbase -text $::tr(PReportClipbase) \
    -variable ::preport::_clipbase] -side top
  addHorizontalRule $w
  pack [frame $w.b] -side bottom -fill x
  set whiteName [sc_game info white]
  set blackName [sc_game info black]
  dialogbutton $w.b2.white -text "$::tr(White) ($whiteName)" -command {
    set ::preport::_player [sc_game info white]
    set ::preport::_color white
  } -font font_Small
  dialogbutton $w.b2.black -text "$::tr(Black) ($blackName)" -command {
    set ::preport::_player [sc_game info black]
    set ::preport::_color black
  } -font font_Small
  if {$whiteName == ""  ||  $whiteName == "?"} {
    $w.b2.white configure -state disabled
  }
  if {$blackName == ""  ||  $blackName == "?"} {
    $w.b2.black configure -state disabled
  }

  dialogbutton $w.b.help -text $::tr(Help) \
    -command {helpWindow Reports Player}
  dialogbutton $w.b.ok -text OK \
    -command "catch {grab release $w}; destroy $w; ::preport::makeReportWin"
  dialogbutton $w.b.cancel -text $::tr(Cancel) \
    -command "catch {grab release $w}; destroy $w"
  foreach button {help ok cancel} {
    $w.b.$button configure -font font_Small
  }
  if {$whiteName != ""  &&  $whiteName != "?"} {
    packbuttons left $w.b2.white
  }
  if {$blackName != ""  &&  $blackName != "?"} {
    packbuttons right $w.b2.black
  }
  packbuttons right $w.b.cancel $w.b.help $w.b.ok
  if {[sc_base current] == [sc_info clipbase]} {
    $w.clipbase configure -state disabled
  }
  bind $w <Return> [list $w.b.ok invoke]
  bind $w <Escape> [list $w.b.cancel invoke]
  placeWinCenter $w
  update
  wm deiconify $w
  focus $w.g.player
}

proc ::preport::ConfigMenus {{lang ""}} {
  if {! [winfo exists .preportWin]} { return }
  if {$lang == ""} { set lang $::language }
  set m .preportWin.menu
  foreach idx {0 1} tag {File Help} {
    configMenuText $m $idx Oprep$tag $lang
  }
  foreach idx {0 1 2 4 6} tag {Text Html LaTeX Options Close} {
    configMenuText $m.file $idx OprepFile$tag $lang
  }
  foreach idx {0 1} tag {Report Index} {
    configMenuText $m.help $idx OprepHelp$tag $lang
  }

}

proc ::preport::makeReportWin {args} {
  if {! [sc_base inUse]} { return }
  set args [linsert $args 0 "args"]

  set showProgress 1
  if {$showProgress} {
    set w .progress
    toplevel $w
    wm withdraw $w
    wm title $w "[tr ToolsPlayerReport]"
    bind $w <Visibility> "raiseWin $w"

    pack [frame $w.b] -side bottom -fill x
    set ::preport::_interrupt 0
    button $w.b.cancel -text $::tr(Cancel) -command {
      set ::preport::_interrupt 1
      sc_progressBar
    }
    pack $w.b.cancel -side right -pady 5 -padx 2

    foreach i {1 2} name {"Searching database for report games"
                        "Generating report information"} {
      label $w.text$i -text "$i. $name"
      pack $w.text$i -side top
      canvas $w.c$i -width 400 -height 20  -relief solid -border 1
      $w.c$i create rectangle 0 0 0 0 -fill $::progcolor -outline $::progcolor -tags bar
      $w.c$i create text 395 10 -anchor e -font font_Regular -tags time \
        -fill black -text "0:00 / 0:00"
      pack $w.c$i -side top -pady 10
    }
    placeWinCenter $w
    wm deiconify $w
    grab $w.b.cancel
    sc_progressBar $w.c1 bar 401 21 time
    busyCursor .
  }

  # if the report is to be done from the starting position, a full
  # search of the base has to be ensured. Remove all filters including
  # tree filters:
  if {$::preport::_pos == "start"} { sc_filter clear }

  set searchArgs {}
  lappend searchArgs -filter RESET
  lappend searchArgs "-$::preport::_color"
  lappend searchArgs "\"$::preport::_player\""
  eval sc_search header $searchArgs
  if {$showProgress} {
    if {$::preport::_interrupt} {
      unbusyCursor .
      catch {grab release $w.b.cancel}
      destroy $w
      return
    }
    sc_progressBar $w.c2 bar 401 21 time
  }

  ::utils::history::AddEntry ::preport::_player $::preport::_player

  if {$::preport::_pos == "start"} { sc_game push }
  sc_search board AND Exact false 0
  sc_report player create $::preport(ExtraMoves) $::preport(MaxGames)
  if {$::preport::_pos == "start"} { sc_game pop }
  if {$::preport::_clipbase} {
    if {[sc_base current] != [sc_info clipbase]} {
      sc_clipbase clear
      sc_filter copy [sc_base current] [sc_info clipbase]
    }
  }
  if {$showProgress} {
    unbusyCursor .
    catch {grab release $w.b.cancel}
    destroy $w
    if {$::preport::_interrupt} { return }
  }
  set report [::preport::report ctext 1]

  if {[lsearch -exact $args "-nodisplay"] >= 0} { return }

  set w .preportWin
  if {[winfo exists $w]} {
    raiseWin $w
  } else {
    toplevel $w
    wm withdraw $w
    wm title $w "$::tr(PReportTitle)"
    menu $w.menu
    $w configure -menu $w.menu
    $w.menu add cascade -label OprepFile -menu $w.menu.file
    $w.menu add cascade -label OprepHelp -menu $w.menu.help
    foreach i {file help} {
      menu $w.menu.$i -tearoff 0
    }
    $w.menu.file add command -label OprepFileText \
      -command {::preport::saveReport text}
    $w.menu.file add command -label OprepFileHtml \
      -command {::preport::saveReport html}
    $w.menu.file add command -label OprepFileLaTeX \
      -command {::preport::saveReport latex}
    $w.menu.file add separator
    $w.menu.file add command -label OprepFileOptions \
      -command ::preport::setOptions
    $w.menu.file add separator
    $w.menu.file add command -label Close \
      -command "$w.b.close invoke"
    # todo: this help menu item gets changed to Opening Report Help &&&
    $w.menu.help add command -label "Player Report Help" \
      -accelerator F1 -command {helpWindow Reports Player}
    $w.menu.help add command -label "Index" \
      -command {helpWindow Index}

    bind $w <F1> {helpWindow Reports Player}
    bind $w <Escape> "$w.b.close invoke"
    bind $w <Up> "$w.text yview scroll -1 units"
    bind $w <Down> "$w.text yview scroll 1 units"
    bind $w <Prior> "$w.text yview scroll -1 pages"
    bind $w <Next> "$w.text yview scroll 1 pages"
    bind $w <Key-Home> "$w.text yview moveto 0"
    bind $w <Key-End> "$w.text yview moveto 0.99"
    bindMouseWheel $w $w.text
    bindWheeltoFont $w

    autoscrollframe -bars y $w.scroll text $w.text \
      -font font_Small -setgrid 1 -wrap word \
      -foreground black -cursor top_left_arrow
    ::htext::init $w.text
    frame $w.b
    button $w.b.opts -text [tr OprepFileOptions] -command ::preport::setOptions
    button $w.b.help -textvar ::tr(Help) -command {helpWindow Reports Player}
    button $w.b.previewLatex -textvar ::tr(OprepViewLaTeX) \
      -command {previewLatex Scid-Player-Report {::preport::report latex 1} .preportWin}
    button $w.b.viewHTML -textvar ::tr(OprepViewHTML) -command ::preport::previewHTML
    button $w.b.update -textvar ::tr(Update) -command ::preport::preportDlg
    button $w.b.close -textvar ::tr(Close) -command "focus .main ; destroy $w"

    entry $w.b.find -width 10 -textvariable ::preport(find) -highlightthickness 0
    configFindEntryBox $w.b.find ::preport .preportWin.text

    pack $w.b -side bottom -fill x
    pack $w.scroll -side top -fill both -expand yes
    pack $w.b.close $w.b.find $w.b.update -side right -padx 2 -pady 2
    pack $w.b.previewLatex $w.b.viewHTML $w.b.opts -side left -padx 2 -pady 2
    ::preport::ConfigMenus
    placeWinCenter $w
    wm geom $w 150x42
    update
    wm deiconify $w
  } 

  busyCursor .
  $w.text configure -state normal
  $w.text delete 1.0 end

  if {$::preport::_pos == "current"  &&  ![sc_pos isAt start]} {
    puts Board!
    # todo , insert a board (?)
  }

  regsub -all "\n" $report "<br>" report
  ::htext::display $w.text $report
  unbusyCursor .
  ::windows::gamelist::Refresh
  ::windows::stats::Refresh
}


proc ::preport::setOptions {} {
  set w .preportOptions
  if {[winfo exists $w]} {
    raiseWin $w
    return
  }
  toplevel $w
  wm withdraw $w
  wm title $w  "[tr ToolsPlayerReport]: [tr OprepFileOptions]"
  wm resizable $w 0 0

  pack [frame $w.f] -side top -fill x -padx 5 -pady 5
  set row 0
  foreach i {Stats AvgPerf Results MovesFrom Themes Endgames} {
    set yesno($i) 1
  }
  foreach i {Stats Oldest Newest MostFrequentOpponents Results sep \
               AvgPerf HighRating sep \
               MostFrequentEcoCodes Themes Endgames sep \
               MaxGames ExtraMoves} {
    set from 0; set to 10; set tick 1; set res 1
    if {$i == "MaxGames"} {
      set from 0; set to 1000; set tick 100; set res 100
    }
    if {$i == "sep"} {
      frame $w.f.fsep$row -height 2 -borderwidth 2 -relief sunken 
      frame $w.f.tsep$row -height 2 -borderwidth 2 -relief sunken 
      grid $w.f.fsep$row -row $row -column 0 -sticky we -columnspan 4
      #grid $w.f.tsep$row -row $row -column 1 -sticky we -columnspan 2
    } elseif {[info exists yesno($i)]} {
      frame $w.f.f$i
      radiobutton $w.f.f$i.yes -variable ::preport($i) -value 1 \
        -text "$::tr(Yes)   " -font font_Small
      radiobutton $w.f.f$i.no -variable ::preport($i) -value 0 \
        -text "$::tr(No)   "  -font font_Small
      pack $w.f.f$i.yes -side left
      pack $w.f.f$i.no -side right
      label $w.f.t$i -textvar ::tr(Oprep$i) -font font_Small
      grid $w.f.f$i -row $row -column 0 -sticky n
      grid $w.f.t$i -row $row -column 1 -sticky w -columnspan 3
    } else {
      scale $w.f.s$i -variable ::preport($i) -from $from -to $to \
        -width 10 -length 200 -tickinterval $tick -orient horizontal \
        -font font_Small -resolution $res -showvalue 0
      label $w.f.t$i -textvar ::tr(Oprep$i) -font font_Small
      grid $w.f.s$i -row $row -column 0 -sticky we
      grid $w.f.t$i -row $row -column 1 -sticky w -columnspan 3
    }
    grid rowconfigure $w.f $row -pad 2
    incr row
  }

  addHorizontalRule $w

  pack [frame $w.b] -side bottom -fill x

  button $w.b.defaults -textvar ::tr(Defaults) -command {
    array set ::preport [array get ::preportDefaults]
  }
  button $w.b.ok -text "OK" -command {
    destroy .preportOptions
    catch {set ::preport::_data(yview) [lindex [.preportWin.text yview] 0]}
    ::preport::makeReportWin
    catch {.preportWin.text yview moveto $::preport::_data(yview)}
  }
  button $w.b.cancel -textvar ::tr(Cancel) -command {
    array set ::preport [array get ::preport::backup]
    destroy .preportOptions
  }

  pack $w.b.defaults -side left -padx 5 -pady 5
  pack $w.b.cancel $w.b.ok -side right -padx 5 -pady 5

  array set ::preport::backup [array get ::preport]
  bind $w <Escape> "$w.b.cancel invoke"

  update
  placeWinOverParent $w .preportWin
  wm deiconify $w
}

# previewHTML:
#   Saves the report to a temporary file, and invokes the user's web
#   browser to display it.
#
proc ::preport::previewHTML {} {
  busyCursor .
  set tmpdir $::scidLogDir
  set tmpfile TempPlayerReport.html
  set fname [file nativename [file join $tmpdir $tmpfile]]
  if {[catch {set tempfile [open $fname w]}]} {
    tk_messageBox -title "Scid: Error writing report" -type ok -icon warning \
        -message "Unable to write the file: $fname"
  }
  puts $tempfile [::preport::report html 1]
  close $tempfile
  openURL $fname
  unbusyCursor .
}

proc ::preport::saveReport {fmt} {
  set default ".txt"
  set ftype {
    { "Text files" {".txt"} }
    { "All files"  {"*"}    }
  }
  if {$fmt == "latex"} {
    set default ".tex"
    set ftype {
      { "LaTeX files" {".tex" ".ltx"} }
      { "All files"  {"*"}    }
    }
  } elseif {$fmt == "html"} {
    set default ".html"
    set ftype {
      { "HTML files" {".html" ".htm"} }
      { "All files"  {"*"}    }
    }
  }

  set fname [tk_getSaveFile -initialdir $::env(HOME) -filetypes $ftype -parent .preportWin \
               -defaultextension $default -title "Save Opening Report"]
  if {$fname == ""} { return }
  if {$::macOS && ![string match *$default $fName] && ![string match *.* $fName]} {
      append fName $default
  }

  busyCursor .
  if {[catch {set tempfile [open $fname w]}]} {
    tk_messageBox -title "Scid: Error writing report" -type ok -icon warning \
      -message "Unable to write the file: $fname\n\n"
  } else {
    set report [::preport::report $fmt 1]
    if {$::hasEncoding  &&  $::langEncoding($::language) != ""} {
      catch {set report [encoding convertto $::langEncoding($::language) $report]}
    }
    puts $tempfile $report
    close $tempfile
  }
  unbusyCursor .
}

proc ::preport::_reset {} {
  set ::preport::_data(sec) 0
  set ::preport::_data(subsec) 0
}

proc ::preport::_title {title} {
  set fmt $::preport::_data(fmt)
  if {$fmt == "latex"} {
    return "\\begin{center}{\\LARGE \\color{blue}$title}\\end{center}\n\n"
  } elseif {$fmt == "html"} {
    return "<h2><center>$title</center></h2>\n\n"
  } elseif {$fmt == "ctext"} {
    return "<h2><center>$title</center></h2>\n\n"
  }
  set r    "--------------------------------------------------------------"
  append r "\n                        [string toupper $title]\n"
  append r "--------------------------------------------------------------"
  append r "\n\n"
  return $r
}

proc ::preport::_sec {text} {
  set fmt $::preport::_data(fmt)
  incr ::preport::_data(sec)
  set ::preport::_data(subsec) 0
  if {$fmt == "latex"} {
    return "\n\n\\section{$text}\n"
  } elseif {$fmt == "html"} {
    return "\n<h2>$::preport::_data(sec). $text</h2>\n"
  } elseif {$fmt == "ctext"} {
    return "<h4>$::preport::_data(sec). $text</h4>"
  }
  set line "$::preport::_data(sec). [string toupper $text]"
  set underline "-----------------------------------------------------"
  return "\n\n$line\n[string range $underline 1 [string length $line]]\n"
}

proc ::preport::_subsec {text} {
  set fmt $::preport::_data(fmt)
  incr ::preport::_data(subsec)
  if {$fmt == "latex"} {
    return "\n\\subsection{$text}\n\n"
  } elseif {$fmt == "html"} {
    return "\n<h3>$::preport::_data(sec).$::preport::_data(subsec) $text</h3>\n\n"
  } elseif {$fmt == "ctext"} {
    return "\n<maroon><b>$::preport::_data(sec).$::preport::_data(subsec) $text</b></maroon>\n\n"
  }
  return "\n$::preport::_data(sec).$::preport::_data(subsec)  $text\n\n"
}


proc ::preport::report {fmt {withTable 1}} {
  global tr preport
  sc_report player format $fmt
  set fmt [string tolower $fmt]
  set ::preport::_data(fmt) $fmt
  ::preport::_reset

  # numRows: the number of rows to show in the theory table.
  # If it is zero, the number of rows if decided according to the
  # number of games in the report.
  set numRows 0

  # Specify whether a theory table is to be printed, so note numbers
  # can be generated and displayed if necessary:
  sc_report player notes $withTable $numRows

  set n "\n"; set p "\n\n"; set preText ""; set postText "";
  set bb "\""; set eb "\""; set ls ":";
  set percent "%"; set bullet "  * ";
  set ml ""; set mo "";
  set va ""; set vo "";
  if {$fmt == "latex"} {
    set n "\\\\\n"; set p "\n\n"; set ls ": &";
    set preText "\\begin{tabularx}{0.8\\textwidth}{rX} \n";
    set postText "\\end{tabularx}\n"
    set percent "\\%"; set bullet "\\hspace{0.5cm}\$\\bullet\$";
    set bb "\\textbf{"; set eb "}";
    set ml "\\mainline{"; set mo "}";
  } elseif {$fmt == "html"} {
    set n "<br>\n"; set p "<p>\n\n"; 
    set preText "<pre>\n"; set postText "</pre>\n";
    set bb "<strong>"; set eb "</strong>";
  } elseif {$fmt == "ctext"} {
    set preText "<tt>"; set postText "</tt>"    
  }

  # Generate the report:
  set games $tr(games)
  set moves $tr(moves)
  set counts [sc_report player count]
  set rgames [lindex $counts 0]
  set tgames [lindex $counts 1]

  set r $::optable::_docStart($fmt)
  set propername $::preport::_player
  if ([string first "," $propername]) {    
    set fields [split $propername ","]
    lassign $fields lastname firstname extracomma
    set propername [concat $firstname $lastname]
    if {$extracomma != ""} {
      set propername [concat $propername $extracomma]
    }    
  }     
  
  # Use this if you want title last name first -- append r [::preport::_title $::preport::_player]
  append r [::preport::_title $propername]
  
  append r $preText
  append r "$tr(Player)$ls$bb$propername$eb"
         
  if {$::preport::_color == "white"} {   
    append r " $tr(PReportColorWhite)"
  } else {
    append r " $tr(PReportColorBlack)"
  }
  
  set eco ""
  if {$::preport::_pos == "current"  &&  ![sc_pos isAt start]} {
    set line [sc_report player line]
    if {$fmt == "latex"} {
      # broke - S.A
      # append r "\\newchessgame%\n"
      # append r "\\hidemoves{$line}%\\n"
      # append r "$n$tr(PReportBeginning)$ls"      
      append r " [format $tr(PReportMoves) [sc_report player line]]"
    } else {
      append r " [format $tr(PReportMoves) [sc_report player line]]"
    } 
    set eco [sc_report player eco]
  }
  append r " ("
  if {$fmt == "ctext"} {
    append r "<darkblue><run sc_report player select all 0; ::windows::stats::Refresh>"
  }
  append r "$rgames"
  if {$fmt == "ctext"} { append r "</run></darkblue>"; }
  append r " $games)$n"  
  append r "$tr(Database)$ls [file tail [sc_base filename]] "
  append r "([::utils::thousands [sc_base numGames]] $games)$n"
  if {$eco != ""} {
     append r "$tr(ECO)$ls $eco $n"
  }
  append r "$::tr(OprepGenerated)$ls $::scidName [sc_info version], [::utils::date::today] $n"
  append r $postText  
    
  if {$preport(Stats)  ||  $preport(Oldest) > 0  ||  $preport(Newest) > 0  ||
      $preport(MostFrequentOpponents) > 0  ||  $preport(Results)} {
    append r [::preport::_sec $tr(OprepStatsHist)]
  }
  if {$preport(Stats)} {
    append r [::preport::_subsec $tr(OprepStats)]
    append r [::optable::stats $fmt]
  }
  if {$preport(Oldest) > 0} {
    append r [::preport::_subsec $tr(OprepOldest)]
    append r "$preText[sc_report player best o $preport(Oldest)]$postText"
  }
  if {$preport(Newest) > 0} {
    append r [::preport::_subsec $tr(OprepNewest)]
    append r "$preText[sc_report player best n $preport(Newest)]$postText"
  }
  if {$preport(MostFrequentOpponents) > 0} {
    append r [::preport::_subsec "$tr(OprepMostFrequentOpponents)"]
    if {$::preport::_color == "white"} {
      append r [sc_report player players black $preport(MostFrequentOpponents)]
    } else {
      append r [sc_report player players white $preport(MostFrequentOpponents)]
    }
  }
  if {$preport(Results)} {
    append r [::preport::_subsec $::tr(OprepResults)]
    append r [::optable::results player $fmt]
  }

  if {$preport(AvgPerf)  ||  $preport(HighRating)} {
    append r [::preport::_sec $tr(OprepRatingsPerf)]
  }
  if {$preport(AvgPerf)} {
    append r [::preport::_subsec $tr(OprepAvgPerf)]
    set e [sc_report player elo white]
    set welo [lindex $e 0]; set wng [lindex $e 1]
    set bpct [lindex $e 2]; set bperf [lindex $e 3]
    set e [sc_report player elo black]
    set belo [lindex $e 0]; set bng [lindex $e 1]
    set wpct [lindex $e 2]; set wperf [lindex $e 3]
    append r "$tr(OprepWRating): $welo ($wng $games);  "
    append r "$tr(OprepWPerf): $wperf ($wpct$percent vs $belo)$n"
    append r "$tr(OprepBRating): $belo ($bng $games);  "
    append r "$tr(OprepBPerf): $bperf ($bpct$percent vs $welo)$n"
  }
  if {$preport(HighRating) > 0} {
    append r [::preport::_subsec $tr(OprepHighRating)]
    append r "$preText[sc_report player best a $preport(HighRating)]$postText"
  }

  if {$preport(Themes)  ||  $preport(MostFrequentEcoCodes) > 0  ||
      $preport(Endgames)} {
    append r [::preport::_sec $tr(OprepMovesThemes)]
  }
  if {$preport(MostFrequentEcoCodes) > 0} {
    append r [::preport::_subsec $tr(PReportOpenings)]
    append r [sc_report player eco $preport(MostFrequentEcoCodes)]
  }
  if {$preport(Themes)} {
    append r [::preport::_subsec $tr(OprepThemes)]
    append r [sc_report player themes \
        $tr(OprepThemeDescription) \
        $tr(OprepThemeSameCastling) \
        $tr(OprepThemeOppCastling) \
        $tr(OprepThemeQueenswap) \
        $tr(OprepTheme1BishopPair) \
        $tr(OprepThemeKPawnStorm) \
        $tr(OprepThemeWIQP) \
        $tr(OprepThemeBIQP) \
        $tr(OprepThemeWP567) \
        $tr(OprepThemeBP234) \
        $tr(OprepThemeOpenCDE) ]
  }
  if {$preport(Endgames)} {
    append r [::preport::_subsec $tr(OprepEndgames)]
    append r "$tr(OprepEndClass:)$n"
    append r [sc_report player endmat]
  }

  if {$withTable  &&  $::preport(MaxGames) > 0} {
    set sec [::preport::_sec $tr(OprepTheoryTable)]
    set comment ""
    if {$tgames > $::preport(MaxGames)} {
      set comment [format $tr(OprepTableComment) $::preport(MaxGames)]
    }
    append r [sc_report player print $numRows $sec $comment]
  }
  append r $::optable::_docEnd($fmt)

  # Eszet (ss) characters seem to be mishandled by LaTeX, even with
  # the font encoding package, so convert them explicitly:
  if {$fmt == "latex"} { regsub -all � $r {{\\ss}} r }

  return $r
}
