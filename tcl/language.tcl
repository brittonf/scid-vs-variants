### lang.tcl: Support for multiple-language menus, buttons, etc.
### Part of Scid, which is Copyright 2001-2003 Shane Hudson.

array set langEncoding {}
set languages {}

if {[catch {encoding names}]} {
  set hasEncoding 0
} else {
  set hasEncoding 1
}
################################################################################
#  Translation of pieces
#  Note - also change tkscid.cpp and game.cpp
#  Note - not all languages have piece translation 
################################################################################
array set transPieces {}

set   transPieces(F) { P P K R Q D R T B F N C }
set untransPieces(F) { P P R K D Q T R F B C N }
set   transPieces(S) { P P K R Q D R T B A N C }
set untransPieces(S) { P P R K D Q T R A B C N }
set   transPieces(D) { P B K K Q D R T B L N S }
set untransPieces(D) { B P K K D Q T R L B S N }
set   transPieces(I) { P P K R Q D R T B A N C }
set untransPieces(I) { P P R K D Q T R A B C N }
set   transPieces(N) { P p K K Q D R T B L N P }
set untransPieces(N) { p P K K D Q T R L B P N }
set   transPieces(C) { P P K K Q D R V B S N J }
set untransPieces(C) { P P K K D Q V R S B J N }
set   transPieces(H) { P G K K Q V R B B F N H }
set untransPieces(H) { G P K K V Q B R F B H N }
set   transPieces(O) { P B K K Q D R T B L N S }
set untransPieces(O) { B P K K D Q T R L B S N }
set   transPieces(W) { P B K K Q D R T B L N S }
set untransPieces(W) { B P K K D Q T R L B S N }
set   transPieces(G) { P S K P Q B R [ B A N I }
set untransPieces(G) { S P P K B Q [ R A B I N }

################################################################################
proc trans { msg } {
  if { $::language == "E" || ! $::translatePieces || $msg == "\[end\]"} {
    return $msg
  }
  if { [ catch { set t [string map $::transPieces($::language) $msg ]} ] } {
    return $msg
  }
  return $t
}
################################################################################
proc untrans { msg } {
  if { $::language == "E"  || ! $::translatePieces || $msg == "\[end\]"} {
    return $msg
  }
  if { [ catch { set t [string map $::untransPieces($::language) $msg ]} ] } {
    return $msg
  }
  return $t
}
################################################################################
#
################################################################################

### Now unused
### Languages are now sourced from menus.tcl -> initLanguageMenus

proc addLanguage {letter name underline {encodingSystem ""}} {
  return
}

# lang filename menuname underline encoding sc_info_lang
array set langTable {
  C {czech    Czech      0 iso8859-2 cz}
  D {deutsch  Deutsch    0 iso8859-1 de}
  F {francais Francais   0 iso8859-1 fr}
  G {greek    Greek      0 utf-8     gr}
  H {hungary  Hungarian  0 iso8859-2 hu}
  I {italian  Italian    0 utf-8     it}
  N {nederlan Nederlands 0 iso8859-1 ne}
  O {norsk    Norsk      1 iso8859-1 no}
  P {polish   Polish     0 utf-8     {}}
  B {portbr   {Brazil Portuguese} 0 iso8859-1 {}}
  U {port     Portuguese 0 iso8859-1 {}}
  R {russian  Russian    0 utf-8     {}}
  Y {serbian  Serbian    2 iso8859-2 {}}
  S {spanish  Español    1 iso8859-1 es}
  W {swedish  Swedish    1 iso8859-1 sw}
}

proc initLanguageMenus {} {
  global langEncoding languages langTable

  # English 
  .menu.options.language add radiobutton -label English \
    -underline 0 -variable language -value E -command setLanguage
  set langEncoding(E) utf-8

  set dir [file nativename [file join $::scidShareDir lang]]

  set l {}
  foreach {m n} [array get langTable] {
    lappend l [list $m [lindex $n 1] $m]
  }
  foreach j [lsort -index 1 $l] {
    set i [lindex $j 0]
    if {[file exists [file nativename [file join $dir [lindex $langTable($i) 0].tcl]]]} {
      .menu.options.language add radiobutton -label [lindex $langTable($i) 1] \
	-underline [lindex $langTable($i) 2] -variable language -value $i -command setLanguage
    }
  }
}

### Assigns the menu name and help message for a menu entry and language.

proc menuText {args} {
  global hasEncoding langEncoding

  lassign $args lang tag label underline helpMsg
  if {![string is integer -strict $underline]} {
    tk_messageBox -icon error -type ok -title "$::scidName Menu Error" \
      -message "menuText $args\n\nNot enough args, or fourth arg is not an integer."
    exit
  }

  set ::menuLabel($lang,$tag) $label
  set ::menuUnder($lang,$tag) $underline
  if {$helpMsg != ""} {
    set ::helpMessage($lang,$tag) $helpMsg
  }
}

array set tr {}
array set translations {}
################################################################################
# translate:
#    Assigns a translation for future reference.
################################################################################
proc translate {lang tag label} {
  regsub {\\n} $label "\n" label
  set ::translations($lang,$tag) $label
  set ::tr($tag) $label
  foreach extra {":" "..."} {
    set newtag "${tag}${extra}"
    set newlabel "${label}${extra}"
    set ::translations($lang,$newtag) $newlabel
    set ::tr($newtag) $newlabel
  }
}
################################################################################
# translateECO:
#    Given a pair list of ECO opening name phrase translations,
#    assigns the translations for future reference.
################################################################################
proc translateECO {lang pairList} {
  foreach {from to} $pairList {
    sc_eco translate $lang $from $to
  }
}
################################################################################
# tr:
#    Given a tag and language, returns the stored text for that tag.
################################################################################
proc tr {tag {lang ""}} {
  global menuLabel tr
  if {$lang == ""} {set lang $::language}
  if {$lang == "X"} {return $tag}
  # First, look for a menu label
  if {[info exists menuLabel($lang,$tag)]} {
    return $menuLabel($lang,$tag)
  }
  if {[info exists menuLabel(E,$tag)]} {
    return $menuLabel(E,$tag)
  }
  # Now look for a regular button/message translation
  if {[info exists tr($tag)]} {
    return $tr($tag)
  }
  # Finally, just give up and return the original tag
  return $tag
}
################################################################################
#
################################################################################
proc setLanguage {{lang ""}} {
  global menuLabel menuUnder oldLang hasEncoding langEncoding langTable

  if {$lang == ""} {
    set lang $::language
  } else {
    set ::language $lang
  }

  if {$lang == "E"} {
      sc_info language en
  } else {
    ### Source language if necessary
    ### (langEncoding doubles as a way to know if we have inited language yet)
    if {![info exists langEncoding($lang)]} {
      set langEncoding($lang) [lindex $langTable($lang) 3]
      set filename [file nativename [file join $::scidShareDir "lang/[lindex $langTable($lang) 0].tcl"]]
      if {$langEncoding($lang) == "utf-8"} {
	source -encoding utf-8 $filename
      } else {
	source $filename
        ### Hmmm. This is probably better, but is untested
	# source -encoding $langEncoding($lang) $filename
      }
    }

    if { $::translatePieces } {
      set info [lindex $langTable($lang) 4]
      if {$info == {}} {
	sc_info language en
      } else {
	sc_info language $info
      }
    }
  }
  if {[catch {setLanguage_$lang} err]} {
    puts "setLanguage_$lang error: $err"
  }

  # TODO: Check this !
  if {$hasEncoding  && $langEncoding($lang) != ""} {
    # encoding system $langEncoding($lang)
  }

  # If using Tk, translate all menus:
  if {! [catch {winfo exists .}]} {
    setLanguageMenus $lang
    if {[winfo exists .glistWin]} {
      ::windows::gamelist::setColumnTitles
    }
  }

  foreach i [array names ::tr] {
    if {[info exists ::translations($lang,$i)]} {
      set ::tr($i) $::translations($lang,$i)
    } elseif {[info exists ::translations(E,$i)]} {
      set ::tr($i) $::translations(E,$i)
    }
  }
  set oldLang $lang
}

################################################################################
# Will switch language only for Scid backoffice, no UI
# Used to make callbacks use english by default
################################################################################
proc setLanguageTemp { lang } {

  if {$lang == "E"} {
      sc_info language en
  } else {
    set info [lindex $::langTable($lang) 4]
    if {$info == {}} {
      sc_info language en
    } else {
      sc_info language $info
    }
  }
}

### End of file: lang.tcl

