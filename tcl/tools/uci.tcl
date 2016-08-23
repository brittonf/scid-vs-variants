###
### uci.tcl: part of Scid.
### Copyright (C) 2007  Pascal Georges
###
######################################################################
### add UCI engine support

namespace eval uci {
  # will contain the UCI engine options saved
  variable newOptions {}

  # set pipe ""
  set uciOptions {}
  set optList {}
  set oldOptions ""
  array set check ""

  # infoToken contains a list of known info tokens (used to find the end of "pv" tokens)
  set infoToken {depth seldepth time nodes pv multipv score cp mate lowerbound upperbound currmove currmovenumber hashfull nps tbhits sbhits cpuload string refutation currline}

  set optionToken {name type default min max var }
  set optionImportant {MultiPV Hash OwnBook BookFile UCI_LimitStrength UCI_Elo Ponder Threads {Skill Level}}
  set optionToKeep { UCI_LimitStrength UCI_Elo UCI_ShredderbasesPath }
  array set uciInfo {}
  ################################################################################
  #
  ################################################################################
  proc resetUciInfo {n} {
    global ::uci::uciInfo
    set uciInfo(depth$n)    0
    set uciInfo(seldepth$n) 0
    set uciInfo(pv$n)      ""
    set uciInfo(multipv$n) ""
    set uciInfo(tmp_score$n) ""
    set uciInfo(scoremate$n) ""
    set uciInfo(currmove$n) ""
    set uciInfo(currmovenumber$n) 0
    # hmmm
    # set uciInfo(score$n) ""
    set uciInfo(skill) ""
  }

  proc resetUciInfo2 {n} {
    global ::uci::uciInfo
    set uciInfo(nodes$n)    0
    set uciInfo(time$n)     0
    set uciInfo(nps$n) 0
    set uciInfo(hashfull$n) ----
    set uciInfo(tbhits$n) ----
    set uciInfo(sbhits$n) ----
    set uciInfo(cpuload$n) ----
    set uciInfo(ponder$n) {}
    ### these three are unused
    # set uciInfo(string$n) ""
    # set uciInfo(refutation$n) ""
    # set uciInfo(currline$n) ""
    set uciInfo(bestmove$n) ""
    set uciInfo(searchmoves$n) ""
  }

  ### if gui = 0 -> engine mode,   pipe used is $uciInfo(pipe$n)
  ### if gui = 1 -> normal mode, pipe used is $analysis(pipe$n)
  # This distinction allows tacGame::Toga and F2 to run at the same time

  # todo: sort out the analyze var with computer tournament feature &&&

