
####################
# Tournament window

namespace eval ::tourney {}

foreach {n v} {start 0000.00.00 end 2047.12.31 minPlayers 2 maxPlayers 1999 \
                 minGames 1 maxGames 9999 minElo 0 maxElo 4000 sort Date \
                 country "" site "" event "" player "" size 50} {
  set ::tourney::$n $v
}

trace variable ::tourney::start w ::utils::validate::Date
trace variable ::tourney::end w ::utils::validate::Date
foreach {n v} {minPlayers 1999 maxPlayers 1999 minGames 9999 maxGames 9999 \
                 minElo [sc_info limit elo] maxElo [sc_info limit elo]} {
  trace variable ::tourney::$n w [list ::utils::validate::Integer $v 0]
}

proc ::tourney::Open {{player {}}} {
  set w .tourney

  if {[winfo exists $w]} {
    if {$player != {}} {
      set ::tourney::player $player
      set ::tourney::site {}
      set ::tourney::event {}
      ::tourney::refresh
    }
    raiseWin $w
    return
  }

  if {! [info exists ::tourney::_defaults]} { ::tourney::defaults }

  if {$player == {}} {
    # Override the defaults for start-up window. "-10" represents last ten years
    set ::tourney::start "[expr [::utils::date::today year] - 10].01.01"
    set ::tourney::minGames 4
  } else {
    # No start date
    set ::tourney::start 1800.01.01
  }

  toplevel $w
  wm withdraw $w
  setWinLocation $w
  setWinSize $w

  bind $w <F1> {helpWindow Tmt}
  bind $w <Escape> "$w.b.close invoke"
  bind $w <Return> "::tourney::check ; ::tourney::refresh"
  bind $w <Destroy> {}
  # standardShortcuts $w
  # bind $w <Left> break
  # bind $w <Right> break
  bind $w <Up> "$w.t.text yview scroll -1 units"
  bind $w <Down> "$w.t.text yview scroll 1 units"
  bind $w <Prior> "$w.t.text yview scroll -1 pages"
  bind $w <Next> "$w.t.text yview scroll 1 pages"
  bind $w <Key-Home> "$w.t.text yview moveto 0"
  bind $w <Key-End> "$w.t.text yview moveto 0.99"

  foreach i {t o1 o2 o3 b} {frame $w.$i}
  text $w.t.text -width 75 -height 22 -font font_Small -wrap none \
    -fg black  -yscrollcommand "$w.t.ybar set" -setgrid 1 \
    -cursor top_left_arrow -xscrollcommand "$w.t.xbar set"
  scrollbar $w.t.ybar -command "$w.t.text yview" -width 12 -takefocus 0
  scrollbar $w.t.xbar -orient horiz -command "$w.t.text xview" -width 12 \
    -takefocus 0
  set xwidth [font measure [$w.t.text cget -font] "0"]
  set tablist {}

  bindMouseWheel $w $w.t.text
  bindWheeltoFont $w.t.text

  ### tabulation formatting

  #                    Count    Date  Players Games    Elo     Event   Site  Winner Runnerup
  foreach {tab justify} {3 r    4 l    18 r    23 r    30 r    32 l    55 l  76 l    94 l} {
    set tabwidth [expr {$xwidth * $tab} ]
    lappend tablist $tabwidth $justify
  }
  $w.t.text configure -tabs $tablist
  $w.t.text tag configure date -foreground darkGreen
  $w.t.text tag configure np -foreground darkBlue
  $w.t.text tag configure elo -foreground {}
  # $w.t.text tag configure best -foreground steelBlue
  $w.t.text tag configure event -foreground steelBlue
  $w.t.text tag configure title -font font_SmallBold

  set font font_Small
  set fbold font_SmallBold

  # todo - The o1 o2 o3 frames should be gridded. S.A

  set f $w.o1

  # num Games

  label $f.games -text "[tr TmtSortGames]    " -font $fbold
  entry $f.gmin -textvariable ::tourney::minGames \
    -width 5 -justify right -font $font
  bindFocusColors $f.gmin
  bind $f.gmin <FocusOut> +::tourney::check
  label $f.gto -text "-" -font $font
  entry $f.gmax -textvariable ::tourney::maxGames \
    -width 5 -justify right -font $font
  bindFocusColors $f.gmax
  bind $f.gmax <FocusOut> +::tourney::check
  pack $f.games $f.gmin $f.gto $f.gmax -side left

  # Event

  label $f.eventlab -text "   $::tr(Event)" -font $fbold
  ttk::combobox $f.event -textvariable ::tourney::event -width 12
  ::utils::history::SetCombobox ::tourney::event $f.event
  bindFocusColors $f.event
  pack $f.event $f.eventlab -side right

  # Country

  label $f.cn -text "  $::tr(Country)" -font $fbold
  ttk::combobox $f.ecn -width 5 -textvar ::tourney::country -values \
    {{} AUS AUT CZE DEN ENG ESP FRA GER GRE HUN ITA NED POL RUS SCG SUI SWE USA YUG}
  bindFocusColors $f.ecn
  bind $f.ecn <FocusOut> +::tourney::check
  pack $f.ecn $f.cn -side right

  set f $w.o2

  # Num Players

  label $f.players -text "[tr TmtSortPlayers]   " -font $fbold
  entry $f.pmin -textvariable ::tourney::minPlayers \
    -width 5 -justify right -font $font
  bindFocusColors $f.pmin
  bind $f.pmin <FocusOut> +::tourney::check
  label $f.pto -text "-"
  entry $f.pmax -textvariable ::tourney::maxPlayers \
    -width 5 -justify right -font $font
  bindFocusColors $f.pmax
  bind $f.pmax <FocusOut> +::tourney::check
  pack $f.players $f.pmin $f.pto $f.pmax -side left

  # Site

  label $f.sitelab -text "$::tr(Site)" -font $fbold
  ttk::combobox $f.site -textvariable ::tourney::site -width 12
  ::utils::history::SetCombobox ::tourney::site $f.site
  bindFocusColors $f.site
  pack $f.site $f.sitelab -side right

  set f $w.o3

  # Mean ELO

  label $f.elolab -text "$::tr(TmtMeanElo)" -font $fbold
  entry $f.elomin -textvariable ::tourney::minElo \
    -width 5 -justify right -font $font
  bindFocusColors $f.elomin
  label $f.eto -text "-"
  entry $f.elomax -textvariable ::tourney::maxElo \
    -width 5 -justify right -font $font
  bindFocusColors $f.elomax
  pack $f.elolab $f.elomin $f.eto $f.elomax -side left

  # Date

  label $f.from -text "[tr TmtSortDate]" -font $fbold
  entry $f.efrom -textvariable ::tourney::start -width 10 -font $font -justify right
  bindFocusColors $f.efrom
  bind $f.efrom <FocusOut> +::tourney::check
  label $f.to -text "-" -font $font
  entry $f.eto2 -textvariable ::tourney::end -width 10 -font $font -justify right
  bindFocusColors $f.eto2
  bind $f.eto2 <FocusOut> +::tourney::check
  pack [frame $f.space -width 12] $f.from $f.efrom $f.to $f.eto2 -side left

  # Player

  label $f.playerlab -text "$::tr(Player)" -font $fbold
  ttk::combobox $f.player -textvariable ::tourney::player -width 12
  ::utils::history::SetCombobox ::tourney::player $f.player
  bindFocusColors $f.player
  pack $f.player $f.playerlab -side right

  # Button bar

  label $w.b.size -text $::tr(TmtLimit) -font $fbold
  ttk::combobox $w.b.esize -width 7 -justify right -textvar ::tourney::size -values {50 100 200 500 1000 10000 100000}
  trace variable ::tourney::size w {::utils::validate::Integer 100000 0}
  bindFocusColors $w.b.esize

  dialogbutton $w.b.defaults -textvar ::tr(Defaults) -command ::tourney::defaults
  dialogbutton $w.b.update -textvar ::tr(Update) -command "::tourney::check ; ::tourney::refresh"
  dialogbutton $w.b.help -textvar ::tr(Help) -command {helpWindow Tmt}
  dialogbutton $w.b.close -textvar ::tr(Close) -command "destroy $w"
  pack $w.b -side bottom -fill x -pady 5
  packbuttons right $w.b.close $w.b.help $w.b.update  $w.b.esize $w.b.size 
  packbuttons left $w.b.defaults
  pack $w.o3 -side bottom -fill x -padx 2 -pady 2
  pack $w.o2 -side bottom -fill x -padx 2 -pady 2
  pack $w.o1 -side bottom -fill x -padx 2 -pady 2
  pack $w.t -side top -fill both -expand yes
  grid $w.t.text -row 0 -column 0 -sticky news
  grid $w.t.ybar -row 0 -column 1 -sticky news
  grid $w.t.xbar -row 1 -column 0 -sticky news
  grid rowconfig $w.t 0 -weight 1 -minsize 0
  grid columnconfig $w.t 0 -weight 1 -minsize 0

  bind $w <Configure> "recordWinSize $w"
  update
  wm deiconify $w

  if {$player != {}} {
    set ::tourney::player $player
  }
  ::tourney::refresh
}


