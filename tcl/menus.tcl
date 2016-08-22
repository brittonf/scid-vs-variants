### Menus.tcl: part of Scid.
### Copyright (C) 2001-2003 Shane Hudson.

### Keep menus on right hand side (X11)
# This also disables automatic menu posting
# catch {tk::classic::restore menu}

# Disabled
if {0 && [tk windowingsystem] eq "x11"} {
  option add *Menu.useMotifHelp true widgetDefault
}

array set helpMessage {}

### Main window menus:

option add *Menu*TearOff 0

menu .menu

### We need to find a way to focus .menu for Alt+Key menu shortcuts in docked mode
# bind .menu <Any-Enter> {focus -force .menu ; break}
# bind .menu <ButtonRelease-1> {focus -force .menu}

if {$windowsOS} {
  # todo &&&
  # How do we disable windows broken menu short-cuts &&&
  # bind $dot_w <Alt> {}
}

## Mac Application menu has to be before any call to configure.
if {$macOS} {
  # Application menu:
  .menu add cascade -label Scid -menu .menu.apple
  menu .menu.apple

  set menuindex -1
  set m .menu.apple

  $m add command -label HelpAbout -command {helpWindow Author}
  set helpMessage($m,[incr menuindex]) HelpAbout

  $m add separator
  incr menuindex

  bind all <Help> {helpWindow Contents}

  # Trap quitting from the tkscid OSX menu (needed to save options).
  proc ::tk::mac::Quit {}  {
    ::file::Exit
  }

}

if {$::gameInfo(showMenu)} {
  $dot_w configure -menu .menu
}

.menu add cascade -label File -menu .menu.file
.menu add cascade -label Play -menu .menu.play
.menu add cascade -label Edit -menu .menu.edit
.menu add cascade -label Game -menu .menu.game
.menu add cascade -label Search -menu .menu.search
.menu add cascade -label Windows -menu .menu.windows
.menu add cascade -label Tools -menu .menu.tools
.menu add cascade -label Options -menu .menu.options
.menu add cascade -label Help -menu .menu.help

foreach menuname { file edit game search windows play tools options help } {
  menu .menu.$menuname
}

.menu.windows configure -tearoff 1
.menu.options configure -tearoff 1
.menu.help configure -tearoff 1


### File menu:

set menuindex -1
set m .menu.file
# If altering .menu.file, must change the 'set idx ...' value below

$m add command -label FileNew -command ::file::New
set helpMessage($m,[incr menuindex]) FileNew

$m add command -label FileOpen -acc "control-o" -command ::file::Open
bind .main <Control-o> ::file::Open
set helpMessage($m,[incr menuindex]) FileOpen

$m add command -label FileSavePgn  -command {::pgn::savePgn .}
set helpMessage($m,[incr menuindex]) FileSavePgn

$m add command -label FileClose -acc "control-w" -command ::file::Close
bind .main <Control-w> ::file::Close
set helpMessage($m,[incr menuindex]) FileClose

$m add command -label FileReadOnly -command makeBaseReadOnly
set helpMessage($m,[incr menuindex]) FileReadOnly

$m add command -label FileFinder -acc "control-/" -command ::file::finder::Open
bind .main <Control-slash> ::file::finder::Open
set helpMessage($m,[incr menuindex]) FileFinder

$m add cascade -label FileBookmarks -menu $m.bookmarks
set helpMessage($m,[incr menuindex]) FileBookmarks
menu $m.bookmarks

$m add separator
incr menuindex

$m add cascade -label FileSwitch -menu $m.switch
set helpMessage($m,[incr menuindex]) FileSwitch

### .menu.file.switch menu items added in updateMenuStates

menu $m.switch -tearoff 1

# naming is weird because the menus are moved from Tools to File menus

$m add command -label FileOpenBaseAsTree -command ::file::openBaseAsTree
set helpMessage($m,[incr menuindex]) FileOpenBaseAsTree
menu $m.recenttrees
$m add cascade -label FileOpenRecentBaseAsTree -menu $m.recenttrees
set helpMessage($m,[incr menuindex]) FileOpenRecentBaseAsTree

$m add separator
incr menuindex

set totalBaseSlots [sc_base count total]
set clipbaseSlot [sc_info clipbase]
set currentSlot [sc_base current]

$m add separator
incr menuindex

$m add command -label FileExit -accelerator "control-q" -command ::file::Exit
bind .main <Control-q> ::file::Exit
set helpMessage($m,[incr menuindex]) FileExit


### Edit menu

set menuindex -1
set m .menu.edit

$m add command -label EditSetup -command setupBoard -accelerator "control-B"
set helpMessage($m,[incr menuindex]) EditSetup

$m add command -label EditCopyBoard -accelerator "control-C" -command copyFEN
set helpMessage($m,[incr menuindex]) EditCopyBoard

$m add command -label EditCopyPGN -command ::pgn::copyPgn
set helpMessage($m,[incr menuindex]) EditCopyPGN

$m add command -label EditPasteBoard -accelerator "control-V" -command pasteFEN
set helpMessage($m,[incr menuindex]) EditPasteBoard

$m add command -label EditPastePGN -command importPgnGame -accelerator "control-I"
set helpMessage($m,[incr menuindex]) EditPastePGN

$m add separator
incr menuindex

$m add command -label EditReset -command {
  sc_clipbase clear
  updateBoard -pgn
  ::windows::gamelist::Refresh
  updateTitle
}
set helpMessage($m,[incr menuindex]) EditReset

$m add command -label EditCopy -accelerator "control-c" -command copyGame
bind .main <Control-c> copyGame
set helpMessage($m,[incr menuindex]) EditCopy

$m add command -label EditPaste -accelerator "control-v" -command pasteGame
bind .main <Control-v> pasteGame
set helpMessage($m,[incr menuindex]) EditPaste

$m add separator
incr menuindex

$m add cascade -label EditStrip -menu $m.strip
set helpMessage($m,[incr menuindex]) EditStrip

$m add command -label EditUndo -command {sc_game undo ; updateBoard -pgn}
set helpMessage($m,[incr menuindex]) EditUndo
$m add command -label EditRedo -command {sc_game redo ; updateBoard -pgn}
set helpMessage($m,[incr menuindex]) EditRedo
bind .main <Control-z> {sc_game undo ; updateBoard -pgn}
bind .main <Control-y> {sc_game redo ; updateBoard -pgn}

$m add separator
incr menuindex

$m add command -label EditAdd -accel "control-a" -command {sc_var create; updateBoard -pgn}
set helpMessage($m,[incr menuindex]) EditAdd

$m add command -label EditPasteVar -command importVar
set helpMessage($m,[incr menuindex]) EditPasteVar

menu $m.del
$m add cascade -label EditDelete -menu $m.del
set helpMessage($m,[incr menuindex]) EditDelete

menu $m.first
$m add cascade -label EditFirst -menu $m.first
set helpMessage($m,[incr menuindex]) EditFirst

menu $m.main
$m add cascade -label EditMain -menu $m.main
set helpMessage($m,[incr menuindex]) EditMain

$m add checkbutton -label EditTrial -variable trialMode \
    -accelerator "control-space" -command {setTrialMode menu}
bind .main <Control-space> { setTrialMode toggle }
set helpMessage($m,[incr menuindex]) EditTrial

menu $m.strip
$m.strip add command -label EditStripBegin -command {::game::TruncateBegin}
set helpMessage($m.strip,2) EditStripBegin
$m.strip add command -label EditStripEnd -command {::game::Truncate}
set helpMessage($m.strip,3) EditStripEnd
bind .main <Delete> {::game::Truncate}
$m.strip add command -label EditStripComments -command {::game::Strip comments}
set helpMessage($m.strip,0) EditStripComments
$m.strip add command -label EditStripVars -command {::game::Strip variations}
set helpMessage($m.strip,1) EditStripVars


### Game menu:
set menuindex -1
set m .menu.game
$m add command -label GameNew -accelerator "control-N" -command ::game::Clear
bind .main <Control-N> ::game::Clear
set helpMessage($m,[incr menuindex]) GameNew

$m add command -label GameReplace -command gameReplace -accelerator "control-s"
bind .main <Control-s> { .menu.game invoke [tr GameReplace] }
set helpMessage($m,[incr menuindex]) GameReplace

$m  add command -label GameAdd -command gameAdd  -accelerator "control-S"
bind .main <Control-S> gameAdd
set helpMessage($m,[incr menuindex]) GameAdd

$m add separator
incr menuindex

$m add command -label GameInfo -command {gameSave -1} -underline 9
set helpMessage($m,[incr menuindex]) GameInfo

$m add command -label GameBrowse -command {::gbrowser::new [sc_base current] [sc_game number] [sc_pos location]}
set helpMessage($m,[incr menuindex]) GameBrowse

$m add command -label GameList -accel "control-l" -command ::windows::gamelist::Open 
set helpMessage($m,[incr menuindex]) GameList

$m add separator
incr menuindex

$m  add command -label GameDelete -accel "control-delete" -command ::game::Delete -underline 0
set helpMessage($m,[incr menuindex]) GameDelete
if {$::macOS} {
  bind .main <Control-BackSpace> ::game::Delete
} else {
  bind .main <Control-Delete> ::game::Delete
}

$m add command -label GameReload -command ::game::Reload 
set helpMessage($m,[incr menuindex]) GameReload

$m add separator
incr menuindex