  proc processAnalysisInput { {n 1} {gui 1} } {
    global analysis annotate comp ::uci::uciInfo ::uci::optionToken 

    if {$gui} {
      set pipe $analysis(pipe$n)
      if { ! [ ::checkEngineIsAlive $n ] } { return }
    } else  {
      set analysis(startpos$n) ""
      set pipe $uciInfo(pipe$n)
      if { ! [ ::uci::checkEngineIsAlive $n ] } { return }
    }

    if {$gui} {
      if {! $analysis(seen$n)} {
        set analysis(seen$n) 1
        logEngineNote $n {First line from engine seen; sending it initial commands now.}
        # in order to get options, engine should end reply with "uciok"
        ::sendToEngine $n "uci"
      }
    } else  {
      if {! $uciInfo(seen$n)} {
        set uciInfo(seen$n) 1
        # logEngineNote $n {First line from engine seen; sending it initial commands now.}
        ::uci::sendToEngine $n "uci"
      }
    }

    # Get one line from the engine:
    set line [gets $pipe]
    if {$line == ""} { return }

    # To speed up parsing of engine's output. Should be removed if currmove info is used
    # if {[string first "info currmove" $line ] == 0} { return }

    logEngine $n "Engine: $line"

    if {[string match "bestmove*" $line]} {
      if {$annotate(Engine) == $n} {
        set ::pause 0
        return
      }
      if {$uciInfo(bestmove$n) == "stop"} {
        # Ponder miss as set by comp.tcl. Discard this bestmove
        set uciInfo(bestmove$n) {}
        return
      }
      set data [split $line]
      set uciInfo(bestmove$n) [lindex $data 1]

      # Sometimes Umko issues a bad bestmove, and then good ones, but not always a "pv" line
      # We rely on "pv" lines (and uciInfo(pv$n)) for getting the best UCI move, so this hack addresses this
      if {$comp(playing)} {
	set analysis(moves$n) [lindex $data 1]
      }

      # get ponder move
      if {[lindex $data 2] == "ponder"} {
        set uciInfo(ponder$n) [lindex $data 3]
      } else {
        set uciInfo(ponder$n) ""
      }
      set analysis(waitForBestMove$n) 0

      return
    }

    ### Parse info line

    if {[string match "info*" $line]} {
      # For a speed bump, ignore info lines if no display and playing a comp
      # Note - the "Add move" button requires parsing of these info lines

      if {$comp(playing) && !$comp(showscores) && !$analysis(movesDisplay$n) } {
         return
      }

      # In annotation mode, ignore infos until ::pause is reset by a readyok
      if {$annotate(Engine) == $n && $annotate(Depth) && $::pause} {
        return
      }

      # keep UI responsive when engine outputs lots of info (garbage ?)
      update idletasks

      set toBeFormatted 0

      resetUciInfo $n

      set data $line

      set length [llength $data]
      set annoMove {}
      for {set i 0} {$i < $length } {incr i} {
        set t [lindex $data $i]
        if { $t == "info" } { continue }
        if { $t == "depth" } {
	  incr i
	  set uciInfo(depth$n) [ lindex $data $i ]
          set uciInfo(pv$n) "" ; # some infos only contain depth, no pv
	  continue
	}
        if { $t == "seldepth" } { incr i ; set uciInfo(seldepth$n) [ lindex $data $i ] ; set analysis(seldepth$n) $uciInfo(seldepth$n) ; continue }
        if { $t == "time" } { incr i ; set uciInfo(time$n) [ lindex $data $i ] ; continue }
        if { $t == "nodes" } { incr i ; set uciInfo(nodes$n) [ lindex $data $i ] ; continue }
        if { $t == "pv" } {
          incr i

          ### Assuming "pv" infos are always last gains ~ 100usecs but is against UCI standard
          set uciInfo(pv$n) [lrange $data $i end]
          if {$analysis(maxPly) > 0} {
	    set uciInfo(pv$n) [lrange $uciInfo(pv$n) 0 [expr {$analysis(maxPly) - 1}]]
          }
          ### Depth annotation feature
	  if {$annotate(Engine) == $n && $annotate(Depth)} {
	    if {($uciInfo(depth$n) >= $annotate(WantedDepth) || $uciInfo(scoremate$n) > 0) || [sc_pos matchMoves {}] == {} } {
		set annoMove [lindex $uciInfo(pv$n) 0]
		set ::pause 1
	    }
	  }
          set toBeFormatted 1
          break
        }
        if { $t == "multipv" } { incr i ; set uciInfo(multipv$n) [ lindex $data $i ] ; continue }
        if { $t == "score" } {
          incr i
          set next [ lindex $data $i ]
	  # Needed for Prodeo, which is not UCI compliant
	  if { $next != "cp" && $next != "mate" } {
	      return
	  }
          if { $next == "cp" } {
            incr i
            set uciInfo(tmp_score$n) [ lindex $data $i ]
          }
          if { $next == "mate" } {
            incr i
            set next [ lindex $data $i ]
            set uciInfo(scoremate$n) $next
            # A little hack to make (say) "mate in 1" better than "mate in 3"
	    if { $next < 0} {
		set uciInfo(tmp_score$n) [expr {-32750 - $next}]
	    } else  {
		set uciInfo(tmp_score$n) [expr {32750 - $next}]
	    }
          }
          # convert the score to white's perspective (not engine's one)

          if { $analysis(side$n) == "black"} {
            set uciInfo(tmp_score$n) [ expr 0.0 - $uciInfo(tmp_score$n) ]
            if { $uciInfo(scoremate$n) != ""} {
              set uciInfo(scoremate$n) [ expr 0 - $uciInfo(scoremate$n) ]
            }
          }
          set uciInfo(tmp_score$n) [expr {double($uciInfo(tmp_score$n)) / 100.0} ]
          
          # don't consider lowerbound & upperbound score info
          continue
        }
        if { $t == "currmove" } {
           incr i
           set uciInfo(currmove$n) [lindex $data $i]
           set analysis(currmove$n) [formatPv $n $uciInfo(currmove$n)]
           continue}
        if { $t == "currmovenumber" } {
           incr i
           set uciInfo(currmovenumber$n) [lindex $data $i]
           set analysis(currmovenumber$n) $uciInfo(currmovenumber$n)
           continue}
        if { $t == "nps" } {
           incr i
           set uciInfo(nps$n) [lindex $data $i]
           set analysis(nps$n) $uciInfo(nps$n)
           continue}

        # These are UCI only
        if { $t == "hashfull" } {
           incr i
           set uciInfo(hashfull$n) [format "%u%%" [expr {round([lindex $data $i] / 10)}]]
           continue}
        if { $t == "tbhits" } {
           # unused at moment
           incr i
           set uciInfo(tbhits$n) [format "%u" [lindex $data $i]]
           continue}
        if { $t == "sbhits" } {
           # unused at moment
           incr i
           set uciInfo(sbhits$n) [format "%u" [lindex $data $i]]
           continue}
        if { $t == "cpuload" } {
           incr i
           set uciInfo(cpuload$n) [format "%u%%" [expr {round( [lindex $data $i] / 10)}]]
           continue}
        if { $t == "string" } {
          # seems unused
          incr i
          set uciInfo(string$n) [lrange $data $i end]
          break}
        # TODO parse following tokens if necessary  : refutation currline
        if { $t == "refutation" } { continue }
        if { $t == "currline" } { continue }
      }; # end for data loop

      ### Malformed time args break. Should we include this check ?
      # if {![string is double $uciInfo(time$n)]} {set uciInfo(time$n) 0}
      
      # return if no interesting info
      if { $uciInfo(tmp_score$n) == "" || $uciInfo(pv$n) == "" } {
        if {$gui} {
          updateAnalysisText $n
        } else {
          set analysis(side$n) [sc_pos side]
        }
        return
      }
      
      # handle the case an UCI engine does not send multiPV
      if { $uciInfo(multipv$n) == "" } { set uciInfo(multipv$n) 1 }
      
      if { $uciInfo(multipv$n) == 1 } {
        set uciInfo(score$n) $uciInfo(tmp_score$n)
      }
      
      if { $uciInfo(multipv$n) == 1 && $gui} {
        # this is the best line
        set analysis(prevdepth$n) $analysis(depth$n)
        set analysis(depth$n) $uciInfo(depth$n)
        set analysis(score$n) $uciInfo(score$n)
        if { $uciInfo(scoremate$n) != "" } {
	    set analysis(scoremate$n) $uciInfo(scoremate$n)
	} else {
	    set analysis(scoremate$n) 0
	}
        set analysis(moves$n) $uciInfo(pv$n)
        set analysis(time$n) [expr {double($uciInfo(time$n)) / 1000.0} ]
        set analysis(nodes$n) [calculateNodes $uciInfo(nodes$n)]
      }
      
      set pvRaw $uciInfo(pv$n)

      # convert to something more readable
      if ($toBeFormatted) {
        set uciInfo(pv$n) [formatPv $n $uciInfo(pv$n)]
        set toBeFormatted 0
      }

      set idx [ expr $uciInfo(multipv$n) -1 ]
      
      if { $idx < $analysis(multiPVCount$n) } {
        if {$idx < [llength $analysis(multiPV$n)]} {
          lset analysis(multiPV$n) $idx "$uciInfo(depth$n) $uciInfo(tmp_score$n) [list $uciInfo(pv$n)] $uciInfo(scoremate$n)"
          lset analysis(multiPVraw$n) $idx "$uciInfo(depth$n) $uciInfo(tmp_score$n) [list $pvRaw] $uciInfo(scoremate$n)"
        } else  {
          lappend analysis(multiPV$n) "$uciInfo(depth$n) $uciInfo(tmp_score$n) [list $uciInfo(pv$n)] $uciInfo(scoremate$n)"
          lappend analysis(multiPVraw$n) "$uciInfo(depth$n) $uciInfo(tmp_score$n) [list $pvRaw] $uciInfo(scoremate$n)"
        }
      }

      if {$gui} {
	updateAnalysisText $n
      } else {
	set analysis(side$n) [sc_pos side]
      }

      # if Annotating, goto next move
      if {$annoMove != ""} {
	after cancel autoplay ; # needed ???
	autoplay
      }

      return
    } ;# end of info line

    # the UCI engine answers to <uci> command
    if { $line == "uciok"} {
      if {$analysis(waitForUciOk$n)} {
        set analysis(waitForUciOk$n) 0
      }
      resetUciInfo $n
      resetUciInfo2 $n
      sendUCIoptions $n
      if {$gui} {
        set analysis(uciok$n) 1
        # sendUCIoptions $n
        # configure initial multipv value
        #        changePVSize $n
        if {$analysis(autostart$n)} {
	  startAnalyzeMode $n
        }
      } else  {
        set uciInfo(uciok$n) 1
      }

      return
    }

    # the UCI engine answers to <isready> command
    if { $line == "readyok"} {
      if {$analysis(waitForReadyOk$n)} {
        set analysis(waitForReadyOk$n) 0
      }
      return
    }

    # get options and save only part of data
    if { [string match "option name*" $line] && $gui } {
      set min "" ; set max ""
      set data [split $line]
      set length [llength $data]
      for {set i 0} {$i < $length} {incr i} {
        set t [lindex $data $i]
        if {$t == "name"} {
          incr i
          set name [ lindex $data $i ]
          incr i
          while { [ lsearch -exact $optionToken [ lindex $data $i ] ] == -1 && $i < $length } {
            append name " " [ lindex $data $i ]
            incr i
          }
          incr i -1
          continue
        }
        if {$t == "min"} { incr i ; set min [ lindex $data $i ] ; continue }
        if {$t == "max"} {incr i ; set max [ lindex $data $i ] ; continue }
      }
      lappend analysis(uciOptions$n) [ list $name $min $max ]

      return
    }

    # Hmmmm.... What happens if we're playing computer tournaments with the same engine against itself
    # So if tourney, don't rename engine
    if {!$comp(playing) && [string match "id name *" $line]} {
      set name [ regsub {id[ ]?name[ ]?} $line "" ]
      if {$gui} {
        set analysis(name$n) $name
      } else  {
        set uciInfo(name$n) $name
      }
      catch {::setTitle .analysisWin$n "$name"}
    }
  }

