###
### fics.tcl: part of Scid.
###
### Copyright (C) 2007  Pascal Georges
### Copyright Stevenaaus 2010-2013

namespace eval fics {
  set sockchan 0
  set seeklist {}
  set mainGame -1
  set autoload {} ; # autoload this players games
  set observedGames {}
  set primary 0
  set playing 0
  set opponent {}
  set mutex 0
  set waitForMoves ""
  set sought 0
  set soughtlist {}
  set newsoughtlist {}
  set graph(init) 0
  set graph(width) 300
  # graph(height) overlaps the buttons frame, and is calculated below
  set graph(on) 0
  set timeseal_pid 0
  font create font_offers -family courier -size 12 -weight bold
  set history {}
  set history_pos 0
  set history_current {}
  set tells {}
  set tellindex 0
  set offers_minelo 1000
  set offers_maxelo 2500
  set offers_mintime 0
  set offers_maxtime 20
  variable logged 0
  set consolewidth 40
  set consoleheight 10
  set catchRemoving 0
  set premove {}
  set examresult *
  set entrytime 0

  set ignore_abort 0
  set ignore_adjourn 0
  set ignore_draw 0
  set ignore_takeback 0
  set takebackMoves 0

  set ping {}
  set timecontrol {}
  array set shorttype {
    crazyhouse crazy
    bughouse bug
    standard normal
    lightning light
  }

  proc config {} {
    variable logged
    global ::fics::sockChan tr
    set w .ficsConfig

    if {[winfo exists $w]} {
      raiseWin $w
      return
    }

    if {[winfo exists .fics]} {
      raiseWin .fics
      return
    }
    set logged 0

    toplevel $w
    wm state $w withdrawn
    wm title $w "Configure Fics"
    label $w.lLogin -text "$tr(CCDlgLoginName)"
    entry $w.login -width 20 -textvariable ::fics::login
    label $w.lPwd -text [tr "CCDlgPassword"]
    entry $w.passwd -width 20 -textvariable ::fics::password -show "*"

    # Time seal configuration
    checkbutton $w.timeseal -textvar tr(FICSTimeseal) -variable ::fics::use_timeseal \
      -onvalue 1 -offvalue 0 -command {
        if {$::fics::use_timeseal} {
	  .ficsConfig.timeseal_entry configure -state normal
	  .ficsConfig.timeseal_browse configure -state normal
        } else {
	  .ficsConfig.timeseal_entry configure -state disabled
	  .ficsConfig.timeseal_browse configure -state disabled
        }
    }
    entry $w.timeseal_entry -width 20 -textvariable ::fics::timeseal_exec
    button $w.timeseal_browse -textvar tr(Browse) -command { set ::fics::timeseal_exec [tk_getOpenFile -parent .ficsConfig] } -pady 0.8

    if {!$::fics::use_timeseal} {
      $w.timeseal_entry configure -state disabled
      $w.timeseal_browse configure -state disabled
    }

    # Server URL, IP address, Refresh button

    label $w.lServer -text URL   
    entry $w.eServer -textvariable ::fics::server

    label $w.lFICS_ip -textvar tr(FICSServerAddress)
    entry $w.ipserver -textvar ::fics::server_ip 
    button $w.bRefresh -textvar tr(FICSRefresh) -command ::fics::getIP -pady 0.8

    label $w.lFICS_port -textvar tr(FICSServerPort)
    entry $w.portserver -width 6 -textvariable ::fics::port_fics
    label $w.ltsport -textvar tr(FICSTimesealPort)
    entry $w.portts -width 6 -textvariable ::fics::port_timeseal

    frame $w.button
    button $w.button.connect -textvar tr(FICSLogin) -command {
      set ::fics::login     [.ficsConfig.login get]
      set ::fics::reallogin $::fics::login
      set ::fics::password  [.ficsConfig.passwd get]
      ::fics::connect
    }

    button $w.button.connectguest -textvar tr(FICSGuest) -command {
      set ::fics::reallogin guest
      ::fics::connect guest
    }

    button $w.button.help -text $tr(Help) -command {helpWindow FICS}

    button $w.button.defaults -textvar tr(Defaults) -command {
      if {[tk_dialog .fics_dialog Abort "This will reset all FICS options. Do you wish to continue ?" question {} [tr Yes] [tr No]] == 0} {
	initFICSDefaults
	raiseWin .ficsConfig
      }
    }

    button $w.button.cancel -textvar tr(Cancel) -command {
      destroy .ficsConfig
    }

    ### Pack .ficsConfig widget in grid

    set row 0
    # grid $w.guest  -column 1 -row $row -sticky w
    # incr row
    grid columnconfigure $w 1 -weight 1
    grid $w.lLogin -column 0 -row $row
    grid $w.login  -column 1 -row $row -sticky ew

    incr row
    grid $w.lPwd   -column 0 -row $row
    grid $w.passwd -column 1 -row $row -sticky ew

    incr row
    # horizontal line
    frame $w.line$row -height 2 -borderwidth 2 -relief sunken 
    grid $w.line$row -pady 5 -column 0 -row $row -columnspan 3 -sticky ew

    incr row
    grid $w.timeseal -column 0 -row $row -sticky w

    grid $w.timeseal_entry -column 1 -row $row -sticky ew -padx 2
    grid $w.timeseal_browse -column 2 -row $row -sticky ew -padx 2

    incr row
    grid $w.lServer -column 0 -row $row 
    grid $w.eServer -column 1 -row $row -sticky ew -padx 2

    incr row
    grid $w.lFICS_ip -column 0 -row $row
    grid $w.ipserver -column 1 -row $row -sticky ew -padx 2
    grid $w.bRefresh -column 2 -row $row

    incr row
    grid $w.lFICS_port -column 0 -row $row
    grid $w.portserver -column 1 -row $row -sticky w -padx 2

    incr row
    grid $w.ltsport -column 0 -row $row
    grid $w.portts -column 1 -row $row -sticky w -padx 2

    incr row
    # horizontal line
    frame $w.line$row -height 2 -borderwidth 2 -relief sunken 
    grid $w.line$row -pady 5 -column 0 -row $row -columnspan 3 -sticky ew

    incr row
    grid $w.button -column 0 -row $row -columnspan 4 -sticky ew -pady 3 -padx 5
    foreach i {connect connectguest help defaults cancel} {
      pack $w.button.$i -side left -padx 3 -pady 3 -expand 1 -fill x
    }

    bind $w <Escape> "$w.button.cancel invoke"
    bind $w <F1> {helpWindow FICS}

    # Get IP adress of server (as Timeseal needs IP adress)
    if { $::fics::server_ip == "0.0.0.0" } {
      getIP
    }

    update
    placeWinOverParent $w .
    wm state $w normal
    focus $w.button.connect
    update
  }

  proc getIP {} {
    set b .ficsConfig.bRefresh
    $b configure -state disabled
    busyCursor .
    update

    # First handle the case of a network down
    if {[catch {
          set sockChan [socket -async $::fics::server $::fics::port_fics]
       } err ]} {
	  ::fics::unbusy_config
	  $b configure -state normal
          tk_messageBox -icon error -type ok -title "Unable to contact $::fics::server" -message $err -parent .ficsConfig
          return
    }

    # Give it 5 tries before giving up
    # Then the case of a proxy
    set timeOut 5
    set i 0

    while { $i <= $timeOut } {
      after 1000

      if { [catch {set peer [ fconfigure $sockChan -peername ]} err]} {
        if {$i == $timeOut} {
          tk_messageBox -icon error -type ok -title "Unable to contact $::fics::server" -message $err -parent .ficsConfig
	  $b configure -state normal
	  unbusyCursor .
          return
        }
      } else  {
        break
      }
      incr i
    }

    set ::fics::server_ip [lindex $peer 0]
    ::close $sockChan
    $b configure -state normal
    unbusyCursor .
  }
    
  proc unbusy_config {} {
    set w .ficsConfig
    # $w.button.connect configure -state normal
    # $w.button.connectguest configure -state normal
    focus $w.button.connect
    unbusyCursor .
  }

