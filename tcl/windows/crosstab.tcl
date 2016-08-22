
### crosstab.tcl

namespace eval ::crosstab {}

foreach var  \
   {sort type ages colors ratings countries tallies titles groups breaks deleted cnumbers text threewin tiewin tiehead colorrows} \
        value \
   {score auto +ages +colors +ratings +countries +tallies +titles -groups -breaks -deleted -numcolumns hypertext -threewin -tiewin -tiehead 1} {
  if {![info exists crosstab($var)]} {
    set crosstab($var) $value
  }
}

proc ::crosstab::ConfigMenus {{lang ""}} {
  global spellCheckFileExists

  if {! [winfo exists .crosstabWin]} { return }
  if {$lang == ""} { set lang $::language }
  set m .crosstabWin.menu
  foreach idx {0 1 2 3 4 5} tag {File Sort Type Opt Edit Help} {
    configMenuText $m $idx Crosstab$tag $lang
  }
  foreach idx {0 1 2 4} tag {Text Html LaTeX Close} {
    configMenuText $m.file $idx CrosstabFile$tag $lang
  }
  foreach idx {1 2 3} tag {Event Site Date} {
    configMenuText $m.edit $idx CrosstabEdit$tag $lang
  }

  ### Scid menus are the biggest steaming pile of shit S.A
  ### We have to skip over numbers for "separators"

  foreach idx   {1 2 3 4 5 6 7 8 9 11 12 13 14 16 17 18} tag {Ages Nats Tallies Ratings Titles Breaks Deleted Colors ColumnNumbers TieHead TieWin ThreeWin Group ColorPlain ColorHyper ColorRows} {
    configMenuText $m.opt $idx CrosstabOpt$tag $lang
  }

  # Disable the Ages, Nats, Titles items if spellcheck not enabled. S.A
  if {!$::spellCheckFileExists} {
    $m.opt entryconfig 1 -state disabled -variable {}
    $m.opt entryconfig 2 -state disabled -variable {}
    $m.opt entryconfig 5 -state disabled -variable {}
  }

  foreach idx {1 2 3 4} tag {Score Name Country Rating} {
    configMenuText $m.sort $idx CrosstabSort$tag $lang
  }
  foreach idx {1 2 3 4} tag {Auto All Swiss Knockout} {
    configMenuText $m.type $idx CrosstabType$tag $lang
  }
  foreach idx {0 1} tag {Cross Index} {
    configMenuText $m.help $idx CrosstabHelp$tag $lang
  }
}