  ### Called by comp.tcl and the AnalysisEngine toplevel

  proc uciConfigN {n parent} {
    global engines

    if {![string is integer -strict $n]} {
      return
    }
    set engineData [lindex $engines(list) $n]
    if {![lindex $engineData 7]} {
      tk_messageBox -title "Engine Error" -icon warning -type ok -message {Engine is not UCI} -parent $parent
      return
    }
    set name [lindex $engineData 0]
    set cmd  [lindex $engineData 1]
    set args [lindex $engineData 2]
    set dir  [lindex $engineData 3] 
    set options [lindex $engineData 8]
    ::uci::uciConfig $n $name [ toAbsPath $cmd ] $args [ toAbsPath $dir ] $options 
  }

  ### Open the pipe and issue 'uci'
  ### Pipe is read by readUCI, which then inits uciConfigWin after options have been read

  proc uciConfig { n name cmd arg dir options } {
    global ::uci::uciOptions ::uci::oldOptions

    set ::uci::name $name

    if {[info exists ::uci::uciInfo(pipe$n)]} {
      if {$::uci::uciInfo(pipe$n) != ""} {
        tk_messageBox -title "Scid" -icon warning -type ok -message "An engine is already running"
        return
      }
    }
    set oldOptions $options

    # If the analysis directory is not current dir, cd to it:
    set oldpwd ""
    if {$dir != "."} {
      set oldpwd [pwd]
      catch {cd $dir}
    }
    # Try to execute the analysis program:
    if {[catch {set pipe [open "| [list $cmd] $arg" "r+"]} result]} {
      if {$oldpwd != ""} { catch {cd $oldpwd} }
      if {[winfo exists .engineEdit]} {
        set parent .engineEdit
      } else {
        set parent .
      }
      tk_messageBox -title "Error starting UCI engine" \
          -icon warning -type ok -message "Unable to start program \n$cmd $arg" -parent $parent
      return
    }

    set ::uci::uciInfo(pipe$n) $pipe

    # Configure pipe for line buffering and non-blocking mode:
    fconfigure $pipe -buffering full -blocking 0
    fileevent $pipe readable "::uci::readUCI $n"

    # Return to original dir if necessary:
    if {$oldpwd != ""} { catch {cd $oldpwd} }

    set uciOptions {}

    puts $pipe "uci"
    flush $pipe

    # Give a few seconds for the engine to output its options, then automatically kill it
    # (to handle xboard engines)

    if {!$::windowsOS && ([string match {*wine*} $cmd] || [string match *.exe $cmd])} {
      # if program is using Wine , give it longer to start up
      after 10000  "::uci::closeUCIengine $n 0"
    } else {
      after 5000  "::uci::closeUCIengine $n 0"
    }
  }