  proc connect {{guest no}} {
    global ::fics::sockchan ::fics::seeklist ::fics::graph fontOptions tr

    if { $guest=="no" && $::fics::reallogin == ""} {
      tk_messageBox -title "Error" -icon error -type ok -parent .ficsConfig \
        -message "No login name specified" -parent .ficsConfig
      return
    }

    # check timeseal configuration
    if {$::fics::use_timeseal} {
      if {![ file executable $::fics::timeseal_exec ]} {
        tk_messageBox -title "Error" -icon error -type ok -message "Timeseal error : \"$::fics::timeseal_exec\" not executable" -parent .ficsConfig
        return
      }
    }
    destroy .ficsConfig

    set w .fics
    ::createToplevel $w
    ::setTitle $w "FICS ($::fics::reallogin)"
    catch {wm state $w withdrawn}

    busyCursor .

    frame $w.console
    frame $w.command
    frame $w.bottom 
    if {$::fics::show_buttons} {
      pack $w.bottom  -side bottom
    }
    pack $w.command -fill x -side bottom
    # pack console last to allow compressing
    pack $w.console  -fill both -expand 1 -side top

    frame $w.bottom.buttons
    frame $w.bottom.clocks
    frame $w.bottom.graph 

    pack $w.bottom.buttons -side right -padx 2 -pady 5 -anchor center
    # Pack graph when "Offers graph" clicked

    # graph widget initialised
    set ::fics::graph(init) 0
    canvas $w.bottom.graph.c -background grey90 -width $::fics::graph(width)
    button $w.bottom.graph.close -image arrow_close -relief flat -command {
      set ::fics::graph(on) 0
      ::fics::showGraph
    }
    pack $w.bottom.graph.c
    place $w.bottom.graph.close -in $w.bottom.graph.c -relx 1 -rely 0 -anchor ne

    scrollbar $w.console.scroll -command "$w.console.text yview"

    ### Ok, this seems to be keeping it's shape now 
    # Use of "-height $::fics::consoleheight -width $::fics::consolewidth"
    # just didn't work, and also conflicted with the universal setWinSize procedure

    ### need a config option here... Somewhere! &&&
    text $w.console.text -bg $::fics::consolebg -fg $::fics::consolefg -wrap word -yscrollcommand "$w.console.scroll set" -width 40 -height 10 -font font_Fixed
    ### is font_Regular working here ? &&&
    bindMouseWheel $w $w.console.text 
    bindWheeltoFixed $w

    pack $w.console.scroll -side right -fill y 
    pack $w.console.text -side left -fill both -expand 1

    ### Console colours
    $w.console.text tag configure seeking -foreground grey
    $w.console.text tag configure tells -foreground coral
    $w.console.text tag configure command -foreground skyblue
    $w.console.text tag configure game -foreground grey70
    $w.console.text tag configure gameresult -foreground SlateBlue1
    $w.console.text tag configure channel -foreground rosybrown

    entry $w.command.entry -insertofftime 0 -bg grey75 -font font_Large -validate key -vcmd {
      set ::fics::entrytime [clock milli]
      return 1
    }

    configHistory fics $w.command.entry

    entry $w.command.find -width 10 -textvariable ::fics::helpWin(find)
    configFindEntryBox $w.command.find ::fics::helpWin $w.console.text

    button $w.command.send -textvar tr(FICSSend) -state disabled

    button $w.command.clear -textvar tr(Clear) -state disabled -command "
      $w.command.entry delete 0 end
      $w.command.find  delete 0 end
    "
    bind $w.command.clear <Control-Button-1> "
      $w.console.text delete 0.0 end
      $w.console.text insert 0.0 \"FICS ($::scidName $::scidVersion)\n\"
      break
    "
    button $w.command.next -textvar tr(Next) -state disabled -command {::fics::writechan next echo}
    button $w.command.hide -image bookmark_down -command ::fics::togglebuttons

    bind $w <Control-p> ::pgn::Open
    bind $w <Prior> "$w.console.text yview scroll -1 page"
    bind $w <Next>  "$w.console.text yview scroll +1 page"
    # i cant think how to separate the entry and console bind for 'Home' and 'End'
    # bind $w <Home>  "$w.console.text yview moveto 0"
    bind $w <End>   "$w.console.text yview moveto 1"
    bind $w <F9> {
      ### F9 recalls a "tell" history 
      .fics.command.entry delete 0 end
      if {$::fics::tellindex >= [llength $::fics::tells]} {
	# .fics.command.entry insert 0 "tell "
        set ::fics::tellindex 0
      } else {
	.fics.command.entry insert 0 "tell [lindex $::fics::tells $::fics::tellindex] "
	incr ::fics::tellindex
      }
    }


    # steer focus into the command entry, as typing into the text widget is pointless
    if {!$::macOS && !$::windowsOS} {
           bind $w.console.text <FocusIn> "focus $w.command.entry"
    }

    pack $w.command.entry -side left -fill x -expand 1 -padx 3 -pady 2
    pack $w.command.find  -side left                   -padx 3 -pady 2
    pack $w.command.hide $w.command.next $w.command.clear $w.command.send -side right -padx 3 -pady 2
    focus $w.command.entry

    # Gameclocks are used, but never packed in fics now
    # black
    ::gameclock::new $w.bottom.clocks 2 120 0 digital
    # white
    ::gameclock::new $w.bottom.clocks 1 120 0 digital

    # can happen that fics is dead, but clocks still exist
    catch {
    label .main.board.clock2 -textvar ::gameclock::data(time2)
    label .main.board.clock1 -textvar ::gameclock::data(time1)
    }
    ::board::ficslabels

    set ::fics::playing 0

    set row 0
    # chanoff var is back to front with fics
    checkbutton $w.bottom.buttons.tells -textvar tr(FICSTells) -state disabled \
    -variable ::fics::chanoff -command {
      ::fics::writechan "set chanoff [expr !$::fics::chanoff]" noecho
      if {$::fics::chanoff} {
	::fics::writechan "set silence 0"
      }
    }
    checkbutton $w.bottom.buttons.shouts -textvar tr(FICSShouts) -state disabled -variable ::fics::shouts -command {
      ::fics::writechan "set shout $::fics::shouts" echo
      # ::fics::writechan "set cshout $::fics::shouts" noecho
      # ::fics::writechan "set gin $::fics::gamerequests" echo
    }

    label $w.bottom.buttons.ping -textvar ::fics::ping -font font_Small

    grid $w.bottom.buttons.tells  -column 0 -row $row
    grid $w.bottom.buttons.shouts -column 1 -row $row
    grid $w.bottom.buttons.ping   -column 2 -row $row

    incr row

    button $w.bottom.buttons.user0
    button $w.bottom.buttons.user1 
    button $w.bottom.buttons.user2

    foreach i {0 1 2} {
      set j [lindex $::fics::user_buttons $i]
      if {[lsearch -exact {FICSInfo FICSOpponent Abort} $j] > -1} {
        set j [tr $j]
      }
      $w.bottom.buttons.user$i configure -text $j -command [lindex $::fics::user_commands $i]
    }

    set ::fics::graph(on) 0

    grid $w.bottom.buttons.user0 -column 0 -row $row -sticky ew -padx 3 -pady 2
    grid $w.bottom.buttons.user1 -column 1 -row $row -sticky ew -padx 3 -pady 2
    grid $w.bottom.buttons.user2 -column 2 -row $row -sticky ew -padx 3 -pady 2

    incr row
    button $w.bottom.buttons.draw    -textvar tr(FICSDraw) -command {::fics::writechan draw}
    button $w.bottom.buttons.resign  -text [tr CCResign] -command {::fics::writechan resign}
    button $w.bottom.buttons.rematch -textvar tr(FICSRematch)  -command {::fics::writechan rematch}
    grid $w.bottom.buttons.draw     -column 0 -row $row -sticky ew -padx 3 -pady 2
    grid $w.bottom.buttons.resign   -column 1 -row $row -sticky ew -padx 3 -pady 2
    grid $w.bottom.buttons.rematch  -column 2 -row $row -sticky ew -padx 3 -pady 2

    incr row
    button $w.bottom.buttons.takeback  -textvar tr(FICSTakeback) -command {
      ::fics::writechan takeback
      set ::fics::takebackMoves 1
      # these two comments gets zero-ed. See "Game out of sync"
      catch { ::commenteditor::appendComment "$::fics::reallogin requests takeback $::fics::playerslastmove" }
    }
    button $w.bottom.buttons.takeback2 -textvar tr(FICSTakeback2) -command {
      ::fics::writechan {takeback 2}
      set ::fics::takebackMoves 2
      catch { ::commenteditor::appendComment "$::fics::reallogin requests takeback $::fics::playerslastmove" }
    }
    button $w.bottom.buttons.censor -textvar tr(FICSCensor) -command {
      if {$::fics::opponent != {}} {
        if {$::fics::playing == 1 || $::fics::playing == -1} {
	  ::fics::writechan "+censor $::fics::opponent" echo
        } else  {
	  .fics.command.entry delete 0 end
	  .fics.command.entry insert 0 "+censor $::fics::opponent"
        }
      } else {
        .fics.command.entry delete 0 end
        .fics.command.entry insert 0 "+censor "
      }
    }
   bind $w.bottom.buttons.censor <Control-Button-1> {
        .fics.command.entry delete 0 end
        .fics.command.entry insert 0 "+censor "
   }
    grid $w.bottom.buttons.takeback  -column 0 -row $row -sticky ew -padx 3 -pady 2
    grid $w.bottom.buttons.takeback2 -column 1 -row $row -sticky ew -padx 3 -pady 2
    grid $w.bottom.buttons.censor    -column 2 -row $row -sticky ew -padx 3 -pady 2

    incr row
    frame $w.bottom.buttons.space -height 2 -borderwidth 0
    grid  $w.bottom.buttons.space -column 0 -row $row -columnspan 3 -sticky ew -pady 3

    incr row
    button $w.bottom.buttons.offers  -text "$tr(FICSOffers) $tr(Graph)" -command {
      set ::fics::graph(on) [expr {! $::fics::graph(on)}]
      ::fics::showGraph
    } -state disabled
    bind $w <Button-2> {if {[string match .fics.bottom* %W]} {.fics.bottom.buttons.offers invoke}}
    button $w.bottom.buttons.findopp -textvar tr(FICSFindOpponent) -command {::fics::findOpponent} -state disabled
    button $w.bottom.buttons.quit    -textvar tr(FICSQuit) -command {::fics::close}
    grid $w.bottom.buttons.offers  -column 0 -row $row -sticky ew -padx 3 -pady 2
    grid $w.bottom.buttons.findopp -column 1 -row $row -sticky ew -padx 3 -pady 2
    grid $w.bottom.buttons.quit    -column 2 -row $row -sticky ew -padx 3 -pady 2

    bind $w <Control-q> ::fics::close
    bind $w <Destroy>   ::fics::close
    bind $w <Configure> "::fics::recordFicsSize $w"
    bind $w <F1> {helpWindow FICS}
    bind $w <Button-3> {
      tk_popup .menu.options.fics %X %Y
    }

    # needs a little voodoo to get minsize working properly with setWinSize

    update
    set x [winfo reqwidth $w]
    set y [winfo reqheight $w]

    setWinLocation $w
    setWinSize $w
    update
    catch {wm state $w normal}
    ::createToplevelFinalize $w

    # all widgets must be visible
    wm minsize $w $x $y

    # set graph height now buttons height is known
    set ::fics::graph(height) [expr [winfo reqheight $w.bottom.buttons] - 2]
    $w.bottom.graph.c configure -height $::fics::graph(height)

    updateConsole "Connecting $::fics::reallogin"

    # start timeseal proxy
    if {$::fics::use_timeseal} {
      updateConsole "Starting TimeSeal"
      if { [catch { set timeseal_pid [exec $::fics::timeseal_exec $::fics::server_ip $::fics::port_fics -p $::fics::port_timeseal &]} ] } {
        set ::fics::use_timeseal 0
        set port $::fics::port_fics
      } else {
        #wait for proxy to be ready !?
        after 500
        set server "localhost"
        set port $::fics::port_timeseal
      }
    } else {
      set server $::fics::server
      set port $::fics::port_fics
    }

    updateConsole "Socket opening"

    if { [catch { set sockchan [socket $server $port] } ] } {
      unbusyCursor .
      tk_messageBox -title "Error" -icon error -type ok -message "Network error\nCan't connect to $::fics::server $port" -parent .fics
      return
    }

    updateConsole "Channel configuration"

    fconfigure $sockchan -blocking 0 -buffering line -translation auto ;#-encoding iso8859-1 -translation crlf
    fileevent $sockchan readable ::fics::readchan

    unbusyCursor .

    # todo: fix this for windows &&&
    if { ! $::windowsOS } {
      initPing
    }
  }

  proc changeScaleSize {} {
      set size [expr {$::fics::size * 5 + 20}]
      foreach w [winfo children .fics.bottom] {
        if {[string match .fics.bottom.game* $w]} {
	  ::board::resize $w.bd $size
        }
      }
  }

  proc recordFicsSize {w} {
    variable logged
    global ::fics::consoleheight ::fics::consolewidth
    recordWinSize $w
    set  t .fics.console.text
    set width  [expr ([winfo width  $t] - 2 * [$t cget -borderwidth] - 4)/[font measure \
      [$t cget -font] 0]]
    set height [expr ([winfo height $t] - 2 * [$t cget -borderwidth] - 4)/[font metrics \
      [$t cget -font] -linespace]]
    incr height 2 ; # for some reason, two bigger is best for fics output

    if {$width != $::fics::consolewidth || $height != $::fics::consoleheight } {
      set ::fics::consolewidth $width
      set ::fics::consoleheight $height
      if {$logged} {
	writechan "set width  $width"  noecho
	if {$height > 4} {
          # fics wants at least height of 5 for some reason ?
	  writechan "set height $height" noecho
        }
        $w.console.text yview moveto 1
      }
    }
  }


  proc cmd {} {
    set w .fics

    set l [string trim [$w.command.entry get]]
    $w.command.entry delete 0 end
    if {$l == "quit" || $l == "exit"} {
      ::fics::close
      return
    }

    set c [lindex [split $l] 0]
    ::fics::addHistory $l
    set c [string trim $c]
    switch -glob $c {
      {}  {
	  updateConsole {}
	  return
	  }

      smove* {
	  # smoves recreates a game without any further announcment
	  if {$::fics::playing == 1 || $::fics::playing == -1} {
	    updateConsole "Scid: smoves disabled while playing a game"
	    return
	  }

	  ::fics::demote_mainGame 
          if {$::fics::playing != 2} {
	    set confirm [::game::ConfirmDiscard]
	    if {$confirm == 2} {return}
	    if {$confirm == 0} {::game::Save}
          }

	  set ::fics::waitForMoves no_meaning
	  if {$c == "smoves+"} {
	    set ::fics::waitForMoves emt
	    set l [string map {smoves+ smoves} $l]
          }

	  sc_game new
	  set ::fics::mainGame -1
	  set ::fics::playing 0
	  updateBoard -pgn
	  updateTitle

	  writechan $l echo

	  vwaitTimed ::fics::waitForMoves 5000 nowarn
	  updateBoard -pgn
	  updateTitle
	  return
      }

      fol* {
          set plus [expr {[string index [lindex $c 0] end] == "+"}]

	  if {$plus && $::fics::playing == 1 || $::fics::playing == -1} {
	    updateConsole "Scid: follow+ disabled while playing a game"
	    return
	  }

          set l2 [lindex $l 1]
          if {$plus && ($l2 == {} || [string index $l2 0] == {/})} {
	    updateConsole "Scid: follow+ needs a player name"
	    return
          }


          if {$plus} {
	    set ::fics::autoload $l2
	    set l [string map {+ {}} $l]
          }

	  writechan $l echo
	  return
      }

      upload {
          # upload current game to examine mode
          if {$::fics::playing == 2} {
	    tk_messageBox -title "Oops" -icon info -type ok -message "You are already examining a game" -parent .fics
            return
          } 
          if {[string first "\n1." [sc_game pgn]] == -1} {
	    tk_messageBox -title "Oops" -icon info -type ok -message "This game has no moves" -parent .fics
            return
          } 
	  set white [string trim [lindex [sc_game tags get White] 0] {,}]
	  set black [string trim [lindex [sc_game tags get Black] 0] {,}]
	  set ::fics::examresult [sc_game tags get Result]

	  set confirm [::game::ConfirmDiscard]
	  if {$confirm == 2} {return}
	  if {$confirm == 0} {::game::Save}

          sc_move end
          set moves [sc_game moves coord]
          sc_game new

	  ::fics::writechan examine
          ::fics::writechan "wname $white"
          ::fics::writechan "bname $black"

          foreach moveUCI $moves {
	    if { [ string length $moveUCI ] == 5 } {
	      set promoLetter [string index $moveUCI end]
	      ::fics::writechan "promote $promoLetter"
	    }
	    ::fics::writechan [ string range $moveUCI 0 3 ]
          }
	  ::fics::writechan commit
	  updateBoard -pgn
          return
      } 
      ex* {
	  set confirm [::game::ConfirmDiscard]
	  if {$confirm == 2} {return}
	  if {$confirm == 0} {::game::Save}
          sc_game new
      }
      moretime {
	  ::commenteditor::appendComment "$::fics::reallogin gives $l"
      }
      default {
	  if {[string match uno* $c]} {
	      set ::fics::catchRemoving 1
          }
	  if {([string match uno* $c]||[string match unex* $c])  && \
	       $::fics::playing != 1 && $::fics::playing != -1 && \
	       ($l == $c || [lindex $l 1] == $::fics::mainGame)} {
	    # unobserve/unexamine main game
	    set ::fics::mainGame -1
	    if {[string match unex* $c]} {
	      set ::fics::playing 0
	      updateBoard -pgn
	      updateTitle
	    }
	  }
          # Problems with doing this 
          # if exam game, ob (load) another game, exam newgame - gets confused :(
          # if {[string match {tell gamebot exam*} $l] ||
          #    [string match {exam*} $c]} {
	  #  ::fics::demote_mainGame 
          #}
      }
    } ; # switch

    writechan $l echo
    $w.console.text yview moveto 1
  }