proc ::crosstab::Open {{game {}}} {
  global crosstab 

  set w .crosstabWin
  if {[winfo exists $w]} {
    ::crosstab::Refresh $game
    raiseWin $w
    return
  }

  ::createToplevel $w
  ::setTitle $w "[tr WindowsCross]"
  wm minsize $w 10 5
  setWinLocation $w
  setWinSize $w

  menu $w.menu
  ::setMenu $w $w.menu
  $w.menu add cascade -label CrosstabFile -menu $w.menu.file
  $w.menu add cascade -label CrosstabSort -menu $w.menu.sort
  $w.menu add cascade -label CrosstabType -menu $w.menu.type
  $w.menu add cascade -label CrosstabOpt -menu $w.menu.opt
  $w.menu add cascade -label CrosstabEdit -menu $w.menu.edit
  $w.menu add cascade -label CrosstabHelp -menu $w.menu.help

  menu $w.menu.file
  menu $w.menu.sort -tearoff 1
  menu $w.menu.type -tearoff 1
  menu $w.menu.opt  -tearoff 1
  menu $w.menu.edit -tearoff 1
  menu $w.menu.help

  $w.menu.file add command -label CrosstabFileText -command {
    set ftype {
      { "Text files" {".txt"} }
      { "All files"  {"*"}    }
    }
    set fname [tk_getSaveFile -initialdir $::env(HOME) -filetypes $ftype  -title "Save Crosstable" -parent .crosstabWin]
    if {$fname != ""} {
      if {[catch {set tempfile [open $fname w]}]} {
        tk_messageBox -title "Scid: Error saving file" \
          -type ok -icon warning -parent .crosstabWin \
          -message "Unable to save the file: $fname\n\n"
      } else {
        puts -nonewline $tempfile [.crosstabWin.f.text get 1.0 end]
        close $tempfile
      }
    }
  }
  $w.menu.file add command -label CrosstabFileHtml -command {
    set ftype {
      { "HTML files" {".html" ".htm"} }
      { "All files"  {"*"}    }
    }
    set fname [tk_getSaveFile -initialdir $::initialDir(html) -filetypes $ftype  -title "Save Crosstable as HTML" -parent .crosstabWin]
    if {$fname != ""} {
      if {[catch {set tempfile [open $fname w]}]} {
        tk_messageBox -title "Scid: Error saving file" \
          -type ok -icon warning -parent .crosstabWin \
          -message "Unable to save the file: $fname\n\n"
      } else {
        catch {sc_game crosstable html $crosstab(sort) $crosstab(type) \
                 $crosstab(ratings) $crosstab(countries) $crosstab(tallies) $crosstab(titles) \
                 $crosstab(colors) $crosstab(groups) $crosstab(ages) \
                 $crosstab(breaks) $crosstab(cnumbers) $crosstab(deleted) $crosstab(threewin) $crosstab(tiewin) $crosstab(tiehead)} \
          result
        puts $tempfile $result
        close $tempfile
      }
    }
  }
  $w.menu.file add command -label CrosstabFileLaTeX -command {
    set ftype {
      { "LaTeX files" {".tex" ".ltx"} }
      { "All files"  {"*"}    }
    }
    set fname [tk_getSaveFile -initialdir $::initialDir(tex) -filetypes $ftype  -title "Save Crosstable as LaTeX" -parent .crosstabWin]
    if {$fname != ""} {
      if {[catch {set tempfile [open $fname w]}]} {
        tk_messageBox -title "Scid: Error saving file" \
          -type ok -icon warning -parent .crosstabWin \
          -message "Unable to save the file: $fname\n\n"
      } else {
        catch {sc_game crosstable latex $crosstab(sort) $crosstab(type) \
                 $crosstab(ratings) $crosstab(countries) $crosstab(tallies) $crosstab(titles) \
                 $crosstab(colors) $crosstab(groups) $crosstab(ages) \
                 $crosstab(breaks) $crosstab(cnumbers) $crosstab(deleted) $crosstab(threewin) $crosstab(tiewin) $crosstab(tiehead)} \
          result
        puts $tempfile $result
        close $tempfile
      }
    }
  }
  $w.menu.file add separator
  $w.menu.file add command -label CrosstabFileClose \
    -command { .crosstabWin.b.cancel invoke } -accelerator Esc

  $w.menu.edit add command -label CrosstabEditEvent -command {
    nameEditor
    setNameEditorType event
    set editName [sc_game info event]
    set editNameNew $editName
    set editNameSelect crosstable
  }
  $w.menu.edit add command -label CrosstabEditSite -command {
    nameEditor
    setNameEditorType site
    set editName [sc_game info site]
    set editNameNew $editName
    set editNameSelect crosstable
  }
  $w.menu.edit add command -label CrosstabEditDate -command {
    nameEditor
    setNameEditorType date
    set editNameNew " "
    set editDate [sc_game info date]
    set editDateNew [sc_game info date]
    set editNameSelect crosstable
  }

  $w.menu.opt add checkbutton -label CrosstabOptAges \
    -variable crosstab(ages) -onvalue "+ages" \
    -offvalue "-ages" -command ::crosstab::Refresh
  $w.menu.opt add checkbutton -label CrosstabOptNats \
    -variable crosstab(countries) -onvalue "+countries" \
    -offvalue "-countries" -command ::crosstab::Refresh
  $w.menu.opt add checkbutton -label CrosstabOptTallies \
    -variable crosstab(tallies) -onvalue "+tallies" \
    -offvalue "-tallies" -command ::crosstab::Refresh
  $w.menu.opt add checkbutton -label CrosstabOptRatings \
    -variable crosstab(ratings) -onvalue "+ratings" -offvalue "-ratings" \
    -command ::crosstab::Refresh
  $w.menu.opt add checkbutton -label CrosstabOptTitles \
    -variable crosstab(titles) -onvalue "+titles" -offvalue "-titles" \
    -command ::crosstab::Refresh
  $w.menu.opt add checkbutton -label CrosstabOptBreaks \
    -variable crosstab(breaks) -onvalue "+breaks" \
    -offvalue "-breaks" -command ::crosstab::Refresh
  $w.menu.opt add checkbutton -label CrosstabOptDeleted \
    -variable crosstab(deleted) -onvalue "+deleted" \
    -offvalue "-deleted" -command ::crosstab::Refresh

  $w.menu.opt add checkbutton -label CrosstabOptColors \
    -underline 0 -variable crosstab(colors) \
    -onvalue "+colors" -offvalue "-colors" -command ::crosstab::Refresh
  $w.menu.opt add checkbutton -label CrosstabOptColumnNumbers \
    -underline 0 -variable crosstab(cnumbers) \
    -onvalue "+numcolumns" -offvalue "-numcolumns" -command ::crosstab::Refresh

  $w.menu.opt add separator

  $w.menu.opt add checkbutton -label CrosstabOptTieHead \
    -variable crosstab(tiehead) -command ::crosstab::Refresh -onvalue "+tiehead" -offvalue "-tiehead"
  $w.menu.opt add checkbutton -label CrosstabOptTieWin \
    -variable crosstab(tiewin) -command ::crosstab::Refresh -onvalue "+tiewin" -offvalue "-tiewin"

  $w.menu.opt add checkbutton -label CrosstabOptThreeWin \
    -variable crosstab(threewin) -command ::crosstab::Refresh  \
    -onvalue "+threewin" -offvalue "-threewin"
  $w.menu.opt add checkbutton -label CrosstabOptGroup \
    -underline 0 -variable crosstab(groups) \
    -onvalue "+groups" -offvalue "-groups" -command ::crosstab::Refresh

  $w.menu.opt add separator

  $w.menu.opt add radiobutton -label CrosstabOptColorPlain \
    -variable crosstab(text) -value plain -command ::crosstab::Refresh
  $w.menu.opt add radiobutton -label CrosstabOptColorHyper \
    -variable crosstab(text) -value hypertext -command ::crosstab::Refresh
  $w.menu.opt add checkbutton -label CrosstabOptColorRows \
    -underline 0 -variable crosstab(colorrows) \
    -onvalue 1 -offvalue 0 -command ::crosstab::Refresh

  $w.menu.sort add radiobutton -label CrosstabSortScore \
    -variable crosstab(sort) -value score -command ::crosstab::Refresh
  $w.menu.sort add radiobutton -label CrosstabSortName \
    -variable crosstab(sort) -value name -command ::crosstab::Refresh
  $w.menu.sort add radiobutton -label CrosstabSortCountry \
    -variable crosstab(sort) -value country -command ::crosstab::Refresh
  $w.menu.sort add radiobutton -label CrosstabSortRating \
    -variable crosstab(sort) -value rating -command ::crosstab::Refresh

  $w.menu.type add radiobutton -label CrosstabTypeAuto \
    -variable crosstab(type) -value auto -command ::crosstab::Refresh
  $w.menu.type add radiobutton -label CrosstabTypeAll \
    -variable crosstab(type) -value allplay -command ::crosstab::Refresh
  $w.menu.type add radiobutton -label CrosstabTypeSwiss \
    -variable crosstab(type) -value swiss -command ::crosstab::Refresh
  $w.menu.type add radiobutton -label CrosstabTypeKnockout \
    -variable crosstab(type) -value knockout -command ::crosstab::Refresh

  $w.menu.help add command -label CrosstabHelpCross \
    -accelerator F1 -command {helpWindow Crosstable}
  $w.menu.help add command -label CrosstabHelpIndex \
     -command {helpWindow Index}

  ::crosstab::ConfigMenus

  # packing this here makes the text widget resize nicely ? S.A.
  frame $w.b
  pack $w.b -side bottom -fill x

  frame $w.f
  pack $w.f -side top -fill both -expand true
  # Causes flicker when updated
  # -width $::winWidth($w) -height $::winHeight($w) &&&
  set text $w.f.text
  text $text -wrap none -font font_Fixed -setgrid 1 -cursor top_left_arrow \
     -yscroll "$w.f.ybar set" -xscroll "$w.f.xbar set"
  ::htext::init $text

  # Crosstable will have striped appearance if {} is replaced by another colour
  $text tag configure rowColor -background $::crosscolor

  scrollbar $w.f.ybar -command "$text yview"
  scrollbar $w.f.xbar -orient horizontal -command "$text xview"
  grid $text -row 0 -column 0 -sticky nesw
  grid $w.f.ybar -row 0 -column 1 -sticky nesw
  grid $w.f.xbar -row 1 -column 0 -sticky nesw
  grid rowconfig $w.f 0 -weight 1 -minsize 0
  grid columnconfig $w.f 0 -weight 1 -minsize 0

  button $w.b.stop -textvar ::tr(Stop) -state disabled -font font_Small \
    -command { set ::htext::interrupt 1 }

  button $w.b.update -textvar ::tr(Update) -font font_Small -command ::crosstab::Refresh

  entry $w.b.find -width 10 -textvariable crosstab(find) -font font_Small -highlightthickness 0
  configFindEntryBox $w.b.find crosstab .crosstabWin.f.text

  button $w.b.cancel -textvar ::tr(Close) -font font_Small -command {
    focus .main
    destroy .crosstabWin
  }
  button $w.b.setfilter -textvar ::tr(SetFilter) -font font_Small -command {::crosstab::setFilter 0}
  button $w.b.addfilter -textvar ::tr(AddToFilter) -font font_Small -command {::crosstab::setFilter}

  button $w.b.font -textvar ::tr(Font) -font font_Small -command {FontDialogFixed .crosstabWin}

  pack $w.b.cancel $w.b.find $w.b.update -side right -pady 3 -padx 5
  pack $w.b.setfilter $w.b.addfilter -side left -pady 3 -padx 5

  standardShortcuts $w

  bind $w <Button-3> {tk_popup .crosstabWin.menu %X %Y}

  bind $w <F1>       "helpWindow Crosstable"
  bind $w <Escape>   ".crosstabWin.b.cancel invoke"
  bind $w <Up>       "$text yview scroll -1 units"
  bind $w <Down>     "$text yview scroll 1 units"
  bind $w <Prior>    "$text yview scroll -1 pages"
  bind $w <Next>     "$text yview scroll 1 pages"
  bind $w <Left>     "$text xview scroll -1 units"
  bind $w <Right>    "$text xview scroll 1 units"
  bind $w <Key-Home> "$text yview moveto 0"
  bind $w <Key-End>  "$text yview moveto 0.99"

  # MouseWheel Bindings:
  if {$::windowsOS || $::macOS} {
    bind $w <Shift-MouseWheel> {break}
    bind $w <MouseWheel> { .crosstabWin.f.text yview scroll [expr {- (%D / 120)}] units}
  } else {
    bind $text <Shift-Button-4> "$text xview scroll -5 units ; break"
    bind $text <Shift-Button-5> "$text xview scroll 5 units ; break"
    bind $text <Button-4> "$text yview scroll -1 units"
    bind $text <Button-5> "$text yview scroll  1 units"
  }

  bindWheeltoFixed $w

  bind $w <Destroy> {}
  ::crosstab::Refresh $game

  bind $w <Configure> "recordWinSize $w"
  ::createToplevelFinalize $w
}

