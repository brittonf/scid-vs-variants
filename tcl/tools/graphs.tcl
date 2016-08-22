### graph.tcl: part of Scid.

set maxyear [clock format [clock seconds] -format "%Y"]
set FilterMaxYear $maxyear

#   Saves a graph (e.g. tree graph, filter graph, rating graph) to a
#   color or greyscale Postscript file.
#   The mode should be "color" or "gray".

proc ::tools::graphs::Save {mode w} {
  if {! [winfo exists $w]} { return }
  set ftypes {{"PostScript files" {.eps .ps}} {"All files" *}}
  set fname [tk_getSaveFile -filetypes $ftypes -parent $w \
               -defaultextension ".eps" -title "Scid: Save Graph"]
  if {$fname == ""} { return }
  if {[catch {$w postscript -file $fname -colormode $mode} result]} {
    tk_messageBox -icon info -parent $w -title "Scid" -message $result
  }
}

########################################
# Configure Filter graph window

if { ! [info exists FilterMinElo] } {
    set FilterMinElo 2100
    set FilterMaxElo 2800
    set FilterStepElo 100
    set FilterGuessELO 1
    set FilterMinYear 1995
    set FilterStepYear 1
    set FilterMinMoves 5
    set FilterMaxMoves 80
    set FilterStepMoves 1
}

image create photo icongraphic -data {
R0lGODlhIAAbAPcAAAQCjISGhMTCvExKpKymnOTixCQilNTSzKSixGxubISC
tMzKxLSypPT23DQynGRmrBQSlLS2zJSSvFxerNzexMzKzLy2tDw6nHx+tJyW
lMTCzFRSpOTi1KyqxPz+3GxutBwelJyavDw+pAwKjIyGhMzGxExOpKympCwq
nNTW1Hx+fIyOvNTOxLSyrBQWlLy6zNze1MzOzLy6tDw+nOzq3KyuxPz+5HRy
tJyevO4AAJEAAHwAAHDkkgUAApLMkHwBAP8w2P+MIf9Fef8AAG2SgAUCU5KQ
0nwAdxUM2AoAAIIAinwAAAAA2AAAIRcAeQAAAFCgeAO55wBPEgAAAFjwh/3m
3BcS0QAAd3ig2Gs4IRdFeQAAAAC0SADmmQASdQAAAH6gAAA4AABFAMAAAAA6
oACeuQAATwAAAP+MAf/mAP8SAP8AAP8QOv/gBv/RAf93zwDkWAAA6wDMEgAB
AAAgIQAANwAARQAAAACS0QACtBeQ0QAAd8ASg+UARhIASAACAGIBkgkAAoIA
kHwAAHjUAGvmABcSAAAAANu+BwXfAILRAHx3AADkAL8AAE/MAAABAHggAGsA
AAEAFwAAAGqSAAACAACQAAAAAPwYAORVABIAAAAAAADYAADmAAASAAAAAPiD
APcqABKCAAB8ABgAKO4AAJEAuXwAAHAAAAUAAJIAAHwAAP8AAP8AAP8AAP8A
AG0pGQW3AJKTAHx8AEosGfYAAIC5AHwAAAC+UAA+7ReCEgB8AAD//wD//wD/
/wD//3gAAGsAABcAAAAAAAC8BAHm6AASEgAAAAC+HgA+qwCCSwB8AFf45Pb3
54ASEnwAAOgYe+buwBKRTgB8AHgAGGu36BeTEgB8AEH/vjv/Pjz/gnf/fBss
nbMA6NG5EncAAPC+5eU+/xKC/wB8fywAhADo6AASEgAAAADdLAA/AHiCuf98
AOMWvpQ/PtGCgnd8fEkBLGYAANMAuXcAANgxGAAAVYoAAAAAAAwBAAAAAAAA
AAAAAEQxzmEwcHMwRyAgACH5BAAAAAAALAAAAAAgABsABwj/AA+wiMHAgw2D
CA8qTMhwoUIWAhk4bGhQAoYGEyceiJiR4QoAAEJQdMgCosSRCFOAHOAB5cEF
AggU7KhQw4wKH0TQNCjgBAkCFBoIHUq0wYUXQk3gKFr0gIwTM1GumKAQhgMM
BxEmFHggakcQNBiKePAgrI2FEFmc7BiB5USQWFsq5OqVIQcQHDKCdAHjLEIW
C1qsZdgAhYaOKUKsGNAg4VMVQJkqQLGBKdMbBjoIjXGgRYa6Zx0AGLBTYQUQ
ikHEMDmxAYgZK0oj1ADyhUCCDD1MuOGyIQyQqzkmDOGgd8YUMWwIVKv1BVjZ
NCEmiNwAAYQYlrNbFvj54IsRNXobZKdrY8No47JvF5wBUmtH9xTTSqQRAoHC
+wbx+824fDD8/1k59NABnxlEwX42HHifgvkxeFAByrGgggwMMCBThRVeiKGG
GWLYoUAWpMWViCSOaCILJRAQgAAltnjii2mdQEALAQEAOw==
}

#Check for illegal Values and set to default values