  proc findOpponent {} {
    global tr

    set w .ficsfindopp
    if {[winfo exists $w]} {
      raiseWin $w
      return
    }
    toplevel $w
    wm state $w withdrawn
    wm title $w "Find Opponent"

    set row 0

    checkbutton $w.cbrated -text $tr(FICSRatedGame) -onvalue rated -offvalue unrated -variable ::fics::findopponent(rated)
    grid $w.cbrated -column 1 -row $row -sticky w

    incr row
    checkbutton $w.cbmanual -text $tr(FICSManualConfirm) -onvalue manual -offvalue auto -variable ::fics::findopponent(manual)
    grid $w.cbmanual -column 1 -row $row -sticky w

    incr row
    frame $w.space$row -height 2 -borderwidth 0
    grid  $w.space$row -column 0 -row $row -columnspan 3 -sticky ew -pady 3

    incr row
    label $w.linit -text $tr(FICSInitTime)
    spinbox $w.sbTime1 -width 7 -textvariable ::fics::findopponent(initTime) -from 0 -to 120 -increment 1
    label $w.linc -text $tr(FICSIncrement)
    spinbox $w.sbTime2 -width 7 -textvariable ::fics::findopponent(incTime) -from 0 -to 120 -increment 1
    grid $w.linit   -column 0 -row $row -sticky ew -padx 5
    grid $w.sbTime1 -column 1 -row $row -padx 5
    incr row
    grid $w.linc    -column 0 -row $row -sticky ew -padx 5
    grid $w.sbTime2 -column 1 -row $row -padx 5

    incr row
    frame $w.space$row -height 2 -borderwidth 0
    grid  $w.space$row -column 0 -row $row -columnspan 3 -sticky ew -pady 3

    incr row
    label $w.color -text $tr(FICSColour)
    grid $w.color -column 1 -row $row

    incr row
    radiobutton $w.rb2 -text $tr(White) -value white -variable ::fics::findopponent(color)
    radiobutton $w.rb3 -text $tr(Black) -value black -variable ::fics::findopponent(color)
    radiobutton $w.rb1 -text $tr(FICSAutoColour)  -value auto  -variable ::fics::findopponent(color)
    grid $w.rb1 -column 0 -row $row -ipadx 5
    grid $w.rb2 -column 1 -row $row -ipadx 5
    grid $w.rb3 -column 2 -row $row -ipadx 5

    incr row
    frame $w.space$row -height 2 -borderwidth 0
    grid  $w.space$row -column 0 -row $row -columnspan 3 -sticky ew -pady 3

    incr row
    checkbutton $w.cblimitrating -text $tr(RatingRange) -variable ::fics::findopponent(limitrating)
    spinbox $w.sbrating1 -width 7 -textvariable ::fics::findopponent(rating1) \
	-from 800 -to 2800 -increment 50
    spinbox $w.sbrating2 -width 7 -textvariable ::fics::findopponent(rating2) \
	-from 800 -to 2800 -increment 50 

    grid $w.cblimitrating -column 0 -row $row -sticky w
    grid $w.sbrating1     -column 1 -row $row
    grid $w.sbrating2     -column 2 -row $row

    incr row
    checkbutton $w.cbformula -text $tr(FICSFilterFormula) -onvalue formula \
      -offvalue none -variable ::fics::findopponent(formula)
    grid $w.cbformula -column 0 -row $row -sticky w

    incr row
    frame $w.space$row -height 2 -borderwidth 2 -relief sunken
    grid  $w.space$row -column 0 -row $row -columnspan 3 -sticky ew -pady 3

    button $w.seek -text {Make Offer} -command {
      set range ""
      if {$::fics::findopponent(limitrating) } {
        set range "$::fics::findopponent(rating1)-$::fics::findopponent(rating2)"
      }

      # can't use a blank value in radiobuttons/checkbuttons... they look stupid
      set color $::fics::findopponent(color)
      if {$::fics::findopponent(color) == "auto"} { set color {} }
      set formula $::fics::findopponent(formula)
      if {$::fics::findopponent(formula) == "none"} { set formula {} }

      set cmd "seek $::fics::findopponent(initTime) $::fics::findopponent(incTime) \
               $::fics::findopponent(rated) $color \
               $::fics::findopponent(manual) $formula $range"
      ::fics::writechan $cmd
      destroy .ficsfindopp
      ::fics::initOffers
    } -width 10
    button $w.help   -text $tr(Help) -command "helpWindow FICSfindopp" -width 10
    button $w.cancel -text $tr(Cancel) -command "destroy $w" -width 10

    bind $w <F1> {helpWindow FICSfindopp}

    incr row
    grid $w.seek   -column 0 -row $row -padx 3 -pady 8
    grid $w.help   -column 1 -row $row -padx 3 -pady 8 -sticky e
    grid $w.cancel -column 3 -row $row -padx 3 -pady 8 -sticky e

    update
    placeWinOverParent $w .fics
    wm state $w normal
  }

  proc readchan {} {
    variable logged
    if {[eof $::fics::sockchan]} {
      fileevent $::fics::sockchan readable {}
      tk_messageBox -title "Read error" -icon error -type ok -message "Network error\nFics will exit." -parent .fics
      ::fics::close error
      return
    }
    # switch from read to gets in case a read is done at the middle of a line
    if {! $logged} {
      set line [read $::fics::sockchan]
      foreach l [split $line "\n"] {
        readparse $l
      }
    } else  {
        set line [gets $::fics::sockchan]
        set line [string map {"\a" ""} $line]
        readparse $line   
    }

  }

  # Appends an array to newsoughtlist if the parameter is correct
  # returns 0 if the line is not parsed and so it is still pending for use

  proc parseSoughtLine { l } {
    global ::fics::offers_minelo ::fics::offers_maxelo ::fics::offers_mintime ::fics::offers_maxtime

    if { [ catch { if {[llength $l] < 8} { return 0} } ] } { return 0}

    # 72 ++++ GuestIEEE           1  10 unrated blitz      [white]     0-9999 m
    # auto/manual     indicates whether a game will start automatically when 
    #                 abbreviated by "a" and "m" [default: auto start]
    # formula         indicates whether your formula will used to screen , abbreviated by "f"

    array set ga {}

    set offset 0
    set ga(game) [lindex $l 0]
    if { ! [string is integer $ga(game)] } { return 0}
    set tmp [lindex $l 1]
    if { [scan $tmp "%d" ga(elo)] != 1} { set ga(elo) $offers_minelo }
    if { $ga(elo) < $offers_minelo } { set ga(elo) $offers_minelo }
    set ga(name) [lindex $l 2]

    set tmp [lindex $l 3]
    if { [scan $tmp "%d" ga(time_init)] != 1} { set ga(time_init) $offers_maxtime}
    set tmp [lindex $l 4]
    if { [scan $tmp "%d" ga(time_inc)] != 1} { set ga(time_inc) 0 }

    set ga(rated) [lindex $l 5]
    if {$ga(rated) != "rated" && $ga(rated) != "unrated"} { return 0 }
        
    set ga(type) [lindex $l 6]
    if { $ga(type) != "untimed" && $ga(type) != "blitz" && $ga(type) != "standard" && $ga(type) != "lightning" } {
      # this line can now be ignored
      return 2
    }
    set ga(color) ""
    if { [lindex $l 7] == "\[white\]" || [lindex $l 7] == "\[black\]" } {
      set ga(color) [lindex $l 7]
      set offset 1
    }
    set ga(rating_range) [lindex $l [expr 7 + $offset]]
    if { [ catch { set ga(start) [lindex $l [expr 8 + $offset]] } ] } {
      set ga(start) ""
    }

    lappend ::fics::newsoughtlist [array get ga]
    return 1
  }

