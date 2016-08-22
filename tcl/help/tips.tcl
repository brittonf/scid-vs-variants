
namespace eval ::tip {}

proc ::tip::show {{n -1}} {
  global tips language
  set w .tipsWin

  if {! [winfo exists .tipsWin]} {
    toplevel $w
    wm withdraw $w
    wm title $w "[tr HelpTip]"
    pack [frame $w.b] -side bottom -fill x
    text $w.text -cursor top_left_arrow -width 40 -height 8 -setgrid 1 \
      -yscrollcommand "$w.ybar set" -wrap word
    ::htext::init $w.text
    scrollbar $w.ybar -command "$w.text yview"
    pack $w.ybar -side right -fill y
    pack $w.text -side left -fill both -expand 1
    checkbutton $w.b.start -textvar ::tr(TipAtStartup) -font font_Small \
      -variable startup(tip)
    dialogbutton $w.b.prev -text "<<" -font font_Small
    dialogbutton $w.b.next -text ">>" -font font_Small
    dialogbutton $w.b.close -textvar ::tr(Close) -font font_Small \
      -command "destroy $w"
    pack $w.b.start -side left -padx 2
    packbuttons right $w.b.close $w.b.next $w.b.prev

    bind $w <Up> "$w.text yview scroll -1 units"
    bind $w <Down> "$w.text yview scroll 1 units"
    bind $w <Prior> "$w.text yview scroll -1 pages"
    bind $w <Next> "$w.text yview scroll 1 pages"
    bind $w <Key-Home> "$w.text yview moveto 0"
    bind $w <Key-End> "$w.text yview moveto 0.99"
    bind $w <Escape> "$w.b.close invoke"
    placeWinCenter $w
    wm deiconify $w
  } else {
    raiseWin $w
  }
  $w.text configure -state normal
  $w.text delete 1.0 end
  if {[info exists tips($language)]} {
    set tiplist $tips($language)
  } else {
    set tiplist $tips(E)
  }

  set ntips [llength $tiplist]
  if {$n < 0} {
    set n [expr int(double($ntips) * rand())]
  }
  set prev [expr $n - 1]
  if {$prev < 0} {set prev [expr $ntips - 1]}
  set next [expr ($n + 1) % $ntips]
  $w.b.prev configure -command "::tip::show $prev"
  $w.b.next configure -command "::tip::show $next"
  set tip "<center><b>$::tr(Tip) [expr $n + 1]</b></center><br><br>"
  append tip [string trim [lindex $tiplist $n]]
  ::htext::display $w.text $tip "" 0
}

