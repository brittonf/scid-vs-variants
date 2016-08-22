###
### search.tcl: Search routines for Scid.
###

namespace eval ::search {}

# 'Header' or 'Material' in a SearchOptions file (.sso)
# (Can't save a Board search)
set searchType 0

# How search affects the filter
# Can be   0 (And)   1 (Or)   2 (Ignore/Reset) which is the default
set ::search::filter::operation 2

# TODO: Rename to ::search::filter::text
# filterText: returns text describing state of filter for specified
#   database, e.g. "no games" or "all / 400" or "1,043 / 2,057"

proc filterText {{base 0} {kilo 0}} {
  # Default to current base if no base specified:
  if {$base == 0} { set base [sc_base current] }
  set filterCount [sc_filter count $base]
  set gameCount [sc_base numGames $base]
  if {$gameCount == 0} { return $::tr(noGames) }
  if {$gameCount == $filterCount} {
    return "$::tr(all) / [::utils::thousands $gameCount $kilo]"
  }
  return "[::utils::thousands $filterCount $kilo] / [::utils::thousands $gameCount $kilo]"
}


proc ::search::filter::reset {{base {}}} {
  if {$base == {}} {set base [sc_base current]}

  sc_filter reset $base

  if {$base == [sc_base current]} { 
    set ::glstart 1
  } else {
    set ::glistStart($base) 1
  }
  ::windows::gamelist::Refresh
  ::windows::stats::Refresh
  updateMenuStates
}

### Negate filter

proc ::search::filter::negate {{base {}}} {
  set currentBaseNum [sc_base current]
  if {$base == {} || $base == $currentBaseNum} {
    sc_filter negate
    set glstart 1
  } else {
    sc_base switch $base
    sc_filter negate
    set ::glistStart($base) 1
    sc_base switch $currentBaseNum
  }

  ::windows::gamelist::Refresh
  ::windows::stats::Refresh
  updateMenuStates
}

#  Sets all filter games to end (move 255)
#  and move current game to end

proc ::search::filter::end {} {
  global glstart
  sc_filter end
  ::move::End
  ::windows::gamelist::Refresh
  ::windows::stats::Refresh
  updateMenuStates
}



# Add a frame of radiobuttons to specify which filter operation to perform with search
#
# The variable ::search::filter::operation is shared between the three search widgets
# (but there should be different variables, to avoid interaction)
# and can be  0 (And), 1 (Or), 2 (Ignore/Reset) which is the default

proc ::search::addFilterOpFrame {w {small 0}} {
  set f $w.filterop

  frame $f
  pack  $f -side top
  if {$small} {
    set regular font_Small
    set bold    font_SmallBold
  } else {
    set regular font_Regular
    set bold    font_Bold
  }

  label $f.title -font $bold -textvar ::tr(FilterOperation)
  radiobutton $f.and -textvar ::tr(FilterAnd) -variable ::search::filter::operation \
    -value 0 -pady 5 -padx 5 -font $regular
  radiobutton $f.or -textvar ::tr(FilterOr) -variable ::search::filter::operation \
    -value 1 -pady 5 -padx 5 -font $regular
  radiobutton $f.ignore -textvar ::tr(FilterIgnore) -variable ::search::filter::operation \
    -value 2 -pady 5 -padx 5 -font $regular

  pack $f.title -side top
  pack $f.ignore $f.and $f.or -side left
}


# ::search::Config
#
#   Sets state of Search button in Header, Board and Material windows

proc ::search::Config {{state ""}} {
  if {$state == ""} {
    if {[sc_base inUse]} {
      set state normal
    } else {
      set state disabled
    }
  }
  catch {.sh.b.search configure -state $state }
  catch {.sb.b.search configure -state $state }
  catch {.sm.b3.search configure -state $state }
}


proc ::search::usefile {} {
  set ftype { { "Scid SearchOption files" {".sso"} } }
  if {! [file isdirectory $::initialDir(sso)] } {
    set ::initialDir(sso) $::env(HOME)
  } 
  set ::fName [tk_getOpenFile -initialdir $::initialDir(sso) \
                 -filetypes $ftype -title "Select a SearchOptions file"]
  if {$::fName == ""} { return }
  set ::initialDir(sso) [file dirname $::fName]

  if {[catch {uplevel "#0" {source $::fName} } ]} {
    tk_messageBox -title "Scid: Error reading file" -type ok -icon warning \
                -message "Unable to open or read SearchOptions file: $fName"
  } else {
    switch -- $::searchType {
      "Material" { ::search::material }
      "Header"   { ::search::header }
      default    { return }
    }
  }
}

proc ::search::loadFirstGame {} {
    ## Used to not load if the Tree of current base is opened "(of there will be filter collision)"
    ## but probably not necessary now tree is unlocked.
    # set w ".treeWin[sc_base current]" ; if {[winfo exists $w]} { return }    
    ::game::Load [sc_filter first]
}