$m add command -label GameFirst -accelerator "control-home" \
    -command {::game::LoadNextPrev first}
set helpMessage($m,[incr menuindex]) GameFirst

$m add command -label GameLast -accelerator "control-end" \
    -command {::game::LoadNextPrev last}
set helpMessage($m,[incr menuindex]) GameLast

$m add command -label GameNext -accelerator "control-down" \
    -command {::game::LoadNextPrev next}
set helpMessage($m,[incr menuindex]) GameNext

$m add command -label GamePrev -accelerator "control-up" \
    -command {::game::LoadNextPrev previous}
set helpMessage($m,[incr menuindex]) GamePrev

$m add command -label GameRandom -command ::game::LoadRandom -accelerator "control-?"
set helpMessage($m,[incr menuindex]) GameRandom

$m add command -label GameNumber -command ::game::LoadNumber -accelerator "control-u"
set helpMessage($m,[incr menuindex]) GameNumber

$m add separator
incr menuindex

$m add command -label GameDeepest -command {
  sc_move ply [sc_eco game ply]
  updateBoard
}
set helpMessage($m,[incr menuindex]) GameDeepest

$m add command -label GameGotoMove -accelerator "control-g" \
    -command ::game::GotoMoveNumber
set helpMessage($m,[incr menuindex]) GameGotoMove
bind .main <Control-g> ::game::GotoMoveNumber

$m add command -label GameNovelty -command findNovelty
set helpMessage($m,[incr menuindex]) GameNovelty


### Search menu:
set menuindex -1
set m .menu.search
$m  add command -label SearchReset -acc "control-r" \
    -command ::search::filter::reset
bind .main <Control-r> ::search::filter::reset
set helpMessage($m,[incr menuindex]) SearchReset

$m  add command -label SearchNegate -acc "control-n" \
    -command ::search::filter::negate
bind .main <Control-n> ::search::filter::negate
set helpMessage($m,[incr menuindex]) SearchNegate

$m  add command -label SearchEnd -command ::search::filter::end
set helpMessage($m,[incr menuindex]) SearchEnd

$m  add separator
incr menuindex

$m  add command -label SearchHeader \
    -command ::search::header -accelerator "control-G"
set helpMessage($m,[incr menuindex]) SearchHeader

$m  add command -label SearchCurrent -command ::search::board
set helpMessage($m,[incr menuindex]) SearchCurrent

$m  add command -label SearchMaterial \
    -command ::search::material -accelerator "control-M"
bind .main <Control-M> ::search::material
set helpMessage($m,[incr menuindex]) SearchMaterial

$m add command -label SearchMoves -command ::search::moves
set helpMessage($m,[incr menuindex]) SearchMoves

$m  add separator
incr menuindex

$m add command -label WindowsPList -command ::plist::Open -accelerator "control-P"
set helpMessage($m,[incr menuindex]) WindowsPList

$m add command -label WindowsTmt -command ::tourney::Open -accelerator "control-T"
set helpMessage($m,[incr menuindex]) WindowsTmt

$m  add separator
incr menuindex

$m add command -label SearchUsing -command ::search::usefile
set helpMessage($m,[incr menuindex]) SearchUsing

### Play menu
set menuindex -1
set m .menu.play

$m add command -label ToolsTrainFics -command ::fics::config
set helpMessage($m,[incr menuindex]) ToolsTrainFics

$m add command -label ToolsTacticalGame -command ::tacgame::config
set helpMessage($m,[incr menuindex]) ToolsTacticalGame

$m add command -label ToolsSeriousGame -command ::sergame::config
set helpMessage($m,[incr menuindex]) ToolsSeriousGame

$m add command -label ToolsComp -command {compInit}
set helpMessage($m,[incr menuindex]) ToolsComp

$m add command -label ToolsTrainTactics -command ::tactics::config
set helpMessage($m,[incr menuindex]) ToolsTrainTactics

$m add separator
incr menuindex

# sub-menu for training
menu $m.training
$m add cascade -label ToolsTraining -menu $m.training
set helpMessage($m,[incr menuindex]) ToolsTraining
$m.training add command -label ToolsTrainCalvar -command ::calvar::config
$m.training add command -label ToolsTrainFindBestMove -command ::tactics::findBestMove

incr menuindex

# Add support for Correspondence Chess by means of Xfcc and cmail
menu $m.correspondence
$m add cascade -label CorrespondenceChess -menu $m.correspondence
set helpMessage($m,[incr menuindex]) CorrespondenceChess


$m.correspondence add command -label CCConfigure   -command {::CorrespondenceChess::config}
set helpMessage($m.correspondence,0) CCConfigure
$m.correspondence add command -label CCConfigRelay   -command {::CorrespondenceChess::ConfigureRelay}
set helpMessage($m.correspondence,1) CCConfigRelay

$m.correspondence add separator
$m.correspondence add command -label CCOpenDB      -command {::CorrespondenceChess::OpenCorrespondenceDB; ::CorrespondenceChess::ReadInbox} 
set helpMessage($m.correspondence,3) CCOpenDB

$m.correspondence add separator
$m.correspondence add command -label CCRetrieve    -command { ::CorrespondenceChess::FetchGames }
set helpMessage($m.correspondence,5) CCRetrieve

$m.correspondence add command -label CCInbox       -command { ::CorrespondenceChess::ReadInbox }
set helpMessage($m.correspondence,6) CCInbox

$m.correspondence add separator
$m.correspondence add command -label CCSend        -command {::CorrespondenceChess::SendMove 0 0 0 0}
set helpMessage($m.correspondence,8) CCSend
$m.correspondence add command -label CCResign      -command {::CorrespondenceChess::SendMove 1 0 0 0}
set helpMessage($m.correspondence,9) CCResign
$m.correspondence add command -label CCClaimDraw   -command {::CorrespondenceChess::SendMove 0 1 0 0}
set helpMessage($m.correspondence,10) CCClaimDraw
$m.correspondence add command -label CCOfferDraw   -command {::CorrespondenceChess::SendMove 0 0 1 0}
set helpMessage($m.correspondence,11) CCOfferDraw
$m.correspondence add command -label CCAcceptDraw  -command {::CorrespondenceChess::SendMove 0 0 0 1}
set helpMessage($m.correspondence,12) CCAcceptDraw
$m.correspondence add command -label CCGamePage    -command {::CorrespondenceChess::CallWWWGame}
set helpMessage($m.correspondence,13) CCGamePage
$m.correspondence add separator
$m.correspondence add command -label CCNewMailGame -command {::CorrespondenceChess::newEMailGame}
set helpMessage($m.correspondence,15) CCNewMailGame
$m.correspondence add command -label CCMailMove    -command {::CorrespondenceChess::eMailMove}
set helpMessage($m.correspondence,16) CCMailMove


### Windows menu:
set menuindex 0
set m .menu.windows

$m  add command -label WindowsGameinfo -accelerator "control-i" -command toggleGameInfo 
bind .main <Control-i> toggleGameInfo
set helpMessage($m,[incr menuindex]) WindowsGameinfo

$m  add command -label WindowsComment -command ::commenteditor::Open -accelerator "control-e"
set helpMessage($m,[incr menuindex]) WindowsComment

$m  add command -label WindowsGList -command ::windows::gamelist::Open -accelerator "control-l"
set helpMessage($m,[incr menuindex]) WindowsGList

$m  add command -label WindowsPGN -command ::pgn::Open  -accelerator "control-p"
set helpMessage($m,[incr menuindex]) WindowsPGN

$m  add command -label WindowsCross -command ::crosstab::Open  -accelerator "control-X"
set helpMessage($m,[incr menuindex]) WindowsCross

$m add command -label WindowsPList -command ::plist::Open -accelerator "control-P"
set helpMessage($m,[incr menuindex]) WindowsPList

$m add command -label WindowsTmt -command ::tourney::Open -accelerator "control-T"
set helpMessage($m,[incr menuindex]) WindowsTmt

$m add command -label WindowsMaint -accelerator "control-m" -command ::maint::Open
set helpMessage($m,[incr menuindex]) WindowsMaint

$m add separator
incr menuindex

$m add command -label WindowsECO -command ::windows::eco::Open
set helpMessage($m,[incr menuindex]) WindowsECO

$m add command -label WindowsStats -command ::windows::stats::Open
bind .main <Control-i> ::windows::stats::Open
set helpMessage($m,[incr menuindex]) WindowsStats

$m add command -label WindowsTree -command ::tree::Open -accelerator "control-t"
set helpMessage($m,[incr menuindex]) WindowsTree

$m add command -label WindowsTB -command ::tb::Open -accelerator "control-="
bind .main <Control-equal> ::tb::Open
set helpMessage($m,[incr menuindex]) WindowsTB

$m add command -label WindowsBook -command ::book::Open
set helpMessage($m,[incr menuindex]) WindowsBook

$m add command -label WindowsCorrChess -command ::CorrespondenceChess::CCWindow 

### Tools menu:

set menuindex -1
set m .menu.tools
$m  add command -label ToolsAnalysis \
    -command ::enginelist::choose -accelerator "control-A"
bind .main <Control-A> ::enginelist::choose
set helpMessage($m,[incr menuindex]) ToolsAnalysis

#Add Menu for Start Engine 1 and Engine 2
$m  add command -label ToolsStartEngine1 \
    -command "startAnalysisWin F2" -accelerator "F2"
bind .main <F2> "startAnalysisWin F2"
set helpMessage($m,[incr menuindex]) ToolsStartEngine1

