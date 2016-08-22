#!/bin/sh

# Scid vs. PC
#
# Based on Shane's Chess Information Database
#
# Copyright Steven Atkinson (stevenaaus@yahoo.com) , Pascal Georges, Shane Hudson
# Released under the GPL
# This is freely redistributable software; see the file named "COPYING"
# or "copying.txt" that came with this program.

# The next line restarts using tkscid: \
exec `dirname "$0"`/tkscid "$0" "$@"

# Alter the version if any patches have been made to the Tcl code only:
set scidVersion 4.16
set scidVersionDate {Jan 25, 2016}

# Set to 0 before releasing, so some alpha-state code is not included
# Set to 1 to have access to all code
set NOT_FOR_RELEASE 0

package require Tcl 8.5
package require Tk  8.5

# Determine operating system platform: unix or windows

set windowsOS	[expr {$tcl_platform(platform) == "windows"}]
set unixOS	[expr {$tcl_platform(platform) == "unix"}]

# debugging a procedure (can affect performance/toolbar)
if {0} {
  set procname update

  rename $procname oldprocname
  proc $procname {args} {
    if {$::windowsOS} {
      catch {::splash::add "$procname $args"}
    } else {
      puts "$::procname $args ([info  level [expr [info level] -1]])"
    }
    eval oldprocname $args
  }
}

if {![catch {tk windowingsystem} wsystem] && $wsystem == "aqua"} {
  set macOS 1
  set scidName {Scid vs. Mac 360}
} else {
  set macOS 0
  set scidName {Scid vs. 360}
}

# See if we're inside a Mac .app bundle.  This duplcates part of the command-line
# parsing, which options should probably be done earlier, but I'm afraid to move
# things around that much - dr

# Mavericks has discarded "-psn", so just assume started as App unless "-noapp" passed

if { $::macOS && ([string first "-noapp" $argv] == -1)} {
  # Remember that we were invoked in a MacOS app bundle
  set macApp 1
} else {
  set macApp 0
}

# Check that on Unix, the version of tkscid matches the version of this
# script or on Windows, that the scid.exe and scid.gui versions are identical.

if {[string compare [sc_info version] $scidVersion]} {
  wm withdraw .
  if {$windowsOS} {
    set msg "This is $::scidName version [sc_info version], but the scid.gui data\n"
    append msg "file has the version number $scidVersion.\n"
  } else {
    set msg "This is $::scidName version $scidVersion,\nbut the "
    append msg "tkscid program \nit uses is version [sc_info version].\n"
    append msg "Check that the path to tkscid is correct."
  }
  tk_messageBox -type ok -icon error -title "Scid: version error" -message $msg
  exit 1
}

#############################################################
#
# NAMESPACES
#
# The main Tcl/Tk namespaces used in the Scid application are
# initialized here, so that default values can be set up and
# altered when the user options file is loaded.
#
foreach ns {
  ::splash
  ::utils
  ::utils::date ::utils::font ::utils::history ::utils::pane ::utils::string
  ::utils::sound ::utils::validate ::utils::win
  ::file
  ::file::finder ::file::maint ::maint
  ::bookmarks
  ::edit
  ::game
  ::gbrowser
  ::search
  ::search::filter ::search::board ::search::header ::search::material
  ::windows
  ::windows::gamelist ::windows::stats ::tree ::tree::mask ::windows::tree
  ::windows::switcher ::windows::eco ::crosstab ::pgn ::book
  ::tools
  ::tools::analysis ::tools::email
  ::tools::graphs
  ::tools::graphs::filter ::tools::graphs::absfilter ::tools::graphs::rating ::tools::graphs::score
  ::tb ::optable
  ::board ::move
  ::tacgame ::sergame ::tactics ::calvar ::uci ::fics
  ::config ::docking
  ::commenteditor
} {
  namespace eval $ns {}
}

### ::pause is used as a semaphore by the trace command in tacgame (and fics)

set ::MAX_GAMES [sc_info limit games]
set ::pause 0
set ::defaultBackground white
set ::defaultGraphBackgroud white
set ::enableBackground 0
set ::tacgame::threshold 0.9
set ::tacgame::levelMin 1200
set ::tacgame::levelMax 2200
set ::tacgame::levelFixed 1500
set ::tacgame::randomLevel 0
set ::tacgame::showblunder 1
set ::tacgame::showblundervalue 1
set ::tacgame::showblunderfound 1
set ::tacgame::showmovevalue 1
set ::tacgame::showevaluation 1
set ::tacgame::isLimitedAnalysisTime 1
set ::tacgame::analysisTime 10
set ::tacgame::openingType new
set ::tacgame::chosenOpening 0
set ::sergame::bookToUse {}
set ::sergame::useBook 1
set ::sergame::startFromCurrent 0
set ::sergame::timeMode movetime
set ::sergame::movetime 6
set ::sergame::current 0
set ::sergame::chosenOpening 0
set ::sergame::isOpening 0
set ::sergame::btime 300000
set ::sergame::wtime 5
set ::sergame::btime 5
set ::sergame::winc 10
set ::sergame::binc 10
set ::commenteditor::showBoard 1
set ::windows::gamelist::widths {}
set ::windows::gamelist::findcase 1
set ::windows::gamelist::showButtons 1
set ::windows::switcher::icons 1
set ::windows::switcher::confirmCopy 1
set ::file::finder::data(dir) $::env(HOME)
set ::file::finder::data(sort) name
set ::file::finder::data(recurse) 0
set ::file::finder::data(Scid) 1
set ::file::finder::data(PGN) 1
set ::file::finder::data(EPD) 1
set ::file::finder::data(Old) 1
set ::tools::graphs::absfilter::type year
set ::tools::graphs::filter::type year
set ::tools::graphs::showpoints 1
set annotate(addTag) 1
set annotate(Moves) all
set annotate(WithVars) blunders
set annotate(WithScore) allmoves
set annotate(WantedDepth) 13
set annotate(Depth) 1
set useAnalysisBook 0
set annotate(isVar) 0
set annotate(scoreType) {+ 1.5}
set annotate(blunder) 1.0
set annotate(cutoff) 5.0
set maintFlag W
set ::gbrowser::size 35
set comp(timecontrol) pergame
set comp(seconds) 180
set comp(base) 60
set comp(incr) 1
set comp(timeout) 0 ;# disabled by default
set comp(name) $scidName
set comp(rounds) 2
set comp(showclock) 0
set comp(debug) 1 ; # print info to console
set comp(animate) 1
set comp(firstonly) 0
set comp(ponder) 0
set comp(usebook) 0
set comp(book) {}
set comp(showscores) 0 ; # add engine scores as comments
set photosMinimized 0
set bookmarks(gamehistory) {}
set playerInfoHistory {}

proc ::docking::init_layout_list {{recover 0}} {
  # Default window docking layouts
  array set ::docking::layout_list {}
  
  # Basic layout : PGN window with main board
  set ::docking::layout_list(1) {{MainWindowGeometry 834x640+80+50} {{.pw vertical {}} {TPanedwindow {{.pw.pw0 horizontal 564} {TNotebook .nb .fdockmain} {TNotebook .tb1 .fdockpgnWin}}}}}

  if {$recover} {
    return
  }

  set ::docking::layout_list(2)  {{MainWindowGeometry 1311x716+65+36} {{.pw vertical {}} {TPanedwindow {{.pw.pw0 horizontal 570} {TNotebook .nb .fdockmain} {TPanedwindow {{.pw.pw0.pw2 vertical 261} {TPanedwindow {{.pw.pw0.pw2.pw9 horizontal 235} {TNotebook .tb32 .fdockpgnWin} {TPanedwindow {{.pw.pw0.pw2.pw9.pw30 vertical {}} {TNotebook .tb1 {.fdockplayerInfoWin .fdockcommentWin}}}}}} {TPanedwindow {{.pw.pw0.pw2.pw3 horizontal {}} {TNotebook .tb8 {.fdockglistWin .fdockcrosstabWin}}}}}}}}}}

  set ::docking::layout_list(3) {{MainWindowGeometry 968x666+80+50} {{.pw vertical {}} {TPanedwindow {{.pw.pw0 horizontal 566} {TNotebook .nb .fdockmain} {TPanedwindow {{.pw.pw0.pw2 vertical 363} {TNotebook .tb1 {.fdockanalysisWin1 .fdockpgnWin}} {TNotebook .tb3 {.fdocktreeWin1 .fdocktreeBest1}}}}}}}}
  set ::docking::layout_list(4) {{MainWindowGeometry 1449x817+76+30} {{.pw vertical {}} {TPanedwindow {{.pw.pw0 horizontal 747} {TNotebook .nb .fdockmain} {TPanedwindow {{.pw.pw0.pw2 vertical {}} {TPanedwindow {{.pw.pw0.pw2.pw3 horizontal {}} {TPanedwindow {{.pw.pw0.pw2.pw3.pw35 vertical 378} {TPanedwindow {{.pw.pw0.pw2.pw3.pw35.pw38 horizontal 347} {TNotebook .tb36 {.fdockpgnWin .fdockcommentWin}} {TNotebook .tb39 {.fdockanalysisWin0 .fdockplayerInfoWin .fdocktreeWin1}}}} {TNotebook .tb8 {.fdockglistWin .fdocksgraph .fdockcrosstabWin}}}}}}}}}}}}
  set ::docking::layout_list(5) {}
}

