########################################
### utils/font.tcl: part of Scid.
#
# The following procs implement a font selection dialog. I found the code
# at codearchive.com (I dont think there was an author listed for it) and
# simplified it for use with Scid.

# God f-ing knows what's happening here really S.A
# Tcl sucks so bad when design is bad. Scid's font feature is powerful... but hard to follow

### FontDialog:

# Creates a font dialog to select a font.
# Returns 1 if user chose a font, 0 otherwise.
# (Returns ... something S.A)
# Naming everything $fr sucks (fixed)
# Grid fatality head shot too. Actually, it's nice now that it resizes properly.

### Default fonts are defined in start.tcl
# There's still a minor bug:
# Set Regular font to italic -> quit Scid & restart -> bold font no longer italic

proc FontDialog {name {parent .}} {
  global fd_family fd_style fd_size fd_close
  global fd_strikeout fd_underline fontOptions

  set w .fontdialog
  if {[winfo exists $w]} { destroy $w }

  set options $fontOptions($name)
  set fixedOnly [expr {$name == "Fixed"}]
  set font_name font_$name

  set fd_family {}
  set fd_style {}
  set fd_size {}
  set fd_close  -1

  set unsorted_fam [font families]
  set families [lsort $unsorted_fam]
  if {$fixedOnly} {
    set fams $families
    set families {}
    foreach f $fams {
      if {[font metrics [list $f] -fixed] == 1} { lappend families $f }
    }
  }

  # Get current font's family and so on.
  if {[llength $options] == 4} {
    # Use provided font settings:
    set family [lindex $options 0]
    set size   [lindex $options 1]
    set weight [lindex $options 2]
    set slant  [lindex $options 3]
  } else {
    # Get options using [font actual]:
    set family [font actual $font_name -family]
    set size   [font actual $font_name -size]
    set weight [font actual $font_name -weight]
    set slant  [font actual $font_name -slant]
  }

  # Default style
  set fd_style Regular
  if { $slant == "italic" } {
    if { $weight == "bold" } {
      set fd_style {Bold Italic}
    } else {
      set fd_style Italic
    }
  } else {
    if { $weight == "bold" } {
      set fd_style Bold
    }
  }

  set fd_family $family
  set fd_size   $size

  toplevel $w
  wm state $w withdrawn
  wm title $w "Scid: $name font"
  wm minsize $w 400 200
  setWinSize $w
  setWinLocation $w

  # this sucks
  wm protocol $w WM_DELETE_WINDOW {set fd_close 0}

  label $w.family_label -text Font -anchor w
  entry $w.family_entry -textvariable fd_family 
  bind  $w.family_entry <Key-Return> "FontDialogRegen $font_name"

  label $w.style_label  -text {Font Style} -anchor w
  entry $w.style_entry  -textvariable fd_style -width 11 
  bind  $w.style_entry  <Key-Return>  "FontDialogRegen $font_name"

  label $w.size_label   -text Size -anchor w
  entry $w.size_entry   -textvariable fd_size -width 4 
  bind  $w.size_entry   <Key-Return> "FontDialogRegen $font_name"

  grid config $w.family_label -column 0 -row 0 -sticky w
  grid config $w.family_entry -column 0 -row 1 -sticky ew
  grid config $w.style_label  -column 1 -row 0 -sticky w
  grid config $w.style_entry  -column 1 -row 1 -sticky ew
  grid config $w.size_label   -column 2 -row 0 -sticky w
  grid config $w.size_entry   -column 2 -row 1 -sticky ew

  ### Fix up this widget to make it stretch nicely ;> S.A.

  grid rowconfigure $w 2 -weight 2

  grid columnconfigure $w 0 -weight 6
  grid columnconfigure $w 1 -weight 2
  grid columnconfigure $w 2 -weight 1

  ### Family listbox.

  frame $w.family_list -bd 0
  listbox $w.family_list.list -height 6 -selectmode single -width 22 \
     -yscrollcommand "$w.family_list.scroll set"
  scrollbar $w.family_list.scroll -command "$w.family_list.list yview"

  foreach f $families {
    $w.family_list.list insert end $f
  }

  bind $w.family_list.list <Double-Button-1> \
    "FontDialogFamily $w.family_list.list $font_name $w.family_entry"

  ### Style listbox.

  frame $w.style_list -bd 0
  listbox $w.style_list.list -height 6 -selectmode single -width 11 \
     -yscrollcommand "$w.style_list.scroll set"
  scrollbar $w.style_list.scroll -command "$w.style_list.list yview"

  foreach i {Regular Bold Italic {Bold Italic}} {
    $w.style_list.list insert end $i
  }

  bind $w.style_list.list <Double-Button-1> \
    "FontDialogStyle $w.style_list.list $font_name $w.style_entry"

  ### Size listbox.

  frame $w.size_list -bd 0
  listbox $w.size_list.list -height 6 -selectmode single -width 5 \
     -yscrollcommand "$w.size_list.scroll set"
  scrollbar $w.size_list.scroll -command "$w.size_list.list yview"

  for {set i 7} {$i <= 20} {incr i} {
    $w.size_list.list insert end $i
  }

  bind $w.size_list.list <Double-Button-1> "FontDialogSize $w.size_list.list $font_name $w.size_entry"

  pack $w.family_list.scroll -side right -expand 1 -fill y
  pack $w.family_list.list   -side left  -expand 1 -fill both

  pack $w.style_list.scroll  -side right -expand 1 -fill y
  pack $w.style_list.list    -side left  -expand 1 -fill both

  pack $w.size_list.scroll   -side right -expand 1 -fill y
  pack $w.size_list.list     -side left  -expand 1 -fill both

  grid config $w.family_list -column 0 -row 2 -rowspan 16 -sticky nsew
  grid config $w.style_list  -column 1 -row 2 -rowspan 16 -sticky nsew
  grid config $w.size_list   -column 2 -row 2 -rowspan 16 -sticky nsew

  ### Buttons

  frame $w.buttons -bd 0

  button $w.buttons.ok -text OK -command "
    FontDialogRegen $font_name
    set fd_close 1
  "
  button $w.buttons.cancel  -text Cancel -command {
    set fd_close 0
  }

  frame $w.buttons.space -bd 0 -height 30

  button $w.buttons.default -text Default -command "
    reinitFont $name
    if {\"$name\" == {Regular}} {
      # reset bold italic to straight
      font configure font_Bold -family {$fd_family} -size {$fd_size} -slant roman
    }
    FontDialogFamily $w.buttons.list $font_name $w.family_entry
    FontDialogStyle $w.buttons.list $font_name $w.style_entry
    FontDialogSize $w.buttons.list $font_name $w.size_entry
    set fd_close 2
  "
  pack $w.buttons.ok -side top -fill x
  pack $w.buttons.default -side top -fill x -pady 10
  pack $w.buttons.space   -side top 
  pack $w.buttons.cancel -side top -fill x -pady 2
  grid config $w.buttons -column 4 -row 1 -rowspan 2 -sticky snew -padx 12

  ### Sample text

  set fr $w.sample
  frame $w.sample -bd 3 -relief groove
  label $w.sample.l_sample -text "Sample" -anchor w

  label $w.sample.sample -font $font_name -bd 2 -relief sunken -text \
    "This is some sample text\nAaBbCcDdEeFfGgHhIiJjKkLlMm\n 0123456789. +=-"

  pack  $w.sample.l_sample -side top -fill x -pady 4
  pack  $w.sample.sample -side top -pady 4 -ipadx 10 -ipady 10

  grid config $w.sample -column 0 -columnspan 3 -row 20 \
    -rowspan 2 -sticky snew -pady 10 -padx 2

  bind $w <Escape> "$w.buttons.cancel invoke"
  bind $w <Configure> "recordWinSize $w"
  update
  placeWinOverParent $w $parent
  wm state $w normal

  ### Tried to change this thing... but gave up.
  ### Spent a whole 12 hours on this file i think S.A

  # Make this a modal dialog. 

  tkwait variable fd_close

  destroy $w

  # Cancel button (Restore old font characteristics)
  if { $fd_close == 0 } {
    font configure $font_name -family $family \
      -size $size -slant $slant -weight $weight
    return {}
  }

  # Ok button
  if { $fd_close == 1 } {
    return [list $fd_family $fd_size [FontWeight $fd_style] [FontSlant $fd_style]]
  } else {

  # Default button
    return {}
  }
}

