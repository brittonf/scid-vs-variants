#
# english.tcl:
#
# Instructions for adding a new language:
#
# (1) Choose a letter code for the language. Currently assigned codes are:
#      E=English, D=Deutsch, F=Francais, S=Spanish, B=Brasil Portuguese, U=Portuguese
#      P=Polish, N=Nederlands, W=Swedish, O=Norsk, C=Czech, H=Hungarian,
#      Y=Serbian.
#
# (2) Edit the code below that has the lines "addLanguage ..." and add your
#     new language. The final digit in each line is the index of the
#     letter to underline in the menu, counting from 0 as the first letter.
#
# (3) Change anything "in quotes" or {in braces} for the menuText and translate commands.
#
#     A menu command has the format:
#         menuText L tag "Name..." underline {HelpMessage}
#
#     A general word or message translation has the format:
#         translate L tag {message}
#
# Notes:
#
#     "HelpMessage" can be left out if desired, as they are not currently used in Scid vs. PC
#
#     "underline" is the index of the letter to underline, counting from 0
#     as the first letter. Two menu entries
#     that appear in the same menu should have a different underlined letter.
#     If in doubt, just make them all "0"
#
# (4) Optionally, make new help entries such as
#
#     set helpTitle(D,Contents) "Inhaltsverzeichnis"
#     set helpText(D,Contents) {<h1>Inhaltsverzeichnis Scid-Hilfe</h1>...}
#     ..... see deutsch.tcl for an example.

addLanguage E English 0