$m  add command -label ToolsStartEngine2 \
    -command "startAnalysisWin F3" -accelerator "F3"
bind .main <F3> "startAnalysisWin F3"
set helpMessage($m,[incr menuindex]) ToolsStartEngine2

$m add separator
incr menuindex

# **********

menu $m.utils
$m add cascade -label ToolsMaint -menu .menu.tools.utils
set helpMessage($m,[incr menuindex]) ToolsMaint

$m.utils add command -label ToolsMaintWin -accelerator "control-m" -command ::maint::Open
set helpMessage($m.utils,0) ToolsMaintWin

$m.utils add command -label ToolsMaintNameEditor -command nameEditor 
set helpMessage($m.utils,0) ToolsMaintNameEditor

$m.utils add command -label ToolsMaintCompact -command makeCompactWin
set helpMessage($m.utils,1) ToolsMaintCompact

$m.utils add command -label ToolsMaintSort -command makeSortWin
set helpMessage($m.utils,3) ToolsMaintSort

$m.utils add separator

$m.utils add command -label ToolsMaintNamePlayer -command {openSpellCheckWin Player}
set helpMessage($m.utils,1) ToolsMaintNamePlayer

$m.utils add command -label ToolsMaintNameEvent -command {openSpellCheckWin Event}
set helpMessage($m.utils,2) ToolsMaintNameEvent

$m.utils add command -label ToolsMaintNameSite -command {openSpellCheckWin Site}
set helpMessage($m.utils.3) ToolsMaintNameSite

$m.utils add command -label ToolsMaintNameRound -command {openSpellCheckWin Round}
set helpMessage($m.utils,4) ToolsMaintNameRound

$m.utils add separator

$m.utils add command -label ToolsMaintDelete -state disabled -command markTwins
set helpMessage($m.utils,5) ToolsMaintDelete

$m.utils add command -label ToolsMaintTwin -command updateTwinChecker
set helpMessage($m.utils,6) ToolsMaintTwin

$m.utils add separator

$m.utils add command -label ToolsMaintFixBase -command ::maint::fixCorruptedBase
set helpMessage($m.utils,10) ToolsMaintFixBase

# **********

# book tuning
$m add command -label ToolsBookTuning -command ::book::tuning
set helpMessage($m,[incr menuindex]) ToolsBookTuning

$m add command -label ToolsPlayerReport -command ::preport::preportDlg
set helpMessage($m,[incr menuindex]) ToolsPlayerReport

$m add command -label ToolsOpReport -command ::optable::makeReportWin
set helpMessage($m,[incr menuindex]) ToolsOpReport

$m add command -label ToolsTracker -command ::ptrack::make
set helpMessage($m,[incr menuindex]) ToolsTracker

$m add command -label ToolsEmail -command ::tools::email
set helpMessage($m,[incr menuindex]) ToolsEmail

# Connect Hardware
menu $m.hardware
$m add cascade -label ToolsConnectHardware -menu $m.hardware
set helpMessage($m,[incr menuindex]) ToolsConnectHardware
incr menuindex

  $m.hardware add command -label ToolsConnectHardwareConfigure -command ::ExtHardware::config
  set helpMessage($m.hardware,0) ToolsConnectHardwareConfigure

  $m.hardware add command -label ToolsConnectHardwareNovagCitrineConnect -command ::novag::connect
  set helpMessage($m.hardware,1) ToolsConnectHardwareNovagCitrineConnect
  $m.hardware add command -label ToolsConnectHardwareInputEngineConnect -command ::inputengine::connectdisconnect
  set helpMessage($m.hardware,2) ToolsConnectHardwareInputEngineConnect

$m add separator
incr menuindex

$m add command -label ToolsFilterGraph -command tools::graphs::filter::Open
set helpMessage($m,[incr menuindex]) ToolsFilterGraph

$m add command -label ToolsAbsFilterGraph -accelerator "control-J" -command ::tools::graphs::absfilter::Open
bind .main <Control-J> ::tools::graphs::absfilter::Open
set helpMessage($m,[incr menuindex]) ToolsAbsFilterGraph

$m add command -label ToolsRating -command {::tools::graphs::rating::Refresh both}
set helpMessage($m,[incr menuindex]) ToolsRating

$m add command -label ToolsScore \
    -accelerator "control-Z" -command ::tools::graphs::score::Toggle
bind .main <Control-Z> ::tools::graphs::score::Toggle
set helpMessage($m,[incr menuindex]) ToolsScore

$m add separator
incr menuindex

menu $m.exportcurrent

$m add cascade -label ToolsExpCurrent -menu $m.exportcurrent
set helpMessage($m,[incr menuindex]) ToolsExpCurrent

$m.exportcurrent add command -label ToolsExpCurrentPGN -command {exportGames current PGN}
set helpMessage($m.exportcurrent,0) ToolsExpCurrentPGN

$m.exportcurrent add command -label ToolsExpCurrentHTML -command {exportGames current HTML}
set helpMessage($m.exportcurrent,1) ToolsExpCurrentHTML

$m.exportcurrent add command -label ToolsExpCurrentHTMLJS -command {::html::exportCurrentGame}
set helpMessage($m.exportcurrent,2) ToolsExpCurrentHTMLJS

$m.exportcurrent add command -label ToolsExpCurrentLaTeX -command {exportGames current Latex}
set helpMessage($m.exportcurrent,3) ToolsExpCurrentLaTeX

$m.exportcurrent add command -label ToolsExpCurrentLaTeX -command {
  ### $::scidLogDir must be usedhere, as previewLatex also looks there.
  ### and xelatex must be configure instead of pdflatex

  set latexFilename Game-Preview
  if {[exportGames current Latex [file join $::scidLogDir $latexFilename.tex]] != "0"} {
    update ; # todo - redraw . after progress window withdraws
    previewLatex $latexFilename {} .
  }
}

menu $m.exportfilter

$m add cascade -label ToolsExpFilter -menu $m.exportfilter
set helpMessage($m,[incr menuindex]) ToolsExpFilter

$m.exportfilter add command -label ToolsExpFilterPGN -command {exportGames filter PGN}
set helpMessage($m.exportfilter,0) ToolsExpFilterPGN

$m.exportfilter add command -label ToolsExpFilterHTML -command {exportGames filter HTML}
set helpMessage($m.exportfilter,1) ToolsExpFilterHTML

$m.exportfilter add command -label ToolsExpFilterHTMLJS -command {::html::exportCurrentFilter}
set helpMessage($m.exportfilter,2) ToolsExpFilterHTMLJS

$m.exportfilter add command -label ToolsExpFilterLaTeX -command {exportGames filter Latex}
set helpMessage($m.exportfilter,3) ToolsExpFilterLaTeX

$m.exportfilter add command -label ToolsExpFilterLatex -command {
  if {[sc_filter count] > 5} {
    tk_messageBox -type ok -icon info -title "Scid: Latex Preview" \
	-message {Latex Preview has a maximum of 5 games.}
  } else {
    set latexFilename Games-Preview
    if {[exportGames filter Latex [file join $::scidLogDir $latexFilename.tex]] != "0"} { 
      update
      previewLatex $latexFilename {} .
    }
  }
}

$m.exportfilter add command -label ToolsExpFilterGames -command openExportGList
set helpMessage($m.exportfilter,3) ToolsExpFilterGames

$m add separator
incr menuindex

$m add command -label ToolsImportOne -accelerator "control-I" -command importPgnGame
bind .main <Control-I> importPgnGame
set helpMessage($m,[incr menuindex]) ToolsImportOne

$m add command -label ToolsImportFile -command importPgnFile
set helpMessage($m,[incr menuindex]) ToolsImportFile

$m add separator
incr menuindex

$m add command -label ToolsScreenshot -command {boardToFile {} {}} -accelerator control-F12
bind .main <Control-Shift-F12> {boardToFile {} {}}
set helpMessage($m,[incr menuindex]) {Board Screenshot}


### Options menu:

set m .menu.options
set optMenus {windows theme colour entry fonts ginfo fics startup language numbers export}
set optLabels {Windows Theme Colour Moves Fonts GInfo Fics Startup Language Numbers Export}
set menuindex 0

$m add command -label OptionsBoard -command chooseBoardColors
set helpMessage($m,[incr menuindex]) OptionsBoard

$m add command -label OptionsToolbar -command configToolbar
set helpMessage($m,[incr menuindex]) OptionsToolbar

$m add command -label OptionsNames -command editMyPlayerNames
set helpMessage($m,[incr menuindex]) OptionsNames

$m add command -label OptionsRecent -command ::recentFiles::configure
set helpMessage($m,[incr menuindex]) OptionsRecent

$m add separator
incr menuindex

foreach menu $optMenus label $optLabels {
  $m add cascade -label Options$label -menu $m.$menu
  set helpMessage($m,[incr menuindex]) Options$label
}

$m add command -label OptionsECO -command ::windows::eco::LoadFile
set helpMessage($m,[incr menuindex]) OptionsECO

$m add command -label OptionsSpell -command readSpellCheckFile
set helpMessage($m,[incr menuindex]) OptionsSpell

$m add command -label OptionsTable -command setTableBaseDir
set helpMessage($m,[incr menuindex]) OptionsTable
if {![sc_info tb]} { $m entryconfigure 13 -state disabled }

# setTableBaseDir:
#    Prompt user to select a tablebase file; all the files in its
#    directory will be used.