::docking::init_layout_list

### Tree/mask options:
set ::tree::showBar [expr {! $::macOS}]
set ::tree::sortBest 1
set ::tree::short 1
set ::tree::mask::recentMask {}
set ::tree::mask::autoLoadMask 0

set cleaner(players) 1
set cleaner(events) 1
set cleaner(sites) 1
set cleaner(rounds) 1
set cleaner(eco) 1
set cleaner(elo) 1
set cleaner(twins) 1
set cleaner(cnames) 0
set cleaner(cgames) 0
set cleaner(tree) 0

#############################################################
# Customisable variables:

# scidExeDir: contains the directory of the Scid executable program.
# Used to determine the location of various relative data directories.
set scidExecutable [info nameofexecutable]

if {$scidExecutable == {}} {
  ### Shit. Wish8.6b2 returns {} 
  # I wonder if new tcl-8.5 works ok ?
  if {$unixOS} {
    catch {
      set scidExecutable [exec readlink /proc/[pid]/exe]
    }
    puts "scidExecutable is null. Now is \"$scidExecutable\"" 
  } else {
    puts "scidExecutable is null" 
  }
}

if {$scidExecutable == {}} {
  ### may work on windows, but will be broken on other OS
  set scidExeDir .
} else {
  if {[file type $scidExecutable] == "link"} {
    set scidExeDir [file dirname [file readlink $scidExecutable]]
    if {[file pathtype $scidExeDir] == "relative"} {
      set scidExeDir [file dirname [file join [file dirname $scidExecutable]\
	[file readlink $scidExecutable]]]
    }
  } else {
    set scidExeDir [file dirname $scidExecutable]
  }
}

# scidUserDir: location of user-specific Scid files.
# This is "~/.scid" on Unix, and the Scid exectuable dir on Windows.

if {$windowsOS} {
  set scidUserDir $scidExeDir

  # Need to cd here to open eco and spellfiles
  #   Probably only has any effect when opening a pgn/si4 file by double clicking on it,
  #   whence the CWD is not "."
  cd $scidExeDir
  # Windows has problems with "cmd.exe /c start" and spaces in file names "Documents and Settings"
  # so choose something dumb
  set scidLogDir {C:\log}
} else {
  set scidUserDir [file nativename "~/.scidvspc"]
  set scidLogDir [file nativename [file join $scidUserDir "log"]]
}

# scidConfigDir, scidDataDir, scidLogDir:
#   Location of Scid configuration, data and log files.
set scidConfigDir [file nativename [file join $scidUserDir "config"]]
set scidDataDir [file nativename [file join $scidUserDir "data"]]
set scidTexturesDir [file nativename [file join $scidUserDir "textures"]]
set scidPiecesDir [file nativename [file join $scidUserDir "pieces"]]
set scidPhotosDir [file nativename [file join $scidUserDir "photos"]]

# boardSizes: sizes after 80 are copied rom smaller ones
set boardSizes [list 25 30 35 40 45 50 55 60 65 70 75 80 90 100 110 120 130 140 150 160]

#load textures for lite and dark squares
set boardfile_dark "emptySquare"
set boardfile_lite "emptySquare"

#[file join $scidExeDir "bitmaps" "empty.gif"] ;# wsquare.gif

# boardSize: Default board size. See the available board sizes above.
set boardSize 60

# language for help pages and messages:
set language E
set oldLang X
# Toolbar configuration:
foreach {tbicon status}  {
  new 0 open 0 save 1 close 0
  finder 0 bkm 1 gfirst 1 gprev 1 gnext 1 glast 1
  newgame 0 copy 0 paste 0
  rfilter 0 bsearch 0 hsearch 0 msearch 0
  glist 1 pgn 1 tmt 1 comment 0 maint 1 eco 0 tree 1 crosst 1 engine 1 book 1
} {
  set toolbar($tbicon) $status
}

# boardCoords: 1 to show board Coordinates, 0 to hide them.
set boardCoords 0

# boardSTM: 1 to show side-to-move icon, 0 to hide it.
set boardSTM 1

# Default values for fonts:
proc createFont {name} {
  set opts $::fontOptions($name)
  font create font_$name \
      -family [lindex $opts 0] -size [lindex $opts 1] \
      -weight [lindex $opts 2] -slant [lindex $opts 3]
}

proc configureFont {name} {
  set opts $::fontOptions($name)
  font configure font_$name \
      -family [lindex $opts 0] -size [lindex $opts 1] \
      -weight [lindex $opts 2] -slant [lindex $opts 3]
}

proc reinitFont {name} {
  set ::fontOptions($name) $::fontOptions(old$name)
  configureFont $name
}

if {$windowsOS} {
  set fontOptions(Regular) { Arial           10 normal roman}
  set fontOptions(Menu)    { {MS Sans Serif}  9 normal roman}
  set fontOptions(Small)   { Arial            9 normal roman}
  set fontOptions(Tiny)    { Arial            7 normal roman}
  set fontOptions(Fixed)   { Courier          9 normal roman}
} elseif {$macOS} {
  set fontOptions(Regular) { {Lucida Grande} 12 normal roman}
  set fontOptions(Menu)    { {Lucida Grande} 14 normal roman}
  set fontOptions(Small)   { {Lucida Grande} 11 normal roman}
  set fontOptions(Tiny)    { {Lucida Grande}  9 normal roman}
  set fontOptions(Fixed)   { Monaco 10 normal roman}
} else {
  set fontOptions(Regular) { helvetica 11 normal roman}
  set fontOptions(Menu)    { helvetica 10 normal roman}
  set fontOptions(Small)   { helvetica 10 normal roman}
  set fontOptions(Tiny)    { helvetica  8 normal roman}

  # try a couple of fonts, and default to "fixed" if no luck
  if {[lsearch [font families] {Liberation Mono}] > 0} {
    set fontOptions(Fixed)   { {Liberation Mono} 11 normal roman}
  } elseif {[lsearch [font families] {Courier 10 Pitch}] > 0} {
    set fontOptions(Fixed)         { {Courier 10 Pitch} 12 normal roman}
  } else {
    set fontOptions(Fixed)   { fixed 11 normal roman}
  }
}

createFont Regular
createFont Menu
createFont Small
createFont Tiny
createFont Fixed

# Analysis command: to start chess analysis engine.
set analysisCommand ""
set analysis(mini) 0

# Maximum number of lines to be saved in a log file
# (setting it to 0 also stops log file being created)
set analysis(logMax) 5000
set analysis(logName) 1
set analysis(maxPly) 0
set analysis(lowPriority) $::windowsOS

# Colors

set lite        #f3f3f3
set dark        #7389b6		;# dark and lite square colors
set highcolor   #b0d0e0		;# color when something is selected
set bestcolor   #bebebe		;# suggested move square
set bgcolor     grey20		;# board (canvas) bg color, appears as the lines between the squares
set progcolor   rosybrown	;# progress bar
set buttoncolor #b0c0d0		;# (below)
set maincolor   black		;# Main line arrow color
set varcolor    grey80		;# Variation arrow colors
set rowcolor    lightsteelblue1 ;# Tree/Crosstab/Book line/row bg color
set switchercolor lightsteelblue3 ;# DB switcher
set crosscolor  grey80		;# Crosstable line colouring

set borderwidth 1

# Set the radiobutton and checkbutton background color if desired.
# I find the maroon color on Unix ugly!
if {$unixOS} {
  option add *Radiobutton*selectColor $buttoncolor
  option add *Checkbutton*selectColor $buttoncolor
  # option add *Menu*selectColor $buttoncolor
}

set ::tactics::analysisTime 3

# Defaults for the PGN window:
# if ::pgn::showColor is 1, the PGN text will be colorized.
set ::pgn::showColor 1
set ::pgn::indentVars 1
set ::pgn::indentComments 1
set ::pgn::symbolicNags 1
set ::pgn::moveNumberSpaces 0
set ::pgn::shortHeader 0
set ::pgn::boldMainLine 0
set ::pgn::columnFormat 0
set ::pgn::stripMarks 0
set ::pgn::showScrollbar 0
set pgnColor(Header) "\#00008b"
set pgnColor(Main) "\#000000"
set pgnColor(Var) "\#0000ee"
set pgnColor(Nag) "\#aa2c2c" ;# ee0000
set pgnColor(Comment) "\#008b00"
set pgnColor(Current) lightSteelBlue
set pgnColor(NextMove) "\#fefe80"
set pgnColor(Background) "\#ffffff"