  ### Only used by uciConfig to gather options info for uciConfigWin

  proc readUCI {n} {
    global ::uci::uciOptions

    set line [string trim [gets $::uci::uciInfo(pipe$n)] ]
    # end of options
    if {$line == "uciok"} {
      # we got all options
      # but keep engine open to process button events.
      # We'll stop engine when we close .uciConfigWin
      after cancel "::uci::closeUCIengine $n 0"
      uciConfigWin $n 
    }
    # get options
    if {[string match {option name *} $line]} {
      lappend uciOptions $line
    }
    # Can't use this, in case of testing the same engine against itself
    # if {[string match {id name *}     $line]} { set name [string range $line 8 end] }
  }

  ### Builds the dialog for UCI engine configuration 

  proc uciConfigWin {n} {
    global ::uci::uciOptions ::uci::optList ::uci::optionToken ::uci::oldOptions ::uci::optionImportant

    set w .uciConfigWin

    if { [winfo exists $w]} {
      return
    }

    toplevel $w

    wm state $w withdrawn
    setWinLocation $w
    setWinSize $w

    wm title $w "UCI Configure $::uci::name"

    pack [label $w.title -text $::uci::name] -side top -pady 5
    addHorizontalRule $w
    pack [frame $w.buttons] -side bottom 
    pack [frame $w.wtf] -side top -expand 1 -fill both

    ### Whoever wrote this gridded widget hierarchy 
    #   scrolledframe scrolledframe $w.sf (scrolledframe) .scrolledframe (later)
    # is an f-ing eediot. (But it's nicely functional otherwise :)


    if {$::windowsOS || $::macOS} {
      # needs testing
      bind $w <Shift-MouseWheel> {
	if {[expr -%D] < 0} {.uciConfigWin.wtf.sf xview scroll -1 units}
	if {[expr -%D] > 0} {.uciConfigWin.wtf.sf xview scroll +1 units}
      }
      bind $w <MouseWheel> {
	if {[expr -%D] < 0} {.uciConfigWin.wtf.sf yview scroll -1 units}
	if {[expr -%D] > 0} {.uciConfigWin.wtf.sf yview scroll +1 units}
      }
    } else {
	bind $w <Button-4> ".uciConfigWin.wtf.sf yview scroll -1 units"
	bind $w <Button-5> ".uciConfigWin.wtf.sf yview scroll +1 units"
    }

    ### Add an extra frame around the scrolledframe to allow the Save/Cancel buttons and Title label to pack outside

    set w $w.wtf

    ### Haha - this is how it's done
    # Make the scrolledframe widget use small fonts
    # option add *uciConfigWin*wtf*Font font_Small

    ::scrolledframe::scrolledframe $w.sf -xscrollcommand "$w.hs set" -yscrollcommand "$w.vs set" \
        -fill both -width 1000 -height 600
    scrollbar $w.vs -command "$w.sf yview" -width 12
    scrollbar $w.hs -command "$w.sf xview" -orient horizontal -width 12

    grid $w.sf -row 0 -column 0 -sticky nsew
    grid $w.vs -row 0 -column 1 -sticky ns
    grid $w.hs -row 1 -column 0 -sticky ew
    grid rowconfigure $w 0 -weight 1
    grid columnconfigure $w 0 -weight 1

    set w $w.sf.scrolled

    set optList ""
    array set elt {}
    foreach opt $uciOptions {
      foreach i {name type default min max var} {
        set elt($i) ""
      }
      set data [split $opt]

      ### todo - check these skipped options on some modern engines S.A.
      # skip options starting with UCI_ (except options in $::optionToKeep)
      # some engines like shredder use UCI_* options that should not be ignored

      set t [lindex $data 2]
      if { [lsearch $::uci::optionToKeep $t] == -1  && [string match UCI_* $t] } {
        continue
      }
      
      set length [llength $data]

      # parse one option
      for {set i 0} {$i < $length} {incr i} {
        set t [lindex $data $i]
        if {$t == "option"} { continue }
        if {$t == "name"} {
          incr i
          set elt(name) [ lindex $data $i ]
          incr i
          while { [ lsearch -exact $optionToken [ lindex $data $i ] ] == -1 && $i < $length } {
            append elt(name) " " [ lindex $data $i ]
            incr i
          }
          incr i -1
          continue
        }
        if {$t == "type"} { incr i ; set elt(type) [ lindex $data $i ] ; continue }
        if {$t == "default"} { ;# Glaurung uses a default value that is > one word
          incr i
          set elt(default) [ lindex $data $i ]
          incr i
          while { [ lsearch -exact $optionToken [ lindex $data $i ] ] == -1 && $i < $length } {
            append elt(default) " " [ lindex $data $i ]
            incr i
          }
          incr i -1
          continue
        }
        if {$t == "min"} { incr i ; set elt(min) [ lindex $data $i ] ; continue }
        if {$t == "max"} { incr i ; set elt(max) [ lindex $data $i ] ; continue }
        if {$t == "var"} {
          incr i
          set tmp [ lindex $data $i ]
          incr i
          while { ([ lsearch -exact $optionToken [ lindex $data $i ] ] == -1 && $i < $length ) \
                || [ lindex $data $i ] == "var" } {
            if {[ lindex $data $i ] != "var" } {
              append tmp " " [ lindex $data $i ]
            } else  {
              lappend elt(var) [list $tmp]
              incr i
              set tmp [ lindex $data $i ]
            }
            incr i
          }
          lappend elt(var) [list $tmp]
          
          incr i -1
          continue
        }
      }
      lappend optList [array get elt]
    }

    # sort list of options so that important ones come first
    set tmp $optList
    set optList {}
    foreach l $tmp {
      array set elt $l
      if { [ lsearch $optionImportant $elt(name) ] != -1 } {
        lappend optList $l
      }
    }
    foreach l $tmp {
      array set elt $l
      if { [ lsearch $optionImportant $elt(name) ] == -1 } {
        lappend optList $l
      }
    }

    set optnbr 0
    frame $w.fopt

    set row 0
    set col 0
    set isImportantParam 1
    foreach l $optList {
      array set elt $l
      set name $elt(name)
      if { [ lsearch $optionImportant $elt(name) ] == -1 && $isImportantParam } {
        set isImportantParam 0
        incr row
        set col 0
      }
      if {$elt(name) == "MultiPV"} { set name $::tr(MultiPV) }
      if {$elt(name) == "Hash"} { set name $::tr(Hash) }
      if {$elt(name) == "OwnBook"} { set name $::tr(OwnBook) }
      if {$elt(name) == "BookFile"} { set name $::tr(BookFile) }
      if {$elt(name) == "UCI_LimitStrength"} { set name $::tr(LimitELO) }
      
      if { $col > 3 } { set col 0 ; incr row}
      if {$elt(default) != ""} {
        set default "\n($elt(default))"
      } else  {
        set default ""
      }
      set value $elt(default)
      # find the name in oldOptions (the previously saved data)
      foreach old $oldOptions {
        if {[lindex $old 0] == $elt(name)} {
          set value [lindex $old 1]
          break
        }
      }
      if { $elt(type) == "check"} {
        checkbutton $w.fopt.opt$optnbr -text "$name$default" -onvalue true -offvalue false -variable ::uci::check($optnbr)
        if { $value == true } { $w.fopt.opt$optnbr select }
        if { $value == false } { $w.fopt.opt$optnbr deselect }
        grid $w.fopt.opt$optnbr -row $row -column $col -sticky w
      }
      if { $elt(type) == "spin"} {
        label $w.fopt.label$optnbr -text "$name$default"
        if { $elt(name) == "UCI_Elo" } {
          spinbox $w.fopt.opt$optnbr -from $elt(min) -to $elt(max) -width 5 -increment 50 -validate all -vcmd {string is int %P}
        } else  {
          spinbox $w.fopt.opt$optnbr -from $elt(min) -to $elt(max) -width 5 -validate all -vcmd {string is int %P}
        }
        $w.fopt.opt$optnbr set $value
        grid $w.fopt.label$optnbr -row $row -column $col -sticky e
        incr col
        grid $w.fopt.opt$optnbr -row $row -column $col -sticky w
      }
      if { $elt(type) == "combo"} {
        label $w.fopt.label$optnbr -text "$name$default"
	set idx 0
	set i 0
	set tmp {}
	foreach e $elt(var) {
	    lappend tmp [join $e]
	    if {[join $e] == $value} { set idx $i }
	    incr i
	}
	ttk::combobox $w.fopt.opt$optnbr -values $tmp

	$w.fopt.opt$optnbr current $idx
        grid $w.fopt.label$optnbr -row $row -column $col -sticky e
        incr col
        grid $w.fopt.opt$optnbr -row $row -column $col -sticky w
      }
      if { $elt(type) == "button"} {
        button $w.fopt.opt$optnbr -text "$name$default" \
          -command "::uci::sendToEngine $n \"setoption name $elt(name)\" "
        grid $w.fopt.opt$optnbr -row $row -column $col -sticky w
      }
      if { $elt(type) == "string"} {
        label $w.fopt.label$optnbr -text "$name$default"
        entry $w.fopt.opt$optnbr
        $w.fopt.opt$optnbr insert 0 $value
        grid $w.fopt.label$optnbr -row $row -column $col -sticky e
        incr col
        grid $w.fopt.opt$optnbr -row $row -column $col -sticky w
      }
      incr col
      incr optnbr
    }
    pack $w.fopt

    set w .uciConfigWin

    dialogbutton $w.buttons.save -text $::tr(Save) -command "
      ::uci::saveConfig $n
      destroy .uciConfigWin"

    dialogbutton $w.buttons.help -text $::tr(Help) -command {helpWindow Analysis UCI}
    dialogbutton $w.buttons.cancel -text $::tr(Cancel) -command {destroy .uciConfigWin}

    pack $w.buttons.save $w.buttons.help $w.buttons.cancel -side left -expand yes -fill both -padx 20 -pady 2

    # bind $w <Return> "$w.buttons.save invoke"

    bind $w <Destroy>   "bind $w <Destroy> {} ; ::uci::closeUCIengine $n 1"
    bind $w <Escape>    {destroy .uciConfigWin}
    bind $w <Configure> "recordWinSize $w"
    bind $w <F1> {helpWindow Analysis UCI}

    update
    wm state $w normal
  }

