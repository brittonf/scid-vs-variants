### sound.tcl
# Scid vs. PC sound procedures
# Copyright (C) Shane Hudson 2004, Stevenaaus 2013
# Requires the Tcl/Tk sound package "Snack"

namespace eval ::utils::sound {}

set ::utils::sound::hasSnackPackage 0
set ::utils::sound::isPlayingSound 0
set ::utils::sound::soundQueue {}
set ::utils::sound::soundFiles "King Queen Rook Bishop Knight CastleQ CastleK Back Mate Promote Check a b c d e f g h x 1 2 3 4 5 6 7 8 move start end"

#   Maps characters in a move to sounds.
#   Before this map is used, "O-O-O" is converted to "q" and "O-O" to "k"
#   Also note that "U" (undo) is used for taking back a move.

array set ::utils::sound::soundMap {
  K King Q Queen R Rook B Bishop N Knight k CastleK q CastleQ
  x x U Back # Mate = Promote  + Check
  a a b b c c d d e e f f g g h h
  1 1 2 2 3 3 4 4 5 5 6 6 7 7 8 8
} 

proc ::utils::sound::Setup {} {
  variable hasSnackPackage
  variable soundFiles
  variable soundFolder

  ::splash::add "Initializing Sound..."

  if {[catch {package require snack 2.0}]} {
    set hasSnackPackage 0
    ::splash::add "   Snack sound package not found." 
    ### undefine procs
    proc ::utils::sound::AnnounceMove {move} {}
    proc ::utils::sound::PlayMove {sound} {}
    return
  }

  ::splash::add "   Snack sound package found: Move speech enabled."
  set devices [snack::audio outputDevices]
  ::splash::add "   Available output devices are: $devices"

  if {$::utils::sound::device != {}} {
    ::utils::sound::SetDevice
  } else {
    set ::utils::sound::device [lindex $devices 0]
  }
  set hasSnackPackage 1

  # Set up sounds. Each sound will be empty until a WAV file for it is found.
  foreach soundFile $soundFiles {
    ::snack::sound sound_$soundFile
  }

  set numSounds [::utils::sound::ReadFolder]
  set numSought [llength $soundFiles]
  ::splash::add "   Found $numSounds of $numSought sound files in $soundFolder"
}



proc ::utils::sound::AnnounceNewMove {move} {
  if {$::utils::sound::announceNew || ($::fics::sound && ($::fics::playing == 1 || $::fics::playing == -1))} { AnnounceMove $move }
}

proc ::utils::sound::AnnounceForward {move} {
  if {$::utils::sound::announceForward} { AnnounceMove $move }
}


proc ::utils::sound::AnnounceBack {} {
  if {$::utils::sound::announceBack} { AnnounceMove U }
}

proc ::utils::sound::AnnounceMove {move} {
  variable soundMap
  variable announceTock

  if {$announceTock || ($::fics::sound && ($move == "tock" || $::fics::playing == 1 || $::fics::playing == -1))} {
    PlayMove sound_move
    return
  }

  if {[string range $move 0 4] == "O-O-O"} { set move q }
  if {[string range $move 0 2] == "O-O"} { set move k }
  set move [::untrans $move]
  set parts [split $move ""]
  set soundList {}
  foreach part $parts {
    if {[info exists soundMap($part)]} {
      lappend soundList sound_$soundMap($part)
    }
  }
  if {[llength $soundList] > 0} {
    PlayMove $soundList
  }
}

# Plays a sound or list of sounds representing a move

proc ::utils::sound::PlayMove {soundlist} {
  # What is the best location for this update
  update idletasks
  ::snack::audio stop
  set ::utils::sound::isPlayingSound 0
  set ::utils::sound::soundQueue $soundlist
  after cancel ::utils::sound::PlaySoundQueue
  after idle ::utils::sound::PlaySoundQueue
}

proc ::utils::sound::PlaySoundQueue {} {

  set ::utils::sound::isPlayingSound 0

  while {[llength $::utils::sound::soundQueue] > 0} {
    set sound [lindex $::utils::sound::soundQueue 0]
    set ::utils::sound::soundQueue [lrange $::utils::sound::soundQueue 1 end]
    incr ::utils::sound::isPlayingSound
    $sound play -blocking 0 -command "incr ::utils::sound::isPlayingSound -1"
    if {[llength $::utils::sound::soundQueue] > 0} {
      vwait ::utils::sound::isPlayingSound
    }
  }
}


#   TODO: language translations for this dialog.