array set findopponent {}

proc initFICSDefaults {} {
  namespace eval fics {
    set use_timeseal 0
    if {$::macOS} {
      set timeseal_exec "$::scidExeDir/timeseal"
    } else {
      set timeseal_exec "timeseal"
    }
    set server        freechess.org
    set port_fics     5000
    set port_timeseal 5001
    set login         ""
    set password      ""
    set findopponent(initTime) 10
    set findopponent(incTime)  10
    set findopponent(rated)    rated
    set findopponent(color)    ""
    set findopponent(limitrating) 0
    set findopponent(rating1)  1000
    set findopponent(rating2)  1500
    set findopponent(manual)   manual
    set findopponent(formula)  ""
    set consolebg grey35
    set consolefg LimeGreen
    set chanoff 1
    set shouts 1
    set server_ip   0.0.0.0
    set autopromote 0
    set autoraise 1
    set size 2
    set sound 0
    set no_results 0
    set no_requests 0

    proc initUserButtons {} {
      set ::fics::user_buttons {FICSInfo FICSOpponent Abort}
      set ::fics::user_commands {
	{::fics::writechan finger ; ::fics::writechan "inchannel $::fics::reallogin"}
	{if {$::fics::opponent != {}} {
	  ::fics::writechan "finger $::fics::opponent"
	}}
	{::fics::writechan abort}
      }
    }

    initUserButtons
    # these are duplicated in fics::editInitCommands
    set init_commands [list \
      {set gin  0} \
      {set echo 1} \
      {set seek 0} \
    ]
    set show_buttons 1
    set allow_premove 1
  }
}

initFICSDefaults

# Defaults for initial directories:
set initialDir(base) $::env(HOME)
set initialDir(pgn)  $::env(HOME)
set initialDir(book) $::env(HOME)
set initialDir(epd)  $::env(HOME)
set initialDir(html) $::env(HOME)
set initialDir(tex)  $::env(HOME)
set initialDir(stm)  $::env(HOME)
set initialDir(sso)  $::env(HOME)
set initialDir(report) $::env(HOME)
set initialDir(tablebase1) ""
set initialDir(tablebase2) ""
set initialDir(tablebase3) ""
set initialDir(tablebase4) ""

# glistSize: Number of games displayed in the game list window
set glistSize 15

# glexport: Format for saving Game List to text file.
set glexportDefault "g6: w13 W4  b13 B4  r3:m2 y4 s11 o4"
set glexport $glexportDefault

# Default window locations:
foreach i {. .main .pgnWin .helpWin .crosstabWin .treeWin .commentWin .glist \
      .playerInfoWin .baseWin .treeBest .tourney .finder \
      .ecograph .statsWin .glistWin .maintWin .nedit} {
  set winX($i) -1
  set winY($i) -1
}

for {set b 1} {$b<=[sc_base count total]} {incr b} {
  foreach i {.treeWin .treeBest} {
    set winX($i$b) -1
    set winY($i$b) -1
  }
}

# Default PGN window size:
set winWidth(.pgnWin)  65
set winHeight(.pgnWin) 20

# Default help window size:
set winWidth(.helpWin)  50
set winHeight(.helpWin) 32

# Default stats window size:
set winWidth(.statsWin) 60
set winHeight(.statsWin) 13

# Default crosstable window size:
set winWidth(.crosstabWin)  75
set winHeight(.crosstabWin) 15

# Default tree window size:
set winWidth(.treeWin)  58
set winHeight(.treeWin) 20

# Default comment editor size:
set winWidth(.commentWin)  40
set winHeight(.commentWin)  6

# Default spellcheck results window size:
set winWidth(.spellcheckWin)  55
set winHeight(.spellcheckWin) 25

# Default player info window size:
set winWidth(.playerInfoWin)  45
set winHeight(.playerInfoWin) 20

# Default switcher window size:
set winWidth(.baseWin) 310
set winHeight(.baseWin) 110

# Default Correspondence Chess window size:
set winWidth(.ccWindow) 10
set winHeight(.ccWindow) 20

# Default stats window lines:
array set ::windows::stats::display {
  r2600 1
  r2500 0
  r2400 1
  r2300 0
  r2200 1
  r2000 1
  r1800 0
  y1900 0
  y1950 0
  y1960 0
  y1970 0
  y1980 0
  y1990 0
  y2000 1
  y2005 1
  y2010 1
}

# Enable stats for subsequent years
for { set year [clock format [clock seconds] -format {%Y}] } \
    { $year > 2010 && ![info exists ::windows::stats::display([subst {y$year}])] } \
    { incr year -1 } {
      set ::windows::stats::display([subst {y$year}]) 1
    }

# Default PGN display options:
set pgnStyle(Tags) 1
set pgnStyle(Comments) 1
set pgnStyle(Vars) 1


# Default Tree sort method:
set tree(order) frequency

# Auto-save tree cache when closing tree window:
set tree(autoSave) 0

# Auto-save options when exiting:
set optionsAutoSave 1

#  Numeric locale: first char is decimal, second is thousands.
#  Example: ".," for "1,234.5" format; ",." for "1.234,5" format.
set locale(numeric) ".,"

# Ask for piece translations (first letter)
set translatePieces 1

# Hightlight the last move played
set highlightLastMove 1
set highlightLastMoveWidth 2
set highlightLastMoveColor "grey"
set highlightLastMovePattern {} ; # this option is not saved

# Ask before replacing existing moves: on by default
set askToReplaceMoves 1

# Show suggested moves
set suggestMoves 0

# Show variations popup window, arrows
set showVarPopup 0
set showVarArrows 1

# Keyboard Move entry options:
set moveEntry(On) 1
set moveEntry(AutoExpand) 0
set moveEntry(Coord) 1

# Autoplay and animation delays in milliseconds:
set autoplayDelay 5000
set animateDelay 200


# Geometry of windows:
array set geometry {}

# Default theme
if {$::windowsOS} {
  set lookTheme clam
} else {
  set lookTheme default
}

# set board piece style
foreach i {tilegtk tileq keramik keramik_alt plastik} {
  catch {package require ttk::theme::$i}
}
# catch {ttk::style theme use $lookTheme}

#   Which windows should be opened on startup
set startup(pgn) 0
set startup(switcher) 0
set startup(tip) 0
set startup(tree) 0
set startup(finder) 0
set startup(crosstable) 0
set startup(gamelist) 0
set startup(stats) 0
set startup(book) 0
set startup(fics) 0

# myPlayerNames:
#   List of player name patterns for which the chessboard should be
#   flipped each time a game is loaded to show the board from that
#   players perspective.

set myPlayerNames {}

# These new checkbuttons (showMenu, showButtons etc) don't really have anything
# to do with gameInfo, but are here anyway S.A

set gameInfo(show) 1
set gameInfo(photos) 0
set gameInfo(hideNextMove) 0
set gameInfo(showMaterial) 1
set gameInfo(showFEN) 0
set gameInfo(showButtons) 1
set gameInfo(showStatus) 1
set gameInfo(showMenu) 1
set gameInfo(showTool) 1
set gameInfo(showMarks) 1
set gameInfo(wrap) 0
set gameInfo(fullComment) 0
set gameInfo(showTB) 0
if {[sc_info tb]} { set gameInfo(showTB) 2 }

### Twin game checker options
# "players" represents *exact* match or 4 chars only

array set twinSettings {
  players Yes
  colors  Yes
  event   No
  site    Yes
  round   Yes
  year    Yes
  month   Yes
  day     No
  result  No
  eco     No
  moves   Yes
  skipshort  Yes
  setfilter  Yes
  undelete   Yes
  comments   Yes
  variations Yes
  usefilter  No
  delete     Shorter
}
array set twinSettingsDefaults [array get twinSettings]

# Opening report options:
array set optable {
  Stats 1
  Oldest 5
  Newest 5
  Popular 1
  MostFrequent 6
  MostFrequentWhite 1
  MostFrequentBlack 1
  AvgPerf 1
  HighRating 8
  Results 1
  Shortest 5
  ShortestWhite 1
  ShortestBlack 1
  MoveOrders 8
  MovesFrom 1
  Themes 1
  Endgames 1
  MaxGames 500
  ExtraMoves 1
}
array set optableDefaults [array get optable]

# Player report options
array set preport {
  Stats 1
  Oldest 5
  Newest 5
  MostFrequentOpponents 6
  AvgPerf 1
  HighRating 8
  Results 1
  MostFrequentEcoCodes 6
  Themes 1
  Endgames 1
  MaxGames 500
  ExtraMoves 1
}
array set preportDefaults [array get preport]