  ### UCI configuration (uciConfigWin) is finished
  ### Generate a list of list {{name}/value} pairs and save the new ::engines(list) to file engines.dat

  proc saveConfig {n} {
    global ::uci::optList ::uci::newOptions

    set newOptions {}
    set w .uciConfigWin.wtf.sf.scrolled
    set optnbr 0

    foreach l $optList {
      array set elt $l
      set value ""
      if { $elt(type) == "check"} {
        set value $::uci::check($optnbr)
      }
      if { $elt(type) == "spin" || $elt(type) == "combo" || $elt(type) == "string" } {
        set value [$w.fopt.opt$optnbr get]
      }
      # Buttons are now handled properly in uciConfigWin
      if { $elt(type) != "button" } { 
	lappend newOptions [ list $elt(name)  $value ]
      }
      incr optnbr
    }

    # Make engine config widget remember these options
    set ::engines(newUCIoptions) $::uci::newOptions

    if {$n != -1} {
      ### Automatically save these options since "Save" has been pressed
      ### Previously it was only done when user "OK"ed the parent widget, or via sergame.tcl

      set enginedata [lindex $::engines(list) $n]
      set enginedata [lreplace $enginedata 8 8 $::uci::newOptions]
      set ::engines(list) [lreplace $::engines(list) $n $n $enginedata]

      ::enginelist::write
    }
}