proc checkConfigFilterGraph {} { 

  global FilterMaxMoves FilterMinMoves FilterStepMoves FilterMaxElo FilterMinElo FilterStepElo FilterMaxYear FilterMinYear FilterStepYear

  if { $FilterStepMoves < 1 } { set FilterStepMoves 1 }
  if { $FilterStepElo < 1 } { set FilterStepElo 100 }
  if { $FilterStepYear < 1 } { set FilterStepYear 1 }
  if { $FilterMinMoves < 1 } { set FilterMinMoves 1 }
  if { $FilterMinElo < 0 } { set FilterMinElo 2100 }
  if { $FilterMinYear < 1 } { set FilterMinYear 1995 }
  if { $FilterMaxMoves < 1 } { set FilterMaxMoves 80 }
  if { $FilterMaxElo < 1 } { set FilterMaxElo 2800 }
  if { $FilterMaxYear < 1 } { set FilterMaxYear $::maxyear }
}

proc configureFilterGraph {parent} {

  global FilterMaxMoves FilterMinMoves FilterStepMoves FilterMaxElo FilterMinElo FilterStepElo FilterMaxYear FilterMinYear FilterStepYear FilterGuessELO

  set w .configFilterGraph
  if {[winfo exists $w]} {
    destroy $w
  }

  toplevel $w
  wm title $w $::tr(ConfigureFilter)
  wm withdraw $w

  bind $w <F1> {helpWindow Graphs Filter}
  standardShortcuts $w
  frame $w.filter
  set col 0
  set row 0
    #Create input for each configurationvalue
    foreach { i n } { Year Year Elo Rating Moves moves} {
      label $w.filter.label$i -text [string totitle $::tr($n)] -font font_Regular
      grid $w.filter.label$i -row $row -column $col -sticky w
      incr col
      foreach {j k} { FilterMin "  " FilterMax " - " FilterStep "  Interval"} {
	  label $w.filter.label$j$i -text $k -font font_Regular
	  entry $w.filter.i$j$i -textvariable $j$i -justify right -width 5 -validate all -vcmd { regexp {^[0-9]{0,4}$} %P }
	  grid $w.filter.label$j$i -row $row -column $col -sticky w -padx 3 -pady 3
	  incr col
	  grid $w.filter.i$j$i -row $row -column $col -sticky w -padx 3 -pady 3
	  incr col
      }
      if { $i == "Elo" } {
	  checkbutton $w.filter.iEloGuess -text $::tr(FilterEstimate) -onvalue 1 -offvalue 0 -variable FilterGuessELO
	  grid $w.filter.iEloGuess -row $row -column $col -sticky w
#	  incr col
      }	    
      incr row
      set col 0
  }

  button $w.close -textvar ::tr(Close) -command {
      checkConfigFilterGraph; ::tools::graphs::filter::Refresh
      ::tools::graphs::absfilter::Refresh; destroy .configFilterGraph  }
  button $w.standard -textvar ::tr(Defaults) -command {
      set FilterMinElo 2100
      set FilterMaxElo 2800
      set FilterStepElo 100
      set FilterMinYear 1995
      set FilterMaxYear $::maxyear
      set FilterStepYear 1
      set FilterMinMoves 5
      set FilterMaxMoves 80
      set FilterStepMoves 1
      set FilterGuessELO 1
  }
  button $w.update -textvar ::tr(Update) -command { checkConfigFilterGraph
      ::tools::graphs::absfilter::Refresh;
      ::tools::graphs::filter::Refresh
  }

  pack $w.filter
  pack $w.close $w.update $w.standard -side right -padx 2 -pady 2
  # focus $w.filter.iFilterMinYear
  
  placeWinOverParent $w $parent
  wm deiconify $w
}

### Filter graph window
# ::tools::graphs::filter::type  can be "decade", "year" or "elo" , "move"

proc tools::graphs::filter::Open {} {

  set w .fgraph
  if {[winfo exists $w]} {
    raiseWin $w
    return
  }

  toplevel $w
  wm title $w $::tr(TitleFilterGraph)
  wm minsize $w 300 300
  wm withdraw $w

  bind $w <Destroy> {}

  frame $w.b
  pack $w.b -side bottom -fill x
  label $w.b.status -width 1 -font font_Small -anchor w
  frame $w.sep -height 2 -borderwidth 2 -relief sunken 
  pack $w.sep -side bottom -fill x -pady 4

  canvas $w.c -width 600 -height 400
  $w.c create text 25 5 -tag title -justify center -width 1 \
    -font font_Small -anchor n
  $w.c create text 250 295 -tag type -justify center -width 1 \
    -font font_Small -anchor s
  pack $w.c -side top -expand yes -fill both
  ::utils::graph::create filter

  bind $w <F1> {helpWindow Graphs Filter}
  standardShortcuts $w
  # bind $w.c <1> tools::graphs::filter::Switch
  bind $w.c <3> ::tools::graphs::filter::Refresh
  bind $w <Escape> "destroy $w"

  foreach {name text} {decade Decade year Year elo Rating move moves} {
    radiobutton $w.b.$name -padx 4 -pady 3 -text [string totitle $::tr($text)] \
      -variable ::tools::graphs::filter::type -value $name \
      -command ::tools::graphs::filter::Refresh
    pack $w.b.$name -side left -padx 1 -pady 2
  }
  button $w.b.setup -image icongraphic -command "configureFilterGraph $w"
  dialogbutton $w.b.close -text $::tr(Close) -command "destroy $w"
  pack $w.b.decade $w.b.elo -side left -padx 1 -pady 2
  pack $w.b.close $w.b.setup -side right -padx 2 -pady 2
  pack $w.b.status -side left -padx 2 -pady 2 -fill x -expand yes

  ::tools::graphs::filter::Refresh
  setWinLocation $w
  setWinSize $w
  wm deiconify $w
  bind $w <Configure> {
    .fgraph.c itemconfigure title -width [expr {[winfo width .fgraph.c] - 50}]
    .fgraph.c coords title [expr {[winfo width .fgraph.c] / 2}] 10
    .fgraph.c itemconfigure type -width [expr {[winfo width .fgraph.c] - 50}]
    .fgraph.c coords type [expr {[winfo width .fgraph.c] / 2}] \
      [expr {[winfo height .fgraph.c] - 10}]
    ::utils::graph::configure filter -height [expr {[winfo height .fgraph.c] - 80}]
    ::utils::graph::configure filter -width [expr {[winfo width .fgraph.c] - 60}]
    ::utils::graph::redraw filter
    recordWinSize .fgraph
  }
}