# Export file options:
set exportFlags(comments) 1
set exportFlags(space) 1
set exportFlags(indentc) 0
set exportFlags(vars) 1
set exportFlags(indentv) 1
set exportFlags(column) 0
set exportFlags(append) 0
set exportFlags(symbols) 0
set exportFlags(htmldiag) 0
set exportFlags(stripMarks) 0
set exportFlags(convertNullMoves) 1
set exportFlags(utf8) 0
set default_exportStartFile(PGN) {}
set default_exportEndFile(PGN) {}

set default_latexRendering(engine) {pdflatex -interaction=nonstopmode}
if {$::windowsOS} {
  set default_latexRendering(viewer) start
} elseif {$::macOS} {
  # Use open -a if you want to force to the built in preview
  set default_latexRendering(viewer) open
} else {
  set default_latexRendering(viewer) xdg-open ; # evince, okular

  # Unused
  if {0} {
    if {[catch {exec xdg-mime query default application/pdf} result] == 0} {
      # cool unix has a registered app for pdfs so lets use it
      set latexViewer "xdg-open"
    } else {
      # try and detect the destop to make at least best guess
      if {[info exists ::env(XDG_CURRENT_DESKTOP)]} {
	set unixDesktop = [string tolower $::env(XDG_CURRENT_DESKTOP)]
      } else {
	switch -regexp -matchvar denv -- $::env(XDG_DATA_DIRS) {
	  .*(gnome|xfce|kde).* { set unixDesktop $denv }
	  default { set unixDesktop "unknown" }
	}
	switch $linuxDesktop {
	  gnome   {set latexViewer evince}
	  kde     {set latexViewer okular}
	  xfce    {set latexViewer evince}
	  default {set latexViewer xpdf}
	}
      }
    }
  }
}

set default_exportStartFile(Latex) {\documentclass[10pt,DIV=20]{scrreprt}
% This is a LaTeX file generated by Scid.
% You must have the skak, KOMAScript and pstricks packages installed to typeset this file.

\usepackage{scrpage2}
\usepackage{charter}
\usepackage[svgnames]{xcolor}
\usepackage{xskak}
\usepackage{lmodern}
\usepackage[T1]{fontenc}
\usepackage{latexsym}
\usepackage{pstricks-add}
\usepackage{tabularx}

% \definecolor{VariationColor}{gray}{0.40}
\definecolor{VariationColor}{RGB}{0,0,128}
% \definecolor{ScoreColor}{gray}{0.40}
\definecolor{ScoreColor}{RGB}{255,215,0}
\definecolor{GridColor}{RGB}{72,61,139}
\definecolor{EvenGameColor}{RGB}{240,240,240}
\definecolor{BlackPiecesGraphColor}{RGB}{101,37,37}
\definecolor{WhitePiecesGraphColor}{RGB}{189,183,107}

\setlength{\extrarowheight}{3pt}  
  
\newcommand{\win}{1-0}
\newcommand{\loss}{0-1}  
\newcommand{\draw}{=-=}  
\newcommand{\p}{\figsymbol{p}}
\newcommand{\N}{\figsymbol{N}}
\newcommand{\B}{\figsymbol{B}}
\newcommand{\R}{\figsymbol{R}}
\newcommand{\Q}{\figsymbol{Q}}  
\newcommand{\K}{\figsymbol{K}}    
  
\renewcommand*\thesection{\arabic{section}}
\addtokomafont{section}{\color{blue}}
\addtokomafont{subsection}{\color{red}}

\begin{document}
}
set default_exportEndFile(Latex) {\end{document}
}

set default_exportStartFile(HTML) {<html>
  <head><title>Scid export</title></head>
  <body bgcolor="#ffffff">
}
set default_exportEndFile(HTML) {</body>
  </html>
}

foreach type {PGN HTML Latex} {
  set exportStartFile($type) $default_exportStartFile($type)
  set exportEndFile($type) $default_exportEndFile($type)
}

foreach type {engine viewer} {
  set latexRendering($type) $default_latexRendering($type)
}

# autoRaise: defines whether the "raise" command should be used to raise
# certain windows (like progress bars) when they become obscured.
# Some Unix window managers (e.g. some versions of Enlightenment and sawfish,
# so I have heard) have a bug where the Tcl/Tk "raise" command times out
# and takes a few seconds. Setting autoRaise to 0 will help avoid this.

# The above mentioned "1 second" bug is relevant to kde1 i think.
# Kde 3.5 (and WinXP) have focus stealing code that stops "raise"
# from working by default. In kde this can be changed by
# configuring "desktop > window behavior > advanced > focus stealing prevention"
# to "none"

set autoRaise 1

proc raiseWin {w} {
  global autoRaise
    if {$w == "." } {
     set w .main
    }
    if {$::docking::USE_DOCKING} {
      if {[catch {::docking::raiseTab $w}]} {
        # dammit, undocked windows aren't raising. fixme
	catch {wm deiconify $w}
	raise $w 
	focus $w
      } 
    } else {
      if {$autoRaise} {
	catch {wm deiconify $w}
	raise $w
	focus $w
      }
    }
}

# autoIconify:
#   Specified whether Scid should iconify all other Scid windows when
#   the main window is iconified. Most people like this behaviour but
#   some window managers send an "UnMap" event when the user switches
#   to another virtual window without iconifying the Scid window so
#   users of such managers will probably want to turn this off.

set autoIconify 1

# windowsDock:
# if true, most of toplevel windows are dockable and embedded in a main window
# windows can be moves among tabs (drag and drop) or undocked (right-clicking on tab)

set windowsDock 1
# set windowsDock [expr {!$::macOS}]

# autoLoadLayout :
# Automatic loading of layout # 1 at startup (docked windows mode only)
set autoLoadLayout 1

# autoResizeBoard:
# resize the board to fit the container
set autoResizeBoard 1

################################################################################
# if undocked window : sets the title of the toplevel window
# if docked : sets the name of the tab
# w : name of the toplevel window
proc setTitle { w title } {
  if { $::docking::USE_DOCKING && ! [ ::docking::isUndocked $w ]} {
    set f .fdock[ string range $w 1 end ]
    if { [catch {set nb [ ::docking::find_tbn $f ]} ]} {
      set nb ""
    }
    
    if { $nb == "" } {
      wm title $w $title
    } else  {
      # if target is main board, update the global window instead
      if { $w == ".main" && $title != [ ::tr "Board" ] } {
        wm title . $title
      } else  {
        # in docked mode trim down title to spare space
        if { [ string range $title 0 5 ] == "Scid: " &&  [ string length $title ] > 6 } {
          set title [string range $title 6 end]
        }
        $nb tab $f -text $title
      }
    }
  } else  {
    set wdock ".fdock[string range $w 1 end]"
    if { [winfo exists $wdock ] } { set w $wdock }
    wm title $w $title
  }
  
}
################################################################################
# Creates a toplevel window depending of the docking option
################################################################################
proc createToplevel { w } {
  set name [string range $w 1 end]
  set f .fdock$name

  # Raise window if already exist
  if { [winfo exists $w] } {
    if {! $::docking::USE_DOCKING } {
      tk::PlaceWindow $w
    } else {
      if { [::docking::isUndocked $w] } {
        tk::PlaceWindow $f
      } else {
        [::docking::find_tbn $f] select $f
      }
    }
    return "already_exists"
  }

  if { $::docking::USE_DOCKING && ! [ ::docking::isUndocked $w ] } {
    frame $f  -container 1
    toplevel .$name -use [ winfo id $f ]
    ::docking::add_tab $f
    
    # auto focus mode : when the mouse enters a toplevel, it gets a forced focus to handle mouse wheel
    # only the highest stacked window can get the focus forced or on windows any time the mouse enters the main window, it will be raised
    bind .$name <Enter> {
      set tl [winfo toplevel %W]
      set focus [focus]
      if {[catch {set focus [winfo toplevel $focus]}]} {
         # if [focus] is {}, try to grab it again
         if {$::windowsOS} {
	   break
         } else {
	   focus -force .fdockmain
         }
      }
      if {$focus != $tl && ([lindex [wm stackorder .] end] == "." || $::macOS)} {
        if {$tl == ".fics"} {
          focus -force .fics.command.entry
        } else {
	  focus -force $tl
        }
      }
    }
    
  } else  {
    toplevel $w
  }
  
}

################################################################################
# In the case of a window closed without the context menu in docked mode, arrange for the tabs to be cleaned up
# Alternative way : directly call ::docking::cleanup $w when closing window
################################################################################
proc createToplevelFinalize {w} {
  if { $::docking::USE_DOCKING } {
    bind $w <Destroy> +[ namespace code "::docking::cleanup $w %W"]
  }
}