### These are new procs - previously in menu.tcl - but moved here
### to allow for fonts to be changed from other widgets S.A.

proc FontDialogFixed {parent} {
  global fontOptions

  set fontOptions(temp) [FontDialog Fixed $parent]
  if {$fontOptions(temp) != {}} { set fontOptions(Fixed) $fontOptions(temp) }
}

proc FontDialogRegular {parent} {
  global fontOptions graphFigurineAvailable

  set fontOptions(temp) [FontDialog Regular $parent]
  if {$fontOptions(temp) != {}} { set fontOptions(Regular) $fontOptions(temp) }

  set font [font configure font_Regular -family]
  set fontsize [font configure font_Regular -size]
  font configure font_Bold -family $font -size $fontsize
  font configure font_Italic -family $font -size $fontsize
  font configure font_BoldItalic -family $font -size $fontsize
  font configure font_H1 -family $font -size [expr {$fontsize + 8} ]
  font configure font_H2 -family $font -size [expr {$fontsize + 6} ]
  font configure font_H3 -family $font -size [expr {$fontsize + 4} ]
  font configure font_H4 -family $font -size [expr {$fontsize + 2} ]
  font configure font_H5 -family $font -size [expr {$fontsize + 0} ]
  if {$graphFigurineAvailable} {
    global graphFigurineFamily graphFigurineWeight
    font configure font_Figurine(normal) -family $graphFigurineFamily(normal) -weight $graphFigurineWeight(normal) -size $fontsize
    font configure font_Figurine(bold) -family $graphFigurineFamily(bold) -weight $graphFigurineWeight(bold) -size $fontsize
  }
  ::pgn::configTabs
}