proc tools::graphs::filter::Switch {} {
  variable type
  switch $type {
    "decade" { set type "year" }
    "year" { set type "elo" }
    "elo" { set type "move" }
    "move" { set type "decade" }
  }
  ::tools::graphs::filter::Refresh
}

proc ::tools::graphs::filter::Refresh {} {
  global FilterMaxMoves FilterMinMoves FilterStepMoves FilterMaxElo FilterMinElo FilterStepElo FilterMaxYear FilterMinYear FilterStepYear FilterGuessELO

  set w .fgraph
  if {! [winfo exists $w]} { return }

  $w.c itemconfigure title -width [expr {[winfo width $w.c] - 50}]
  $w.c coords title [expr {[winfo width $w.c] / 2}] 10
  $w.c itemconfigure type -width [expr {[winfo width $w.c] - 50}]
  $w.c coords type [expr {[winfo width $w.c] / 2}] \
    [expr {[winfo height $w.c] - 10}]
  set height [expr {[winfo height $w.c] - 80}]
  set width [expr {[winfo width $w.c] - 60}]
  set vlines {}
  if {$::tools::graphs::filter::type == "elo"} {
    # Vertical lines for Elo-range graph:
    for {set i 1} {$i <=  $FilterMaxElo- $FilterMinElo} { incr i } {
      lappend vlines [list gray90 1 at $i.5]
    }
  } elseif {$::tools::graphs::filter::type == "year"} {
    # Vertical lines for Year-range graph:
    for {set i 1} {$i <= $FilterMaxYear- $FilterMinYear} {incr i } {
      lappend vlines [list gray90 1 at $i.5]
    }
  } elseif {$::tools::graphs::filter::type == "decade"} {
    # Vertical lines for Decade graph: most are gray, but those
    # just before 1950s and 2000s are blue to make them stand out.
    for {set i 1} {$i < 10} {incr i} {
      set vlineColor gray90
      if {$i == 4  ||  $i == 9} { set vlineColor steelBlue }
      lappend vlines [list $vlineColor 1 at $i.5]
    }
  }

  ::utils::graph::create filter -width $width -height $height -xtop 40 -ytop 35 \
    -ytick 1 -xtick 1 -font font_Small -canvas $w.c -textcolor black \
    -vline $vlines -tickcolor black -xmin 0 -xmax 1
  ::utils::graph::redraw filter
  busyCursor .
  update

  set count 0
  set dlist {}
  set xlabels {}
  set max 0.0

  # Generate plot values and labels:
  if {$::tools::graphs::filter::type == "decade"} {
    set ftype date
    set typeName $::tr(Decade)
    set rlist [list 0000 1919 -1919  1920 1929 20-29 \
                 1930 1939 30-39  1940 1949 40-49  1950 1959 50-59 \
                 1960 1969 60-69  1970 1979 70-79  1980 1989 80-89 \
                 1990 1999 90-99  2000 2009 00-09  2010 2019 2010+]
  } elseif {$::tools::graphs::filter::type == "year"} {
    set ftype date
    set typeName $::tr(Year)
    set endYear $FilterMaxYear
    set startYear $FilterMinYear
    set rlist {}
    for {set i $startYear} {$i <= $endYear} {set i [expr {$i + $FilterStepYear}]} {
      lappend rlist $i
      lappend rlist [expr {$i+$FilterStepYear-1}]
      lappend rlist [expr {$i+$FilterStepYear/2}]
    }
  } elseif {$::tools::graphs::filter::type == "elo"} {
    set ftype elo
    set typeName $::tr(Rating)
#    set rlist [list 0 1999 0-1999  2000 2099 20xx  2100 2199 21xx  \
                 2200 2299 22xx  2300 2399 23xx  2400 2499 24xx  \
                 2500 2599 25xx  2600 2699 26xx  2700 3999 2700+]
    set endElo $FilterMaxElo
    set startElo $FilterMinElo
    set rlist {}
    for {set i $startElo} {$i <= $endElo} {set i [expr {$i + $FilterStepElo}]} {
      lappend rlist $i
      lappend rlist [expr {$i+$FilterStepElo-1}]
      # shorten gap between 0 and "useful" ratings 1800
      set j $i
	if { $i < 100 } { set i [expr { 1800 - $FilterStepElo}] }
      lappend rlist [concat $j-[expr {$i+$FilterStepElo-1}]]
    }
  } else {
      set ftype move
      set typeName $::tr(moves)
      set startMove $FilterMinMoves
      set endMove  $FilterMaxMoves
      set rlist {}
      for {set i $startMove} {$i <= $endMove} {set i [expr {$i + $FilterStepMoves}]} {
	  lappend rlist [expr {2*$i}]
	  lappend rlist [expr {2*($i+$FilterStepMoves)-1}]
	  if { $i % 5 == 0 } {
	      lappend rlist $i
	  } else {
	      lappend rlist ""
	  }
      }
  }

  foreach {start end label} $rlist {
    if {$ftype == "date"} { append end ".12.31" }
    set r [sc_filter freq $ftype $start $end $FilterGuessELO]
    set filter [lindex $r 0]
    set all [lindex $r 1]
    if {$all == 0} {
      set freq 0.0
    } else {
      set freq [expr {double($filter) * 1000.0 / double($all)}]
    }
    if {$freq >= 1000.0} { set freq 999.9 }
    incr count
    lappend dlist $count
    lappend dlist $freq
    if {$freq > $max} { set max $freq }
    lappend xlabels [list $count $label]
  }

  # Find a suitable spacing of y-axis labels:
  set ytick 0.1
  if {$max > 1.0} { set ytick 0.2 }
  if {$max > 2.5} { set ytick 0.5 }
  if {$max >   5} { set ytick   1 }
  if {$max >  10} { set ytick   2 }
  if {$max >  25} { set ytick   5 }
  if {$max >  50} { set ytick  10 }
  if {$max > 100} { set ytick  20 }
  if {$max > 250} { set ytick  50 }
  if {$max > 500} { set ytick 100 }
  set hlines [list [list gray90 1 each $ytick]]
  # Add mean horizontal line:
  set filter [sc_filter count]
  set all [sc_base numGames]
  if {$all > 0} {
    set mean [expr {double($filter) * 1000.0 / double($all)}]
    if {$mean >= 1000.0} { set mean 999.9 }
    lappend hlines [list rosybrown 2 at $mean]
  }

  # Create fake dataset with bounds so we see 0.0::
  #::utils::graph::data decade bounds -points 0 -lines 0 -bars 0 -coords {1 0.0 1 0.0}

  ::utils::graph::data filter data -color steelblue -points $::tools::graphs::showpoints -lines 1 -bars 0 \
    -linewidth 2 -radius 2 -outline steelblue -coords $dlist
  ::utils::graph::configure filter -xlabels $xlabels -ytick $ytick \
    -hline $hlines -ymin 0 -xmin 0.5 -xmax [expr {$count + 0.5}]
  ::utils::graph::redraw filter
  $w.c itemconfigure title -text $::tr(GraphFilterTitle)
  $w.c itemconfigure type -text $typeName
  $w.b.status configure -text "  $::tr(Filter): [filterText]"
  unbusyCursor .
  update
}

