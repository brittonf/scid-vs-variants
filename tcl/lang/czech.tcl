# czech.tcl: Czech menus and help for Scid.
# Contributed by Pavel Hanak and Vlastimil Babula
# Untranslated messages are marked with a "***" comment.

addLanguage C Czech 0 iso8859-2

proc setLanguage_C {} {

# File menu:
menuText C File "Soubor" 0
menuText C FileNew "Nový..." 0 {Vytvoøit novou Scid databázi}
menuText C FileOpen "Otevøít..." 0 {Otevøít existující Scid databázi}
menuText C FileClose "Zavøít" 0 {Zavøít aktivní Scid databázi}
menuText C FileFinder "Vyhledávaè" 2 {Otevøít okno vyhledávaèe souborù}
menuText C FileSavePgn "Save Pgn..." 0 {}
# ====== TODO To be translated ======
menuText C FileOpenBaseAsTree "Open Base as Tree" 13   {Open a base and use it in Tree window}
# ====== TODO To be translated ======
menuText C FileOpenRecentBaseAsTree "Open Recent as Tree" 0   {Open a recent base and use it in Tree window}
menuText C FileBookmarks "Zálo¾ky" 2 {Menu zálo¾ek (klávesa: Ctrl+B)}
menuText C FileBookmarksAdd "Pøidat zálo¾ku" 0 \
  {Zálo¾ka aktuální pozice a partie z databáze}
menuText C FileBookmarksFile "Zaøadit zálo¾ku" 0 \
  {Zaøadit zálo¾ku pro aktuální partii a pozici}
menuText C FileBookmarksEdit "Editovat zálo¾ky..." 0 \
  {Editovat menu zálo¾ek}
menuText C FileBookmarksList "Zobrazit slo¾ky jako jediný seznam" 0 \
  {Zobrazit slo¾ky se zálo¾kami jako jediný seznam, bez podnabídek}
menuText C FileBookmarksSub "Zobrazit slo¾ky jako podnabídky" 9 \
  {Zobrazit zálo¾kové slo¾ky jako podnabídky, ne jako jediný seznam}
menuText C FileReadOnly "Pouze pro ètení..." 0 \
  {Nastavit aktuální databázi jako jen ke ètení, a zabránit tak zmìnám}
menuText C FileSwitch "Pøepnout se do databáze" 15 \
  {Pøepnout se do jiné otevøené databáze}
menuText C FileExit "Ukonèit" 0 {Ukonèit Scid}

# Edit menu:
menuText C Edit "Editace" 0
menuText C EditAdd "Pøidat variantu" 0 {Pøidat variantu k tomuto tahu v partii}
menuText C EditPasteVar "Vlozit variace" 0
menuText C EditDelete "Vymazat variantu" 0 {Vymazat variantu k tomuto tahu}
menuText C EditFirst "Zaøadit jako první variantu" 0 \
  {Zaøadit variantu na první místo v seznamu variant}
menuText C EditMain "Pový¹it stávající variantu na hlavní" 30 \
  {Pový¹it stávající variantu na hlavní variantu}
menuText C EditTrial "Zkusit variantu" 1 \
    {Spustit/Ukonèit zku¹ební mód pro testování my¹lenky na ¹achovnici}
menuText C EditStrip "Odstranit" 0 {Odstranit komentáøe nebo varianty z této partie}
menuText C EditUndo "Vzít zpìt" 0 {Vzít zpìt poslední zmìnu v partii}
# todo
menuText C EditRedo "Redo" 0
menuText C EditStripComments "Komentáøe" 0 \
  {Odstranit v¹echny poznámky a anotace z této partie}
menuText C EditStripVars "Varianty" 0 {Odstranit v¹echny varianty z této partie}
menuText C EditStripBegin "Tahy ze zaèátku" 5 \
  {Odstranit tahy ze zaèátku partie}
menuText C EditStripEnd "Tahy do konce" 5 \
  {Odstranit tahy do konce partie}
menuText C EditReset "Vyprázdnit schránku" 11 \
  {Kompletní vyprázdnìní databáze schránka}
menuText C EditCopy "Zkopírovat tuto partii do schránky" 23 \
  {Zkopírovat tuto partií do databáze schránka}
menuText C EditPaste "Vlo¾it poslední partii ze schránky" 24 \
  {Vlo¾it aktivní partii z databáze schránka}
menuText C EditPastePGN "Paste Clipboard text as PGN game..." 10 \
  {Interpret the clipboard text as a game in PGN notation and paste it here} ;# ***
menuText C EditSetup "Nastavit výchozí pozici..." 0 \
  {Nastavit výchozí pozici pro tuto partii}
menuText C EditCopyBoard "Kopírovat pozici" 4 \
  {Kopírovat aktuální pozici ve FEN notaci do textového výbìru (do clipboardu)}
menuText C EditCopyPGN "Kopírovat PGN" 0 {} 
menuText C EditPasteBoard "Vlo¾it poèáteèní pozici" 1 \
  {Nastavit poèáteèní pozici z aktuálního textového výbìru (z clipboardu)}

# Game menu:
menuText C Game "Partie" 0
menuText C GameNew "Nová partie" 0 \
  {Nastavit novou partii, v¹echny provedené zmìny budou ztraceny}
menuText C GameFirst "Natáhnout první partii" 10 {Natáhnout první partii z filtrovaných partií}
menuText C GamePrev "Natáhnout pøedchozí partii" 13 {Natáhnout pøedchozí partii z filtrovaných partií}
menuText C GameReload "Znovunatáhnout aktuální partii" 0 \
  {Znovunata¾ení aktuální partie, v¹echny doposud provedené zmìny budou ztraceny}
menuText C GameNext "Natáhnout následující partii" 14 {Natáhnout následující partii z filtrovaných partií}
menuText C GameLast "Natáhnout poslední partii" 11 {Natáhnout poslední partii z filtrovaných partií}
menuText C GameRandom "Natáhnout partii náhodnì" 1 {Natáhnout náhodnì vybranou partii z filtru}
menuText C GameNumber "Natáhnout partii èíslo..." 19 \
  {Natáhnout partii èíslo...}
menuText C GameReplace "Ulo¾it: pøepsání partie..." 0 \
  {Ulo¾it tuto partii - pøepí¹e pùvodní verzi}
menuText C GameAdd "Ulo¾it: pøidání nové partie..." 1 \
  {Ulo¾it tuto partii jako novou partii v databázi}
menuText C GameInfo "Set Informace o hre" 0
menuText C GameBrowse "Procházet hry" 0
menuText C GameList "Seznam vsech her" 0
# ====== TODO To be translated ======
menuText C GameDelete "Delete Game" 0
menuText C GameDeepest "Identifikace zahájení" 0 \
  {Pøejít na koncovou pozici z ECO knihovny, která odpovídá zvolenému zahájení}
menuText C GameGotoMove "Pøejít na tah èíslo..." 10 \
  {Pøejít v aktuální partii do pozice udané èíslem tahu}
menuText C GameNovelty "Hledat novinku..." 0 \
  {Hledat první tah této partie, který doposud nebyl hrán}

# Search Menu:
menuText C Search "Hledat" 0
menuText C SearchReset "Vyèistit filtr" 0 {Vyèistit filtr - vybrány budou v¹echny partie}
menuText C SearchNegate "Negace filtru" 0 {Negace filtru -  vybrány budou pouze partie vyòaté pøedcházejícím filtrem}
menuText C SearchEnd "Presun na poslední filtr" 0
menuText C SearchCurrent "Aktuální pozice..." 0 {Hledat aktuální pozici}
menuText C SearchHeader "Hlavièka..." 0 {Hledat podle hlavièky partie (hráè, turnaj apod.)}
menuText C SearchMaterial "Materiál/Vzor..." 0 {Hledat podle materiálu nebo podle vzoru}
menuText C SearchMoves {Tahy} 0 {}
menuText C SearchUsing "Hledat pomocí souboru voleb..." 14 {Hledat s pou¾itím voleb zapsaných v souboru}

# Windows menu:
menuText C Windows "Okna" 0
menuText C WindowsGameinfo "Game Info" 0 {Show/hide the game info panel}
menuText C WindowsComment "Editor komentáøù" 0 {Otevøít/zavøít editor komentáøù}
menuText C WindowsGList "Seznam partií" 2 {Otevøít/zavøít okno se seznamem partií}
menuText C WindowsPGN "Okno PGN" 5 {Otevøít/zavøít okno PGN}
menuText C WindowsCross "Turnajová tabulka" 0 {Ukázat turnajovou tabulku pro tuto partii}
menuText C WindowsPList "Vyhledávaè hráèù" 11 {Otevøít/zavøít okno vyhledávaèe hráèù}
menuText C WindowsTmt "Vyhledávaè turnajù" 11 {Otevøít/zavøít okno vyhledávaèe turnajù}
menuText C WindowsSwitcher "Výbìr databáze" 0 {Otevøít/zavøít okno pro výbìr databází}
menuText C WindowsMaint "Okno údr¾by" 6 {Otevøít/zavøít okno údr¾by}
menuText C WindowsECO "ECO prohlí¾eè" 1 {Otevøít/zavøít okno ECO prohlí¾eèe}
menuText C WindowsStats "Statistické okno" 0 {Otevøít/zavøít statistické okno filtru}
menuText C WindowsTree "Stromové okno" 4 {Otevøít/zavøít stromové okno}
menuText C WindowsTB "Okno tabulky koncovek" 13 {Otevøít/zavøít okno tabulek koncovek}
# ====== TODO To be translated ======
menuText C WindowsBook "Book Window" 0 {Open/close the Book window}
# ====== TODO To be translated ======
menuText C WindowsCorrChess "Correspondence Window" 0 {Open/close the Correspondence window}

# Tools menu:
menuText C Tools "Nástroje" 3
menuText C ToolsAnalysis "Program pro analýzu..." 0 \
  {Spustit/zastavit ¹achový program pro analýzu pozice}
menuText C ToolsEmail "Email mana¾er" 1 \
  {Otevøít/zavøít okno emailového mana¾era}
menuText C ToolsFilterGraph "Graf filtru" 0 \
  {Otevøít/zavøít okno grafu filtru}
# ====== TODO To be translated ======
menuText C ToolsAbsFilterGraph "Abs. Filter Graph" 7 {Open/close the filter graph window for absolute values}
menuText C ToolsOpReport "Profil zahájení" 7 \
  {Generovat profil zahájení pro aktuální pozicí}
menuText C ToolsTracker "Stopaø figur"  0 {Otevøít okno stopaøe figur}
# ====== TODO To be translated ======
menuText C ToolsTraining "Training"  0 {Training tools (tactics, openings,...) }
menuText C ToolsComp "Tournament" 2 {Chess engine tournament}
# ====== TODO To be translated ======
menuText C ToolsTacticalGame "Tactical game"  0 {Play a game with tactics}
# ====== TODO To be translated ======
menuText C ToolsSeriousGame "Serious game"  0 {Play a serious game}
# ====== TODO To be translated ======
menuText C ToolsTrainTactics "Tactics"  0 {Solve tactics}
# ====== TODO To be translated ======
menuText C ToolsTrainCalvar "Calculation of variations"  0 {Calculation of variations training}
# ====== TODO To be translated ======
menuText C ToolsTrainFindBestMove "Find best move"  0 {Find best move}
# ====== TODO To be translated ======
menuText C ToolsTrainFics "Internet"  0 {Play on freechess.org}
# ====== TODO To be translated ======
menuText C ToolsBookTuning "Book tuning" 0 {Book tuning}
menuText C ToolsMaint "Údr¾ba" 2 {Nástroje pro údr¾bu databáze Scidu}
menuText C ToolsMaintWin "Okno údr¾by" 0 \
  {Otevøít/zavøít okno pro údr¾bu Scid databáze}
menuText C ToolsMaintCompact "Kompaktování databáze..." 13 \
  {Kompaktování databázových souborù, odstranìní vymazaných partií a nepou¾ívaných jmen}
menuText C ToolsMaintClass "ECO klasifikace partií..." 0 \
  {Pøepoèítání ECO kódù v¹ech partií}
menuText C ToolsMaintSort "Setøídit databázi..." 0 \
  {Setøídit v¹echny partie v databázi}
menuText C ToolsMaintDelete "Vymazání zdvojených partií..." 0 \
  {Hledat zdvojené partie a oznaèit je pro vymazání}
menuText C ToolsMaintTwin "Kontrola zdvojených partií" 0 \
  {Otevøít/aktualizovat okno pro kontrolu zdvojených partií}
menuText C ToolsMaintNameEditor "Editor jmen" 0 \
  {Otevøít/zavøít editor jmen}
menuText C ToolsMaintNamePlayer "Kontrola pravopisu hráèù..." 19 \
  {Kontrola pravopisu jmen hráèù s vyu¾itím souboru pro kontrolu pravopisu}
menuText C ToolsMaintNameEvent "Kontrola pravopisu turnajù..." 19 \
  {Kontrola pravopisu názvù turnajù s vyu¾itím souboru pro kontrolu pravopisu}
menuText C ToolsMaintNameSite "Kontrola pravopisu míst..." 19 \
  {Kontrola pravopisu míst turnajù s vyu¾itím souboru pro kontrolu pravopisu}
menuText C ToolsMaintNameRound "Kontrola pravopisu kol..." 19 \
  {Kontrola pravopisu kol s vyu¾itím souboru pro kontrolu pravopisu}
# ====== TODO To be translated ======
menuText C ToolsMaintFixBase "Repair base" 0 {Try to repair a corrupted base}
# ====== TODO To be translated ======
menuText C ToolsConnectHardware "Connect Hardware" 0 {Connect external hardware}
# ====== TODO To be translated ======
menuText C ToolsConnectHardwareConfigure "Configure..." 0 {Configure external hardware and connection}
# ====== TODO To be translated ======
menuText C ToolsConnectHardwareNovagCitrineConnect "Connect Novag Citrine" 0 {Connect Novag Citrine}
# ====== TODO To be translated ======
menuText C ToolsConnectHardwareInputEngineConnect "Connect Input Engine" 0 {Connect Input Engine (e.g. DGT)}
# ====== TODO To be translated ======
menuText C ToolsNovagCitrine "Novag Citrine" 0 {Novag Citrine}
# ====== TODO To be translated ======
menuText C ToolsNovagCitrineConfig "Configuration" 0 {Novag Citrine configuration}
# ====== TODO To be translated ======
menuText C ToolsNovagCitrineConnect "Connect" 0 {Novag Citrine connect}
menuText C ToolsPInfo "Informace o hráèích"  0 \
  {Otevøít/aktualizovat okno s informacemi o hráèích}
menuText C ToolsPlayerReport "Profil hráèe" 7 \
  {Generovat profil hráèe}
menuText C ToolsRating "Graf ratingu" 5 \
  {Zobrazit graf vývoje ratingu hráèù aktuální partie}
menuText C ToolsScore "Graf skóre" 6  {Zobrazit okno grafu skóre}
menuText C ToolsExpCurrent "Export aktuální partie" 7 \
  {Zapsat aktuální partii do textového souboru}
menuText C ToolsExpCurrentPGN "Export partie do PGN souboru..." 17 \
  {Zapsat aktuální partii do PGN souboru}
menuText C ToolsExpCurrentHTML "Export partie do HTML souboru..." 17 \
  {Zapsat aktuální partii do HTML souboru}
# ====== TODO To be translated ======
menuText C ToolsExpCurrentHTMLJS "Export Game to HTML and JavaScript File..." 15 {Write current game to a HTML and JavaScript file}  
menuText C ToolsExpCurrentLaTeX "Export partie do LaTeX souboru..." 17 \
  {Zapsat aktuální partii do LaTeX souboru}
# ====== TODO To be translated ======
menuText C ToolsExpFilter "Export filtrovaných partií" 7 \
  {Zapsat v¹echny filtrované partie do textového souboru}
menuText C ToolsExpFilterPGN "Export filtrovaných partií do PGN souboru..." 30 \
  {Zapsat v¹echny filtrované partie do PGN souboru}
menuText C ToolsExpFilterHTML "Export filtrovaných partií do HTML souboru..." 30 \
  {Zapsat v¹echny filtrované partie do HTML souboru}
# ====== TODO To be translated ======
menuText C ToolsExpFilterHTMLJS "Export Filter to HTML and JavaScript File..." 17 {Write all filtered games to a HTML and JavaScript file}  
menuText C ToolsExpFilterLaTeX "Export filtrovaných partií do LaTeX souboru..." 30 \
  {Zapsat v¹echny filtrované partie do LaTeX souboru}
# ====== TODO To be translated ======
# ====== TODO To be translated ======
menuText C ToolsExpFilterGames "Export Gamelist to Text" 19 {Print a formatted Gamelist.}
menuText C ToolsImportOne "Import jedné PGN partie..." 7 \
  {Importovat partii z PGN zápisu}
menuText C ToolsImportFile "Import souboru PGN partií..." 10 \
  {Importovat partie z PGN souboru}
# ====== TODO To be translated ======
menuText C ToolsStartEngine1 "Start engine 1" 0  {Start engine 1}
# ====== TODO To be translated ======
menuText C ToolsStartEngine2 "Start engine 2" 0  {Start engine 2}
# ====== TODO To be translated ======
menuText C ToolsScreenshot "desce Screenshot" 0
menuText C Play "Hra" 0
menuText C CorrespondenceChess "Korespondenèní ¹ach" 0 {Funkce pro korespondenèní ¹ach zalo¾ený na e-mailu a Xfcc}
menuText C CCConfigure "Konfigurovat..." 0 {Konfigurovat externí nástroje a obecná nastavení}
menuText C CCConfigRelay "Konfigurovat sledování..." 10 {Konfigurovat partie ke sledování}
menuText C CCOpenDB "Otevøít databázi..." 0 {Otevøít výchozí korespondenèní databázi}
menuText C CCRetrieve "Stáhnout partie" 0 {Stáhnout partie s pomocí externího (Xfcc-)nástroje}
menuText C CCInbox "Zpracovat pøíchozí schránku" 0 {Zpracovat v¹echny soubory v pøíchozí schránce scidu}
menuText C CCSend "Poslat tah" 0 {Poslat tah prostøednictvím e-mailu nebo externího (Xfcc-)nástroje}
menuText C CCResign "Vzdát" 0 {Vzdát (nikoliv prostøednictvím e-mailu)}
menuText C CCClaimDraw "Reklamovat remízu" 0 {Poslat tah a reklamovat remízu (nikoliv prostøednictvím e-mailu)}
menuText C CCOfferDraw "Nabídnout remízu" 0 {Odeslat tah a nabídnout remízu (nikoliv prostøednictvím e-mailu)}
menuText C CCAcceptDraw "Pøijmout remízu" 0 {Pøijmout nabídku remízy (nikoliv prostøednictvím e-mailu)}
menuText C CCNewMailGame "Nová e-mailová partie..." 0 {Zaèít novou e-mailovou partii}
menuText C CCMailMove "Mailovat tah..." 0 {Odeslat tah soupeøi prostøednictvím e-mailu}
menuText C CCGamePage "Stránka partie..." 0 {Vyvolat partii pomocí webového prohlí¾eèe}
menuText C CCEditCopy "Zkopírovat seznam partií do schránky" 0 {Zkopírovat partie jako CVS seznam do schránky}


# Options menu:
menuText C Options "Volby" 0
menuText C OptionsBoard "©achovnice" 1 {Volby zobrazení ¹achovnice}
menuText C OptionsColour "Background Colour" 0 {Default text widget color}
# ====== TODO To be translated ======
menuText C OptionsBackColour "Background" 0 {Default text widget color}
# ====== TODO To be translated ======
menuText C OptionsEnableColour "Enable" 0 {}
# ====== TODO To be translated ======
menuText C OptionsMainLineColour "Mainline Arrows" 0 {Mainline arrows}
# ====== TODO To be translated ======
menuText C OptionsVarLineColour "Variation Arrows" 0 {Variation arrows}
# ====== TODO To be translated ======
menuText C OptionsRowColour "Rows" 0 {Default tree/book row color}
# ====== TODO To be translated ======
menuText C OptionsSwitcherColour "Switcher" 0 {Default db switcher color}
# ====== TODO To be translated ======
menuText C OptionsProgressColour "Progressbar" 0 {Default progressbar color}
# ====== TODO To be translated ======
menuText C OptionsCrossColour "Crosstable rows" 0 {Default crosstable row color}
menuText C OptionsNames "Jména mých hráèù..." 0 {Editovat jména mých hráèù}
menuText C OptionsExport "Volby exportu" 7 {Zmìnit volby pro textový export}
menuText C OptionsFonts "Fonty" 2 {Zmìnit fonty}
menuText C OptionsFontsRegular "Základní" 0 {Zmìnit základní font}
menuText C OptionsFontsMenu "Menu" 1 {Zmìnit font pro menu}
menuText C OptionsFontsSmall "Malé" 0 {Zmìnit malý font}
menuText C OptionsFontsFixed "Fixní" 0 {Zmìnit font fixní ¹íøky}
menuText C OptionsGInfo "Informace o partii" 0 {Volby pro informace o partii}
menuText C OptionsFics "FICS" 0
menuText C OptionsFicsAuto "Autopromote královna" 0
# ====== TODO To be translated ======
menuText C OptionsFicsColour "Text Colour" 0
# ====== TODO To be translated ======
menuText C OptionsFicsSize "Board Size" 0
# ====== TODO To be translated ======
menuText C OptionsFicsButtons "User Buttons" 0
# ====== TODO To be translated ======
menuText C OptionsFicsCommands "Init Commands" 0
# ====== TODO To be translated ======
menuText C OptionsFicsNoRes "No Results" 0
# ====== TODO To be translated ======
menuText C OptionsFicsNoReq "No Requests" 0
# ====== TODO To be translated ======
menuText C OptionsFicsPremove "Allow Premove" 0
menuText C OptionsLanguage "Jazyk" 0 {Vybrat jazyk menu}
# ====== TODO To be translated ======
menuText C OptionsMovesTranslatePieces "Translate pieces" 0 {Translate first letter of pieces}
# ====== TODO To be translated ======
menuText C OptionsMovesHighlightLastMove "Highlight last move" 0 {Highlight last move}
# ====== TODO To be translated ======
menuText C OptionsMovesHighlightLastMoveDisplay "Show" 0 {Display last move Highlight}
# ====== TODO To be translated ======
menuText C OptionsMovesHighlightLastMoveWidth "Width" 0 {Thickness of line}
# ====== TODO To be translated ======
menuText C OptionsMovesHighlightLastMoveColor "Color" 0 {Color of line}
menuText C OptionsMoves "Tahy" 0 {Volby pro zadávání tahù}
menuText C OptionsMovesAsk "Ptát se pøed nahrazením tahù" 0 \
  {Ptát se v¾dy pøed pøepsáním existujícího tahu}
menuText C OptionsMovesAnimate "Èas animace" 4 \
  {Nastavit èas pou¾itý na animaci tahù}
menuText C OptionsMovesDelay "Prodleva pøi automatickém pøehrávání..." 1 \
  {Nastavit èasovou prodlevu pøi automatickém pøehrávání}
menuText C OptionsMovesCoord "Souøadnicové zadávání tahù" 0 \
  {Povolit zadávání tahù pomocí souøadnic (napø. "g1f3")}
menuText C OptionsMovesSuggest "Ukázat navrhované tahy" 0 \
  {Zapnout/vypnout zobrazování navrhovaných tahù}
# ====== TODO To be translated ======
menuText C OptionsShowVarPopup "Show Variation Window" 0 {Turn on/off the display of a variations window}  
# ====== TODO To be translated ======
menuText C OptionsMovesSpace "Add spaces after move number" 0 {Add spaces after move number}  
menuText C OptionsMovesKey "Klávesnicové doplòování" 13 \
  {Zapnout/vypnout automatické doplòování tahù zadávaných klávesnicí}
menuText C OptionsMovesShowVarArrows "Zobrazit ¹ipky pro varianty" 0 {Zapnout/vypnout zobrazování ¹ipek ukazujících tahy variant}
menuText C OptionsNumbers "Formát èísel" 0 {Zvolit formát èísel}
menuText C OptionsStartup "Pøi spu¹tìní" 4 {Zvolit okna, která se otevøou pøi spu¹tìní}
menuText C OptionsTheme "Téma" 0 {Zmìnit vzhled u¾ivatelského rozhraní}
menuText C OptionsWindows "Okna" 0 {Volby oken}
menuText C OptionsWindowsIconify "Automatická minimalizace" 12 \
   {Minimalizovat v¹echna okna pøi minimalizování hlavního okna}
menuText C OptionsWindowsRaise "Automaticky do popøedí" 15 \
  {Dát do popøedí jistá okna, jsou-li zakrytá}
menuText C OptionsSounds "Sounds..." 2 {Configure move announcement sounds} ;# ***
menuText C OptionsWindowsDock "Zaparkovat okna" 0 {Zaparkovat okna}
menuText C OptionsWindowsSaveLayout "Ulo¾it rozlo¾ení" 0 {Ulo¾it rozlo¾ení}
menuText C OptionsWindowsRestoreLayout "Obnovit rozlo¾ení" 0 {Obnovit rozlo¾ení}
menuText C OptionsWindowsShowGameInfo "Ukázat informace o partii" 0 {Ukázat informace o partii}
menuText C OptionsWindowsAutoLoadLayout "Automaticky natáhnout první rozlo¾ení" 0 {Automaticky na zaèátku natáhnout první rozlo¾ení}
# todo
menuText C OptionsWindowsAutoResize "Auto resize board" 0 {}
# ====== TODO To be translated ======
menuText C OptionsWindowsFullScreen "Fullscreen" 0 {Toggle fullscreen mode}
menuText C OptionsToolbar "Nástrojová li¹ta..." 11 \
  {Konfigurovat nástrojovou li¹tu hlavního okna}
menuText C OptionsECO "Natáhnout ECO soubor..." 10 {Natáhnout soubor s klasifikací ECO}
menuText C OptionsSpell "Natáhnout soubor pro kontrolu pravopisu..." 21 \
  {Natáhnout soubor Scidu pro kontrolu pravopisu}
menuText C OptionsTable "Adresáø pro tabulky koncovek..." 14 \
  {Vybrat soubor s tabulkami koncovek; v¹echny tabulky koncovek v jeho adresáøi budou pou¾ity}
menuText C OptionsRecent "Nedávné soubory..." 0 \
  {Zmìnit poèet nedávných souborù zobrazovaných v menu Soubor}
# ====== TODO To be translated ======
menuText C OptionsBooksDir "Books directory..." 0 {Sets the opening books directory}
# ====== TODO To be translated ======
menuText C OptionsTacticsBasesDir "Bases directory..." 0 {Sets the tactics (training) bases directory}
menuText C OptionsSave "Ulo¾it volby" 0 \
  "Ulo¾it v¹echny nastavitelné volby do souboru $::optionsFile"
menuText C OptionsAutoSave "Automaticky ukládat volby pøi ukonèení" 20 \
  {Automaticky ukládat v¹echny volby pøi ukonèení Scidu}

# Help menu:
menuText C Help "Nápovìda" 0
menuText C HelpContents "Obsah" 0 {Zobrazit stránku nápovìdy s obsahem}
menuText C HelpIndex "Index" 0 {Zobrazit stránku nápovìdy s indexem}
menuText C HelpGuide "Rychlý prùvodce" 7 {Zobrazit stránku nápovìdy s rychlým prùvodcem}
menuText C HelpHints "Rady" 0 {Zobrazit stránku nápovìdy s radami}
menuText C HelpContact "Kontakt" 0 {Zobrazit stránku nápovìdy s kontaktními informacemi}
menuText C HelpTip "Tip dne" 4 {Zobrazit u¾iteèný tip Scidu}
menuText C HelpStartup "Startovací okno" 0 {Zobrazit startovací okno}
menuText C HelpAbout "O aplikaci Scid" 2 {Informace o aplikaci Scid}

# Game info box popup menu:
menuText C GInfoHideNext "Skrýt následující tah" 0
# ====== TODO To be translated ======
menuText C GInfoShow "Side to Move" 0
# ====== TODO To be translated ======
menuText C GInfoCoords "Toggle Coords" 0
menuText C GInfoMaterial "Ukázat hodnoty materiálu" 15
menuText C GInfoFEN "Ukázat FEN" 7
menuText C GInfoMarks "Zobrazovat barevná pole a ¹ipky" 11
menuText C GInfoWrap "Zalamovat dlouhé øádky" 0
menuText C GInfoFullComment "Zobrazit úplný komentáø" 15
menuText C GInfoPhotos "Zobrazit fotky" 10
menuText C GInfoTBNothing "Tabulky koncovek: nic" 19
menuText C GInfoTBResult "Tabulky koncovek: jen výsledek" 23
menuText C GInfoTBAll "Tabulky koncovek: výsledek a nejlep¹í tahy" 39
menuText C GInfoDelete "Vymazat/Nemazat tuto partii" 0
menuText C GInfoMark "Oznaèit/Odznaèit tuto partii" 0
# ====== TODO To be translated ======
menuText C GInfoInformant "Configure informant values" 0
# ====== TODO To be translated ======
translate C FlipBoard {Flip board}
# ====== TODO To be translated ======
translate C RaiseWindows {Raise windows}
# ====== TODO To be translated ======
translate C AutoPlay {Autoplay}
# ====== TODO To be translated ======
translate C TrialMode {Trial mode}

# General buttons:
# ====== TODO To be translated ======
translate C Apply {Apply}
translate C Back {Zpìt}
translate C Browse {Prohlí¾et}
translate C Cancel {Zru¹it}
# ====== TODO To be translated ======
translate C Continue {Continue}
translate C Clear {Vyèistit}
translate C Close {Zavøít}
translate C Contents {Obsah}
translate C Defaults {Pøedvolené}
translate C Delete {Vymazat}
translate C Graph {Graf}
translate C Help {Nápovìda}
translate C Import {Import}
translate C Index {Index}
translate C LoadGame {Natáhnout partii}
translate C BrowseGame {Prohlédnout partii}
translate C MergeGame {Pøipojit partii}
# ====== TODO To be translated ======
translate C MergeGames {Merge Games}
translate C Preview {Náhled}
translate C Revert {Vrátit se}
translate C Save {Ulo¾it}
# ====== TODO To be translated ======
translate C DontSave {Don't Save}
translate C Search {Hledat}
translate C Stop {Stop}
translate C Store {Uschovat}
translate C Update {Aktualizovat}
translate C ChangeOrient {Zmìnit orientaci okna}
translate C ShowIcons {Show Icons} ;# ***
# ====== TODO To be translated ======
translate C ConfirmCopy {Confirm Copy}
translate C None {Nic}
translate C First {První}
translate C Current {Aktuální}
translate C Last {Poslední}
# ====== TODO To be translated ======
translate C Font {Font}
# ====== TODO To be translated ======
translate C Change {Change}
# ====== TODO To be translated ======
translate C Random {Random}

# General messages:
translate C game {partie}
translate C games {partie}
translate C move {tah}
translate C moves {tahy}
translate C all {v¹e}
translate C Yes {Ano}
translate C No {Ne}
translate C Both {Oba}
translate C King {Král}
translate C Queen {Dáma}
translate C Rook {Vì¾}
translate C Bishop {Støelec}
translate C Knight {Jezdec}
translate C Pawn {Pì¹ec}
translate C White {Bílý}
translate C Black {Èerný}
translate C Player {Hráè}
translate C Rating {Rating}
translate C RatingDiff {Rozdíl v ratingu (Bílý - Èerný)}
translate C AverageRating {Prùmìrný rating}
translate C Event {Turnaj}
translate C Site {Místo}
translate C Country {Zemì}
translate C IgnoreColors {Ignorovat barvy}
# ====== TODO To be translated ======
translate C MatchEnd {End pos only}
translate C Date {Datum}
translate C EventDate {Datum turnaje}
translate C Decade {Dekáda}
translate C Year {Rok}
translate C Month {Mìsíc}
translate C Months {Leden Únor Bøezen Duben Kvìten Èerven Èervenec Srpen Záøí Øíjen Listopad Prosinec}
translate C Days {Ned Pon Úte Stø Ètv Pát Sob}
translate C YearToToday {Rok zpìt}
translate C Result {Výsledek}
translate C Round {Kolo}
translate C Length {Délka}
translate C ECOCode {ECO kód}
translate C ECO {ECO}
translate C Deleted {Vymazán(a)}
translate C SearchResults {Hledat výsledky}
translate C OpeningTheDatabase {Databáze zahájení}
translate C Database {Databáze}
translate C Filter {Filtr}
# ====== TODO To be translated ======
translate C Reset {Reset}
translate C IgnoreCase {Ignorovat Pouzdro}
translate C noGames {¾ádné partie}
translate C allGames {v¹echny partie}
translate C empty {prázdná}
translate C clipbase {schránka}
translate C score {skóre}
translate C Start {Poèáteèní}
translate C StartPos {Poèáteèní pozice}
translate C Total {Celkem}
translate C readonly {read-only} ;# ***
# ====== TODO To be translated ======
translate C altered {altered}
# ====== TODO To be translated ======
translate C tagsDescript {Extra tags (eg: Annotator "Anand")}
# ====== TODO To be translated ======
translate C prevTags {Use previous}

# Standard error messages:
translate C ErrNotOpen {To není otevøená databáze.}
translate C ErrReadOnly {Tato databáze je jen ke ètení; nemù¾e být zmìnìna.}
translate C ErrSearchInterrupted {Hledání bylo pøeru¹eno; výsledky nejsou kompletní.}

# Game information:
translate C twin {zdvojená}
translate C deleted {vymazaná}
translate C comment {komentáø}
translate C hidden {skrytá}
translate C LastMove {Poslední tah}
translate C NextMove {Následující tah}
translate C GameStart {Zaèátek partie}
translate C LineStart {Zaèátek série tahù}
translate C GameEnd {Konec partie}
translate C LineEnd {Konec série tahù}

# Player information:
translate C PInfoAll {v¹ech partií}
translate C PInfoFilter {filtrovaných partií}
translate C PInfoAgainst {Výsledky proti}
translate C PInfoMostWhite {Nejèastìj¹í zahájení za bílé}
translate C PInfoMostBlack {Nejèastìj¹í zahájení za èerné}
translate C PInfoRating {Historie ratingu}
translate C PInfoBio {Biografie}
translate C PInfoEditRatings {Editovat ratingy}
# ====== TODO To be translated ======
translate C PinfoEditName {Edit Name}
# ====== TODO To be translated ======
translate C PinfoLookupName {Lookup Name}

# Tablebase information:
translate C Draw {Remíza}
translate C stalemate {pat}
# ====== TODO To be translated ======
translate C checkmate {checkmate}
translate C withAllMoves {se v¹emi tahy}
translate C withAllButOneMove {se v¹emi tahy kromì posledního}
translate C with {s}
translate C only {jen}
translate C lose {prohrát}
translate C loses {prohrává}
translate C allOthersLose {v¹echny ostatní prohrávají}
translate C matesIn {matuje bìhem}
translate C longest {nejdel¹í}
translate C WinningMoves {vyhrávající tahy}
translate C DrawingMoves {remizující tahy}
translate C LosingMoves {prohrávající tahy}
translate C UnknownMoves {tahy s neznámým výsledkem}

# Tip of the day:
translate C Tip {Tip}
translate C TipAtStartup {Tip pøi spu¹tìní}

# Tree window menus:
menuText C TreeFile "Soubor" 0
menuText C TreeFileFillWithBase "Naplnit cache z databáze" 0 {Naplnit cachovací soubor v¹emi partiemi z aktuální databáze}
menuText C TreeFileFillWithGame "Naplnit cache partií" 0 {Naplnit cachovací soubor aktuální partií z aktuální databáze}
menuText C TreeFileSetCacheSize "Velikost cache" 0 {Nastavit velikost cache}
menuText C TreeFileCacheInfo "Informace o cache" 0 {Získat informaci o vyu¾ití cache}
menuText C TreeFileSave "Ulo¾it cache soubor" 0 \
  {Ulo¾it stromový cache (.stc) soubor}
menuText C TreeFileFill "Naplnit cache soubor" 0 \
  {Naplnit cache soubor nejbì¾nìj¹ími pozicemi zahájení}
menuText C TreeFileBest "Seznam nejlep¹ích partií" 0 {Zobrazit seznam nejlep¹ích partií  stromu}
menuText C TreeFileGraph "Okno grafu" 0 {Zobrazit graf pro tuto vìtev stromu}
menuText C TreeFileCopy "Kopírovat text stromu do clipboardu" 0 \
  {Kopírovat stromové statistiky do textového výbìru}
menuText C TreeFileClose "Zavøít stromové okno" 0 {Zavøít stromové okno}
menuText C TreeMask "Maska" 0
menuText C TreeMaskNew "New" 0 {Nová maska}
menuText C TreeMaskOpen "Open" 0 {Otevøít masku}
menuText C TreeMaskOpenRecent "Open recent" 0 {Otevøít nedávnou masku}
menuText C TreeMaskSave "Save" 0 {Ulo¾it masku}
menuText C TreeMaskClose "Close" 0 {Uzavøit masku}
# ====== TODO To be translated ======
menuText C TreeMaskFillWithLine "Fill with line" 0 {Fill mask with all previous moves}
menuText C TreeMaskFillWithGame "Naplnit partií" 0 {Naplnit masku partií}
menuText C TreeMaskFillWithBase "Naplnit databází" 0 {Naplnit masku v¹emi partiemi z databáze}
menuText C TreeMaskInfo "Info" 0 {Ukázat statistiku aktuální masky}
menuText C TreeMaskDisplay "Display mask map" 0 {Ukázat data masky ve formì stromu}
menuText C TreeMaskSearch "Search" 0 {Hledat v aktuální masce}
menuText C TreeSort "Øadit" 2
menuText C TreeSortAlpha "Abecednì" 0
menuText C TreeSortECO "ECO kód" 0
menuText C TreeSortFreq "Frekvence" 0
menuText C TreeSortScore "Skóre" 0
menuText C TreeOpt "Volby" 0
menuText C TreeOptSlowmode "pomalý re¾im" 0 {Pomalý re¾im aktualizace (vysoká pøesnost)}
menuText C TreeOptFastmode "Rychlý re¾im" 0 {Rychlý re¾im aktualizace (beze zmìny poøadí tahù)}
menuText C TreeOptFastAndSlowmode "Rychlý a pomalý re¾im" 0 {Rychlý re¾im a potom pomalý re¾im aktualizace}
menuText C TreeOptStartStop "Automatické aktualizace" 0 {Pøepnout automatické aktualizace stromového okna}
menuText C TreeOptLock "Zamknout" 0 {Zamknout/Odemknout strom k aktuální databázi}
menuText C TreeOptTraining "Trénink" 0 {Zapnout/Vypnout stromový tréninkový mód}
# ====== TODO To be translated ======
menuText C TreeOptShort "Short Display" 0 {Don't show ELO information}
menuText C TreeOptAutosave "Automatické ukládání cache souboru" 0 \
  {Automatické ukládání cache souboru pøi uzavøení stromového okna}
# ====== TODO To be translated ======
menuText C TreeOptAutomask "Auto-Load Mask" 0 "Auto-Load most recent mask with a tree open."
# ====== TODO To be translated ======
menuText C TreeOptShowBar "Show Progress Bar" 0 "Show tree progress bar."
# ====== TODO To be translated ======
menuText C TreeOptSortBest "Sort Best Games" 0 "Sort Best Games by ELO."
menuText C TreeHelp "Nápovìda" 0
menuText C TreeHelpTree "Nápovìda - Strom" 11
menuText C TreeHelpIndex "Index nápovìdy" 0

translate C SaveCache {Ulo¾it cache}
translate C Training {Trénink}
translate C LockTree {Zamknout}
translate C TreeLocked {Zamknuto}
translate C TreeBest {Nejlep¹í}
translate C TreeBestGames {Nejlep¹í partie stromu}
# ====== TODO To be translated ======
translate C TreeAdjust {Adjust Filter}
# Note: the next message is the tree window title row. After editing it,
# check the tree window to make sure it lines up with the actual columns.
translate C TreeTitleRow {    Tah       Frekvence    Skóre Remíz PrElo Perf PrRok ECO}
translate C TreeTitleRowShort {    Tah       Frekvence    Skóre Remíz}
translate C TreeTotal {CELKEM}
translate C DoYouWantToSaveFirst {Chcete nejprve ulo¾it}
translate C AddToMask {Pøidat do masky}
translate C RemoveFromMask {Odstranit z masky}
translate C AddThisMoveToMask {Pøidat tento tah do masky}
translate C SearchMask {Hledat v masce}
translate C DisplayMask {Zobrazit masku}
translate C Nag {Nag kód}
translate C Marker {Znaèka}
translate C Include {Zahrnout}
translate C Exclude {Vylouèit}
translate C MainLine {Hlavní varianta}
translate C Bookmark {Zálo¾ka}
translate C NewLine {Nová varianta}
translate C ToBeVerified {K provìøení}
translate C ToTrain {Trénovat}
translate C Dubious {Pochybné}
translate C ToRemove {Odstranit}
translate C NoMarker {®ádná znaèka}
translate C ColorMarker {Barva}
translate C WhiteMark {Bílá}
translate C GreenMark {Zelená}
translate C YellowMark {®lutá}
translate C BlueMark {Modrá}
translate C RedMark {Èervená}
translate C CommentMove {Okomentovat tah}
translate C CommentPosition {Okomentovat pozici}
translate C AddMoveToMaskFirst {Nejprve pøidejte tah do masky}
translate C OpenAMaskFileFirst {Nejprve otevøete soubor masky}
translate C Positions {Pozice}
translate C Moves {Tahy}

# Finder window:
menuText C FinderFile "Soubor" 0
menuText C FinderFileSubdirs "Hledat v podadresáøích" 0
menuText C FinderFileClose "Zavøít vyhledávaè souborù" 0
menuText C FinderSort "Øadit" 2
menuText C FinderSortType "Typ" 0
menuText C FinderSortSize "Velikost" 0
menuText C FinderSortMod "Zmìnìno" 0
menuText C FinderSortName "Jméno" 0
menuText C FinderSortPath "Cesta" 0
menuText C FinderTypes "Typy" 0
menuText C FinderTypesScid "Databáze Scidu" 0
menuText C FinderTypesOld "Databáze Scidu starého formátu" 15
menuText C FinderTypesPGN "PGN soubory" 0
menuText C FinderTypesEPD "EPD soubory" 0
menuText C FinderHelp "Nápovìda" 0
menuText C FinderHelpFinder "Nápovìda - Vyhledávaè souborù" 11
menuText C FinderHelpIndex "Index nápovìdy" 0
translate C FileFinder {Vyhledávaè souborù}
translate C FinderDir {Adresáø}
translate C FinderDirs {Adresáøe}
translate C FinderFiles {Soubory}
translate C FinderUpDir {nahoru}
# ====== TODO To be translated ======
translate C FinderCtxOpen {Open}
# ====== TODO To be translated ======
translate C FinderCtxBackup {Backup}
# ====== TODO To be translated ======
translate C FinderCtxCopy {Copy}
# ====== TODO To be translated ======
translate C FinderCtxMove {Move}
# ====== TODO To be translated ======
translate C FinderCtxDelete {Delete}

# Player finder:
menuText C PListFile "Soubor" 0
menuText C PListFileUpdate "Aktualizovat" 0
menuText C PListFileClose "Zavøít vyhledávaè hráèù" 0
menuText C PListSort "Øadit" 2
menuText C PListSortName "Jméno" 0
menuText C PListSortElo "ELO" 0
menuText C PListSortGames "Partie" 0
menuText C PListSortOldest "Nejstar¹í" 3
menuText C PListSortNewest "Nejnovìj¹í" 3

# Tournament finder:
menuText C TmtFile "Soubor" 0
menuText C TmtFileUpdate "Aktualizovat" 0
menuText C TmtFileClose "Zavøít vyhledávaè souborù" 0
menuText C TmtSort "Øadit" 2
menuText C TmtSortDate "Datum" 0
menuText C TmtSortPlayers "Hráèi" 0
menuText C TmtSortGames "Partie" 0
menuText C TmtSortElo "ELO" 0
menuText C TmtSortSite "Místo" 0
menuText C TmtSortEvent "Turnaj" 0
menuText C TmtSortWinner "Vítìz" 0
translate C TmtLimit "Limit seznamu"
translate C TmtMeanElo "Prùmìrné ELO"
translate C TmtNone "®ádné odpovídající turnaje nebyly nalezeny."

# Graph windows:
menuText C GraphFile "Soubor" 0
menuText C GraphFileColor "Ulo¾it jako barevný Postscript..." 12
menuText C GraphFileGrey "Ulo¾it jako èernobílý Postscript..." 13
menuText C GraphFileClose "Zavøít okno" 0
menuText C GraphOptions "Volby" 0
menuText C GraphOptionsWhite "Bílý" 0
menuText C GraphOptionsBlack "Èerný" 1
menuText C GraphOptionsBoth "Oba" 0
menuText C GraphOptionsPInfo "Informace o hráèi" 0
translate C GraphFilterTitle "Graf filtru: èetnost na 1000 partií"
# ====== TODO To be translated ======
translate C GraphAbsFilterTitle "Filter Graph: frequency of the games"
# ====== TODO To be translated ======
translate C ConfigureFilter {Configure X Axis}
# ====== TODO To be translated ======
translate C FilterEstimate "Estimate"
# ====== TODO To be translated ======
translate C TitleFilterGraph "Scid: Filter Graph"

# Analysis window:
translate C AddVariation {Pøidat variantu}
# ====== TODO To be translated ======
translate C AddAllVariations {Add All Variations}
translate C AddMove {Pøidat tah}
translate C Annotate {Anotace}
# ====== TODO To be translated ======
translate C ShowAnalysisBoard {Show analysis board}
# ====== TODO To be translated ======
translate C ShowInfo {Show engine info}
# ====== TODO To be translated ======
translate C FinishGame {Finish game}
# ====== TODO To be translated ======
translate C StopEngine {Stop engine}
# ====== TODO To be translated ======
translate C StartEngine {Start engine}
# ====== TODO To be translated ======
translate C ExcludeMove {Exclude Move}
# ====== TODO To be translated ======
translate C LockEngine {Lock engine to current position}
translate C AnalysisCommand {Program pro analýzu}
translate C PreviousChoices {Pøedchozí vybrané programy}
translate C AnnotateTime {Nastavit èas mezi tahy v sekundách}
translate C AnnotateWhich {Pøidat varianty}
translate C AnnotateAll {Pro tahy obou stran}
# ====== TODO To be translated ======
translate C AnnotateAllMoves {Annotate all moves}
translate C AnnotateWhite {Pouze pro tahy bílého}
translate C AnnotateBlack {Pouze pro tahy èerného}
translate C AnnotateNotBest {Pokud tah v partii není nejlep¹ím tahem}
# ====== TODO To be translated ======
translate C AnnotateBlundersOnly {When game move is an obvious blunder}
# ====== TODO To be translated ======
translate C BlundersNotBest {Blunders/Not Best}
# ====== TODO To be translated ======
translate C AnnotateBlundersOnlyScoreChange {Analysis reports blunder, with score change from/to: }
translate C AnnotateTitle {Konfigurace Anotace}
# ====== TODO To be translated ======
translate C BlundersThreshold {Threshold}
# ====== TODO To be translated ======
translate C ScoreFormat {Score format}
# ====== TODO To be translated ======
translate C CutOff {Cut Off}
translate C LowPriority {Nízká CPU priorita}
# ====== TODO To be translated ======
translate C LogEngines {Log Size}
# ====== TODO To be translated ======
translate C LogName {Add Name}
# ====== TODO To be translated ======
translate C MaxPly {Max Ply}
# ====== TODO To be translated ======
translate C ClickHereToSeeMoves {Click here to see moves}
# ====== TODO To be translated ======
translate C ConfigureInformant {Configure Informant}
# ====== TODO To be translated ======
translate C Informant!? {Interesting move}
# ====== TODO To be translated ======
translate C Informant? {Poor move}
# ====== TODO To be translated ======
translate C Informant?? {Blunder}
# ====== TODO To be translated ======
translate C Informant?! {Dubious move}
# ====== TODO To be translated ======
translate C Informant+= {White has a slight advantage}
# ====== TODO To be translated ======
translate C Informant+/- {White has a moderate advantage}
# ====== TODO To be translated ======
translate C Informant+- {White has a decisive advantage}
# ====== TODO To be translated ======
translate C Informant++- {The game is considered won}
# ====== TODO To be translated ======
translate C Book {Book}

# Analysis Engine open dialog:
translate C EngineList {Seznam programù pro analýzu}
# ====== TODO To be translated ======
translate C EngineKey {Key}
# ====== TODO To be translated ======
translate C EngineType {Type}
translate C EngineName {Jméno}
translate C EngineCmd {Pøíkaz}
translate C EngineArgs {Parametry}
translate C EngineDir {Adresáø}
translate C EngineElo {ELO}
translate C EngineTime {Datum}
translate C EngineNew {Nový}
translate C EngineEdit {Editace}
translate C EngineRequired {Tuènì vyznaèené polo¾ky jsou povinné; ostatní jsou volitelné}

# Stats window menus:
menuText C StatsFile "Soubor" 0
menuText C StatsFilePrint "Vytisknout do souboru..." 0
menuText C StatsFileClose "Zavøít okno" 0
menuText C StatsOpt "Volby" 0

# PGN window menus:
menuText C PgnFile "Soubor" 0
menuText C PgnFileCopy "Kopírovat partii do clipboardu" 0
menuText C PgnFilePrint "Vytisknout do souboru..." 0
menuText C PgnFileClose "Zavøít okno PGN" 0
menuText C PgnOpt "Zobrazit" 0
menuText C PgnOptColor "Barevné zobrazení" 0
menuText C PgnOptShort "Krátká (tøíøádková) hlavièka" 20
menuText C PgnOptSymbols "Symbolické anotace" 0
menuText C PgnOptIndentC "Odsazovat komentáøe" 10
menuText C PgnOptIndentV "Odsazovat varianty" 10
menuText C PgnOptColumn "Sloupcový styl (jeden tah na øádek)" 1
menuText C PgnOptSpace "Mezera za èíslem tahu" 0
menuText C PgnOptStripMarks "Odstranit kódy barevných polí a ¹ipek" 0
menuText C PgnOptChess "Sachové figurky" 0
menuText C PgnOptScrollbar "Posuvník" 0
menuText C PgnOptBoldMainLine "Use Bold Text for Main Line Moves" 4 ;# ***
menuText C PgnColor "Barvy" 0
menuText C PgnColorHeader "Hlavièka..." 0
menuText C PgnColorAnno "Anotace..." 0
menuText C PgnColorComments "Komentáøe..." 0
menuText C PgnColorVars "Varianty..." 0
menuText C PgnColorBackground "Pozadí..." 0
# ====== TODO To be translated ======
menuText C PgnColorMain "Main line..." 0
# ====== TODO To be translated ======
menuText C PgnColorCurrent "Current move background..." 1
# ====== TODO To be translated ======
menuText C PgnColorNextMove "Next move background..." 0
menuText C PgnHelp "Nápovìda" 0
menuText C PgnHelpPgn "Nápovìda - Okno PGN " 16
menuText C PgnHelpIndex "Index nápovìdy" 0
translate C PgnWindowTitle {Game Notation - game %u} ;# ***

# Crosstable window menus:
menuText C CrosstabFile "Soubor" 0
menuText C CrosstabFileText "Vytisknout do textového souboru..." 14
menuText C CrosstabFileHtml "Vytisknout do HTML souboru..." 14
menuText C CrosstabFileLaTeX "Vytisknout do LaTeX souboru..." 14
menuText C CrosstabFileClose "Zavøít okno turnajové tabulky" 0
menuText C CrosstabEdit "Editovat" 0
menuText C CrosstabEditEvent "Turnaj" 0
menuText C CrosstabEditSite "Místo" 0
menuText C CrosstabEditDate "Datum" 0
menuText C CrosstabOpt "Zobrazit" 0
menuText C CrosstabOptColorPlain "Prostý text" 0
menuText C CrosstabOptColorHyper "Hypertext" 0
# ====== TODO To be translated ======
menuText C CrosstabOptTieWin "Tie-Break by wins" 1
# ====== TODO To be translated ======
menuText C CrosstabOptTieHead "Tie-Break by head-head" 1
# todo
menuText C CrosstabOptThreeWin "3 Points for Win" 1
menuText C CrosstabOptAges "Vìk" 0
menuText C CrosstabOptNats "Národnost" 0
# todo
menuText C CrosstabOptTallies "Win/Loss/Draw" 0
menuText C CrosstabOptRatings "Rating" 0
menuText C CrosstabOptTitles "Titul" 0
menuText C CrosstabOptBreaks "Výsledky tie-breaku" 10
menuText C CrosstabOptDeleted "Vèetnì vymazaných partií" 9
menuText C CrosstabOptColors "Barvy (jen pro ¹výcarský systém)" 0
# ====== TODO To be translated ======
menuText C CrosstabOptColorRows "Color Rows" 0
menuText C CrosstabOptColumnNumbers "Èíslované sloupce (jen v tabulkách 'ka¾dý s ka¾dým')" 3
menuText C CrosstabOptGroup "Skupiny podle skóre" 0
menuText C CrosstabSort "Øadit" 2
menuText C CrosstabSortName "Jméno" 0
menuText C CrosstabSortRating "Rating" 0
menuText C CrosstabSortScore "Skóre" 0
menuText C CrosstabSortCountry "Zemì" 0
# todo
menuText C CrosstabType "Format" 0
menuText C CrosstabTypeAll "Ka¾dý s ka¾dým" 0
menuText C CrosstabTypeSwiss "©výcarský systém" 3
menuText C CrosstabTypeKnockout "Vyøazovací" 4
menuText C CrosstabTypeAuto "Auto" 0
menuText C CrosstabHelp "Nápovìda" 0
menuText C CrosstabHelpCross "Nápovìda - Turnajovou tabulku" 11
menuText C CrosstabHelpIndex "Index nápovìdy" 0
translate C SetFilter {Nastavit filtr}
translate C AddToFilter {Pøidat do filtru}
translate C Swiss {©výcarský systém}
translate C Category {Kategorie}

# Opening report window menus:
menuText C OprepFile "Soubor" 0
menuText C OprepFileText "Vytisknout do textového souboru..." 14
menuText C OprepFileHtml "Vytisknout do HTML souboru..." 14
menuText C OprepFileLaTeX "Vytisknout do LaTeX souboru..." 14
menuText C OprepFileOptions "Volby" 0
menuText C OprepFileClose "Zavøít okno s profilem" 0
menuText C OprepFavorites "Oblíbené" 0
menuText C OprepFavoritesAdd "Pøidat profil..." 0
menuText C OprepFavoritesEdit "Editovat oblíbené profily..." 0
menuText C OprepFavoritesGenerate "Generovat profil..." 0
menuText C OprepHelp "Nápovìda" 0
menuText C OprepHelpReport "Nápovìda - Profil zahájení" 11
menuText C OprepHelpIndex "Index nápovìdy" 11

# Header search:
translate C HeaderSearch {Hledat podle hlavièky}
translate C EndSideToMove {Side to move at end of game} ;# ***
translate C GamesWithNoECO {Partie bez ECO?}
translate C GameLength {Délka Partie}
translate C FindGamesWith {Najít partie s pøíznaky}
translate C StdStart {Nestandardní start}
translate C Promotions {Promìny}
# ====== TODO To be translated ======
translate C UnderPromo {Under Prom.}
translate C Comments {Komentáøe}
translate C Variations {Varianty}
translate C Annotations {Anotace}
translate C DeleteFlag {Mazací pøíznak}
translate C WhiteOpFlag {Zahájení bílého}
translate C BlackOpFlag {Zahájení èerného}
translate C MiddlegameFlag {Støední hra}
translate C EndgameFlag {Koncovka}
translate C NoveltyFlag {Novinka}
translate C PawnFlag {Pì¹cová struktura}
translate C TacticsFlag {Taktika}
translate C QsideFlag {Hra na dámském køídle}
translate C KsideFlag {Hra na královském køídle}
translate C BrilliancyFlag {Brilantní}
translate C BlunderFlag {Hrubka}
translate C UserFlag {U¾ivatel}
translate C PgnContains {PGN obsahuje text}

# Game list window:
translate C GlistNumber {Èíslo}
translate C GlistWhite {Bílý}
translate C GlistBlack {Èerný}
translate C GlistWElo {B-ELO}
translate C GlistBElo {È-ELO}
translate C GlistEvent {Turnaj}
translate C GlistSite {Místo}
translate C GlistRound {Kolo}
translate C GlistDate {Datum}
translate C GlistYear {Rok}
translate C GlistEventDate {Datum turnaje}
translate C GlistResult {Výsledek}
translate C GlistLength {Délka}
translate C GlistCountry {Zemì}
translate C GlistECO {ECO}
translate C GlistOpening {Zahájení}
translate C GlistEndMaterial {Materiál na konci}
translate C GlistDeleted {Vymazán(a)}
translate C GlistFlags {Pøíznak}
translate C GlistVariations {Varianty}
translate C GlistComments {Komentáøe}
translate C GlistAnnos {Anotace}
translate C GlistStart {Poèáteèní pozice}
translate C GlistGameNumber {Èíslo partie}
translate C GlistFindText {Hledat text}
translate C GlistMoveField {Pøesunout}
translate C GlistEditField {Konfigurovat}
translate C GlistAddField {Pøidat}
translate C GlistDeleteField {Odebrat}
translate C GlistColor {Barva}
# ====== TODO To be translated ======
translate C GlistSort {Sort database}
# ====== TODO To be translated ======
translate C GlistRemoveThisGameFromFilter  {Remove}
# ====== TODO To be translated ======
translate C GlistRemoveGameAndAboveFromFilter  {Remove game (and all above it)}
# ====== TODO To be translated ======
translate C GlistRemoveGameAndBelowFromFilter  {Remove game (and all below it)}
# ====== TODO To be translated ======
translate C GlistDeleteGame {(Un)Delete this game} 
# ====== TODO To be translated ======
translate C GlistDeleteAllGames {Delete all games in filter} 
# ====== TODO To be translated ======
translate C GlistUndeleteAllGames {Undelete all games in filter} 
# ====== TODO To be translated ======
translate C GlistAlignL {Align left}
# ====== TODO To be translated ======
translate C GlistAlignR {Align right}
# ====== TODO To be translated ======
translate C GlistAlignC {Align center}

# Maintenance window:
translate C DatabaseName {Jméno databáze:}
translate C TypeIcon {Symbol}
translate C NumOfGames {Partie:}
translate C NumDeletedGames {Vymazané partie:}
translate C NumFilterGames {Partie ve filtru:}
translate C YearRange {Rozsah rokù:}
translate C RatingRange {Rozsah ratingu:}
translate C Description {Popis}
translate C Flag {Pøíznak}
translate C CustomFlags {U¾ivatelské pøíznaky}
translate C DeleteCurrent {Vymazat aktuální partii}
translate C DeleteFilter {Vymazat filtrované partie}
translate C DeleteAll {Vymazat v¹echny partie}
translate C UndeleteCurrent {Obnovit aktuální partie po vymazání}
translate C UndeleteFilter {Obnovit filtrované partie po vymazání}
translate C UndeleteAll {Obnovit v¹echny partie po vymazání}
translate C DeleteTwins {Vymazat zdvojené partie}
translate C MarkCurrent {Oznaèit aktivní partii}
translate C MarkFilter {Oznaèit filtrované partie}
translate C MarkAll {Oznaèit v¹echny partie}
translate C UnmarkCurrent {Odznaèit aktuální partii}
translate C UnmarkFilter {Odznaèit filtrované partie}
translate C UnmarkAll {Odznaèit v¹echny partie}
translate C Spellchecking {Kontrola pravopisu}
# ====== TODO To be translated ======
translate C MakeCorrections {Make Corrections}
# ====== TODO To be translated ======
translate C Ambiguous {Ambiguous}
# ====== TODO To be translated ======
translate C Surnames {Surnames}
translate C Players {Hráèi}
translate C Events {Turnaje}
translate C Sites {Místa}
translate C Rounds {Kola}
translate C DatabaseOps {Databázové operace}
translate C ReclassifyGames {ECO klasifikace partií}
translate C CompactDatabase {Kompaktovat databázi}
translate C SortDatabase {Øadit databázi}
translate C AddEloRatings {Pøidat ELO rating}
translate C AutoloadGame {Automaticky otevírat partii è.}
translate C StripTags {Odstranit PGN znaèky}
translate C StripTag {Odstranit znaèku}
# ====== TODO To be translated ======
translate C CheckGames {Check games}
translate C Cleaner {Èi¹tìní databáze}
translate C CleanerHelp {
    Èi¹tìním databáze Scid provede u aktuální databáze v¹echny údr¾báøské akce, které zvolíte v seznamu.

    Pokud zvolíte ECO klasifikaci a mazání zdvojených partií pou¾ijí se aktuální nastavení z pøíslu¹ných dialogù.
}
translate C CleanerConfirm {
Jakmile je èi¹tìní jednou spu¹tìno, nemù¾e ji¾ být pøeru¹eno!

Tato akce mù¾e pro velké databáze trvat dlouhou dobu v závislosti na funkcích, které jste zvolili, a v závislosti na jejich stávajícím nastavení.

Jste si jisti, ¾e chcete zaèít s údr¾báøskými funkcemi, které jste zvolili?
}
# ====== TODO To be translated ======
translate C TwinCheckUndelete {to flip; "u" undeletes both)}
# ====== TODO To be translated ======
translate C TwinCheckprevPair {Previous pair}
# ====== TODO To be translated ======
translate C TwinChecknextPair {Next pair}
# ====== TODO To be translated ======
translate C TwinChecker {Scid: Twin game checker}
# ====== TODO To be translated ======
translate C TwinCheckTournament {Games in tournament:}
# ====== TODO To be translated ======
translate C TwinCheckNoTwin {No twin  }
# ====== TODO To be translated ======
translate C TwinCheckNoTwinfound {No twin was detected for this game.\nTo show twins using this window, you must first use the "Delete twin games..." function. }
# ====== TODO To be translated ======
translate C TwinCheckTag {Share tags...}
# ====== TODO To be translated ======
translate C TwinCheckFound1 {Scid found $result twin games}
# ====== TODO To be translated ======
translate C TwinCheckFound2 { and set their delete flags}
# ====== TODO To be translated ======
translate C TwinCheckNoDelete {There are no games in this database to delete.}
# ====== TODO To be translated ======
translate C TwinCriteria1 { Your settings for finding twin games are potentially likely to\ncause non-twin games with similar moves to be marked as twins.}
# ====== TODO To be translated ======
translate C TwinCriteria2 {It is recommended that if you select "No" for "same moves", you should select "Yes" for the colors, event, site, round, year and month settings.\nDo you want to continue and delete twins anyway? }
# ====== TODO To be translated ======
translate C TwinCriteria3 {It is recommended that you specify "Yes" for at least two of the "same site", "same round" and "same year" settings.\nDo you want to continue and delete twins anyway?}
# ====== TODO To be translated ======
translate C TwinCriteriaConfirm {Scid: Confirm twin settings}
# ====== TODO To be translated ======
translate C TwinChangeTag "Change the following game tags:\n\n"
# ====== TODO To be translated ======
translate C AllocRatingDescription "This command will use the current spellcheck file to add Elo ratings to games in this database. Wherever a player has no currrent rating but his/her rating at the time of the game is listed in the spellcheck file, that rating will be added."
# ====== TODO To be translated ======
translate C RatingOverride "Overwrite existing non-zero ratings?"
# ====== TODO To be translated ======
translate C AddRatings "Add ratings to:"
# ====== TODO To be translated ======
translate C AddedRatings {Scid added $r Elo ratings in $g games.}
# ====== TODO To be translated ======
translate C NewSubmenu "New submenu"

# Comment editor:
translate C AnnotationSymbols  {Anotaèní symboly:}
translate C Comment {Komentáø:}
translate C InsertMark {Vlo¾it znaèku}
translate C InsertMarkHelp {
Insert/remove mark: Select color, type, square.
Insert/remove arrow: Right-click two squares.
} ;# ***

# Nag buttons in comment editor:
translate C GoodMove {Good move} ;# ***
translate C PoorMove {Poor move} ;# ***
translate C ExcellentMove {Excellent move} ;# ***
translate C Blunder {Hrubka}
translate C InterestingMove {Interesting move} ;# ***
translate C DubiousMove {Dubious move} ;# ***
translate C WhiteDecisiveAdvantage {White has a decisive advantage} ;# ***
translate C BlackDecisiveAdvantage {Black has a decisive advantage} ;# ***
translate C WhiteClearAdvantage {White has a clear advantage} ;# ***
translate C BlackClearAdvantage {Black has a clear advantage} ;# ***
translate C WhiteSlightAdvantage {White has a slight advantage} ;# ***
translate C BlackSlightAdvantage {Black has a slight advantage} ;# ***
translate C Equality {Equality} ;# ***
translate C Unclear {Unclear} ;# ***
translate C Diagram {Diagram} ;# ***

# Board search:
translate C BoardSearch {Hledat pozici}
translate C FilterOperation {Operace s aktuálním filtrem:}
translate C FilterAnd {A (Omezit filtr)}
translate C FilterOr {NEBO (Pøidat k filtru)}
translate C FilterIgnore {IGNOROVAT (Ignoruj filtr)}
translate C SearchType {Typ hledání:}
translate C SearchBoardExact {Pøesná pozice (v¹echny figury na stejných polích)}
translate C SearchBoardPawns {Pì¹ci (tentý¾ materiál, v¹ichni pì¹ci na stejných polích)}
translate C SearchBoardFiles {Sloupce (tentý¾ materiál, v¹ichni pì¹ci na stejných sloupcích)}
translate C SearchBoardAny {Jakákoliv (tentý¾ materiál, pì¹ci a figury kdekoliv)}
translate C SearchInRefDatabase { Hledat v databázi }
translate C LookInVars {Dívat se do variant}

# Material search:
translate C MaterialSearch {Hledat materiál}
translate C Material {Materiál}
translate C Patterns {Vzory}
translate C Zero {Nic}
translate C Any {Cokoliv}
translate C CurrentBoard {Aktuální pozice}
translate C CommonEndings {Typické koncovky}
translate C CommonPatterns {Typické vzory}
translate C MaterialDiff {Rozdíl v materiálu}
translate C squares {pole}
translate C SameColor {Stejnobarevné}
translate C OppColor {Nestejnobarevné}
translate C Either {Obojí}
translate C MoveNumberRange {Rozsah tahù}
translate C MatchForAtLeast {Shoda pro minimálnì}
translate C HalfMoves {pùltahù}

# Common endings in material search:
translate C EndingPawns {Pawn endings} ;# ***
translate C EndingRookVsPawns {Rook vs. Pawn(s)} ;# ***
translate C EndingRookPawnVsRook {Rook and 1 Pawn vs. Rook} ;# ***
translate C EndingRookPawnsVsRook {Rook and Pawn(s) vs. Rook} ;# ***
translate C EndingRooks {Rook vs. Rook endings} ;# ***
translate C EndingRooksPassedA {Rook vs. Rook endings with a passed a-pawn} ;# ***
translate C EndingRooksDouble {Double Rook endings} ;# ***
translate C EndingBishops {Bishop vs. Bishop endings} ;# ***
translate C EndingBishopVsKnight {Bishop vs. Knight endings} ;# ***
translate C EndingKnights {Knight vs. Knight endings} ;# ***
translate C EndingQueens {Queen vs. Queen endings} ;# ***
translate C EndingQueenPawnVsQueen {Queen and 1 Pawn vs. Queen} ;# ***
translate C BishopPairVsKnightPair {Two Bishops vs. Two Knights middlegame} ;# ***

# Common patterns in material search:
translate C PatternWhiteIQP {White IQP} ;# ***
translate C PatternWhiteIQPBreakE6 {White IQP: d4-d5 break vs. e6} ;# ***
translate C PatternWhiteIQPBreakC6 {White IQP: d4-d5 break vs. c6} ;# ***
translate C PatternBlackIQP {Black IQP} ;# ***
translate C PatternWhiteBlackIQP {White IQP vs. Black IQP} ;# ***
translate C PatternCoupleC3D4 {White c3+d4 Isolated Pawn Couple} ;# ***
translate C PatternHangingC5D5 {Black Hanging Pawns on c5 and d5} ;# ***
translate C PatternMaroczy {Maroczy Center (with Pawns on c4 and e4)} ;# ***
translate C PatternRookSacC3 {Rook Sacrifice on c3} ;# ***
translate C PatternKc1Kg8 {O-O-O vs. O-O (Kc1 vs. Kg8)} ;# ***
translate C PatternKg1Kc8 {O-O vs. O-O-O (Kg1 vs. Kc8)} ;# ***
translate C PatternLightFian {Light-Square Fianchettos (Bishop-g2 vs. Bishop-b7)} ;# ***
translate C PatternDarkFian {Dark-Square Fianchettos (Bishop-b2 vs. Bishop-g7)} ;# ***
translate C PatternFourFian {Four Fianchettos (Bishops on b2,g2,b7,g7)} ;# ***

# Game saving:
translate C Today {Dnes}
translate C ClassifyGame {Klasifikovat partii}

# Setup position:
translate C EmptyBoard {Vyprázdnit ¹achovnici}
translate C InitialBoard {Výchozí pozice}
translate C SideToMove {Na tahu je}
translate C MoveNumber {Èíslo tahu}
translate C Castling {Ro¹áda}
translate C EnPassantFile {En Passant sloupec}
translate C ClearFen {Vyèistit FEN}
translate C PasteFen {Vlo¾it FEN}
# ====== TODO To be translated ======
translate C SaveAndContinue {Save and continue}
# ====== TODO To be translated ======
translate C DiscardChangesAndContinue {Discard Changes}
# ====== TODO To be translated ======
translate C GoBack {Go back}

# Replace move dialog:
translate C ReplaceMove {Nahradit tah}
translate C AddNewVar {Pøidat novou variantu}
# ====== TODO To be translated ======
translate C NewMainLine {New Main Line}
translate C ReplaceMoveMessage {Zde ji¾ existuje tah.

Mù¾ete ho nahradit, a zru¹it tak i v¹echny následující tahy, nebo mù¾ete vá¹ tah pøidat jako novou variantu.

(Zobrazení této zprávy mù¾ete v budoucnu potlaèit pøepnutím volby "Ptát se pøed nahrazením tahù" v menu Volby:Tahy.)}

# Make database read-only dialog:
translate C ReadOnlyDialog {Pokud databázi nastavíte jako jen ke ètení, nebudou povoleny ¾ádné zmìny.
®ádné partie nebude mo¾no ulo¾it ani pøepsat a ¾ádný mazací pøíznak nebude mo¾no zmìnit.
V¹echny výsledky operace øazení èi ECO klasifikace budou pouze doèasné.

Databázi mù¾ete uèinit opìt zapisovatelnou pomocí jejího zavøení a opìtovného otevøení.

Pøejete si skuteènì nastavit tuto databázi jako jen ke ètení?}

# Exit dialog:
translate C ExitDialog {Opravdu si pøejete ukonèit Scid?}
# ====== TODO To be translated ======
translate C ClearGameDialog {This game has been altered.\nDo you wish to save it?}
translate C ExitUnsaved {Následující databáze obsahují partie s neulo¾enými zmìnami. Pokud nyní skonèíte, budou tyto zmìny ztraceny.}

# Import window:
translate C PasteCurrentGame {Vlo¾it aktuální partii}
translate C ImportHelp1 {Zapsat nebo vlo¾it partii ve formátu PGN do rámce nahoøe.}
translate C ImportHelp2 {Jakékoli chyby pøi importu partie budou zobrazeny zde.}
# ====== TODO To be translated ======
translate C OverwriteExistingMoves {Overwrite existing moves ?}

# ECO Browser:
translate C ECOAllSections {v¹echny ECO sekce}
translate C ECOSection {ECO sekce}
translate C ECOSummary {Souhrn pro}
translate C ECOFrequency {Frekvence subkódù pro}

# Opening Report:
translate C OprepTitle {Profil zahájení}
translate C OprepReport {Profil}
translate C OprepGenerated {Generován}
translate C OprepStatsHist {Statistika a historie}
translate C OprepStats {Statistika}
translate C OprepStatAll {V¹echny partie profilu}
translate C OprepStatBoth {Oba ratingovaní}
translate C OprepStatSince {Od}
translate C OprepOldest {Nejstar¹í partie}
translate C OprepNewest {Nejnovìj¹í partie}
translate C OprepPopular {Stávající popularita}
translate C OprepFreqAll {Frekvence za v¹echny roky: }
translate C OprepFreq1   {Bìhem posledního roku:     }
translate C OprepFreq5   {Bìhem posledních 5 let:    }
translate C OprepFreq10  {Bìhem posledních 10 let:   }
translate C OprepEvery {jednou z %u partií}
translate C OprepUp {více o %u%s v porovnání se v¹emi roky}
translate C OprepDown {ménì o %u%s v porovnání se v¹emi roky}
translate C OprepSame {¾ádná zmìna pøi porovnání se v¹emi roky}
translate C OprepMostFrequent {Nejèastìj¹í hráèi}
translate C OprepMostFrequentOpponents {Nejèastìj¹í soupeøi}
translate C OprepRatingsPerf {Ratingy a performance}
translate C OprepAvgPerf {Prùmìrné ratingy a performance}
translate C OprepWRating {Rating bílý}
translate C OprepBRating {Rating èerný}
translate C OprepWPerf {Performance bílý}
translate C OprepBPerf {Performance èerný}
translate C OprepHighRating {Partie s nejvy¹¹ím prùmìrným ratingem}
translate C OprepTrends {Výsledkový trend}
translate C OprepResults {Délka partií a frekvence}
translate C OprepLength {Délka partií}
translate C OprepFrequency {Frekvence}
translate C OprepWWins {Výhry bílý: }
translate C OprepBWins {Výhry èerný: }
translate C OprepDraws {Remízy:      }
translate C OprepWholeDB {celá databáze}
translate C OprepShortest {Nejkrat¹í výhry}
translate C OprepMovesThemes {Tahy a témata}
translate C OprepMoveOrders {Posloupnosti tahù vedoucí k profilované pozici}
translate C OprepMoveOrdersOne \
  {Nalezena pouze jedna posloupnost tahù vedoucích k této pozici:}
translate C OprepMoveOrdersAll \
  {Nalezeno %u posloupností tahù vedoucích k této pozici:}
translate C OprepMoveOrdersMany \
  {Nalezeno %u posloupností tahù vedoucích k této pozici. Prvních %u jsou:}
translate C OprepMovesFrom {Tahy z profilované pozice}
translate C OprepMostFrequentEcoCodes {Nejèastìj¹í ECO kódy}
translate C OprepThemes {Pozièní témata}
translate C OprepThemeDescription {Frekvence témat v prvních %u tazích ka¾dé partie}
translate C OprepThemeSameCastling {Ro¹ády na stejnou stranu}
translate C OprepThemeOppCastling {Ro¹ády na rùzné strany}
translate C OprepThemeNoCastling {Obì strany bez ro¹ády}
translate C OprepThemeKPawnStorm {Pì¹cový útok na královském køídle}
translate C OprepThemeQueenswap {Vymìnìné dámy}
translate C OprepThemeWIQP {Bílý izolovaný dámský pì¹ec}
translate C OprepThemeBIQP {Èerný izolovaný dámský pì¹ec}
translate C OprepThemeWP567 {Bílý pì¹ec na 5., 6. nebo 7. øadì}
translate C OprepThemeBP234 {Èerný pì¹ec na 2., 3. nebo 4. øadì}
translate C OprepThemeOpenCDE {Otevøený sloupec C, D nebo E}
translate C OprepTheme1BishopPair {Jedna strana má dvojici støelcù}
translate C OprepEndgames {Koncovky}
translate C OprepReportGames {Profilované partie}
translate C OprepAllGames {V¹echny partie}
translate C OprepEndClass {Materiálu na konci ka¾dé partie}
translate C OprepTheoryTable {Tabulka teorie}
translate C OprepTableComment {Generováno z %u partií s nejvy¹¹ím prùmìrným ratingem.}
translate C OprepExtraMoves {Extra poznámkové tahy v tabulce teorie}
translate C OprepMaxGames {Maximum tahù v tabulce teorie}
translate C OprepViewHTML {Zobrazit HTML}
translate C OprepViewLaTeX {Zobrazit LaTeX}

# Player Report:
translate C PReportTitle {Profil hráèe}
translate C PReportColorWhite {bílými figurami}
translate C PReportColorBlack {èernými figurami}
# ====== TODO To be translated ======
translate C PReportBeginning {Beginning with}
translate C PReportMoves {po %s}
translate C PReportOpenings {Zahájení}
translate C PReportClipbase {Vyprázdnit schránku a zkopírovat do ní odpovídající partie}

# Piece Tracker window:
translate C TrackerSelectSingle {Levým tlaèítkem my¹i se tato figura vybere.}
translate C TrackerSelectPair {Levým tlaèítkem se tato figura vybere; pravým se vyberou obì stejné figury.}
translate C TrackerSelectPawn {Levým tlaèítkem se vybere tento pì¹ec; pravým se vybere v¹ech 8 pì¹cù.}
translate C TrackerStat {Statistika}
translate C TrackerGames {% partií s tahem na pole}
translate C TrackerTime {% èasu na ka¾dém poli}
translate C TrackerMoves {Tahy}
translate C TrackerMovesStart {Vlo¾te èíslo tahu, kterým má stopování zaèít.}
translate C TrackerMovesStop {Vlo¾te èíslo tahu, kterým má stopování skonèit.}

# Game selection dialogs:
translate C SelectAllGames {V¹echny partie v databázi}
translate C SelectFilterGames {Jen filtrované partie}
translate C SelectTournamentGames {Jen partie z aktuálního turnaje}
translate C SelectOlderGames {Jen star¹í partie}

# Delete Twins window:
translate C TwinsNote {Aby byly dvì partie vyhodnoceny jako zdvojené, musí být hrány tými¾ dvìma hráèi a dále musí splòovat kritéria, která nastavíte ní¾e. Pokud jsou nalezeny zdvojené partie, pak je krat¹í z nich vymazána. Rada: je vhodné provést pøed vymazáním zdvojených partií kontrolu pravopisu, nebo» to zdokonalí detekci zdvojených partií.}
translate C TwinsCriteria {Kritéria: Zdvojené partie musí mít...}
translate C TwinsWhich {Jaké partie prozkoumat}
translate C TwinsColors {Tyté¾ barvy u hráèù?}
translate C TwinsEvent {Tentý¾ turnaj?}
translate C TwinsSite {Toté¾ místo?}
translate C TwinsRound {Toté¾ kolo?}
translate C TwinsYear {Tentý¾ rok?}
translate C TwinsMonth {Tentý¾ mìsíc?}
translate C TwinsDay {Tentý¾ den?}
translate C TwinsResult {Tentý¾ výsledek?}
translate C TwinsECO {Tentý¾ ECO kód?}
translate C TwinsMoves {Tyté¾ tahy?}
translate C TwinsPlayers {Porovnání jmen:}
translate C TwinsPlayersExact {Pøesná shoda}
translate C TwinsPlayersPrefix {Jen první 4 znaky}
translate C TwinsWhen {Pokud se budou mazat zdvojené partie}
translate C TwinsSkipShort {Ignorovat v¹echny partie krat¹í ne¾ 5 tahù?}
translate C TwinsUndelete {Obnovit nejprve v¹echny partie?}
translate C TwinsSetFilter {Nastavit filtr na v¹echny vymazané zdvojené partie?}
translate C TwinsComments {V¾dy zachovat partie s komentáøi?}
translate C TwinsVars {V¾dy zachovat partie s variantami?}
translate C TwinsDeleteWhich {Kterou partii vymazat:}
translate C TwinsDeleteShorter {Krat¹í partii}
translate C TwinsDeleteOlder {Partii s ni¾¹ím èíslem}
translate C TwinsDeleteNewer {Partii s vy¹¹ím èíslem}
translate C TwinsDelete {Vymazat partie}

# Name editor window:
translate C NameEditType {Typ jména pro editaci}
translate C NameEditSelect {Partie k editaci}
translate C NameEditReplace {Nahradit}
translate C NameEditWith {}
translate C NameEditMatches {Shoduje se: Stiskni Ctrl+1 a¾ Ctrl+9 pro výbìr}
# ====== TODO To be translated ======
translate C CheckGamesWhich {Check games}
# ====== TODO To be translated ======
translate C CheckAll {All games}
# ====== TODO To be translated ======
translate C CheckSelectFilterGames {Only games in filter}

# Classify window:
translate C Classify {Klasifikace}
translate C ClassifyWhich {ECO klasifikace kterých partií}
translate C ClassifyAll {V¹echny partie (pøepsat staré ECO kódy)}
translate C ClassifyYear {V¹echny partie hrané za poslední rok}
translate C ClassifyMonth {V¹echny partie hrané za poslední mìsíc}
translate C ClassifyNew {Jen partie, které jsou zatím bez ECO kódu}
translate C ClassifyCodes {Pou¾ít tyto ECO kódy}
translate C ClassifyBasic {Jen základní kódy ("B12", ...)}
translate C ClassifyExtended {Roz¹íøení Scidu  ("B12j", ...)}

# Compaction:
translate C NameFile {Jmenný soubor}
translate C GameFile {Partiový soubor}
translate C Names {Jména}
translate C Unused {Nepou¾ito}
translate C SizeKb {Velikost (kb)}
translate C CurrentState {Aktuální stav}
translate C AfterCompaction {Po kompaktování}
translate C CompactNames {Kompaktovat jmenný soubor}
translate C CompactGames {Kompaktovat partiový soubor}
# ====== TODO To be translated ======
translate C NoUnusedNames "There are no unused names, so the name file is already fully compacted."
# ====== TODO To be translated ======
translate C NoUnusedGames "The game file is already fully compacted."
# ====== TODO To be translated ======
translate C NameFileCompacted {The name file for "[file tail [sc_base filename]]" was compacted.}
# ====== TODO To be translated ======
translate C GameFileCompacted {The game file for "[file tail [sc_base filename]]" was compacted.}

# Sorting:
translate C SortCriteria {Kritéria}
translate C AddCriteria {Pøidat kritéria}
translate C CommonSorts {Bì¾ná øazení}
translate C Sort {Setøídit}

# Exporting:
translate C AddToExistingFile {Pøidat partie do existujícího souboru?}
translate C ExportComments {Exportovat komentáøe?}
translate C ExportVariations {Exportovat varianty?}
translate C IndentComments {Odsazovat komentáøe?}
translate C IndentVariations {Odsazovat varianty?}
translate C ExportColumnStyle {Sloupcový styl (jeden tah na øádek)?}
translate C ExportSymbolStyle {Styl pro symbolické anotace:}
translate C ExportStripMarks {Odstranit kódové znaèky polí/¹ipek z komentáøù?}

# Goto game/move dialogs:
translate C LoadGameNumber {Vlo¾te èíslo partie:}
translate C GotoMoveNumber {Pøejít na tah èíslo:}

# Copy games dialog:
translate C CopyGames {Kopírovat partie}
translate C CopyConfirm {
 Skuteènì chcete kopírovat
 [::utils::thousands $nGamesToCopy] filtrovaných partií
 z databáze "$fromName"
 do databáze "$targetName"?
}
translate C CopyErr {Nelze zkopírovat partie}
translate C CopyErrSource {zdrojová databáze}
translate C CopyErrTarget {cílová databáze}
translate C CopyErrNoGames {nemá ¾ádné partie ve filtru}
translate C CopyErrReadOnly {je pouze ke ètení}
translate C CopyErrNotOpen {není otevøena}

# Colors:
translate C LightSquares {Bílá pole}
translate C DarkSquares {Èerná pole}
translate C SelectedSquares {Vybraná pole}
translate C SuggestedSquares {Pole navrhovaných tahù}
# todo
translate C Grid {Grid}
translate C Previous {Pøedchozí}
translate C WhitePieces {Bílé figury}
translate C BlackPieces {Èerné figury}
translate C WhiteBorder {Obrys bílých figur}
translate C BlackBorder {Obrys èerných figur}
translate C ArrowMain   {Main Arrow}
translate C ArrowVar    {Var Arrows}

# Novelty window:
translate C FindNovelty {Hledat novinku}
translate C Novelty {Novinka}
translate C NoveltyInterrupt {Hledání novinky pøeru¹eno}
translate C NoveltyNone {V této partii nebyla nalezena ¾ádná novinka}
translate C NoveltyHelp {
Scid bude hledat první tah aktuální partie, který dosáhne pozice, která se nevyskytla ve vybrané databázi ani v knihovnì zahájení ECO.
}

# Sounds configuration:
translate C SoundsFolder {Sound Files Folder} ;# ***
translate C SoundsFolderHelp {The folder should contain the files King.wav, a.wav, 1.wav, etc} ;# ***
translate C SoundsAnnounceOptions {Move Announcement Options} ;# ***
translate C SoundsAnnounceNew {Announce new moves as they are made} ;# ***
translate C SoundsAnnounceForward {Announce moves when moving forward one move} ;# ***
translate C SoundsAnnounceBack {Announce when retracting or moving back one move} ;# ***

# Upgrading databases:
translate C Upgrading {Upgrade}
translate C ConfirmOpenNew {
Toto je starý formát (Scid 2) databáze, jen¾ není mo¾no otevøít ve Scidu 3. Verze s novým formátem (Scid 3) pøitom ji¾ byla vytvoøena.

Chcete otevøít verzi s novým formátem datábáze?
}
translate C ConfirmUpgrade {
Toto je starý formát (Scid 2) databáze. K otevøení ve Scidu 3 je nutno databázi nejprve zkonvertovat do nového formátu.

Upgrade vytvoøí novou verzi databáze; originální soubory se nebudou ani editovat, ani mazat.

Tento úkon mù¾e zabrat trochu èasu, ale je tøeba jej provést pouze jednou. Mù¾ete ho pøeru¹it, pokud bude trvat pøíli¹ dlouho.

Chcete tuto databázi upgradovat nyní?
}

# Recent files options:
translate C RecentFilesMenu {Poèet nedávných souborù v menu Soubor}
translate C RecentFilesExtra {Poèet nedávných souborù v extra podmenu}

# My Player Names options:
translate C MyPlayerNamesDescription {
Otevøe seznam se jmény preferovaných hráèù, ka¾dé jméno na jeden øádek. Zástupné znaky (tj. "?" pro jakýkoliv jeden znak, "*" pro jakoukoliv sekvenci znakù) jsou povoleny.

V¾dy, kdy¾ se natáhne partie hráèe uvedeného v seznamu, ¹achovnice v hlavním oknì se otoèí, jestli¾e je to nutné k zobrazení partie z perspektivy tohoto hráèe.
}
# ====== TODO To be translated ======
translate C showblunderexists {show blunder exists}
# ====== TODO To be translated ======
translate C showblundervalue {show blunder value}
# ====== TODO To be translated ======
translate C showscore {show score}
# ====== TODO To be translated ======
translate C coachgame {coach game}
# ====== TODO To be translated ======
translate C configurecoachgame {configure coach game}
# ====== TODO To be translated ======
translate C configuregame {Game configuration}
# ====== TODO To be translated ======
translate C Phalanxengine {Phalanx engine}
# ====== TODO To be translated ======
translate C Coachengine {Coach engine}
# ====== TODO To be translated ======
translate C difficulty {difficulty}
# ====== TODO To be translated ======
translate C hard {hard}
# ====== TODO To be translated ======
translate C easy {easy}
# ====== TODO To be translated ======
translate C Playwith {Play with}
# ====== TODO To be translated ======
translate C white {white}
# ====== TODO To be translated ======
translate C black {black}
# ====== TODO To be translated ======
translate C both {both}
# ====== TODO To be translated ======
translate C Play {Play}
# ====== TODO To be translated ======
translate C Noblunder {No blunder}
# ====== TODO To be translated ======
translate C blunder {blunder}
# ====== TODO To be translated ======
translate C Noinfo {-- No info --}
# ====== TODO To be translated ======
# ====== TODO To be translated ======
# ====== TODO To be translated ======
# ====== TODO To be translated ======
translate C moveblunderthreshold {move is a blunder if loss is greater than}
# ====== TODO To be translated ======
translate C limitanalysis {limit engine analysis time}
# ====== TODO To be translated ======
translate C seconds {seconds}
# ====== TODO To be translated ======
translate C Abort {Abort}
# ====== TODO To be translated ======
translate C Resume {Resume}
# ====== TODO To be translated ======
translate C Restart {Restart}
# ====== TODO To be translated ======
translate C OutOfOpening {Out of opening}
# ====== TODO To be translated ======
translate C NotFollowedLine {You did not follow the line}
# ====== TODO To be translated ======
translate C DoYouWantContinue {Do you want yo continue ?}
# ====== TODO To be translated ======
translate C CoachIsWatching {Coach is watching}
# ====== TODO To be translated ======
translate C Ponder {Permanent thinking}
# ====== TODO To be translated ======
translate C LimitELO {Limit ELO strength}
# ====== TODO To be translated ======
translate C DubiousMovePlayedTakeBack {Dubious move played, do you want to take back ?}
# ====== TODO To be translated ======
translate C WeakMovePlayedTakeBack {Weak move played, do you want to take back ?}
# ====== TODO To be translated ======
translate C BadMovePlayedTakeBack {Bad move played, do you want to take back ?}
# ====== TODO To be translated ======
translate C Iresign {I resign}
# ====== TODO To be translated ======
translate C yourmoveisnotgood {your move is not good}
# ====== TODO To be translated ======
translate C EndOfVar {End of variation}
# ====== TODO To be translated ======
translate C Openingtrainer {Opening trainer}
# ====== TODO To be translated ======
translate C DisplayCM {Display candidate moves}
# ====== TODO To be translated ======
translate C DisplayCMValue {Display candidate moves value}
# ====== TODO To be translated ======
translate C DisplayOpeningStats {Show statistics}
# ====== TODO To be translated ======
translate C ShowReport {Show report}
# ====== TODO To be translated ======
translate C NumberOfGoodMovesPlayed {good moves played}
# ====== TODO To be translated ======
translate C NumberOfDubiousMovesPlayed {dubious moves played}
# ====== TODO To be translated ======
translate C NumberOfTimesPositionEncountered {times position encountered}
# ====== TODO To be translated ======
translate C PlayerBestMove  {Allow only best moves}
# ====== TODO To be translated ======
translate C OpponentBestMove {Opponent plays best moves}
# ====== TODO To be translated ======
translate C OnlyFlaggedLines {Only flagged lines}
# ====== TODO To be translated ======
translate C resetStats {Reset statistics}
# ====== TODO To be translated ======
translate C Movesloaded {Moves loaded}
# ====== TODO To be translated ======
translate C PositionsNotPlayed {Positions not played}
# ====== TODO To be translated ======
translate C PositionsPlayed {Positions played}
# ====== TODO To be translated ======
translate C Success {Success}
# ====== TODO To be translated ======
translate C DubiousMoves {Dubious moves}
# ====== TODO To be translated ======
translate C ConfigureTactics {Configure tactics}
# ====== TODO To be translated ======
translate C ResetScores {Reset scores}
# ====== TODO To be translated ======
translate C LoadingBase {Loading base}
# ====== TODO To be translated ======
translate C Tactics {Tactics}
# ====== TODO To be translated ======
translate C ShowSolution {Show solution}
# ====== TODO To be translated ======
translate C Next {Next}
# ====== TODO To be translated ======
translate C ResettingScore {Resetting score}
# ====== TODO To be translated ======
translate C LoadingGame {Loading game}
# ====== TODO To be translated ======
translate C MateFound {Mate found}
# ====== TODO To be translated ======
translate C BestSolutionNotFound {Best solution NOT found !}
# ====== TODO To be translated ======
translate C MateNotFound {Mate not found}
# ====== TODO To be translated ======
translate C ShorterMateExists {Shorter mate exists}
# ====== TODO To be translated ======
translate C ScorePlayed {Score played}
# ====== TODO To be translated ======
translate C Expected {expected}
# ====== TODO To be translated ======
translate C ChooseTrainingBase {Choose training base}
# ====== TODO To be translated ======
translate C Thinking {Thinking}
# ====== TODO To be translated ======
translate C AnalyzeDone {Analyze done}
# ====== TODO To be translated ======
translate C WinWonGame {Win won game}
# ====== TODO To be translated ======
translate C Lines {Lines}
# ====== TODO To be translated ======
translate C ConfigureUCIengine {Configure UCI engine}
# ====== TODO To be translated ======
translate C SpecificOpening {Specific opening}
# ====== TODO To be translated ======
translate C StartNewGame {Start new game}
# ====== TODO To be translated ======
translate C FixedLevel {Fixed level}
# ====== TODO To be translated ======
translate C Opening {Opening}
# ====== TODO To be translated ======
translate C RandomLevel {Random level}
# ====== TODO To be translated ======
translate C StartFromCurrentPosition {Start from current position}
# ====== TODO To be translated ======
translate C FixedDepth {Fixed depth}
# ====== TODO To be translated ======
translate C Nodes {Nodes} 
# ====== TODO To be translated ======
translate C Depth {Depth}
# ====== TODO To be translated ======
translate C Time {Time} 
# ====== TODO To be translated ======
translate C SecondsPerMove {Seconds per move}
# ====== TODO To be translated ======
translate C DepthPerMove {Depth per move}
# ====== TODO To be translated ======
translate C MoveControl {Move Control}
# ====== TODO To be translated ======
translate C TimeLabel {Time per move}
# ====== TODO To be translated ======
translate C AddVars {Add Variations}
# ====== TODO To be translated ======
translate C AddScores {Add Score}
# ====== TODO To be translated ======
translate C Engine {Engine}
# ====== TODO To be translated ======
translate C TimeMode {Time mode}
# ====== TODO To be translated ======
translate C TimeBonus {Time + bonus}
# ====== TODO To be translated ======
# ====== TODO To be translated ======
translate C TimeMin {min}
# ====== TODO To be translated ======
translate C TimeSec {sec}
# ====== TODO To be translated ======
# ====== TODO To be translated ======
# ====== TODO To be translated ======
translate C AllExercisesDone {All exercises done}
# ====== TODO To be translated ======
translate C MoveOutOfBook {Move out of book}
# ====== TODO To be translated ======
translate C LastBookMove {Last book move}
# ====== TODO To be translated ======
translate C AnnotateSeveralGames {Annotate several games\nfrom current to :}
# ====== TODO To be translated ======
translate C FindOpeningErrors {Find opening errors}
# ====== TODO To be translated ======
translate C MarkTacticalExercises {Mark tactical exercises}
# ====== TODO To be translated ======
translate C UseBook {Use book}
# ====== TODO To be translated ======
translate C MultiPV {Multiple variations}
# ====== TODO To be translated ======
translate C Hash {Hash memory}
# ====== TODO To be translated ======
translate C OwnBook {Use engine book}
# ====== TODO To be translated ======
translate C BookFile {Opening book}
# ====== TODO To be translated ======
translate C AnnotateVariations {Annotate variations}
# ====== TODO To be translated ======
translate C ShortAnnotations {Short annotations}
# ====== TODO To be translated ======
translate C addAnnotatorTag {Add annotator tag}
# ====== TODO To be translated ======
translate C AddScoreToShortAnnotations {Add score to short annotations}
# ====== TODO To be translated ======
translate C Export {Export}
# ====== TODO To be translated ======
translate C BookPartiallyLoaded {Book partially loaded}
# ====== TODO To be translated ======
translate C AddLine {Add Line}
# ====== TODO To be translated ======
translate C RemLine {Remove Line}
# ====== TODO To be translated ======
translate C Calvar {Calculation of variations}
# ====== TODO To be translated ======
translate C ConfigureCalvar {Configuration}
# ====== TODO To be translated ======
# ====== TODO To be translated ======
translate C Reti {Reti}
# ====== TODO To be translated ======
translate C English {English}
# ====== TODO To be translated ======
translate C d4Nf6Miscellaneous {1.d4 Nf6 Miscellaneous}
# ====== TODO To be translated ======
translate C Trompowsky {Trompowsky}
# ====== TODO To be translated ======
translate C Budapest {Budapest}
# ====== TODO To be translated ======
translate C OldIndian {Old Indian}
# ====== TODO To be translated ======
translate C BenkoGambit {Benko Gambit}
# ====== TODO To be translated ======
translate C ModernBenoni {Modern Benoni}
# ====== TODO To be translated ======
translate C DutchDefence {Dutch Defence}
# ====== TODO To be translated ======
translate C Scandinavian {Scandinavian}
# ====== TODO To be translated ======
translate C AlekhineDefence {Alekhine Defence}
# ====== TODO To be translated ======
translate C Pirc {Pirc}
# ====== TODO To be translated ======
translate C CaroKann {Caro-Kann}
# ====== TODO To be translated ======
translate C CaroKannAdvance {Caro-Kann Advance}
# ====== TODO To be translated ======
translate C Sicilian {Sicilian}
# ====== TODO To be translated ======
translate C SicilianAlapin {Sicilian Alapin}
# ====== TODO To be translated ======
translate C SicilianClosed {Sicilian Closed}
# ====== TODO To be translated ======
translate C SicilianRauzer {Sicilian Rauzer}
# ====== TODO To be translated ======
translate C SicilianDragon {Sicilian Dragon}
# ====== TODO To be translated ======
translate C SicilianScheveningen {Sicilian Scheveningen}
# ====== TODO To be translated ======
translate C SicilianNajdorf {Sicilian Najdorf}
# ====== TODO To be translated ======
translate C OpenGame {Open Game}
# ====== TODO To be translated ======
translate C Vienna {Vienna}
# ====== TODO To be translated ======
translate C KingsGambit {King's Gambit}
# ====== TODO To be translated ======
translate C RussianGame {Russian Game}
# ====== TODO To be translated ======
translate C ItalianTwoKnights {Italian/Two Knights}
# ====== TODO To be translated ======
translate C Spanish {Spanish}
# ====== TODO To be translated ======
translate C SpanishExchange {Spanish Exchange}
# ====== TODO To be translated ======
translate C SpanishOpen {Spanish Open}
# ====== TODO To be translated ======
translate C SpanishClosed {Spanish Closed}
# ====== TODO To be translated ======
translate C FrenchDefence {French Defence}
# ====== TODO To be translated ======
translate C FrenchAdvance {French Advance}
# ====== TODO To be translated ======
translate C FrenchTarrasch {French Tarrasch}
# ====== TODO To be translated ======
translate C FrenchWinawer {French Winawer}
# ====== TODO To be translated ======
translate C FrenchExchange {French Exchange}
# ====== TODO To be translated ======
translate C QueensPawn {Queen's Pawn}
# ====== TODO To be translated ======
translate C Slav {Slav}
# ====== TODO To be translated ======
translate C QGA {QGA}
# ====== TODO To be translated ======
translate C QGD {QGD}
# ====== TODO To be translated ======
translate C QGDExchange {QGD Exchange}
# ====== TODO To be translated ======
translate C SemiSlav {Semi-Slav}
# ====== TODO To be translated ======
translate C QGDwithBg5 {QGD with Bg5}
# ====== TODO To be translated ======
translate C QGDOrthodox {QGD Orthodox}
# ====== TODO To be translated ======
translate C Grunfeld {Grünfeld}
# ====== TODO To be translated ======
translate C GrunfeldExchange {Grünfeld Exchange}
# ====== TODO To be translated ======
translate C GrunfeldRussian {Grünfeld Russian}
# ====== TODO To be translated ======
translate C Catalan {Catalan}
# ====== TODO To be translated ======
translate C CatalanOpen {Catalan Open}
# ====== TODO To be translated ======
translate C CatalanClosed {Catalan Closed}
# ====== TODO To be translated ======
translate C QueensIndian {Queen's Indian}
# ====== TODO To be translated ======
translate C NimzoIndian {Nimzo-Indian}
# ====== TODO To be translated ======
translate C NimzoIndianClassical {Nimzo-Indian Classical}
# ====== TODO To be translated ======
translate C NimzoIndianRubinstein {Nimzo-Indian Rubinstein}
# ====== TODO To be translated ======
translate C KingsIndian {King's Indian}
# ====== TODO To be translated ======
translate C KingsIndianSamisch {King's Indian Sämisch}
# ====== TODO To be translated ======
translate C KingsIndianMainLine {King's Indian Main Line}
# ====== TODO To be translated ======

translate C ConfigureFics {Konfigurovat FICS}
translate C FICSLogin {Pøihlásit}
translate C FICSGuest {Pøihlásit jako host}
translate C FICSServerPort {Port serveru}
translate C FICSServerAddress {IP adresa}
translate C FICSRefresh {Obnovit}
# TODO
translate C FICSTimeseal {Timeseal}
translate C FICSTimesealPort {Port timesealu}
translate C FICSSilence {Ticho}
translate C FICSOffers {Nabídky}
translate C FICSGames {Hry}
translate C FICSFindOpponent {Najít soupeøe}
translate C FICSTakeback {Vrátit tah}
translate C FICSTakeback2 {Vrátit tah 2}
translate C FICSInitTime {Poèáteèní èas (min)}
translate C FICSIncrement {Inkrement (s)}
translate C FICSRatedGame {Partie zapoèítaná do ratingu}
translate C FICSAutoColour {automatické}
translate C FICSManualConfirm {potvrdit ruènì}
translate C FICSFilterFormula {Filtrovat formulí}
# ====== TODO To be translated ======
translate C FICSIssueSeek {Issue seek}
# ====== TODO To be translated ======
translate C FICSAccept {accept}
# ====== TODO To be translated ======
translate C FICSDecline {decline}
translate C FICSColour {Barva}
# ====== TODO To be translated ======
translate C FICSSend {send}
translate C FICSConnect {Pøipojit}
# ====== TODO To be translated ======
translate C FICSShouts {Shouts}
# ====== TODO To be translated ======
translate C FICSTells {Tells}
# ====== TODO To be translated ======
translate C FICSOpponent {Opponent Info}
# ====== TODO To be translated ======
translate C FICSInfo {Info}
# ====== TODO To be translated ======
translate C FICSDraw {Offer Draw}
# ====== TODO To be translated ======
translate C FICSRematch {Rematch}
# ====== TODO To be translated ======
translate C FICSQuit {Quit FICS}
# ====== TODO To be translated ======
translate C FICSCensor {Censor}

translate C CCDlgConfigureWindowTitle {Konfigurovat korespondenèní ¹ach}
translate C CCDlgCGeneraloptions {Obecná nastavení}
translate C CCDlgDefaultDB {Výchozí databáze:}
translate C CCDlgInbox {Pøíchozí schránka (cesta):}
translate C CCDlgOutbox {Odchozí schránka (cesta):}
translate C CCDlgXfcc {Konfigurace Xfcc:}
translate C CCDlgExternalProtocol {Externí nástroj pro protokoly (napø. Xfcc)}
translate C CCDlgFetchTool {Stahovací nástroj:}
translate C CCDlgSendTool {Odesílací nástroj:}
translate C CCDlgEmailCommunication {E-mailová komunikace}
translate C CCDlgMailPrg {E-mailový program:}
translate C CCDlgBCCAddr {(B)CC adresa:}
translate C CCDlgMailerMode {Re¾im:}
translate C CCDlgThunderbirdEg {napø. Thunderbird, Mozilla Mail, Icedove...}
translate C CCDlgMailUrlEg {napø. Evolution}
translate C CCDlgClawsEg {napø. Sylpheed Claws}
translate C CCDlgmailxEg {napø. mailx, mutt, nail...}
translate C CCDlgAttachementPar {Parametr pøílohy:}
translate C CCDlgInternalXfcc {Pou¾ít vystavìnou podporu Xfcc}
translate C CCDlgConfirmXfcc {Potvrdit tahy}
translate C CCDlgSubjectPar {Pøedmìt:}
translate C CCDlgDeleteBoxes {Prázdná pøíchozí/odchozí schránka}
translate C CCDlgDeleteBoxesText {Opravdu chcete vyprázdnit pøíchozí a odchozí schránky pro korespondeèní ¹ach? To vy¾aduje novou synchronizaci, aby mohl být zobrazen poslední stav va¹ich partií.}
translate C CCDlgConfirmMove {Potvrdit tah}
translate C CCDlgConfirmMoveText {Pokud potvrdíte, následující tah a komentáø bude zaslán na server:}
translate C CCDlgDBGameToLong {Nekonzistentní hlavní varianta}
translate C CCDlgDBGameToLongError {Hlavní varianta v databázi je del¹í ne¾ partie v pøíchozí schránce. Jestli¾e pøíchozí schránka obsahuje aktuální partie, tj. èerstvì po synchronizaci, nìkteré tahy byly do hlavní varianty v databázi pøidány chybnì.\nV takovém pøípadì prosím zkra»te hlavní variantu do (max.) tahu\n}
translate C CCDlgStartEmail {Zaèít novou e-mailovou partii}
translate C CCDlgYourName {Va¹e jména:}
translate C CCDlgYourMail {Va¹e e-mailová adresa:}
translate C CCDlgOpponentName {Jméno soupeøe:}
translate C CCDlgOpponentMail {E-mailová adresa soupeøe:}
translate C CCDlgGameID {Identifikátor partie (jednoznaèný):}
translate C CCDlgTitNoOutbox {Scid: Odchozí schránka korespondenèního ¹achu}
translate C CCDlgTitNoInbox {Scid: Pøíchozí schránka korespondenèního ¹achu}
translate C CCDlgTitNoGames {Scid: ®ádné korespondenèní partie}
translate C CCErrInboxDir {Adresáø pøíchozí schránky korespondenèního ¹achu:}
translate C CCErrOutboxDir {Adresáø odchozí schránky korespondenèního ¹achu:}
translate C CCErrDirNotUsable {neexistuje nebo není pøístupná!\nProsím zkontrolujte a opravte nastavení.}
translate C CCErrNoGames {neobsahuje ¾ádné partie!\nNejprve je prosím stáhnìte.}
translate C CCDlgTitNoCCDB {Scid: ®ádná korespondenèní databáze.}
translate C CCErrNoCCDB {®ádná korespondenèní databáze není otevøena. Prosím otevøete nìjakou ne¾ budete pou¾ívat funkce korespondenèního ¹achu.}
translate C CCFetchBtn {Stáhnout partie ze serveru a zpracovat pøíchozí schránku}
translate C CCPrevBtn {Jít na pøedchozí partii}
translate C CCNextBtn {Jít na následující partii}
translate C CCSendBtn {Poslat tah}
translate C CCEmptyBtn {Vyprázdnit pøíchozí a odchozí schránku}
translate C CCHelpBtn {Nápovìda k ikonám a stavovým indikátorùm.\nPro obecnou nápovìdu stisknìte F1!}
translate C CCDlgServerName {Jméno serveru:}
translate C CCDlgLoginName  {Pøihla¹ovací jméno:}
translate C CCDlgPassword   {Heslo:}
translate C CCDlgURL        {URL Xfcc:}
translate C CCDlgRatingType {Typ ratingu:}
translate C CCDlgDuplicateGame {Nejednoznaèný identifikátor partie}
translate C CCDlgDuplicateGameError {Tato partie se v databázi vyskytuje více ne¾ jednou. Prosím sma¾te v¹echny duplikáty a soubor partií zhutnìte (Soubor/Údr¾ba/Zhutnit databázi).}
translate C CCDlgSortOption {Tøídìní:}
# ====== TODO To be translated ======
translate C CCDlgListOnlyOwnMove {Only games I have the move}
translate C CCOrderClassicTxt {Místo, událost, kolo, výsledek, bílý, èerný}
translate C CCOrderMyTimeTxt {Mé hodiny}
translate C CCOrderTimePerMoveTxt {Èas na ka¾dý tah do pøí¹tí èasové kontroly}
translate C CCOrderStartDate {Poèáteèní datum}
translate C CCOrderOppTimeTxt {Soupeøovy hodiny}
translate C CCDlgConfigRelay {Konfigurovat sledování ICCF}
translate C CCDlgConfigRelayHelp {Bì¾te na stránku partií na http://www.iccf-webchess.com a zobrazte partii, která má být sledována. Pokud vidíte ¹achovnici, zkopírujte URL z prohlí¾eèe do seznamu ní¾e. Pouze jediné URL na ka¾dém øádku!\nPøíklad: http://www.iccf-webchess.com/MakeAMove.aspx?id=266452}

# ====== TODO To be translated ======
translate C ExtHWConfigConnection {Configure external hardware}
# ====== TODO To be translated ======
translate C ExtHWPort {Port}
# ====== TODO To be translated ======
translate C ExtHWEngineCmd {Engine command}
# ====== TODO To be translated ======
translate C ExtHWEngineParam {Engine parameter}
# ====== TODO To be translated ======
translate C ExtHWShowButton {Show button}
# ====== TODO To be translated ======
translate C ExtHWHardware {Hardware}
# ====== TODO To be translated ======
translate C ExtHWNovag {Novag Citrine}
# ====== TODO To be translated ======
translate C ExtHWInputEngine {Input Engine}
# ====== TODO To be translated ======
translate C ExtHWNoBoard {No board}
# ====== TODO To be translated ======
translate C IEConsole {Input Engine Console}
# ====== TODO To be translated ======
translate C IESending {Moves sent for}
# ====== TODO To be translated ======
translate C IESynchronise {Synchronise}
# ====== TODO To be translated ======
translate C IERotate  {Rotate}
# ====== TODO To be translated ======
translate C IEUnableToStart {Unable to start Input Engine:}
# ====== TODO To be translated ======
translate C DoneWithPosition {Done with position}
translate C Board {©achovnice}
translate C showGameInfo {Ukázat informace o partii}
translate C autoResizeBoard {Automatická zmìna velikosti ¹achovnice}
translate C DockTop {Pøesunout nahoru}
translate C DockBottom {Pøesunout dolù}
translate C DockLeft {Pøesunout doleva}
translate C DockRight {Pøesunout doprava}
# ====== TODO To be translated ======
translate C Undock {Undock}
translate C ChangeIcon {Zmìnit ikonu}
# ====== TODO To be translated ======
translate C More {More}

# Drag & Drop
# ====== TODO To be translated ======
translate C CannotOpenUri {Cannot open the following URI:}
# ====== TODO To be translated ======
translate C InvalidUri {Drop content is not a valid URI list.}
# ====== TODO To be translated ======
translate C UriRejected	{The following files are rejected:}
# ====== TODO To be translated ======
translate C UriRejectedDetail {Only the listed file types can be handled:}
# ====== TODO To be translated ======
translate C EmptyUriList {Drop content is empty.}
# ====== TODO To be translated ======
translate C SelectionOwnerDidntRespond {Timeout during drop action: selection owner didn't respond.}

}

### Czech help pages: removed because they are too old :( S.A.

# end of czech.tcl