proc FontDialogMenu {parent} {
  global fontOptions

  set fontOptions(temp) [FontDialog Menu $parent]
  if {$fontOptions(temp) != ""} { set fontOptions(Menu) $fontOptions(temp) }
}

proc FontDialogSmall {parent} {
  global fontOptions

  set fontOptions(temp) [FontDialog Small $parent]
  if {$fontOptions(temp) != ""} { set fontOptions(Small) $fontOptions(temp) }

  set font [font configure font_Small -family]
  set fontsize [font configure font_Small -size]
  font configure font_SmallBold -family $font -size $fontsize
  font configure font_SmallItalic -family $font -size $fontsize
  font configure font_Tiny -family $font -size [expr $fontsize - 1]
}

proc FontDialogFamily { listname font_name entrywidget } {
  # Get selected text from list.
  catch {
    set item_num [$listname curselection]
    set item [$listname get $item_num]

    # Set selected list item into entry for font family.
    $entrywidget delete 0 end
    $entrywidget insert end $item

    # Use this family in the font and regenerate font.
    FontDialogRegen $font_name
  }
}

proc FontDialogStyle { listname font_name entrywidget } {
  # Get selected text from list.
  catch {
    set item_num [$listname curselection]
    set item [$listname get $item_num]

    # Set selected list item into entry for font family.
    $entrywidget delete 0 end
    $entrywidget insert end $item

    # Use this family in the font and regenerate font.
    FontDialogRegen $font_name
  }
}

proc FontDialogSize { listname font_name entrywidget } {
  # Get selected text from list.
  catch {
    set item_num [$listname curselection]
    set item [$listname get $item_num]

    # Set selected list item into entry for font family.
    $entrywidget delete 0 end
    $entrywidget insert end $item

    # Use this family in the font and regenerate font.
    FontDialogRegen $font_name
  }
}

proc FontWeight {style} {
  if { $style == "Bold Italic" || $style == "Bold" } {
    return "bold"
  }
  return "normal"
}