################################################################################
# Sets the menu for a new window : in docked mode the menu is displayed by clicking on the tab of the notebook
################################################################################
proc setMenu {w m} {
  if { ! $::docking::USE_DOCKING } {
    $w configure -menu $m
  }
}
################################################################################
# In docked mode, resize board automatically
# Very messy and there's probably a better way, but cant be bothered right now.
################################################################################
proc resizeMainBoard {} {
  global gameInfo board

  if { ! $::docking::USE_DOCKING } { return }
  
  bind .main <Configure> {}
  
  set w [winfo width .main]
  set h [winfo height .main]
  set bd .main.board
  
  ### calculate available height

  set height_used 0
  if {$gameInfo(showTool)} {
    incr height_used [ lindex [grid bbox .main 0 0] 3]
  }
  if {$gameInfo(showButtons)} {
    incr height_used [ lindex [grid bbox .main 0 1] 3]
  }

  # coordinates
  if { $::board::_coords($bd) == 2 || $::board::_coords($bd) == 0} {
    incr height_used [ lindex [ grid bbox $bd 1 9 ] 3 ]
  }
  if { $::board::_coords($bd) == 0 } {
    incr height_used [ lindex [ grid bbox $bd 1 0 ] 3 ]
  }

  # game info &&& fixme
  set min_game_info_height [expr {6 + $gameInfo(showFEN) + $::macOS}]
  set game_info_line_height 5
  set min_game_info_lines 1
  if {$gameInfo(show)} {
    set min_game_info_lines 5
    set game_info_lines [.main.gameInfo count -displaylines 1.0 end]
    if { $game_info_lines > 0 } {
      # probably not very correct, do you know any better way to get this information?
      set game_info_line_height [expr 1.0 * [.main.gameInfo count -ypixels 1.0 end] / $game_info_lines]
    } else {
      # utter approximation
      set game_info_line_height [expr [font configure font_Regular -size] * 1.5]
    }
    set min_game_info_height [expr int($min_game_info_lines * $game_info_line_height + 5)]
  } else {
    set min_game_info_height [expr int([font configure font_Regular -size] * 1.5 * 2.5)]
  }
  incr height_used $min_game_info_height
  
  # status bar
  incr height_used [ lindex [grid bbox .main 0 4] 3]
  
  set availh [expr $h - $height_used]
  
  ### calculate available width

  set width_used 12
  if {[winfo exists .fics]} {
    ### proc ::board::ficslabels
    incr width_used 16
  }
  if { $::board::_coords($bd) == 2 || $::board::_coords($bd) == 0} {
    incr width_used [ lindex [ grid bbox $bd 2 1 ] 2 ]
  }
  if { $::board::_coords($bd) == 0 } {
    incr width_used [ lindex [ grid bbox $bd 11 1 ] 2 ]
  }
  if {$::board::_stm($bd)} {
    incr width_used [ lindex [ grid bbox $bd 1 1] 2 ]
    incr width_used 10
  }
  if {$::board::_showmat($bd)} {
    # we can't rely on board::_matwidth($bd) or the bbox of 12,1 because matwidth is being set afterwards
    incr width_used 30
  }
  # Not quite perfect for some reason (-16)
  set availw [expr $w - $width_used -16] 
  
  if {$availh < $availw} {
    set min $availh
  } else  {
    set min $availw
  }

  if { $::autoResizeBoard } {
    # find the closest available size
    for {set i 0} {$i < [llength $::boardSizes]} {incr i} {
      set newSize [lindex $::boardSizes $i]
      if { $newSize > [ expr $min / 8 ] } {
        if {$i > 0} {
          set newSize [lindex $::boardSizes [expr $i -1] ]
        }
        break
      }
    }
    # resize the board
    ::board::resize .main.board $newSize
    set ::boardSize $newSize
  }

  # adjust game info height
  set new_game_info_lines [expr int(($min_game_info_height+($availh-$::boardSize*8))/$game_info_line_height)]
  if { $new_game_info_lines > $min_game_info_lines } {
    set new_game_info_lines [expr $new_game_info_lines - 1]
  }
  .main.gameInfo configure -height $new_game_info_lines
  
  update idletasks
  bind .main <Configure> {::docking::handleConfigureEvent %W}
}

proc toggleToolbar {} {
  if {$::gameInfo(showTool)} {
    grid .main.tb -row 0 -column 0 -columnspan 3 -sticky we
  } else {
    grid forget .main.tb
  }
}

proc toggleMenubar {} {
  set ::gameInfo(showMenu) [expr !$::gameInfo(showMenu)]
  showMenubar
}

proc showMenubar {} {
  if {!$::gameInfo(showMenu)} {
    $::dot_w configure -menu {}
  } else {
    $::dot_w configure -menu .menu
  }
}

proc toggleButtonBar {} {
  if {!$::gameInfo(showButtons)} {
    grid remove .main.button
  } else {
    grid configure .main.button -row 1 -column 0 -pady 3 -padx 5
  }
}

proc toggleStatus {} {
  if {!$::gameInfo(showStatus)} {
    grid remove .main.statusbar
  } else {
    grid configure .main.statusbar -row 4 -column 0 -columnspan 3 -sticky we
  }
}

proc toggleGameInfo {} {
  set ::gameInfo(show) [expr ! $::gameInfo(show)]
  showGameInfo
  resizeMainBoard
}

proc showGameInfo {} {
  if {$::gameInfo(show)} {
    grid forget .main.gameInfoMini
    grid .main.gameInfoFrame -row 3 -column 0 -sticky nsew -padx 2
  } else  {
    grid forget .main.gameInfoFrame
    grid .main.gameInfoMini -row 3 -column 0 -padx 2
  }
  update idletasks
}

# Email configuration

set email(logfile) [file join $scidLogDir "scidmail.log"]
set email(smtp) 1
set email(smproc) "/usr/lib/sendmail"
set email(server) localhost
set email(from) ""
set email(bcc) ""

# Sound options

set ::utils::sound::announceNew 0
set ::utils::sound::announceForward 0
set ::utils::sound::announceBack 0
set ::utils::sound::announceTock 0
set ::utils::sound::soundFolder {} ;# disabled by default
set ::utils::sound::device {}

set ::book::lastBook1 {} ; # book name without extension (.bin)
set ::book::lastBook2 {}
set ::book::lastTuning {}
set ::book::sortAlpha 0
set ::book::showTwo 0
set ::book::oppMovesVisible 0

# Engines list file: -- OLD NAMES, NO LONGER USED
#set engines(file) [file join $scidUserDir "engines.lis"]
#set engines(backup) [file join $scidUserDir "engines.bak"]

# Engines data:
set engines(list) {}
set engines(sort) Time
set engines(F2)  0
set engines(F3)  1
set engines(F4)  {}

proc resetInformants {} {
  global informant
  array set informant {}
  set informant("!?")  0.5
  set informant("?")   1.5
  set informant("??")  3.0
  set informant("?!")  0.5
  set informant("+=")  0.5
  set informant("+/-") 1.5
  set informant("+-")  3.0
  set informant("++-") 5.5
}

resetInformants

# Nice icon from OSX,
# ... but it doesn't antialias well in the text widget !%^&*

