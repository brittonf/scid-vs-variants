###
### pinfo.tcl # Player Info window
###

set playerInfoName ""

proc playerInfo {{player ""} {raise 0}} {
  global playerInfoName playerInfoHistory
  if {$player == ""} { set player $playerInfoName }
  if {[catch {sc_name info -htext $player} pinfo]} { return }
  set playerInfoName $player

  set ::rgraph(player) $player
  set w .playerInfoWin
  if {! [winfo exists $w]} {
    ::createToplevel $w
    ::setTitle $w "[tr ToolsPInfo]"
    catch {wm state $w withdrawn}
    setWinLocation $w
    wm minsize $w 450 300

    menu $w.menu 
    ::setMenu $w $w.menu
    $w.menu add cascade -label TmtSortPlayers -menu $w.menu.players
    $w.menu add command -label Help -command "helpWindow PInfo"
    $w.menu add command -label FileClose -command "destroy $w"
    menu $w.menu.players -tearoff 1
    playerInfoConfigMenus
    bind $w <Button-3> "tk_popup $w.menu.players %X %Y"

    pack [frame $w.b] -side bottom -expand 1 -fill x -pady 0 -padx 5

    button $w.b.graph -text [tr ToolsRating] \
      -command {::tools::graphs::rating::Refresh $playerInfoName} 
    button $w.b.edit -text $::tr(PInfoEditRatings) -command {
      nameEditor
      setNameEditorType rating
      set editName $playerInfoName
      set editNameSelect crosstable
      set editNameRating {}
    }
    button $w.b.match -text [tr PinfoLookupName] -command {
      set ::plist::name [lindex $playerInfoName 0]
      if {[winfo exists .plist]} {
	::plist::refresh
        raiseWin .plist
      } else {
	::plist::Open
      }
    } -width 10
    button $w.b.nedit -text [tr PinfoEditName] -command {
      nameEditor
      setNameEditorType player
      set editName $playerInfoName
      set editNameNew $playerInfoName
      set editNameSelect all
    } -width 10

    button $w.b.report -text [tr ToolsPlayerReport] -command {::preport::preportDlg $playerInfoName}
    button $w.b.tourney -text [tr WindowsTmt] -command {::tourney::Open $playerInfoName}
    label $w.b.space -width 2
    button $w.b.update -textvar ::tr(Update) -command {playerInfo $playerInfoName} -width 10
    # button $w.b.help -textvar ::tr(Help) -command {helpWindow PInfo} -width 10
    button $w.b.close -textvar ::tr(Close) -command "destroy $w" -width 10

    ### The rightmost four buttons are already set width 10
    ### If English, we can set the other four buttons likewise (and allign nicely)
    if {$::language == "E"} {
      foreach i {graph edit report tourney} {
        $w.b.$i configure -width 10
      }
    }
    foreach i {graph edit report tourney match nedit update close} {
      $w.b.$i configure -font font_Small
    }

    grid columnconfigure $w.b 0 -weight 1
    grid columnconfigure $w.b 1 -weight 1
    grid columnconfigure $w.b 2 -weight 1
    grid columnconfigure $w.b 3 -weight 1
    grid $w.b.graph   -row 0 -column 0 -padx 3 -pady 1 -sticky ew
    grid $w.b.edit    -row 0 -column 1 -padx 3 -pady 1 -sticky ew
    grid $w.b.match   -row 0 -column 2 -padx 3 -pady 1 -sticky ew
    grid $w.b.nedit   -row 0 -column 3 -padx 3 -pady 1 -sticky ew
    grid $w.b.report  -row 1 -column 0 -padx 3 -pady 1 -sticky ew
    grid $w.b.tourney -row 1 -column 1 -padx 3 -pady 1 -sticky ew
    grid $w.b.update  -row 1 -column 2 -padx 3 -pady 1 -sticky ew
    grid $w.b.close   -row 1 -column 3 -padx 3 -pady 1 -sticky ew

    autoscrollframe $w.frame text $w.text -font font_Regular -wrap none

    pack $w.frame -side top -fill both -expand yes
    ::htext::init $w.text
    bind $w <Escape> "focus .main ; destroy $w"
    bind $w <F1> {helpWindow PInfo}
    standardShortcuts $w
    bindWheeltoFont $w

    setWinSize $w
    catch {wm state $w normal}
    bind $w <Configure> "recordWinSize $w"
    ::createToplevelFinalize $w
  } else {
    # Generating a player report refreshs stats, which refreshes this proc
    # So only raise if asked to
    if {$raise != {0}} {
      raiseWin $w
    }
  }

  ### Add player to history
  if {$player != ""} {
    # Remove player from playerInfoHistory (if any)
    while {1} {
      set idx [lsearch -exact $playerInfoHistory $player]
      if {$idx < 0} { break }
      set playerInfoHistory [lreplace $playerInfoHistory $idx $idx]
    }
    set playerInfoHistory [linsert $playerInfoHistory 0 $player]
  }
  set playerInfoHistory [lrange $playerInfoHistory 0 [expr {$::recentFiles(playernames) - 1}]]

  $w.menu.players delete 0 end
  foreach i $playerInfoHistory {
    $w.menu.players add command -label $i -command [list playerInfo $i]
  }

  ### Make FIDEID open relevant url
  regsub {FIDEID ([0-9]+)} $pinfo {<run openURL http://ratings.fide.com/card.phtml?event=%\1 ; ::windows::stats::Refresh>FIDEID \1</run>} pinfo

  ### update main window
  $w.text configure -state normal
  $w.text delete 1.0 end
  ::htext::display $w.text $pinfo

  set player [trimEngineName $player]
  if {[info exists ::photo($player)]} {
    if {[string match *.gif $::photo($player)]} {
        image create photo photoPInfo -file [file join $::scidPhotosDir $::photo($player)]
    } else {
        image create photo photoPInfo -data $::photo($player)
    }
    $w.text configure -state normal
    if {0} {
      label $w.photo 
      $w.photo configure -image photoPInfo -anchor ne
      place $w.photo -in $w.text -relx 1.0 -x -1 -rely 0.0 -y 1 -anchor ne
    } else {
      if {![string match {The name*} $pinfo]} {
	# image now scrolls with the widget
	$w.text insert 2.0 "\n"
	$w.text image create 2.0 -image photoPInfo -align top -padx 3 -pady 5
      } ; # i cant get figging image to be below the text *&^%&!
    }
    $w.text configure -state disabled
  } else {
    # place forget $w.photo
  }

  ::windows::gamelist::Refresh
  ::maint::Refresh

  #raiseWin $w
}

# Refresh after hyperlinks in the playerinfo widget are clicked
# eg: <run sc_name info -oaA {}; ::playerInfoRefresh>GAMES</run>

proc playerInfoRefresh {} {
  set ::glstart 1
  raiseWin .glistWin
  ::windows::stats::Refresh
}

proc playerInfoConfigMenus {} {
  if {![winfo exists .playerInfoWin]} {
    return
  }
  foreach idx {0 1 2} tag {TmtSortPlayers Help FileClose} {
    configMenuText .playerInfoWin.menu $idx $tag $::language
  }
}

###
### end of pinfo.tcl
###