  proc readparse {line} {
    variable logged
    ### what is the significance of the fics prompt "fics%" &&&

    # Many lines have trailing spaces, so best not to do this
    # if {$logged} {set line [string trim $line]}

    if {[string match {fics%*} $line]} {
	set line [string trim [string range $line 5 end]]
    }

    if { $::fics::sought } {
      if {[string match "* ad* displayed." $line]} {
        # end of offers
	set ::fics::sought 0
	set ::fics::soughtlist $::fics::newsoughtlist
        set ::fics::newsoughtlist {}
	displayGraph
	return
      }
      if { [ parseSoughtLine $line ] } {
	return
      }
    }

    switch -glob $line {
      {} {return}

      {login: } {
	writechan $::fics::reallogin
	if { [string match -nocase guest $::fics::reallogin ] } {
	  set logged 1
	}
	return
      }

      {password: } {
	writechan $::fics::password
	set logged 1
	return
      }

      {<sc>*} {
	set ::fics::seeklist {}
	return
      }

      {<s>*} {
	parseSeek $line
	return
      }

      {<sr>*} {
	removeSeek $line
	return
      }

      {<12>*} {
	parseStyle12 $line
	return
      }

      {<b1>*} {
        ### variants info lines
        # When showing positions from bughouse games, a second line showing piece
        # holding is given, with "<b1>" at the beginning, for example:
        # <b1> game 6 white [PNBBB] black [PNB]
        # .fics.bottom.game$game.w.white configure -text "[lindex $line 17] ([lindex $line 24] secs) X"
	if { [scan $line "<b1> game %d white %s black %s" game piecesw piecesb] == 3} {
          catch {
            if {$piecesw == {[]}} {set piecesw {}}
            if {$piecesb == {[]}} {set piecesb {}}
	    set tempw [.fics.bottom.game$game.w.white cget -text]
	    set tempb [.fics.bottom.game$game.b.black cget -text]
	    if {[string index $tempw end] == "X"} {
              .fics.bottom.game$game.w.white configure -text "[string range $tempw 0 end-2] $piecesw X"
              .fics.bottom.game$game.b.black configure -text "$tempb $piecesb"
            } else {
              .fics.bottom.game$game.w.white configure -text "$tempw $piecesw"
              .fics.bottom.game$game.b.black configure -text "[string range $tempb 0 end-2] $piecesb X"
            }
          }
        }
        return
      }
    }

    updateConsole $line

    if { [string match "You are now observing game*" $line] } {
      # You are now observing game 193.
      # Game 193: franky (1758) homeomorphism (1722) rated lightning 1 0

      scan $line "You are now observing game %d." game

      # Only setup a new little board if its not the mainGame
      # mainGame gets loaded later (in parseStyle12)
      if {$game != $::fics::mainGame} {
	addObservedGame $game
      }
      return
    }

    if { [string match "Removing game *" $line] && $::fics::catchRemoving } {
      ### Only rely on this if catchRemoving set via 'cmd'
      scan $line "Removing game %d from observation list." game
      if {$game == $::fics::mainGame} {
        set ::fics::mainGame -1
      }
      remove_observedGame $game
      set ::fics::catchRemoving 0
      return
    }

    if {[string match "Creating: *" $line]} {
      catch {destroy .ficsOffers}
      ::fics::checkRaise

      # Setting this, stops automatically accepting rematches. (But algorythm needs fixing a little)
      set ::fics::findopponent(manual) manual
      after cancel ::fics::updateAds

      # Move a previously observed game back to the fics widget
      ::fics::demote_mainGame 
      set ::fics::mainGame -1 ; # reset to this new game with first style12 
      set ::fics::autoload {}

      ::fics::disableEngines

      sc_game new

      set idx1 [string first "(" $line]
      set white [string trim [string range $line 10 [expr $idx1 -1]] ]
      set idx2 [string first ")" $line]
      set whiteElo [string trim [string range $line [expr $idx1 +1] [expr $idx2 -1]] ]

      set idx1 [expr $idx2 +1]
      set idx2 [string first "(" $line $idx1]
      set black [string trim [string range $line $idx1 [expr $idx2 -1]] ]

      set idx1 [expr $idx2 +1]
      set idx2 [string first ")" $line $idx1]
      set blackElo [string trim [string range $line $idx1 [expr $idx2 -1]] ]

      if { $whiteElo == "++++"} { set whiteElo 0 }
      if { $blackElo == "++++"} { set blackElo 0 }

      if { [ string match -nocase $white $::fics::reallogin ] } {
	### 1 = game_start/my move, 0 = not playing, -1 = opponents move
	set ::fics::playing 1
      } else {
	set ::fics::playing -1
      }

      sc_game tags set -white $white
      sc_game tags set -whiteElo $whiteElo
      sc_game tags set -black $black
      sc_game tags set -blackElo $blackElo
      sc_game tags set -date [::utils::date::today]

      if {[string match -nocase $::fics::reallogin $white]} {
        set ::fics::opponent $black 
      } elseif {[string match -nocase $::fics::reallogin $black]} {
        set ::fics::opponent $white
      } else {
        set ::fics::opponent {}
      }
        
      
      # line: "Creating: hruvulum (1079) stevenaaus (1148) rated blitz 2 18"
      # resumed game line is different though
      if {[regexp {.*\) ([^\)]*$)} $line t1 t2]} {
        sc_game tags set -event "FICS [lrange $line end-3 end-2]"
        set ::fics::timecontrol [lindex $line end-1]/[lindex $line end]
        sc_game tags set -extra [list "Time \"[::utils::date::time]\"" "TimeControl  \"$::fics::timecontrol\""]
      } else {
        set ::fics::timecontrol {}
      }
      if { [::board::isFlipped .main.board] } {
        if { [ string match -nocase $white $::fics::reallogin ] } { ::board::flip .main.board }
      } else {
        if { [ string match -nocase $black $::fics::reallogin ] } { ::board::flip .main.board }
      }
      updateBoard -pgn -animate
      wm title $::dot_w "$::scidName: $white - $black ($::fics::timecontrol)"

      if {$::fics::sound} {
	::utils::sound::PlayMove sound_start
      }

      ### hide offers graph ; sometime ::fics::updateAds doesn't get cancelled though !?^&$%!
      set ::fics::graph(on) 0
      showGraph