image create photo icon -format gif -data {
R0lGODlhLwAvAOf/AA4OIAQNQgQNSAYPOAYPPQ0PKg4NOBcPFQ4LQw8QMBAN
PggOUAARVxEMSgkOVx0SDRARNhQSKCQTBQwRUw0XNhYWJhATTxkUNREWRi4V
AhUZMwkXXxMUVx0ZIQsYWR8bGhgXWxkeMzMaAhIcXiMeJx0cQyUiEhQeWjgd
AR4hPCsiFCoiGT4dAB4eVh8gUhogYyImMSEfXioqIx4lYjIrD0YkACkqMSQn
UycmX04nADkxFVIpAk8rATwzDiYuZj40BzczIzEuT1UrADQzMVAxAFgtADEv
YFAxDV0tAlUwCjQ4OlkvClgyAEQ6DS41Z2AvAFEzFjczXVoxCVY4ADM3ZVA3
F2IxB083HmQyAUo5J0s/Blg1Hkc8KEE5S007I2c1BDs7XF47AEg+LkQ/NFU5
Kmo3AEk6TD1EQFREBFk7J2c6Bzw+Zz9DRUNDO2Y7D0dBS1E9RldIAERGQ1Y+
PUFFV19GAE1DQ0JFY2hAHExHRnBCAGVDHURMSF1NAEJNTmhJAF1OBVZKNVRL
QGNIKEhMX0hLbGRTAmFSEHhKAEhTU2hSBG1RAFNMYlJPXkxVUElRbmhXAGxV
AGpPM2ZSOmVXI2lTNmtaDGFWPm5cAlBbXGJXR3FeAFJeXndfAIRZAGFdTmhb
RnZjAGRbYGFdXltjX3pmBYNkAFxjcGhhW31pAFxnaF1kd21mVHppKoNtAm5o
XGFsbWRsaIpuAIhxAINvHHVuVWdvdm9uZo9zAJNxAI12AW50aox2EJ9wAJB4
AH9zS5F5BpN7AKN0AJh6AIt4M5Z+AJqBBKJ9BZeAHZ2DAI1/UaCGAKSEAJ6F
C5WBO6OIAJ+GGqWKA5yGM7GEBpeFTJ6JJaiNAKyLAK2RALOQAaOOSLGUBLeU
ALqRCLCUFrSXALWYDLOXKrqcAL6aALyeBMGcBsOdAMGhAMiiAL+iLMKjH8en
AsylBM+oAMKlNdOsANeuAsytK9iwBtqxANSyDt+1AOK4AOm9AOW9De7CAPLF
APXHAPjKAPvMAP7PAP///yH5BAEKAP8ALAAAAAAvAC8AAAj+AP8JHEiw4MBb
X5gMQ/fuHbyHD98tS5bMmMWLxcyx24jOnMGPBfcgWTSuYT15J+nRK7esJbOJ
FJMtW0dzXbtzIHOCKkMkVbFm0b59O9eu3btszCompVhsWLZ3RduxQ5fz4y03
RRYVe5ZHkLFnz5ZF20bPJjpx3LJdY/ZMnNGi7HBWDVlkyqxlz3hdCILsWrRn
7eTRqQZvnsp5Da9Zy/ZNXLlycwm++sIDE96/liC0aGVtWz17sgJoWjfP8Dx0
yZIyK8Y68kA8T/4Me4YNWzZrhgxwuLTOnj16ijB08TZPHj1xTJMaK+b63yQs
PFzRrl37GSADE0DNs1dPnSIFJ4j+yZuXjeIyYxWZR36lhoeiZNmwbaO+zXoA
Bm/o3bPHrhOE3euE9RJFwxjj2h5PhGGOce/ENQ4329R3SAMMdPEOd+/4VyEw
0RjzUkvqVQUKdMPYo08++uyzz4kYigPEAgzY8Rk+7JRy3w28LMNMUscYWNUu
amQFzz368GPkivqcOE42w5QAYyDbnLNOOZgo4EALtCzTDIhzDYIFEdbkk88+
+fBDZpL54DMfNpRwwIAHpTCDDViHCOCAC9Bwg401y1TFyhc7mGJPmUYW2k+R
60SITTMnMLCADmBZM045QyywQBCkwcNOVW48MQU6+OzDTz+FGilmhNtkg0wM
DDCwQjD+1zzzzjzhOLoAJQ69k1Ml0OWCj5H9BEsqP0XSA84323jTiKMK/CCL
NdigNE8LDnBAgjllgYRQEX/IU6SwwRaajzjIYjMKBw4s8IEhsHLDXToeVNsB
M/Lo+tEeZfCATT79+OOvP+DmYw833FRTiKMCfBBHKM9E0xs9jXCwQANNMAPP
Oh+NyEMdUdKDz6/gGrlOOKzgMMECCpgQBybJ2AbPO6I44GgHmGRT70dYIEGE
L9uI4zM5QNPkcTy1GJFuAxE00Ucoy+yJjTsHnwwAJMOsc3NBXuYQiTVDiXMO
0ECDI80oMzAwgQAR/ADJJrpccw021aAywgQMILCCIrIsSI/+vQP9WVcyjYlD
juDkhPPLGh4w4EAAFWixiSyA7adOyQtInMAPm/gizjz1IFYQbDmEwtjPhaPi
g5sLGLACGqVA3s49+LiDygyoG6CCFpHIko1RhvH9jyT51sFMY5N688oMMApQ
AA2YzDIMN/IIrM0d8Vp++8p3hdWSXwdh8QQRs2zDTWPOOGFrAjT00Qkz6Njz
sTZggJCuABX0EEcfkOCClzVsvfSMj/9AUA4UEZTGsOIF81MZJFKxDiLpIx6P
AEGrBNAB3JkiFdl7hjXAgpeW9OkfO6mLL67xjWycawEOGEAP+mCKZJgDRfmg
Rgwm4ACkaaETs4gGOqzBQw4+o3/+OjLQLjqVA0gsQ3y1cBMDAvCDSMyiM0TK
Ry3mtsQVWOJZ7PiN2zT4Qw5Ggxno+YeXylAGRHgiF8R4gaXU1YdZyEccYlLG
BhzVAB10Ahig4s45erhBsERDJs+oyD+uUAQhIKEIWLCCEejmAAT0ABItw8Y7
8BEOEFhqAisIRTQ49xl7YOOLeOGgB5nyj0sU4ZSnnMMGFnCyArDgCWXQAyKE
wY1COOCWClDEMN7RyXq84y9rEdCHXGIgTZzykEvwAQrTdQAWCKEIT/iCFeZg
tpNFQBHX4KVK6oGODrrEg8NQDnNegcoizIEDJ6uhBGpQziVQQXGOOkANnoAF
M/ZiGsf+KFBMKKKcigxDPVKA5hKicEtHEUACOTjkKdNgyZMJYJ3H9B4WsBBL
M5pCFsMIRjKKYYxhJAMYAvmEF6pAhhOcTHEJEIEhDYkEOMjslgHIQA0UWs5D
PgGWsJSlJy4aDJAKJBOJuMNLLQUAFDzzkDwwwhqXmIFjovIJ5TRkEZCg0ImS
sSBrcAANHVWBIYyBC1dIwhZiILNWESADz4zqU9M6VYUiAaoFQZ6tGmADR5DC
EY7wAx08cDJLDcCoLH2CEJ5A1VMOtqY0JcgqJAbPACgBFgR5xC0nmwAZgPUI
OTDsSg1bzs4SpBAbSJelFMAGrE6grwyAgBzw6gc+tGEMIz2zgmEL29lTEoQK
W5XZABJREB+UFUYJyARBYnFXPrh2DGLwwhF2UNsiEGQG1VojBRzR276m6wLC
zYkq7tpaOYwhC2FdgnMFYosRwJMBHAgBKQoyglvCiAHqbc4/YqEKR2SCD3Jo
w0BWccl0wkAVBCnvSVmpAU7I1yAAFohkJ4tCG8SCIKdA3WTje2CQECIEGsiw
BiLwWAinQMMZ/m+Fc+II4/LBD601CCnYYGI2OOLBIx5IQAAAOw==
}

wm iconphoto . -default icon

# Opening files by drag & drop on Scid icon on Mac
if { $macOS } {
  # Drag & Drop
  set dndisbusy 0
  set isopenBaseready 0
  set dndargs 0

  proc dragndrop {args} {
    global dndisbusy
    global isopenBaseready
    global dndargs

    # Un-nest arguments:
    set args [join $args]

    # Wait for openBase to be ready, if needed.
    if {$isopenBaseready == 0} {
      if {$dndargs != 0} {
        tk_messageBox -type ok -icon info -title "Scid" -message \
            "Please, wait until Scid finish starting up."
        return
      } else {
        # Save file names for later use:
        set dndargs $args
      }
      return
    }

    # Are we busy opening files? if so, display message and do nothing
    if {$dndisbusy != 0} {
      tk_messageBox -type ok -icon info -title "Scid" -message \
          "Please, wait until the previou(s) database(s) are opened and try again."
      return
    }

    # Un-nest argumens again if Scid opened on drag & drop
    if {$isopenBaseready == 2} {
      # Un-nest arguments:
      set args [join $args]
      set isopenBaseready 1
    }

    set dndisbusy 1
    set errmsg ""
    foreach file $args {
      # Check for available slots:
      if {[sc_base count free] == 0} {
        tk_messageBox -type ok -icon info -title "Scid" \
            -message "Too many databases are open; close at least one \n\
            before opening more databases"
        #::splash::add "No slot available."
        return
      }
      set ext [file extension $file]
      # Email File:
      if {$ext == ".sem"} {
        #::tools::email
        continue
      }
      # SearchOptions file:
      if {$ext == ".sso"} {
        set ::fName $file
        if {[catch {uplevel "#0" {source $::fName}} errmsg]} {
          tk_messageBox -title "Scid: Error reading file" -type ok -icon warning \
              -message "Unable to open or read SearchOptions file: $file"
        } else {
          switch -- $::searchType {
            "Material" { ::search::material }
            "Header"   { ::search::header }
            default    { continue }
          }
        }
        continue
      }
      if {$ext == ".sg4" || $ext == ".sn4"} {
        set file "[file rootname $file].si4"
      }
      if {$ext == ".sg3" || $ext == ".sn3"} {
        set file "[file rootname $file].si3"
      }

      # Check if base is already opened
      set slot [sc_base slot $file]
      if {$slot != 0} {
        sc_base switch $slot
        refreshWindows
        updateBoard -pgn
      } else  {
        # All seems good, let's open those files:
        wm deiconify $::dot_w
        ::file::Open $file
        focus .main
      }
    }
    set dndisbusy 0
    set dndargs 0
  }
  proc tkOpenDocument {args} {
    after idle [list dragndrop $args]
  }
  rename tkOpenDocument ::tk::mac::OpenDocument

  # Hack to allow focus and text copy from disabled text widgets on OSX
  rename text ::tk::mac::text
  proc text {w args} {
    eval ::tk::mac::text $w $args
    bind $w <1> "focus $w"
    $w configure -highlightthickness 0
  }
}