#Klimmek: Invert white/black Score in Score graph
set ::tools::graphs::score::White 0
set ::tools::graphs::score::Black 0

### Game Score graph

proc ::tools::graphs::score::Toggle {} {
  set w .sgraph
  if {[winfo exists $w]} {
    destroy $w
  } else {
    ::tools::graphs::score::Init
  }
}

proc ::tools::graphs::score::Init {} {
  ::tools::graphs::score::Refresh2 1
}

proc ::tools::graphs::score::Refresh {} {
  after cancel ::tools::graphs::score::Refresh2
  after idle ::tools::graphs::score::Refresh2
}

proc ::tools::graphs::score::Refresh2 {{init 0}} {
  set w .sgraph

  if {![winfo exists $w.c] && ! $init} {
    return
  }

  set linecolor steelblue
  set linewidth 2
  set psize 2

  if {![winfo exists $w]} {
    ::createToplevel $w
    ::setTitle $w "[tr ToolsScore]"

    setWinLocation $w
    setWinSize $w

    menu $w.menu
    ::setMenu $w $w.menu

    $w.menu add cascade -label GraphFile -menu $w.menu.file
    menu $w.menu.file
    $w.menu.file add command -label GraphFileColor \
      -command "::tools::graphs::Save color $w.c"
    $w.menu.file add command -label GraphFileGrey \
      -command "::tools::graphs::Save gray $w.c"
    $w.menu.file add separator
    $w.menu.file add command -label GraphFileClose -command "destroy $w"

    $w.menu add cascade -label GraphOptions -menu $w.menu.options
    #Klimmek: Checkbuttons for Invert white/black Score in Score graph
    menu $w.menu.options
    foreach i {White Black} {
      $w.menu.options add checkbutton -label GraphOptions$i \
        -variable ::tools::graphs::score::$i  -command ::tools::graphs::score::Refresh
    }

    $w.menu.options add checkbutton -label {Show Dots} \
      -variable ::tools::graphs::showpoints -command ::tools::graphs::score::Refresh

    $w.menu add cascade -label $::tr(Help) -menu $w.menu.help -underline 0
    menu $w.menu.help
    $w.menu.help add command -label $::tr(Help)  -accelerator F1 -command {helpWindow Graphs Score}

    canvas $w.c -width 500 -height 300
    $w.c create text 25 5 -tag text -justify center -width 1 -font font_Regular -anchor n
    # $w.c create text 25 340 -tag text2 -text {Move Number} -justify center -font font_Regular
    pack $w.c -side top -expand yes -fill both
    bind $w <F1> {helpWindow Graphs Score}
    standardShortcuts $w
    bind $w <Configure> {
      .sgraph.c itemconfigure text -width [expr {[winfo width .sgraph.c] - 50}]
      # .sgraph.c itemconfigure text2 -width [expr {[winfo width .sgraph.c] - 50}]
      .sgraph.c coords text [expr {[winfo width .sgraph.c] / 2}] 2
      ::utils::graph::configure score -height [expr {[winfo height .sgraph.c] - 90}]
      ::utils::graph::configure score -width [expr {[winfo width .sgraph.c] - 50}]
      ::utils::graph::redraw score
      recordWinSize .sgraph
    }
    bind $w.c <ButtonPress-3> ::tools::graphs::score::Refresh
    bind $w.c <ButtonPress-1> {::tools::graphs::score::Move %x %y}
    bind $w.c <ButtonPress-2> {::tools::graphs::score::ShowBoard %x %y %X %Y}
    bind $w.c <ButtonRelease-2> ::pgn::HideBoard
    bind $w <Escape> "destroy $w"
    bind $w <Control-Z> "destroy $w"

    ::tools::graphs::score::ConfigMenus
    ::createToplevelFinalize $w
  }

  $w.c itemconfigure text -width [expr {[winfo width $w.c] - 50}]
  $w.c coords text [expr {[winfo width $w.c] / 2}] 2
  set height [expr {[winfo height $w.c] - 90} ]
  set width [expr {[winfo width $w.c] - 50} ]
  ::utils::graph::create score -width $width -height $height -xtop 25 -ytop 50 \
    -ytick 1 -xtick 5 -font font_Small -canvas $w.c -textcolor black \
    -hline {{gray90 1 each 1} {black 1 at 0}} \
    -vline {{gray90 1 each 1} {steelBlue 1 each 5}}

  # Create fake dataset with bounds so we see at least -1.0 to 1.0:
  ::utils::graph::data score bounds -points 0 -lines 0 -bars 0 -coords {1 -0.9 1 0.9}

  # Update the graph:
  set whiteelo [sc_game tag get WhiteElo]
  set blackelo [sc_game tag get BlackElo]  
  if {$whiteelo == 0} {set whiteelo ""} else {set whiteelo "($whiteelo)"}
  if {$blackelo == 0} {set blackelo ""} else {set blackelo "($blackelo)"}  
  switch [sc_game tag get Result] {
    1 {
  $w.c itemconfigure text -text "[sc_game info white] $whiteelo - [sc_game info black] $blackelo (1-0)\n[sc_game info site]  [sc_game info date]"
    }
    0 {
  $w.c itemconfigure text -text "[sc_game info white] $whiteelo - [sc_game info black] $blackelo (0-1)\n[sc_game info site]  [sc_game info date]"
    }
    = {
  $w.c itemconfigure text -text "[sc_game info white] $whiteelo - [sc_game info black] $blackelo (1/2-1/2)\n[sc_game info site]  [sc_game info date]"
    }
    default {
  $w.c itemconfigure text -text "[sc_game info white] $whiteelo - [sc_game info black] $blackelo\n[sc_game info site]  [sc_game info date]"
    }
  }
  #Klimmek: Invert white/black Score in Score graph
  catch {::utils::graph::data score data -color $linecolor -points 0 -lines 0 -bars 1 \
             -barwidth .7 -outline grey \
             -coords [sc_game scores $::tools::graphs::score::White $::tools::graphs::score::Black]}
  ::utils::graph::redraw score
}

