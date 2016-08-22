###
### wbdetect.tcl: part of Scid.
### Hacks to configure xboard engines not supporting "protover 2"

### This code should probably be removed as (currently) it is called
### every time an unhandled line is processed by ::processAnalysisInput
### (But unsure if Crafty's hacks can be removed) S.A.

### Copyright (C) 1999-2002  Shane Hudson.
### Copyright (C) 2006-2007  Pascal Georges.

# Code to detect various Winboard engines being used as analysis
# engines in Scid.
#
# Thanks to Allen Lake for testing many WinBoard engines
# with Scid in Windows and providing this code.
#
# Most cases below are for engines that have analyze mode but
# do not let Scid know about it by sending a "feature" line
# with "analyze=1" in response to the "protover 2" command.
# Some cases also cover engines that report times in seconds
# instead of centiseconds.

proc detectWBEngine {n engineOutput} {

  global analysis

  # Check for a line starting with "Crafty", so Scid can work well
  # with older Crafty versions that do not recognize "protover"

  if {[string match {*Crafty*} $engineOutput]} {
    # Engine: Crafty v23.4 JA (1 cpus)
    # Engine: feature myname="Crafty-23.4 JA" name=1

    logEngineNote $n {Seen "Crafty"; assuming analyze and setboard commands.}
    if {[scan $engineOutput "Crafty v%d.%d" major minor] == 2} {
      logEngineNote $n "Crafty version $major.$minor"
      if { $major >= 18} {
	logEngineNote $n {which is >= 18.0; Assuming scores are from White perspective.}
        # Note: if comp(playing) this single line is not getting set, but is is also not getting used S.A
	set analysis(invertScore$n) 0
      }
    }
    sendToEngine $n {log off} ; # turn off crafty logging to reduce number of junk files:
    # Set a fairly low noise value so Crafty is responsive to board changes,
    # but not so low that we get lots of short-ply search data:
    # "noise 0" "will produce output starting with iteration 1"
    sendToEngine $n {noise 1000}
    sendToEngine $n {egtb off} ; # turn off end game table book
    sendToEngine $n {resign 0} ; # turn off alarm (resigning ?)
    set analysis(isCrafty$n) 1
    set analysis(has_setboard$n) 1
    set analysis(has_analyze$n) 1
    set analysis(wbEngineDetected$n) 1
    return
  }

  # Amy 0.7 Winboard engine, doesn't support "setboard" command, but does support "analyze" 
  if {[string match "*Amy version*" $engineOutput] } {
    logEngineNote $n {Seen "Amy"; assuming analyze command.}
    set analysis(has_analyze$n) 1
    set analysis(wbEngineDetected$n) 1
    return
  }

  # Baron 0.26, 0.26a, 0.27, or 0.28a Winboard engines.  These
  # engines display analysis time in whole seconds, rather than
  # in centiseconds, so I have added code to detect this.
  if {[string match "*Baron*" $engineOutput] } {
    logEngineNote $n {Seen "Baron"; assuming analyze, setboard, times in seconds.}
    set analysis(has_setboard$n) 1
    set analysis(has_analyze$n) 1
    set analysis(wholeSeconds$n) 1
    set analysis(wbEngineDetected$n) 1
    return
  }

  # Duke 1.0 or 1.1 Winboard engines, don't support "setboard" command, but do support "analyze" 
  if {[string match "*D U K E*" $engineOutput] } {
    logEngineNote $n {Seen "Duke"; assuming analyze command.}
    set analysis(has_analyze$n) 1
    set analysis(wbEngineDetected$n) 1
    return
  }

  # Check for a line containing "ESCbook.bin" to detect 
  # Esc 1.09 Winboard engine, which doesn't support the "setboard" command, but does support the "analyze" command.
  if {[string match "*ESCbook.bin*" $engineOutput] } {
    logEngineNote $n {Seen "ESC"; assuming analyze command.}
    set analysis(has_analyze$n) 1
    set analysis(wbEngineDetected$n) 1
    return
  }

  # Fortress 1.62 Winboard engine, doesn't support "setboard" , but does support "analyze"
  if {[string match "*FORTRESS*" $engineOutput] } {
    logEngineNote $n {Seen "Fortress"; assuming analyze command.}
    set analysis(has_analyze$n) 1
    set analysis(wbEngineDetected$n) 1
    return
  }

  # Check for a line containing only "Chess", to detect the use of
  # GNU Chess 4, which issues time in whole seconds rather than in
  # centiseconds.
  #if {! [string compare $engineOutput "Chess"]} {
  #  logEngineNote $n {Seen "GNU Chess 4"; assuming times in seconds.}
  #  set analysis(wholeSeconds$n) 1
  #  set analysis(wbEngineDetected$n) 1
  #  return
  #}

  # GNU Chess 5.02 or 5.03 Winboard engine don't support "analyze" command, but do support "setboard".
  if {[string match "*GNU Chess v5*" $engineOutput] } {
    logEngineNote $n {Seen "GNU Chess 5"; assuming setboard command.}
    set analysis(has_setboard$n) 1
    set analysis(wbEngineDetected$n) 1
    return
  }

  # Gromit 3.00 or Gromit 3.8.2 Winboard engine, don't support "setboard" , but do support "analyze"
  if {[string match "*Gromit3*" $engineOutput]  ||  [string match "GROMIT" $engineOutput]} {
    logEngineNote $n {Seen "Gromit"; assuming analyze command.}
    set analysis(has_analyze$n) 1
    set analysis(wbEngineDetected$n) 1
    return
  }

  # Jester 0.82 Winboard engine.  This engine supports "analyze", but doesn't support "setboard" or "protover".
  if {[string match "*Jester*" $engineOutput] } {
    logEngineNote $n {Seen "Jester"; assuming analyze command.}
    set analysis(has_analyze$n) 1
    set analysis(wbEngineDetected$n) 1
    return
  }

  # Leila 0.36 or Leila 0.41i don't support "setboard" , but do support "analyze"
  if {[string match "*Calzerano*" $engineOutput] } {
    logEngineNote $n {Seen "Calzerano" (Leila); assuming analyze command.}
    set analysis(has_analyze$n) 1
    set analysis(wbEngineDetected$n) 1
    return
  }

  # LordKing 3.0, 3.1, or 3.2 have "analyze", but not "setboard" or "protover".
  if {[string match "*LordKing*" $engineOutput] } {
    logEngineNote $n {Seen "LordKing"; assuming analyze command.}
    set analysis(has_analyze$n) 1
    set analysis(wbEngineDetected$n) 1
    return
  }

  # Nejmet 2.6.0 supports "setboard"  and "analyze", but not "protover".
  if {[string match "*NEJMET*" $engineOutput] } {
    logEngineNote $n {Seen "Nejmet"; assuming analyze and setboard commands.}
    set analysis(has_setboard$n) 1
    set analysis(has_analyze$n) 1
    set analysis(wbEngineDetected$n) 1
    return
  }

  # Nejmet 3.0.1 and 3.0.2 which sends "feature analyse=1" instead of "feature analyze=1".
  if {[string match "*Nejmet*" $engineOutput] } {
    logEngineNote $n {Seen "Nejmet"; assuming analyze and setboard commands.}
    set analysis(has_setboard$n) 1
    set analysis(has_analyze$n) 1
    set analysis(wbEngineDetected$n) 1
    return
  }

  # Pharaon 2.50 or Pharaon 2.61 display analysis time in whole seconds, rather than centiseconds
  # Performance of these engines has been somewhat uneven, with
  # occasional crashes of the engine, but more stable and predictable with this code in place.
  if {[string match "*Pharaon*" $engineOutput] } {
    logEngineNote $n {Seen "Pharaon"; assuming analyze, setboard, times in seconds.}
    set analysis(has_setboard$n) 1
    set analysis(has_analyze$n) 1
    set analysis(wholeSeconds$n) 1
    set analysis(wbEngineDetected$n) 1
    return
  }

  # Skaki 1.19 has "analyze", but not "setboard" or "protover".
  if {[string match "*Skaki*" $engineOutput] } {
    logEngineNote $n {Seen "Skaki"; assuming analyze command.}
    set analysis(has_analyze$n) 1
    set analysis(wbEngineDetected$n) 1
    return
  }

  # TCB 0045 has "analyze", but not "setboard" or "protover".
  if {[string match "*EngineControl-TCB*" $engineOutput] } {
    logEngineNote $n {Seen "TCB"; assuming analyze and setboard commands.}
    set analysis(has_analyze$n) 1
    set analysis(wbEngineDetected$n) 1
    return
  }

  # ZChess 2.22.  ZChess is the predecessor of the Pharaon engines and, as such,
  # displays analysis time in whole seconds, rather than in centiseconds.
  if {[string match "*ZChess*" $engineOutput] } {
    logEngineNote $n {Seen "ZChess"; assuming analyze, setboard, times in seconds.}
    set analysis(has_analyze$n) 1
    set analysis(wholeSeconds$n) 1
    set analysis(wbEngineDetected$n) 1
    return
  }

  # King of Kings 2.02 uses the "protover" command, but seems to confuse previous code on
  # Win98SE. Setting analysis(has_setboard$n) and analysis(has_analyze$n) explicitly seems to help.
  if {[string match "*King of Kings*" $engineOutput] } {
    logEngineNote $n {Seen "King of Kings"; assuming analyze and setboard commands.}
    set analysis(has_setboard$n) 1
    set analysis(has_analyze$n) 1
    set analysis(wbEngineDetected$n) 1
    return
  }

  # EXchess 4.02 or 4.03 supports "setboard" and "analyze", but not "protover".
  if {[string match "*EXchess*" $engineOutput] } {
    logEngineNote $n {Seen "EXchess"; assuming analyze and setboard commands.}
    set analysis(has_setboard$n) 1
    set analysis(has_analyze$n) 1
    set analysis(wbEngineDetected$n) 1
    return
  }

  # WildCat 2.61 supports "analyze" but not "setboard" or "protover".
  if {[string match "*WildCat version 2.61*" $engineOutput] } {
    logEngineNote $n {Seen "WildCat 2.61"; assuming analyze and setboard commands.}
    set analysis(has_analyze$n) 1
    set analysis(wbEngineDetected$n) 1
    return
  }


  # Phalanx supports "analyze"
  # Older versions did not support "protover" or "setboard", but it now does S.A.
  # (feature myname="Phalanx XXIII" analyze=1 setboard=1 sigint=1 time=1 draw=0)
  if {[string match "*Phalanx*" $engineOutput] } {
    logEngineNote $n {Seen "Phalanx"; assuming analyze command.}
    set analysis(has_analyze$n) 1
    set analysis(wbEngineDetected$n) 1
    set analysis(has_setboard$n) 1
    return
  }

  # Scorpio supports "analyze" and "setboard".
  # some engines report feature 'egt="scorpio"'
  if {[string match "*Scorpio*" $engineOutput] } {
    logEngineNote $n {Seen "Scorpio"; assuming analyze command.}
    set analysis(has_analyze$n) 1
    set analysis(wbEngineDetected$n) 1
    return
  }

}

###
### End of file: wbdetect.tcl
###