# Add empty updateStatusBar proc to avoid errors caused by early
# closing of the splash window:
#
proc updateStatusBar {} {}

set ::splash::keepopen 1
set ::splash::cache {}

# the function gets redfined once the fonts have been read from options.dat

proc ::splash::add {text {tag {indent}}} {
  lappend ::splash::cache $text
}

# Remember old font settings before loading options file:
set fontOptions(oldRegular) $fontOptions(Regular)
set fontOptions(oldMenu) $fontOptions(Menu)
set fontOptions(oldSmall) $fontOptions(Small)
set fontOptions(oldTiny) $fontOptions(Tiny)
set fontOptions(oldFixed) $fontOptions(Fixed)

# New configuration file names:
set scidConfigFiles(options)     options.dat
set scidConfigFiles(engines)     engines.dat
set scidConfigFiles(engines.bak) engines.dat
set scidConfigFiles(recentfiles) recent.dat
set scidConfigFiles(history)     history.dat
set scidConfigFiles(bookmarks)   bookmarks.dat
set scidConfigFiles(reports)     reports.dat
set scidConfigFiles(optrainer)   optrainer.dat

set ecoFile {}

set addRatings(overwrite) 0
set addRatings(filter)    1

# scidConfigFile:
#   Returns the full path and name of a Scid configuration file,
#   given its configuration type.
#
proc scidConfigFile {type} {
  global scidConfigDir scidConfigFiles
  if {! [info exists scidConfigFiles($type)]} {
    return -code error "No such config file type: $type"
  }
  return [file nativename [file join $scidConfigDir $scidConfigFiles($type)]]
}

# Create user ".scid" directory in Unix if necessary:
# Since the options file used to be ".scid", rename it:
if {! [file isdirectory $scidUserDir]} {
  if {[catch {file mkdir $scidUserDir} err]} {
    ::splash::add "Error creating $scidUserDir directory: $err" error
  } else {
    catch {file rename "$scidUserDir.old" $optionsFile}
  }
}

# Create the config, data and log directories if they do not exist:
proc makeScidDir {dir} {
  if {![file isdirectory $dir] || ![file writable $dir]} {
    if {[catch {file mkdir $dir} err]} {
      ::splash::add "Error creating directory $dir: $err" error
    } else {
      ::splash::add "Created directory: $dir"
    }
  }
}

makeScidDir $scidConfigDir
makeScidDir $scidDataDir
makeScidDir $scidLogDir

# moveOldConfigFiles removed S.A

set optionsFile [scidConfigFile options]

::splash::add "Command line is \"$::argv0 $::argv\""
::splash::add "User directory is \"$scidUserDir\""

if {[info tclversion] >= "8.6"} { 
  ::splash::add "png image support is available."
  set png_image_support 1
  set boardStyle Merida1
} elseif { [catch { package require img::png } ] } {
  ::splash::add "TkImg not found. Most piece sets are disabled."
  set png_image_support 0
  set boardStyle Alpha
} else {
  ::splash::add "TkImg found. Enabling png image support."
  set png_image_support 1
  set boardStyle Merida1
}

set useGraphFigurine 1

if {[catch {source $optionsFile} ]} {
  ::splash::add "Error loading options file \"$optionsFile\"" error
} else {
  ::splash::add "Loaded options from \"$optionsFile\"."
}

if { [string first "-dock" [lindex $argv 0]] > -1} {
  set windowsDock 1
}

if { [string first "-nodock" [lindex $argv 0]] > -1} {
  # reset in case of error recovery
  set windowsDock 0
  ::docking::init_layout_list  1
}

if { [string first "-dock" [lindex $argv 0]] > -1} {
  set windowsDock 1
}

set ::docking::USE_DOCKING $windowsDock

if {$::docking::USE_DOCKING} {
  set dot_w .
} else  {
  set dot_w .main
}

if {$enableBackground} {
  option add *Text*background $defaultBackground
  option add *Listbox*background $defaultBackground
}

# Reconfigure fonts if necessary

foreach i {Regular Menu Small Tiny Fixed} {
  if {$fontOptions($i) == $fontOptions(old$i)} {
    # Old font format in options file, or no file. Extract new options:
    set fontOptions($i) {}
    lappend fontOptions($i) [font actual font_$i -family]
    lappend fontOptions($i) [font actual font_$i -size]
    lappend fontOptions($i) [font actual font_$i -weight]
    lappend fontOptions($i) [font actual font_$i -slant]
  } else {
    # New font format in options file:
    configureFont $i
  }
}

# make font_Regular the default font for widgets

set fd_size [font actual font_Regular -size]
option add *Font font_Regular
option add *Menu*Font font_Menu
# option add *Menubutton*Font font_Menu
if {$unixOS} {
  option add Scrollbar*borderWidth 1
}

### Fonts now fully configure :> S.A

### Takes an entrybox, a (global?) var, and a text widget
#   Binds Entry <Return> to search the text widget for entry box contents

proc configFindEntryBox {entry var text} {
    upvar $var topvar

    ### This code originally in htext.tcl::updateHelpWindow
    $text tag configure Highlight -background orange

    set topvar(findprev) {}
    set topvar(findindex) 1.0
    bind $entry <Return> "nextFindEntryBox $entry $var $text"
    bind [winfo toplevel $entry] <Control-f> "focus $entry"
}

proc nextFindEntryBox {entry var text} {
    upvar 1 $var topvar

    if {$topvar(findprev) != $topvar(find)} {
      set topvar(findprev) $topvar(find)
    }
    $text tag remove Highlight 1.0 end

    if {[catch {
          set result [$text search -regexp -nocase -- $topvar(find) $topvar(findindex)]
        }]} {
      flashEntryBox $entry
      return
    }
    if {$result == {}} {
      set topvar(findindex) 1.0
      bell
    } else {
      if {[ regexp {(.*)\.(.*)} $result t1 line char]} {
        $text see $result
        # find the length of matching text
        regexp -nocase -- $topvar(find) [$text get $line.0 $line.end] matchVar
        set length [string length $matchVar]
        if {$length < 1} {
          set length 1
        }
        $text tag add Highlight $result $line.[expr $char + $length]
        set topvar(findindex) $line.[expr $char + 1]
      } ;# should always succeed ?
    }
}

### [bell] doesnt work on all platforms (esp. Linux), so make our own

proc flashEntryBox {w} {
      set bg [$w cget -background]
      set fg [$w cget -foreground]
      $w configure -background $fg -foreground $bg
      after 200 "$w configure -background $bg -foreground $fg"
}

### Add basic Bash-style history to entry boxes
#   (History up/down with arrows, Control-c to cancel, and alt-backspace to delete a word)

proc  configHistory {namespace entrybox} {

  set ::${namespace}::entrybox $entrybox

  bind $entrybox <Up> "::${namespace}::cmdHistory up"
  bind $entrybox <Down> "::${namespace}::cmdHistory down"
  if {$::macOS} {
    bind $entrybox <Option-BackSpace> "::${namespace}::cmdBackWord ; break"
  } else {
    bind $entrybox <Alt-BackSpace> "::${namespace}::cmdBackWord ; break"
  }

  namespace eval $namespace {
    variable history
    variable history_pos
    variable history_current
    variable entrybox

    set history {}
    set history_pos 0
    set history_current 0

    namespace export addHistory cmdHistory cmdClear cmdBackWord

    proc addHistory {text} {
      variable history
      variable history_pos
      variable history_current
      variable entrybox
      
      if {[lindex $history end] != $text} {
	lappend history $text
      }
      set history_pos [llength $history]
    }

    proc cmdHistory {action} {
      variable history
      variable history_pos
      variable history_current
      variable entrybox
      
      set t $entrybox

      if {$action == "up" && $history_pos > 0} {
	if {$history_pos == [llength $history]} {
	  set history_current [$t get]
	}
	$t delete 0 end
	incr history_pos -1
	$t insert end [lindex $history $history_pos]
      }
      if {$action == "down"} {
	if {$history_pos < [llength $history]} {
	  $t delete 0 end
	  incr history_pos
	  if {$history_pos == [llength $history]} {
	    set  entry $history_current 
	  } else {
	    set entry [lindex $history $history_pos]
	  }
	  $t insert end $entry
	}
      }
    }

    proc cmdBackWord {} {
      variable entrybox

      # bash like delete last word on command line
      set entry [$entrybox get]
      # break line into two parts (before/after cursor)
      set i [$entrybox index insert]
      set t1 [string range $entry 0 $i-1]
      set t2 [string range $entry $i end]
      if {[string is space [string index $t1 end]]} {
	while {[string is space [string index $t1 end]]} {
	  set t1 [string range $t1 0 end-1]
          # Oops. "" is space !
	  if {$t1 == ""} { return }
	}
      } else {
	set j [string last { } $t1]
	set t1 [string range $t1 0 $j-1]
      }
      $entrybox delete 0 end
      $entrybox insert end $t1$t2

      $entrybox icursor [string length $t1]
    }

    proc cmdClear {} {
      variable history
      variable history_pos
      variable entrybox

      $entrybox delete 0 end
      set history_pos [llength $history]
    }

  }
}