  ### The engine replied readyok, so it's time to configure it (sends the options to the engine)
  ### It seems necessary to ask first if engine is ready

  proc sendUCIoptions {n {sergame 0}} {
    global analysis
    set engineData [ lindex $::engines(list) $n ]
    set options [ lindex $engineData 8 ]
    foreach opt $options {
      set name [lindex $opt 0]
      set value [lindex $opt 1]
      set analysis(waitForReadyOk$n) 1
      ::sendToEngine $n "isready"
      vwait analysis(waitForReadyOk$n)
      ::sendToEngine $n "setoption name $name value $value"
      if {$name == {Skill Level} && $sergame} {
        set ::uci::uciInfo(skill) $value
      }
    }
  }

  ### Start an engine silently (for playing, not analysis)
  ### Called by calvar.tcl sergame.tcl tactics.tcl and tacgame.tcl
  ### Logging not currently used.

  proc startEngine {n} {

    global ::uci::uciInfo analysis

    resetUciInfo $n
    resetUciInfo2 $n
    set uciInfo(pipe$n) ""
    set uciInfo(seen$n) 0
    set uciInfo(uciok$n) 0
    ::resetEngine $n
    set engineData [lindex $::engines(list) $n]
    set analysisName [lindex $engineData 0]
    set analysisCommand [ toAbsPath [lindex $engineData 1] ]
    set analysisArgs [lindex $engineData 2]
    set analysisDir [ toAbsPath [lindex $engineData 3] ]

    if {$::macApp && [file pathtype $analysisCommand] != "absolute"} {
      # Maybe if they put a full path in the config they knew what they wanted?
      # Otherwise, look in the analysisDir. - dr
      set analysisCommand [file join $analysisDir $analysisCommand]
    }

    # If the analysis directory is not current dir, cd to it:
    set oldpwd ""
    if {$analysisDir != "."} {
      set oldpwd [pwd]
      catch {cd $analysisDir}
    }

    # Try to execute the analysis program:
    if {[catch {set uciInfo(pipe$n) [open "| [list $analysisCommand] $analysisArgs" "r+"]} result]} {
      if {$oldpwd != ""} { catch {cd $oldpwd} }
      tk_messageBox -title "Error starting engine" -icon warning -type ok \
          -message "Unable to start the program:\n$analysisCommand:\n$result"
      return
    }

    set analysis(pipe$n) $uciInfo(pipe$n)

    # Return to original dir if necessary:
    if {$oldpwd != ""} { catch {cd $oldpwd} }

    fconfigure $uciInfo(pipe$n) -buffering line -blocking 0
    fileevent $uciInfo(pipe$n) readable "::uci::processAnalysisInput $n 0"

    # wait a few seconds to be sure the engine had time to start
    set counter 0
    while {! $::uci::uciInfo(uciok$n) && $counter < 50 } {
      incr counter
      update
      after 100
    }
  }