proc ::crosstab::setFilter {{round {}}} {
  global crosstab glstart crosstabGame crosstabBase

  set currentBase [sc_base current]
  if {$currentBase != $crosstabBase} {
    sc_base switch $crosstabBase
  }

  if {$round == {}} {
    sc_game crosstable filter -gameNumber $crosstabGame $crosstab(deleted)
  } else {
    sc_game crosstable filter -round $round -gameNumber $crosstabGame $crosstab(deleted) 
  }

  if {$currentBase != $crosstabBase} {
    sc_base switch $currentBase
  }

  set glstart 1
  ::windows::stats::Refresh
  ::windows::gamelist::Refresh
  updateStatusBar
}

proc ::crosstab::Refresh {{game {}}} {
  global crosstab crosstabGame crosstabBase
  set w .crosstabWin
  if {! [winfo exists $w]} { return }

  $w.f.text configure -state normal
  $w.f.text delete 1.0 end
  busyCursor .
  $w.f.text configure -state disabled
  ### Stop button is broken currently 
  ### We need to implement it via sc_progressBar
  update idle
  # $w.b.stop configure -state normal
  foreach button {update cancel setfilter addfilter} {
    $w.b.$button configure -state disabled
  }
  # pack $w.b.stop -side right -padx 5 -pady 3
  # catch {grab $w.b.stop}
  # update

  if {$game == {}} {
    # Since we aren't autoupdating crosstable, remember which base/game the table is for, for ::crosstab::setFilter
    set crosstabGame [sc_game number]
  } else {
    set crosstabGame $game
  }
  set crosstabBase [sc_base current]

  if {[
  catch {sc_game crosstable $crosstab(text) $crosstab(sort) $crosstab(type) \
         $crosstab(ratings) $crosstab(countries) $crosstab(tallies) $crosstab(titles) \
         $crosstab(colors) $crosstab(groups) $crosstab(ages) \
         $crosstab(breaks) $crosstab(cnumbers) $crosstab(deleted) $crosstab(threewin) $crosstab(tiewin) $crosstab(tiehead) \
         -gameNumber $crosstabGame } result
  ]} {
    puts "sc_game crosstable failed"
  }

  $w.f.text configure -state normal
  if {$crosstab(text) == "plain"} {
    $w.f.text insert end $result
  } else {
    ::htext::display $w.f.text $result
  }

if {$crosstab(colorrows) && $crosstab(type) != "knockout"} {
  set start [$w.f.text search -- --------- 1.0]
  if {$start != {}} {
    set end [$w.f.text search -- --------- "$start +1line"]

    # Shade every second line to help readability
    $w.f.text configure -state normal
    set startline [expr {int($start) + 1}]
    set endline   [expr {int($end) - 1}]
    for {set i $startline} {$i <= $endline} {incr i 2} {
      $w.f.text tag add rowColor $i.0 "$i.end +1c"
    }
  }
}
  unbusyCursor .
  # catch {grab release $w.b.stop}
  # $w.b.stop configure -state disabled
  ### We cant use forget on this because of a bug in the windows packer
  # pack forget $w.b.stop
  foreach button {update cancel setfilter addfilter} {
    $w.b.$button configure -state normal
  }
  $w.f.text configure -state disabled
}

### end of crosstable.tcl