proc setLanguage_E {} {

# File menu:
menuText E File "File" 0
menuText E FileNew "New" 0 {Create a new Scid database}
menuText E FileOpen "Open" 0 {Open an existing Scid database}
menuText E FileClose "Close" 0 {Close the active Scid database}
menuText E FileFinder "Finder" 0 {Open the File Finder window}
menuText E FileSavePgn "Save PGN" 0 {Save this game to file}
menuText E FileOpenBaseAsTree "Open Base as Tree" 13   {Open a base and use it in Tree window}
menuText E FileOpenRecentBaseAsTree "Open Recent as Tree" 0   {Open a recent base and use it in Tree window}
menuText E FileBookmarks "Bookmarks" 0 {Bookmarks menu}
menuText E FileBookmarksAdd "Add Bookmark" 0 \
  {Bookmark the current database game and position}
menuText E FileBookmarksFile "File Bookmark" 0 \
  {File a bookmark for the current game and position}
menuText E FileBookmarksEdit "Edit Bookmarks" 0 \
  {Edit the bookmarks menus}
menuText E FileBookmarksList "Display Folders as Single List" 0 \
  {Display bookmark folders as a single list, not submenus}
menuText E FileBookmarksSub "Display Folders as Submenus" 0 \
  {Display bookmark folders as submenus, not a single list}

menuText E FileReadOnly "Read-Only" 0 \
  {Treat the current database as read-only, preventing changes}
menuText E FileSwitch "Switch to Base" 1 \
  {Switch to a different opened database}
menuText E FileExit "Exit" 1 {Exit Scid}

# Edit menu:
menuText E Edit "Edit" 0
menuText E EditAdd "Add Variation" 0 {Add a variation at this move in the game}
menuText E EditPasteVar "Paste Variation" 0
menuText E EditDelete "Delete Variation" 0 {Delete a variation for this move}
menuText E EditFirst "Make First Variation" 5 \
  {Promote a variation to be first in the list}
menuText E EditMain "Promote Variation" 21 \
  {Promote a variation to be the main line}
menuText E EditTrial "Try Variation" 0 \
  {Start/stop trial mode, for testing an idea on the board}
menuText E EditStrip "Strip" 0 {Strip comments or variations from this game}
menuText E EditUndo "Undo" 0 {Undo last game change}
menuText E EditRedo "Redo" 0 {Redo last game change}
menuText E EditStripComments "Comments" 0 \
  {Strip all comments and annotations from this game}
menuText E EditStripVars "Variations" 0 {Strip all variations from this game}
menuText E EditStripBegin "Moves from Start" 11 \
  {Strip moves from the beginning of the game}
menuText E EditStripEnd "Moves to End" 9 \
  {Strip moves to the end of the game}
menuText E EditReset "Empty Clipbase" 0 \
  {Reset the clipbase to be completely empty}
menuText E EditCopy "Copy to Clipbase" 1 \
  {Copy this game to the Clipbase database}
menuText E EditPaste "Paste from Clipbase" 1 \
  {Paste the active Clipbase game here}
menuText E EditPastePGN "Paste PGN" 0 \
  {Interpret the clipboard text as PGN and paste it here}
menuText E EditSetup "Setup Board" 6 \
  {Set the start position for this game}
menuText E EditCopyBoard "Copy FEN" 5 \
  {Copy the current board in FEN notation to the text selection (clipboard)}
menuText E EditCopyPGN "Copy PGN" 0 \
  {Copy the current PGN to the text selection (clipboard)}
menuText E EditPasteBoard "Paste FEN" 6 \
  {Set the start board from the current text selection (clipboard)}

# Game menu:
menuText E Game "Game" 0
menuText E GameNew "New Game" 0 {Reset to an empty game, discarding any changes}
menuText E GameFirst "Load First" 5 {Load the first filtered game}
menuText E GamePrev "Load Previous" 5 {Load the previous filtered game}
menuText E GameReload "Reload Game" 2 {Reload this game, discarding any changes made}
menuText E GameNext "Load Next" 7 {Load the next filtered game}
menuText E GameLast "Load Last" 8 {Load the last filtered game}
menuText E GameRandom "Load Random Game" 8 {Load a random filtered game}
menuText E GameNumber "Load Game Number" 5 {Load a game by entering its number}
menuText E GameReplace "Replace Game" 0 {Save this game, replacing the old version}
menuText E GameAdd "Add Game" 0 {Save this game as a new game in the database}
menuText E GameInfo "Set Game Information" 9
menuText E GameBrowse "Browse Game" 0
menuText E GameList "List all Games" 0
menuText E GameDelete "Delete Game" 0
menuText E GameDeepest "Identify Opening" 0 {Goto the deepest game position listed in the ECO book}
menuText E GameGotoMove "Goto Move Number" 5 {Go to a specified move number in the current game}
menuText E GameNovelty "Find Novelty" 7 {Find the first move of this game that has not played before}

# Search Menu:
menuText E Search "Search" 0
menuText E SearchReset "Reset Filter" 0 {Reset the filter so all games are included}
menuText E SearchNegate "Negate Filter" 0 {Negate the filter to only include excluded games}
menuText E SearchEnd "Filter to Last Move" 15 {All filter games load at the end position}
menuText E SearchCurrent "Current Board" 0 {Search for the current board position}
menuText E SearchHeader "General" 0 {Search by Header (player, event, etc) information}
menuText E SearchMaterial "Material/Pattern" 0 {Search for material or board patterns}
menuText E SearchMoves "Moves" 0 {}
menuText E SearchUsing "Load Search File" 0 {Search using a SearchOptions file}

# Windows menu:
menuText E Windows "Windows" 0
menuText E WindowsGameinfo "Game Info" 0 {Show/hide the game info panel}
menuText E WindowsComment "Comment Editor" 9 {Open/close the comment editor}
menuText E WindowsGList "Game List" 0 {Open/close the game list window}
menuText E WindowsPGN "PGN Window" 0 {Open/close the PGN (game notation) window}
menuText E WindowsCross "Crosstable" 0 {Open/close the Tournament Crosstable}
menuText E WindowsPList "Player Finder" 2 {Open/close the player finder}
menuText E WindowsTmt "Tournaments" 2 {Open/close the tournament finder}
menuText E WindowsSwitcher "Databases" 0  {Open/close the Database Switcher window}
menuText E WindowsMaint "Maintenance Window" 0 {Open/close the Maintenance window}
menuText E WindowsECO "ECO Browser" 0 {Open/close the ECO Browser window}
menuText E WindowsStats "Statistics Window" 0 {Open/close the filter statistics window}
menuText E WindowsTree "Tree Window" 0 {Open/close the Tree window}
menuText E WindowsTB "Tablebase Window" 1 {Open/close the Tablebase window}
menuText E WindowsBook "Book Window" 0 {Open/close the Book window}
menuText E WindowsCorrChess "Correspondence Window" 1 {Open/close the Correspondence window}

# Tools menu:
menuText E Tools "Tools" 0
menuText E ToolsAnalysis "Analysis Engines" 0 {Configure analysis engines}
menuText E ToolsEmail "Email Manager" 0 {Open/close the email chess manager window}
menuText E ToolsFilterGraph "Rel. Filter Graph" 12 {Open/close the filter graph window for relative values}
menuText E ToolsAbsFilterGraph "Abs. Filter Graph" 7 {Open/close the filter graph window for absolute values}
menuText E ToolsOpReport "Opening Report" 0 {Generate an opening report for the current position}
menuText E ToolsTracker "Piece Tracker"  6 {Open the Piece Tracker window}
menuText E ToolsTraining "Training"  7 {Training tools (tactics, openings,...) }
menuText E ToolsComp "Tournament" 0 {Chess engine tournament}
menuText E ToolsTacticalGame "Computer - Phalanx"  0 {Play a game with tactics}
menuText E ToolsSeriousGame "Computer - UCI Engine"  11 {Play against an UCI engine}
menuText E ToolsTrainTactics "Mate in ..N.. Puzzle"  0 {Solve "Mate in" puzzles}
menuText E ToolsTrainCalvar "Calculation of Variations"  0 {Stoyko Exercise}
menuText E ToolsTrainFindBestMove "Find Best Move"  0 {Find best move}
menuText E ToolsTrainFics "Internet (FICS)"  0 {Play on freechess.org}
menuText E ToolsBookTuning "Book tuning" 0 {Book tuning}

menuText E ToolsMaint "Maintenance" 0 {Scid database maintenance tools}
menuText E ToolsMaintWin "Maintenance Window" 0 {Open/close the Scid database maintenance window}
menuText E ToolsMaintCompact "Compact Database" 0 {Compact database files, removing deleted games and unused names}
menuText E ToolsMaintClass "ECO-Classify Games" 2 {Recompute the ECO code of all games}
menuText E ToolsMaintSort "Sort Database" 0 {Sort all games in the database}
menuText E ToolsMaintDelete "Delete Twin Games" 0 {Find twin games and set them to be deleted}
menuText E ToolsMaintTwin "Twin Checker Window" 0 {Open/update the Twin checker window}
menuText E ToolsMaintNameEditor "Name Editor" 0 {Open/close the name editor window}
menuText E ToolsMaintNamePlayer "Spellcheck Player Names" 11 {Spellcheck player names using the spellcheck file}
menuText E ToolsMaintNameEvent "Spellcheck Event Names" 11 {Spellcheck event names using the spellcheck file}
menuText E ToolsMaintNameSite "Spellcheck Site Names" 11 {Spellcheck site names using the spellcheck file}
menuText E ToolsMaintNameRound "Spellcheck Round Names" 11 {Spellcheck round names using the spellcheck file}
menuText E ToolsMaintFixBase "Repair base" 0 {Try to repair a corrupted base}

menuText E ToolsConnectHardware "Connect Hardware" 0 {Connect external hardware}
menuText E ToolsConnectHardwareConfigure "Configure..." 0 {Configure external hardware and connection}
menuText E ToolsConnectHardwareNovagCitrineConnect "Connect Novag Citrine" 9 {Connect Novag Citrine with Scid}
menuText E ToolsConnectHardwareInputEngineConnect "Connect Input Engine" 9 {Connect Input Engine (e.g. DGT board) with Scid}
# these three unused
menuText E ToolsNovagCitrine "Novag Citrine" 0 {Novag Citrine}
menuText E ToolsNovagCitrineConfig "Configuration" 0 {Novag Citrine configuration}
menuText E ToolsNovagCitrineConnect "Connect" 0 {Novag Citrine connect}

menuText E ToolsPInfo "Player Information"  0 \
  {Open/update the Player Information window}
menuText E ToolsPlayerReport "Player Report" 3 \
  {Generate a player report}
menuText E ToolsRating "Player Ratings" 0 \
  {Graph the rating history of the current game players}
menuText E ToolsScore "Score Graph" 0 {Show the score graph window}
menuText E ToolsExpCurrent "Export Current Game" 8 \
  {Write current game to a text file}
menuText E ToolsExpCurrentPGN "Export Game to PGN" 15 \
  {Write current game to a PGN file}
menuText E ToolsExpCurrentHTML "Export Game to HTML" 15 \
  {Write current game to a HTML file}
menuText E ToolsExpCurrentHTMLJS "Export Game to HTML and JavaScript" 15 {Write current game to a HTML and JavaScript file}  
menuText E ToolsExpCurrentLaTeX "Export Game to LaTeX" 15 {Write current game to a LaTeX file using xSkak}
menuText E ToolsExpFilter "Export All Filter Games" 1 \
  {Write all filtered games to a text file}
menuText E ToolsExpFilterPGN "Export Filter to PGN" 17 \
  {Write all filtered games to a PGN file}
menuText E ToolsExpFilterHTML "Export Filter to HTML" 17 \
  {Write all filtered games to a HTML file}
menuText E ToolsExpFilterHTMLJS "Export Filter to HTML and JavaScript" 17 {Write all filtered games to a HTML and JavaScript file}  
menuText E ToolsExpFilterLaTeX "Export Filter to LaTeX" 17  {Write all filtered games to a LaTeX file}
menuText E ToolsExpFilterGames "Export Gamelist to Text" 19 {Print a formatted Gamelist.}
menuText E ToolsImportOne "Import PGN Text" 0 \
  {Import a game from PGN text}
menuText E ToolsImportFile "Import PGN File" 7 {Import games from a PGN file}
menuText E ToolsStartEngine1 "Start engine 1" 0  {Start engine 1}
menuText E ToolsStartEngine2 "Start engine 2" 0  {Start engine 2}
menuText E ToolsScreenshot "Board Screenshot" 0  {Take a screenshot}

# Play menue
menuText E Play "Play" 0 {Play Games}

# --- Correspondence Chess
menuText E CorrespondenceChess "Correspondence Chess" 0 {Functions for eMail and Xfcc based correspondence chess}
menuText E CCConfigure "Configure" 0 {Configure external tools and general setup}
menuText E CCConfigRelay "Observe games" 10 {Configure games to be observed}
menuText E CCOpenDB "Open Database" 0 {Open the default Correspondence database}
menuText E CCRetrieve "Retrieve Games" 0 {Retrieve games via external (Xfcc-)helper}
menuText E CCInbox "Process Inbox" 8 {Process all files in scids Inbox}
menuText E CCSend "Send Move" 0 {Send your move via eMail or external (Xfcc-)helper}

menuText E CCResign "Resign" 1 {Resign (not via eMail)}
menuText E CCClaimDraw "Claim Draw" 6 {Send move and claim a draw (not via eMail)}
menuText E CCOfferDraw "Offer Draw" 1 {Send move and offer a draw (not via eMail)}
menuText E CCAcceptDraw "Accept Draw" 0 {Accept a draw offer (not via eMail)}

menuText E CCNewMailGame "New eMail Game" 2 {Start a new eMail game}
menuText E CCMailMove "Mail Move" 0 {Send the move via eMail to the opponent}
menuText E CCGamePage "Game Page" 0 {Call up the game via the web browser}

# menu in cc window:
menuText E CCEditCopy "Copy Gamelist to Clipbase" 0 {Copy the games as CSV list to clipbase}


#  B    GHiJKL    Q  TUV XYZ

# Options menu:
menuText E Options "Options" 0
menuText E OptionsBoard "Chessboard/Pieces" 0 {Chess board appearance}
menuText E OptionsColour "Colors" 0 {Default text widget color}
menuText E OptionsBackColour "Background" 0 {Default text widget color}
menuText E OptionsEnableColour "Enable Background Color" 0 {}
menuText E OptionsMainLineColour "Mainline Arrows" 0 {Mainline arrows}
menuText E OptionsVarLineColour "Variation Arrows" 0 {Variation arrows}
menuText E OptionsRowColour "Rows" 0 {Default tree/book row color}
menuText E OptionsSwitcherColour "Switcher" 0 {Default db switcher color}
menuText E OptionsProgressColour "Progressbar" 0 {Default progressbar color}
menuText E OptionsCrossColour "Crosstable rows" 0 {Default crosstable row color}
menuText E OptionsNames "My Player Names" 3 {Edit my player names}
menuText E OptionsExport "Exporting" 0 {Change text export options}
menuText E OptionsFonts "Fonts" 0 {Change fonts}
menuText E OptionsFontsRegular "Regular" 0 {Change the regular font}
menuText E OptionsFontsMenu "Menu" 0 {Change the menu font}
menuText E OptionsFontsSmall "Small" 0 {Change the small font}
menuText E OptionsFontsFixed "Fixed" 0 {Change the fixed-width font}
menuText E OptionsGInfo "Game Information" 0 {Game information options}
menuText E OptionsFics "FICS" 0 {Free Chess Internet Server}
menuText E OptionsFicsAuto "Autopromote Queen" 0
menuText E OptionsFicsColour "Text Color" 0
menuText E OptionsFicsSize "Board Size" 0
menuText E OptionsFicsButtons "User Buttons" 0
menuText E OptionsFicsCommands "Init Commands" 0
menuText E OptionsFicsNoRes "No Results" 0
menuText E OptionsFicsNoReq "No Requests" 0
menuText E OptionsFicsPremove "Allow Premove" 0

menuText E OptionsLanguage "Language" 0 {Select menu language}
menuText E OptionsMovesTranslatePieces "Translate Pieces" 0 {Translate first letter of pieces}
menuText E OptionsMovesHighlightLastMove "Highlight Last Move" 0 {Highlight last move}
menuText E OptionsMovesHighlightLastMoveDisplay "Show" 0 {Display last move Highlight}
menuText E OptionsMovesHighlightLastMoveWidth "Width" 0 {Thickness of line}
menuText E OptionsMovesHighlightLastMoveColor "Color" 0 {Color of line}
menuText E OptionsMoves "Moves" 0 {Move entry options}
menuText E OptionsMovesAsk "Ask Before Replacing Moves" 0 \
  {Ask before overwriting any existing moves}
menuText E OptionsMovesAnimate "Animation Time" 1 \
  {Set the amount of time used to animate moves}
menuText E OptionsMovesDelay "Autoplay Time Delay" 1 \
  {Set the time delay for autoplay mode}
menuText E OptionsMovesCoord "Coordinate Move Entry" 0 \
  {Accept coordinate-style move entry (e.g. "g1f3")}
menuText E OptionsMovesSuggest "Show Suggested Moves" 0 \
  {Turn on/off move suggestion}
menuText E OptionsShowVarPopup "Show Variation Window" 0 {Turn on/off the display of a variations window}  
menuText E OptionsMovesSpace "Add Spaces after Move Number" 0 {Add spaces after move number}  
menuText E OptionsMovesKey "Keyboard Completion" 0 \
  {Turn on/off keyboard move auto-completion}
menuText E OptionsMovesShowVarArrows "Show Variation Arrows" 0 {Turn on/off arrows showing moves in variations}
menuText E OptionsNumbers "Number Format" 0 {Select the number format}
menuText E OptionsStartup "Startup" 3 {Select windows to open at startup}
menuText E OptionsTheme "Theme" 0 {Ttk theme}
menuText E OptionsWindows "Windows" 0 {Window options}
menuText E OptionsWindowsIconify "Auto-Iconify" 5 \
  {Iconify all windows when the main window is iconified}
menuText E OptionsWindowsRaise "Auto-Raise" 5 \
  {Raise certain windows (e.g. progress bars) whenever they are obscured}
menuText E OptionsSounds "Sounds" 2 {Configure move announcement sounds}
menuText E OptionsWindowsDock "Dock windows" 0 {Dock windows (needs restart)}
menuText E OptionsWindowsSaveLayout "Save Layout" 0 {Save layout}
menuText E OptionsWindowsRestoreLayout "Restore Layout" 0 {Restore layout}
menuText E OptionsWindowsShowGameInfo "Show game info" 0 {Show game info}
menuText E OptionsWindowsAutoLoadLayout "Auto load first layout" 0 {Auto load first layout at startup}
menuText E OptionsWindowsAutoResize "Auto resize board" 0 {}
menuText E OptionsWindowsFullScreen "Fullscreen" 0 {Toggle fullscreen mode}
menuText E OptionsToolbar "Toolbar" 0 {Configure the main window toolbar}
menuText E OptionsECO "Load ECO File" 7 {Load the ECO classification file}
menuText E OptionsSpell "Load Spellcheck File" 11 \
  {Load the Scid spellcheck file}
menuText E OptionsTable "Tablebase Directory" 10 \
  {Select a tablebase file; all tablebases in its directory will be used}
menuText E OptionsRecent "Recent Entries" 0 {Change the number of entries shown in the File/Game-History menus}
menuText E OptionsBooksDir "Books Directory" 0 {Sets the opening books directory}
menuText E OptionsTacticsBasesDir "Bases Directory" 0 {Sets the tactics (training) bases directory}
menuText E OptionsSave "Save Options" 0 "Save all settable options to the file $::optionsFile"
menuText E OptionsAutoSave "Auto-Save Options on Exit" 0 \
  {Auto-save all options when exiting Scid}

# Help menu:
menuText E Help "Help" 0
menuText E HelpContents "Help" 0 {Show the help contents page}
menuText E HelpIndex "Index" 0 {Show the help index page}
menuText E HelpGuide "Quick Guide" 0 {Show the quick guide help page}
menuText E HelpHints "Hints" 1 {Show the hints help page}
menuText E HelpContact "Contact Info" 1 {Show the contact information help page}
menuText E HelpTip "Tip of the Day" 0 {Show a useful Scid tip}
menuText E HelpStartup "Startup Window" 0 {Show the startup window}
menuText E HelpAbout "About" 0 {Information about Scid Vs PC}

# Game info box popup menu:
menuText E GInfoHideNext "Hide Next Move" 0
menuText E GInfoShow "Side to Move" 0
menuText E GInfoCoords "Toggle Coords" 0
menuText E GInfoMaterial "Toggle Material" 7
menuText E GInfoFEN "FEN" 5
menuText E GInfoMarks "Show Colored Squares and Arrows" 5
menuText E GInfoWrap "Wrap Long Lines" 0
menuText E GInfoFullComment "Show Full Comment" 10
menuText E GInfoPhotos "Show Photos" 5
menuText E GInfoTBNothing "Tablebases: Nothing" 12
menuText E GInfoTBResult "Tablebases: Result Only" 12
menuText E GInfoTBAll "Tablebases: Result and Best Moves" 19
menuText E GInfoDelete "(Un)Delete This Game" 4
menuText E GInfoMark "(Un)Mark This Game" 4
menuText E GInfoInformant "Configure Informant Values" 0

translate E FlipBoard {Flip board}
translate E RaiseWindows {Raise windows}
translate E AutoPlay {Autoplay}
translate E TrialMode {Trial mode}

# General buttons:
translate E Apply {Apply}
translate E Back {Back}
translate E Browse {Browse}
translate E Cancel {Cancel}
translate E Continue {Continue}
translate E Clear {Clear}
translate E Close {Close}
translate E Contents {Contents}
translate E Defaults {Defaults}
translate E Delete {Delete}
translate E Graph {Graph}
translate E Help {Help}
translate E Import {Import}
translate E Index {Index}
translate E LoadGame {Load}
translate E BrowseGame {Browse}
translate E MergeGame {Merge}
translate E MergeGames {Merge Games}
# translate E Ok {Ok}
translate E Preview {Preview}
translate E Revert {Revert}
translate E Save {Save}
translate E DontSave {Don't Save}
translate E Search {Search}
translate E Stop {Stop}
translate E Store {Store}
translate E Update {Update}
translate E ChangeOrient {Change window orientation}
translate E ShowIcons {Show Icons}
translate E ConfirmCopy {Confirm Copy}
translate E None {None}
translate E First {First}
translate E Current {Current}
translate E Last {Last}
translate E Font {Font}
translate E Change {Change}
translate E Random {Random}

# General messages:
translate E game {game}
translate E games {games}
translate E move {move}
translate E moves {moves}
translate E all {all}
translate E Yes {Yes}
translate E No {No}
translate E Both {Both}
translate E King {King}
translate E Queen {Queen}
translate E Rook {Rook}
translate E Bishop {Bishop}
translate E Knight {Knight}
translate E Pawn {Pawn}
translate E White {White}
translate E Black {Black}
translate E Player {Player}
translate E Rating {Rating}
translate E RatingDiff {Rating difference}
translate E AverageRating {Average Rating}
translate E Event {Event}
translate E Site {Site}
translate E Country {Country}
translate E IgnoreColors {Ignore colors}
translate E MatchEnd {End pos only}
translate E Date {Date}
translate E EventDate {Event date}
translate E Decade {Decade}
translate E Year {Year}
translate E Month {Month}
translate E Months {January February March April May June July August September October November December}
translate E Days {Sun Mon Tue Wed Thu Fri Sat}
translate E YearToToday {Year to today}
translate E Result {Result}
translate E Round {Round}
translate E Length {Length}
translate E ECOCode {ECO code}
translate E ECO {ECO}
translate E Deleted {Deleted}
translate E SearchResults {Search Results}
translate E OpeningTheDatabase {Opening database}
translate E Database {Database}
translate E Filter {Filter}
translate E Reset {Reset}
translate E IgnoreCase {Ignore case}
translate E noGames {empty}
translate E allGames {all}
translate E empty {empty}
translate E clipbase {clipbase}
translate E score {score}
translate E Start {Start}
translate E StartPos {Start position}
translate E Total {Total}
translate E readonly {read-only}
translate E altered {altered}
translate E tagsDescript {Extra tags (eg: Annotator "Anand")}
translate E prevTags {Use previous}

# Standard error messages:
translate E ErrNotOpen {This is not an open database.}
translate E ErrReadOnly {This database is read-only and can't be altered.}
translate E ErrSearchInterrupted {Search interrupted}

# Game information:
translate E twin {twin}
translate E deleted {deleted}
translate E comment {comment}
translate E hidden {hidden}
translate E LastMove {Move}
translate E NextMove {Next}
translate E GameStart {Start of game}
translate E LineStart {Start of line}
translate E GameEnd {End of game}
translate E LineEnd {End of line}

# Player information:
translate E PInfoAll {All games}
translate E PInfoFilter {Filter games}
translate E PInfoAgainst {Against}
translate E PInfoMostWhite {Most common openings as White}
translate E PInfoMostBlack {Most common openings as Black}
translate E PInfoRating {Rating history}
translate E PInfoBio {Biography}
translate E PInfoEditRatings {Edit Ratings}
translate E PinfoEditName {Edit Name}
translate E PinfoLookupName {Lookup Name}

# Tablebase information:
translate E Draw {Draw}
translate E stalemate {stalemate}
translate E checkmate {checkmate}
translate E withAllMoves {with all moves}
translate E withAllButOneMove {with all but one move}
translate E with {with}
translate E only {only}
translate E lose {lose}
translate E loses {loses}
translate E allOthersLose {all others lose}
translate E matesIn {mates in}
translate E longest {longest}
translate E WinningMoves {Winning moves}
translate E DrawingMoves {Drawing moves}
translate E LosingMoves {Losing moves}
translate E UnknownMoves {Unknown-result moves}

# Tip of the day:
translate E Tip {Tip}
translate E TipAtStartup {Show tip on startup}

# Tree window menus:
menuText E TreeFile "Tree" 0
menuText E TreeFileFillWithBase "Fill Cache with base" 0 {Fill the cache file with all games in current base}
menuText E TreeFileFillWithGame "Fill Cache with game" 0 {Fill the cache file with current game in current base}
menuText E TreeFileSetCacheSize "Cache size" 0 {Set the cache size}
menuText E TreeFileCacheInfo "Cache info" 0 {Get info on cache usage}
menuText E TreeFileSave "Save Cache File" 0 {Save the tree cache (.stc) file}
menuText E TreeFileFill "Fill Cache File" 0 \
  {Fill the cache file with common opening positions}
menuText E TreeFileBest "Best Games" 0 {Show the best matching games}
menuText E TreeFileGraph "Graph Window" 0 {Show the graph for this tree branch}
menuText E TreeFileCopy "Copy Tree Text to Clipboard" 1 \
  {Copy the tree statisctics to the clipboard}
menuText E TreeFileClose "Close Tree Window" 0 {Close the tree window}
menuText E TreeMask "Mask" 0
menuText E TreeMaskNew "New" 0 {New mask}
menuText E TreeMaskOpen "Open" 0 {Open mask}
menuText E TreeMaskOpenRecent "Open recent" 0 {Open recent mask}
menuText E TreeMaskSave "Save" 0 {Save mask}
menuText E TreeMaskClose "Close" 0 {Close mask}
menuText E TreeMaskFillWithLine "Fill with line" 0 {Fill mask with all previous moves}
menuText E TreeMaskFillWithGame "Fill with game" 0 {Fill mask with game}
menuText E TreeMaskFillWithBase "Fill with base" 0 {Fill mask with all games in base}
menuText E TreeMaskInfo "Info" 0 {Show statistics for current mask}
menuText E TreeMaskDisplay "Display mask map" 0 {Show mask data in a tree form}
menuText E TreeMaskSearch "Search" 0 {Search in current mask}
menuText E TreeSort "Sort" 0
menuText E TreeSortAlpha "Alphabetical" 0
menuText E TreeSortECO "ECO Code" 0
menuText E TreeSortFreq "Frequency" 0
menuText E TreeSortScore "Score" 0
menuText E TreeOpt "Options" 0
menuText E TreeOptSlowmode "Slow mode" 0 {Slow mode for updates (high accuracy)}
menuText E TreeOptFastmode "Fast mode" 0 {Fast mode for updates (no move transposition)}
menuText E TreeOptFastAndSlowmode "Fast and slow mode" 0 {Fast mode then slow mode for updates}
menuText E TreeOptStartStop "Auto refreshing" 0 {Toggles automatic refreshing of the tree window}
menuText E TreeOptLock "Lock" 0 {Lock/unlock the tree to the current database}
menuText E TreeOptTraining "Training" 0 {Turn on/off tree training mode}
menuText E TreeOptShort "Short Display" 0 {Don't show ELO information}
menuText E TreeOptAutosave "Auto-Save Cache" 0 {Auto-save the cache file when closing the tree window}
menuText E TreeOptAutomask "Auto-Load Mask" 0 "Auto-Load most recent mask with a tree open."
menuText E TreeOptShowBar "Show Progress Bar" 0 "Show tree progress bar."
menuText E TreeOptSortBest "Sort Best Games" 0 "Sort Best Games by ELO."
menuText E TreeHelp "Help" 0
menuText E TreeHelpTree "Tree Help" 0
menuText E TreeHelpIndex "Help Index" 0
translate E SaveCache {Save Cache}
translate E Training {Training}
translate E LockTree {Lock}
translate E TreeLocked {locked}
translate E TreeBest {Best}
translate E TreeBestGames {Best Games}
translate E TreeAdjust {Adjust Filter}
# Note: the next message is the tree window title row. After editing it,
# check the tree window to make sure it lines up with the actual columns.
translate E TreeTitleRow      {    Move      Frequency    Score  Draw AvElo Perf AvYear ECO}
translate E TreeTitleRowShort {    Move      Frequency    Score  Draw}
translate E TreeTotal {TOTAL}
translate E DoYouWantToSaveFirst {Do you want to save}
translate E AddToMask {Add to Mask}
translate E RemoveFromMask {Remove from Mask}
translate E AddThisMoveToMask {Add Move to Mask}
translate E SearchMask {Search in Mask}
translate E DisplayMask {Display Mask}
translate E Nag {Nag code}
translate E Marker {Marker}
translate E Include {Include}
translate E Exclude {Exclude}
translate E MainLine {Main line}
translate E Bookmark {Bookmark}
translate E NewLine {New line}
translate E ToBeVerified {To be verified}
translate E ToTrain {To train}
translate E Dubious {Dubious}
translate E ToRemove {To remove}
translate E NoMarker {No marker}
translate E ColorMarker {Color}
translate E WhiteMark {White}
translate E GreenMark {Green}
translate E YellowMark {Yellow}
translate E BlueMark {Blue}
translate E RedMark {Red}
translate E CommentMove {Comment move}
translate E CommentPosition {Comment position}
translate E AddMoveToMaskFirst {Add move to mask first}
translate E OpenAMaskFileFirst {Open a mask file first}
translate E Positions {Positions}
translate E Moves {Moves}

# Finder window:
menuText E FinderFile "Finder" 0
menuText E FinderFileSubdirs "Look in Subdirectories" 0
menuText E FinderFileClose "Close" 0
menuText E FinderSort "Sort By" 0
menuText E FinderSortType "Type" 0
menuText E FinderSortSize "Games" 0
menuText E FinderSortMod "Modified" 0
menuText E FinderSortName "Name" 0
menuText E FinderSortPath "Path" 0
menuText E FinderTypes "Types" 0
menuText E FinderTypesScid "Scid Databases" 0
menuText E FinderTypesOld "Old-Format Scid Databases" 0
menuText E FinderTypesPGN "PGN Files" 0
menuText E FinderTypesEPD "EPD Files" 0
menuText E FinderHelp "Help" 0
menuText E FinderHelpFinder "Finder Help" 0
menuText E FinderHelpIndex "Index" 0
translate E FileFinder {File Finder}
translate E FinderDir {Directory}
translate E FinderDirs {Directories}
translate E FinderFiles {Files}
translate E FinderUpDir {up}
translate E FinderCtxOpen {Open}
translate E FinderCtxBackup {Backup}
translate E FinderCtxCopy {Copy}
translate E FinderCtxMove {Move}
translate E FinderCtxDelete {Delete}

# Player finder:
menuText E PListFile "Player Finder" 0
menuText E PListFileUpdate "Update" 0
menuText E PListFileClose "Close" 0
menuText E PListSort "Sort" 0
menuText E PListSortName "Name" 0
menuText E PListSortElo "Elo" 0
menuText E PListSortGames "Games" 0
menuText E PListSortOldest "Oldest" 0
menuText E PListSortNewest "Newest" 2

# Tournament finder:
menuText E TmtFile "Tournament Finder" 0
menuText E TmtFileUpdate "Update" 0
menuText E TmtFileClose "Close" 0
menuText E TmtSort "Sort" 0
menuText E TmtSortDate "Date" 0
menuText E TmtSortPlayers "Players" 0
menuText E TmtSortGames "Games" 0
menuText E TmtSortElo "Elo" 0
menuText E TmtSortSite "Site" 0
menuText E TmtSortEvent "Event" 1
menuText E TmtSortWinner "Winner" 0
translate E TmtLimit "List Size"
translate E TmtMeanElo "Mean Elo"
translate E TmtNone "No matching tournaments were found."

# Graph windows:
menuText E GraphFile "File" 0
menuText E GraphFileColor "Save as Color PostScript" 8
menuText E GraphFileGrey "Save as Greyscale PostScript" 8
menuText E GraphFileClose "Close" 0
menuText E GraphOptions "Options" 0
menuText E GraphOptionsWhite "White" 0
menuText E GraphOptionsBlack "Black" 0
menuText E GraphOptionsBoth "Both" 1
menuText E GraphOptionsPInfo "Player Info player" 0
translate E GraphFilterTitle "Frequency per 1000 Games"
translate E GraphAbsFilterTitle "Game Frequency"
translate E ConfigureFilter "Configure X Axis"
translate E FilterEstimate "Estimate"
translate E TitleFilterGraph "Scid: Filter Graph"

# Analysis window:
translate E AddVariation {Add Variation}
translate E AddAllVariations {Add All Variations}
translate E AddMove {Add Move}
translate E Annotate {Annotate}
translate E ShowAnalysisBoard {Show analysis board}
translate E ShowInfo {Show engine info}
translate E FinishGame {Finish game}
translate E StopEngine {Stop engine}
translate E StartEngine {Start engine}
translate E ExcludeMove {Exclude Move}
translate E LockEngine {Lock engine to current position}
translate E AnalysisCommand {Analysis Command}
translate E PreviousChoices {Previous Choices}
translate E AnnotateTime {Seconds per Move}
translate E AnnotateWhich {Which Side}
translate E AnnotateAll {Moves by both sides}
translate E AnnotateAllMoves {All moves}
translate E AnnotateWhite {White moves only}
translate E AnnotateBlack {Black moves only}
translate E AnnotateNotBest {When move is not the best}
translate E AnnotateBlundersOnly {When move is a blunder}
translate E BlundersNotBest {Blunders/Not Best}
translate E AnnotateBlundersOnlyScoreChange {Analysis reports blunder, with score change from/to: }
translate E AnnotateTitle {Configure Annotation}
translate E BlundersThreshold {Threshold}
translate E ScoreFormat {Score format}
translate E CutOff {Cut Off}
translate E LowPriority {Low CPU Priority}
translate E LogEngines {Log Size}
translate E LogName {Add Name}
translate E MaxPly {Max Ply}
translate E ClickHereToSeeMoves {Click here to see moves}
translate E ConfigureInformant {Configure Informant}
translate E Informant!? {Interesting move}
translate E Informant? {Poor move}
translate E Informant?? {Blunder}
translate E Informant?! {Dubious move}
translate E Informant+= {White has a slight advantage}
translate E Informant+/- {White has a moderate advantage}
translate E Informant+- {White has a decisive advantage}
translate E Informant++- {The game is considered won}

# Book window
translate E Book {Book}

# Analysis Engine open dialog:
translate E EngineList {Analysis Engines}
translate E EngineKey {Key}
translate E EngineType {Type}
translate E EngineName {Name}
translate E EngineCmd {Command}
translate E EngineArgs {Parameters}
translate E EngineDir {Directory}
translate E EngineElo {Elo}
translate E EngineTime {Date}
translate E EngineNew {New}
translate E EngineEdit {Edit}
translate E EngineRequired {Fields in bold are required; others are optional}

# Stats window menus:
menuText E StatsFile "Statistics" 0
menuText E StatsFilePrint "Print to File" 0
menuText E StatsFileClose "Close Window" 0
menuText E StatsOpt "Options" 0

# PGN window menus:
menuText E PgnFile "Pgn" 0
menuText E PgnFileCopy "Copy to Clipboard" 0
menuText E PgnFilePrint "Save Game as" 0
menuText E PgnFileClose "Close" 10
menuText E PgnOpt "Options" 0
menuText E PgnOptColor "Color Display" 0
menuText E PgnOptShort "Short Header" 6
menuText E PgnOptSymbols "Symbolic Annotations" 1
menuText E PgnOptIndentC "Indent Comments" 0
menuText E PgnOptIndentV "Indent Variations" 7
menuText E PgnOptColumn "Column Style" 1
menuText E PgnOptSpace "Space after Move Numbers" 18
menuText E PgnOptStripMarks "Hide Square/Arrow Codes" 1
menuText E PgnOptChess "Chess Pieces" 6
menuText E PgnOptScrollbar "Scrollbar" 6
menuText E PgnOptBoldMainLine "Bold Main Line" 4
menuText E PgnColor "Colors" 0
menuText E PgnColorHeader "Header" 0
menuText E PgnColorAnno "Annotations" 0
menuText E PgnColorComments "Comments" 0
menuText E PgnColorVars "Variations" 0
menuText E PgnColorBackground "Background" 0
menuText E PgnColorMain "Main line" 0
menuText E PgnColorCurrent "Current Move" 1
menuText E PgnColorNextMove "Next move" 0
menuText E PgnHelp "Help" 0
menuText E PgnHelpPgn "PGN Help" 0
menuText E PgnHelpIndex "Index" 0
translate E PgnWindowTitle {PGN: game %u}

# Crosstable window menus:
menuText E CrosstabFile "Crosstable" 0
menuText E CrosstabFileText "Save as Text" 8
menuText E CrosstabFileHtml "Save as Html" 8
menuText E CrosstabFileLaTeX "Save as Latex" 8
menuText E CrosstabFileClose "Close" 0
menuText E CrosstabEdit "Edit" 0
menuText E CrosstabEditEvent "Event" 0
menuText E CrosstabEditSite "Site" 0
menuText E CrosstabEditDate "Date" 0
menuText E CrosstabOpt "Options" 0
menuText E CrosstabOptColorPlain "Plain Text" 0
menuText E CrosstabOptColorHyper "Hypertext" 0
menuText E CrosstabOptTieWin "Tie-Break by wins" 1
menuText E CrosstabOptTieHead "Tie-Break by head-head" 1
menuText E CrosstabOptThreeWin "3 Points for Win" 1
menuText E CrosstabOptAges "Ages in Years" 8
menuText E CrosstabOptNats "Nationalities" 0
menuText E CrosstabOptTallies "Win/Loss/Draw" 0
menuText E CrosstabOptRatings "Ratings" 0
menuText E CrosstabOptTitles "Titles" 0
menuText E CrosstabOptBreaks "Tie-Break Scores" 4
menuText E CrosstabOptDeleted "Include Deleted Games" 8
menuText E CrosstabOptColors "Color Information (Swiss only)" 0
menuText E CrosstabOptColorRows "Color Rows" 0
menuText E CrosstabOptColumnNumbers "Numbered Columns (All-Play-All only)" 2
menuText E CrosstabOptGroup "Group Scores" 0
menuText E CrosstabSort "Sort by" 0
menuText E CrosstabSortName "Name" 0
menuText E CrosstabSortRating "Rating" 0
menuText E CrosstabSortScore "Score" 0
menuText E CrosstabSortCountry "Country" 0
menuText E CrosstabType "Format" 0
menuText E CrosstabTypeAll "All-Play-All" 0
menuText E CrosstabTypeSwiss "Swiss" 0
menuText E CrosstabTypeKnockout "Rounds" 0
menuText E CrosstabTypeAuto "Auto" 1
menuText E CrosstabHelp "Help" 0
menuText E CrosstabHelpCross "Crosstable Help" 0
menuText E CrosstabHelpIndex "Help Index" 0
translate E SetFilter {Set Filter}
translate E AddToFilter {Add to Filter}
translate E Swiss {Swiss}
translate E Category {Category}

# Opening report window menus:
menuText E OprepFile "Report" 0
menuText E OprepFileText "Print to Text" 9
menuText E OprepFileHtml "Print to HTML" 9
menuText E OprepFileLaTeX "Print to LaTeX" 9
menuText E OprepFileOptions "Options" 0
menuText E OprepFileClose "Close Report Window" 0
menuText E OprepFavorites "Favorites" 1
menuText E OprepFavoritesAdd "Add Report" 0
menuText E OprepFavoritesEdit "Edit Report Favorites" 0
menuText E OprepFavoritesGenerate "Generate Reports" 0
menuText E OprepHelp "Help" 0
menuText E OprepHelpReport "Opening Report Help" 0
menuText E OprepHelpIndex "Help Index" 0

# Header search:
translate E HeaderSearch {General Search}
translate E EndSideToMove {Side to move at end of game}
translate E GamesWithNoECO {Games with no ECO?}
translate E GameLength {Game length}
translate E FindGamesWith {Find games with flags}
translate E StdStart {Non-standard start}
translate E Promotions {Promotions}
translate E UnderPromo {Under Prom.}
translate E Comments {Comments}
translate E Variations {Variations}
translate E Annotations {Annotations}
translate E DeleteFlag {Delete flag}
translate E WhiteOpFlag {White opening}
translate E BlackOpFlag {Black opening}
translate E MiddlegameFlag {Middlegame}
translate E EndgameFlag {Endgame}
translate E NoveltyFlag {Novelty}
translate E PawnFlag {Pawn structure}
translate E TacticsFlag {Tactics}
translate E QsideFlag {Queenside play}
translate E KsideFlag {Kingside play}
translate E BrilliancyFlag {Brilliancy}
translate E BlunderFlag {Blunder}
translate E UserFlag {User}
translate E PgnContains {PGN contains text}

# Game list window:
translate E GlistNumber {Number}
translate E GlistWhite {White}
translate E GlistBlack {Black}
translate E GlistWElo {W-Elo}
translate E GlistBElo {B-Elo}
translate E GlistEvent {Event}
translate E GlistSite {Site}
translate E GlistRound {Round}
translate E GlistDate {Date}
translate E GlistYear {Year}
translate E GlistEventDate {Event Date}
translate E GlistResult {Result}
translate E GlistLength {Length}
translate E GlistCountry {Country}
translate E GlistECO {ECO}
translate E GlistOpening {Opening}
translate E GlistEndMaterial {End Material}
translate E GlistDeleted {Deleted}
translate E GlistFlags {Flags}
translate E GlistVariations {Variations}
translate E GlistComments {Comments}
translate E GlistAnnos {Annotations}
translate E GlistStart {Start}
translate E GlistGameNumber {Game number}
translate E GlistFindText {Find}
translate E GlistMoveField {Move}
translate E GlistEditField {Configure}
translate E GlistAddField {Add}
translate E GlistDeleteField {Delete}
translate E GlistColor {Color}
translate E GlistSort {Sort database}

# menu shown with right mouse button down on game list. 
translate E GlistRemoveThisGameFromFilter  {Remove}
translate E GlistRemoveGameAndAboveFromFilter  {Remove all above}
translate E GlistRemoveGameAndBelowFromFilter  {Remove all below}
translate E GlistDeleteGame {Delete this game} 
translate E GlistDeleteAllGames {Delete all games in filter} 
translate E GlistUndeleteAllGames {Undelete all games in filter} 

translate E GlistAlignL {Align left}
translate E GlistAlignR {Align right}
translate E GlistAlignC {Align center}

# Maintenance window:
translate E DatabaseName {Database Name:}
translate E TypeIcon {Database Type}
translate E NumOfGames {Games:}
translate E NumDeletedGames {Deleted games:}
translate E NumFilterGames {Games in filter:}
translate E YearRange {Year range:}
translate E RatingRange {Rating range:}
translate E Description {Description}
translate E Flag {Flag}
translate E CustomFlags {Custom flags}
translate E DeleteCurrent {Delete current game}
translate E DeleteFilter {Delete filter games}
translate E DeleteAll {Delete all games}
translate E UndeleteCurrent {Undelete current game}
translate E UndeleteFilter {Undelete filter games}
translate E UndeleteAll {Undelete all games}
translate E DeleteTwins {Delete twin games}
translate E MarkCurrent {Mark current game}
translate E MarkFilter {Mark filter games}
translate E MarkAll {Mark all games}
translate E UnmarkCurrent {Unmark current game}
translate E UnmarkFilter {Unmark filter games}
translate E UnmarkAll {Unmark all games}
translate E Spellchecking {Spell-checking}
translate E MakeCorrections {Make Corrections}
translate E Ambiguous {Ambiguous}
translate E Surnames {Surnames}
translate E Players {Players}
translate E Events {Events}
translate E Sites {Sites}
translate E Rounds {Rounds}
translate E DatabaseOps {Database operations}
translate E ReclassifyGames {ECO classify games}
translate E CompactDatabase {Compact database}
translate E SortDatabase {Sort database}
translate E AddEloRatings {Add Elo ratings}
translate E AutoloadGame {Autoload game}
translate E StripTags {Strip extra tags}
translate E StripTag {Strip tag}
translate E CheckGames {Check games}
translate E Cleaner {Cleaner}
translate E CleanerHelp {
The Cleaner will perform all actions selected below on the current database.

Current settings in ECO Classification and Twin Deletion will apply if selected.
}
translate E CleanerConfirm {
Once Cleaner maintenance is started it cannot be interrupted.

This may take a long time.

Are you sure you want to run the selected maintenance functions ?
}
# Twinchecker
translate E TwinCheckUndelete {to toggle)}
translate E TwinCheckprevPair {Previous pair}
translate E TwinChecknextPair {Next pair}
translate E TwinChecker {Twin Game Checker}
translate E TwinCheckTournament {Games in tournament:}
translate E TwinCheckNoTwin {No twin  }
translate E TwinCheckNoTwinfound {No twin was detected for this game.\nTo show twins using this window, you must first use the "Delete twin games" function. }
translate E TwinCheckTag {Share tags...}
translate E TwinCheckFound1 {Scid found $result twin games}
translate E TwinCheckFound2 { and set their delete flags}
translate E TwinCheckNoDelete {There are no games in this database to delete.}
# bug here... can't use \n\n
translate E TwinCriteria1 {Weak Criteria warning\n}
translate E TwinCriteria2 {You have selected "No" for "Same Moves", which is very bad.\n
Continue anyway?}
translate E TwinCriteria3 {You should specify "Yes" for at least two of the "Same Site", "Same Round" and "Same Year" settings.\n
Continue anyway?}
translate E TwinCriteriaConfirm {Scid: Confirm twin settings}
translate E TwinChangeTag "Change the following game tags:\n\n"
translate E AllocRatingDescription "Add Player Elo Ratings to relevant games, using info from the Spelling (Ratings) file."
translate E RatingOverride "Overwrite existing ratings?"
translate E AddRatings "Add ratings to"
translate E AddedRatings {Scid added $r Elo ratings in $g games.}

#Bookmark editor
translate E NewSubmenu "Add Menu"

# Comment editor:
translate E AnnotationSymbols  {Annotations}
translate E Comment {Comments}
translate E InsertMark {Marks}
translate E InsertMarkHelp {
Insert/remove mark: Select color, type, square.
Insert/remove arrow: Right-click two squares.
}

# Nag buttons in comment editor:
translate E GoodMove {Good move}
translate E PoorMove {Poor move}
translate E ExcellentMove {Excellent move}
translate E Blunder {Blunder}
translate E InterestingMove {Interesting move}
translate E DubiousMove {Dubious move}
translate E WhiteDecisiveAdvantage {White has a decisive advantage}
translate E BlackDecisiveAdvantage {Black has a decisive advantage}
translate E WhiteClearAdvantage {White has a clear advantage}
translate E BlackClearAdvantage {Black has a clear advantage}
translate E WhiteSlightAdvantage {White has a slight advantage}
translate E BlackSlightAdvantage {Black has a slight advantage}
translate E Equality {Equality}
translate E Unclear {Unclear}
translate E Diagram {Diagram}

# Board search:
translate E BoardSearch {Board Search}
translate E FilterOperation {Filter Setting}
translate E FilterAnd {Restrict filter (AND)}
translate E FilterOr {Add to filter (OR)}
translate E FilterIgnore {Reset filter}
translate E SearchType {Search Type}
translate E SearchBoardExact {Exact position (all pieces on same squares)}
translate E SearchBoardPawns {Pawns (same material, all pawns on same squares)}
translate E SearchBoardFiles {Files (same material, all pawns on same files)}
translate E SearchBoardAny {Any (same material, pawns and pieces anywhere)}
translate E SearchInRefDatabase { Search in database }
translate E LookInVars {Look in variations}

# Material search:
translate E MaterialSearch {Material Search}
translate E Material {Material}
translate E Patterns {Patterns}
translate E Zero {Zero}
translate E Any {Any}
translate E CurrentBoard {Current Board}
translate E CommonEndings {Common Endings}
translate E CommonPatterns {Common Patterns}
translate E MaterialDiff {Material difference}
translate E squares {squares}
translate E SameColor {Same color}
translate E OppColor {Opposite color}
translate E Either {Either}
translate E MoveNumberRange {Move number range}
translate E MatchForAtLeast {Match for at least}
translate E HalfMoves {Half moves}

# Common endings in material search:
translate E EndingPawns {Pawn endings}
translate E EndingRookVsPawns {Rook vs. Pawn(s)}
translate E EndingRookPawnVsRook {Rook and 1 Pawn vs. Rook}
translate E EndingRookPawnsVsRook {Rook and Pawn(s) vs. Rook}
translate E EndingRooks {Rook vs. Rook endings}
translate E EndingRooksPassedA {Rook vs. Rook endings with a passed a-pawn}
translate E EndingRooksDouble {Double Rook endings}
translate E EndingBishops {Bishop vs. Bishop endings}
translate E EndingBishopVsKnight {Bishop vs. Knight endings}
translate E EndingKnights {Knight vs. Knight endings}
translate E EndingQueens {Queen vs. Queen endings}
translate E EndingQueenPawnVsQueen {Queen and 1 Pawn vs. Queen}
translate E BishopPairVsKnightPair {Two Bishops vs. Two Knights middlegame}

# Common patterns in material search:
translate E PatternWhiteIQP {White IQP}
translate E PatternWhiteIQPBreakE6 {White IQP: d4-d5 break vs. e6}
translate E PatternWhiteIQPBreakC6 {White IQP: d4-d5 break vs. c6}
translate E PatternBlackIQP {Black IQP}
translate E PatternWhiteBlackIQP {White IQP vs. Black IQP}
translate E PatternCoupleC3D4 {White c3+d4 Isolated Pawn Couple}
translate E PatternHangingC5D5 {Black Hanging Pawns on c5 and d5}
translate E PatternMaroczy {Maroczy Center (with Pawns on c4 and e4)}
translate E PatternRookSacC3 {Rook Sacrifice on c3}
translate E PatternKc1Kg8 {O-O-O vs. O-O (Kc1 vs. Kg8)}
translate E PatternKg1Kc8 {O-O vs. O-O-O (Kg1 vs. Kc8)}
translate E PatternLightFian {Light-Square Fianchettos (Bishop-g2 vs. Bishop-b7)}
translate E PatternDarkFian {Dark-Square Fianchettos (Bishop-b2 vs. Bishop-g7)}
translate E PatternFourFian {Four Fianchettos (Bishops on b2,g2,b7,g7)}

# Game saving:
translate E Today {Today}
translate E ClassifyGame {Classify game}

# Setup position:
translate E EmptyBoard {Clear board}
translate E InitialBoard {Initial board}
translate E SideToMove {Side to move}
translate E MoveNumber {Move number}
translate E Castling {Castling}
translate E EnPassantFile {En Passant file}
translate E ClearFen {Clear FEN}
translate E PasteFen {Paste FEN}

translate E SaveAndContinue {Save and continue}
translate E DiscardChangesAndContinue {Discard Changes}
translate E GoBack {Go back}

# Replace move dialog:
translate E ReplaceMove {Replace Move}
translate E AddNewVar {Add Variation}
translate E NewMainLine {New Main Line}
translate E ReplaceMoveMessage {Move Already Exists.

Please Enter Choice.
Replace Move will discard all subsequent moves.}

# Make database read-only dialog:
translate E ReadOnlyDialog {Do you want to make this database read-only?

(You can make the database writable again by closing and reopening it.)}

translate E ExitDialog {Do you really want to exit Scid?}
translate E ClearGameDialog {This game has been altered.\nDo you wish to save it?}
translate E ExitUnsaved {The following databases have unsaved games. If you exit now, these changes will be lost.}

# Import window:
translate E PasteCurrentGame {Paste Current Game}
translate E ImportHelp1 {Enter or Paste PGN in the above frame.}
translate E ImportHelp2 {Any errors importing the game will be displayed here.}
translate E OverwriteExistingMoves {Overwrite existing moves ?}

# ECO Browser:
translate E ECOAllSections {All ECO sections}
translate E ECOSection {ECO section}
translate E ECOSummary {Summary for}
translate E ECOFrequency {Frequency of subcodes for}

# Opening Report:
translate E OprepTitle {Opening Report}
translate E OprepReport {Report}
translate E OprepGenerated {Generated by}
translate E OprepStatsHist {Statistics and History}
translate E OprepStats {Statistics}
translate E OprepStatAll {All report games}
translate E OprepStatBoth {Both rated}
translate E OprepStatSince {Since}
translate E OprepOldest {Oldest games}
translate E OprepNewest {Newest games}
translate E OprepPopular {Current popularity}
translate E OprepFreqAll {Frequency in all years:   }
translate E OprepFreq1   {In the  1 year  to today: }
translate E OprepFreq5   {In the  5 years to today: }
translate E OprepFreq10  {In the 10 years to today: }
translate E OprepEvery {once every %u games}
translate E OprepUp {up %u%s from all years}
translate E OprepDown {down %u%s from all years}
translate E OprepSame {no change from all years}
translate E OprepMostFrequent {Most frequent players}
translate E OprepMostFrequentOpponents {Most frequent opponents}
translate E OprepRatingsPerf {Ratings and Performance}
translate E OprepAvgPerf {Average ratings and performance}
translate E OprepWRating {White rating}
translate E OprepBRating {Black rating}
translate E OprepWPerf {White performance}
translate E OprepBPerf {Black performance}
translate E OprepHighRating {Games with highest average rating}
translate E OprepTrends {Result Trends}
translate E OprepResults {Result lengths and frequencies}
translate E OprepLength {Game length}
translate E OprepFrequency {Frequency}
translate E OprepWWins {White wins: }
translate E OprepBWins {Black wins: }
translate E OprepDraws {Draws:      }
translate E OprepWholeDB {whole database}
translate E OprepShortest {Shortest wins}
translate E OprepMovesThemes {Moves and Themes}
translate E OprepMoveOrders {Move orders reaching the report position}
translate E OprepMoveOrdersOne \
  {There was only one move order reaching this position:}
translate E OprepMoveOrdersAll \
  {There were %u move orders reaching this position:}
translate E OprepMoveOrdersMany \
  {There were %u move orders reaching this position. The top %u are:}
translate E OprepMovesFrom {Moves from the report position}
translate E OprepMostFrequentEcoCodes {Most frequent ECO codes}
translate E OprepThemes {Positional Themes}
translate E OprepThemeDescription {Frequency of themes in the first %u moves of each game}
translate E OprepThemeSameCastling {Same-side castling}
translate E OprepThemeOppCastling {Opposite castling}
translate E OprepThemeNoCastling {Both Kings uncastled}
translate E OprepThemeKPawnStorm {Kingside pawn storm}
translate E OprepThemeQueenswap {Queens exchanged}
translate E OprepThemeWIQP {White Isolated Queen Pawn}
translate E OprepThemeBIQP {Black Isolated Queen Pawn}
translate E OprepThemeWP567 {White Pawn on 5/6/7th rank}
translate E OprepThemeBP234 {Black Pawn on 2/3/4th rank}
translate E OprepThemeOpenCDE {Open c/d/e file}
translate E OprepTheme1BishopPair {Only one side has Bishop pair}
translate E OprepEndgames {Endgames}
translate E OprepReportGames {Report games}
translate E OprepAllGames    {All games}
translate E OprepEndClass {Material at the end of each game}
translate E OprepTheoryTable {Theory Table}
translate E OprepTableComment {Generated from the %u highest-rated games.}
translate E OprepExtraMoves {Extra note moves in theory table}
translate E OprepMaxGames {Maximum games in theory table}
translate E OprepViewHTML {View HTML}
translate E OprepViewLaTeX {View LaTeX}

# Player Report:
translate E PReportTitle {Player Report}
translate E PReportColorWhite {with the White pieces}
translate E PReportColorBlack {with the Black pieces}
translate E PReportBeginning {Beginning with}
translate E PReportMoves {after %s}
translate E PReportOpenings {Openings}
translate E PReportClipbase {Empty clipbase and copy matching games to it}

# Piece Tracker window:
translate E TrackerSelectSingle {Left mouse button selects this piece.}
translate E TrackerSelectPair {Left mouse button selects this piece; right button also selects its sibling.}
translate E TrackerSelectPawn {Left mouse button selects this pawn; right button selects all 8 pawns.}
translate E TrackerStat {Statistic}
translate E TrackerGames {% games with move to square}
translate E TrackerTime {% time on each square}
translate E TrackerMoves {Moves}
translate E TrackerMovesStart {Enter the move number where tracking should begin.}
translate E TrackerMovesStop {Enter the move number where tracking should stop.}

# Game selection dialogs:
translate E SelectAllGames {All games}
translate E SelectFilterGames {Filter games}
translate E SelectTournamentGames {Only games in the current tournament}
translate E SelectOlderGames {Only older games}

# Delete Twins window:
translate E TwinsNote {To be marked as twins, games must have the same Players and other criteria, as per below. It is best to spellcheck the database before detecting twins. }
translate E TwinsCriteria {Twin Game Criteria}
translate E TwinsWhich {Examine All/Filter}
translate E TwinsColors {Same player colors}
translate E TwinsEvent {Same event}
translate E TwinsSite {Same site}
translate E TwinsRound {Same round}
translate E TwinsYear {Same year}
translate E TwinsMonth {Same month}
translate E TwinsDay {Same day}
translate E TwinsResult {Same result}
translate E TwinsECO {Same ECO code}
translate E TwinsMoves {Same moves}
translate E TwinsPlayers {Player names}
translate E TwinsPlayersExact {Exact match}
translate E TwinsPlayersPrefix {First four letters only}
translate E TwinsWhen {When deleting Twin Games}
translate E TwinsSkipShort {Ignore games under 5 moves long}
translate E TwinsUndelete {Undelete all games first}
translate E TwinsSetFilter {Set filter to twins to be deleted}
translate E TwinsComments {Always keep games with comments}
translate E TwinsVars {Always keep games with variations}
translate E TwinsDeleteWhich {Delete which game ?}
translate E TwinsDeleteShorter {Shorter game}
translate E TwinsDeleteOlder {Lesser game number}
translate E TwinsDeleteNewer {Greater game number}
translate E TwinsDelete {Delete games}

# Name editor window:
translate E NameEditType {Name Type to Edit}
translate E NameEditSelect {Games to Edit}
translate E NameEditReplace {Replace}
translate E NameEditWith {With}
translate E NameEditMatches {Matches: Press Ctrl+1 to Ctrl+9 to select}

# Check games window:
translate E CheckGamesWhich {Check Games}
translate E CheckAll {All games}
translate E CheckSelectFilterGames {Filter games}

# Classify window:
translate E Classify {Classify}
translate E ClassifyWhich {ECO Classify}
translate E ClassifyAll {All games (overwrite old ECO codes)}
translate E ClassifyYear {All games played in the last year}
translate E ClassifyMonth {All games played in the last month}
translate E ClassifyNew {Only games with no ECO code yet}
translate E ClassifyCodes {ECO Codes to use}
translate E ClassifyBasic {Basic codes only ("B12", ...)}
translate E ClassifyExtended {Scid extensions ("B12j", ...)}

# Compaction:
translate E NameFile {Name file}
translate E GameFile {Game file}
translate E Names {Names}
translate E Unused {Unused}
translate E SizeKb {Size (kb)}
translate E CurrentState {Current state}
translate E AfterCompaction {After compaction}
translate E CompactNames {Compact Name file}
translate E CompactGames {Compact Game file}
translate E NoUnusedNames "There are no unused names, so the name file is already fully compacted."
translate E NoUnusedGames "The game file is already fully compacted."
translate E NameFileCompacted {The name file for "[file tail [sc_base filename]]" was compacted.}
translate E GameFileCompacted {The game file for "[file tail [sc_base filename]]" was compacted.}

# Sorting:
translate E SortCriteria {Criteria}
translate E AddCriteria {Add criteria}
translate E CommonSorts {Common sorts}
translate E Sort {Sort}

# Exporting:
translate E AddToExistingFile {Add games to an existing file?}
translate E ExportComments {Export comments?}
translate E ExportVariations {Export variations?}
translate E IndentComments {Indent comments?}
translate E IndentVariations {Indent variations?}
translate E ExportColumnStyle {Column style (one move per line)?}
translate E ExportSymbolStyle {Symbolic annotation style:}
translate E ExportStripMarks {Strip square/arrow mark codes from comments?}

# Goto game/move dialogs:
translate E LoadGameNumber {Load Game number}
translate E GotoMoveNumber {Goto Move number}

# Copy games dialog:
translate E CopyGames {Copying games}
translate E CopyConfirm {
Copy [::utils::thousands $nGamesToCopy] game(s)
from "$fromName" to "$targetName"?
}
translate E CopyErr {Cannot copy games}
translate E CopyErrSource {The source database}
translate E CopyErrTarget {The target database}
translate E CopyErrNoGames {has no games in its filter}
translate E CopyErrReadOnly {is read-only}
translate E CopyErrNotOpen {is not open}

# Colors:
translate E LightSquares {Light squares}
translate E DarkSquares {Dark squares}
translate E SelectedSquares {Selected}
translate E SuggestedSquares {Suggested}
translate E Grid {Grid}
translate E Previous {Previous}
translate E WhitePieces {White pieces}
translate E BlackPieces {Black pieces}
translate E WhiteBorder {White border}
translate E BlackBorder {Black border}
translate E ArrowMain   {Main Arrow}
translate E ArrowVar    {Var Arrows}

# Novelty window:
translate E FindNovelty {Find Novelty}
translate E Novelty {Novelty}
translate E NoveltyInterrupt {Novelty search interrupted}
translate E NoveltyNone {No novelty was found for this game}
translate E NoveltyHelp {Find the first unique move in the selected base}

# Sounds configuration:
translate E SoundsFolder {Sounds Folder}
translate E SoundsFolderHelp {The folder should contain the files King.wav, 1.wav, etc}
translate E SoundsAnnounceOptions {Move Announcement}
translate E SoundsAnnounceNew {Announce new moves}
translate E SoundsAnnounceForward {Announce when moving forward}
translate E SoundsAnnounceBack {Announce when moving back}

# Upgrading databases:
translate E Upgrading {Upgrading}
translate E ConfirmOpenNew {
This is an old-format (si3) database that cannot be opened in Scid 4.0, but a new-format (si4) version has already been created.

Do you want to open the new-format version of the database?
}
translate E ConfirmUpgrade {
This is an "si3" format database. It must be converted to "si4" before it can be used in Scid vs. PC 4.0.

This process is irreversible and only needs to be done once. You can cancel if it takes too long.

Do you want to upgrade this database now?
}

# Recent files options:
translate E RecentFilesMenu {Number of files in File menu}
translate E RecentFilesExtra {Number of files in Submenu}

translate E MyPlayerNamesDescription {
Enter preferred player names below, one name per line.
Every time a game with a player in the list is loaded, the main chessboard will be flipped if necessary.
}

#Coach
translate E showblunderexists {show phalanx blunder}
translate E showblundervalue {show blunder value}
translate E showscore {show score}
translate E coachgame {coach game}
translate E configurecoachgame {Configure Tactical game}
translate E configuregame {Configure UCi game}
translate E Phalanxengine {Phalanx engine}
translate E Coachengine {Coach engine}
translate E difficulty {difficulty}
translate E hard {hard}
translate E easy {easy}
translate E Playwith {Play with}
translate E white {white}
translate E black {black}
translate E both {both}
translate E Play {Play}
translate E Noblunder {No blunder}
translate E blunder {blunder}
translate E Noinfo {-- No info --}
translate E moveblunderthreshold {move is a blunder if loss is greater than}
translate E limitanalysis {Coach's analysis time}
translate E seconds {seconds}
translate E Abort {Abort}
translate E Resume {Resume}
translate E Restart {Restart}
translate E OutOfOpening {Out of opening}
translate E NotFollowedLine {You did not follow the line}
translate E DoYouWantContinue {Do you want yo continue ?}
translate E CoachIsWatching {Coach is watching}
translate E Ponder {Permanent thinking}
translate E LimitELO {Limit ELO strength}
translate E DubiousMovePlayedTakeBack {Dubious move played, do you want to take back ?}
translate E WeakMovePlayedTakeBack {Weak move played, do you want to take back ?}
translate E BadMovePlayedTakeBack {Bad move played, do you want to take back ?}
translate E Iresign {I resign}
translate E yourmoveisnotgood {your move is not good}
translate E EndOfVar {End of variation}
translate E Openingtrainer {Opening trainer}
translate E DisplayCM {Display candidate moves}
translate E DisplayCMValue {Display candidate moves value}
translate E DisplayOpeningStats {Show statistics}
translate E ShowReport {Show report}
translate E NumberOfGoodMovesPlayed {good moves played}
translate E NumberOfDubiousMovesPlayed {dubious moves played}
translate E NumberOfTimesPositionEncountered {times position encountered}
translate E PlayerBestMove  {Allow only best moves}
translate E OpponentBestMove {Opponent plays best moves}
translate E OnlyFlaggedLines {Only flagged lines}
translate E resetStats {Reset statistics}
translate E Movesloaded {Moves loaded}
translate E PositionsNotPlayed {Positions not played}
translate E PositionsPlayed {Positions played}
translate E Success {Success}
translate E DubiousMoves {Dubious moves}
translate E ConfigureTactics {Select Puzzle}
translate E ResetScores {Reset scores}
translate E LoadingBase {Loading base}
translate E Tactics {Tactics}
translate E ShowSolution {Show solution}
translate E Next {Next}
translate E ResettingScore {Resetting score}
translate E LoadingGame {Loading game}
translate E MateFound {Mate found}
translate E BestSolutionNotFound {Best solution NOT found !}
translate E MateNotFound {Mate not found}
translate E ShorterMateExists {Shorter mate exists}
translate E ScorePlayed {Score played}
translate E Expected {expected}
translate E ChooseTrainingBase {Choose Training Base}
translate E Thinking {Thinking}
translate E AnalyzeDone {Analyze done}
translate E WinWonGame {Win won game}
translate E Lines {Lines}
translate E ConfigureUCIengine {Configure Engine}
translate E SpecificOpening {Specific opening}
translate E StartNewGame {Start new game}
translate E FixedLevel {Fixed level}
translate E Opening {Opening}
translate E RandomLevel {Random level}
translate E StartFromCurrentPosition {Start from current position}
translate E FixedDepth {Fixed depth}
translate E Nodes {Nodes}
translate E Depth {Depth}
translate E Time {Time} 
translate E SecondsPerMove {Seconds per move}
translate E DepthPerMove {Depth per move}
translate E MoveControl {Move Control}
translate E TimeLabel {Time per move}
translate E AddVars {Add Variations}
translate E AddScores {Add Score}
translate E Engine {Engine}
translate E TimeMode {Time mode}
translate E TimeBonus {Time + bonus}
translate E TimeMin {min}
translate E TimeSec {sec}
translate E AllExercisesDone {All exercises done}
translate E MoveOutOfBook {Move out of book}
translate E LastBookMove {Last book move}
translate E AnnotateSeveralGames {Batch annotation\nFrom current to :}
translate E FindOpeningErrors {Opening errors only}
translate E MarkTacticalExercises {Mark tactical exercises}
translate E UseBook {Use book}
translate E MultiPV {Multiple variations}
translate E Hash {Hash memory}
translate E OwnBook {Use engine book}
translate E BookFile {Opening book}
translate E AnnotateVariations {Process variations}
translate E ShortAnnotations {Short annotations}
translate E addAnnotatorTag {Add annotator tag}
translate E AddScoreToShortAnnotations {Add score to annotations}
translate E Export {Export}
translate E BookPartiallyLoaded {Book partially loaded}
translate E AddLine {Add Line}
translate E RemLine {Remove Line}
translate E Calvar {Calculation of variations}
translate E ConfigureCalvar {Configuration}
# Opening names used in tacgame.tcl
translate E Reti {Reti}
translate E English {English}
translate E d4Nf6Miscellaneous {1.d4 Nf6 Miscellaneous}
translate E Trompowsky {Trompowsky}
translate E Budapest {Budapest}
translate E OldIndian {Old Indian}
translate E BenkoGambit {Benko Gambit}
translate E ModernBenoni {Modern Benoni}
translate E DutchDefence {Dutch Defence}
translate E Scandinavian {Scandinavian}
translate E AlekhineDefence {Alekhine Defence}
translate E Pirc {Pirc}
translate E CaroKann {Caro-Kann}
translate E CaroKannAdvance {Caro-Kann Advance}
translate E Sicilian {Sicilian}
translate E SicilianAlapin {Sicilian Alapin}
translate E SicilianClosed {Sicilian Closed}
translate E SicilianRauzer {Sicilian Rauzer}
translate E SicilianDragon {Sicilian Dragon}
translate E SicilianScheveningen {Sicilian Scheveningen}
translate E SicilianNajdorf {Sicilian Najdorf}
translate E OpenGame {Open Game}
translate E Vienna {Vienna}
translate E KingsGambit {King's Gambit}
translate E RussianGame {Russian Game}
translate E ItalianTwoKnights {Italian/Two Knights}
translate E Spanish {Spanish}
translate E SpanishExchange {Spanish Exchange}
translate E SpanishOpen {Spanish Open}
translate E SpanishClosed {Spanish Closed}
translate E FrenchDefence {French Defence}
translate E FrenchAdvance {French Advance}
translate E FrenchTarrasch {French Tarrasch}
translate E FrenchWinawer {French Winawer}
translate E FrenchExchange {French Exchange}
translate E QueensPawn {Queen's Pawn}
translate E Slav {Slav}
translate E QGA {QGA}
translate E QGD {QGD}
translate E QGDExchange {QGD Exchange}
translate E SemiSlav {Semi-Slav}
translate E QGDwithBg5 {QGD with Bg5}
translate E QGDOrthodox {QGD Orthodox}
translate E Grunfeld {Grünfeld}
translate E GrunfeldExchange {Grünfeld Exchange}
translate E GrunfeldRussian {Grünfeld Russian}
translate E Catalan {Catalan}
translate E CatalanOpen {Catalan Open}
translate E CatalanClosed {Catalan Closed}
translate E QueensIndian {Queen's Indian}
translate E NimzoIndian {Nimzo-Indian}
translate E NimzoIndianClassical {Nimzo-Indian Classical}
translate E NimzoIndianRubinstein {Nimzo-Indian Rubinstein}
translate E KingsIndian {King's Indian}
translate E KingsIndianSamisch {King's Indian Sämisch}
translate E KingsIndianMainLine {King's Indian Main Line}

# FICS
translate E ConfigureFics {Configure FICS}
translate E FICSLogin {Login}
translate E FICSGuest {Login as Guest}
translate E FICSServerPort {Server port}
translate E FICSServerAddress {IP Address}
translate E FICSRefresh {Refresh}
translate E FICSTimeseal {Timeseal}
translate E FICSTimesealPort {Timeseal port}
translate E FICSSilence {Console filter}
translate E FICSOffers {Offers}
translate E FICSGames {Games}
translate E FICSFindOpponent {Find Opponent}
translate E FICSTakeback {Takeback}
translate E FICSTakeback2 {Takeback 2}
translate E FICSInitTime {Time (min)}
translate E FICSIncrement {Increment (sec)}
translate E FICSRatedGame {Rated Game}
translate E FICSAutoColour {Automatic}
translate E FICSManualConfirm {Confirm manually}
translate E FICSFilterFormula {Filter with formula}
translate E FICSIssueSeek {Issue seek}
translate E FICSAccept {Accept}
translate E FICSDecline {Decline}
translate E FICSColour {Color}
translate E FICSSend {Send}
translate E FICSConnect {Connect}
translate E FICSShouts {Shouts}
translate E FICSTells {Tells}
translate E FICSOpponent {Opponent Info}
translate E FICSInfo {Info}
translate E FICSDraw {Offer Draw}
translate E FICSRematch {Rematch}
translate E FICSQuit {Quit FICS}
translate E FICSCensor {Censor}


# Correspondence Chess Dialogs:
translate E CCDlgConfigureWindowTitle {Configure Correspondence Chess}
translate E CCDlgCGeneraloptions {General Options}
translate E CCDlgDefaultDB {Default Database:}
translate E CCDlgInbox {Inbox (path):}
translate E CCDlgOutbox {Outbox (path):}
translate E CCDlgXfcc {Xfcc Configuration:}
translate E CCDlgExternalProtocol {External Protocol Handler (e.g. Xfcc)}
translate E CCDlgFetchTool {Fetch Tool:}
translate E CCDlgSendTool {Send Tool:}
translate E CCDlgEmailCommunication {eMail Communication}
translate E CCDlgMailPrg {Mail program:}
translate E CCDlgBCCAddr {(B)CC Address:}
translate E CCDlgMailerMode {Mode:}
translate E CCDlgThunderbirdEg {e.g. Thunderbird, Mozilla Mail, Icedove...}
translate E CCDlgMailUrlEg {e.g. Evolution}
translate E CCDlgClawsEg {e.g Sylpheed Claws}
translate E CCDlgmailxEg {e.g. mailx, mutt, nail...}
translate E CCDlgAttachementPar {Attachment parameter:}
translate E CCDlgInternalXfcc {Use internal Xfcc support}
translate E CCDlgConfirmXfcc {Confirm moves}
translate E CCDlgSubjectPar {Subject parameter:}
translate E CCDlgDeleteBoxes {Empty In-/Outbox}
translate E CCDlgDeleteBoxesText {Do you really want to empty your In- and Outbox folders for Correspondence Chess?\nThis requires a new sync to show the last state of your games.}
translate E CCDlgConfirmMove {Confirm move}
translate E CCDlgConfirmMoveText {If you confirm, the following move and comment will be sent to the server:}
translate E CCDlgDBGameToLong {Inconsistent Mainline}
translate E CCDlgDBGameToLongError {The mainline in your database is longer than the game in your Inbox. If the Inbox contains current games, i.e. right after a sync, some moves were added to the mainline in the database erroneously.

In this case please shorten the mainline to (at max) move
}

translate E CCDlgStartEmail {Start new eMail game}
translate E CCDlgYourName {Your Name:}
translate E CCDlgYourMail {Your eMail Address:}
translate E CCDlgOpponentName {Opponents Name:}
translate E CCDlgOpponentMail {Opponents eMail Address:}
translate E CCDlgGameID {Game ID (unique):}

translate E CCDlgTitNoOutbox {Scid: Correspondence Chess Outbox}
translate E CCDlgTitNoInbox {Scid: Correspondence Chess Inbox}
translate E CCDlgTitNoGames {Scid: No Correspondence Chess Games}
translate E CCErrInboxDir {Correspondence Chess inbox directory:}
translate E CCErrOutboxDir {Correspondence Chess outbox directory:}
translate E CCErrDirNotUsable {does not exist or is not accessible!\nPlease check and correct the settings.}
translate E CCErrNoGames {does not contain any games!\nPlease fetch them first.}

translate E CCDlgTitNoCCDB {Scid: No Correspondence Database}
translate E CCErrNoCCDB {No Database of type 'Correspondence' is opened. Please open one before using correspondence chess functions.}

translate E CCFetchBtn {Fetch games from the server and process the Inbox}
translate E CCPrevBtn {Goto previous game}
translate E CCNextBtn {Goto next game}
translate E CCSendBtn {Send move}
translate E CCEmptyBtn {Empty In- and Outbox}
translate E CCHelpBtn {Help on icons and status indicators.\nFor general Help press F1!}

translate E CCDlgServerName {Server Name}
translate E CCDlgLoginName  {Login Name}
translate E CCDlgPassword   {Password}
translate E CCDlgURL        {Xfcc-URL}
translate E CCDlgRatingType {Rating Type}

translate E CCDlgDuplicateGame {Non-unique game ID}
translate E CCDlgDuplicateGameError {This game exists more than once in your database. Please delete all duplicates and compact your game file (File/Maintenance/Compact Database).}

translate E CCDlgSortOption {Sorting:}
translate E CCDlgListOnlyOwnMove {Only games I have the move}
translate E CCOrderClassicTxt {Site, Event, Round, Result, White, Black}
translate E CCOrderMyTimeTxt {My Clock}
translate E CCOrderTimePerMoveTxt {Time per move till next time control}
translate E CCOrderStartDate {Start date}
translate E CCOrderOppTimeTxt {Opponents Clock}

translate E CCDlgConfigRelay {Observe games}
translate E CCDlgConfigRelayHelp {Go to the games page on http://www.iccf-webchess.com and display the game to be observed.  If you see the chessboard copy the URL from your browser to the list below. One URL per line only!\nExample: http://www.iccf-webchess.com/MakeAMove.aspx?id=266452}


# Connect Hardware dialoges
translate E ExtHWConfigConnection {Configure external hardware}
translate E ExtHWPort {Port}
translate E ExtHWEngineCmd {Engine command}
translate E ExtHWEngineParam {Engine parameter}
translate E ExtHWShowButton {Show button in main window}
translate E ExtHWHardware {Hardware}
translate E ExtHWNovag {Novag Citrine}
translate E ExtHWInputEngine {Input Engine}
translate E ExtHWNoBoard {No board}

# Input Engine dialogs
translate E IEConsole {Input Engine Console}
translate E IESending {Moves sent for}
translate E IESynchronise {Synchronise}
translate E IERotate  {Rotate}
translate E IEUnableToStart {Unable to start Input Engine:}
# Calculation of Variations
translate E DoneWithPosition {Done with position}

translate E Board {Board}
translate E showGameInfo {Show game info}
translate E autoResizeBoard {Automatic resize of board}
translate E DockTop {Move to top}
translate E DockBottom {Move to bottom}
translate E DockLeft {Move to left}
translate E DockRight {Move to right}
translate E Undock {Undock}

# Switcher window
translate E ChangeIcon {Change icon}
translate E More {More}

# Drag & Drop
translate E CannotOpenUri {Cannot open the following URI:}
translate E InvalidUri {Drop content is not a valid URI list.}
translate E UriRejected	{The following files are rejected:}
translate E UriRejectedDetail {Only the listed file types can be handled:}
translate E EmptyUriList {Drop content is empty.}
translate E SelectionOwnerDidntRespond {Timeout during drop action: selection owner didn't respond.}

}
# end of english.tcl