  ### ::uci::sendToEngine
  ### Called by calvar.tcl sergame.tcl tactics.tcl and tacgame.tcl
  ### ::sendToEngine is used by all windowed engines.

  proc sendToEngine {n text} {

    ### No log file initialised here, so no point going to logEngine
    # logEngine $n "Scid  : $text"
    catch {puts $::uci::uciInfo(pipe$n) $text}
  }

  ### Returns 0 if engine died abruptly or 1 otherwise
  # only used for non-gui (uci) engines

  proc checkEngineIsAlive {n} {

    global ::uci::uciInfo errorCode

    if {![eof $uciInfo(pipe$n)]} {
      return 1
    }

    fileevent $uciInfo(pipe$n) readable {}

    set exit_status 0
    if {[catch {close $uciInfo(pipe$n)}  standard_error] != 0} {
      if {[lindex $errorCode 0] == "CHILDSTATUS"} {
	  set exit_status [lindex $errorCode 2]
      }
    }

    set uciInfo(pipe$n) ""

    if { $exit_status != 0 } {
	# logEngineNote $n {Engine terminated with exit code $exit_status: "\"$standard_error\""}
	tk_messageBox -type ok -icon info -parent . -title "Scid" \
		      -message "The uci engine terminated with exit code $exit_status: \"$standard_error\""
    } else {
	# logEngineNote $n {Engine terminated without exit code: "\"$standard_error\""}
	tk_messageBox -type ok -icon info -parent . -title "Scid" \
		      -message "The uci engine terminated without exit code: \"$standard_error\""
    }
    return 0
  }
  ################################################################################
  # close the engine
  # It may be not an UCI one (if the user made an error, trying to configure an xboard engine)
  ################################################################################
  proc closeUCIengine { n { uciok 1 } } {
    global windowsOS ::uci::uciInfo

    set pipe $uciInfo(pipe$n)
    # Check the pipe is not already closed:
    if {$pipe == ""} { return }

    fileevent $pipe readable {}

    if {! $uciok } {
      set parent .
      foreach pparent {.configSerGameWin .engineEdit} {
	if {[winfo exists $pparent]} {
	  set parent $pparent
	}
      }
      tk_messageBox -title "Engine Error" -icon warning -type ok \
                    -message "File not executable,\nor not an UCI engine." -parent $parent
    }

    # Some engines in analyze(gui?) mode may not react as expected to "quit"
    # so ensure the engine exits analyze mode first:
    catch { puts $pipe "stop" ; puts $pipe "quit" }
    #in case an xboard engine
    catch { puts $pipe "exit" ; puts $pipe "quit" }

    # last resort : try to kill the engine (TODO if Windows : no luck, welcome zombies !)
    # No longer try to kill the engine as :
    # - it does not work on Windows
    # - Rybka MP uses processes instead of threads : killing the main process will leave the children processes running
    # - engines should normally exit
    # if { ! $windowsOS } { catch { exec -- kill -s INT [ pid $pipe ] }  }
        
    catch { flush $pipe }
    catch { close $pipe }
    set uciInfo(pipe$n) ""
  }