proc FontSlant {style} {
  if { $style == "Bold Italic" || $style == "Italic" } {
    return "italic"
  }
  return "roman"
}

### FontDialogRegen: Regenerates font from attributes.

proc FontDialogRegen { font_name } {
  global fd_family fd_style fd_size graphFigurineAvailable

  set weight "normal"
  if { $fd_style == "Bold Italic" || $fd_style == "Bold" } {
    set weight "bold"
  }

  set slant "roman"
  if { $fd_style == "Bold Italic" || $fd_style == "Italic" } {
    set slant "italic"
  }

  # Change font to have new characteristics.
  font configure $font_name -family $fd_family -size $fd_size -slant $slant -weight $weight
  if {$font_name == "font_Regular" } {
    font configure font_Bold -family $fd_family -size $fd_size -slant $slant
    if {$graphFigurineAvailable} {
      font configure font_Figurine(normal) -size $fd_size 
      font configure font_Figurine(bold) -size $fd_size
    }
    ::pgn::configTabs
  }
}

proc FontBiggerSmaller {incr} {
  global fd_size fontOptions graphFigurineAvailable

  set fd_size [font configure font_Regular -size]
  set small_delta [expr {$fd_size - [font configure font_Small -size]}]
  incr fd_size $incr
  if {$fd_size < 5} { set fd_size 5 }
  set small_size [expr {$fd_size - $small_delta}]

  font configure font_Bold -size $fd_size
  font configure font_Regular -size $fd_size
  font configure font_Italic -size $fd_size
  font configure font_BoldItalic -size $fd_size
  font configure font_Small -size $small_size
  font configure font_SmallBold -size $small_size
  font configure font_SmallItalic -size $small_size
  font configure font_Tiny -size [expr $small_size - 1]
  font configure font_H1 -size [expr $fd_size + 8]
  font configure font_H2 -size [expr $fd_size + 6]
  font configure font_H3 -size [expr $fd_size + 4]
  font configure font_H4 -size [expr $fd_size + 2]
  if {$graphFigurineAvailable} {
    font configure font_Figurine(normal) -size $fd_size
    font configure font_Figurine(bold) -size $fd_size
  }
  ::pgn::configTabs

  set fontOptions(Regular) [lreplace $fontOptions(Regular) 1 1 $fd_size]
  set fontOptions(Small) [lreplace $fontOptions(Small) 1 1 $small_size]
  set fontOptions(Tiny) [lreplace $fontOptions(Tiny) 1 1 [expr $small_size - 1]]
}

proc FixedBiggerSmaller {incr} {
  global fontOptions 

  set size [font configure font_Fixed -size]
  incr size $incr
  if {$size < 5} { set size 5 }

  font configure font_Fixed -size $size
  set fontOptions(Fixed) [lreplace $fontOptions(Fixed) 1 1 $size]
}

proc bindWheeltoFont {w} {
  if {$::windowsOS || $::macOS} {
    # Control-MouseWheel binding is (generally) grabbed on OSX and doesn't work
    bind $w <Control-MouseWheel> {
      if {[expr -%D] < 0} {FontBiggerSmaller 1 ; break}
      if {[expr -%D] > 0} {FontBiggerSmaller -1 ; break}
    }
  } else {
    bind $w <Control-Button-4> {FontBiggerSmaller 1 ; break}
    bind $w <Control-Button-5> {FontBiggerSmaller -1 ; break}
  }
}

proc bindWheeltoFixed {w} {
  if {$::windowsOS || $::macOS} {
    # Control-MouseWheel binding is (generally) grabbed on OSX and doesn't work
    bind $w <Control-MouseWheel> {
      if {[expr -%D] < 0} {FixedBiggerSmaller 1 ; break}
      if {[expr -%D] > 0} {FixedBiggerSmaller -1 ; break}
    }
  } else {
    bind $w <Control-Button-4> {FixedBiggerSmaller 1 ; break}
    bind $w <Control-Button-5> {FixedBiggerSmaller -1 ; break}
  }
}

### End of file: font.tcl