proc setTableBaseDir {} {
  global initialDir tempDir
  set ftype { { "Tablebase files" {".emd" ".nbw" ".nbb"} } }

  set w .tablebaseDialog
  toplevel $w
  wm state $w withdrawn
  wm title $w Tablebases

  label $w.title -text "Select up to 4 tablebase directories:"
  pack $w.title -side top
  foreach i {1 2 3 4} {
    set tempDir(tablebase$i) $initialDir(tablebase$i)
    pack [frame $w.f$i] -side top -pady 3 -fill x -expand yes
    entry $w.f$i.e -width 30 -textvariable tempDir(tablebase$i)
    bindFocusColors $w.f$i.e
    button $w.f$i.b -text "..." -pady 2 -command [list chooseTableBaseDir $i]
    pack $w.f$i.b -side right -padx 2
    pack $w.f$i.e -side left -padx 2 -fill x -expand yes
  }
  addHorizontalRule $w
  pack [frame $w.b] -side top -fill x
  dialogbutton $w.b.ok -text OK -command "destroy $w ; openTableBaseDirs"
  dialogbutton $w.b.help -textvar ::tr(Help) -command "helpWindow TB"
  dialogbutton $w.b.cancel -textvar ::tr(Cancel) -command "destroy $w"
  pack $w.b.cancel $w.b.help $w.b.ok -side right -padx 5 -pady 3
  bind $w <Escape> "$w.b.cancel invoke"

  update
  placeWinOverParent $w .
  wm state $w normal
}

proc openTableBaseDirs {} {
  global initialDir tempDir
  set tableBaseDirs ""
  foreach i {1 2 3 4} {
    set tbDir [string trim $tempDir(tablebase$i)]
    if {$tbDir != ""} {
      if {$tableBaseDirs != ""} { append tableBaseDirs ";" }
      append tableBaseDirs [file nativename $tbDir]
    }
  }

  set npieces [sc_info tb $tableBaseDirs]
  foreach i {1 2 3 4} {
    set initialDir(tablebase$i) $tempDir(tablebase$i)
  }
  if {$npieces == 0} {
    set msg "No tablebases found."
  } else {
    set msg "Tablebases with up to $npieces pieces found.\n\nTo use these tablebases whenever you start Scid, select \"Save Options\" from the Options menu."
  }
  tk_messageBox -type ok -icon info -title "Scid: Tablebase results" \
      -message $msg

}
proc chooseTableBaseDir {i} {
  global tempDir

  set ftype { { "Tablebase files" {".emd" ".nbw" ".nbb"} } }
  set idir $tempDir(tablebase$i)
  if {$idir == ""} { set idir [pwd] }

  set fullname [tk_chooseDirectory -mustexist 1 -initialdir $idir -parent .tablebaseDialog \
      -title "Select a Tablebase directory"]
  if {$fullname == ""} { return }

  set tempDir(tablebase$i) $fullname
}

$m add command -label OptionsSounds -command ::utils::sound::OptionsDialog
set helpMessage($m,[incr menuindex]) OptionsSounds

$m add command -label OptionsBooksDir -command setBooksDir
set helpMessage($m,[incr menuindex]) OptionsBooksDir

$m add command -label OptionsTacticsBasesDir -command setTacticsBasesDir
set helpMessage($m,[incr menuindex]) OptionsTacticsBasesDir

proc setBooksDir {} {
  global scidBooksDir
  set dir [tk_chooseDirectory -initialdir $scidBooksDir -mustexist 1 -title "[tr Book] [tr Directory]"]
  if {$dir == ""} {
    return
  } else {
    set scidBooksDir $dir
  }
}

proc setTacticsBasesDir {} {
  global scidBasesDir
  set dir [tk_chooseDirectory -initialdir $scidBasesDir -mustexist 1 -title "Bases [tr Directory]"]
  if {$dir != ""} {
    set scidBasesDir $dir
  }
}

$m add separator
incr menuindex

if {$::docking::USE_DOCKING} {
  $m add command -label OptionsWindowsSaveLayout -command {
    ::docking::layout_save 1
    set autoLoadLayout 1
    .menu.options invoke [tr OptionsSave]
  }
}

$m add command -label OptionsSave -command {
  set optionF ""
  if {[catch {open [scidConfigFile options] w} optionF]} {
    tk_messageBox -title "Scid: Unable to write file" -type ok -icon warning \
        -message "Unable to write options file: [scidConfigFile options]\n$optionF"
  } else {
    puts $optionF "# Scid vs. PC (version $scidVersion) Options file"
    puts $optionF "# This file contains commands in the Tcl language format."
    puts $optionF "# If you edit this file, you must preserve valid its Tcl"
    puts $optionF "# format or it will not set your Scid options properly."
    puts $optionF ""

  foreach i {boardSize boardStyle language ::pgn::showColor 
    ::pgn::indentVars ::pgn::indentComments ::defaultBackground ::::defaultGraphBackgroud ::enableBackground
    ::pgn::shortHeader ::pgn::boldMainLine ::pgn::stripMarks 
    ::pgn::symbolicNags ::pgn::moveNumberSpaces ::pgn::columnFormat ::pgn::showScrollbar
    myPlayerNames optionsAutoSave ::tree::mask::recentMask ::tree::mask::autoLoadMask ::tree::showBar ::tree::short ::tree::sortBest
    ecoFile suggestMoves showVarPopup showVarArrows 
    annotate(blunder) annotate(addTag) annotate(Moves) annotate(WithVars) annotate(WithScore) useAnalysisBook annotate(isVar) annotate(scoreType) annotate(cutoff)
    annotate(WantedDepth) annotate(Depth) autoplayDelay animateDelay boardCoords boardSTM 
    moveEntry(AutoExpand) moveEntry(Coord)
    translatePieces highlightLastMove highlightLastMoveWidth highlightLastMoveColor 
    askToReplaceMoves ::windows::switcher::icons ::windows::switcher::confirmCopy locale(numeric) 
    spellCheckFile ::splash::keepopen autoRaise autoIconify windowsDock autoLoadLayout
    exportFlags(comments) exportFlags(space) exportFlags(vars) exportFlags(indentc)
    exportFlags(indentv) exportFlags(column) exportFlags(htmldiag) exportFlags(utf8)
    email(smtp) email(smproc) email(server) 
    email(from) email(bcc) ::windows::gamelist::findcase ::windows::gamelist::showButtons
    gameInfo(show) gameInfo(photos) gameInfo(wrap) gameInfo(showStatus) 
    gameInfo(fullComment) gameInfo(showMarks) gameInfo(showMenu) gameInfo(showTool) 
    gameInfo(showMaterial) gameInfo(showFEN) gameInfo(showButtons) gameInfo(showTB) 
    analysis(mini) engines(F2) engines(F3) engines(F4) analysis(logMax) analysis(logName) analysis(maxPly) analysis(lowPriority)
    scidBooksDir scidBasesDir 
    ::book::lastBook1 ::book::lastBook2 ::book::lastTuning ::book::sortAlpha 
    ::book::showTwo ::book::oppMovesVisible ::gbrowser::size 
    crosstab(type) crosstab(ages) crosstab(countries) crosstab(ratings) crosstab(titles) crosstab(breaks) crosstab(colorrows)
    crosstab(deleted) crosstab(colors) crosstab(cnumbers) crosstab(groups) crosstab(sort) crosstab(tallies) crosstab(tiewin) crosstab(tiehead)
    ::utils::sound::soundFolder ::utils::sound::announceNew ::utils::sound::announceTock
    ::utils::sound::announceForward ::utils::sound::announceBack ::utils::sound::device
    ::tacgame::threshold ::tacgame::levelMin  ::tacgame::levelMax  ::tacgame::levelFixed ::tacgame::randomLevel 
    ::tacgame::showblunder ::tacgame::showblundervalue 
    ::tacgame::showblunderfound ::tacgame::showmovevalue ::tacgame::showevaluation 
    ::tacgame::isLimitedAnalysisTime ::tacgame::analysisTime ::tacgame::openingType ::tacgame::chosenOpening
    ::sergame::bookToUse ::sergame::useBook ::sergame::startFromCurrent 
    ::sergame::winc ::sergame::wtime ::sergame::binc ::sergame::btime
    ::sergame::timeMode ::sergame::movetime ::sergame::current ::sergame::chosenOpening ::sergame::isOpening
    ::commenteditor::showBoard ::commenteditor::State(markColor) ::commenteditor::State(markType) boardfile_lite boardfile_dark 
    ::file::finder::data(dir) ::file::finder::data(sort) ::file::finder::data(recurse) 
    ::file::finder::data(Scid) ::file::finder::data(PGN) 
    ::file::finder::data(EPD) ::file::finder::data(Old) 
    FilterMaxMoves FilterMinMoves FilterStepMoves FilterMaxElo FilterMinElo FilterStepElo 
    FilterMaxYear FilterMinYear FilterStepYear FilterGuessELO lookTheme autoResizeBoard
    comp(timecontrol) comp(seconds) comp(base) comp(incr) comp(timeout) comp(name) comp(usebook) comp(book)
    comp(rounds) comp(showclock) comp(debug) comp(animate) comp(firstonly) comp(ponder) comp(showscores)
    ::tools::graphs::filter::type  ::tools::graphs::absfilter::type ::tools::graphs::showpoints
    maintFlag useGraphFigurine photosMinimized bookmarks(gamehistory) playerInfoHistory
    glistSize glexport glistColOrder glistColWidth glistColAnchor addRatings(overwrite) addRatings(filter)} {

      puts $optionF "set $i [list [set $i]]"

    }
    puts $optionF ""
    foreach i [lsort [array names winWidth]] {
      puts $optionF "set winWidth($i)  [expr $winWidth($i)]"
      puts $optionF "set winHeight($i) [expr $winHeight($i)]"
    }
    puts $optionF ""
    foreach i [lsort [array names winX]] {
      puts $optionF "set winX($i)  [expr $winX($i)]"
      puts $optionF "set winY($i)  [expr $winY($i)]"
    }
    puts $optionF ""
    puts $optionF "set analysisCommand [list $analysisCommand]"
    puts $optionF ""
    foreach i {lite dark highcolor bestcolor bgcolor maincolor varcolor rowcolor progcolor switchercolor borderwidth \
          pgnColor(Header) pgnColor(Main) pgnColor(Var) \
          pgnColor(Nag) pgnColor(Comment) pgnColor(Background) \
          pgnColor(Current) pgnColor(NextMove) } {
      puts $optionF "set $i [list [set $i]]"
    }
    puts $optionF ""
    foreach i [lsort [array names optable]] {
      puts $optionF "set optable($i) [list $optable($i)]"
    }
    foreach i [lsort [array names startup]] {
      puts $optionF "set startup($i) [list $startup($i)]"
    }
    foreach i [lsort [array names toolbar]] {
      puts $optionF "set toolbar($i) [list $toolbar($i)]"
    }
    foreach i [lsort [array names twinSettings]] {
      puts $optionF "set twinSettings($i) [list $twinSettings($i)]"
    }
    foreach i [lsort [array names cleaner]] {
      puts $optionF "set cleaner($i) [list $cleaner($i)]"
    }
    puts $optionF ""
    foreach i {Regular Menu Small Tiny Fixed} {
      puts $optionF "set fontOptions($i) [list $fontOptions($i)]"
    }
    foreach type {base book html tex epd stm sso pgn report tablebase1 tablebase2 tablebase3 tablebase4} {
      puts $optionF "set initialDir($type) [list $initialDir($type)]"
    }
    puts $optionF ""
    foreach type {PGN HTML Latex} {
      puts $optionF "set exportStartFile($type) [list $exportStartFile($type)]"
      puts $optionF "set exportEndFile($type) [list $exportEndFile($type)]"
    }
    puts $optionF ""
    foreach type {engine viewer} {
      puts $optionF "set latexRendering($type) [list $latexRendering($type)]"
    }
    puts $optionF ""
    foreach i [lsort [array names informant]] {
      puts $optionF "set informant($i) [list $informant($i)]"
    }
    puts $optionF ""

    # save FICS config
    foreach i { use_timeseal timeseal_exec port_fics port_timeseal login password consolebg consolefg chanoff shouts server_ip consolebg consolefg autopromote autoraise size sound no_results no_requests server init_commands show_buttons allow_premove user_buttons user_commands} {
      puts $optionF "set ::fics::$i [list [set ::fics::$i]]"
    }
    foreach i [lsort [array names ::fics::findopponent]] {
      puts $optionF "set ::fics::findopponent($i) [list $::fics::findopponent($i)]"
    }

    # save Window Docking layouts
    foreach slot {1 2 3 4 5} {
      puts $optionF "set ::docking::layout_list($slot) [list $::docking::layout_list($slot)]"
    }

    close $optionF
    set ::statusBar "Options were saved to: [scidConfigFile options]"
  }
}
set helpMessage($m,[incr menuindex]) OptionsSave

