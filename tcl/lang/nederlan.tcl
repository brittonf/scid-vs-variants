#  nederlan.tcl:
#  Dutch language support for ScidvsPC.
#  Added by J.Kees Hofkamp.
#  Changes by J. Krabbenbos.
#  Changes by Leander Laruelle.
#  Changes by Peter C. Tak (juni 2013 // 4.9.2 - 28 augustus 2013 // 4.10)
# Untranslated messages are marked with a TODO comment.


addLanguage N Nederlands 0 ;#iso8859-1

proc setLanguage_N {} {

# File menu:
menuText N File "Bestand" 0
menuText N FileNew "Nieuw..." 0 {Maak een nieuwe ScidvsPC database}
menuText N FileOpen "Openen..." 0 {Open een bestaande ScidvsPC database}
menuText N FileClose "Sluiten" 0 {Sluit de actieve ScidvsPC database}
menuText N FileFinder "Bestandzoeker" 0 {Open het bestandszoekvenster}
menuText N FileSavePgn "PGN opslaan..." 0 {Deze partij als PGN-bestand opslaan}
menuText N FileOpenBaseAsTree "Open database als boom" 5  {Open een database en toon deze als een boomweergave}
menuText N FileOpenRecentBaseAsTree "Open recente database als boom" 5  {Open een recent gebruikte database als boomweergave}
menuText N FileBookmarks "Bladwijzers" 2 {Bladwijzer menu (sneltoets: Ctrl+B)}
menuText N FileBookmarksAdd "Toevoegen bladwijzer" 0 \
  {Bladwijzer naar huidige databasepartij en stelling}
menuText N FileBookmarksFile "Bladwijzer-bestand" 0 \
  {Maak een bladwijzerbestand voor de huidige partij en stelling}
menuText N FileBookmarksEdit "Wijzigen bladwijzers..." 0 \
  {Bladwijzermenu's}
menuText N FileBookmarksList "Weergeven bladwijzers als lijst" 0 \
  {Weergeven bladwijzers als lijst, niet als submenu's}
menuText N FileBookmarksSub "Weergeven bladwijzers als submenu's" 0 \
  {Weergeven bladwijzers als submenu's, niet als lijst}
menuText N FileReadOnly "Alleen lezen..." 7 \
  {Zet huidige database op alleen-lezen en voorkom wijzigingen}
menuText N FileSwitch "Schakel naar andere database" 1 \
  {Schakel naar een andere geopende database} 
menuText N FileExit "Programma afsluiten" 3 {Einde ScidvsPC programma}

# Edit menu:
menuText N Edit "Bewerken" 2
menuText N EditAdd "Nieuwe variant" 4 \
 {Voeg op dit punt een variant toe}
menuText N EditPasteVar "Plakken variant" 1
menuText N EditDelete "Verwijderen variant" 6 \
 {Verwijder een variant voor deze zet}
menuText N EditFirst "Maak hoofdvariant" 5 \
  {Maak deze variant de eerste in de lijst}
menuText N EditMain "Variant op hoofdvariant" 1 \
   {Promoveert de variant tot hoofdvariant}
menuText N EditTrial "Variant uitproberen" 14 \
  {Start/stop probeermodus, om een idee/variant op het bord te testen}
menuText N EditStrip "Verwijder analyse" 1 {Verwijder commentaar of varianten uit deze partij}
menuText N EditUndo "Ongedaan" 0 {Maak laatste verandering ongedaan}
menuText N EditRedo "Opnieuw" 5
menuText N EditStripComments "- commentaar" 0 \
  {Verwijder alle commentaar en annotaties uit deze partij}
menuText N EditStripVars "- varianten" 0 {Verwijder alle varianten uit deze partij}
menuText N EditStripBegin "- zetten vanaf begin" 1 \
  {Verwijder alle zetten vanaf begin van de partij}
menuText N EditStripEnd "- zetten tot het einde" 0 \
  {Verwijder alle volgende zetten tot het einde van de partij}
menuText N EditReset "Clipbase leegmaken" 0  {Maak Clipbase helemaal leeg}
menuText N EditCopy "Partij naar Clipbase" 7  {Kopieer deze partij naar het Clipbase}
menuText N EditPaste "Partij vanuit Clipbase" 7  {Plak actieve Clipbase-partij hier}
menuText N EditPastePGN "Plak de klembord-tekst als PGN partij..." 0 \
  {Interpreteer de klembord-tekst als een partij in PGN notatie en plak die hier}
menuText N EditSetup "Stelling opzetten..." 0 \
  {Kies een start-stelling voor de partij}
menuText N EditCopyBoard "Kopieer stelling " 0 \
  {Kopieer de huidige stelling in FEN notatie naar het geheugen (klembord)}
menuText N EditCopyPGN "Kopieer PGN " 9 {Kopieer de PGN naar het geheugen (klembord)}
menuText N EditPasteBoard "Invoegen start stelling" 0 \
  {Creëer een beginstelling van de huidige tekst selectie (van klembord)}

# Game menu:
menuText N Game "Partij" 0
menuText N GameNew "Partij leegmaken" 7 \
  {Maak partij leeg; sla veranderingen niet op}
menuText N GameFirst "Eerste partij laden" 0 {Laad de eerste gefilterde partij}
menuText N GamePrev "Vorige partij laden" 2 \
  {Laad vorige partij in het filter}
menuText N GameReload "Partij opnieuw laden" 1 \
  {Laad partij opnieuw; sla veranderingen niet op}
menuText N GameNext "Volgende partij laden" 3 \
  {Laad volgende partij in het filter}
menuText N GameLast "Laatste partij laden" 4 {Laad de laatste gefilterde partij}
menuText N GameRandom "Laad willekeurige partij" 5 {Laad een willekeurige partij}
menuText N GameNumber "Laad partijnummer..." 12 \
  {Laad partijnummer:}
menuText N GameReplace "Partij overschrijven..." 7 \
  {Bewaar partij; overschrijf de oude versie}
menuText N GameAdd "Partij toevoegen..." 7 \
  {Bewaar partij en voeg toe aan de database}
menuText N GameInfo "Partij informatie invoeren" 0
menuText N GameBrowse "Door de partijen bladeren" 0
menuText N GameList "Toon de partijenlijst" 0
menuText N GameDelete "Delete Game" 0
menuText N GameDeepest "Opening bepalen" 0 \
  {Ga naar de diepste stelling uit het ECO openingboek}
menuText N GameGotoMove "Zetnummer..." 0 \
  {Ga naar zetnummer .. in de partij}
menuText N GameNovelty "Vind nieuwtje..." 0 \
  {Vind de eerste zet in deze partij die nog niet eerder is gespeeld}

# Search menu:
menuText N Search "Zoeken" 0
menuText N SearchReset "Alle partijen" 0 \
  {Reset filter en toon alle partijen}
menuText N SearchNegate "Selectie omdraaien" 9 {Draai filter om en toon de andere partijen uit de database}
menuText N SearchEnd "Ga naar laatste filter" 0
menuText N SearchCurrent "Zoek huidige stelling" 5 \
  {Zoek in database naar huidige stelling}
menuText N SearchHeader "Partijgegevens..." 0 \
  {Zoek op speciale informatie: speler, evenement enz.}
menuText N SearchMaterial "Materiaal/Kenmerken..." 0 \
  {Zoek op patroon: bord, materiaal enz.}
menuText N SearchMoves {Zetten} 1 {}
menuText N SearchUsing "Zoekopties" 3 \
  {Zoek met gebruikmaking van opgeslagen opties}

# Windows menu:
menuText N Windows "Venster" 0
menuText N WindowsGameinfo "Partij informatie" 0 {Toon de informatiedetails over de partij}
menuText N WindowsComment "Bewerk commentaar" 0 \
 {Open/sluit commentaar bewerkingsvenster}
menuText N WindowsGList "Toon de partijenlijst" 0 \
  {Open/sluit lijst met partijen}
menuText N WindowsPGN "PGN-venster" 4 {Open/sluit het PGN-notatie venster}
menuText N WindowsCross "Kruistabel" 0 {Toon toernooi kruistabel voor huidige partij}
menuText N WindowsPList "Speler zoeker" 0 {Open/sluit venster om spelers te zoeken}
menuText N WindowsTmt "Toernooi zoeker" 9 {Open/sluit het toernooi zoekvenster}
menuText N WindowsSwitcher  "Database wisselen" 0 \
  {Open/sluit het database-wisselen venster}
menuText N WindowsMaint "Onderhoudsvenster" 0 \
  {Open/sluit het onderhoudsvenster}
menuText N WindowsECO "ECO Browser" 0 {Open/sluit het ECO browser venster}
menuText N WindowsStats "Statistiek" 4 \
  {Open/sluit het filter statiekenvenster}
menuText N WindowsTree "Openingoverzicht" 3 {Open/sluit het Openingoverzichtvenster}
menuText N WindowsTB "Tablebase venster" 1 \
  {Open/sluit het Tablebase venster}
menuText N WindowsBook "Boek venster" 0 {Open/sluit het boek venster}
menuText N WindowsCorrChess "Correspondentievenster" 0 {Openen/Sluiten van het correspondentievenster}

# Tools menu:
menuText N Tools "Gereedschappen" 0
menuText N ToolsAnalysis "Schaakengine ..." 0 \
  {Start/stop schaak-analyse engine 1}
menuText N ToolsEmail "E-mail beheer" 0 {Open/sluit het e-mail beheervenster}
menuText N ToolsFilterGraph "Grafisch filter" 0 \
  {Openen/sluiten grafisch filter venster}
menuText N ToolsAbsFilterGraph "Abs. grafisch filter" 0 {Open/sluit het grafische filtervenster voor absolute waarden}
menuText N ToolsOpReport "Openingen rapportering" 3 \
  {Genereer een openingenrapport voor de huidige stelling}
menuText N ToolsTracker "Stuk spoorvolger" 1 {Open het stuk spoorvolger venster}
menuText N ToolsTraining "Training" 1 {Training gereedschappen (tactiek, openingen,...) }
menuText N ToolsComp "Toernooi" 1 {Schaak-engine toernooi}
menuText N ToolsTacticalGame "Tactische partij"  0 {Speel en tactische partij}
menuText N ToolsSeriousGame "Serieuze partij"  0 {Speel een serieuze partij}
menuText N ToolsTrainTactics "Tactiek " 1 {Los tactische stellingen op }
menuText N ToolsTrainCalvar "Bereken varianten"  0 {Training in het berekenen van varianten}
menuText N ToolsTrainFindBestMove "Vind de beste zet"  0 {Vind de beste zet}
menuText N ToolsTrainFics "Internet"  0 {Spelen op FICS - freechess.org}
menuText N ToolsBookTuning "Openingenboek afstemmen" 0 {Openingenboek afstemmen}
menuText N ToolsMaint "Onderhoud" 3 {Onderhoud ScidvsPC database}
menuText N ToolsMaintWin "Onderhoudsvenster" 2 \
  {Open/sluit het ScidvsPC onderhoudsvenster}
menuText N ToolsMaintCompact "Reorganiseer database..." 0 \
  {Reorganiseer database bestanden}
menuText N ToolsMaintClass "Partijen ECO-classificeren..." 10 \
  {Herbereken de ECO code van alle partijen}
menuText N ToolsMaintSort "Sorteren..." 0 \
  {Sorteer alle partijen in de database}
menuText N ToolsMaintDelete "Dubbele partijen verwijderen..." 0 \
  {Vind dubbele partijen om ze te verwijderen}
menuText N ToolsMaintTwin "Dubbele partijenvenster" 1 \
  {Open/bijwerken het dubbele partijen controlevenster}
menuText N ToolsMaintNameEditor "Namen-bewerker" 6 \
  {Open/sluit het namen correctievenster}
menuText N ToolsMaintNamePlayer "Corrigeer naam speler..." 15 \
  {Controleer spelling namen via het spelling-bestand}
menuText N ToolsMaintNameEvent "Corrigeer naam evenement..." 15 \
  {Controleer spelling evenementen via spelling-bestand}
menuText N ToolsMaintNameSite "Corrigeer naam plaats..." 15 \
  {Controleer plaatsnamen via spelling-bestand}
menuText N ToolsMaintNameRound "Corrigeer ronde..." 10 \
  {Controleer rondenamen via spelling-bestand}
menuText N ToolsMaintFixBase "Herstel beschadigde database" 0 {Proberen een beschadigde database te herstellen}
menuText N ToolsConnectHardware "Verbind hardware" 0 {Externe hardware verbinden cq aansluiten}
menuText N ToolsConnectHardwareConfigure "Configureer..." 0 {Configureer externe hardware en verbinding}
menuText N ToolsConnectHardwareNovagCitrineConnect "Verbind Novag Citrine" 0 {Verbind Novag Citrine met ScidvsPC}
menuText N ToolsConnectHardwareInputEngineConnect "Invoer Engine aansluiten" 0 {Invoer Engine aansluiten(e.g. DGT)}
menuText N ToolsNovagCitrine "Novag Citrine" 0 {Novag Citrine}
menuText N ToolsNovagCitrineConfig "Configuratie" 0 {Novag Citrine configuratie}
menuText N ToolsNovagCitrineConnect "Aansluiten" 0 {Novag Citrine aansluiten}
menuText N ToolsPInfo "Spelerinformatie"  6 \
  {Open/wijzig het spelerinformatievenster}
menuText N ToolsPlayerReport "Speler rapport " 7 \
  {Genereer een speler rapport}
menuText N ToolsRating "Spelers Elo-rating" 3 \
  {Grafiek met Elo ratingoverzicht van de spelers van deze partij}
menuText N ToolsScore "Partij score" 0 \
  {Laat het partij-score venster zien}
menuText N ToolsExpCurrent "Partij exporteren" 8 \
  {Exporteer huidige partij naar een bestand}
menuText N ToolsExpCurrentPGN "Partij in PGN-formaat exporteren..." 11 \
  {Schrijf huidige partij naar PGN-bestand}
menuText N ToolsExpCurrentHTML "Partij in HTML-formaat exporteren..." 11 \
  {Schrijf huidige partij naar HTML-bestand}
menuText N ToolsExpCurrentHTMLJS "Exporteer partij als HTML/JavaScript bestand..." 15 {De huidige partij opslaan als een HTML/JavaScript bestand}  
menuText N ToolsExpCurrentLaTeX "Partij in LaTeX-formaat exporteren..." 11 \
  {Schrijf huidige partij naar LaTex-bestand}
# ====== TODO To be translated ======
menuText N ToolsExpFilter "Alle partijen in filter exporteren" 17 \
  {Exporteer alle geslecteerde partijen naar een bestand}
menuText N ToolsExpFilterPGN "Filter in PGN-formaat exporteren..." 10 \
  {Schrijf selectie naar PGN-bestand}
menuText N ToolsExpFilterHTML "Filter in HTML-formaat exporteren..." 10 \
  {Schrijf selectie naar HTML-bestand}
menuText N ToolsExpFilterHTMLJS "Exporteer filter naar HTML/Javascript bestand..." 17 {Schrijf alle via filter geselecteerde partijen naar een HTML/Javascript bestand}
menuText N ToolsExpFilterLaTeX "Filter in LaTeX-formaat exporteren..." 10 \
  {Schrijf selectie naar LaTex-bestand}
# ====== TODO To be translated ======
# ====== TODO To be translated ======
menuText N ToolsExpFilterGames "Export Gamelist to Text" 19 {Print a formatted Gamelist.}
menuText N ToolsImportOne "Een PGN partij importeren..." 16 \
  {Importeer PGN partij}
menuText N ToolsImportFile "PGN database importeren..." 4 \
  {Importeer PGN bestand}
menuText N ToolsStartEngine1 "Start engine 1" 13  {Start engine 1}
menuText N ToolsStartEngine2 "Start engine 2" 13  {Start engine 2}
menuText N ToolsScreenshot "Kopieer diagram" 0

menuText N Play "Speel" 0
menuText N CorrespondenceChess "Correspondentieschaak" 0 {Functies voor e-mail en Xfcc gebaseerde correspondentieschaak}
menuText N CCConfigure "Configureer..." 0 {Configureer externe gereedschappen en algemene instellingen}
menuText N CCConfigRelay "Bekijk partijen..." 10 {Configureer partijen die je wilt bekijken}
menuText N CCOpenDB "Open database..." 0 {Open de standaard correspondentieschaak database}
menuText N CCRetrieve "Haal partijen op" 0 {Haal partijen op via externe (Xfcc-)helper}
menuText N CCInbox "Verwerk inbox" 0 {Verwerk alle bestanden in ScidvsPC inbox}
menuText N CCSend "Stuur de zet op" 0 {Stuur de zet op via e-mail of de externe (Xfcc-)helper}
menuText N CCResign "Geef op" 0 {Geef op (niet via e-mail)}
menuText N CCClaimDraw "Eis remise" 0 {Stuur de zet op en eis remise (niet via e-mail)}
menuText N CCOfferDraw "Stel remise voor" 0 {Stuur de zet op en stel remise voor (niet via e-mail)}
menuText N CCAcceptDraw "Accepteer remise" 0 {Accepteer een remise voorstel (niet via e-mail)}
menuText N CCNewMailGame "Nieuwe e-mail partij..." 0 {Start een nieuwe e-mail partij}
menuText N CCMailMove "Stuur de zet op..." 0 {Stuur de zet op naar de tegenspeler via e-mail}
menuText N CCGamePage "Partij pagina..." 0 {Roep de partij op met een web browser}
menuText N CCEditCopy "Kopieer de partijlijst naar het Clipbase" 0 {Kopieer de partijen als CSV-lijst naar het Clipbase}


# Options menu:
menuText N Options "Opties" 0
menuText N OptionsBoard "Bord" 0 {Opties  Uitzicht Schaakbord} ;
menuText N OptionsColour "Achtergrondkleur" 0 {Standaard widget tekstkleur}
# ====== TODO To be translated ======
menuText N OptionsBackColour "Background" 0 {Default text widget color}
# ====== TODO To be translated ======
menuText N OptionsEnableColour "Enable" 0 {}
# ====== TODO To be translated ======
menuText N OptionsMainLineColour "Mainline Arrows" 0 {Mainline arrows}
# ====== TODO To be translated ======
menuText N OptionsVarLineColour "Variation Arrows" 0 {Variation arrows}
# ====== TODO To be translated ======
menuText N OptionsRowColour "Rows" 0 {Default tree/book row color}
# ====== TODO To be translated ======
menuText N OptionsSwitcherColour "Switcher" 0 {Default db switcher color}
# ====== TODO To be translated ======
menuText N OptionsProgressColour "Progressbar" 0 {Default progressbar color}
# ====== TODO To be translated ======
menuText N OptionsCrossColour "Crosstable rows" 0 {Default crosstable row color}
menuText N OptionsNames "Mijn spelersnamen ..." 0 {Bewerk mijn spelersnamen} ;
menuText N OptionsExport "Export" 1 {Wijzig tekst export opties}
menuText N OptionsFonts "Lettertypes" 0 {Wijzig lettertype}
menuText N OptionsFontsRegular "Standaard" 0 {Wijzig het standaard lettertype}
menuText N OptionsFontsMenu "Menu" 0 {Wijzig het menu lettertype}
menuText N OptionsFontsSmall "Klein" 0 {Wijzig het kleine lettertype}
menuText N OptionsFontsFixed "Vaste grootte" 0 {Wijzig dit lettertype}
menuText N OptionsGInfo "Partij informatie" 0 {Partij-informatie opties}
menuText N OptionsFics "FICS" 0
menuText N OptionsFicsAuto "Autopromotie koningin" 0
menuText N OptionsFicsColour "Tekst kleur" 0
# ====== TODO To be translated ======
menuText N OptionsFicsSize "Board Size" 0
# ====== TODO To be translated ======
menuText N OptionsFicsButtons "User Buttons" 0
# ====== TODO To be translated ======
menuText N OptionsFicsCommands "Init Commands" 0
menuText N OptionsFicsNoRes "Geen uitslagen" 0
menuText N OptionsFicsNoReq "Geen verzoeken" 0
# ====== TODO To be translated ======
menuText N OptionsFicsPremove "Allow Premove" 0
menuText N OptionsLanguage "Kies taal" 0 {Kies taal}
menuText N OptionsMovesTranslatePieces "Stukken vertalen" 0 {Vertalen eerste letters van de stukken}
menuText N OptionsMovesHighlightLastMove "Markeren laatste zet" 0 {De laatst gespeelde zet markeren}
menuText N OptionsMovesHighlightLastMoveDisplay "Tonen" 0 {Tonen laatste zet markering}
menuText N OptionsMovesHighlightLastMoveWidth "Dikte" 0 {Dikte van de lijn}
menuText N OptionsMovesHighlightLastMoveColor "Kleur" 0 {Kleur van de lijn}
menuText N OptionsMoves "Zetten" 0 {Wijzig optie voor zet-invoer}
menuText N OptionsMovesAsk "Bevestiging voor overschrijven" 0 \
  {Bevestig het overschrijven van bestaande zetten}
menuText N OptionsMovesAnimate "Stuk animatietijd " 1 \
  {Zet animatietijd van de stukkenbewegingen} ;
menuText N OptionsMovesDelay "Tijdinstelling voor auto-spelen" 10 \
  {Stel de tijd in voor het automatisch spelen van de zetten}
menuText N OptionsMovesCoord "Zet-ingave" 0 \
  {Accepteer de volgende manier van zetten invoeren ("g1f3")}
menuText N OptionsMovesSuggest "Toon hint" 0 \
  {Schakel hints aan of uit}
menuText N OptionsShowVarPopup "Toon variantenvenster" 0 {In-/Uitschakelen weergeven van het variantenvenster} 
menuText N OptionsMovesSpace "Spaties zetten achter zetnummer" 0 {Zet spaties na het zetnummer}  
menuText N OptionsMovesKey "Auto-aanvullen" 0 \
  {Aan/uitschakelen van toetsenbordzet auto-aanvullen}
menuText N OptionsMovesShowVarArrows "Toon pijlen voor varianten" 0 {Aan-/Uitzetten weergave pijlen van varianten}
menuText N OptionsNumbers "Getalformaat" 5 \
  {Kies de manier waarop getallen te zien zijn}
menuText N OptionsStartup "Opstarten" 0 {Selecteer de vensters die tijdens starten geopend worden}
menuText N OptionsTheme "Thema" 0 {Verander het uitzicht van de interface}
menuText N OptionsWindows "Vensters" 0 {Venster opties}
menuText N OptionsWindowsIconify "Auto-icon" 5 \
  {Toon alle vensters in iconvorm wanneer het hoofdvenster wordt geminimaliseerd.}
menuText N OptionsWindowsRaise "Auto-voorgrond" 0 \
  {Breng vensters terug naar de voorgrond (bvb. voortgangsbalken) wanneer ze onzichtbaar zijn.}
menuText N OptionsSounds "Geluiden ..." 4 {Configureer zet aankondigingsgeluiden} ;
menuText N OptionsWindowsDock "Veranker de vensters" 0 {Veranker de vensters}
menuText N OptionsWindowsSaveLayout "Opmaak opslaan" 0 {Opmaak opslaan}
menuText N OptionsWindowsRestoreLayout "Opmaak herstellen" 0 {Opmaak herstellen}
menuText N OptionsWindowsShowGameInfo "Toon de informatie over de partij" 0 {Toon de informatie over de partij}
menuText N OptionsWindowsAutoLoadLayout "Auto laad eerste lay-out" 0 {Automatisch laden eerste lay-out bij opstarten}
menuText N OptionsWindowsAutoResize "Bordgrootte automatisch aanpassen" 0 {}
# ====== TODO To be translated ======
menuText N OptionsWindowsFullScreen "Fullscreen" 0 {Toggle fullscreen mode}
menuText N OptionsToolbar "Gereedschappenbalk" 0 \
  {Weergeven/verbergen hoofdvenster gereedschappenbalk}
menuText N OptionsECO "ECO data laden..." 1 \
  {Laad het ECO classificatie bestand}
menuText N OptionsSpell "Laad spelling (namen)..." 5 \
  {Laad het ScidvsPC spelling-bestand}
menuText N OptionsTable "Eindspeldatabase laden..." 0 \
  {Kies een eindspeldatabase, alle in de map aanwezige bestanden worden gebruikt}
menuText N OptionsRecent "Recente bestanden..." 0 \
  {Wijzig het aantal recent gebruikte bestanden in het Bestand menu}
menuText N OptionsBooksDir "Openingboek map..." 3 {Map met openingsboeken instellen}
menuText N OptionsTacticsBasesDir "Databases map..." 0 {Map met de tactieken (training) databases instellen}
menuText N OptionsSave "Opties bewaren" 9 \
  "Bewaar alle instellingen in het bestand $::optionsFile"
menuText N OptionsAutoSave "Automatisch bewaren opties tijdens afsluiten" 1 \
  {Automatisch bewaren alle gewijzigde opties bij het afsluiten van ScidvsPC}

# Help menu:
menuText N Help "Help" 0
menuText N HelpContents "Inhoud" 0 {Toon de help inhoudspagina} ;
menuText N HelpIndex "Index" 1 {Toon de help indexpagina}
menuText N HelpGuide "Snelle help" 0 {Laat de snelle helppagina zien}
menuText N HelpHints "Hints" 0 {Laat de hints helppagina zien}
menuText N HelpContact "Contact-info" 0 {Laat de contact-infopagina zien}
menuText N HelpTip "Tip van de dag" 0 {Laat een handige ScidvsPC tip zien}
menuText N HelpStartup "Startvenster" 0 {Laat het startvenster zien}
menuText N HelpAbout "Over ScidvsPC" 0 {Informatie over ScidvsPC}

# Game info box popup menu:
menuText N GInfoHideNext "Verberg volgende zet" 0
menuText N GInfoShow "Kleur aan zet" 0
menuText N GInfoCoords "Coördinaten aan/uit" 0
menuText N GInfoMaterial "Materiaalverhouding" 0
menuText N GInfoFEN "FEN" 0
menuText N GInfoMarks "Toon gekleurde velden en pijlen. " 5
menuText N GInfoWrap "Lange regels op schermbreedte splitsen." 0
menuText N GInfoFullComment "Volledig commentaar weergeven" 10
menuText N GInfoPhotos "Toon foto's" 5 ;
menuText N GInfoTBNothing "Eindspel tablebases: geen" 12
menuText N GInfoTBResult  "Eindspel tablebases: alleen resultaat" 12
menuText N GInfoTBAll "Eindspel tablebases: resultaat en beste zetten" 19
menuText N GInfoDelete "Partij wissen/terughalen" 9
menuText N GInfoMark "Partij markeren/niet markeren" 7
menuText N GInfoInformant "Configureer informant waarden" 0
# ====== TODO To be translated ======
translate N FlipBoard {Flip board}
# ====== TODO To be translated ======
translate N RaiseWindows {Raise windows}
# ====== TODO To be translated ======
translate N AutoPlay {Autoplay}
# ====== TODO To be translated ======
translate N TrialMode {Trial mode}

# General buttons:
translate N Apply {Toepassen}
translate N Back {Terug}
translate N Browse {Bladeren} ;
translate N Cancel {Annuleren}
translate N Continue {Verder gaan}
translate N Clear {Leegmaken}
translate N Close {Sluiten}
translate N Contents {Inhoud} ;
translate N Defaults {Standaard}
translate N Delete {Wis}
translate N Graph {Grafiek}
translate N Help {Help}
translate N Import {Importeren}
translate N Index {Index}
translate N LoadGame {Partij laden}
translate N BrowseGame {Door de partij bladeren}
translate N MergeGame {Partij samenvoegen}
translate N MergeGames {Partijen samenvoegen}
translate N Preview {Voorbeeld}
translate N Revert {Terugkeren}
translate N Save {Bewaren}
# ====== TODO To be translated ======
translate N DontSave {Don't Save}
translate N Search {Zoeken}
translate N Stop {Stop}
translate N Store {Opbergen}
translate N Update {Bijwerken}
translate N ChangeOrient {Wijzigen venster oriëntatie}
translate N ShowIcons {Toon iconen} ;
# ====== TODO To be translated ======
translate N ConfirmCopy {Confirm Copy}
translate N None {Geen}
translate N First {Eerste}
translate N Current {Huidige}
translate N Last {Laatste}
# ====== TODO To be translated ======
translate N Font {Font}
# ====== TODO To be translated ======
translate N Change {Change}
# ====== TODO To be translated ======
translate N Random {Random}

# General messages:
translate N game {Partij}
translate N games {Partijen}
translate N move {Zet}
translate N moves {Zetten}
translate N all {Alle}
translate N Yes {Ja}
translate N No {Nee}
translate N Both {Beide}
translate N King {Koning}
translate N Queen {Dame}
translate N Rook {Toren}
translate N Bishop {Loper}
translate N Knight {Paard}
translate N Pawn {Pion}
translate N White {Wit}
translate N Black {Zwart}
translate N Player {Speler}
translate N Rating {Eloklassering}
translate N RatingDiff {Verschil Elo klassering (Wit - Zwart)}
translate N AverageRating {Gemiddelde Elo rangschikking}
translate N Event {Evenement}
translate N Site {Plaats}
translate N Country {Land}
translate N IgnoreColors {Kleuren negeren}
# ====== TODO To be translated ======
translate N MatchEnd {End pos only}
translate N Date {Datum}
translate N EventDate {Datum evenement}
translate N Decade {Decennium}
translate N Year {Jaar}
translate N Month {Maand}
translate N Months {Januari Februari Maart April Mei Juni Juli Augustus September Oktober November December}
translate N Days {Zon Maa Din Woe Don Vri Zat}
translate N YearToToday {Een jaar geleden}
translate N Result {Uitslag}
translate N Round {Ronde}
translate N Length {Lengte}
translate N ECOCode {ECO Code}
translate N ECO {ECO}
translate N Deleted {Verwijderd}
translate N SearchResults {Zoekresultaten}
translate N OpeningTheDatabase {Database aan het openen}
translate N Database {Database}
translate N Filter {Filter}
# ====== TODO To be translated ======
translate N Reset {Reset}
translate N IgnoreCase {Negeer hoofdletters}
translate N noGames {Geen partijen}
translate N allGames {Alle partijen}
translate N empty {leeg}
translate N clipbase {clipbase}
translate N score {Score}
translate N Start {Start}
translate N StartPos {Beginstelling}
translate N Total {Totaal}
translate N readonly {alleen-lezen}
# ====== TODO To be translated ======
translate N altered {altered}
# ====== TODO To be translated ======
translate N tagsDescript {Extra tags (eg: Annotator "Anand")}
# ====== TODO To be translated ======
translate N prevTags {Use previous}

# Standard error messages:
translate N ErrNotOpen {Deze database is niet geopend.}
translate N ErrReadOnly {Deze database is alleen lezen; kan niet veranderd worden.}
translate N ErrSearchInterrupted {Zoeken werd onderbroken; de resultaten zijn onvolledig.}

# Game information:
translate N twin {Dubbele partijen}
translate N deleted {Gewist}
translate N comment {Commentaar}
translate N hidden {Verborgen}
translate N LastMove {Laatste zet}
translate N NextMove {Volgende zet}
translate N GameStart {Start partij}
translate N LineStart {Start variant}
translate N GameEnd {Einde partij}
translate N LineEnd {Einde variant}

# Player information:
translate N PInfoAll {alle partijen}
translate N PInfoFilter {filter partijen}
translate N PInfoAgainst {Resultaten tegen}
translate N PInfoMostWhite {Meest gespeelde opening als wit}
translate N PInfoMostBlack {Meest gespeelde opening als zwart}
translate N PInfoRating {Geschiedenis Elo klassering}
translate N PInfoBio {Biografie}
translate N PInfoEditRatings {Bewerk Elo rangschikking}
# ====== TODO To be translated ======
translate N PinfoEditName {Edit Name}
# ====== TODO To be translated ======
translate N PinfoLookupName {Lookup Name}

# Tablebase information:
translate N Draw {Remise}
translate N stalemate {Pat}
# ====== TODO To be translated ======
translate N checkmate {checkmate}
translate N withAllMoves {met alle zetten}
translate N withAllButOneMove {alle zetten behalve één}
translate N with {met}
translate N only {alleen}
translate N lose {verliezen}
translate N loses {verliest}
translate N allOthersLose {alle overigen verliezen}
translate N matesIn {Mat in}
translate N longest {langste}
translate N WinningMoves {Winnende zetten}
translate N DrawingMoves {Remise zetten}
translate N LosingMoves {Verliezende zetten}
translate N UnknownMoves {Onbekend resultaat zetten}

# Tip of the day:
translate N Tip {Tip}
translate N TipAtStartup {Tip bij opstarten}

# Tree window menus:
menuText N TreeFile "BoomDatabase" 0
menuText N TreeFileFillWithBase "Vul het cache met database" 0 {Vul het cachebestand met alle partijen uit de huidige database}
menuText N TreeFileFillWithGame "Vul het cache met de partij" 0 {Vul het cachebestand met het huidige partij uit de huidige database}
menuText N TreeFileSetCacheSize "Cache grootte" 0 {Stel de grootte van het cache bestand in}
menuText N TreeFileCacheInfo "Cache info" 0 {Vraag informatie over het gebruik van de cache}
menuText N TreeFileSave " BoomData Bewaren" 0 {Bewaar de boomdata in een boomcache (.stc) bestand}
menuText N TreeFileFill "Vullen boomcache bestand" 0 \
  {Vul het boomcache bestand met algemene opening stellingen}
menuText N TreeFileBest "Lijst beste partijen" 0 {Weergeven van de lijst met beste partijen}
menuText N TreeFileGraph "Grafiek-venster" 0 \
  {Weergeven van de grafiek voor deze tak}
menuText N TreeFileCopy "Kopieer boom tekst naar klembord" 0 \
  {Kopiëren van de boomstatistieken naar het klembord}
menuText N TreeFileClose "Zoekboom venster sluiten" 0 {Sluiten van het zoekboom venster}
menuText N TreeMask "Masker" 0
menuText N TreeMaskNew "Nieuw" 0 {Nieuw masker}
menuText N TreeMaskOpen "Open" 0 {Open masker}
menuText N TreeMaskOpenRecent "Open recent" 0 {Open recent masker}
menuText N TreeMaskSave "Bewaar" 0 {Bewaar het masker}
menuText N TreeMaskClose "Sluiten" 0 {Sluit het masker}
# ====== TODO To be translated ======
menuText N TreeMaskFillWithLine "Fill with line" 0 {Fill mask with all previous moves}
menuText N TreeMaskFillWithGame "Vullen met partij" 0 {Vul het masker met de partij}
menuText N TreeMaskFillWithBase "Vullen met database" 0 {Vul het masker met alle partijen in het database}
menuText N TreeMaskInfo "Info" 0 {Toon de statistieken voor het huidige masker}
menuText N TreeMaskDisplay "Toon masker overzicht" 0 {Toon maskerdata in boomvorm}
menuText N TreeMaskSearch "Zoek" 0 {Zoek in huidig masker}
menuText N TreeSort "Sorteren" 0
menuText N TreeSortAlpha "Alfabetisch" 0
menuText N TreeSortECO "ECO code" 0
menuText N TreeSortFreq "Frequentie" 0
menuText N TreeSortScore "Punten" 0
menuText N TreeOpt "Opties" 0
menuText N TreeOptSlowmode "Trage modus" 0 {Trage modus voor updates (hoge nauwkeurigheid)}
menuText N TreeOptFastmode "Snelle modus" 0 {Snelle modus voor updates (geen omwisselingen van zetten)}
menuText N TreeOptFastAndSlowmode "Snelle en trage modus" 0 {Eerst snelle modus en daarna trage modus voor updates}
menuText N TreeOptStartStop "Automatisch verversen" 0 {Zet automatisch verversen van het boomvenster aan/uit}
menuText N TreeOptLock "Vergrendelen" 0 {Vergrendelen/Ontgrendelen van de boom bij de huidige database}
menuText N TreeOptTraining "Training" 0 {Aan/Uit zetten training modus}
# ====== TODO To be translated ======
menuText N TreeOptShort "Short Display" 0 {Don't show ELO information}
menuText N TreeOptAutosave "Autom.cache-data Bewaren" 4 \
  {Automatisch bewaren van het cache bestand bij sluiten boomvenster}
# ====== TODO To be translated ======
menuText N TreeOptAutomask "Auto-Load Mask" 0 "Auto-Load most recent mask with a tree open."
# ====== TODO To be translated ======
menuText N TreeOptShowBar "Show Progress Bar" 0 "Show tree progress bar."
# ====== TODO To be translated ======
menuText N TreeOptSortBest "Sort Best Games" 0 "Sort Best Games by ELO."
menuText N TreeHelp "Help" 0
menuText N TreeHelpTree "Hulp bij zoekboom" 0
menuText N TreeHelpIndex "Index" 0

translate N SaveCache {Cache bewaren}
translate N Training {Training}
translate N LockTree {Boom vergrendelen}
translate N TreeLocked {Vergrendeld}
translate N TreeBest {Beste}
translate N TreeBestGames {Boom beste partijen}
# ====== TODO To be translated ======
translate N TreeAdjust {Adjust Filter}
# Note: the next message is the tree window title row. After editing it,
# check the tree window to make sure it lines up with the actual columns.
translate N TreeTitleRow {    Zet      Frequentie    Score Rem. GemElo Prest GemJaar ECO}
translate N TreeTitleRowShort {    Zet      Frequentie    Score Rem.}
translate N TreeTotal {TOTAAL}
translate N DoYouWantToSaveFirst {Wil u eerst de verandering bewaren?}
translate N AddToMask {Toevoegen aan het masker}
translate N RemoveFromMask {Verwijderen uit het masker}
translate N AddThisMoveToMask {Voeg deze zet toe aan het masker}
translate N SearchMask {Zoek in masker}
translate N DisplayMask {Toon masker}
translate N Nag {Nag code}
translate N Marker {Aanwijzer}
translate N Include {Invoegen}
translate N Exclude {Weglaten}
translate N MainLine {Hoofdvariant}
translate N Bookmark {Bladwijzer}
translate N NewLine {Nieuwe variant}
translate N ToBeVerified {Na te kijken}
translate N ToTrain {Trainen}
translate N Dubious {Dubieus}
translate N ToRemove {Verwijderen}
translate N NoMarker {Geen aanwijzer}
translate N ColorMarker {Kleur}
translate N WhiteMark {Wit}
translate N GreenMark {Groen}
translate N YellowMark {Geel}
translate N BlueMark {Blauw}
translate N RedMark {Rood}
translate N CommentMove {Commentaar op zet}
translate N CommentPosition {Commentaar op stelling}
translate N AddMoveToMaskFirst {Voeg de zet eerst toe aan het masker}
translate N OpenAMaskFileFirst {Open eerst een maskerbestand}
translate N Positions {Stellingen}
translate N Moves {Zetten}

# Finder window:
menuText N FinderFile "Bestand" 0
menuText N FinderFileSubdirs "Kijken in submappen" 0
menuText N FinderFileClose "Sluiten bestandszoeker" 0
menuText N FinderSort "Sorteren" 0
menuText N FinderSortType "Type" 0
menuText N FinderSortSize "Grootte" 0
menuText N FinderSortMod "Gewijzigd" 0
menuText N FinderSortName "Naam" 0
menuText N FinderSortPath "Pad" 0
menuText N FinderTypes "Types" 0
menuText N FinderTypesScid "ScidvsPC databases" 0
menuText N FinderTypesOld "Oud formaat ScidvsPC databases" 0
menuText N FinderTypesPGN "PGN bestanden" 0
menuText N FinderTypesEPD "EPD (boek) bestanden" 0
menuText N FinderHelp "Help" 0
menuText N FinderHelpFinder "Bestandszoeker help" 0
menuText N FinderHelpIndex "Bestandszoeker helpindex" 0
translate N FileFinder {Bestandszoeker}
translate N FinderDir {Map}
translate N FinderDirs {Mappen}
translate N FinderFiles {Bestanden}
translate N FinderUpDir {Hogere map}
translate N FinderCtxOpen {Openen}
translate N FinderCtxBackup {Back-up}
translate N FinderCtxCopy {Kopiëren}
translate N FinderCtxMove {Verplaatsen}
translate N FinderCtxDelete {Verwijderen}

# Player finder:
menuText N PListFile "Bestand" 0
menuText N PListFileUpdate "Bijwerken" 0
menuText N PListFileClose "Sluiten" 0
menuText N PListSort "Sorteren" 0
menuText N PListSortName "Naam" 0
menuText N PListSortElo "Elo" 0
menuText N PListSortGames "Partijen" 0
menuText N PListSortOldest "Oudste" 0
menuText N PListSortNewest "Nieuwste" 0

# Tournament finder:
menuText N TmtFile "Bestand" 0
menuText N TmtFileUpdate "Bijwerken" 0
menuText N TmtFileClose "Sluiten toernooi zoeker" 0
menuText N TmtSort "Sorteren" 0
menuText N TmtSortDate "Datum" 0
menuText N TmtSortPlayers "Spelers" 0
menuText N TmtSortGames "Partijen" 0
menuText N TmtSortElo "Elo" 0
menuText N TmtSortSite "Plaats" 0
menuText N TmtSortEvent "Evenement" 1
menuText N TmtSortWinner "Winnaar" 0
translate N TmtLimit "Lijst grootte"
translate N TmtMeanElo "Laagste gem. Elo" 
translate N TmtNone "Geen toernooien gevonden."

# Graph windows:
menuText N GraphFile "Bestand" 0
menuText N GraphFileColor "Bewaren als kleuren Postscript..." 8
menuText N GraphFileGrey "Bewaren als grijze Postscript..." 8
menuText N GraphFileClose "Venster sluiten" 0
menuText N GraphOptions "Opties" 0
menuText N GraphOptionsWhite "Wit" 0
menuText N GraphOptionsBlack "Zwart" 0
menuText N GraphOptionsBoth "Beide" 1
menuText N GraphOptionsPInfo "Speler informatie" 0
translate N GraphFilterTitle "Filtergrafiek: frequentie per 1000 partijen"
translate N GraphAbsFilterTitle "Filter grafiek: frequentie van de partijen"
translate N ConfigureFilter {Configureer X-as}
translate N FilterEstimate "Ongeveer"
translate N TitleFilterGraph "ScidvsPC: Filter grafiek"

# Analysis window:
translate N AddVariation {Toevoegen variant}
translate N AddAllVariations {Alle varianten toevoegen}
translate N AddMove {Toevoegen zet}
translate N Annotate {Annotatie}
translate N ShowAnalysisBoard {Toon analysebord}
translate N ShowInfo {Toon engine informatie}
translate N FinishGame {Beëindig partij}
translate N StopEngine {Stop de engine}
translate N StartEngine {Start de engine}
# ====== TODO To be translated ======
translate N ExcludeMove {Exclude Move}
translate N LockEngine {Engine op huidige stelling vastzetten}
translate N AnalysisCommand {Analyse commando}
translate N PreviousChoices {Voorgaande keuzes}
translate N AnnotateTime {Geef de analysetijd in seconden per zet}
translate N AnnotateWhich {Voeg varianten toe}
translate N AnnotateAll {Voor zetten van beide zijden}
translate N AnnotateAllMoves {Annoteer alle zetten}
translate N AnnotateWhite {Alleen voor zetten van Wit}
translate N AnnotateBlack {Alleen voor zetten van Zwart}
translate N AnnotateNotBest {Als de partijzet niet de beste is.}
translate N AnnotateBlundersOnly {Als de partijzet een blunder is}
# ====== TODO To be translated ======
translate N BlundersNotBest {Blunders/Not Best}
translate N AnnotateBlundersOnlyScoreChange {Blunder analyse rapport, met scorewijziging van/naar: }
translate N AnnotateTitle {Configureren annotatie}
translate N BlundersThreshold {Ondergrens}
# ====== TODO To be translated ======
translate N ScoreFormat {Score format}
# ====== TODO To be translated ======
translate N CutOff {Cut Off}
translate N LowPriority {Lage CPU prioriteit}
# ====== TODO To be translated ======
translate N LogEngines {Log Size}
# ====== TODO To be translated ======
translate N LogName {Add Name}
# ====== TODO To be translated ======
translate N MaxPly {Max Ply}
translate N ClickHereToSeeMoves {Klik hier om zetten te zien}
translate N ConfigureInformant {Annotaties configureren}
translate N Informant!? {Interessante zet}
translate N Informant? {Slechte zet}
translate N Informant?? {Blunder}
translate N Informant?! {Dubieuze zet}
translate N Informant+= {Wit heeft een klein voordeel}
translate N Informant+/- {Wit heeft duidelijk voordeel}
translate N Informant+- {Wit heeft een beslissend voordeel}
translate N Informant++- {Je mag stellen dat de partij gewonnen is}
translate N Book {Openingenboek}

# Analysis Engine open dialog:
translate N EngineList {Analyse enginelijst}
# ====== TODO To be translated ======
translate N EngineKey {Key}
# ====== TODO To be translated ======
translate N EngineType {Type}
translate N EngineName {Naam}
translate N EngineCmd {Commando}
translate N EngineArgs {Parameters}
translate N EngineDir {Map}
translate N EngineElo {Elo}
translate N EngineTime {Datum}
translate N EngineNew {Nieuw}
translate N EngineEdit {Bewerk}
translate N EngineRequired {Velden in <b>vet</b> zijn vereist; de andere facultatief}

# Stats window menus:
menuText N StatsFile "Bestand" 0
menuText N StatsFilePrint "Data als tekstbestand Bewaren..." 0
menuText N StatsFileClose "Venster sluiten" 0
menuText N StatsOpt "Opties" 0

# PGN window menus:
menuText N PgnFile "Bestand" 0
menuText N PgnFileCopy "Kopieer partij naar klembord" 0
menuText N PgnFilePrint "Als PGN bestand Bewaren..." 0
menuText N PgnFileClose "PGN-venster sluiten" 0
menuText N PgnOpt "Opties" 0
menuText N PgnOptColor "Instellen kleuren" 10
menuText N PgnOptShort "Korte (3 regelige) kop" 0
menuText N PgnOptSymbols "Symbolen annotaties" 10
menuText N PgnOptIndentC "Inspringen (commentaar)" 12
menuText N PgnOptIndentV "Inspringen (variant)" 12
menuText N PgnOptColumn "Kolom stijl (een zet per regel)" 0
menuText N PgnOptSpace "Spatie na zetnummer" 0
menuText N PgnOptStripMarks "Verwijder gekleurde vierkante haken codes" 1
menuText N PgnOptChess "Schaakstukken" 0
menuText N PgnOptScrollbar "Scrolbalk" 6
menuText N PgnOptBoldMainLine "Gebruik vette tekst voor zetten hoofdvariant" 4
menuText N PgnColor "Kleuren" 0
menuText N PgnColorHeader "Kop..." 0
menuText N PgnColorAnno "Annotaties..." 0
menuText N PgnColorComments "Commentaar..." 0
menuText N PgnColorVars "Varianten..." 0
menuText N PgnColorBackground "Achtergrondkleur..." 0

menuText N PgnColorMain "Hoofdvariant..." 0
menuText N PgnColorCurrent "Huidige zet achtergrond..." 1
menuText N PgnColorNextMove "Volgende zet achtergrond..." 0
menuText N PgnHelp "Help" 0
menuText N PgnHelpPgn "PGN help" 0
menuText N PgnHelpIndex "Inhoud" 0
translate N PgnWindowTitle {Partij Notatie - partij %u} ;

# Crosstable window menus:
menuText N CrosstabFile "Bestand" 0
menuText N CrosstabFileText "Bewaren in tekstformaat..." 13
menuText N CrosstabFileHtml " Bewaren in HTML-formaat..." 13
menuText N CrosstabFileLaTeX " Bewaren in LaTeX-formaat..." 13
menuText N CrosstabFileClose "Kruistabel sluiten" 0
menuText N CrosstabEdit "Bewerken" 0
menuText N CrosstabEditEvent "Evenement" 0
menuText N CrosstabEditSite "Plaats" 0
menuText N CrosstabEditDate "Datum" 0
menuText N CrosstabOpt "Opties" 0
menuText N CrosstabOptColorPlain "Tekst" 0
menuText N CrosstabOptColorHyper "Hypertekst" 1
# ====== TODO To be translated ======
menuText N CrosstabOptTieWin "Tie-Break by wins" 1
# ====== TODO To be translated ======
menuText N CrosstabOptTieHead "Tie-Break by head-head" 1
menuText N CrosstabOptThreeWin "3 punten voor een overwinning" 1
menuText N CrosstabOptAges "Leeftijd in jaren" 8
menuText N CrosstabOptNats "Nationaliteiten" 1
menuText N CrosstabOptTallies "Winst/Verlies/Remise" 0
menuText N CrosstabOptRatings "Elo" 0
menuText N CrosstabOptTitles "Titels" 0
menuText N CrosstabOptBreaks "Tie-break scores" 4
menuText N CrosstabOptDeleted "Inclusief gewiste partijen" 8
menuText N CrosstabOptColors "Kleuren (alleen bij Zwitsers)" 0
# ====== TODO To be translated ======
menuText N CrosstabOptColorRows "Color Rows" 0
menuText N CrosstabOptColumnNumbers "Genummerde kolommen (Alleen bij gesloten tabel)" 2
menuText N CrosstabOptGroup "Punten (groep)" 0
menuText N CrosstabSort "Sorteren" 0
menuText N CrosstabSortName "Naam" 0
menuText N CrosstabSortRating "Elo" 0
menuText N CrosstabSortScore "Score" 0
menuText N CrosstabSortCountry "Land" 0
# todo
menuText N CrosstabType "Format" 0
menuText N CrosstabTypeAll "Gesloten" 0
menuText N CrosstabTypeSwiss "Zwitsers" 0
menuText N CrosstabTypeKnockout "Knock-out" 0
menuText N CrosstabTypeAuto "Auto" 0
menuText N CrosstabHelp "Help" 0
menuText N CrosstabHelpCross "Help (kruistabel)" 0
menuText N CrosstabHelpIndex "Inhoud" 0
translate N SetFilter {Zet Filter}
translate N AddToFilter {Toevoegen aan selectie}
translate N Swiss {Zwitsers}
translate N Category {Categorie} ;

# Opening report window menus:
menuText N OprepFile "Bestand" 0
menuText N OprepFileText "Bewaren in tekstformaat..." 13
menuText N OprepFileHtml " Bewaren in HTML-formaat..." 13
menuText N OprepFileLaTeX " Bewaren in LaTeX-formaat..." 13
menuText N OprepFileOptions "Opties..." 0
menuText N OprepFileClose "Sluit rapportvenster" 0
menuText N OprepFavorites "Favorieten" 1 ;
menuText N OprepFavoritesAdd "Voeg rapport toe..." 0 ;
menuText N OprepFavoritesEdit "Bewerk favoriete rapport..." 0 ;
menuText N OprepFavoritesGenerate "Genereer rapporten..." 0 ;
menuText N OprepHelp "Help" 0
menuText N OprepHelpReport "Help (openingsrapport)" 0
menuText N OprepHelpIndex "Inhoud" 0

# Header search:
translate N HeaderSearch {Zoek naar kop}
translate N EndSideToMove {Kleur aan zet bij partijeinde} ;
translate N GamesWithNoECO {Partijen zonder ECO?}
translate N GameLength {Lengte partij}
translate N FindGamesWith {Vind partijen met vlag}
translate N StdStart {Niet standaard begin}
translate N Promotions {Promoties}
# ====== TODO To be translated ======
translate N UnderPromo {Under Prom.}
translate N Comments {Commentaar}
translate N Variations {Varianten}
translate N Annotations {Annotaties}
translate N DeleteFlag {Wis-markeringen}
translate N WhiteOpFlag {Wit opening}
translate N BlackOpFlag {Zwart opening}
translate N MiddlegameFlag {Middenspel}
translate N EndgameFlag {Eindspel}
translate N NoveltyFlag {Nieuwtje}
translate N PawnFlag {Pionnenstructuur}
translate N TacticsFlag {Tactiek}
translate N QsideFlag {Damevleugel}
translate N KsideFlag {Koningsvleugel}
translate N BrilliancyFlag {Briljant}
translate N BlunderFlag {Blunder}
translate N UserFlag {Gebruiker}
translate N PgnContains {PGN bevat tekst}

# Game list window:
translate N GlistNumber {Nummer}
translate N GlistWhite {Wit}
translate N GlistBlack {Zwart}
translate N GlistWElo {W-Elo}
translate N GlistBElo {Z-Elo}
translate N GlistEvent {Evenement}
translate N GlistSite {Plaats}
translate N GlistRound {Ronde}
translate N GlistDate {Datum}
translate N GlistYear {Jaar}
translate N GlistEventDate {Datum evenement}
translate N GlistResult {Uitslag}
translate N GlistLength {Lengte}
translate N GlistCountry {Land}
translate N GlistECO {ECO}
translate N GlistOpening {Opening}
translate N GlistEndMaterial {Eind-Materiaal}
translate N GlistDeleted {Verwijderd}
translate N GlistFlags {Markeringen}
translate N GlistVariations {Varianten}
translate N GlistComments {Commentaar}
translate N GlistAnnos {Annotaties}
translate N GlistStart {Start}
translate N GlistGameNumber {Partijnummer}
translate N GlistFindText {Tekst zoeken}
translate N GlistMoveField {Verplaats}
translate N GlistEditField {Configuratie}
translate N GlistAddField {Voeg toe}
translate N GlistDeleteField {Verwijder}
translate N GlistColor {Kleuren}
# ====== TODO To be translated ======
translate N GlistSort {Sort database}
translate N GlistRemoveThisGameFromFilter  {Verwijder}
translate N GlistRemoveGameAndAboveFromFilter  {Verwijder alle hiervoor}
translate N GlistRemoveGameAndBelowFromFilter  {Verwijder alle hierna}
translate N GlistDeleteGame {Verwijder/Herstel deze partij} 
translate N GlistDeleteAllGames {Verwijder alle gefilterde partijen} 
translate N GlistUndeleteAllGames {Herstellen alle partijen in het filter} 
# ====== TODO To be translated ======
translate N GlistAlignL {Align left}
# ====== TODO To be translated ======
translate N GlistAlignR {Align right}
# ====== TODO To be translated ======
translate N GlistAlignC {Align center}

# Maintenance windows
translate N DatabaseName {Naam database:}
translate N TypeIcon {Type icon}
translate N NumOfGames {Partijen:}
translate N NumDeletedGames {Gewiste partijen:}
translate N NumFilterGames {Partijen in selectie:}
translate N YearRange {Jaarbereik:}
translate N RatingRange {Elobereik (laag/hoog):}
translate N Description {Beschrijving} ;
translate N Flag {Markering}
translate N CustomFlags {Markering volgens keus}
translate N DeleteCurrent {Wis huidige partij}
translate N DeleteFilter {Wis geselecteerde partijen}
translate N DeleteAll {Wis alle partijen}
translate N UndeleteCurrent {Haal huidige partij terug}
translate N UndeleteFilter {Haal geselecteerde partijen terug}
translate N UndeleteAll {Haal alle partijen terug}
translate N DeleteTwins {Wis dubbelen}
translate N MarkCurrent {Markeer huidige partij}
translate N MarkFilter {Markeer geselecteerde partijen}
translate N MarkAll {Markeer alle partijen}
translate N UnmarkCurrent {Verwijder Markering huidige partij)}
translate N UnmarkFilter {Verwijder Markering geselecteerde partijen)}
translate N UnmarkAll {Verwijder Markering alle partijen)}
translate N Spellchecking {Spellingcontrole}
# ====== TODO To be translated ======
translate N MakeCorrections {Make Corrections}
# ====== TODO To be translated ======
translate N Ambiguous {Ambiguous}
# ====== TODO To be translated ======
translate N Surnames {Surnames}
translate N Players {Spelers}
translate N Events {Evenementen}
translate N Sites {Plaatsen}
translate N Rounds {Rondes}
translate N DatabaseOps {Database bewerkingen}
translate N ReclassifyGames {Partijen ECO-classificeren...}
translate N CompactDatabase {Database compact maken = optimaliseren}
translate N SortDatabase {Database sorteren}
translate N AddEloRatings {Toevoegen Elo classificatie}
translate N AutoloadGame {Auto-laden partij nummer}
translate N StripTags {Verwijder PGN labels}
translate N StripTag {Verwijder label}
translate N CheckGames {Controleer partijen}
translate N Cleaner {Reiniger}
translate N CleanerHelp {
De ScidvsPC Reiniger zal alle onderhoudsactiviteiten die u selecteert uit onderstaande lijst, uitvoeren op de huidige database. 
De dialogen van de huidige instellingen in de ECO classificatie en verwijderen van dubbelen zullen worden toegepast indien u deze functies selecteert.
}
translate N CleanerConfirm {
Wanneer het Reinigeronderhoud is gestart, kan dit niet worden onderbroken!

Dit kan lang duren op een grote database, afhankelijk van de geselecteerde functies en de huidige instellingen.

Weet u zeker dat u de geselecteerde onderhoudsfuncties wilt uitvoeren?
}
translate N TwinCheckUndelete {Omdraaien; "u" hersteld beiden)}
translate N TwinCheckprevPair {Vorig paar}
translate N TwinChecknextPair {Volgend paar}
translate N TwinChecker {ScidvsPC: Controle dubbele partijen}
translate N TwinCheckTournament {Partijen in toernooi:}
translate N TwinCheckNoTwin {Geen dubbelen  }
translate N TwinCheckNoTwinfound {Geen dubbele partij gevonden.\nOm dubbelen in dit scherm te tonen, moet je de "Verwijder dubbele partijen..." functie gebruiken. }
translate N TwinCheckTag {Delen tags...}
translate N TwinCheckFound1 {ScidvsPC heeft $result dubbele partijen gevonden}
translate N TwinCheckFound2 { en heeft de verwijder code aangezet}
translate N TwinCheckNoDelete {Er zijn in deze database geen partijen te verwijderen.}
translate N TwinCriteria1 { De instellingen voor het zoeken van dubbele partijen kunnen tot\ngevolg hebben dat partijen met soortgelijke zetten als dubbel worden gemarkeerd.}
translate N TwinCriteria2 {Aanbeveling om "Nee" voor "zelfde zetten" te kiezen en "Ja" voor kleuren, toernooi, locatie, ronde, jaar en maand instelling.\nWil je verder gaan en dubbelen toch verwijderen? }
translate N TwinCriteria3 {Aanbeveling om minimaal twee keer "JA" te kiezen bij "zelfde site", "zelfde ronde" of "zelfde jaar" instellingen.\n Wil je verder gaan en dubbelen toch verwijderen?}
translate N TwinCriteriaConfirm {ScidvsPC: instelling voor dubbelen bevestigen}
translate N TwinChangeTag "Wijzig de volgende partij tags:\n\n"
translate N AllocRatingDescription "Deze opdracht gebruikt het spelling-bestand om Elo ratings aan partijen in de database toe te voegen. Als een speler geen rating is heeft, maar zijn/haar rating op het moment van de partij wel in het spelling-bestand staat, dan wordt die rating toegevoegd."
translate N RatingOverride "Ongelijk ratings overschrijven?"
translate N AddRatings "Elo rating toevoegen aan:"
translate N AddedRatings {ScidvsPC voegde $r Elo ratings aan $g partijen toe.}
translate N NewSubmenu "Nieuw submenu"

# Comment editor:
translate N AnnotationSymbols  {Symbolen voor annotatie:}
translate N Comment {Commentaar:}
translate N InsertMark {Voeg markering toe}
translate N InsertMarkHelp {
Voeg toe/verwijder markering: Selecteer  kleur, type, veld.
Voeg toe/verwijder pijl: Rechtsklik twee velden.
} ;

# Nag buttons in comment editor:
translate N GoodMove {Goede zet}
translate N PoorMove {Slechte zet}
translate N ExcellentMove {Excellente zet}
translate N Blunder {Blunder}
translate N InterestingMove {Interessante zet}
translate N DubiousMove {Dubieuze zet}
translate N WhiteDecisiveAdvantage {Wit heeft beslissend voordeel}
translate N BlackDecisiveAdvantage {Zwart heeft beslissend voordeel}
translate N WhiteClearAdvantage {Wit heeft duidelijk voordeel}
translate N BlackClearAdvantage {Zwart heeft beslissend voordeel}
translate N WhiteSlightAdvantage {Wit heeft licht voordeel}
translate N BlackSlightAdvantage {Zwart heeft licht voordeel}
translate N Equality {Gelijk}
translate N Unclear {Onduidelijk}
translate N Diagram {Diagram}

# Board search:
translate N BoardSearch {Zoeken Bord}
translate N FilterOperation {Toepassen op huidige selectie:}
translate N FilterAnd {AND (Selectie beperken)}
translate N FilterOr {OR (Selectie uitbreiden)}
translate N FilterIgnore {Selectie Ongedaan maken}
translate N SearchType {Zoek type stelling:}
translate N SearchBoardExact {Exacte stelling (stukken op dezelfde velden)}
translate N SearchBoardPawns {Pionnen (hetzelfde materiaal, alle pionnen op dezelfde velden)}
translate N SearchBoardFiles {Lijnen (hetzelfde materiaal, alle pionnen op dezelfde lijnen)}
translate N SearchBoardAny {Willekeurig (hetzelfde materiaal, pionnen en stukken willekeurig)}
translate N SearchInRefDatabase {Zoek in database }
translate N LookInVars {Zoek in varianten}

# Material search:
translate N MaterialSearch {Zoeken materiaal}
translate N Material {Materiaal}
translate N Patterns {Patroon}
translate N Zero {Niets}
translate N Any {Willekeurig}
translate N CurrentBoard {Huidige stelling}
translate N CommonEndings {Veel voorkomende eindspelen}
translate N CommonPatterns {Veel voorkomende patronen}
translate N MaterialDiff {Ongelijk materiaal}
translate N squares {Velden}
translate N SameColor {Gelijke kleur}
translate N OppColor {Ongelijke kleur}
translate N Either {Beide}
translate N MoveNumberRange {Zet bereik }
translate N MatchForAtLeast {Op z'n minst gelijk}
translate N HalfMoves {halve zetten}

# Common endings in material search:
translate N EndingPawns {Pionnen eindspel}
translate N EndingRookVsPawns {Toren tegen Pion(nen)}
translate N EndingRookPawnVsRook {Toren en 1 Pion tegen Toren}
translate N EndingRookPawnsVsRook {Toren en Pionnen tegen Toren}
translate N EndingRooks {Toren tegen Toren eindspel}
translate N EndingRooksPassedA {Toren tegen Toren met een vrije a-pion}
translate N EndingRooksDouble {Dubbele Toren eindspelen}
translate N EndingBishops {Loper tegen Loper eindspel}
translate N EndingBishopVsKnight {Loper tegen Paard eindspel}
translate N EndingKnights {Paard tegen Paard eindspel}
translate N EndingQueens {Dame tegen Dame eindspel}
translate N EndingQueenPawnVsQueen {Dame en pion tegen Dame}
translate N BishopPairVsKnightPair {Loperpaar tegen 2 Paarden middenspel}

# Common patterns in material search:
translate N PatternWhiteIQP {Witte geïsoleerde pion}
translate N PatternWhiteIQPBreakE6 {Witte geïsoleerde pion: d4-d5 doorbraak vs e6}
translate N PatternWhiteIQPBreakC6 {Witte geïsoleerde pion: d4-d5 doorbraak vs c6}
translate N PatternBlackIQP {Zwarte geïsoleerde pion}
translate N PatternWhiteBlackIQP {Witte geïsoleerde pion vs Zwarte geïsoleerde pion}
translate N PatternCoupleC3D4 {Witte hangende pionnen c3+d4}
translate N PatternHangingC5D5 {Zwarte hangende pionnen c5+d5}
translate N PatternMaroczy {Maroczy Centrum (Pionnen op c4 en e4)}
translate N PatternRookSacC3 {Torenoffer op c3}
translate N PatternKc1Kg8 {O-O-O en O-O (Kc1 vs Kg8)}
translate N PatternKg1Kc8 {O-O en O-O-O (Kg1 vs Kc8)}
translate N PatternLightFian {Lichte velden Fianchettos (Loper-g2 vs Loper-b7)}
translate N PatternDarkFian {Donkere velden Fianchettos (Loper-b2 vs Loper-g7)}
translate N PatternFourFian {Vier Fianchettos (Lopers op b2,g2,b7,g7)}

# Game saving:
translate N Today {Nu}
translate N ClassifyGame {Partij classificeren}

# Setup position:
translate N EmptyBoard {Bord leegmaken}
translate N InitialBoard {Beginstelling}
translate N SideToMove {Aan zet:}
translate N MoveNumber {Zetnummer}
translate N Castling {Rokade}
translate N EnPassantFile {En Passant lijn}
translate N ClearFen {FEN leegmaken}
translate N PasteFen {FEN plakken}
translate N SaveAndContinue {Opslaan en doorgaan}
translate N DiscardChangesAndContinue {Wijzigingen negeren}
translate N GoBack {Terug}

# Replace move dialog:
translate N ReplaceMove {Zet vervangen}
translate N AddNewVar {Voeg nieuwe variant toe}
translate N NewMainLine {Nieuwe hoofdvariant}
translate N ReplaceMoveMessage {Hier is al een zet.  

U kunt hem vervangen en alle volgende zetten wissen, of uw zet toevoegen als een nieuwe variant.

(U kunt deze melding in de toekomst onderdrukken door "Bevestiging voor overschrijven" uit te zetten in het menu:Opties - Zetten)}

# Make database read-only dialog:
translate N ReadOnlyDialog {Als u deze database "alleen-lezen" maakt, zijn geen veranderingen toegestaan.
Er kunnen geen partijen meer worden opgeslagen of veranderd en ook geen wis-markeringen toegevoegd of verwijderd.
Elke sortering of ECO-classificering zal tijdelijk zijn dan voor deze database.

U kunt de database weer schrijf-toegankelijk maken door hem te sluiten en weer te openen.

Wilt u echt deze database alleen-lezen maken?}

# Exit dialog:
translate N ExitDialog {Wilt u ScidvsPC werkelijk afsluiten?}
# ====== TODO To be translated ======
translate N ClearGameDialog {This game has been altered.\nDo you wish to save it?}
translate N ExitUnsaved {In de volgende databases zijn partijen gewijzigd en niet opgeslagen. Als u nu afsluit zullen deze wijzigingen verloren gaan.}

# Import window:
translate N PasteCurrentGame {Plak huidige partij}
translate N ImportHelp1 {Invoeren of plak een PGN-formaat partij in het venster hierboven.}
translate N ImportHelp2 {Alle import-fouten worden hier weergegeven.}
translate N OverwriteExistingMoves {Bestaande zetten overschrijven?}

# ECO Browser:
translate N ECOAllSections {alle ECO code secties}
translate N ECOSection {ECO sectie}
translate N ECOSummary {Samenvatting voor}
translate N ECOFrequency {Frequentie van subcodes voor}

# Opening Report:
translate N OprepTitle {Openingsrapportage}
translate N OprepReport {Rapportage}
translate N OprepGenerated {Samengesteld door }
translate N OprepStatsHist {Statistieken en Geschiedenis}
translate N OprepStats {Statistieken}
translate N OprepStatAll {Alle rapportage partijen}
translate N OprepStatBoth {Elo beide spelers}
translate N OprepStatSince {Sinds}
translate N OprepOldest {Oudste partijen}
translate N OprepNewest {Meest recente partijen}
translate N OprepPopular {Huidige populariteit}
translate N OprepFreqAll {Frequentie over alle jaren: }
translate N OprepFreq1   {In het afgelopen jaar:      }
translate N OprepFreq5   {In de afgelopen 5 jaar:    }
translate N OprepFreq10  {In de afgelopen 10 jaar:    }
translate N OprepEvery {Een keer in %u partijen}
translate N OprepUp {%u%s hoger dan alle jaren}
translate N OprepDown {%u%s lager dan alle jaren}
translate N OprepSame {zelfde als alle jaren}
translate N OprepMostFrequent {Meest frequente spelers}
translate N OprepMostFrequentOpponents {Frequentste tegenstanders} ;
translate N OprepRatingsPerf {Elo classificatie en Resultaten}
translate N OprepAvgPerf {Gemiddelde Elo classificatie en Resultaten }
translate N OprepWRating {Witte Elo classificatie }
translate N OprepBRating {Zwarte Elo classificatie }
translate N OprepWPerf {Prestatie wit}
translate N OprepBPerf {Prestatie zwart}
translate N OprepHighRating {Partijen met de hoogste gemiddelde Elo Classificatie }
translate N OprepTrends {Resultaten trends}
translate N OprepResults {Resultaat lengtes en frequenties}
translate N OprepLength {Partij lengte}
translate N OprepFrequency {Frequentie}
translate N OprepWWins {Overwinningen wit:   }
translate N OprepBWins {Overwinningen zwart: }
translate N OprepDraws {Remises: }
translate N OprepWholeDB {Hele database}
translate N OprepShortest {Kortste winst}
# translate N OprepShortWhite {Kortste witte overwinningen}
# translate N OprepShortBlack {Kortste zwarte overwinningen}
translate N OprepMovesThemes {Zetten en thema's}
translate N OprepMoveOrders {Zetreeks om rapportstelling te bereiken}
translate N OprepMoveOrdersOne \
  {Er was slechts 1 zetreeks om deze stelling te bereiken:}
translate N OprepMoveOrdersAll \
  {Er waren %u zetreeksen om deze stelling te bereiken:}
translate N OprepMoveOrdersMany \
  {Er waren %u zetreeksen om deze stelling te bereiken. De top %u zijn:}
translate N OprepMovesFrom {Zetten vanuit de rapportstelling:}
translate N OprepMostFrequentEcoCodes {Frequentste ECO codes} ;
translate N OprepThemes {Positionele Thema's}
translate N OprepThemeDescription {Frequentie van thema's in de eerste %u zetten van elke partij}
translate N OprepThemeSameCastling {Gelijke rokades}
translate N OprepThemeOppCastling {Tegengestelde rokades}
translate N OprepThemeNoCastling {Beide zijden niet gerokeerd}
translate N OprepThemeKPawnStorm {Pionnenstorm op koningsvleugel}
translate N OprepThemeQueenswap {Dameruil}
translate N OprepThemeWIQP {Witte geïsoleerde damepion} ;
translate N OprepThemeBIQP {Zwarte geïsoleerde damepion} ;
translate N OprepThemeWP567 {Witte pion op de 5/6/7de rij}
translate N OprepThemeBP234 {Zwarte pion op de 2/3/4de rij}
translate N OprepThemeOpenCDE {Open c/d/e lijn}
translate N OprepTheme1BishopPair {Slechts 1 kant heeft loperpaar}
translate N OprepEndgames {Eindspelen}
translate N OprepReportGames {Rapportage partijen}
translate N OprepAllGames {Alle partijen}
translate N OprepEndClass {Materiaal classificatie van eindstellingen}
translate N OprepTheoryTable {Theorie tabel}
translate N OprepTableComment {Samengesteld uit de %u partijen met de hoogste Elo classificatie.}
translate N OprepExtraMoves {Extra zetten in theorie tabel}
translate N OprepMaxGames {Maximaal aantal partijen in theorie tabel}
translate N OprepViewHTML { HTML zicht} ;
translate N OprepViewLaTeX {LaTeX zicht} ;

# Player Report:
translate N PReportTitle {Speler rapport} ;
translate N PReportColorWhite {met Wit} ;
translate N PReportColorBlack {mee Zwart} ;
# ====== TODO To be translated ======
translate N PReportBeginning {Beginning with}
translate N PReportMoves {na %s} ;
translate N PReportOpenings {Openingen} ;
translate N PReportClipbase {Maak clipbase leeg en kopieer de geselecteerde partijen erheen} ;

# Piece Tracker window:
translate N TrackerSelectSingle {Linker muisknop selecteert dit stuk.}
translate N TrackerSelectPair {Linker muisknop selecteert dit stuk; de rechtermuisknop selecteert zijn buur.}
translate N TrackerSelectPawn {Linker muisknop selecteert deze pion; de rechtermuisknop selecteert alle 8 pionnen.}
translate N TrackerStat {Statistiek}
translate N TrackerGames {% partijen met zet naar dit veld.}
translate N TrackerTime {% keer op ieder veld.}
translate N TrackerMoves {Zetten}
translate N TrackerMovesStart {Voer het zetnummer in waarmee de spoorvolger moet beginnen.}
translate N TrackerMovesStop {Voer het zetnummer in waar de spoorvolger moet stoppen.}

# Game selection dialogs:
translate N SelectAllGames {Alle partijen in de database}
translate N SelectFilterGames {Alleen partijen uit selectiefilter}
translate N SelectTournamentGames {Alleen partijen in huidig toernooi}
translate N SelectOlderGames {Alleen oudere partijen}

# Delete Twins window:
translate N TwinsNote {Om een dubbele partij te zijn moet deze minimaal dezelfde twee spelers en de onderstaande te selecteren criteria bevatten. Bij vondst van twee dubbele partijen wordt de kortste verwijderd. Hint: Controleer de database op spelfouten voordat dubbelen worden verwijderd. Dit verhoogt de kans op vinden van dubbele partijen. }
translate N TwinsCriteria {Criteria: Dubbele partijen moeten hebben...}
translate N TwinsWhich {Onderzoek welke partijen}
translate N TwinsColors {Spelers dezelfde kleur?}
translate N TwinsEvent {Hetzelfde evenement?}
translate N TwinsSite {Dezelfde locatie?}
translate N TwinsRound {Dezelfde ronde?}
translate N TwinsYear {Hetzelfde jaar?}
translate N TwinsMonth {Dezelfde maand?}
translate N TwinsDay {Dezelfde dag?}
translate N TwinsResult {Hetzelfde resultaat?}
translate N TwinsECO {Dezelfde ECO-code?}
translate N TwinsMoves {Dezelfde zetten?}
translate N TwinsPlayers {Vergelijken speler namen:}
translate N TwinsPlayersExact {Exacte overeenkomst}
translate N TwinsPlayersPrefix {Alleen eerste 4 letters}
translate N TwinsWhen {Wanneer dubbele partijen verwijderen}
translate N TwinsSkipShort {Negeer alle partijen korter dan 5 zetten?}
translate N TwinsUndelete {Haal alle voor wissen gemarkeerde partijen eerst terug?}
translate N TwinsSetFilter {Selecteer alle verwijderde dubbele partijen?}
translate N TwinsComments {Altijd partijen met commentaar bewaren?}
translate N TwinsVars {Altijd partijen met varianten bewaren?}
translate N TwinsDeleteWhich {Welke partij wissen:}
translate N TwinsDeleteShorter {Kortste partij}
translate N TwinsDeleteOlder {Laagste partijnummer}
translate N TwinsDeleteNewer {Hoogste partijnummer}
translate N TwinsDelete {Verwijder partijen}

# Name editor window:
translate N NameEditType {Type naam om te wijzigen}
translate N NameEditSelect {Partijen om te wijzigen}
translate N NameEditReplace {Vervangen}
translate N NameEditWith {met}
translate N NameEditMatches {Gelijken: Druk Ctrl+1 tot Ctrl+9 om te selecteren}

# Check games window:
translate N CheckGamesWhich {Controleer partijen met}
translate N CheckAll {Alle partijen}
translate N CheckSelectFilterGames {Alleen partijen binnen het filter}

# Classify window:
translate N Classify {Classificeren}
translate N ClassifyWhich {ECO-Classificatie: welke partijen}
translate N ClassifyAll {Alle partijen (overschrijven oude ECO codes)}
translate N ClassifyYear {Alle partijen gespeeld in het afgelopen jaar}
translate N ClassifyMonth {Alle partijen gespeeld in de afgelopen maand}
translate N ClassifyNew {Alleen partijen zonder ECO code}
translate N ClassifyCodes {ECO Codes om te gebruiken}
translate N ClassifyBasic {Alleen basis codes ("B12", ...)}
translate N ClassifyExtended {ScidvsPC extensies ("B12j", ...)}

# Compaction:
translate N NameFile {Namenbestand}
translate N GameFile {Partijenbestand}
translate N Names {Namen}
translate N Unused {Ongebruikt}
translate N SizeKb {Grootte (Kb)}
translate N CurrentState {Huidige status}
translate N AfterCompaction {Na comprimeren}
translate N CompactNames {Gecomprimeerde namenbestand}
translate N CompactGames {Gecomprimeerd partijenbestand}
translate N NoUnusedNames "Er zijn geen overbodige namen, dus het namenbestand is al volledig gecomprimeerd."
translate N NoUnusedGames "Het partijenbestand is al volledig gecomprimeerd."
translate N NameFileCompacted {Het namenbestand "[file tail [sc_base filename]]" is gecomprimeerd.}
translate N GameFileCompacted {Het partijenbestand "[file tail [sc_base filename]]" is gecomprimeerd.}

# Sorting:
translate N SortCriteria {Criteria}
translate N AddCriteria {Toevoegen criteria}
translate N CommonSorts {Algemene sorteringen}
translate N Sort {Sorteren}

# Exporting:
translate N AddToExistingFile {Toevoegen partijen aan bestaand bestand?}
translate N ExportComments {Exporteren commentaar?}
translate N ExportVariations {Exporteren varianten?}
translate N IndentComments {Inspringen commentaar?}
translate N IndentVariations {Inspringen varianten?}
translate N ExportColumnStyle {Kolomstijl (een zet per regel)?}
translate N ExportSymbolStyle {Symbolische annotatie stijl:}
translate N ExportStripMarks {Wis vierkante haken/pijlen markeer codes uit de commentaar?}

# Goto game/move dialogs:
translate N LoadGameNumber {Geef het nummer van de te laden partij:}
translate N GotoMoveNumber {Ga naar zetnummer:}

# Copy games dialog:
translate N CopyGames {Kopiëren partijen}
translate N CopyConfirm {
 Wilt u echt kopiëren
 de [::utils::thousands $nGamesToCopy] geselecteerde partijen
 van database "$fromName"
 naar database "$targetName"?
}
translate N CopyErr {Kan partijen niet kopiëren}
translate N CopyErrSource {de bron database}
translate N CopyErrTarget {de doel database}
translate N CopyErrNoGames {heeft geen partijen in het filter}
translate N CopyErrReadOnly {is alleen-lezen}
translate N CopyErrNotOpen {is niet geopend}

# Colors:
translate N LightSquares {Lichte velden}
translate N DarkSquares {Donkere velden}
translate N SelectedSquares {Geselecteerde velden}
translate N SuggestedSquares {Zetsuggestie velden}
translate N Grid {Raster}
translate N Previous {Voorgaande}
translate N WhitePieces {Witte stukken}
translate N BlackPieces {Zwarte stukken}
translate N WhiteBorder {Witte rand}
translate N BlackBorder {Zwarte rand}
translate N ArrowMain   {Hoofdpijl}
translate N ArrowVar    {Variatiepijl}

# Novelty window:
translate N FindNovelty {Vind nieuwtje}
translate N Novelty {Nieuwtje}
translate N NoveltyInterrupt {Zoeken nieuwtje onderbroken}
translate N NoveltyNone {In deze partij is geen nieuwtje gevonden}
translate N NoveltyHelp {
ScidvsPC zal de eerste zet vinden in de huidige partij, waarna een stelling ontstaat die nog niet was gevonden in de database of in het ECO openingsboek.
}

# Sounds configuration:
translate N SoundsFolder {Geluidsbestanden map} ;
translate N SoundsFolderHelp {De map moet de bestanden King.wav, a.wav, 1.wav, enz. bevatten} ;
translate N SoundsAnnounceOptions {Zet signalering opties} ;
translate N SoundsAnnounceNew {Signaleer als een nieuwe zet gedaan wordt} ;
translate N SoundsAnnounceForward {Signaleer als een zet vooruit gedaan wordt} ;
translate N SoundsAnnounceBack {Signaleer als een zet terug gedaan of genomen wordt} ;

# Upgrading databases:
translate N Upgrading {Bijwerken}
translate N ConfirmOpenNew {
Dit is een oud formaat (SI3) database welke in ScidvsPC 4 niet kan openen, echter een nieuwe versie (SI4) bestaat wel al.

Wilt u de database in het nieuwe formaat openen?
}
translate N ConfirmUpgrade {
Dit is een oud formaat "SI3" database. Een versie in het nieuwe formaat moet worden gemaakt, voordat het in ScidvsPC 4 kan worden gebruikt.

Bijwerken creëert een nieuwe versie van de database. De originele bestanden blijven bestaan en worden niet gewijzigd.

Dit kan enige tijd duren, maar het hoeft slechts eenmalig plaats te vinden. U kunt het afbreken indien het te lang duurt.

Wilt u de database nu bijwerken?
}

# Recent files options:
translate N RecentFilesMenu {Aantal recente bestanden in Bestand menu}
translate N RecentFilesExtra {Aantal recente bestanden in extra submenu}

# My Player Names options:
translate N MyPlayerNamesDescription {Voeg hieronder een lijst met voorkeur spelersnamen in, 1 speler per regel. Jokers (bvb "?" voor elke letter, "*" voor een reeks letters) zijn toegelaten.
Telkens een partij uit de lijst word geladen, zal het schaakbord worden gedraaid indien nodig om de partij vanuit die speler zijn perspectief te tonen.
} ;

translate N showblunderexists {toon dat er een blunder is}
translate N showblundervalue {toon blunder waarde}
translate N showscore {toon score}
translate N coachgame {coach partij}
translate N configurecoachgame {configureer coach partij}
translate N configuregame {Partij configuratie}
translate N Phalanxengine {Phalanx schaakengine}
translate N Coachengine {Coach engine}
translate N difficulty {moeilijkheidsgraad}
translate N hard {erg moeilijk}
translate N easy {gemakkelijk}
translate N Playwith {Speel met}

translate N white {wit}
translate N black {zwart}
translate N both {beide}
translate N Play {Spel}
translate N Noblunder {Geen blunder}
translate N blunder {Blunder}

translate N Noinfo {-- Geen info --}



translate N moveblunderthreshold {zet is blunder als het verlies groter is dan}

translate N limitanalysis {Maximum analysetijd schaakengine}

translate N seconds {seconden}

translate N Abort {Afbreken}
translate N Resume {Hervatten}
translate N Restart {Herstarten}
translate N OutOfOpening {Uit de opening}

translate N NotFollowedLine {Je volgde de variant niet}

translate N DoYouWantContinue {Wil je verder gaan?}
translate N CoachIsWatching {De coach kijkt mee}
translate N Ponder {Continu denken}
translate N LimitELO {Limiteer Elo sterkte}
translate N DubiousMovePlayedTakeBack {Dubieuze zet gespeeld, wilt u deze terugnemen?}
translate N WeakMovePlayedTakeBack {Minder goede zet gespeeld, wilt u deze terugnemen?}
translate N BadMovePlayedTakeBack {Slechte zet gespeeld, wilt u deze terugnemen?}

translate N Iresign {Ik geef op}
translate N yourmoveisnotgood {Je zet is niet goed}
translate N EndOfVar {Eind van variant}
translate N Openingtrainer {Opening trainer}
translate N DisplayCM {Toon kandidaat zetten}

translate N DisplayCMValue {Toon waarde kandidaat zetten}
translate N DisplayOpeningStats {Toon statistieken}
translate N ShowReport {Toon rapport}
translate N NumberOfGoodMovesPlayed {goede zetten gespeeld}
translate N NumberOfDubiousMovesPlayed {dubieuze zetten gespeeld}
translate N NumberOfTimesPositionEncountered {aantal keer dat deze stelling voorkomt}
translate N PlayerBestMove  {Laat alleen beste zetten toe}
translate N OpponentBestMove {Tegenstander speelt beste zetten}
translate N OnlyFlaggedLines {Enkel gemarkeerde varianten}
translate N resetStats {Statistieken wissen}
translate N Movesloaded {Zetten geladen}
translate N PositionsNotPlayed {Positie niet gespeeld}
translate N PositionsPlayed {Positie gespeeld}
translate N Success {Succes}
translate N DubiousMoves {Dubieuze zet}

translate N ConfigureTactics {Configureer tactiek}

translate N ResetScores {Initialiseer scores}

translate N LoadingBase {Laad database}

translate N Tactics {Tactiek}

translate N ShowSolution {Toon oplossing}

translate N Next {Volgende}

translate N ResettingScore {Initialiseer score}

translate N LoadingGame {Laad partij}

translate N MateFound {Mat gevonden}

translate N BestSolutionNotFound {Beste oplossing NIET gevonden!}

translate N MateNotFound {Mat NIET gevonden}

translate N ShorterMateExists {Korter mat bestaat}

translate N ScorePlayed {Score gespeeld}

translate N Expected {verwacht}

translate N ChooseTrainingBase {Kies training base}

translate N Thinking {Denken}

translate N AnalyzeDone {Analyse gedaan}

translate N WinWonGame {Win gewonnen partij}

translate N Lines {Varianten}

translate N ConfigureUCIengine {Configureer UCI engine}

translate N SpecificOpening {Specifieke opening}
translate N StartNewGame {Start nieuwe partij}
translate N FixedLevel {Vast niveau}
translate N Opening {Opening}
translate N RandomLevel {Willekeurig niveau}
translate N StartFromCurrentPosition {Start vanuit de huidige stelling}
translate N FixedDepth {Vaste diepte}
translate N Nodes {Knooppunten}
translate N Depth {Diepte}
translate N Time {Tijd} 
translate N SecondsPerMove {Seconden per zet}
# ====== TODO To be translated ======
translate N DepthPerMove {Depth per move}
# ====== TODO To be translated ======
translate N MoveControl {Move Control}
translate N TimeLabel {Tijd per zet}
# ====== TODO To be translated ======
translate N AddVars {Add Variations}
# ====== TODO To be translated ======
translate N AddScores {Add Score}
translate N Engine {Engine}
translate N TimeMode {Tijd modus}
translate N TimeBonus {Tijd + bonus}
translate N TimeMin {min}
translate N TimeSec {sec}

translate N AllExercisesDone {Alle oefeningen gedaan}
translate N MoveOutOfBook {Zet buiten boek}
translate N LastBookMove {Laatste zet boek}
translate N AnnotateSeveralGames {Becommentarieer verschillende partijen \n van huidig tot :}
translate N FindOpeningErrors {Vind openingsfouten}
translate N MarkTacticalExercises {Markeer tactische oefeningen}
translate N UseBook {Gebruik boek}
translate N MultiPV {Meerdere varianten}
translate N Hash {Hash Geheugentabel}
translate N OwnBook {Gebruik engineboek}
translate N BookFile {Opening boek}

translate N AnnotateVariations {Becommentarieer varianten}
translate N ShortAnnotations {Korte annotaties}
translate N addAnnotatorTag {Annotator label toevoegen}
translate N AddScoreToShortAnnotations {Voeg de score toe aan de korte annotaties}

translate N Export {Export}

translate N BookPartiallyLoaded {Boek gedeeltelijk geladen}
# ====== TODO To be translated ======
translate N AddLine {Add Line}
# ====== TODO To be translated ======
translate N RemLine {Remove Line}
translate N Calvar {Berekenen van variaties}
translate N ConfigureCalvar {Configuratie}

translate N Reti {Reti}
translate N English {Engels}
translate N d4Nf6Miscellaneous {1.d4 Nf6 diversen}
translate N Trompowsky {Trompowsky}
translate N Budapest {Boedapest}
translate N OldIndian {Oud-Indisch}
translate N BenkoGambit {Benko gambiet}
translate N ModernBenoni {Moderne Benoni}
translate N DutchDefence {Nederlandse verdediging}
translate N Scandinavian {Scandinavisch}
translate N AlekhineDefence {Aljechin verdediging}
translate N Pirc {Pirc}
translate N CaroKann {Caro-Kann}
translate N CaroKannAdvance {Caro-Kann doorschuif}
translate N Sicilian {Siciliaans}
translate N SicilianAlapin {Siciliaans Alapin}
translate N SicilianClosed {Siciliaans gesloten}
translate N SicilianRauzer {Siciliaans Rauzer}
translate N SicilianDragon {Siciliaans draak}
translate N SicilianScheveningen {Siciliaans Scheveningen}
translate N SicilianNajdorf {Siciliaans Najdorf}
translate N OpenGame {Open spel}
translate N Vienna {Weens}
translate N KingsGambit {Koningsgambiet}
translate N RussianGame {Russisch}
translate N ItalianTwoKnights {Italiaans/Tweepaardenspel}
translate N Spanish {Spaans}
translate N SpanishExchange {Spaans ruilvariant}
translate N SpanishOpen {Spaans open}
translate N SpanishClosed {Spaans gesloten}
translate N FrenchDefence {Frans}
translate N FrenchAdvance {Frans doorschuif}
translate N FrenchTarrasch {Frans Tarrasch}
translate N FrenchWinawer {Frans Winawer}
translate N FrenchExchange {Frans ruilvariant}
translate N QueensPawn {Damepionspel}
translate N Slav {Slavisch}
translate N QGA {Aangenomen damegambiet}
translate N QGD {Damegambiet}
translate N QGDExchange {Damegambiet ruilvariant}
translate N SemiSlav {Half-Slavisch}
translate N QGDwithBg5 {Damegambiet met Lg5}
translate N QGDOrthodox {Damegambiet Orthodox}
translate N Grunfeld {Grünfeld}
translate N GrunfeldExchange {Grünfeld ruilvariant}
translate N GrunfeldRussian {Grünfeld Russisch}
translate N Catalan {Catalaans}
translate N CatalanOpen {Catalaans open}
translate N CatalanClosed {Catalaans gesloten}
translate N QueensIndian {Dame-Indisch}
translate N NimzoIndian {Nimzo-Indisch}
translate N NimzoIndianClassical {Nimzo-Indisch klassiek Dc2}
translate N NimzoIndianRubinstein {Nimzo-Indisch Rubinstein}
translate N KingsIndian {Koning-Indisch}
translate N KingsIndianSamisch {Koning-Indisch Sämisch}
translate N KingsIndianMainLine {Koning-Indisch hoofdvariant}

translate N ConfigureFics {Configureer FICS}
translate N FICSLogin {Login}
translate N FICSGuest {Login als Gast}
translate N FICSServerPort {Server poort}
translate N FICSServerAddress {IP-adres}
translate N FICSRefresh {Ververs}
translate N FICSTimeseal {Timeseal}
translate N FICSTimesealPort {Timeseal poort}
translate N FICSSilence {Stilte}
translate N FICSOffers {Biedt aan}
translate N FICSGames {Partijen}
translate N FICSFindOpponent {Zoek tegenstander}
translate N FICSTakeback {Terugnemen}
translate N FICSTakeback2 {Terugnemen 2}
translate N FICSInitTime {Initiële tijd (min)}
translate N FICSIncrement {Toename (sec)}
translate N FICSRatedGame {De betreffende partij}
translate N FICSAutoColour {Automatisch}
translate N FICSManualConfirm {Bevestig manueel}
translate N FICSFilterFormula {Filter met formule}
translate N FICSIssueSeek {Zoek uitdager}
translate N FICSAccept {Aanvaard}
translate N FICSDecline {weiger}
translate N FICSColour {Kleur}
translate N FICSSend {Zend}
translate N FICSConnect {Verbind}
# ====== TODO To be translated ======
translate N FICSShouts {Shouts}
# ====== TODO To be translated ======
translate N FICSTells {Tells}
# ====== TODO To be translated ======
translate N FICSOpponent {Opponent Info}
# ====== TODO To be translated ======
translate N FICSInfo {Info}
# ====== TODO To be translated ======
translate N FICSDraw {Offer Draw}
# ====== TODO To be translated ======
translate N FICSRematch {Rematch}
# ====== TODO To be translated ======
translate N FICSQuit {Quit FICS}
# ====== TODO To be translated ======
translate N FICSCensor {Censor}


translate N CCDlgConfigureWindowTitle {Configureer correspondentieschaak}
translate N CCDlgCGeneraloptions {Algemene opties}
translate N CCDlgDefaultDB {Standaard database:}
translate N CCDlgInbox {Inbox (pad):}
translate N CCDlgOutbox {Uitbox (pad):}
translate N CCDlgXfcc {Xfcc Configuratie:}
translate N CCDlgExternalProtocol {Externe protocol verwerker (b.v. Xfcc)}
translate N CCDlgFetchTool {Ontvangst tool:}
translate N CCDlgSendTool {Zend tool:}
translate N CCDlgEmailCommunication {E-mail communicatie}
translate N CCDlgMailPrg {Mail programma:}
translate N CCDlgBCCAddr {(B)CC adres:}
translate N CCDlgMailerMode {Mode:}
translate N CCDlgThunderbirdEg {b.v. Thunderbird, Mozilla Mail, Icedove...}
translate N CCDlgMailUrlEg {b.v. Evolution}
translate N CCDlgClawsEg {b.v. Sylpheed Claws}
translate N CCDlgmailxEg {b.v. mailx, mutt, nail...}
translate N CCDlgAttachementPar {Aanhangsel parameter:}
translate N CCDlgInternalXfcc {Gebruik interne Xfcc ondersteuning}
translate N CCDlgConfirmXfcc {Bevestig de zetten}
translate N CCDlgSubjectPar {Onderwerp parameter:}
translate N CCDlgDeleteBoxes {Lege in-/uitbox}
translate N CCDlgDeleteBoxesText {Wil je echt de  in-/uitbox mappen voor correspondentieschaak ledigen? Dit vereist een nieuwe synchronisatie om de laatste staat van je partijen te tonen.}
translate N CCDlgConfirmMove {Bevestig zet}
translate N CCDlgConfirmMoveText {Als je bevestigt zal volgende zet en commentaar naar de server gestuurd worden:}
translate N CCDlgDBGameToLong {Onverenigbare hoofdvariant}
translate N CCDlgDBGameToLongError {De hoofdvariant in jouw database is langer dan de partij in je inbox. Als de inbox huidige partijen bevat, bijv. vlak na een synchronisatie, dan werden enkele verkeerde zetten toegevoegd aan de hoofdvariant.\nIn dit geval verkort de hoofdvariant tot (max) zetten\n}
translate N CCDlgStartEmail {Start een nieuwe e-mail partij}
translate N CCDlgYourName {Uw naam:}
translate N CCDlgYourMail {Uw e-mail adres:}
translate N CCDlgOpponentName {Naam van de tegenstander:}
translate N CCDlgOpponentMail {E-mail adres van de tegenstander:}
translate N CCDlgGameID {Game ID (uniek):}
translate N CCDlgTitNoOutbox {ScidvsPC: Correspondentieschaak uitbox}
translate N CCDlgTitNoInbox {ScidvsPC: Correspondentieschaak inbox}
translate N CCDlgTitNoGames {ScidvsPC: Geen correspondentieschaak partijen}
translate N CCErrInboxDir {Correspondentieschaak inbox map:}
translate N CCErrOutboxDir {Correspondentieschaak uitbox map:}
translate N CCErrDirNotUsable {bestaat niet of is niet toegankelijk!\nVerifieer en corrigeer de instellingen.}
translate N CCErrNoGames {bevat geen partijen!\nHaal ze alstublieft eerst op.}
translate N CCDlgTitNoCCDB {ScidvsPC: Geen correspondentie database}
translate N CCErrNoCCDB {Er werd geen database van type 'Correspondentie' geopend. U moet er eerst een openen alvorens de correspondentieschaak functies te gebruiken.}
translate N CCFetchBtn {Haal de partijen van de server en verwerk de inbox}
translate N CCPrevBtn {Ga naar de vorige partij}
translate N CCNextBtn {Ga naar de volgende}
translate N CCSendBtn {Stuur de zet op}
translate N CCEmptyBtn {In-/Uitbox opschonen}
translate N CCHelpBtn {Hulp over iconen en status indicatoren.\nVoor algemene hulp: druk F1!}
translate N CCDlgServerName {Server naam:}
translate N CCDlgLoginName  {Login naam:}
translate N CCDlgPassword   {Wachtwoord:}
translate N CCDlgURL        {Xfcc-URL:}
translate N CCDlgRatingType {Klassering type:}
translate N CCDlgDuplicateGame {Niet-unieke partij ID}
translate N CCDlgDuplicateGameError {Deze partij bestaat meer dan één keer in de database. Graag duplicaten verwijderen en partijenbestand comprimeren (Bestand/Onderhoud/Comprimeer database).}
translate N CCDlgSortOption {Rangschikken:}
translate N CCDlgListOnlyOwnMove {De enige partijen waarvan ik de zet heb}
translate N CCOrderClassicTxt {Plaats, Wedstrijd, Ronde, Resultaat, Wit, Zwart}
translate N CCOrderMyTimeTxt {Mijn klok}
translate N CCOrderTimePerMoveTxt {Tijd per zet tot de volgende tijdscontrole}
translate N CCOrderStartDate {Start datum}
translate N CCOrderOppTimeTxt {Tegenstander klok}
translate N CCDlgConfigRelay {Partij bekijken}
translate N CCDlgConfigRelayHelp {Ga naar de partijenpagina op http://www.iccf-webchess.com en toon de partijen die je kan observeren.  Als je het schaakbord ziet, kopieer de URL van de browser naar de lijst hieronder. Maximaal een URL per regel!\nVoorbeeld:http://www.iccf-webchess.com/MakeAMove.aspx?id=266452}

translate N ExtHWConfigConnection {Configureer externe hardware}
translate N ExtHWPort {Poort}
translate N ExtHWEngineCmd {Engine opdracht}
translate N ExtHWEngineParam {Engine parameters}
translate N ExtHWShowButton {Toon knop}
translate N ExtHWHardware {Hardware}
translate N ExtHWNovag {Novag Citrine}
translate N ExtHWInputEngine {Invoer engine}
translate N ExtHWNoBoard {Geen bord}
translate N IEConsole {Invoer engine console}
translate N IESending {Zetten verstuurd naar}
translate N IESynchronise {Synchroniseren}
translate N IERotate  {Roteren}
translate N IEUnableToStart {Kan de invoer engine niet starten:}
translate N DoneWithPosition {Klaar met deze stelling}
translate N Board {Bord}
translate N showGameInfo {Toon de partij informatie}
translate N autoResizeBoard {Verander bord automatisch van grootte}
translate N DockTop {Zend naar eerste plaats}
translate N DockBottom {Zend naar laatste plaats}
translate N DockLeft {Zend naar links}
translate N DockRight {Zend naar rechts}
translate N Undock {Losmaken}
translate N ChangeIcon {Verander icon}
# ====== TODO To be translated ======
translate N More {More}

# Drag & Drop
translate N CannotOpenUri {Kan de volgende URI niet openen:}
translate N InvalidUri {Geplakte inhoud is geen geldige URI lijst.}
translate N UriRejected        {De volgende bestanden zijn afgekeurd:}
translate N UriRejectedDetail {Alleen de vermelde bestandstypes kunnen worden verwerkt:}
translate N EmptyUriList {Geplakte inhoud is leeg.}
translate N SelectionOwnerDidntRespond {Time-out tijdens plakken data: geen reactie van geselecteerde eigenaar.}
}

# end of nederlan.tcl