proc ::tools::graphs::score::ConfigMenus {{lang ""}} {

  if {! [winfo exists .sgraph]} { return }
  if {$lang == ""} { set lang $::language }
  set m .sgraph.menu
  foreach idx {0 1} tag {File Options} {
    configMenuText $m $idx Graph$tag $lang
  }
  foreach idx {0 1 3} tag {Color Grey Close} {
    configMenuText $m.file $idx GraphFile$tag $lang
  }
  #Klimmek: translate optionsmenu
  foreach idx {0 1} tag {White Black} {
    configMenuText $m.options $idx GraphOptions$tag $lang
  }
}

proc ::tools::graphs::score::Move {x y} {
  if {$y < 50} {return} ; # clicked on header
  set movenum [expr {round([::utils::graph::xunmap score $x] * 2)-1} ]
  sc_move start
  sc_move forward $movenum
  updateBoard
}

# Derived from pgn::ShowBoard

proc ::tools::graphs::score::ShowBoard {x y xc yc} {
    if {$y < 50} {return} ; # clicked on header
    set win .sgraph

    # get movenumber 
    set movenum [expr {round([::utils::graph::xunmap score $x] * 2)-1} ]

    # Do these pushes/pops break anything elsewhere ?
    sc_game push copyfast
    sc_move ply $movenum
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


set ::tools::graphs::rating::year 1900
set ::tools::graphs::rating::elo 0
set ::tools::graphs::rating::type both
set ::tools::graphs::rating::players {} 
set ::tools::graphs::rating::colors {steelblue seagreen rosybrown violet sandybrown skyblue indianred slateblue orange}

### Rating graph

proc ::tools::graphs::rating::Refresh {{player {}}} {

  set w .rgraph

  if {[winfo exists $w]} {
    raiseWin $w
  } else {
    ::createToplevel $w
    ::setTitle $w "[tr ToolsRating]"

    menu $w.menu
    ::setMenu $w $w.menu

    $w.menu add cascade -label GraphFile -menu $w.menu.file
    menu $w.menu.file
    $w.menu.file add command -label GraphFileColor \
      -command "::tools::graphs::Save color $w.c"
    $w.menu.file add command -label GraphFileGrey \
      -command "::tools::graphs::Save gray $w.c"
    $w.menu.file add separator
    $w.menu.file add command -label GraphFileClose -command "destroy $w"

    $w.menu add cascade -label GraphOptions -menu $w.menu.showdots
    menu $w.menu.showdots
    $w.menu.showdots add checkbutton -label {Show Dots} \
      -variable ::tools::graphs::showpoints -command ::tools::graphs::rating::Refresh

    $w.menu add cascade -label {Start Year} -menu $w.menu.options
    menu $w.menu.options
    foreach i {1900 1980 1985 1990 1995 2000 2005 2010 2015 } {
      $w.menu.options add radiobutton -label "Since $i" \
        -variable ::tools::graphs::rating::year -value $i \
        -command ::tools::graphs::rating::Refresh
    }

    $w.menu add cascade -label {Start ELO} -menu $w.menu.elo
    menu $w.menu.elo
    foreach i {0 500 1000 1500 1800 2000 2200 2300 2400 2500 2600} {
      $w.menu.elo add radiobutton -label "Elo $i" \
        -variable ::tools::graphs::rating::elo -value $i \
        -command ::tools::graphs::rating::Refresh
    }

    $w.menu add cascade -label $::tr(Help) -menu $w.menu.help 
    menu $w.menu.help
    $w.menu.help add command -label $::tr(Help) -accelerator F1 -command {helpWindow Graphs Rating}

    canvas $w.c -width 500 -height 300
    $w.c create text 25 5 -tag text -justify left -width 1 -font font_Regular -anchor n
    # the above height, width, x, y are reset below
    pack $w.c -side top -expand yes -fill both
    bind $w <F1> {helpWindow Graphs Rating}
    standardShortcuts $w
    bind $w <Configure> {
      .rgraph.c itemconfigure text -width [expr {[winfo width .rgraph.c] - 50} ]
      .rgraph.c coords text [expr {[winfo width .rgraph.c] / 2} ] 5
      ::utils::graph::configure ratings -height [expr {[winfo height .rgraph.c] - 60} ]
      ::utils::graph::configure ratings -width [expr {[winfo width .rgraph.c] - 70} ]
      ::utils::graph::configure ratings -logy 10
      ::utils::graph::redraw ratings
      update
      recordWinSize .rgraph
    }
    bind $w.c <Button-3> ::tools::graphs::rating::Refresh
    bind $w <Escape> "destroy $w"
    bind $w <Destroy> {set ::tools::graphs::rating::players {}}

    ::tools::graphs::rating::ConfigMenus
    setWinLocation $w
    setWinSize $w
    ::createToplevelFinalize $w
  }

  set lwidth 2
  set psize 2

  $w.c itemconfigure text -width [expr {[winfo width $w.c] - 50} ]
  $w.c coords text [expr {[winfo width $w.c] / 2} ] 5
  set height [expr {[winfo height $w.c] - 60} ]
  set width [expr {[winfo width $w.c] - 70} ]
  ::utils::graph::create ratings -width $width -height $height -xtop 40 -ytop 30 \
    -ytick 50 -xtick 1 -font font_Small -canvas $w.c -textcolor black \
    -hline {{gray90 1 each 25} {steelBlue 1 each 100}} \
    -vline {{gray90 1 each 1} {steelBlue 1 each 5}}
  ::utils::graph::redraw ratings
  busyCursor $w
  update

  set title "[tr ToolsRating] \[[file tail [sc_base filename]]\]"

  set year $::tools::graphs::rating::year
  set elo $::tools::graphs::rating::elo

  if {($player == {both} || $player == {}) && $::tools::graphs::rating::players == {}} {
    set players {}
    set p1 [sc_game info white]
    if {$p1 != {?}} {lappend players $p1}
    set p2 [sc_game info black]
    if {$p2 != {?}} {lappend players $p2}
    set ::tools::graphs::rating::players $players
  }

  if {$player != {} && $player != {both}} {
    # player already in graph ?
    set i [lsearch $::tools::graphs::rating::players $player]

    if {$i == -1} {
      # add player
      lappend ::tools::graphs::rating::players $player
    } else {
      # remove player
      set ::tools::graphs::rating::players [lreplace $::tools::graphs::rating::players $i $i]

    }
  }

  # Re-add data for every player

  set i 1
  foreach p $::tools::graphs::rating::players {
    set key [::utils::string::Surname $p]
    set color [lindex $::tools::graphs::rating::colors [expr ($i - 1) % [llength $::tools::graphs::rating::colors]]]
    catch {
      ::utils::graph::data ratings d$i -color $color -points $::tools::graphs::showpoints -lines 1 \
	       -linewidth $lwidth -radius $psize -outline $color \
	       -key $key -coords [sc_name info -ratings:$year -elo:$elo $p]
    }
    incr i
  }

  set minYear [expr {int([::utils::graph::cget ratings axmin])} ]
  set maxYear [expr {int([::utils::graph::cget ratings axmax])} ]
  ::utils::graph::configure ratings -xtick 1
  if {[expr {$maxYear - $minYear} ] > 10} {::utils::graph::configure ratings -xtick 5}
  ::utils::graph::redraw ratings
  $w.c itemconfigure text -text $title
  unbusyCursor $w
}

proc ::tools::graphs::rating::ConfigMenus {{lang ""}} {
  if {! [winfo exists .rgraph]} { return }
  if {$lang == ""} { set lang $::language }
  set m .rgraph.menu
  foreach idx {0} tag {File} {
    configMenuText $m $idx Graph$tag $lang
  }
  configMenuText $m 1 GraphOptions $lang

  foreach idx {0 1 3} tag {Color Grey Close} {
    configMenuText $m.file $idx GraphFile$tag $lang
  }
}


########################################
# Filter graph window for absolut values

# ::tools::graphs::absfilter::type
#   can be "decade", "year" or "elo", "move"
#

proc tools::graphs::absfilter::Open {} {
  set w .afgraph

  if {[winfo exists $w]} {
    raiseWin $w
    return
  }
  toplevel $w
  wm withdraw $w
  wm title $w $::tr(TitleFilterGraph)
  wm minsize $w 300 300

  bind $w <Destroy> {}
  bind $w <Control-J> tools::graphs::absfilter::Open

  frame $w.b
  pack $w.b -side bottom -fill x
  label $w.b.status -width 1 -font font_Small -anchor w
  frame $w.sep -height 2 -borderwidth 2 -relief sunken 
  pack $w.sep -side bottom -fill x -pady 4

  canvas $w.c -width 600 -height 400
  $w.c create text 25 5 -tag title -justify center -width 1 \
    -font font_Small -anchor n
  $w.c create text 250 295 -tag type -justify center -width 1 \
    -font font_Small -anchor s
  pack $w.c -side top -expand yes -fill both
  ::utils::graph::create absfilter

  bind $w <F1> {helpWindow Graphs Filter}
  standardShortcuts $w
  # bind $w.c <1> tools::graphs::absfilter::Switch
  bind $w.c <3> ::tools::graphs::absfilter::Refresh
  bind $w <Escape> "destroy $w"
  foreach {name text} {decade Decade year Year elo Rating move moves} {
    radiobutton $w.b.$name -padx 4 -pady 3 -text [string totitle $::tr($text)] \
      -variable ::tools::graphs::absfilter::type -value $name \
      -command ::tools::graphs::absfilter::Refresh
    pack $w.b.$name -side left -padx 1 -pady 2
  }
  button $w.b.setup -image icongraphic -command "configureFilterGraph $w"
  dialogbutton $w.b.close -text $::tr(Close) -command "destroy $w"
  pack $w.b.decade $w.b.elo -side left -padx 1 -pady 2
  pack $w.b.close $w.b.setup -side right -padx 2 -pady 2
  pack $w.b.status -side left -padx 2 -pady 2 -fill x -expand yes

  ::tools::graphs::absfilter::Refresh
  setWinLocation $w
  setWinSize $w
  wm deiconify $w
  bind $w <Configure> {
    .afgraph.c itemconfigure title -width [expr {[winfo width .afgraph.c] - 50}]
    .afgraph.c coords title [expr {[winfo width .afgraph.c] / 2}] 10
    .afgraph.c itemconfigure type -width [expr {[winfo width .afgraph.c] - 50}]
    .afgraph.c coords type [expr {[winfo width .afgraph.c] / 2}] \
      [expr {[winfo height .afgraph.c] - 10}]
    ::utils::graph::configure absfilter -height [expr {[winfo height .afgraph.c] - 80}]
    ::utils::graph::configure absfilter -width [expr {[winfo width .afgraph.c] - 60}]
    ::utils::graph::redraw absfilter
    recordWinSize .afgraph
  }
}

proc tools::graphs::absfilter::Switch {} {
  variable type
  switch $type {
    "decade" { set type "year" }
    "year" { set type "elo" }
    "elo" { set type "move" }
    "move" { set type "decade" }
  }
  ::tools::graphs::absfilter::Refresh
}

proc ::tools::graphs::absfilter::Refresh {} {
  global FilterMaxMoves FilterMinMoves FilterStepMoves FilterMaxElo FilterMinElo FilterStepElo FilterMaxYear FilterMinYear FilterStepYear FilterGuessELO

  set w .afgraph
  if {! [winfo exists $w]} { return }

  $w.c itemconfigure title -width [expr {[winfo width $w.c] - 50}]
  $w.c coords title [expr {[winfo width $w.c] / 2}] 10
  $w.c itemconfigure type -width [expr {[winfo width $w.c] - 50}]
  $w.c coords type [expr {[winfo width $w.c] / 2}] \
    [expr {[winfo height $w.c] - 10}]
  set height [expr {[winfo height $w.c] - 80}]
  set width [expr {[winfo width $w.c] - 60}]
  set vlines {}
  if {$::tools::graphs::absfilter::type == "elo"} {
    # Vertical lines for Elo-range graph:
    for {set i 1} {$i <=  $FilterMaxElo- $FilterMinElo} { incr i } {
      lappend vlines [list gray90 1 at $i.5]
    }
  } elseif {$::tools::graphs::absfilter::type == "year"} {
    # Vertical lines for Year-range graph:
    for {set i 1} {$i <= $FilterMaxYear- $FilterMinYear} {incr i } {
      lappend vlines [list gray90 1 at $i.5]
    }
  } elseif {$::tools::graphs::absfilter::type == "decade"} {
    # Vertical lines for Decade graph: most are gray, but those
    # just before 1950s and 2000s are blue to make them stand out.
    for {set i 1} {$i < 10} {incr i} {
      set vlineColor gray90
      # if {$i == 4  ||  $i == 9} { set vlineColor steelBlue }
      lappend vlines [list $vlineColor 1 at $i.5]
    }
  } else {
    ### moves
    for {set i 1} {$i <= $FilterMaxMoves - $FilterMinMoves} {incr i} {
      # this is a son of a bitch thing, and is broken S.A.
      # FilterMinMoves is fucked around somewhere else too.
      # if {[expr $i % 5] == [expr $FilterMinMoves % 5]}
      lappend vlines [list gray90 1 at $i]
    }
  } 

  ::utils::graph::create absfilter -width $width -height $height -xtop 40 -ytop 35 \
    -ytick 1 -xtick 1 -font font_Small -canvas $w.c -textcolor black \
    -vline $vlines -tickcolor black -xmin 0 -xmax 1
  ::utils::graph::redraw absfilter
  busyCursor .
  update

  set count 0
  set dlist {}
  set xlabels {}
  set max 0.0

  # Generate plot values and labels:
  if {$::tools::graphs::absfilter::type == "decade"} {
    set ftype date
    set typeName $::tr(Decade)
    set rlist [list 0000 1919 -1919  1920 1929 20-29 \
                 1930 1939 30-39  1940 1949 40-49  1950 1959 50-59 \
                 1960 1969 60-69  1970 1979 70-79  1980 1989 80-89 \
                 1990 1999 90-99  2000 2009 00-09  2010 2019 2010+]
  } elseif {$::tools::graphs::absfilter::type == "year"} {
    set ftype date
    set typeName $::tr(Year)
    set endYear $FilterMaxYear
    set startYear $FilterMinYear
    set rlist {}
    for {set i $startYear} {$i <= $endYear} {set i [expr {$i + $FilterStepYear}]} {
      lappend rlist $i
      lappend rlist [expr {$i+$FilterStepYear-1}]
      lappend rlist [expr {$i+$FilterStepYear/2}]
    }
  } elseif {$::tools::graphs::absfilter::type == "elo"} {
    set ftype elo
    set typeName $::tr(Rating)
#    set rlist [list 0 1999 0-1999  2000 2099 20xx  2100 2199 21xx  \
                 2200 2299 22xx  2300 2399 23xx  2400 2499 24xx  \
                 2500 2599 25xx  2600 2699 26xx  2700 3999 2700+]
    set endElo $FilterMaxElo
    set startElo $FilterMinElo
    set rlist {}
    for {set i $startElo} {$i <= $endElo} {set i [expr {$i + $FilterStepElo}]} {
      lappend rlist $i
      lappend rlist [expr {$i+$FilterStepElo-1}]
      # shorten gap between 0 and "useful" ratings 1800
      set j $i
	if { $i < 100 } { set i [expr { 1800 - $FilterStepElo}] }
      lappend rlist [concat $j-[expr {$i+$FilterStepElo-1}]]
    }
  } else {
      set ftype move
      set typeName $::tr(moves)
      set startMove $FilterMinMoves
      set endMove  $FilterMaxMoves
      set rlist {}
      for {set i $startMove} {$i <= $endMove} {incr i $FilterStepMoves} {
	  lappend rlist [expr {2*$i-1}]
	  lappend rlist [expr {2*($i+$FilterStepMoves)-2}]
	  if { $i % 5 == 0 } {
	      lappend rlist $i
	  } else {
	      lappend rlist ""
	  }
      }
  }

  set mean 0
  foreach {start end label} $rlist {
    if {$ftype == "date"} { append end ".12.31" }
    set r [sc_filter freq $ftype $start $end $FilterGuessELO]
    set absfilter [lindex $r 0]
    set all [lindex $r 1]
    set freq $absfilter  
    incr count
    set mean [expr { $mean + $absfilter }]
    lappend dlist $count
    lappend dlist $freq
    if {$freq > $max} { set max $freq }
    lappend xlabels [list $count $label]
  }

  # Find a suitable spacing of y-axis labels:
  set ytick 1
  if {$max >=  10} { set ytick   1 }
  if {$max >=  25} { set ytick   5 }
#  if {$max >=  50} { set ytick   5 }
  if {$max >= 100} { set ytick  10 }
  if {$max >= 250} { set ytick  25 }
  if {$max >= 500} { set ytick  50 }
  if {$max >= 1000} { set ytick 100 }
  if {$max >= 2500} { set ytick 250 }
  if {$max >= 5000} { set ytick 500 }
  if {$max >= 10000} { set ytick  1000 }
  if {$max >= 25000} { set ytick  2500 }
  if {$max >= 50000} { set ytick  5000 }
  if {$max >= 100000} { set ytick 10000 }
  if {$max >= 250000} { set ytick 25000 }
  if {$max >= 500000} { set ytick 50000 }
  if {$max >= 1000000} { set ytick 100000 }
  set hlines [list [list gray90 1 each $ytick]]
  # Add mean horizontal line:
  set absfilter [sc_filter count]
  set all [sc_base numGames]
  if { $count != 0 } {set mean [expr { $mean / $count }] }
  if {$all > 0} {
    if {$mean > $max} { set max $mean }
    lappend hlines [list rosybrown 2 at $mean]
  }

  # Create fake dataset with bounds so we see 0.0::
  #::utils::graph::data decade bounds -points 0 -lines 0 -bars 0 -coords {1 0.0 1 0.0}

  ::utils::graph::data absfilter data -color steelblue -points $::tools::graphs::showpoints -lines 1 -bars 0 \
    -linewidth 2 -radius 2 -outline steelblue -coords $dlist
  ::utils::graph::configure absfilter -xlabels $xlabels -ytick $ytick \
    -hline $hlines -ymin 0 -xmin 0.5 -xmax [expr {$count + 0.5}]
  ::utils::graph::redraw absfilter
  $w.c itemconfigure title -text $::tr(GraphAbsFilterTitle)
  $w.c itemconfigure type -text $typeName
  $w.b.status configure -text "  $::tr(Filter): [filterText]"
  unbusyCursor .
  update
}
### End of file: graph.tcl