$m add checkbutton -label OptionsAutoSave -variable optionsAutoSave
set helpMessage($m,[incr menuindex]) OptionsAutoSave

menu $m.ginfo -tearoff 1
$m.ginfo add checkbutton -label GInfoHideNext \
    -variable gameInfo(hideNextMove) -offvalue 0 -onvalue 1 -command updateBoard
$m.ginfo add checkbutton -label GInfoShow \
    -variable boardSTM -offvalue 0 -onvalue 1 -command {::board::togglestm .main.board}
$m.ginfo add checkbutton -label GInfoFEN \
    -variable gameInfo(showFEN) -offvalue 0 -onvalue 1 -command checkGameInfoHeight
$m.ginfo add checkbutton -label GInfoMarks \
    -variable gameInfo(showMarks) -offvalue 0 -onvalue 1 -command updateBoard
$m.ginfo add checkbutton -label GInfoWrap \
    -variable gameInfo(wrap) -offvalue 0 -onvalue 1 -command updateBoard
$m.ginfo add checkbutton -label GInfoFullComment \
    -variable gameInfo(fullComment) -offvalue 0 -onvalue 1 -command updateBoard
$m.ginfo add checkbutton -label GInfoPhotos \
    -variable gameInfo(photos) -offvalue 0 -onvalue 1 \
    -command {updatePlayerPhotos -force}
$m.ginfo add command -label GInfoMaterial -command toggleMat
$m.ginfo add command -label GInfoCoords -command toggleCoords
$m.ginfo add separator
$m.ginfo add radiobutton -label GInfoTBNothing \
    -variable gameInfo(showTB) -value 0 -command checkGameInfoHeight
$m.ginfo add radiobutton -label GInfoTBResult \
    -variable gameInfo(showTB) -value 1 -command checkGameInfoHeight
$m.ginfo add radiobutton -label GInfoTBAll \
    -variable gameInfo(showTB) -value 2 -command checkGameInfoHeight
$m.ginfo add separator
$m.ginfo add command -label GInfoInformant -command configInformant

menu $m.entry -tearoff 1
$m.entry add checkbutton -label OptionsMovesAsk \
    -variable askToReplaceMoves -offvalue 0 -onvalue 1
set helpMessage($m.entry,0) OptionsMovesAsk \

$m.entry add checkbutton -label OptionsMovesShowVarArrows \
    -variable showVarArrows -offvalue 0 -onvalue 1
set helpMessage($m.entry,10) OptionsMovesShowVarArrows

$m.entry add checkbutton -label OptionsShowVarPopup \
    -variable showVarPopup -offvalue 0 -onvalue 1
set helpMessage($m.entry,6) OptionsShowVarPopup

menu $m.entry.highlightlastmove -tearoff 1
$m.entry add cascade -label OptionsMovesHighlightLastMove -menu  $m.entry.highlightlastmove
$m.entry.highlightlastmove add checkbutton -label OptionsMovesHighlightLastMoveDisplay -variable ::highlightLastMove -command updateBoard
menu $m.entry.highlightlastmove.width
$m.entry.highlightlastmove add cascade -label OptionsMovesHighlightLastMoveWidth -menu $m.entry.highlightlastmove.width
foreach i {1 2 3 4 5} {
  $m.entry.highlightlastmove.width add radiobutton -label $i -value $i -variable ::highlightLastMoveWidth -command updateBoard
}
$m.entry.highlightlastmove add command -label OptionsMovesHighlightLastMoveColor -command {
  set col [ tk_chooseColor -initialcolor $::highlightLastMoveColor -title "Scid"]
  if { $col != "" } {
    set ::highlightLastMoveColor $col
    updateBoard
  }
}
set helpMessage($m.entry,9) OptionsMovesHighlightLast

$m.entry add cascade -label OptionsMovesAnimate -menu $m.entry.animate
menu $m.entry.animate -tearoff 1
foreach i {0 100 150 200 250 300 400 500 600 800 1000} {
  $m.entry.animate add radiobutton -label "$i ms" \
      -variable animateDelay -value $i
}
set helpMessage($m.entry,1) OptionsMovesAnimate

$m.entry add separator

$m.entry add command -label OptionsMovesDelay -command setAutoplayDelay
set helpMessage($m.entry,2) OptionsMovesDelay

$m.entry add checkbutton -label OptionsMovesCoord \
    -variable moveEntry(Coord) -offvalue 0 -onvalue 1
set helpMessage($m.entry,3) OptionsMovesCoord

$m.entry add checkbutton -label OptionsMovesKey \
    -variable moveEntry(AutoExpand) -offvalue 0 -onvalue 1
set helpMessage($m.entry,4) OptionsMovesKey

$m.entry add checkbutton -label OptionsMovesSuggest \
    -variable suggestMoves -offvalue 0 -onvalue 1
set helpMessage($m.entry,5) OptionsMovesSuggest

$m.entry add checkbutton -label OptionsMovesSpace \
    -variable ::pgn::moveNumberSpaces -offvalue 0 -onvalue 1
set helpMessage($m.entry,7) OptionsMovesSpace

$m.entry add checkbutton -label OptionsMovesTranslatePieces \
    -variable ::translatePieces -offvalue 0 -onvalue 1 -command setLanguage
set helpMessage($m.entry,8) OptionsMovesTranslatePieces

proc updateLocale {} {
  global locale
  sc_info decimal $locale(numeric)
  ### Don't know why this is happening, but it causes two
  ### Refreshes when window is opened at startup
  # ::windows::gamelist::Refresh
  updateTitle
}

set m .menu.options.numbers
menu $m -tearoff 1
foreach numeric {".,"   ". "   "."   ",."   ", "   ","} \
    underline {  0     1      2     4      5      6} {
      set decimal [string index $numeric 0]
      set thousands [string index $numeric 1]
      $m add radiobutton -label "12${thousands}345${decimal}67" \
      -underline $underline \
      -variable locale(numeric) -value $numeric -command updateLocale
    }