      # display the win / draw / loss score
      ::fics::writechan assess noecho
      set ::fics::ignore_abort 0
      set ::fics::ignore_takeback 0
      set ::fics::ignore_draw 0
      set ::fics::ignore_adjourn 0
      set ::fics::lastmove {no move}
      set ::fics::playerslastmove {no move}
      return
    }

    # {Game 331 (AmorVerus vs. killerbie) killerbie checkmated} 1-0

    # Creating: Libertie (1263) stevenaaus (1092) rated blitz 6 12
    # {Game 112 (Libertie vs. stevenaaus) Creating rated blitz match.}

    if {[string match "\{Game *" $line]} {
      if {[string match {* Creating *} $line]} {
	scan $line "\{Game %d %s" num tmp
        return
      }
      set num [lindex [lindex $line 0] 1]
      set res [lindex $line end]

      if {$num == $::fics::mainGame} {
        # Game is over. Set result and save game
        ::gameclock::stop 1
        ::gameclock::stop 2

	# {Game 331 (AmorVerus vs. killerbie) killerbie ran out of time and Oli has no material to mate} 1/2-1/2
	set resultcomment [lrange [lindex $line 0] 2 end]
	set t1 [string first {)} $resultcomment]
	if {$t1 > -1} {
	  set resultcomment [string range $resultcomment $t1+2 end]
	}

        set t1 [::gameclock::getSec 1]
        set t2 [::gameclock::getSec 2]
	::commenteditor::appendComment "$resultcomment\nWhiteclock [expr $t1 / 60]:[format {%02i} [expr $t1 % 60]] Blackclock [expr $t2 / 60]:[format {%02i} [expr $t2 % 60]]"
        sc_game tags set -result $res
        # if {![string match  {*Game aborted*} $line]} 
        if {[sc_pos moveNumber] > 2} {
	  catch {::game::Save}
	  updateBoard -pgn
	  ::windows::gamelist::Refresh
        }
        # we need a better way to update gamelist when adding a new game
        ::windows::gamelist::Refresh
        set ::fics::playing 0
        set ::fics::mainGame -1
        set ::pause 0
	if {[string match -nocase $::fics::reallogin [sc_game tags get Black]] ||
            [string match -nocase $::fics::reallogin [sc_game tags get White]]} {
	  if {$::fics::sound} {
	    ::utils::sound::PlayMove sound_end
	  }
	  if {! $::fics::no_results && ($res != "*" || [sc_pos moveNumber] > 1)} {
	    if {[string match "1/2*" $res]} {set res Draw}
	    ::fics::killDialogs
	    tk_messageBox -title "Game result" -icon info -type ok -message "$res"
	  }
	}
	# &&& do we need ::fics::remove_observedGame $num (todo check)
	::fics::enableEngines
      } else {
        # Add result to white label
        catch {
	  .fics.bottom.game$num.bd.bd bind current <Double-Button-1> {}
	  .fics.bottom.game$num.w.result configure -font font_Small -text \
	      "[.fics.bottom.game$num.w.result cget -text] ($res)"
          pack forget .fics.bottom.game$num.b.load
        }
        ::fics::remove_observedGame $num
      } 
      return
    }

    if {[string match "Game *rated *" $line]} {

      # Game notification: Kaitlin ( 696) vs. leilatov (1186) rated bughouse 2 0: Game 335
      if {[string match "Game notification*" $line]} {
        return
      }

      ### Get observed game Info
      # Game 237: impeybarbicane (1651) bust (1954) rated crazyhouse 5 0
      # Game 237: impeybarbicane ( 649) bust ( 987) rated crazyhouse 5 0
      # note - the stray '('s in the line below seems to make matching the elo easier

      if {[scan $line {Game %d: %s (%s %s (%s %s %s %d %d} g white whiteElo black blackElo dummy gametype t1 t2] == 9} {
          set ::fics::elo($white) [string range $whiteElo 0 end-1]
          set ::fics::elo($black) [string range $blackElo 0 end-1]
          if {[winfo exists .fics.bottom.game$g]} {
	    # These two lines give info straight away, but erase the ordinary time details when "time" is issued
	    # .fics.bottom.game$g.w.white configure -text $white
	    # .fics.bottom.game$g.b.black configure -text $black
            set type $gametype
            catch {set type $::fics::shorttype($gametype)}
	    .fics.bottom.game$g.w.result configure -text "$g $type"
	    # disable load button if non-standard game
	    if {$gametype != {untimed} && $gametype != {blitz} && $gametype != {lightning} && $gametype != {standard}} {
	      pack forget .fics.bottom.game$g.b.load
	    }
          }
      } else {
        updateConsole "Error parsing Game line \"$line\""
      }
    }

    # "Movelist for game *:" (unhandled)

    if {[string match "*Starting FICS session*" $line]} {
      # mandatory init commands
      writechan "iset seekremove 1"
      writechan "iset seekinfo 1"
      writechan "style 12"
      writechan "iset nowrap 1"
      writechan "iset nohighlight 1"

      writechan "set interface $::scidName $::scidVersion"

      # pychess sets this bloody thing
      writechan "set availinfo off"
      writechan "set chanoff [expr !$::fics::chanoff]"
      # writechan "set cshout $::fics::shouts"
      writechan "set shout $::fics::shouts"
      # What is this ? S.A. writechan "iset nowrap 1"
      writechan "iset nohighlight 1"

      # User init commands
      foreach i $::fics::init_commands {
        writechan $i
      }

      .fics.bottom.buttons.offers  configure -state normal
      .fics.bottom.buttons.tells   configure -state normal
      .fics.bottom.buttons.shouts  configure -state normal
      .fics.bottom.buttons.findopp configure -state normal
      .fics.bottom.buttons.offers  configure -state normal
      .fics.command.send           configure -state normal
      .fics.command.clear          configure -state normal
      .fics.command.next           configure -state normal

      bind .fics.command.entry <Return> ::fics::cmd
      .fics.command.send configure -command ::fics::cmd
      return
    }

    if { $::fics::waitForMoves != "" } {
      set line [string trim $line]

      # Because some free text may be in the form (".)
      if {[catch {set length [llength $line]} err]} {
        puts "Exception $err llength $line"
        return
      }

      # Moves over an hour necessitate reading %d:%d or %d:%d:%d as string (%s
      # 19.  Qe3     (1:02:38)   Be6     (8:06)  

      switch $length {

        3 - 5 {
            # hmmm - we assume any line length 3 or 5 is a game moves line. ???

            # set moves m1, m2 (todo: store times)
            if {$length == "5"} {
              if {[scan $line "%d. %s (%s %s (%s" t1 m1 t2 m2 t3] != 5} {
                ### puts "waitForMoves failed processing: $line"
                return
              }
            } else {
	      # length = 3
	      if {[scan $line "%d. %s (%s" t1 m1 t2] != 3} {
                ### puts "waitForMoves failed processing: $line"
		# waitForMoves failed processing: Move  BetoScaramal       mandre
		# waitForMoves failed processing: ----  ----------------   ----------------
                return
              }
              set m2 {}
	    }

	    # Add this move
	    # 1.  d4      (0:00)     d6      (0:00)
	    # 2.  c4      (0:25)     Bf5     (0:01)

	    catch { sc_move addSan $m1 }
	    if { $::fics::waitForMoves == "emt" } {
              sc_pos setComment "\[%emt [string trim $t2 {)}]\]"
            }
	    if {$m2 != ""} {
	      catch { sc_move addSan $m2 }
	      if { $::fics::waitForMoves == "emt" } {
		sc_pos setComment "\[%emt [string trim $t3 {)}]\]"
	      }
	    }
	    if {[sc_pos fen] == $::fics::waitForMoves } {
              ### Game reconstructed successfully
	      set ::fics::waitForMoves ""
	    }
            return
        }

        12 {
	      if {[scan $line {%s (%s %s %s (%s} t1 t2 t3 t4 t5] == 5} {
		# ImaGumby (1280) vs. Kaitlin (1129) --- Sat Feb  4, 02:12 PST 2012
		# stevenaaus (1157) vs. Abatwa (1103) --- Sun Feb  5, 23:13 PST 2012
		if {$t3 == "vs."} {
		  sc_game tags set -white    $t1
		  sc_game tags set -black    $t4
		  sc_game tags set -whiteElo [string range $t2 0 end-1]
		  sc_game tags set -blackElo [string range $t5 0 end-1]
		}
		return
	      }
           }

      2 {
	  if {[string match {\{*\} *} $line]} {
	    # {White forfeits on time} 1-0
if {[lindex $line 0] != {Still in progress}} {
	    ::commenteditor::appendComment [lindex $line 0]
}
	    sc_game tags set -result [lindex $line 1]
	    set ::fics::waitForMoves ""
	    return
	  }
        }

      default {
	  if {[string match "Rated*" $line] || [string match Unrated* $line]} {
	    # Unrated blitz match, initial time: 3 minutes, increment: 0 seconds.
	    # Rated wild/fr match, initial time: 5 minutes, increment: 0 seconds
	    # Rated lightning match, initial time: 1 minutes, increment: 0 seconds.

	    ### If we try to filter illegal game types, by the time we get here, we have already created a new game :(
	    # foreach i {wild suicide crazy bug losers atomic} {if {[string match ${i}* $type]} {...}}
	    #   updateConsole "Oops - game type $type not supported. Try examining game instead."

	    sc_game tags set -event "FICS [string tolower [lrange $line 0 1]]"
            set ::fics::timecontrol [lindex $line end-4]/[lindex $line end-1]
	    sc_game tags set -extra [list "Time \"[::utils::date::time]\"" "TimeControl  \"$::fics::timecontrol\""]
	    # This is the download date - not the correct played date, which can be assembled from
	    # Kaitlin (1463) vs. PLAYERFOREVER (1808) --- Wed Jun 27, 02:54 PDT 2012
	    sc_game tags set -date [::utils::date::today]
	    return
	  }

          ### should we return ?
	}

      } ;# switch length

    } ;# waitformoves

    if {[string match "Challenge:*" $line]} {
	if {[winfo exists .ficsOffers] && $::fics::findopponent(manual) == {auto}} {
            writechan accept
	} else {
	    ::fics::addOffer $line
	}
    }

    if {[string match "Challenge * removed*" $line]} {
	::fics::delOffer [string tolower [lindex [split $line] 2]]
    }

    if {[string match "* withdraws * offer*" $line]} {
	::fics::delOffer [string tolower [lindex [split $line] 0]]
    }

    # JM: To avoid "denial of play" attack by the opponent constantly issuing request[s]
    # SA: Add ignore_request checks, and use tk_dialog instead of tk_messageBox

    # abort request

    if {[string match "* would like to abort the game;*" $line] && ! $::fics::ignore_abort} {
      if {$::fics::no_requests} {
        writechan decline
      } else {
	::fics::killDialogs
	set ans [tk_dialog .fics_dialog Abort "$line\nDo you accept ?" question {} Yes No Ignore]
	switch -- $ans {
	  0 {writechan accept}
	  1 {writechan decline}
	  2 {set ::fics::ignore_abort 1}
	}
      }
    }

    # takeback
    if {[string match "* would like to take back *" $line] && ! $::fics::no_requests && ! $::fics::ignore_takeback} {
      ::fics::killDialogs
      set ans [tk_dialog .fics_dialog {Take Back} "$line\nDo you accept ?" question {} Yes No Ignore]
      switch -- $ans {
        0 {
            writechan accept
	    if {[regexp {(.*) would like to take back} $line t1 t2]} {
	      ::commenteditor::appendComment "$t2 takes back move $::fics::lastmove"
	    }
	    # goodness knows whose go it is. Often players request takeback instead of takeback2, so just stop clocks now!
	    ::gameclock::stop 1
	    ::gameclock::stop 2
          }
        1 {writechan decline}
        2 {set ::fics::ignore_takeback 1}
      }
    }

    # draw
    if {[string match "*offers you a draw*" $line] && ! $::fics::ignore_draw} {
      if {[regexp {(.*) offers you a draw} $line t1 t2]} {
	::commenteditor::appendComment "$t2 offers draw"
      }
      if {$::fics::no_requests} {
        writechan decline
      } else {
        ::fics::killDialogs
	set ans [tk_dialog .fics_dialog {Draw Offered} "$line\nDo you accept ?" question {} Yes No Ignore]
	switch -- $ans {
	  0 {writechan accept}
	  1 {writechan decline}
	  2 {set ::fics::ignore_draw 1}
	}
      }
    }

    # adjourn
    if {[string match "*would like to adjourn the game*" $line] && ! $::fics::ignore_adjourn} {
      if {$::fics::no_requests} {
        writechan decline
      } else {
        ::fics::killDialogs
	set ans [tk_dialog .fics_dialog {Adjourn Offered} "$line\nDo you accept ?" question {} Yes No Ignore]
	switch -- $ans {
	  0 {writechan accept}
	  1 {writechan decline}
	  2 {set ::fics::ignore_adjourn 1}
	}
      }
    }

    # guest logging
    if {[string match "Logging you in as*" $line]} {
      set line [string map {"\"" "" ";" ""} $line ]
      set ::fics::reallogin [lindex $line 4]
      wm title .fics "FICS ($::fics::reallogin)"
    }
    if {[string match "Press return to enter the server as*" $line]} {
      writechan "\n"
    }

  }

  ### Make a new small board in the fics widget to observe a game

  proc addObservedGame {game} {
      set w .fics
      if {$::fics::observedGames == {}} {
        set ::fics::primary $game
      }
      if {[lsearch -exact $::fics::observedGames $game] == -1} {
	lappend ::fics::observedGames $game
      }
      if {[winfo exists $w.bottom.game$game]} {
        # Check for clash between finished games and new games
	bind .fics <Destroy> {}
        destroy $w.bottom.game$game
        bind .fics <Destroy> ::fics::close
      }
      frame $w.bottom.game$game
      ::board::new $w.bottom.game$game.bd [expr {$::fics::size * 5 + 20}] 1
      # At bottom we have White and game number
      # (note whiteElo, blackElo labels are not packed, only used for data should we load game
      # data for these labels is read next line from fics
      frame $w.bottom.game$game.w
      label $w.bottom.game$game.w.white  -font font_Small
      label $w.bottom.game$game.w.result -font font_Small

      $w.bottom.game$game.bd.bd bind current <Double-Button-1> "
        catch {$w.bottom.game\${::fics::primary}.w.result configure -font font_Small}
        ::fics::writechan \"primary $game\"
        set ::fics::primary $game
        $w.bottom.game$game.w.result configure -font font_SmallBold
      "

      if {$::fics::primary == $game} {
        $w.bottom.game$game.w.result configure -font font_SmallBold
      }
      # At top we have Black and Buttons
      frame $w.bottom.game$game.b 
      label $w.bottom.game$game.b.black -font font_Small

      button $w.bottom.game$game.b.close -image arrow_close -font font_Small -relief flat -command "
        bind .fics <Destroy> {}
        destroy .fics.bottom.game$game
        bind .fics <Destroy> ::fics::close
        ::fics::unobserveGame $game"

      ### Doesnt work as focus in fics goes to the command entry
      # $w.bottom.game$game.bd.bd bind current <Escape> "$w.bottom.game$game.b.close invoke"

      button $w.bottom.game$game.b.flip -image arrow_updown -font font_Small -relief flat -command "
        set temp1 \[.fics.bottom.game$game.b.black cget -text\]
        set temp2 \[.fics.bottom.game$game.w.white cget -text\]
	::board::flip $w.bottom.game$game.bd
        .fics.bottom.game$game.b.black configure -text \$temp2
        .fics.bottom.game$game.w.white configure -text \$temp1
      "

      button $w.bottom.game$game.b.load -image arrow_up -font font_Small -relief flat -command "
	if {\[lsearch -exact \$::fics::observedGames $game\] > -1} {
          if {\$::fics::playing == -1 || \$::fics::playing == 1} {
            return
          }
	  ### If we're already observing a game, move it back to a small board
	  ::fics::demote_mainGame 
          # unflip when loading new game ??
	  if {\[::board::isFlipped .main.board\] ^ \[::board::isFlipped $w.bottom.game$game.bd\]} {::board::flip .main.board}

	  ### Restarting observe ensures we get a parseStyle12 line straight away
	  ::fics::unobserveGame $game
	  set ::fics::mainGame $game
	  ::fics::writechan \"observe $game\"
	  bind .fics <Destroy> {}
	  destroy .fics.bottom.game$game
	  bind .fics <Destroy> ::fics::close
          raiseWin .
	} else {
          ### should never get here
	  # close game if it is finished
	  puts {Bad FICS load}
	  bind .fics <Destroy> {}
	  destroy .fics.bottom.game$game
	  bind .fics <Destroy> ::fics::close
	}
      "

      # button $w.bottom.game$game.w.flip -text flip -font font_Small -relief flat -command ""

      if {[catch {pack $w.bottom.game$game -side left -padx 3 -pady 3 -before $w.bottom.buttons}]} {
                pack $w.bottom.game$game -side left -padx 3 -pady 3 -before $w.bottom.graph
      }

      pack $w.bottom.game$game.b  -side top -anchor w -expand 1 -fill x
      pack $w.bottom.game$game.b.black -side left 
      pack [frame $w.bottom.game$game.b.space -width 24] \
           $w.bottom.game$game.b.close $w.bottom.game$game.b.load $w.bottom.game$game.b.flip -side right
      pack $w.bottom.game$game.bd -side top
      pack $w.bottom.game$game.w -side top -expand 1 -fill x
      pack $w.bottom.game$game.w.white -side left 
      pack [frame $w.bottom.game$game.w.space -width 20] \
           $w.bottom.game$game.w.result -side right
      if {!$::fics::show_buttons} {
	::fics::togglebuttons
      }
  }

  proc unobserveGame {game} {
    if {[::fics::remove_observedGame $game]} {
      ::fics::writechan "unobserve $game"
    }
  }

  proc remove_observedGame {game} {
    if {$game == $::fics::primary} {
      # actually, we may still have a primary game, but scid does not track their order
      set ::fics::primary 0
    }
    set i [lsearch -exact $::fics::observedGames $game]
    if {$i > -1} {
      set ::fics::observedGames [lreplace $::fics::observedGames $i $i]
      return 1
    } else {
      return 0
    }
  }

  proc demote_mainGame {} {
    if {$::fics::mainGame > -1 && $::fics::playing != 2} {
      set tmp $::fics::mainGame
      ::fics::writechan "unobserve $tmp"

      ::gameclock::stop 1
      ::gameclock::stop 2
      set ::gameclock::data(time2) 00:00
      set ::gameclock::data(time1) 00:00

      ::fics::writechan "observe $tmp"
      ::fics::addObservedGame $tmp
    }
  }

  proc updateConsole {line} {

    set t .fics.console.text

    # colors defined line 281

    switch -glob $line {
	{\{Game *\}}	{ $t insert end "$line\n" game }
	{\{Game *\} *}	{ $t insert end "$line\n" gameresult }
	{* tells you:*}	{ $t insert end "$line\n" tells 
			  if {[regexp {(.*) tells you:(.*$)} $line t1 t2 t3]} {
                            if {[set temp [string first {(} $t2]] > -1} {
                              set t2 [string range $t2 0 $temp-1]
                            }
                            switch -glob $t2 {
                              mamer* { 
				      if {! $::fics::no_results} {
					tk_messageBox -title Mamer -icon info -type ok -parent .fics -message "$t2 tells you" -detail $t3
				      }
				    } 
                              ROBO* {
				    }
			      default {
				      if {$::fics::playing != 0} {
					::commenteditor::appendComment "\[$t2\] $t3"
				      }
				      # Add this person to tells
				      set i [lsearch -exact $::fics::tells $t2]
				      if {$i > -1} {
					set ::fics::tells [lreplace $::fics::tells $i $i]
				      }
				      set ::fics::tells [linsert $::fics::tells 0 $t2]
				      set ::fics::tellindex 0
				    }
                            }
			  }
			}
	{* seeking *}	{ $t insert end "$line\n" seeking }
	{->>say *} - {->>. *}	{
                          $t insert end "$line\n" tells 
                          if {$::fics::playing == 1 || $::fics::playing == -1}  {
			    if {[regexp -- {->>say (.*$)} $line t1 t2]} {
			      ::commenteditor::appendComment "\[$::fics::reallogin\] $t2"
			    }
                          }
			}
	{* says: *}	{ $t insert end "$line\n" tells 
			  catch {
                            regexp {(.*) says: (.*$)} $line t1 t2 t3
                            # remove trailing [342] (eg) from player name
                            if {[regexp {(^.*)\[.*\]} $t2 t0 t4]} {
			      ::commenteditor::appendComment "\[$t4\] $t3"
                            } else {
			      ::commenteditor::appendComment "\[$t2\] $t3"
                            } 
                          }
			}
        {Draw request sent*} { ::commenteditor::appendComment "$::fics::reallogin offers draw"
                          $t insert end "$line\n"
                        }
	{->>tell *}	{ $t insert end "$line\n" tells }
    	{->>*}		{ $t insert end "$line\n" command }

	{*[A-Za-z]\(*\): *} { $t insert end "$line\n" channel }
        # {Finger of *}   { $t insert end "$line\n" seeking }
        # {History of *}  { $t insert end "$line\n" seeking }
        {Present company includes: *} { $t insert end "$line\n" gameresult }
        {Game notification: *} { $t insert end "$line\n" gameresult }
        {Notification: *}      { $t insert end "$line\n" gameresult }
        {* goes forward [0-9]* move*} {}
        {* backs up [0-9]* move*} {}
	{Width set *}	{}
	{Height set *}	{}
	{Game * relay has set *} {}
        {* accepts the takeback request.} - {You accept the takeback request *} {
			if {$::fics::takebackMoves > 0} {
			  if {$::fics::takebackMoves % 2 == 1} {
			    set ::fics::playing [expr {- $::fics::playing}]
			  }
			  ::move::Back $::fics::takebackMoves
			  ::game::Truncate
			}
			set ::fics::takebackMoves 0  
        }
	{* would like to take back * half move*} {
      			if {[scan $line {%s would like to take back %d half %s} dummy1 tmp dummy2] == 3} {
			  set ::fics::takebackMoves $tmp
			}
	}
	default		{ $t insert end "$line\n" }
      }

    set pos [ lindex [ .fics.console.scroll get ] 1 ]
    if {$pos == 1.0} {
      $t yview moveto 1
    }
  }

  ### New Fics Offer widgets S.A.

  ### Init 

  proc initOffers {{flag 0}} {
    set w .ficsOffers

    if {[winfo exists $w]} {return}
    set ::fics::exitwithzero $flag

    toplevel $w
    wm state $w withdrawn
    wm title $w "Fics Offers"
    pack [label $w.title -text "Offers for $::fics::reallogin" -font font_Regular] -side top -padx 20 -pady 5

    pack [button $w.cancel -text "Cancel" \
	-command "::fics::writechan unseek ; destroy $w"] -side bottom -pady 5
    pack [frame $w.line -height 2 -borderwidth 2 -relief sunken ] \
        -fill x -expand 1 -side bottom -pady 2

    set ::fics::Offers 0
    ::fics::checkZeroOffers 0 {}

    update
    placeWinOverParent $w .fics
    wm state $w normal
    wm minsize $w [winfo reqwidth $w] [winfo reqheight $w]
  }

  ### Add Offer

  proc addOffer {line} {
    # Challenge: GuestYGTD (----) stevenaaus (1670) unrated standard 15 1
    if {![winfo exists .ficsOffers]} {
        # ::fics::killDialogs
        # hmm - the result is a tk_messageBox -title "Game result"
        catch {destroy .__tk__messagebox}
	::fics::initOffers 1
    }

    set PLAYER [lindex [split $line] 1]
    set details [string range $line [expr {[string last ) $line] + 2}] end]
    set player [string tolower $PLAYER]
    # set elo [string trimright [lindex [split $line] 3] )]
    if { [regexp {\(----\).*([0-9][0-9][0-9])} $line ] || \
         [regexp {\(----\).*\(----\)} $line ] } {
	set elo {unrated}
    } else {
        regexp {([0-9]+)} $line elo 
    }
    if {"$player" == ""} {
       puts "Fics:Empty player offer!"
       return
    }

    set f .ficsOffers.$player

    if {[winfo exists $f]} { 
	return
    }

    ::fics::checkZeroOffers +1 {}

    # Do we have to catch this ?
    pack [frame $f] -side top -padx 5 -pady 5
    pack [label $f.name -text "$PLAYER ($elo) $details" -width 40] -side left
    pack [button $f.decline -text "decline" \
	-command "::fics::writechan \"decline $PLAYER\" ; ::fics::checkZeroOffers -1 $f" ] -side right -padx 5
    pack [button $f.accept -text "accept" \
	-command "::fics::writechan \"accept $PLAYER\"  ; ::fics::checkZeroOffers -1 $f" ] -side right -padx 5
    update
    ### Hmmmm  - accepting an offer can kill this window at any time... How best to handle it ? todo
    catch {raiseWin .ficsOffers}
  }

  ### Delete Offer 

  proc delOffer {player} {
  # Challenge from PLAYER removed.

    if {![winfo exists .ficsOffers]} {
	return
    }

    if {"$player" == ""} {
       puts "Fics:Empty player offer!"
       return
    }

    if {[winfo exists .ficsOffers.$player]} { 
	::fics::checkZeroOffers -1 .ficsOffers.$player
    }
  }

  ### update the number of offers, and draw a blank frame if there's none

  proc checkZeroOffers {n destroyed} {

    catch {
      destroy $destroyed
    }

    set f .ficsOffers.blank

    incr ::fics::Offers $n

    if {$::fics::Offers <= 0} {
      if {$n == -1 && $::fics::exitwithzero} {
        destroy .ficsOffers
        return
      }
      if {$::fics::findopponent(manual) == {auto}} {
	  pack [frame $f] -side top -padx 5 -pady 5
	  pack [label $f.name -text "Awaiting offer" -width 40] -padx 10
      } else {
	if {![winfo exists $f]} {
	  pack [frame $f] -side top -padx 5 -pady 5
	  pack [label $f.name -text "No offers" -state disabled -width 40] -side left 
	  pack [button $f.decline -text "decline" -state disabled ] -side right -padx 5
	  pack [button $f.accept -text "accept" -state disabled ] -side right -padx 5
	}
      }
    } else {
      destroy $f
    }
  }

  proc removeSeek {line} {
    global ::fics::seeklist
    foreach l $line {
      
      if { $l == "<sr>" } {continue}
      
      # remove seek from seeklist
      for {set i 0} {$i < [llength $seeklist]} {incr i} {
        array set a [lindex $seeklist $i]
        if {$a(index) == $l} {
          set seeklist [lreplace $seeklist $i $i]
          break
        }
      }
      
      # remove seek from graph
      if { $::fics::graph(on) } {
        for {set idx 0} { $idx < [llength $::fics::soughtlist]} { incr idx } {
          array set g [lindex $::fics::soughtlist $idx]
          set num $g(game)
          if { $num == $l } {
            .fics.bottom.graph.c delete game_$idx
            break
          }
        }
      }
      
    }
  }

  proc parseStyle12 {line} {

    # <12> r-----k- p----ppp ---rq--- --R-p--- -------- ------PP --R--P-- ------K-
    #      W -1 0 0 0 0 2 182 stevenaaus DRSlay 1 5 12 13 24 84 28 32 Q/e7-e6 (0:40) Qe6 0 1 77

    # * the string "<12>" to identify this line.
    # * eight fields representing the board position.  The first one is White's
    #   8th rank (also Black's 1st rank), then White's 7th rank (also Black's 2nd),
    #   etc, regardless of who's move it is.
    # * color whose turn it is to move ("B" or "W")
    # * -1 if the previous move was NOT a double pawn push, otherwise the chess 
    #   board file  (numbered 0--7 for a--h) in which the double push was made
    # * can White still castle short? (0=no, 1=yes)
    # * can White still castle long?
    # * can Black still castle short?
    # * can Black still castle long?
    # * the number of moves made since the last irreversible move.  (0 if last move
    #   was irreversible.  If the value is >= 100, the game can be declared a draw
    #   due to the 50 move rule.)
    # * The game number
    # * White's name
    # * Black's name
    # * my relation to this game:
    #     -3 isolated position, such as for "ref 3" or the "sposition" command
    #     -2 I am observing game being examined
    #      2 I am the examiner of this game
    #     -1 I am playing, it is my opponent's move
    #      1 I am playing and it is my move
    #      0 I am observing a game being played
    # * initial time (in seconds) of the match
    # * increment In seconds) of the match
    # * White material strength
    # * Black material strength
    # * White's remaining time
    # * Black's remaining time
    # * the number of the move about to be made (standard chess numbering -- White's
    #   and Black's first moves are both 1, etc.)
    # * verbose coordinate notation for the previous move ("none" if there were
    #   none) [note this used to be broken for examined games]
    # * time taken to make previous move "(min:sec)".
    # * pretty notation for the previous move ("none" if there is none)
    # * flip field for board orientation: 1 = Black at bottom, 0 = White at bottom.

    set game  [lindex $line 16]
    set color [lindex $line 9]

    set white [lindex $line 17]
    set black [lindex $line 18]
    set state [lindex $line 19]
    set whiteTime [lindex $line 24]
    set blackTime [lindex $line 25]
    if {$::fics::mainGame == -1 && (
        ($white != {} && $white == $::fics::autoload) ||
        ($black != {} && $black == $::fics::autoload) ) } {
      catch {.fics.bottom.game$game.b.load invoke}
    }

    ### Observed games are a row of small boards down the bottom left 
    if {[lsearch -exact $::fics::observedGames $game] > -1} {
      if { [::board::isFlipped .fics.bottom.game$game.bd] } {
	if {$color == "W"} {
	  .fics.bottom.game$game.b.black configure -text "$white ($whiteTime secs) X"
	  .fics.bottom.game$game.w.white configure -text "$black ($blackTime secs)"
	} else {
	  .fics.bottom.game$game.b.black configure -text "$white ($whiteTime secs)"
	  .fics.bottom.game$game.w.white configure -text "$black ($blackTime secs) X"
	}
      } else {
	if {$color == "W"} {
	  .fics.bottom.game$game.w.white configure -text "$white ($whiteTime secs) X"
	  .fics.bottom.game$game.b.black configure -text "$black ($blackTime secs)"
	} else {
	  .fics.bottom.game$game.w.white configure -text "$white ($whiteTime secs)"
	  .fics.bottom.game$game.b.black configure -text "$black ($blackTime secs) X"
	}
      }

      set moves [lreverse [lrange $line 1 8]]
      set boardmoves [string map { "-" "." " " "" } $moves]
      ::board::update .fics.bottom.game$game.bd $boardmoves 1
      return
    }

    # If not playing and not examiner (state 1, -1, 2), then we unobserve game, as its not in $observedGames
    if { $state != -1 && $state != 1 && $state != 2 && ($game != $::fics::mainGame) } {
      # Is "unobserve" really necessary now. This code *can* be reached, but an unobserve has been queued already
      ::fics::writechan "unobserve $game"
      return
    }

    set initialTime   [lindex $line 20]
    set increment     [lindex $line 21]
    set whiteMaterial [lindex $line 22]
    set blackMaterial [lindex $line 23]
    set whiteRemainingTime [lindex $line 24]
    set blackRemainingTime [lindex $line 25]
    set moveNumber      [lindex $line 26]
    set verbose_move    [lindex $line 27]
    set moveTime        [lindex $line 28]
    set moveSan         [lindex $line 29]
    set ::fics::playing [lindex $line 19]
    set ::fics::mainGame $game

    ::gameclock::setSec 1 [ expr 0 - $whiteRemainingTime ]
    ::gameclock::setSec 2 [ expr 0 - $blackRemainingTime ]
    # Show time remaining in titlebar ?
    # wm title . "$::scidName: $white ($whiteRemainingTime) - $black ($blackRemainingTime)"
    if {$fics::playing == 1 || $fics::playing == -1 ||  $fics::playing == 0} {
      if {$color == "W"} {
	::gameclock::start 1
	::gameclock::stop 2
      } else {
	::gameclock::start 2
	::gameclock::stop 1
      }
    }

    ### Construct fen from [lrange $line 1 8] lines of the game. Slow!
    ### r-----k- p----ppp ---rq--- --R-p--- -------- ------PP --R--P-- ------K-
    set fen ""
    for {set i 1} {$i <=8} { incr i} {
      set l [lindex $line $i]
      set count 0
      
      for { set col 0 } { $col < 8 } { incr col } {
        set c [string index $l $col]
        if { $c == "-"} {
          incr count
        } else {
          if {$count != 0} {
            append fen $count
            set count 0
          }
          append fen $c
        }
      }
      
      if {$count != 0} { append fen $count }
      if {$i != 8} { append fen {/} }
    }

    append fen " [string tolower $color]"
    set f [lindex $line 10]

    # en passant
    if { $f == "-1" || $verbose_move == "none"} {
      set enpassant "-"
    } else {
      set enpassant "-"
      set conv "abcdefgh"
      set fl [string index $conv $f]
      if {$color == "W"} {
        if { [ string index [lindex $line 4] [expr $f - 1]] == "P" || [ string index [lindex $line 4] [expr $f + 1]] == "P" } {
          set enpassant "${fl}6"
        }
      } else {
        if { [ string index [lindex $line 5] [expr $f - 1]] == "p" || [ string index [lindex $line 5] [expr $f + 1]] == "p" } {
          set enpassant "${fl}3"
        }
      }
    }

    set castle ""
    if {[lindex $line 11] == "1"} {set castle "${castle}K"}
    if {[lindex $line 12] == "1"} {set castle "${castle}Q"}
    if {[lindex $line 13] == "1"} {set castle "${castle}k"}
    if {[lindex $line 14] == "1"} {set castle "${castle}q"}
    if {$castle == ""} {set castle "-"}

    append fen " $castle $enpassant [lindex $line 15] $moveNumber"

    if {$::fics::playing == 2} {
      # Examining game
      sc_game tags set -white $white
      sc_game tags set -black $black
      if {$color == "W"} {
        if {$moveNumber > 1} {
	  sc_pos setComment "$moveNumber. ... $moveSan"
        }
      } else {
	sc_pos setComment "$moveNumber. $moveSan"
      }
      if {[catch {sc_game startBoard $fen}]} {
	# Pawn and piece counts get verified in Position::ReadFromFEN, but crazyhouse often has more than 8 pawns.
        # So we may have to setup board manually
	sc_game tags set -result $::fics::examresult
	updateGameinfo
	set moves [lreverse [lrange $line 1 8]]
	set boardmoves [string map { "-" "." " " "" } $moves]
	::board::update .main.board $boardmoves 1
	.button.back    configure -state normal
	.button.forward configure -state normal
	.button.start   configure -state normal
	.button.end     configure -state normal
      } else {
	sc_game tags set -result $::fics::examresult
	updateBoard -pgn
      }
      wm title $::dot_w "$::scidName: $white - $black (examining game $game)"
      return
    }

    # puts $verbose_move
    # puts $moveSan

    # try to play the move and check if fen corresponds. If not this means the position needs to be set up.
    if {$moveSan != "none" && $::fics::playing != -1} {
      # Process opponents move
      # Move to game end incase user was messing around with the game
      sc_move end

      # Why is this check necessary ?
      if { ([sc_pos side] == "white" && $color == "B") || ([sc_pos side] == "black" && $color == "W") } {

       if {$::fics::playing == 1} {
          ::fics::checkRaise
        }

        set ::fics::lastmove $moveSan ; # remember last opponents move for takeback comment
        if {[catch {sc_move addSan $moveSan } err]} {
          # This is a common occurence when moving observed games to the main board
          # puts "error $err"
        } else {
	  if {$::fics::premove != {}} {
	    ### Send premove 
	    if {$fen == [sc_pos fen]} {
	      updateBoard -pgn -animate
	      lassign $::fics::premove move sq1 sq2
	      set promoLetter ""
	      catch {
		if {[sc_pos isPromotion $sq1 $sq2] == 1 && ![winfo exists .promoWin]} {
		  set promo [getPromoPiece]
		  switch -- $promo {
		    2 { set promoLetter "q"}
		    3 { set promoLetter "r"}
		    4 { set promoLetter "b"}
		    5 { set promoLetter "n"}
		    default {set promoLetter ""}
		  }
		}
	      }

              # should we use "proc addSanMove"
              if { [catch {sc_move addSan $move$promoLetter}]} {
                puts "Premove $move failed"
              } else {
		if {$promoLetter != ""} {
		  ::fics::writechan "promote $promoLetter"
		}
		::fics::writechan $move
		### Stop clock
		if {[sc_pos side] == "white"} {
		  ::gameclock::stop 2
		} else {
		  ::gameclock::stop 1
		}
		updateBoard -pgn -animate
              }
	    }
	    set ::fics::premove {}
	    return
	  } 
	  if {$::fics::sound} {
	    ::utils::sound::PlayMove sound_move
	  }
          if { $::novag::connected } {
            set m $verbose_move
            if { [string index $m 1] == "/" } { set m [string range $m 2 end] }
            set m [string map { "-" "" "=" "" } $m]
            ::novag::addMove $m
          }
        }
      }
    } else {
      set ::fics::playerslastmove $moveSan
      set ::fics::premove {}
    }

    if {$fen == [sc_pos fen]} {
      wm title $::dot_w "$::scidName: $white - $black (game $game: $::fics::timecontrol)"
      updateBoard -pgn -animate
    } else {
puts "HMMMM \n$fen \n[sc_pos fen]"
      ### Game out of sync, probably due to player takeback request (or opponent take back 2).
      ### But also used to load observed games
      # After player takeback, game gets reconstructed, comments are zeroed. Opponents takeback is handled better elsewhere.
      # Fics doesn't give much warning that take back was succesful, only the uncertain "Takeback request sent."
      # If player makes a move after his time has expired, we end up here. Bad.
      # Todo: Before starting new game, try to move backwards in game.
      # todo: should we stop clocks now ?

      # To solve the problem of concurrent processing of parseStyle12 lines, we have to have mutexs on this proc
      # ... for some reason using individual mutexs for each game doesnt work properly &&&
      # while {$::fics::mutex($num)} {vwait ::fics::mutex($num)}

      if {$::fics::mutex} {
        return
      }
      set ::fics::mutex 1

      # puts "Debug fen \n$fen\n[sc_pos fen]"

      ### Save previous (unfinished?) game.
      # ideally we can save observed games too, but only after we have the "Debug fen" working 100%

      if {[string match -nocase $white $::fics::reallogin] ||
          [string match -nocase $black $::fics::reallogin]} {
	catch {::game::Save}
      }

      sc_game new
      sc_game tags set -white $white
      sc_game tags set -black $black
      if {[info exists ::fics::elo($white)]} {
	sc_game tags set -whiteElo $::fics::elo($white)
      }
      if {[info exists ::fics::elo($black)]} {
	sc_game tags set -blackElo $::fics::elo($black)
      }
      sc_game tags set -date [::utils::date::today]
      set ::fics::timecontrol $initialTime/$increment
      sc_game tags set -extra [list "Time \"[::utils::date::time]\"" "TimeControl  \"$::fics::timecontrol\""]

      ### Try to get first moves of game

      writechan "moves $game"
      set ::fics::waitForMoves $fen
      vwaitTimed ::fics::waitForMoves 5000 nowarn
      set ::fics::waitForMoves ""

      # After the 5 second time period, we could decide to give up and just set the FEN,
      # but this leaves the game without it's move history
      if {$fen != [sc_pos fen]} {
        # Did not manage to reconstruct the game, just set its position
        # (But this never works !? &&& )
        sc_game startBoard $fen
      }

      set ::fics::mutex 0
      updateBoard -pgn
      wm title $::dot_w "$::scidName: $white - $black (game $game: $::fics::timecontrol)"

      if {$::fics::playing != 1 && $::fics::playing != -1 && $::fics::observedGames != {}} {
	catch {.fics.bottom.game${::fics::primary}.w.result configure -font font_Small}
        writechan "primary $game"
        set ::fics::primary $game
      }
    }
  }

  proc parseSeek {line} {
    array set seekelt {}
    set seekelt(index) [lindex $line 1]
    foreach m [split $line] {
      if {[string match "w=*" $m]} { set seekelt(name_from) [string range $m 2 end] ; continue }
      if {[string match "ti=*" $m]} { set seekelt(titles) [string range $m 3 end] ; continue }
      if {[string match "rt=*" $m]} { set seekelt(rating) [string range $m 3 end] ; continue }
      if {[string match "t=*" $m]} { set seekelt(time) [string range $m 2 end] ; continue }
      if {[string match "i=*" $m]} { set seekelt(increment) [string range $m 2 end] ; continue }
      if {[string match "r=*" $m]} { set seekelt(rated) [string range $m 2 end] ; continue }
      if {[string match "tp=*" $m]} { set seekelt(type) [string range $m 3 end] ; continue }
      if {[string match "c=*" $m]} { set seekelt(color) [string range $m 2 end] ; continue }
      if {[string match "rr=*" $m]} { set seekelt(rating_range) [string range $m 3 end] ; continue }
      if {[string match "a=*" $m]} { set seekelt(automatic) [string range $m 2 end] ; continue }
      if {[string match "f=*" $m]} { set seekelt(formula_checked) [string range $m 2 end] ; continue }
    }
    lappend ::fics::seeklist [array get seekelt]
  }


  # Unused

  proc redim {} {
    set w .fics
    update
    set x [winfo reqwidth $w]
    set y [winfo reqheight $w]
    wm geometry $w ${x}x${y}
  }
  
  proc showGraph {} {
    set w .fics.bottom

    ### Either the buttons or offers graph are shown at any one time

    if { $::fics::graph(on) } {
      pack forget $w.buttons
      pack $w.graph -side right -padx 2 -pady 5 -anchor center
      bind .fics <Escape> {
        set ::fics::graph(on) 0
        ::fics::showGraph
      }
      updateAds
    } else {
      after cancel ::fics::updateAds
      bind .fics <Escape> ".fics.command.entry delete 0 end"
      pack forget $w.graph
      $w.graph.c delete game
      $w.graph.c delete status
      pack $w.buttons -side right -padx 2 -pady 5 -anchor center
    }

    ### Repacking can make the console suspend, so seek to console end 
    update
    catch {.fics.console.text yview moveto 1} ; # in case we quit fics already
  }

  proc updateAds { } {
    set ::fics::sought 1
    # set ::fics::newsoughtlist {}

    writechan sought
    vwait ::fics::sought 

    # Don't update Ads anymore if playing
    if {$::fics::playing != 1 && $::fics::playing != -1 && $::fics::graph(on) && [winfo exists .fics]} {
      # We no longer have to wait till seeking new Ads (maybe this update could be where we call displayGraph
      ::fics::updateAds
    }
  }


  proc displayGraph {} {
    global ::fics::graph ::fics::offers_minelo ::fics::offers_maxelo ::fics::offers_mintime ::fics::offers_maxtime

    after cancel ::fics::updateAds

    set w .fics.bottom.graph
    set size 7
    set idx 0

    # delete games
    $w.c delete game

    if {!$graph(init)} {
      set graph(init) 1
      set graph(xoff) 15 ;# axis offset
      set graph(yoff) [expr $graph(xoff) - 2]
      set gy [expr $graph(height) - $graph(yoff)]

      # Draw Axis
      # E (xoff,0)
      # L |
      # O |
      #   |
      #   |
      #   (xoff,gy)-------------------(width,gy) Time

      # X axis, Y Axis
      $w.c create line $graph(xoff) $gy $graph(width) $gy -fill blue
      # Y axis
      $w.c create line $graph(xoff) $gy $graph(xoff) 0 -fill blue

      # Labels
      $w.c create text [expr $graph(xoff) - 10] 0 -fill black -anchor nw -text "E\nL\nO"
      # $w.c create text $graph(width) [expr $graph(height) + 2] -fill black -anchor se -text [tr Time]

      # Time markers at 5 (rapid/blitz), 10, 15 (blitz/standard) minutes
      foreach mins {5 10 15} {
	set x [ expr $graph(xoff) + $mins * ($graph(width) - $graph(xoff)) / ($offers_maxtime - $offers_mintime)]
	$w.c create line $x 0 $x $gy -fill grey
	$w.c create text [expr $x - 5] [expr $graph(height) + 2]  -fill black -anchor sw -text "${mins}min"
      }
    }
    foreach g $::fics::soughtlist {
      array set l $g
      set fillcolor skyblue ; set outline blue

      # if the time is too large, put it in red
      set tt [expr $l(time_init) + $l(time_inc) * 2 / 3 ]
      if { $tt > $offers_maxtime } {
        set tt $offers_maxtime
        set fillcolor red ; set outline darkred
      }
      # Computer opponent
      if { [string match "*(C)" $l(name)] } {
        set fillcolor green ; set outline darkgreen
      }
      # Player without ELO
      if { [string match "Guest*" $l(name)] } {
        set fillcolor gray ; set outline darkgray
      }
      
      set x [ expr $graph(xoff) + $tt * ($graph(width) - $graph(xoff)) / ($offers_maxtime - $offers_mintime)]
      set y [ expr $graph(height) - $graph(yoff) - ( $l(elo) - $offers_minelo ) * ($graph(height) - $graph(yoff)) / ($offers_maxelo - $offers_minelo)]
      if { $l(rated) == "rated" } {
        set object "oval"
      } else {
        set object "rectangle"
      }
      $w.c create $object [expr $x - $size ] [expr $y - $size ] [expr $x + $size ] [expr $y + $size ] \
           -tags "game game_$idx" -fill $fillcolor -outline $outline
      
      $w.c bind game_$idx <Enter> "::fics::showGraphText $idx %x %y"
      $w.c bind game_$idx <Leave> "::fics::delGraphText $idx"
      $w.c bind game_$idx <ButtonPress> "::fics::acceptGraphGame $idx"
      incr idx
    }

  }

  ### Play the selected game

  proc acceptGraphGame { idx } {
    array set ga [lindex $::fics::soughtlist $idx]
    catch {
      writechan "play $ga(game)" echo
    }
  }

  proc delGraphText { idx } {
    set w .fics.bottom.graph

    $w.c itemconfig game_$idx -width 1
    $w.c delete status
  }

  proc showGraphText {idx x y {exit 0}} {

    set w .fics.bottom.graph

    $w.c itemconfig game_$idx -width 2
    set gl [lindex $::fics::soughtlist $idx]
    if { $gl == "" } { return }
    array set l [lindex $::fics::soughtlist $idx]
    set m "$l(name)($l(elo)) $l(time_init)/$l(time_inc) $l(rated) $l(type) $l(color) $l(start)"
    
    $w.c delete status
    $w.c create text 20 0 -tags status -text "$m" -font font_Regular -anchor nw
    $w.c raise game_$idx

  }

  proc writechan {line {echo "noecho"}} {
    after cancel ::fics::stayConnected
    if {[eof $::fics::sockchan]} {
      tk_messageBox -title "Write error" -icon error -type ok -message "Network error\nFics will exit"
      ::fics::close error
      return
    }

    if {$::fics::use_timeseal} {
      # Remove non-ascii chars. They cause timeseal to die and give a network error
      set line [regsub -all {[\u0080-\uffff]} $line ?]
    }

    puts $::fics::sockchan $line

    if {$echo != "noecho"} {
      updateConsole "->>$line"
    }
    after 2700000 ::fics::stayConnected
  }
  ################################################################################
  # FICS seems to close connexion after 1 hr idle. So send a dummy command
  # every 45 minutes
  ################################################################################
  proc stayConnected {} {
    catch {
      writechan "date" "noecho"
      after 2700000 ::fics::stayConnected
    }
  }

  proc close {{mode {}}} {
    variable logged

    if {![winfo exists .fics]} {
      return
    }
    bind .fics <Destroy> {}
    destroy .main.board.clock2
    destroy .main.board.clock1

    # Unused
    if {$mode == "safe"} {
      ::fics::killDialogs
      set ans [tk_dialog .fics_dialog Abort "You are playing a game\nDo you want to exit ?" question {} Exit Cancel ]
      if {$ans == 1} {
	bind .fics <Destroy> ::fics::close
        return
      }
    }

    set ::fics::sought 0
    after cancel ::fics::updateAds
    after cancel ::fics::stayConnected
    set logged 0

    if {$mode == "error"} {
      if {$::fics::playing == -1 || $::fics::playing == 1} {
        set t1 [::gameclock::getSec 1]
        set t2 [::gameclock::getSec 2]
	::commenteditor::appendComment "Disconnected\nWhiteclock [expr $t1 / 60]:[format {%02i} [expr $t1 % 60]] Blackclock [expr $t2 / 60]:[format {%02i} [expr $t2 % 60]]"
        if {[sc_pos moveNumber] > 2} {
          catch {::game::Save}
          updateBoard -pgn
        }
        ::windows::gamelist::Refresh
      }
    } else {
	catch {writechan "exit"}
    }
    if {$fics::playing == 1 || $fics::playing == -1} {
      enableEngines
    }
    set ::fics::playing 0
    set ::fics::mainGame -1
    set ::pause 0
    # Hmmm... why do we need to catch these ?
    catch { ::close $::fics::sockchan }
    catch { ::close $::fics::sockping }
    after cancel ::fics::clearPing
    if { ! $::windowsOS } { catch { exec -- kill -s INT [ $::fics::timeseal_pid ] }  }

    ::docking::cleanup .fics
    catch {destroy .ficsOffers}
    catch {destroy .fics}
  }


  proc initPing {} {
    # get ping to report in every 10 seconds
    set ::fics::sockping [open "|ping -i 10 $::fics::server" r]
    fconfigure $::fics::sockping -blocking 0 -buffering line -translation auto 
    fileevent $::fics::sockping readable ::fics::readPing
    updateConsole "Starting Ping"
  }

  proc readPing {} {

    # ping should report every ten seconds (see above), so if it doesn't, zero ping label
    after cancel ::fics::clearPing
    after 18000  ::fics::clearPing 
    
    if {[eof $::fics::sockping]} {
      fileevent $::fics::sockping readable {}
      puts "Ping exitted"
      return
    }
    set line [gets $::fics::sockping]
    
    if {[regexp {.* time=([[:digit:]]*\.?[[:digit:]]*) } $line t1 t2]} {
      set ::fics::ping "ping: [expr int($t2)] ms"
    } else {
      set ::fics::ping {ping ....}
    }
    ### Windows/ FreeBSD ?
    ### ping: 64 bytes from fics.freechess.org (69.36.243.188): icmp_seq=24 ttl=55 time=265 ms
  }

  proc clearPing {} {
    set ::fics::ping {ping ....}
  }

  proc checkRaise {} {
    # only autoraise if greater than 1.5 seconds since last entry keyboard input
    if {$::fics::autoraise && [expr {[clock milli] - $::fics::entrytime > 1500}]} {
      if {[wm state $::dot_w] != {normal}} {
          # fixme : what is the best way to not generate <Map> which in turn raiseAllWindows and leave fics on top.
	  wm deiconify $::dot_w
      }
      # this is a bit of a mess
      if  {$::docking::USE_DOCKING} {
	raiseWin .main
      } else {
	raise .main
	focus .main
      }
    }
  }

  proc setForeGround {} {
    set fg [tk_chooseColor -initialcolor $::fics::consolefg -title {FICS Text} -parent .]
    if {![catch {.fics.console.text configure -fg $fg}]} {
      set ::fics::consolefg $fg
    }
  }

  proc setBackGround {} {
    set bg [tk_chooseColor -initialcolor $::fics::consolebg -title {FICS Background} -parent .]
    if {![catch {.fics.console.text configure -bg $bg}]} {
      set ::fics::consolebg $bg
    }
  }

  ### Send the last move made (via book, tree, engine or main.tcl) to fics if playing

  proc checkAdd {} {
    if {$::fics::playing == 1 && [winfo exists .fics]}  {
      # If just castled, send San move
      set previousMove [sc_game info previousMove]
      if {[string match O-O* $previousMove]} {
	::fics::writechan $previousMove
      } else {
	set moveUCI [sc_game info previousMoveUCI]
	if { [ string length $moveUCI ] == 5 } {
	  set promoLetter [ string tolower [ string index $moveUCI end ] ]
	  ::fics::writechan "promote $promoLetter"
	}
	::fics::writechan [string range $moveUCI 0 3 ]
      }

      ### Stop clock
      if {[sc_pos side] == "white"} {
	::gameclock::stop 2
      } else {
	::gameclock::stop 1
      }
    }
  }

  proc killDialogs {} {
      if {[winfo exists .fics_dialog]} {
        destroy .fics_dialog
      }
  }

  proc disableEngines {} {
    for {set i 0} {$i < [llength $::engines(list)]} {incr i} {
      if {[winfo exists .analysisWin$i]} {
	if {$::analysis(analyzeMode$i)} {
	  toggleEngineAnalysis $i
	 }
	.analysisWin$i.b.startStop configure -state disabled
      }
    }
  }

  proc enableEngines {} {
    for {set i 0} {$i < [llength $::engines(list)]} {incr i} {
      if {[winfo exists .analysisWin$i]} {
	.analysisWin$i.b.startStop configure -state normal
      }
    }
  }

  proc editUserButtons {} {
    set w .editUserButtons

    if {[winfo exists $w]} {
      raiseWin $w
      return
    }
    toplevel $w
    wm state $w withdrawn
    wm title $w "FICS: [tr OptionsFicsButtons]"

    foreach i {0 1 2} {
      set f $w.f$i
      frame $f
      entry $f.button -width 8
      entry $f.command -width 40
      $f.button insert 0 [lindex $::fics::user_buttons $i]
      $f.command insert 0 [lindex $::fics::user_commands $i]
      pack $f -side top -fill both -expand yes
      pack $f.button $f.command -side left -fill x -expand yes -pady 3 -padx 3
    }

    addHorizontalRule $w

    frame $w.b
    pack $w.b -side bottom 

    dialogbutton $w.b.ok -text OK -command {
      set ::fics::user_buttons {}
      set ::fics::user_commands {}
      foreach i {0 1 2} {
	set f .editUserButtons.f$i
	lappend ::fics::user_buttons [$f.button get]
	lappend ::fics::user_commands [$f.command get]
	if {[winfo exists .fics.bottom.buttons.user$i]} {
          set b [string trim [$f.button get]]
	  if {[lsearch -exact {FICSInfo FICSOpponent Abort} $b] > -1} {
            set b [tr $b]
          }
	  .fics.bottom.buttons.user$i configure -text $b -command [$f.command get]
        }
      }
      destroy .editUserButtons
    }

    dialogbutton $w.b.defaults -text $::tr(Defaults) -command {
      ::fics::initUserButtons
      foreach i {0 1 2} { 
	set w .editUserButtons
	set f $w.f$i
	$f.button delete 0 end
	$f.command delete 0 end
	$f.button insert 0 [lindex $::fics::user_buttons $i]
	$f.command insert 0 [lindex $::fics::user_commands $i]
      } 
    }

    dialogbutton $w.b.cancel -text $::tr(Cancel) -command "destroy $w"
    pack $w.b.cancel $w.b.defaults $w.b.ok -side right -padx 10 -pady 5

    bind $w <Escape> "destroy $w"
    update
    if {[winfo exists .fics]} {
      placeWinOverParent $w .fics
    } else {
      placeWinOverParent $w .
    }
    bind $w <F1> {helpWindow FICSwidget}
    wm state $w normal
    update
  }

  proc editInitCommands {} {
    set w .editInitCommands

    if {[winfo exists $w]} {
      raiseWin $w
      return
    }
    toplevel $w
    wm state $w withdrawn
    wm title $w "FICS: [tr OptionsFicsCommands]"

    text $w.text -width 50 -height 10 -wrap none
    foreach name $::fics::init_commands {
      $w.text insert end "$name\n"
    }
    pack $w.text -side top -fill both -expand yes

    addHorizontalRule $w

    frame $w.b
    pack $w.b -side bottom 

    dialogbutton $w.b.ok -text OK -command {
      set ::fics::init_commands {}
      foreach i [split [string trim [.editInitCommands.text get 1.0 end]] "\n"] {
        if {$i != ""} {
          lappend ::fics::init_commands $i
        }
      }
      destroy .editInitCommands
    }
    dialogbutton $w.b.defaults -text $::tr(Defaults) -command {
      .editInitCommands.text delete 0.0 end
      .editInitCommands.text insert end "set gin 0
set echo 1
set seek 0"
    }
    dialogbutton $w.b.cancel -text $::tr(Cancel) -command "destroy $w"
    pack $w.b.cancel $w.b.defaults $w.b.ok -side right -padx 10 -pady 5

    bind $w <Escape> "destroy $w"
    update
    if {[winfo exists .fics]} {
      placeWinOverParent $w .fics
    } else {
      placeWinOverParent $w .
    }
    bind $w <F1> {helpWindow FICSwidget}
    wm state $w normal
    update
  }

  proc togglebuttons {} {
    set w .fics
    set ::fics::show_buttons [expr {1 - $::fics::show_buttons}]
    if {$::fics::show_buttons} {
      pack $w.bottom  -side bottom -before $w.command
      $w.command.hide configure -image bookmark_down
    } else {
      pack forget $w.bottom
      $w.command.hide configure -image bookmark_up
    }
  }

}

###
### End of file: fics.tcl
###