### Start up splash window

proc ::splash::make {} {
  ### windows hack 
  # Dont withdraw toplevel if windows and docked mode, because of rendering bugs in paned windows/tabs
  if {!($::windowsOS && $::docking::USE_DOCKING)} {
     wm withdraw .
  }
  set w [toplevel .splash]
  wm withdraw $w
  wm protocol $w WM_DELETE_WINDOW [list wm withdraw $w]
  wm title $w "Welcome to $::scidName $::scidVersion"

  ### Pack in this order to resize nicely
  # buttons
  frame $w.b
  pack $w.b -side bottom -fill x

  # command entry
  entry $w.command
  pack $w.command -side bottom -fill x -padx 3 -pady 2

  configHistory splash $w.command

  # text
  frame $w.f
  pack $w.f -side top -expand yes -fill both

  text $w.t -height 15 -width 55 -cursor top_left_arrow \
       -font font_Regular -wrap word \
      -yscrollcommand [list $w.ybar set] -setgrid 1
  scrollbar $w.ybar -command [list $w.t yview]
  # Hmm - translations aren't set up yet
  checkbutton $w.auto -text "Keep open after startup" \
      -variable ::splash::keepopen -font font_Small -pady 5 -padx 5
  button $w.dismiss -text Close -width 8 -command [list wm withdraw $w] \
      -font font_Small

  entry $w.find -width 10 -textvariable ::splash::find(find) -highlightthickness 0
  configFindEntryBox $w.find ::splash::find $w.t

  set ::splash::console 0
  bind $w.command <Return> {
    if {!$::splash::console} {
      set ::splash::console 1
      ::splash::add {}
      ::splash::add "$scidName $scidVersion Console"
      ::splash::add {------------------------------------}
    }
    set command [string trim [.splash.command get]]
    ::splash::add "# $command"
    ::splash::addHistory $command
    if {$command != {}} {
      if {[catch {set result [eval $command]} error]} {
	::splash::add "> $error"
      } else {
	::splash::add "> $result"
      }
    }
    .splash.t see end
    .splash.command delete 0 end
  }


  pack $w.auto -side left -in .splash.b -pady 2 -ipadx 10 -padx 10
  pack $w.find $w.dismiss -side right -in .splash.b -pady 2 -ipadx 10 -padx 10
  pack $w.ybar -in $w.f -side right -fill y
  pack $w.t -in $w.f -side left -fill both -expand yes

  # Centre the splash window:
  update idletasks
  set x [expr {[winfo screenwidth $w]/2 - [winfo reqwidth $w]/2 \
        - [winfo vrootx .]}]
  set y [expr {[winfo screenheight $w]/2 - [winfo reqheight $w]/2 \
        - [winfo vrooty .]}]
  wm geom $w +$x+$y
  wm deiconify $w

  bind $w <F1> {helpWindow Contents}
  bind $w <Escape> {.splash.dismiss invoke}

  $w.t tag configure indent -lmargin2 20
  $w.t tag configure error -foreground red
  $w.t tag configure scid_title -font {Arial 24 normal} -foreground darkslateblue

  $w.t insert end "        $::scidName     " scid_title
  $w.t image create end -image icon -padx 20 -pady 10
}

# new logo from www.vitualpieces.net

::splash::make

proc ::splash::add {text {tag {indent}}} {
  if {[winfo exists .splash]} {
    .splash.t insert end "\n$text" $tag
    if {$tag == {error}} {
      if {$::windowsOS} {
	puts $text
      } else {
	puts stderr $text
      }
    }
  }
}

::splash::add "$::scidName $::scidVersion ($::scidVersionDate)."
::splash::add "http://scidvspc.sourceforge.net"
::splash::add ""
::splash::add "(C) Steven Atkinson (stevenaaus@yahoo.com) 2008-2016"
::splash::add "(C) Pascal Georges 2006-2008"
::splash::add "(C) Shane Hudson 1999-2004"
::splash::add "(C) Gregor Cramer, Fulvio Benini and others."
::splash::add "Licenced under the GNU General Public License."
::splash::add ""

# add cached splash comments
foreach line $::splash::cache {
  ::splash::add $line
}

# A lot of code assumes tcl_platform is either windows or unix, so
# lotsa stuff may break if this is not the case.

::splash::add "Using Tcl/Tk version: [info patchlevel]"
::splash::add "$tcl_platform(os) operating system, version $tcl_platform(osVersion)"
if {(! $windowsOS)  &&  (! $unixOS)} {
  ::splash::add "Operating System may not be supported"
}
if {[string match -nocase Linux $tcl_platform(os)]} {
  catch {
    ::splash::add "[eval exec cat [glob /etc/*-release] | uniq]"
  }
}

catch {
  ::splash::add "LANG environment var is $::env(LANG)"
}

::splash::add ""

### Workaround a bug in Wish 8.5.10 ttk::scale.
# To trigger, press Control-l three times and try to move y scrollbar

set buggyttk [expr {[info patchlevel] == {8.5.10}}]
if {$buggyttk} {
      ::splash::add "Warning - Disabling Tk-8.5.10's buggy ttk::scale widget." error
}


# Check board size is valid:
set newSize [lindex $boardSizes 0]
foreach sz $boardSizes {
  if {$boardSize >= $sz} { set newSize $sz }
}
set boardSize $newSize

# Load theme
catch {ttk::style theme use $lookTheme}
::ttk::style configure TNotebook.Tab -font font_Menu

# Check for old (single-directory) tablebase option:
if {[info exists initialDir(tablebase)]} {
  set initialDir(tablebase1) $initialDir(tablebase)
}

set fontsize [font configure font_Regular -size]
set font [font configure font_Regular -family]

font create font_Bold -family $font -size $fontsize -weight bold
font create font_BoldItalic -family $font -size $fontsize -weight bold \
    -slant italic
font create font_Italic -family $font -size $fontsize -slant italic
font create font_H1 -family $font -size [expr {$fontsize + 16} ] -weight bold
font create font_H2 -family $font -size [expr {$fontsize + 6} ] -weight bold
font create font_H3 -family $font -size [expr {$fontsize + 4} ] -weight bold
font create font_H4 -family $font -size [expr {$fontsize + 2} ] -weight bold
font create font_H5 -family $font -size [expr {$fontsize + 0} ] -weight bold

set fontsize [font configure font_Small -size]
set font [font configure font_Small -family]
font create font_SmallBold -family $font -size $fontsize -weight bold
font create font_SmallItalic -family $font -size $fontsize -slant italic

# Hidden-file dialog hack
# https://sourceforge.net/p/pure-data/patches/208/
catch {tk_getOpenFile -with-invalid-argument}
namespace eval ::tk::dialog::file {
  variable showHiddenBtn 1
  variable showHiddenVar 0
}

## ttk init
# Gregor's code to give readonly combos/enrties/spinboxes a non-grey background
set fbg {}
switch "_$::ttk::currentTheme" {
   _alt     { set fbg [list readonly white disabled [ttk::style lookup $::ttk::currentTheme -background]] }
   _clam    { set fbg [list readonly white {readonly focus} [ttk::style lookup $::ttk::currentTheme -selectbackground]] }
   _default { set fbg [list readonly white disabled [ttk::style lookup $::ttk::currentTheme -background]] }
}
if {[llength $fbg]} {
   ttk::style map TCombobox -fieldbackground $fbg
   ttk::style map TEntry -fieldbackground $fbg
   if {[info tclversion] >= "8.6"} { 
      ttk::style map TSpinbox -fieldbackground $fbg
   }
}

# Start in the clipbase, if no database is loaded at startup.
sc_base switch clipbase

###
### End of file: start.tcl