set m .menu.options.fics
menu $m -tearoff 1
$m add checkbutton -label OptionsWindowsRaise -variable ::fics::autoraise
$m add checkbutton -label OptionsFicsAuto     -variable ::fics::autopromote
$m add checkbutton -label OptionsSounds       -variable ::fics::sound
$m add command     -label OptionsFicsColour   -command ::fics::setForeGround
$m add command     -label OptionsColour       -command ::fics::setBackGround
$m add command     -label OptionsFonts        -command {
  set fontOptions(temp) [FontDialog Fixed]
  if {$fontOptions(temp) != ""} { set fontOptions(Fixed) $fontOptions(temp) }
}
$m add command     -label OptionsFicsButtons  -command ::fics::editUserButtons
$m add command     -label OptionsFicsCommands -command ::fics::editInitCommands
$m add cascade     -label OptionsFicsSize     -menu $m.size
$m add separator
$m add checkbutton -label OptionsFicsNoRes    -variable ::fics::no_results
$m add checkbutton -label OptionsFicsNoReq    -variable ::fics::no_requests
$m add checkbutton -label OptionsFicsPremove  -variable ::fics::allow_premove

menu $m.size -tearoff 1
if {$::fics::size > 5} {set ::fics::size 3} ; # ::fics::size used to be 25 to 50, but now is a radiobutton
foreach i {1 2 3 4 5} {
  $m.size add radiobutton -label $i -value $i -variable ::fics::size -command ::fics::changeScaleSize
}

set m .menu.options.export
menu $m -tearoff -1
foreach format {PGN HTML Latex} {
  $m add command -label $format -underline 0 \
      -command "setExportText $format"
}

###############################
set m .menu.options.windows
menu $m -tearoff -1

$m add checkbutton -label OptionsWindowsDock -variable windowsDock -command {
  if {$::docking::USE_DOCKING != $windowsDock} {
    set answer [tk_messageBox -type yesno -icon info -title Scid -message "Changing Docking requires a restart.\nExit now ?"]
    if {$answer == "yes"} {
      ::file::Exit
    }
  }
}
set helpMessage($m,2) OptionsWindowsDock

if {$::docking::USE_DOCKING} {
  $m add checkbutton -label OptionsWindowsAutoLoadLayout -variable autoLoadLayout 
  set helpMessage($m,4) OptionsWindowsAutoLoadLayout

  $m add checkbutton -label OptionsWindowsAutoResize -variable ::autoResizeBoard -command {
     if {$::autoResizeBoard} {resizeMainBoard}
  }
  set helpMessage($m,4) OptionsWindowsAutoLoadLayout

  menu $m.savelayout
  menu $m.restorelayout
  foreach i {"1 (default)" "2 (custom)" "3 (analysis)" "4 (sa)" 5} slot {1 2 3 4 5} {
    $m.savelayout add command -label $i -command "::docking::layout_save $slot"
    $m.restorelayout add command -label $i -command "::docking::layout_restore $slot"
  }
  $m add cascade -label OptionsWindowsSaveLayout -menu $m.savelayout
  set helpMessage($m,5) OptionsWindowsSaveLayout
  $m add cascade -label OptionsWindowsRestoreLayout -menu $m.restorelayout
  set helpMessage($m,6) OptionsWindowsRestoreLayout
}

$m add separator

$m add checkbutton -label OptionsWindowsIconify -variable autoIconify
set helpMessage($m,0) OptionsWindowsIconify
$m add checkbutton -label OptionsWindowsRaise -variable autoRaise
set helpMessage($m,1) OptionsWindowsRaise
$m add command -label OptionsWindowsFullScreen -command toggleFullScreen -accelerator F11
set helpMessage($m,1) OptionsWindowsFullScreen

set m .menu.options.theme
menu $m -tearoff -1
foreach i [ttk::style theme names] {
  $m add radiobutton -label "$i" -value $i -variable ::lookTheme -command changeTheme
}

proc changeTheme {} {
    ttk::style theme use $::lookTheme
    if {$::enableBackground} {
      ::ttk::style configure Treeview -background $::defaultBackground
      ::ttk::style configure Treeview -fieldbackground $::defaultBackground
    }
    ::ttk::style configure TNotebook.Tab -font font_Menu
}

set m .menu.options.colour
menu $m -tearoff -1

$m add command -label OptionsMainLineColour -command SetMainLineColour
set helpMessage($m,1) OptionsMainLineColour
$m add command -label OptionsVarLineColour -command SetVarLineColour
set helpMessage($m,1) OptionsVarLineColour
$m add command -label OptionsRowColour -command SetRowBackgroundColour
set helpMessage($m,1) OptionsRowColour
$m add command -label OptionsSwitcherColour -command SetRowSwitcherColour
set helpMessage($m,1) OptionsSwitcherColour
$m add command -label OptionsProgressColour -command SetProgressColour
set helpMessage($m,1) OptionsProgressColour
$m add command -label OptionsCrossColour -command SetCrossColour
set helpMessage($m,1) OptionsCrossColour

$m add separator

$m add checkbutton -label OptionsEnableColour -variable enableBackground -command {
  if {$::enableBackground} {
    initBackgroundColour $defaultBackground
  } else {
    initBackgroundColour grey95
  }
}
$m add command -label OptionsBackColour -command SetBackgroundColour
set helpMessage($m,1) OptionsBackColour

proc SetBackgroundColour {} {
  global defaultBackground enableBackground
  set temp [tk_chooseColor -initialcolor $defaultBackground -title [tr OptionsBackColour]]
  if {$temp != {}} {
    set defaultBackground $temp
    set enableBackground 1
    option add *Text*background $temp
    option add *Listbox*background $temp
    .main.gameInfo configure -bg $temp
    initBackgroundColour $defaultBackground
  }
}

proc SetMainLineColour {} {
  global maincolor
  set temp [tk_chooseColor -initialcolor $maincolor -title [tr OptionsMainLineColour]]
  if {$temp != {}} {
    set maincolor $temp
    updateBoard
    if {[::move::drawVarArrows]} { ::move::showVarArrows }
  }
}

proc SetVarLineColour {} {
  global varcolor
  set temp [tk_chooseColor -initialcolor $varcolor -title [tr OptionsVarLineColour]]
  if {$temp != {}} {
    set varcolor $temp
    updateBoard
    if {[::move::drawVarArrows]} { ::move::showVarArrows }
  }
}

proc SetRowBackgroundColour {} {
  global rowcolor
  set temp [tk_chooseColor -initialcolor $rowcolor -title [tr OptionsRowColour]]
  if {$temp != {}} {
    set rowcolor $temp
    # todo
    # ::tree::refresh
    # if {[winfo exists .crosstabWin.f.text]} {.crosstabWin.f.text tag configure rowColor -background $::rowcolor}
    if {[winfo exists .bookTuningWin]} {::book::refreshTuning}
    if {[winfo exists .bookWin] } {::book::refresh}
  }
}

proc SetRowSwitcherColour {} {
  global switchercolor
  set temp [tk_chooseColor -initialcolor $switchercolor -title [tr OptionsSwitcherColour]]
  if {$temp != {}} {
    set switchercolor $temp
    ::windows::switcher::Refresh
  }
}

proc SetProgressColour {} {
  global progcolor
  set temp [tk_chooseColor -initialcolor $progcolor -title [tr OptionsProgressColour]]
  if {$temp != {}} {
    set progcolor $temp
  }
}

proc SetCrossColour {} {
  global crosscolor
  set temp [tk_chooseColor -initialcolor $crosscolor -title [tr OptionsCrossColour]]
  if {$temp != {}} {
    set crosscolor $temp
    ::crosstab::Refresh
  }
}

proc initBackgroundColour {colour} {
    # border around gameinfo photos
    .main.photoW configure -background $colour
    .main.photoB configure -background $colour
    ::ttk::style configure Treeview -background $colour
    ::ttk::style configure Treeview -fieldbackground $colour
    option add *Text*background $colour
    option add *Listbox*background $colour
    # Updating padding in tree would be nice, but now they have to close and re-open tree
    # if {[winfo exists .baseWin.c]} { .baseWin.c configure -bg $temp }
    recurseBackgroundColour . $colour
    set ::defaultGraphBackgroud $colour
    foreach i {.sgraph .rgraph .fgraph .afgraph} {
      if {[winfo exists $i.c]} {
        $i.c itemconfigure fill -fill $colour
      }
    }
}

proc recurseBackgroundColour {w colour} {
     if {[winfo class $w] == "Text" || [winfo class $w] == "Listbox"} {
         $w configure -background $colour
     } else {
       foreach c [winfo children $w] {
	   recurseBackgroundColour $c $colour
       }
     }
}

###############################

menu .menu.options.language -tearoff -1
initLanguageMenus

set m .menu.options.fonts
menu $m -tearoff -1

$m add command -label OptionsFontsRegular -underline 0 -command {
    FontDialogRegular .
}

$m add command -label OptionsFontsMenu -underline 0 -command {
    FontDialogMenu .
}

$m add command -label OptionsFontsSmall -underline 0 -command {
    FontDialogSmall .
}

$m add command -label OptionsFontsFixed -underline 0 -command {
    FontDialogFixed .
}

set helpMessage($m,0) OptionsFontsRegular
set helpMessage($m,1) OptionsFontsMenu
set helpMessage($m,2) OptionsFontsSmall
set helpMessage($m,3) OptionsFontsFixed