  ### UCI moves use long notation
  ### returns 1 if an error occured when entering a move
  # This procedure was previously ::uci::sc_move_add, and is now done in tkscid

  proc addUCIMoves { moves } {

    return [ catch { sc_move addUCI $moves } ]

  }

  ################################################################################
  #make UCI output more readable (b1c3 -> Nc3)
  ################################################################################

  # uci.tcl calls this for "none". calvar.tcl cals this for "$fen" or ""

  proc formatPv {n moves {fen none}} {
    global analysis

    if {$analysis(lockEngine$n) } {
      set fen $analysis(lockFen$n)
    } else {
      if {$fen == "none"} {
	# costs around 5 microseconds
	set fen [sc_pos fen]
      }
    }

    # Push a temporary copy of the current game:
    if {$fen == ""} {
      sc_game push copyfast
    } else  {
      sc_game push
      sc_game startBoard $fen
    }

    catch {sc_move addUCI $moves} tmp
    set tmp [string trim $tmp]

    # Pop the temporary game:
    sc_game pop

    return $tmp
  }

  ### Format a line starting at current position where <moves> were played (in San notation)
  ### only used by calvar.tcl

  proc formatPvAfterMoves { played_moves moves } {
      sc_game push copyfast
      sc_move addSan $played_moves
      
      catch {sc_move addUCI $moves} tmp
      set tmp [string trim $tmp]
      
      # Pop the temporary game:
      sc_game pop
      
      return $tmp
  }

}
###
### End of file: uci.tcl
###
