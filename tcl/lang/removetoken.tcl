#!/bin/sh
# The next line restarts using tkscid: \
exec tclsh "$0" "$@"

###
### removetoken.tcl
###

# (C) Pascal Georges 2007
#
# Will remove a line containing the token in argument
# NB - must be manually removed from english.tcl first.

array set encodings {
  czech iso8859-2
  deutsch iso8859-1
  francais iso8859-1
  hungary iso8859-2
  italian utf-8
  nederlan iso8859-1
  norsk iso8859-1
  polish utf-8
  portbr iso8859-1
  port iso8859-1
  russian utf-8
  serbian iso8859-2
  spanish iso8859-1
  swedish iso8859-1
  greek   utf-8
}

set languages {czech deutsch francais hungary italian nederlan norsk polish
  portbr port russian spanish swedish greek serbian
}

################################################################################
proc remove {langfile enc token} {
  # Read the language file

  set f [open $langfile.tcl r]
  fconfigure $f -encoding $enc
  set data [read $f]
  close $f
  set langData [split $data "\n"]

  if {[lindex $langData end] == ""} {
    set langData [lrange $langData 0 end-1]
  }

  set fnew [open $langfile.tcl.new w]
  fconfigure $fnew -encoding $enc

  foreach line $langData {
    set fields [split $line]
    set command [lindex $fields 0]
    set lang [lindex $fields 1]
    set name [lindex $fields 2]
    if {$name != $token} {
      puts $fnew $line
    }
  }
  close $fnew
}
################################################################################

set token $argv
if {$token == "" || [llength $token] > 1} {
  puts "usage: removetoken.tcl ARG"
} else {
  foreach language $languages {
    remove $language $encodings($language) $token
  }
}

# end of file