set m .menu.options.startup
menu $m -tearoff -1
$m add checkbutton -label HelpTip -variable startup(tip)
$m add checkbutton -label HelpStartup -variable ::splash::keepopen
$m add checkbutton -label WindowsCross -variable startup(crosstable)
$m add checkbutton -label FileFinder -variable startup(finder)
$m add checkbutton -label WindowsGList -variable startup(gamelist)
$m add checkbutton -label WindowsPGN -variable startup(pgn)
$m add checkbutton -label WindowsStats -variable startup(stats)
$m add checkbutton -label WindowsTree -variable startup(tree)
$m add checkbutton -label WindowsBook -variable startup(book)
$m add checkbutton -label FICS -variable startup(fics)


### Help menu:
set menuindex 0
set m .menu.help
$m add command -label HelpContents -command {helpWindow Contents} -accelerator "F1"
set helpMessage($m,[incr menuindex]) HelpContents

$m add command -label HelpIndex -command {helpWindow Index}
set helpMessage($m,[incr menuindex]) HelpIndex

$m add separator
incr menuindex
# $m add command -label HelpIndex -command {helpWindow Index}
# set helpMessage($m,[incr menuindex]) HelpIndex
# $m add command -label HelpGuide -command {helpWindow Guide}
# set helpMessage($m,[incr menuindex]) HelpGuide
# $m add command -label HelpHints -command {helpWindow Hints}
# set helpMessage($m,[incr menuindex]) HelpHints
# 
# $m add separator
# incr menuindex

$m add command -label HelpTip -command ::tip::show
set helpMessage($m,[incr menuindex]) HelpTip
$m add command -label HelpStartup -command raiseSplashWindow

proc raiseSplashWindow {} {
  # .splash window is never destroyed !!
  wm deiconify .splash
  raiseWin .splash
}
set helpMessage($m,[incr menuindex]) HelpStartup

$m add separator
incr menuindex

$m add command -label Changelog -command {helpWindow Changelog}
incr menuindex
$m  add command -label HelpAbout -command {helpWindow Author}
set helpMessage($m,[incr menuindex]) HelpAbout

bind .main <F1> toggleHelp
bind .main <Control-Key-quoteleft> {::file::SwitchToBase 9}
bind .main <Control-Tab> ::file::SwitchToNextBase
bind .main <Control-f> {if {!$tree(refresh)} {toggleRotateBoard}}

catch {
  if {$windowsOS} {
    bind .main <Shift-Tab> {::file::SwitchToNextBase -1} 
  } else {
    bind .main <ISO_Left_Tab> {::file::SwitchToNextBase -1} 
  }
}

##################################################

# updateMenuStates:
#   Update all the menus, rechecking which state each item should be in.

proc updateMenuStates {} {
  global totalBaseSlots windowsOS dot_w

  set ::currentSlot [sc_base current]
  set lang $::language
  set m .menu

  # Switch to database number $i
  set current [sc_base current]
  $m.file.switch delete 0 9
  
  for {set i 1} { $i <= $totalBaseSlots } { incr i } {
    set fname [file tail [sc_base filename $i]]

    # Only show menu items for open database slots
    if {$fname != {[empty]} } {
      $m.file.switch add command -command "set currentSlot $i" \
	  -label "$fname" -underline 5 -accelerator "control-$i" \
          -command "::file::SwitchToBase $i"
      bind .main <Control-Key-$i> "::file::SwitchToBase $i"

      if {$i == $current} {
	$m.file.switch entryconfig $i -state disabled
      }
    }
  }

  foreach i {Compact Delete} {
    $m.tools.utils entryconfig [tr ToolsMaint$i] -state disabled
  }
  foreach i {Editor Player Event Site Round} {
    $m.tools.utils entryconfig [tr ToolsMaintName$i] -state disabled
  }

  $m.file entryconfig [tr FileReadOnly] -state disabled

  # Recent Tree list (open base as Tree)
  ::recentFiles::treeshow .menu.file.recenttrees

  # Remove and reinsert the Recent files list and Exit command
  $m.file add separator
  set idx 12
  $m.file delete $idx end
  if {[::recentFiles::show $m.file] > 0} {
    $m.file add separator
  }
  set idx [$m.file index end]
  incr idx
  $m.file add command -label [tr FileExit] -accelerator "control-q" \
      -command ::file::Exit
  set helpMessage($m.file,$idx) FileExit

  # File menu entry states
  if {[sc_base inUse]} {
    set isReadOnly [sc_base isReadOnly]
    $m.file entryconfig [tr FileClose] -state normal
    if {! $isReadOnly} {
      $m.tools.utils entryconfig [tr ToolsMaintDelete] -state normal
      foreach i {Editor Player Event Site Round} {
        $m.tools.utils entryconfig [tr ToolsMaintName$i] -state normal
      }
      $m.file entryconfig [tr FileReadOnly] -state normal
      $m.game entryconfig [tr GameInfo] -state normal
    } else {
      $m.game entryconfig [tr GameInfo] -state disabled
    }

    # Load first/last/random buttons
    set filtercount [sc_filter count]
    if {$filtercount == 0} {
      set state disabled
    } else {
      set state normal
    }
    $m.game entryconfig [tr GameFirst] -state $state
    $m.game entryconfig [tr GameLast] -state $state
    $m.game entryconfig [tr GameRandom] -state $state
    $m.game entryconfig [tr GameNumber] -state $state
    $m.game entryconfig [tr GamePrev] -state $state
    $m.game entryconfig [tr GameNext] -state $state
    # .main.tb.gprev configure -state $state
    # .main.tb.gnext configure -state $state

    # Reload and Delete
    if {[sc_game number]} {
      set state normal
    } else {
      set state disabled
    }
    $m.game entryconfig [tr GameReload] -state $state
    if {$isReadOnly} {
      set state disabled
    }
    $m.game entryconfig [tr GameDelete] -state $state

    # Save add button
    if {$isReadOnly  ||  $::trialMode} {
      set state disabled
    } else {
      set state normal
    }
    $m.game entryconfig [tr GameAdd] -state $state

    # Save replace button
    if {[sc_game number] == 0  ||  $isReadOnly  ||  $::trialMode} {
      set state disabled
    } else {
      set state normal
    }
    $m.game entryconfig [tr GameReplace] -state $state

  } else {
    # Base is not in use
    $m.file entryconfig [tr FileClose] -state disabled

    # This gets called *occasionally* after closing tree and others (?)
    # but dont disable 'Info Browse List' as they never get re-enabled !
    foreach i {Replace Add First Prev Reload Next Last Random Number Info Browse List Delete} {
      $m.game entryconfig [tr Game$i] -state disabled
    }
    # .main.tb.gprev configure -state disabled
    # .main.tb.gnext configure -state disabled
  }

  if {[sc_base numGames] == 0} {
    $m.tools entryconfig [tr ToolsExpFilter] -state disabled
  } else {
    $m.tools entryconfig [tr ToolsExpFilter] -state normal
  }

  if {[baseIsCompactable]} {
    set state normal
  } else {
    set state disabled
  }
  $m.tools.utils entryconfig [tr ToolsMaintCompact] -state $state

  ::search::Config
  ::maint::Refresh
  ::bookmarks::Refresh
}


### Language menu support functions.

#   Reconfigures the main window menus. Called when the language is changed.

proc configMenuText {menu entry tag lang} {
  global menuLabel menuUnder
  if {[info exists menuLabel($lang,$tag)] && [info exists menuUnder($lang,$tag)]} {
    $menu entryconfig $entry -label $menuLabel($lang,$tag) \
        -underline $menuUnder($lang,$tag)
  } else {
    $menu entryconfig $entry -label $menuLabel(E,$tag) \
        -underline $menuUnder(E,$tag)
  }
}