set tips(E) {
  {
    Scid has over seventy <a Index>Help Pages</a>. They are accessible
    by pressing <b>F1</b> in most windows.
  }
  {
    You can hide (or show) various board components by right-clickng the 'Board' tab (or the whole Main Board in undocked mode).
  }
  {
    Mastering Scid's <a Docking>Docked Windows</a> feature is tricky, but allows for a very configurable desktop.
  }
  {
    Using <b>Control+Wheelmouse</b> in the Main/Pgn/Help windows will adjust the text size.
  }
  {
    Entering moves can be done with the mouse or keyboard
    <br><br>
    See <a Moves>Move Entry</a> help for details.
  }
  {
    Scid has many handy <a ShortCuts>Keyboard shortcuts</a>, though some will only work when the mouse is over the Main Board.
    <br><br>
    Use Undo (Control+Z) and Redo (Control+Y) to edit recent game/move changes.
  }
  {
    Middle clicking the surrounds of the Main Board, and the Gamelist, will hide/show extra information.
  }
  {
    Recently opened games are accessible from the bottom of the <b>Game Menu</b>.
    <br><br>
    Adjust <b>Options--<gt>RecentEntries</b> to configure this menu's size.
  }
  {
    You can see the moves, comments and variations of the current game
    in the <a PGN>PGN Window</a>.
    Prssing middle-mouse on a move will show a preview of that position.
  }
  {
    Copy games from one database to another using drag and drop
    in the <a Switcher>Database Switcher</a> (in the bottom of the gamelist).
    Dragging filtered games to the Clipbase allows one to sort the games without having to sort the
    whole base.
  }
  {
    Single-game PGN files can be saved via <b>File--<gt>Save PGN</b>
    But larger PGN files are always opened read-only.
    <br><br>
    For more information, see <a BrowsingPGN>PGN and Scid</a>
  }
  {
    In the Main Window, double-clicking the Status Bar starts the (first)
    chess engine. Right-clicking docks/undocks the engine.
  }
  {
    Clicking on a player's name shows the <a PInfo>Player Information Window</a>.
    From here, one can easily select all games by the player 
    by clicking on the Win/Lose/Filter values (in green).
  }
  {
    Important databases can be made <b>Read-Only</b> temporarily
    by right-clicking in the <a Switcher>Database Switcher</a>, or (permanently) by changing
    the database's file permissions through Windows/Linux/OSX.
  }
  {
   The <a Maintenance Editing>Name Editor</a> allows one to substitute individual 
   Player and Event names (and more).
  }
  {
    Here's a sorting hint. If you have a large Database where most games have
    an Event Date To sort the games by date, consider <a
    Sorting>sorting</a> it by Event Date, then Event
    (instead of Date then Event), as
    this keeps games in the same tournament, but with different dates,
    together. (Assuming they all have the same EventDate).
  }
  {
    Before looking for <a Maintenance Twins>Twin Games</a>, it is a good idea
    to <a Maintenance Spellcheck>spell check</a> your database, as this
    allows Scid to better find twins.
  }
  {
    <a Flags>Flags</a> are useful for marking database games with
    particular characteristics , such as pawn structure, tactics, etc.
    This can be done in Scid vs. PC's gamelist. There are also 6 custom flags, whose labels can
    be changed in the <a Maintenance>Maintenance</a> window.
  } 
  {
    You can search for flagged or deleted games with the
    <a Searches Header>General Search</a> window.
    After saving Search Criteria with the <b>Save</b> button, these saves can then
    be reloaded later from Scid's main <b>Search Menu</b>.
  }
  {
    If you are playing through a game and want to quickly try out some moves
    , simply turn on Trial mode (with the
    <b>Control-Space</b> shortcut or the buttonbar icon). Turning it off
    again returns the game to it's original state.
  }
  {
    To find the most important games (with high-rated opponents)
    reaching a certain position, open the <a Tree>Tree Window</a>
    and then the Best Games widget. You can even restrict
    these games to show only a particular result.
  }
  {
    The <a Tmt>Tournament Finder</a> not only finds
    a particular tournament, but can also show what tournaments
    a player has recently competed in, or browse the top
    tournaments played in a particular country.
  }
  {
    There are a number of common patterns defined in the
    <a Searches Material>Material/Pattern</a> search window that you
    may find useful for openings or middlegame study.
  }
  {
    When searching for material differences in the
    <a Searches Material>Material/Pattern</a> search window, pay attention
    to the "Half moves" entry, to eliminate games where the difference
    only occurs briefly.
  }
  {
    If you use XBoard , the quickest way to copy a  chess position to Scid
    is to select <b>Copy Position</b> from Xboard's File menu 
    , then <b>Paste FEN</b> from Scid's Edit menu.
  }
  {
    In a <a Searches Header>General Search</a>, Player/Event/Site/Round
    Names are case-insensitive and match anywhere in a name. You can choose
    to do more precise searches using double-quotes and the wildcards
    "?" (any single character) and "*" (zero or more characters)
    For example, searching for <b>belg</b> (in the site field) shows many matches
    but <b>"*Belgium*" shows fewer matches.
  }
  {
    If you want to correct a move in a game without losing all the moves
    played after it, open the <a Import>Import Window</a>, press the
    <b>Paste current game</b> button, edit the incorrect move and then
    press <b>Import</b>.
  }
  {
    If you have an ECO classification file loaded, you can go to the
    deepest classified position in the current game with
    <b>Identify Opening</b> in the <b>Game</b> menu
    (shortcut: Control-Shift-D).
  }
  {
    If you want to check the size of a file or its date of last modification
    before opening it, open the <a Finder>File Finder</a> with <b>Control-/</b>.
  }
  {
    An <a OpReport>Opening Report</a> is great for learning more about
    a particular position. You can see how well it scores, whether it
    leads to frequent short draws, and common positional themes.
  }
  {
    You can add the most common annotation symbols (!, !?, +=, etc) to the
    current move or position with keyboard shortcuts without needing to
    use the <a Comment>comment editor<a> -- for example, type "!" then
    the Return key to add a "!" annotation symbol. See the
    <a Moves>Entering Chess Moves</a> help page for details.
  }
  {
    The Tree Window shows how well a particualr opening scores, 
    but for more detailed statistics, enable "Adjust Filter"
    and open the Statistics Window. This will show the opening score
    for highly rated players, and of the most recent games.
  }
  {
    You can resize the main board size with <b>Control+Wheelmouse</b>, or by
    <b>Control-Shift-Left/Right</b>.
  }
  {
    After a <a Searches>search</a>, you can browse through all
    matching games with <b>Control-Up/Down</b> to load the previous/next
    <a Filter>filter</a> game.
  }
  {
    Scid vs. PC makes <a Tourney>Computer Tournaments</a> between numerous opponents possible.
    To select extra opponents, change the "Number of Engines", then press "Update".
    Short games can be played by entering (for example) .5 minutes , for 30 second games.
  }
  {
    The cut-off menu (dotted line) in the <green>File-<gt>Switch to Database</green> menu makes it a great little database switcher.
  }
  {
    The <a Tree>Tree Window</a> shows all moves played from the
    current position. To see the move orders
    that reached this position, generate an <a OpReport>Opening Report</a>.
  }
  {
   If you have a large database you often use with the <a Tree>Tree</a>,
   selecting <b>Fill Cache File</b> (from the Tree Menu) will greatly speed
   things up.
  }
  {
    When studying an Opening, it can be useful to peform a
    <a Searches Board>Board Search</a> with the Pawns or
    Files option on an important position, as this may
    reveal other openings reaching the same pawn structure.
  }
  {
   The <a Maintenance Cleaner>Maintenance Cleaner</a> allows
   one to do several <a Maintenance>maintenance</a> jobs at the one time.
  }
  {
    A great way to study an opening using a large database of games is
    to turn on training mode in the <a Tree>Tree Window</a>. Then play
    against the database to see which lines most often occur.
  }
}