proc ::tourney::defaults {} {
  set ::tourney::_defaults 1
  set year [::utils::date::today year]
  #set ::tourney::start "$year.??.??"
  set ::tourney::start "1960.??.??"
  set ::tourney::end "$year.12.31"
  set ::tourney::size 1000
  set ::tourney::minPlayers 2
  set ::tourney::maxPlayers 1999
  set ::tourney::minGames 1
  set ::tourney::maxGames 9999
  set ::tourney::minElo 0
  set ::tourney::maxElo 4000
  set ::tourney::country ""
  set ::tourney::site ""
  set ::tourney::event ""
  set ::tourney::player ""
}

proc ::tourney::refresh {{option ""}} {
  set w .tourney
  if {! [winfo exists $w]} { return }

  if {[string length $::tourney::player] < 2} {
    wm title $w "[tr WindowsTmt]: [file tail [sc_base filename]]"
  } else {
    wm title $w "[tr WindowsTmt]: $::tourney::player - [file tail [sc_base filename]]"
  }
  busyCursor $w
  ::utils::history::AddEntry ::tourney::site $::tourney::site
  ::utils::history::AddEntry ::tourney::event $::tourney::event
  ::utils::history::AddEntry ::tourney::player $::tourney::player

  set t $w.t.text
  $t configure -state normal
  $t delete 1.0 end
  update
  set fastmode 0
  if {$option == "-fast"} { set fastmode 1 }

  if {$fastmode  &&  $::tourney::list != ""} {
    set tlist $::tourney::list
  } else {
    if {[catch {sc_base tournaments \
                  -start $::tourney::start \
                  -end $::tourney::end \
                  -size 2500 \
                  -minPlayers $::tourney::minPlayers \
                  -maxPlayers $::tourney::maxPlayers \
                  -minGames $::tourney::minGames \
                  -maxGames $::tourney::maxGames \
                  -minElo $::tourney::minElo \
                  -maxElo $::tourney::maxElo \
                  -country [string toupper $::tourney::country] \
                  -site $::tourney::site \
                  -event $::tourney::event \
                  -player $::tourney::player \
                } tlist]} {
      $t insert end $tlist
      $t configure -state disabled
      unbusyCursor .
      return
    }
    set ::tourney::list $tlist
  }

  ### tlist list elements are
  #
  # {Date, Site, Event, Players, Games, Elo, ?, Winner}

  switch $::tourney::sort {
    "None" {}
    "Date" { set tlist [lsort -decreasing -index 0 $tlist] }
    "Players" { set tlist [lsort -integer -decreasing -index 3 $tlist] }
    "Games" { set tlist [lsort -integer -decreasing -index 4 $tlist] }
    "Elo" { set tlist [lsort -integer -decreasing -index 5 $tlist] }
    "Site" { set tlist [lsort -dict -index 1 $tlist] }
    "Event" { set tlist [lsort -dict -index 2 $tlist] }
    "Winner" { set tlist [lsort -dict -index 7 $tlist] }
  }

  # Title headings

  foreach i {Date Players Games Elo Site Event Winner} {
    $t tag configure s$i -font font_SmallBold
    $t tag bind s$i <1> "
      set ::tourney::sort $i
      ::tourney::refresh -fast"
    $t tag bind s$i <Any-Enter> "$t tag config s$i -background grey85"
    $t tag bind s$i <Any-Leave> "$t tag config s$i -background {}"
  }

  ### Titles

  $t insert end "\t\t"
  $t insert end [tr TmtSortDate] sDate
  $t insert end "\t"
  $t insert end [tr TmtSortPlayers] sPlayers
  $t insert end "\t"
  $t insert end [tr TmtSortGames] sGames
  $t insert end "\t"
  $t insert end [tr TmtSortElo] sElo
  $t insert end "\t"
  $t insert end [tr TmtSortEvent] sEvent
  $t insert end "\t"
  $t insert end [tr TmtSortSite] sSite
  $t insert end "\t"
  $t insert end [tr TmtSortWinner] sWinner

  $t insert end "\n"

  set hc $::rowcolor
  set count 0
  foreach tmt $tlist {
    incr count
    if {$count > $::tourney::size} { break }
    set date [lindex $tmt 0]
    set site [lindex $tmt 1]
    set event [lindex $tmt 2]
    set np [lindex $tmt 3]
    set ng [lindex $tmt 4]
    set elo [lindex $tmt 5]
    set g [lindex $tmt 6]
    set winner [::utils::string::Surname [lindex $tmt 7]]
    set elo1 [lindex $tmt 8]
    set score1 [lindex $tmt 9]
    set runnerup [::utils::string::Surname [lindex $tmt 10]]
    set elo2 [lindex $tmt 11]
    set score2 [lindex $tmt 12]
    if {$elo1 > 0} { append winner " ($elo1)" }
    if {$elo2 > 0} { append runnerup " ($elo2)" }
    # append winner " $score1"
    # append runnerup " $score2"
    ### add an extra space because {1. } is roughly the same width as {1=}
    set one "1. "
    set two "2. "
    if {$score1 == $score2} {
      set one "1="; set two "1="
    }
    set best "$one $winner\t$two $runnerup, ..."
    if {$np == 2} { set best "$one $winner\t$two $runnerup" }

    $t tag bind g$count <ButtonPress-3> [list ::tourney::select $g $event 1]
    $t tag bind g$count <ButtonPress-1> [list ::tourney::select $g $event]
    $t tag bind g$count <Any-Enter> "$t tag configure g$count -background $hc"
    $t tag bind g$count <Any-Leave> "$t tag configure g$count -background {}"
    $t insert end "\n"
    $t insert end "\t$count\t" g$count
    $t insert end $date [list date g$count]
    $t insert end "\t" g$count
    $t insert end $np [list np g$count]
    $t insert end "\t" g$count
    $t insert end $ng [list ng g$count]
    $t insert end "\t" g$count
    $t insert end $elo [list elo g$count]
    $t insert end "\t" g$count
    # These "24" widths don't work perfectly because the fonts aren't fixed
    $t insert end [string range $event 0 24] [list event g$count]
    $t insert end "\t" g$count
    $t insert end [string range $site 0 24] [list site g$count]
    $t insert end "\t$best" g$count
  }
  $t insert end "\n"
  $t configure -state disabled
  unbusyCursor .
}