proc setLanguageMenus {{lang ""}} {
  global menuLabel menuUnder oldLang

  if {$lang == ""} {set lang $::language}

  foreach tag {CorrespondenceChess ToolsTraining ToolsTacticalGame ToolsSeriousGame ToolsTrainFics ToolsComp ToolsTrainTactics} {
    configMenuText .menu.play [tr $tag $oldLang] $tag $lang
  }

  foreach tag {TrainCalvar TrainFindBestMove} {
    configMenuText .menu.play.training [tr Tools$tag $oldLang] Tools$tag $lang
  }

  foreach tag { CCConfigure CCConfigRelay CCOpenDB CCRetrieve CCInbox \
        CCSend CCResign CCClaimDraw CCOfferDraw CCAcceptDraw   \
        CCNewMailGame CCMailMove CCGamePage } {
    configMenuText .menu.play.correspondence [tr $tag $oldLang] $tag $lang
  }

  foreach tag {File Edit Game Search Play Windows Tools Options Help} {
    configMenuText .menu [tr $tag $oldLang] $tag $lang
  }

  foreach tag {New Open SavePgn OpenBaseAsTree OpenRecentBaseAsTree Close Finder Bookmarks ReadOnly Switch Exit} {
    configMenuText .menu.file [tr File$tag $oldLang] File$tag $lang
  }

  foreach tag {PastePGN Setup CopyBoard CopyPGN PasteBoard Reset Copy Paste Add Delete First Main Trial Strip PasteVar Undo Redo} {
    configMenuText .menu.edit [tr Edit$tag $oldLang] Edit$tag $lang
  }
  foreach tag {Comments Vars Begin End} {
    configMenuText .menu.edit.strip [tr EditStrip$tag $oldLang] \
        EditStrip$tag $lang
  }
  foreach tag {Reset Negate End Material Moves Current Header Using} {
    configMenuText .menu.search [tr Search$tag $oldLang] Search$tag $lang
  }
  
  # These two items still appear in windows menu
  configMenuText .menu.search [tr WindowsPList $oldLang] WindowsPList $lang
  configMenuText .menu.search [tr WindowsTmt $oldLang] WindowsTmt $lang

  foreach tag {Replace Add New First Prev Reload Next Last Random Number Info Browse List Delete
    Deepest GotoMove Novelty} {
    configMenuText .menu.game [tr Game$tag $oldLang] Game$tag $lang
  }

  foreach tag {Gameinfo Comment GList PGN Cross PList Tmt Maint ECO Stats Tree TB Book CorrChess } {
    configMenuText .menu.windows [tr Windows$tag $oldLang] Windows$tag $lang
  }

  foreach tag {Analysis Maint Email FilterGraph AbsFilterGraph OpReport Tracker
    Rating Score ExpCurrent ExpFilter ImportOne ImportFile StartEngine1 StartEngine2 BookTuning
    PlayerReport ConnectHardware Screenshot} {
    configMenuText .menu.tools [tr Tools$tag $oldLang] Tools$tag $lang
  }

  foreach tag {Win Compact Delete Twin Sort FixBase} {
    # Maintenance used to be in .menu.file but is now in .menu.tools
    configMenuText .menu.tools.utils [tr ToolsMaint$tag $oldLang] \
        ToolsMaint$tag $lang
  }
  foreach tag {Editor Player Event Site Round} {
    configMenuText .menu.tools.utils [tr ToolsMaintName$tag $oldLang] \
        ToolsMaintName$tag $lang
  }

  foreach tag {ToolsExpCurrentPGN ToolsExpCurrentHTML ToolsExpCurrentHTMLJS ToolsExpCurrentLaTeX} {
    configMenuText .menu.tools.exportcurrent [tr $tag $oldLang] $tag $lang
  }
  .menu.tools.exportcurrent entryconfig 4 -label "[tr ToolsExpCurrentLaTeX] ([tr OprepViewLaTeX])"

  foreach tag {ToolsExpFilterPGN ToolsExpFilterHTML ToolsExpFilterHTMLJS ToolsExpFilterLaTeX ToolsExpFilterGames} {
    configMenuText .menu.tools.exportfilter [tr $tag $oldLang] $tag $lang
  }
  .menu.tools.exportfilter entryconfig 4 -label "[tr ToolsExpFilterLaTeX] ([tr OprepViewLaTeX])"

  foreach tag {Board Colour Toolbar Names Recent Fonts GInfo Fics Moves Startup Language
    Numbers Windows Theme Export ECO Spell Table BooksDir TacticsBasesDir Sounds Save AutoSave} {
    configMenuText .menu.options [tr Options$tag $oldLang] Options$tag $lang
  }

  foreach tag {EnableColour BackColour MainLineColour VarLineColour RowColour SwitcherColour ProgressColour CrossColour} {
    configMenuText .menu.options.colour [tr Options$tag $oldLang] Options$tag $lang
  }

  foreach tag { Configure NovagCitrineConnect InputEngineConnect  } {
    configMenuText .menu.tools.hardware [tr ToolsConnectHardware$tag $oldLang] ToolsConnectHardware$tag $lang
  }

  foreach tag {Regular Menu Small Fixed} {
    configMenuText .menu.options.fonts [tr OptionsFonts$tag $oldLang] \
        OptionsFonts$tag $lang
  }

  foreach tag {HideNext Show Coords Material FEN Marks Wrap FullComment Photos \
        TBNothing TBResult TBAll Informant} {
    configMenuText .menu.options.ginfo [tr GInfo$tag $oldLang] \
        GInfo$tag $lang
  }
  configMenuText .menu.options.entry [tr OptionsShowVarPopup $oldLang] OptionsShowVarPopup $lang
  # S.A. here's how to fix these f-ing menus. &&&
  foreach tag {Ask Animate Delay Suggest Key Coord Space TranslatePieces HighlightLastMove ShowVarArrows} {
    configMenuText .menu.options.entry [tr OptionsMoves$tag $oldLang] \
        OptionsMoves$tag $lang
  }

  foreach tag {OptionsWindowsRaise OptionsFicsAuto OptionsSounds OptionsFicsColour OptionsColour OptionsFonts OptionsFicsButtons OptionsFicsCommands OptionsFicsSize OptionsFicsNoRes OptionsFicsNoReq OptionsFicsPremove} {
    configMenuText .menu.options.fics [tr $tag $oldLang] $tag $lang
  }

  foreach tag { Color Width Display } {
    configMenuText .menu.options.entry.highlightlastmove [tr OptionsMovesHighlightLastMove$tag $oldLang] OptionsMovesHighlightLastMove$tag $lang
  }
  foreach tag {HelpTip HelpStartup WindowsPGN WindowsTree FileFinder \
        WindowsCross WindowsGList WindowsStats WindowsBook} {
    configMenuText .menu.options.startup [tr $tag $oldLang] $tag $lang
  }
  # unhandled FICS

  foreach tag {Iconify Raise Dock FullScreen} {
    configMenuText .menu.options.windows [tr OptionsWindows$tag $oldLang] \
        OptionsWindows$tag $lang
  }
  if {$::docking::USE_DOCKING} {
    foreach tag {AutoLoadLayout AutoResize SaveLayout RestoreLayout} {
      configMenuText .menu.options.windows [tr OptionsWindows$tag $oldLang] \
          OptionsWindows$tag $lang
    }
    # and the single save layout menu at the bottom
    configMenuText .menu.options [tr OptionsWindowsSaveLayout $oldLang] \
	OptionsWindowsSaveLayout $lang

  }

  foreach tag {Contents Index Tip Startup About} {
    configMenuText .menu.help [tr Help$tag $oldLang] Help$tag $lang
  }
  if {$::macOS} {
    configMenuText .menu.apple [tr HelpAbout $oldLang] HelpAbout $lang
  }

  # Should sort out what the Delete , Mark menus did.
  # Its' proably tied in with my half-baked Gamelist Widget, and FLAGS
  #  foreach tag {HideNext Show Coords Material FEN Marks Wrap FullComment Photos TBNothing TBResult TBAll Delete Mark} 

  foreach tag {HideNext Show Coords Material FEN} {
    configMenuText .main.gameInfo.menu [tr GInfo$tag $oldLang] GInfo$tag $lang
  }

  ::pgn::ConfigMenus
  ::windows::stats::ConfigMenus
  ::tree::ConfigMenus
  ::crosstab::ConfigMenus
  ::optable::ConfigMenus
  ::preport::ConfigMenus
  playerInfoConfigMenus

  updateGameinfo
  updateStatusBar
  # todo &&&  Update docking tab labels (setTitle)

  # Check for duplicate menu underline characters in this language
  if {0} {
    foreach m {file edit game search windows tools options help} {
      set list [checkMenuUnderline .menu.$m]
      if {[llength $list] > 0} {
        ::splash::add "Menu $m has duplicate underline letters: $list" error
      }
    }
  }

}

# checkMenuUnderline:
#  Given a menu widget, returns a list of all the underline
#  characters that appear more than once.
#
proc checkMenuUnderline {menu} {
  array set found {}
  set duplicates {}
  set last [$menu index last]
  for {set i [$menu cget -tearoff]} {$i <= $last} {incr i} {
    if {[string equal [$menu type $i] "separator"]} {
      continue
    }
    set char [string index [$menu entrycget $i -label] \
        [$menu entrycget $i -underline]]
    set char [string tolower $char]
    if {$char == ""} {
      continue
    }
    if {[info exists found($char)]} {
      lappend duplicates $char
    }
    set found($char) 1
  }
  return $duplicates
}

proc configInformant {} {
  global informant

  set w .configInformant
  if {[winfo exists $w]} {
    destroy $w
  }

  toplevel $w
  wm state $w withdrawn
  wm title $w $::tr(ConfigureInformant)

  frame $w.main
  frame $w.buttons
  set row 0

  foreach i [lsort [array names informant]] {
    label $w.main.explanation$row -text [ ::tr "Informant[ string trim $i "\""]" ]
    label $w.main.label$row -text [string trim $i {"}]
    spinbox $w.main.value$row -textvariable informant($i) -width 4 -from 0.0 -to 9.9 -increment 0.1 \
        -validate all -vcmd {string is double %P} -justify center
    grid $w.main.explanation$row -row $row -column 0 -sticky w 
    grid $w.main.label$row -row $row -column 1 -sticky w -padx 5 -pady 3
    grid $w.main.value$row -row $row -column 2 -sticky w -padx 5 -pady 3
    incr row
  }

  dialogbutton $w.buttons.defaults -textvar ::tr(Defaults) -command resetInformants
  dialogbutton $w.buttons.help -textvar ::tr(Help) -command {helpWindow Moves Informant}
  dialogbutton $w.buttons.ok -text OK -command "destroy $w"
  pack $w.main $w.buttons -pady 5

  pack $w.buttons.defaults $w.buttons.help -side left -padx 5
  pack $w.buttons.ok  -side right -padx 5

  update
  placeWinOverParent $w .
  wm state $w normal
}

### End of file: menus.tcl