proc ::utils::sound::OptionsDialog {} {
  set w .soundOptions

  if {[winfo exists $w]} {
    raiseWin $w
    return
  }

  # foreach v {soundFolder announceNew announceForward announceBack announceTock}

  toplevel $w
  wm title $w "Scid: Sound Options"
  wm withdraw $w
  wm resizable $w 0 0

  pack [frame $w.b] -side bottom -fill x -pady 2

  if {! $::utils::sound::hasSnackPackage} {
    label $w.status -text "Scid could not find the Snack audio package at startup. Sound is disabled."
    pack $w.status -side bottom
  }

  pack [frame $w.f -relief groove -borderwidth 2] \
      -side top -fill x -padx 5 -pady 5 -ipadx 4 -ipady 4

  set f $w.f
  set r 0

  label $f.ftitle -text $::tr(SoundsFolder) -font font_Bold
  grid $f.ftitle -row $r -column 0 -columnspan 3 -pady 4
  incr r

  entry $f.folderEntry -width 40 -textvariable ::utils::sound::soundFolder
  grid $f.folderEntry -row $r -column 0 -columnspan 2 -sticky we -padx 3
  button $f.folderBrowse -text " $::tr(Browse)" -command ::utils::sound::ChooseFolder
  grid $f.folderBrowse -row $r -column 2 -padx 3
  incr r

  label $f.folderHelp -text $::tr(SoundsFolderHelp)
  grid $f.folderHelp -row $r -column 0 -columnspan 3
  incr r

  grid [frame $f.gap$r -height 5] -row $r -column -0; incr r

  label $f.title -text $::tr(SoundsAnnounceOptions) -font font_Bold
  grid $f.title -row $r -column 0 -columnspan 3 -pady 4
  incr r

  checkbutton $f.announceNew -text $::tr(SoundsAnnounceNew) \
      -variable ::utils::sound::announceNew
  grid $f.announceNew -row $r -column 0 -columnspan 2 -sticky w
  incr r

  grid [frame $f.gap$r -height 5] -row $r -column -0; incr r

  checkbutton $f.announceForward -text $::tr(SoundsAnnounceForward) \
      -variable ::utils::sound::announceForward
  grid $f.announceForward -row $r -column 0 -columnspan 2 -sticky w
  incr r

  grid [frame $f.gap$r -height 5] -row $r -column -0; incr r

  checkbutton $f.announceBack -text $::tr(SoundsAnnounceBack) \
      -variable ::utils::sound::announceBack
  grid $f.announceBack -row $r -column 0 -columnspan 2 -sticky w
  incr r

  grid [frame $f.gap$r -height 5] -row $r -column -0; incr r

  checkbutton $f.announceTock -text {Play Tick-Tock sound instead of move} \
      -variable ::utils::sound::announceTock
  grid $f.announceTock -row $r -column 0 -columnspan 2 -sticky w
  incr r

  grid [frame $f.gap$r -height 5] -row $r -column -0; incr r

  ### device combobox

  label $f.deviceLabel -text "Sound Device" -font font_Bold
  grid  $f.deviceLabel -row $r -column 0 -columnspan 3 -pady 4
  incr r

  set devices [::snack::audio outputDevices]

  set tmp $::utils::sound::device
  ttk::combobox $f.device -width 20 -textvariable ::utils::sound::device 
  bind $f.device <<ComboboxSelected>> ::utils::sound::SetDevice

  # set i [lsearch $devices $::utils::sound::device]
  $f.device configure -values $devices
  set ::utils::sound::device $tmp
  # $f.device current $i

  grid $f.device -row $r -column 0 -columnspan 3
  incr r

  dialogbutton $w.b.help -text $::tr(Help) -command {helpWindow Sound}
  dialogbutton $w.b.ok -text OK -command "
    ::utils::sound::ReadFolder
    destroy $w"
  packbuttons right $w.b.ok $w.b.help
  bind $w <Escape> "destroy $w"
  bind $w <F1> {helpWindow Sound}
  placeWinCenter $w
  wm state $w normal
}



proc ::utils::sound::ChooseFolder {} {
  if {[file isdirectory $::utils::sound::soundFolder]} {
    set initialdir $::utils::sound::soundFolder
  } else {
    set initialdir $::env(HOME)
  }
  set newFolder [tk_chooseDirectory -initialdir $initialdir -parent .soundOptions -title "Scid: $::tr(SoundsFolder)"]
  if {$newFolder == ""} {
    return
  }
  set ::utils::sound::soundFolder [file nativename $newFolder]
  ::utils::sound::soundFolderOK
}

proc ::utils::sound::soundFolderOK {} {
  variable soundFolder

    set numSoundFiles [::utils::sound::ReadFolder]
    tk_messageBox -title "Scid: Sound Files" -type ok -icon info \
        -message "Found $numSoundFiles of [llength $::utils::sound::soundFiles] sound files in $::utils::sound::soundFolder"
}

### Read sound files from the specified directory.
#   Return the number of Scid sound files found in that directory.

proc ::utils::sound::ReadFolder {} {
  variable soundFiles
  variable soundFolder

  set count 0
  foreach soundFile $soundFiles {
    set f [file join $soundFolder $soundFile.wav]
    if {[file readable $f]} {
      sound_$soundFile configure -file $f

      ### alternatively, store file in memory
      # sound_$soundFile read $f

      incr count
    }
  }
  return $count
}

proc ::utils::sound::SetDevice {args} {

  if {[catch {snack::audio selectOutput $::utils::sound::device}]} {
    ::splash::add "   Failure setting Snack output device to $::utils::sound::device"
  } else {
    ::splash::add "   Succesfully set Snack output device to $::utils::sound::device"
  }
}

::utils::sound::Setup

# end of sound.tcl