proc ::tourney::check {} {
  set start $::tourney::start
  set end $::tourney::end
  if {[string length $start] == 0} { set start "0000" }
  if {[string length $end]   == 0} { set end [sc_info limit year]}
  if {[string length $start] == 4} { append start ".??.??" }
  if {[string length $end]   == 4} { append end ".12.31" }
  if {[string length $start] == 7} { append start ".??" }
  if {[string length $end]   == 7} { append end ".31" }
  if {[string match {*.01.01} $start]} { set start "[string range $start 0 end-6].??.??"}
  set ::tourney::start $start
  set ::tourney::end $end
  if {$::tourney::minPlayers < 2} {set ::tourney::minPlayers 2}
  if {$::tourney::minPlayers > $::tourney::maxPlayers} {
    set ::tourney::maxPlayers $::tourney::minPlayers
  }
  set s $::tourney::country
  set s [string toupper [string trim $s]]
  if {[string length $s] > 3} { set s [string range $s 0 2] }
  set ::tourney::country $s
  if {$::tourney::country == "---"} {
    set ::tourney::country ""
  }
}

proc ::tourney::select {gnum event {load 0}} {

  # We now nolonger have to autoload crosstable game
  if {$load} {
    if {[catch {::game::Load $gnum} result]} {
      tk_messageBox -type ok -icon info -title "Scid" -message $result
      return
    }
    flipBoardForPlayerNames
    updateBoard -pgn
    updateTitle
  }

  # Filter this event... Could we catch this ? S.A.
  # ::search::filter::reset
  # ::search::filter::negate
  # sc_game crosstable filter
  # ::windows::gamelist::Refresh

  ::crosstab::Open $gnum
}

