# swedish.tcl:
# Text for menu names and status bar help messages in Swedish.
# Part of Scid (Shane's Chess Information Database).
# Contributed by Martin Skjöldebrand, martin@skjoldebrand.org
# Thanks to: Hans Eriksson, for looking over the translation file

addLanguage W Swedish 1 ;#iso8859-1

proc setLanguage_W {} {

# File menu:
menuText W File "Arkiv" 0
menuText W FileNew "Ny..." 0 {Skapa en ny Scid databas}
menuText W FileOpen "Öppna..." 0 {Öppna en befintlig Scid databas}
menuText W FileClose "Stäng" 0 {Stäng den aktiva Scid databasen}
menuText W FileFinder "Sök filer" 4 {Öppna sökdialogen}
menuText W FileSavePgn "Spara PGN..." 0 {}
menuText W FileOpenBaseAsTree "Öppna databas som träd" 0   {Öppna en databas och använd den i Trädfönstret}
menuText W FileOpenRecentBaseAsTree "Öppna senaste databasen som träd" 0   {Öppna den senaste databasen och använd den i Trädfönstret}
menuText W FileBookmarks "Bokmärken" 0 {Hantera bokmärken (kortkommando: Ctrl+B)}
menuText W FileBookmarksAdd "Nytt bokmärke" 0 \
  {Markera den aktiva ställningen i partiet}
menuText W FileBookmarksFile "Spara bokmärke" 0 \
  {Spara bokmärket för den aktiva ställningen i partiet}
menuText W FileBookmarksEdit "Redigera bokmärken..." 0 \
  {Redigera bokmärken}
menuText W FileBookmarksList "Visa bokmärken som lista" 19 \
  {Visar bokmärkena som lista, inte undermenyer}
menuText W FileBookmarksSub "Visa bokmärken i undermenyer" 17 \
  {Visar bokmärkena som undermenyer, inte lista}
menuText W FileReadOnly "Enbart läsbar..." 8 \
  {Avlägsna temporärt redigeringsmöjligheterna till databasen}
menuText W FileSwitch "Byt databas" 0 \
  {Byt till en annan öppnad databas}
menuText W FileExit "Avsluta" 0 {Avsluta Scid}

# Edit menu:
menuText W Edit "Redigera" 0
menuText W EditAdd "Lägg till variant" 0 {Skapa en variant vid denna ställning}
menuText W EditPasteVar "Klistra Variation" 0
menuText W EditDelete "Radera variant" 0 {Radera en variant vid denna ställning}
menuText W EditFirst "Skapa huvudvariant" 6 \
  {Gör en av varianterna till huvudvariant}
menuText W EditMain "Skapa nytt textdrag" 11 \
  {Gör en av varianterna till partifortsättning}
menuText W EditTrial "Testa variant" 6 \
  {Starta/ stoppa testläge, undersök en idé på brädet}
menuText W EditStrip "Ta bort" 3 {Avlägsna kommentarer eller varianter från partiet}
menuText W EditUndo "Ångra" 0 {Ångra senaste ändring i parti}
menuText W EditRedo "Repetera" 0
menuText W EditStripComments "Kommentarer" 0 \
  {Avlägsna alla kommentarer och noteringar från partiet}
menuText W EditStripVars "Varianter" 0 {Avlägsna alla varianter från partiet}
menuText W EditStripBegin "Avlägsna tidigare drag" 9 \
  {Avlägsna dragen fram till den aktuella ställningen}
menuText W EditStripEnd "Avlägsna resterande drag" 0 \
  {Avlägsna partiets resterande drag}
menuText W EditReset "Töm Clipbase" 1 \
  {Tömmer den temporära databasen}
menuText W EditCopy "Kopiera partiet till Clipbase" 21 \
  {Kopierar det aktuella partiet till Clipbase}
menuText W EditPaste "Klistra in det senaste Clipbasepartiet" 8 \
  {Klistrar in det senaste tillagda i Clipbase i den aktiva databasen}
menuText W EditPastePGN "Klistra in Clipbasetext som PGNparti..." 10 \
  {Tolka Clipbasetexten som ett parti i PGN notation och klistra in det här}
menuText W EditSetup "Skapa ställning..." 0 \
  {Skapa en utgångsställning för aktuellt parti}
menuText W EditCopyBoard "Kopiera ställning" 0 \
  {Kopiera den aktuella ställningen i FEN kod till urklippshanteraren}
menuText W EditCopyPGN "Kopiera PGN" 0 {}
menuText W EditPasteBoard "Klistra in utgångsställning" 10 \
  {Klistra in ställningen från aktuellt parti i den temporära databasen}

# Game menu:
menuText W Game "Partier" 0
menuText W GameNew "Nytt parti" 0 \
  {Återställ brädet inför ett nytt parti (raderar alla ändringar)}
menuText W GameFirst "Ladda det första partiet" 10 {Laddar det första partiet i filtret}
menuText W GamePrev "Ladda föregående parti" 7 {Ladda föregående parti i filtret}
menuText W GameReload "Börja om partiet" 0 \
  {Återställ partiet (raderar alla ändringar)}
menuText W GameNext "Ladda nästa parti" 6 {Ladda nästa parti i filtret}
menuText W GameLast "Ladda det sista partiet" 10 {Ladda det sista partiet i filtret}
menuText W GameRandom "Ladda parti slumpmässigt" 14 \
  {Ladda ett av datorn slumpmässigt valt parti}
menuText W GameNumber "Ladda parti nummer..." 6 \
  {Ladda ett parti genom att ange dess nummer}
menuText W GameReplace "Spara: Ersätt parti..." 7 \
  {Spara partiet och ersätt tidigare version}
menuText W GameAdd "Spara: Nytt parti..." 1 \
  {Spara ett nytt parti}
menuText W GameInfo "Ställ Spelinformation" 0
menuText W GameBrowse "Bläddra bland spel" 0
menuText W GameList "Visa alla spel" 0
# ====== TODO To be translated ======
menuText W GameDelete "Delete Game" 0
menuText W GameDeepest "Identifiera öppningen" 0 \
  {Gå till den mest detaljerade ställningen i ECO boken}
menuText W GameGotoMove "Gå till drag nummer..." 8 \
  {Gå till ett specifikt drag i partiet}
menuText W GameNovelty "Hitta nyhet..." 7 \
  {Hitta det första draget i partiet som inte spelats tidigare}

# Search Menu:
menuText W Search "Sök" 0
menuText W SearchReset "Återställ sökfilter" 0 {Återställ sökfiltret så att alla partiet ingår}
menuText W SearchNegate "Omvänt filter" 0 {Ta med partier som utesluts av filtret}
menuText W SearchEnd "Flytta till sista filter" 0
menuText W SearchCurrent "Aktuell position..." 8 {Sök partier med aktuell position på brädet}
menuText W SearchHeader "I huvud..." 2 {Använd fast information (spelare, evenemang, plats, mm)}
menuText W SearchMaterial "Material/ställning..." 0 {Sökning baserad på material eller ställning}
menuText W SearchMoves {Drag} 0 {}
menuText W SearchUsing "Använd sökfil..." 10 {Använd en fil med lagrade sökvillkor}

# Windows menu:
menuText W Windows "Fönster" 0
menuText W WindowsGameinfo "Visa partiinformation" 0 {Show/hide the game info panel}
menuText W WindowsComment "Kommentarseditor" 0 {Öppna/ stäng kommentarseditorn}
menuText W WindowsGList "Partilista" 5 {Öppna/ stäng partilistan}
menuText W WindowsPGN "PGN fönster" 0 {Öppna/ stäng PGN fönstret}
menuText W WindowsCross "Resultattabell" 0 {Visa en resultattabell för den aktuella turneringen}
menuText W WindowsPList "Spelarförteckning" 7 {Öppna/ stäng en förteckning över spelarna i den aktiva databasen}
menuText W WindowsTmt "Turneringar" 0 {Lista turneringar}
menuText W WindowsSwitcher "Databasväxlaren" 0 \
  {Öppna/ stäng databasväxlaren}
menuText W WindowsMaint "Verktygsfönster" 0 \
  {Öppna/ stäng verktygsfönstret}
menuText W WindowsECO "ECO fönster" 0 {Öppna/ stäng ECO bläddraren}
menuText W WindowsStats "Statistikfönster" 0 \
  {Öppna/ stäng statistikfönstret}
menuText W WindowsTree "Trädfönster" 2 {Öppna/ stäng variantträdets fönster}
menuText W WindowsTB "Slutspelsdatabas" 2 \
  {Öppna/ stäng slutspelsdatabasfönstret}
menuText W WindowsBook "Bokfönster" 0 {Öppna/stäng Bokfönstret}
menuText W WindowsCorrChess "Korrespondensfönster" 0 {Öppna/stäng Korrespondensfönstret}

# Tools menu:
menuText W Tools "Verktyg" 0
menuText W ToolsAnalysis "Analysmotor..." 6 \
  {Starta/ stoppa en analysmotor}
menuText W ToolsEmail "Eposthanterare" 0 \
  {Öppna/ stäng eposthanteraren}
menuText W ToolsFilterGraph "Filterdiagram" 7 \
  {Öppna/ stäng filterdiagramfönstret}
menuText W ToolsAbsFilterGraph "Absolut Filtergraf" 7 {Öppna/stäng filtergraffönstret för absolutvärden}
menuText W ToolsOpReport "Öppningsrapport" 0 \
  {Skapa en öppningsrapport utifrån den aktuella ställningen}
menuText W ToolsTracker "Sök material"  0 {Öppnar dialog för att söka efter en viss materiell balans}
menuText W ToolsTraining "Träning"  0 {Träningsverktyg (taktik, öppningar,...) }
menuText W ToolsComp "Turnering" 2 {Schackmotorturnering}
menuText W ToolsTacticalGame "Taktiskt parti"  0 {Spela ett parti med taktik}
menuText W ToolsSeriousGame "Seriöst parti"  0 {Spela ett seriöst parti}
menuText W ToolsTrainTactics "Taktik"  0 {Lösa taktik}
menuText W ToolsTrainCalvar "Variantberäkning"  0 {Variantberäkningsträning}
menuText W ToolsTrainFindBestMove "Hitta bäst drag"  0 {Hitta bästa draget}
menuText W ToolsTrainFics "Spela på Internet"  0 {Spela på freechess.org}
menuText W ToolsBookTuning "Bokfininställning" 0 {Bokfininställning}
menuText W ToolsMaint "Databasverktyg" 0 {Scids databasverktyg}
menuText W ToolsMaintWin "Verktygsfönster" 0 \
  {Öppna/ stäng verktygsfönstret}
menuText W ToolsMaintCompact "Komprimera databasen..." 0 \
  {Komprimera databasen, avlägsna raderade partier och oanvända namn}
menuText W ToolsMaintClass "Klassificera partier enligt ECO..." 2 \
  {Klassificera om alla partier enligt ECO-systemet}
menuText W ToolsMaintSort "Sortera databasen..." 0 \
  {Sortera partierna i den aktiva databasen}
menuText W ToolsMaintDelete "Radera dubbletter..." 0 \
  {Sök dubbletter och markera dem som raderingsbara}
menuText W ToolsMaintTwin "Sök dubbletter" 0 \
  {Öppna/ stäng dubblettfönstret för att söka dubblettpartier}
menuText W ToolsMaintNameEditor "Redigera namn" 0 \
  {Redigera spelarnamn utifrån rättstavningsfilen}
menuText W ToolsMaintNamePlayer "Stavningskontrollera namn..." 22 \
  {Stavningskontrollera namn utifrån rättstavningsfilen}
menuText W ToolsMaintNameEvent "Stavningskontrollera evenemang..." 21 \
  {Stavningskontrollera evenemang utifrån rättstavningsfilen}
menuText W ToolsMaintNameSite "Stavningskontrollera platser..." 21 \
  {Stavningskontrollera platser utifrån rättstavningsfilen}
menuText W ToolsMaintNameRound "Stavningskontrollera ronder..." 21 \
  {Stavningskontrollera ronder utifrån rättstavningsfilen}
menuText W ToolsMaintFixBase "Fixa trasig databas" 0 {Försök att fixa en trasig databas}
menuText W ToolsConnectHardware "Anslut hårdvara" 0 {Anslut extern hårdvara}
menuText W ToolsConnectHardwareConfigure "Konfigurera..." 0 {Konfigurera extern hårdvara och anslutning}
menuText W ToolsConnectHardwareNovagCitrineConnect "Anslut Novag Citrine" 0 {Anslut Novag Citrine}
menuText W ToolsConnectHardwareInputEngineConnect "Anslut Inmatningsmotor" 0 {Anslut Inmatningsmotor (t ex DGT)}
menuText W ToolsNovagCitrine "Novag Citrine" 0 {Novag Citrine}
menuText W ToolsNovagCitrineConfig "Konfiguration" 0 {Novag Citrine Konfiguration}
menuText W ToolsNovagCitrineConnect "Anslut" 0 {Anslut Novag Citrine}
menuText W ToolsPInfo "Spelarinformation"  0 \
  {Öppna/ uppdatera spelarinformation}
menuText W ToolsPlayerReport "Spelarrapport" 3 \
  {Skapa en spelarrapport}
menuText W ToolsRating "Ratingdiagram" 0 \
  {Skapa ett ratingdiagram för spelarna i partiet}
menuText W ToolsScore "Resultatdiagram" 8 {Visa resultatdiagrammet}
menuText W ToolsExpCurrent "Exportera aktuellt parti" 1 \
  {Spara aktuellt parti till en textfil}
menuText W ToolsExpCurrentPGN "Exportera till PGN..." 15 \
  {Spara aktuellt parti till en PGN-fil}
menuText W ToolsExpCurrentHTML "Exportera till HTML..." 15 \
  {Spara aktuellt parti till en HTML-fil}
menuText W ToolsExpCurrentHTMLJS "Exportera till HTML och JavaScript-fil..." 15 {Spara aktuellt parti till en HTML och JavaScript-fil} 
menuText W ToolsExpCurrentLaTeX "Exportera till LaTeX..." 15 \
  {Spara aktuellt parti till en LaTeX-fil}
# ====== TODO To be translated ======
menuText W ToolsExpFilter "Exportera alla filtrerade partier" 15 \
  {Spara alla filterade partier till en textfil}
menuText W ToolsExpFilterPGN "Exportera till PGN..." 15 \
  {Spara alla filterade partier till en PGN-fil}
menuText W ToolsExpFilterHTML "Exportera till HTML..." 15 \
  {Spara alla filterade partier till en HTML-fil}
menuText W ToolsExpFilterHTMLJS "Exportera filtrerade till HTML och JavaScript-fil..." 17 {Spara alla filtrerade partier till en HTML och JavaScript-fil} 
menuText W ToolsExpFilterLaTeX "Exportera till LaTeX..." 15 \
  {Spara alla filterade partier till en LaTeX-fil}
# ====== TODO To be translated ======
# ====== TODO To be translated ======
menuText W ToolsExpFilterGames "Export Gamelist to Text" 19 {Print a formatted Gamelist.}
menuText W ToolsImportOne "Importera ett parti i PGN-format..." 0 \
  {Importera ett parti i PGN-format}
menuText W ToolsImportFile "Importera flera partier i PGN-format..." 16 \
  {Importera flera partier i PGN-format från en fil}
menuText W ToolsStartEngine1 "Starta schackmotor 1" 0  {Starta schackmotor 1}
menuText W ToolsStartEngine2 "Starta schackmotor 2" 0  {Starta schackmotor 2}
menuText W ToolsScreenshot "Skapa en Skärmdump" 0
menuText W Play "Spela" 0
menuText W CorrespondenceChess "Korrespondensschack" 0 {Funktioner för eMail och Xfcc baserad Korrespondensschack}
menuText W CCConfigure "Konfigurera..." 0 {Konfigurera externa verktyg och generella inställningar}
menuText W CCConfigRelay "Konfigurera observationer..." 10 {Konfigurera partier att observera}
menuText W CCOpenDB "Öppna Databas..." 0 {Öppna standardkorrespondensdatabasen}
menuText W CCRetrieve "Hämta Partier" 0 {Hämta partier via extern (Xfcc-)hjälpare}
menuText W CCInbox "Hantera Inkorg" 0 {Hantera alla filer i Scids Inkorg}
menuText W CCSend "Skicka Drag" 0 {Skicka ditt drag via eMail eller extern (Xfcc-)hjälpare}
menuText W CCResign "Ge upp" 0 {Ge upp (inte via eMail)}
menuText W CCClaimDraw "Hävda Remi" 0 {Skicka drag och hävda Remi (inte via eMail)}
menuText W CCOfferDraw "Erbjud Remi" 0 {Skicka drag och erbjud Remi (inte via eMail)}
menuText W CCAcceptDraw "Acceptera Remi" 0 {Acceptera en erbjuden Remi (inte via eMail)}
menuText W CCNewMailGame "Nytt eMail-parti..." 0 {Starta ett nytt eMail-parti}
menuText W CCMailMove "Skicka Drag..." 0 {Skicka draget via eMail till motståndaren}
menuText W CCGamePage "Partisida..." 0 {Starta upp partiet via webläsaren}
menuText W CCEditCopy "Kopiera partilista till Clipbase" 0 {Kopiera partierna som CSV-lista till Clipbase}


# Options menu:
menuText W Options "Alternativ" 2
menuText W OptionsBoard "Brädet" 0 {Ändra brädets utseende}
menuText W OptionsColour "Bakgrundsfärg" 0 {Standardtextfärg}
# ====== TODO To be translated ======
menuText W OptionsBackColour "Background" 0 {Default text widget color}
# ====== TODO To be translated ======
menuText W OptionsEnableColour "Enable" 0 {}
# ====== TODO To be translated ======
menuText W OptionsMainLineColour "Mainline Arrows" 0 {Mainline arrows}
# ====== TODO To be translated ======
menuText W OptionsVarLineColour "Variation Arrows" 0 {Variation arrows}
# ====== TODO To be translated ======
menuText W OptionsRowColour "Rows" 0 {Default tree/book row color}
# ====== TODO To be translated ======
menuText W OptionsSwitcherColour "Switcher" 0 {Default db switcher color}
# ====== TODO To be translated ======
menuText W OptionsProgressColour "Progressbar" 0 {Default progressbar color}
# ====== TODO To be translated ======
menuText W OptionsCrossColour "Crosstable rows" 0 {Default crosstable row color}
menuText W OptionsNames "Spelarnamn..." 0 {Redigera spelares namn}
menuText W OptionsExport "Export" 0 {Ändra exportalternativ}
menuText W OptionsFonts "Typsnitt" 0 {Ändra typsnitt}
menuText W OptionsFontsRegular "Normal" 0 {Ändra det normala typsnittet}
menuText W OptionsFontsMenu "Menu" 0 {Ändra menytypsnittet}
menuText W OptionsFontsSmall "Liten" 0 {Ändra det lilla typsnittet}
menuText W OptionsFontsFixed "Fixerad" 0 {Ändra det fixerade typsnittet}
menuText W OptionsGInfo "Partiinformation" 0 {Alternativ för partiinformation}
menuText W OptionsFics "FICS" 0
menuText W OptionsFicsAuto "Autopronomera Drottningen" 0
# ====== TODO To be translated ======
menuText W OptionsFicsColour "Text Colour" 0
# ====== TODO To be translated ======
menuText W OptionsFicsSize "Board Size" 0
# ====== TODO To be translated ======
menuText W OptionsFicsCommands "Init Commands" 0
# ====== TODO To be translated ======
menuText W OptionsFicsNoRes "No Results" 0
# ====== TODO To be translated ======
menuText W OptionsFicsNoReq "No Requests" 0
# ====== TODO To be translated ======
menuText W OptionsFicsPremove "Allow Premove" 0
menuText W OptionsLanguage "Språk" 0 {Välj språk}
menuText W OptionsMovesTranslatePieces "Översätt pjäser" 0 {Översätt första bokstaven för pjäser}
menuText W OptionsMovesHighlightLastMove "Markera senaste draget" 0 {Markera senaste draget}
menuText W OptionsMovesHighlightLastMoveDisplay "Visa" 0 {Visa senaste markerade draget}
menuText W OptionsMovesHighlightLastMoveWidth "Bredd" 0 {Tjockhet på rad}
menuText W OptionsMovesHighlightLastMoveColor "Färg" 0 {Färg på rad}
menuText W OptionsMoves "Drag" 0 {Alternativ för dragangivelse}
menuText W OptionsMovesAsk "Fråga före ersätt drag" 0 \
  {Fråga innan du ersätter befintliga drag}
menuText W OptionsMovesAnimate "Fördröjning vid manuellt spel" 1 \
  {Ange tid mellan varje drag när dragen görs automatiskt}
menuText W OptionsMovesDelay "Fördröjning vid automatspel..." 1 \
  {Ange fördröjning mellan dragen när datorn spelar själv}
menuText W OptionsMovesCoord "Koordinater" 0 \
  {Acceptera koordinater ("g1f3") vid dragangivelse}
menuText W OptionsMovesSuggest "Visa föreslagna drag" 0 \
  {Visa/ Dölj föreslagna drag}
menuText W OptionsShowVarPopup "Visa Variantfönster" 0 {Starta/Avsluta visningen av ett Variantfönster} 
menuText W OptionsMovesSpace "Lägg till mellanslag efter dragnummer" 0 {Lägg till mellanslag efter dragnummer} 
menuText W OptionsMovesKey "Tangentkomplettering" 0 \
  {Starta/ stäng av dragkomplettering vid tangentinmatning}
menuText W OptionsMovesShowVarArrows "Visa pilar för variationer" 0 {Växlar på/av pilar som visar drag i variationer}
menuText W OptionsNumbers "Talformat" 3 {Välj hur tal visas}
menuText W OptionsStartup "Start" 3 {Välj vilka fönster som ska öppnas vid start}
menuText W OptionsTheme "Tema" 0 {Ändra utseende på gränssnitt}
menuText W OptionsWindows "Fönster" 1 {Fönsteralternativ}
menuText W OptionsWindowsIconify "Minimera automatiskt" 5 \
  {Minimera alla fönster när huvudfönstret minimeras}
menuText W OptionsWindowsRaise "Autofokus" 0 \
  {Visa åter vissa fönster (t ex. resultaträknare) automatiskt när de döljs}
menuText W OptionsSounds "Ljud..." 2 {Konfigurera ljud för att annonsera drag}
menuText W OptionsWindowsDock "Dockningsfönster" 0 {Dockningsfönster}
menuText W OptionsWindowsSaveLayout "Spara layout" 0 {Sparar layout}
menuText W OptionsWindowsRestoreLayout "Återställ layout" 0 {Återställer layout}
menuText W OptionsWindowsShowGameInfo "Visa partiinformation" 0 {Visar partiinformation}
menuText W OptionsWindowsAutoLoadLayout "Automatiskt öppna första layouten" 0 {Öppnar automatiskt första layouten vid uppstart}
# todo
menuText W OptionsWindowsAutoResize "Auto resize board" 0 {}
# ====== TODO To be translated ======
menuText W OptionsWindowsFullScreen "Fullscreen" 0 {Toggle fullscreen mode}
menuText W OptionsToolbar "Verktygsfält" 0 \
  {Visa/ dölj huvudfönstrets verktygsfält}
menuText W OptionsECO "Ladda ECO fil..." 7 {Ladda ECO-klassificeringen vid start}
menuText W OptionsSpell "Ladda Rättstavningsfil..." 7 \
  {Ladda rättstavningsfilen vid start}
menuText W OptionsTable "Katalog för slutspelsdatabaser..." 0 \
  {Välj en fil som innehåller en slutspelsdatabas; alla övriga filer i samma katalog kommer att användas}
menuText W OptionsRecent "Senast använda filer..." 16 \
  {Ãndra antalet senast använda filer som visas i Arkivmenyn}
menuText W OptionsBooksDir "Öppningsbokskatalog..." 0 {Anger Öppningsbokskatalogen}
menuText W OptionsTacticsBasesDir "Taktikbaskatalog..." 0 {Anger Taktikbaskatalog (för träning)}
menuText W OptionsSave "Spara alternativ" 7 \
  "Spara alla alternativ till en inställningsfil"
menuText W OptionsAutoSave "Autospara vid avslut" 1 \
  {Spara alla alternativ när du avslutar Scid}

# Help menu:
menuText W Help "Hjälp" 0
menuText W HelpContents "Innehåll" 0 {Visa innehåll}
menuText W HelpIndex "Index" 0 {Hjälpsystemets indexsida}
menuText W HelpGuide "Snabbguide" 0 {Visa snabbguiden}
menuText W HelpHints "Tips" 0 {Visa tips}
menuText W HelpContact "Kontaktinformation" 0 {Visa kontaktinformation}
menuText W HelpTip "Dagens tips" 0 {Användbara Scid tips}
menuText W HelpStartup "Startfönster" 5 {Visa startfönstret}
menuText W HelpAbout "Om Scid" 0 {Information om Scid}

# Game info box popup menu:
menuText W GInfoHideNext "Dölj nästa drag" 0
# ====== TODO To be translated ======
menuText W GInfoShow "Side to Move" 0
# ====== TODO To be translated ======
menuText W GInfoCoords "Toggle Coords" 0
menuText W GInfoMaterial "Visa materialvärden" 0
menuText W GInfoFEN "Visa FEN" 5
menuText W GInfoMarks "Visa färgade fält och pilar" 22
menuText W GInfoWrap "Radbrytning" 0
menuText W GInfoFullComment "Visa fullständiga kommentarer" 18
menuText W GInfoPhotos "Visa bilder" 5 ;
menuText W GInfoTBNothing "Slutspelsdatabaser: inget" 20
menuText W GInfoTBResult "Slutspelsdatabaser: endast resultat" 28
menuText W GInfoTBAll "Slutspelsdatabaser: resultat och bästa drag" 33
menuText W GInfoDelete "Återta/Radera detta parti" 0
menuText W GInfoMark "(Av-)Markera detta parti" 5
menuText W GInfoInformant "Konfigurera Informant-parametrar" 0
# ====== TODO To be translated ======
translate W FlipBoard {Flip board}
# ====== TODO To be translated ======
translate W RaiseWindows {Raise windows}
# ====== TODO To be translated ======
translate W AutoPlay {Autoplay}
# ====== TODO To be translated ======
translate W TrialMode {Trial mode}

# General buttons:
# ====== TODO To be translated ======
translate W Apply {Apply}
translate W Back {Tillbaka}
translate W Browse {Bläddra}
translate W Cancel {Avbryt}
translate W Continue {Fortsätt}
translate W Clear {Rensa}
translate W Close {Stäng}
translate W Contents {Innehåll}
translate W Defaults {Standard}
translate W Delete {Radera}
translate W Graph {Diagram}
translate W Help {Hjälp}
translate W Import {Importera}
translate W Index {Index}
translate W LoadGame {Ladda parti}
translate W BrowseGame {Bläddra genom partier}
translate W MergeGame {Slå samman parti}
translate W MergeGames {Slå samman partier}
translate W Preview {Förhandsgranska}
translate W Revert {Ångra inmatning}
translate W Save {Spara}
# ====== TODO To be translated ======
translate W DontSave {Don't Save}
translate W Search {Sök}
translate W Stop {Stoppa}
translate W Store {Spara}
translate W Update {Uppdatera}
translate W ChangeOrient {Ãndra fönstrets orientering}
translate W ShowIcons {Visa Ikoner} ;# ***
# ====== TODO To be translated ======
translate W ConfirmCopy {Confirm Copy}
translate W None {Ingen}
translate W First {Första}
translate W Current {Aktuella}
translate W Last {Sista}
# ====== TODO To be translated ======
translate W Font {Font}
# ====== TODO To be translated ======
translate W Change {Change}
# ====== TODO To be translated ======
translate W Random {Random}

# General messages:
translate W game {parti}
translate W games {partier}
translate W move {drag}
translate W moves {drag}
translate W all {alla}
translate W Yes {Ja}
translate W No {Nej}
translate W Both {Båda}
translate W King {Kung}
translate W Queen {Dam}
translate W Rook {Torn}
translate W Bishop {Löpare}
translate W Knight {Springare}
translate W Pawn {Bonde}
translate W White {Vit}
translate W Black {Svart}
translate W Player {Spelare}
translate W Rating {Rating}
translate W RatingDiff {Ratingskillnad (Vit - Svart)}
translate W AverageRating {Medelrating}
translate W Event {Evenemang}
translate W Site {Plats}
translate W Country {Land}
translate W IgnoreColors {Ignorera färger}
# ====== TODO To be translated ======
translate W MatchEnd {End pos only}
translate W Date {Datum}
translate W EventDate {Evenemangsdatum}
translate W Decade {Decennium}
translate W Year {År}
translate W Month {Månad}
translate W Months {Januari Februari Mars April Maj Juni Juli Augusti September Oktober November December}
translate W Days {Sön Mån Tis Ons Tor Fre Lör}
translate W YearToToday {Idag}
translate W Result {Resultat}
translate W Round {Rond}
translate W Length {Längd}
translate W ECOCode {ECO kod}
translate W ECO {ECO}
translate W Deleted {Raderad}
translate W SearchResults {Sökresultat}
translate W OpeningTheDatabase {Öppnar databas}
translate W Database {Databas}
translate W Filter {Filter}
# ====== TODO To be translated ======
translate W Reset {Reset}
translate W IgnoreCase {Ignorera textstorlek}
translate W noGames {inga partier}
translate W allGames {alla partier}
translate W empty {tom}
translate W clipbase {temporär databas}
translate W score {resultat}
translate W Start {Start}
translate W StartPos {Utgångsställning}
translate W Total {Totalt}
translate W readonly {bara läsbar} ;# ***
# ====== TODO To be translated ======
translate W altered {altered}
# ====== TODO To be translated ======
translate W tagsDescript {Extra tags (eg: Annotator "Anand")}
# ====== TODO To be translated ======
translate W prevTags {Use previous}

# Standard error messages:
translate W ErrNotOpen {Databasen är inte öppen.}
translate W ErrReadOnly {Databasen är skrivskyddad. Du kan inte ändra i den.}
translate W ErrSearchInterrupted {Sökningen avbröts; resultatet är inte fullständigt.}

# Game information:
translate W twin {dubblett}
translate W deleted {raderad}
translate W comment {kommentar}
translate W hidden {dold}
translate W LastMove {Senaste draget}
translate W NextMove {Nästa}
translate W GameStart {Utgångsställning}
translate W LineStart {Varianten börjar}
translate W GameEnd {Slutställning}
translate W LineEnd {Varianten slut}

# Player information:
translate W PInfoAll {alla partier}
translate W PInfoFilter {filtrerade partier}
translate W PInfoAgainst {Resultat mot}
translate W PInfoMostWhite {De vanligaste öppningarna som vit}
translate W PInfoMostBlack {De vanligaste öppningarna som svart}
translate W PInfoRating {Ratinghistoria}
translate W PInfoBio {Biografisk information}
translate W PInfoEditRatings {Redigera rating}
# ====== TODO To be translated ======
translate W PinfoEditName {Edit Name}
# ====== TODO To be translated ======
translate W PinfoLookupName {Lookup Name}

# Tablebase information:
translate W Draw {Remi}
translate W stalemate {patt}
# ====== TODO To be translated ======
translate W checkmate {checkmate}
translate W withAllMoves {med alla drag}
translate W withAllButOneMove {med alla drag utom ett}
translate W with {med}
translate W only {bara}
translate W lose {förlust}
translate W loses {förluster}
translate W allOthersLose {alla andra drag förlorar}
translate W matesIn {med matt i}
translate W longest {längst}
translate W WinningMoves {Vinstdrag}
translate W DrawingMoves {Remidrag}
translate W LosingMoves {Förlustdrag}
translate W UnknownMoves {Okänt resultat}

# Tip of the day:
translate W Tip {Tips}
translate W TipAtStartup {Tips vid start}

# Tree window menus:
menuText W TreeFile "Fil" 0
menuText W TreeFileFillWithBase "Fyll Cache med databas" 0 {Fyll Cachefilen med alla partier i den aktuella databasen}
menuText W TreeFileFillWithGame "Fyll Cache med parti" 0 {Fyll Cachefilen med aktuellt parti i den aktuella databasen}
menuText W TreeFileSetCacheSize "Cachestorlek" 0 {Ange Cachestorleken}
menuText W TreeFileCacheInfo "Cacheinformation" 0 {Få information om Cacheanvändning}
menuText W TreeFileSave "Spara cachefil" 0 {Spara trädcache (*.stc)-filen}
menuText W TreeFileFill "Fyll cachefil" 0 \
{Fyll cachefilen med vanliga öppningar}
menuText W TreeFileBest "Lista bästa partier" 0 {Visa lista över de bästa partierna i trädet}
menuText W TreeFileGraph "Diagramfönster" 0 {Visa diagrammet för denna gren i trädet}
menuText W TreeFileCopy "Kopiera träd till urklipp" 1 \
  {Kopierar trädrelaterad statistik till urklipp}
menuText W TreeFileClose "Stäng trädfönstret" 0 {Stäng trädfönstret}
menuText W TreeMask "Sökmask" 0
menuText W TreeMaskNew "Ny" 0 {Ny sökmask}
menuText W TreeMaskOpen "Öppna" 0 {Öppna sökmask}
menuText W TreeMaskOpenRecent "Öppna senaste" 0 {Öppna senaste sökmasken}
menuText W TreeMaskSave "Spara" 0 {Spara sökmask}
menuText W TreeMaskClose "Stäng" 0 {Stäng sökmask}
# ====== TODO To be translated ======
menuText W TreeMaskFillWithLine "Fill with line" 0 {Fill mask with all previous moves}
menuText W TreeMaskFillWithGame "Fyll med parti" 0 {Fyll sökmask med parti}
menuText W TreeMaskFillWithBase "Fyll med databas" 0 {Fyll sökmask med alla partier i databasen}
menuText W TreeMaskInfo "Info om sökmask" 0 {Visa statistik för aktuell sökmask}
menuText W TreeMaskDisplay "Visa sökmaskkarta" 0 {Visa sökmaskdata i trädform}
menuText W TreeMaskSearch "Sök" 0 {Sök i aktuell sökmask}
menuText W TreeSort "Sortera" 0
menuText W TreeSortAlpha "Alfabetiskt" 0
menuText W TreeSortECO "ECO kod" 0
menuText W TreeSortFreq "Frekvens" 0
menuText W TreeSortScore "Resultat" 0
menuText W TreeOpt "Alternativ" 0
menuText W TreeOptSlowmode "Långsam mod" 0 {Långsam mod för uppdateringar (hög noggrannhet)}
menuText W TreeOptFastmode "Snabb mod" 0 {Snabb mod för uppdateringar (ingen dragtranspositionering)}
menuText W TreeOptFastAndSlowmode "Snabb och långsam mod" 0 {Snabb mod sedan långsam mod för uppdateringar}
menuText W TreeOptStartStop "Automatisk uppdatering" 0 {Växlar automatisk uppdatering av trädfönstret}
menuText W TreeOptLock "Lås" 0 {Lås/ lås upp trädet för den aktuella databasen}
menuText W TreeOptTraining "Träna" 0 {Starta/ stäng av träningsläge}
# ====== TODO To be translated ======
menuText W TreeOptShort "Short Display" 0 {Don't show ELO information}
menuText W TreeOptAutosave "Spara cache filen automatiskt" 0 \
  {Spara cachefilen automatiskt när trädfönstret stängs}
# ====== TODO To be translated ======
menuText W TreeOptAutomask "Auto-Load Mask" 0 "Auto-Load most recent mask with a tree open."
# ====== TODO To be translated ======
menuText W TreeOptShowBar "Show Progress Bar" 0 "Show tree progress bar."
# ====== TODO To be translated ======
menuText W TreeOptSortBest "Sort Best Games" 0 "Sort Best Games by ELO."
menuText W TreeHelp "Hjälp" 0
menuText W TreeHelpTree "Trädhjälp" 0
menuText W TreeHelpIndex "Hjälpindex" 0

translate W SaveCache {Spara cache}
translate W Training {Träna}
translate W LockTree {Lås}
translate W TreeLocked {Låst}
translate W TreeBest {Bäst}
translate W TreeBestGames {Bästa partier i trädet}
# ====== TODO To be translated ======
translate W TreeAdjust {Adjust Filter}
# Note: the next message is the tree window title row. After editing it,
# check the tree window to make sure it lines up with the actual columns.
translate W TreeTitleRow { Drag       Frekvens        Res.  Remi   Elo~  Nivå År~ ECO}
translate W TreeTitleRowShort { Drag       Frekvens        Res. Remi}
translate W TreeTotal {TOTALT}
translate W DoYouWantToSaveFirst {Vill du spara först}
translate W AddToMask {Lägg till i Sökmask}
translate W RemoveFromMask {Ta bort från Sökmask}
# TODO
translate W AddThisMoveToMask {Add Move to Mask}
translate W SearchMask {Sök i sökmask}
translate W DisplayMask {Visa sökmask}
translate W Nag {NAG-kod}
translate W Marker {Markera}
translate W Include {Inkludera}
translate W Exclude {Exkludera}
translate W MainLine {Huvudvariant}
translate W Bookmark {Bokmärke}
translate W NewLine {Ny variant}
translate W ToBeVerified {Att bli verifierad}
translate W ToTrain {Att träna}
translate W Dubious {Tveksam}
translate W ToRemove {Att ta bort}
translate W NoMarker {Ingen markering}
translate W ColorMarker {Färg}
translate W WhiteMark {Vit}
translate W GreenMark {Grön}
translate W YellowMark {Gul}
translate W BlueMark {Blå}
translate W RedMark {Röd}
translate W CommentMove {Kommentera drag}
translate W CommentPosition {Kommentera position}
translate W AddMoveToMaskFirst {Lägg till drag till sökmask först}
translate W OpenAMaskFileFirst {Öppna en sökmaskmaskfil först}
translate W Positions {Positioner}
translate W Moves {Drag}

# Finder window:
menuText W FinderFile "Fil" 0
menuText W FinderFileSubdirs "Sök i underkataloger" 0
menuText W FinderFileClose "Stäng Filsökaren" 0
menuText W FinderSort "Sortera" 0
menuText W FinderSortType "Typ" 0
menuText W FinderSortSize "Storlek" 0
menuText W FinderSortMod "Förändrad" 0
menuText W FinderSortName "Namn" 0
menuText W FinderSortPath "Sökväg" 0
menuText W FinderTypes "Typer" 0
menuText W FinderTypesScid "Sciddatabaser" 0
menuText W FinderTypesOld "Sciddatabaser i äldre format" 0
menuText W FinderTypesPGN "PGN-filer" 0
menuText W FinderTypesEPD "EPD-filer" 0
menuText W FinderHelp "Hjälp" 0
menuText W FinderHelpFinder "Hjälp för Filsökaren" 0
menuText W FinderHelpIndex "Hjälpindex" 0
translate W FileFinder {Filsökaren}
translate W FinderDir {Katalog}
translate W FinderDirs {Kataloger}
translate W FinderFiles {Filer}
translate W FinderUpDir {upp}
translate W FinderCtxOpen {Öppna}
translate W FinderCtxBackup {Spara}
translate W FinderCtxCopy {Kopiera}
translate W FinderCtxMove {Flytta}
translate W FinderCtxDelete {Ta bort}

# Player finder:
menuText W PListFile "Fil" 0
menuText W PListFileUpdate "Uppdatera" 0
menuText W PListFileClose "Stäng spelarförteckningen" 1
menuText W PListSort "Sortera" 0
menuText W PListSortName "Namn" 0
menuText W PListSortElo "Elo" 0
menuText W PListSortGames "Partier" 0
menuText W PListSortOldest "Äldst" 0
menuText W PListSortNewest "Yngst" 0

# Tournament finder:
menuText W TmtFile "Fil" 0
menuText W TmtFileUpdate "Uppdatera" 0
menuText W TmtFileClose "Stäng turneringshanteraren" 0
menuText W TmtSort "Sortera" 0
menuText W TmtSortDate "Datum" 0
menuText W TmtSortPlayers "Spelare" 0
menuText W TmtSortGames "Partier" 0
menuText W TmtSortElo "Elo" 0
menuText W TmtSortSite "Plats" 0
menuText W TmtSortEvent "Evenemang" 1
menuText W TmtSortWinner "Vinnare" 0
translate W TmtLimit "Listbegränsningar"
translate W TmtMeanElo "Lägsta snitt Elo"
translate W TmtNone "Inga turneringar hittades."

# Graph windows:
menuText W GraphFile "Fil" 0
menuText W GraphFileColor "Spara som Postscript (i färg)" 8
menuText W GraphFileGrey "Spara som Postscript (i gråskala)" 8
menuText W GraphFileClose "Stäng fönster" 6
menuText W GraphOptions "Alternativ" 0
menuText W GraphOptionsWhite "Vit" 0
menuText W GraphOptionsBlack "Svart" 0
menuText W GraphOptionsBoth "Båda" 1
menuText W GraphOptionsPInfo "Spelarinformation" 0
translate W GraphFilterTitle "Filterdiagram: antal per 1000 partier"
translate W GraphAbsFilterTitle "Filtergraf: frekvens för partierna"
translate W ConfigureFilter {Konfigurera X-axlar för År, Rating och Drag}
translate W FilterEstimate "Uppskatta"
translate W TitleFilterGraph "Scid: Filtergraf"

# Analysis window:
translate W AddVariation {Lägg till variation}
translate W AddAllVariations {Lägg till alla variationer}
translate W AddMove {Lägg till drag}
translate W Annotate {Kommentera}
translate W ShowAnalysisBoard {Visa Analysbräde}
translate W ShowInfo {Visa schackmotorinformation}
translate W FinishGame {Avsluta parti}
translate W StopEngine {Stoppa schackmotor}
translate W StartEngine {Starta schackmotor}
# ====== TODO To be translated ======
translate W ExcludeMove {Exclude Move}
translate W LockEngine {Lås schackmotor vid nuvarande position}
translate W AnalysisCommand {Analysera}
translate W PreviousChoices {Föregående val}
translate W AnnotateTime {Ange tid mellan drag i sekunder}
translate W AnnotateWhich {Lägg till variationer}
translate W AnnotateAll {För båda sidors drag}
translate W AnnotateAllMoves {Kommentera alla drag}
translate W AnnotateWhite {Endast vits drag}
translate W AnnotateBlack {Endast svarts drag}
translate W AnnotateNotBest {När partidraget inte är det bästa}
translate W AnnotateBlundersOnly {När partidraget är en uppenbar blunder}
# ====== TODO To be translated ======
translate W BlundersNotBest {Blunders/Not Best}
translate W AnnotateBlundersOnlyScoreChange {Analysen rapporterar blunder, med värderingsförändringar från/till}
translate W AnnotateTitle {Konfigurera Anteckningar}
translate W BlundersThreshold {Tröskelvärde}
# ====== TODO To be translated ======
translate W ScoreFormat {Score format}
# ====== TODO To be translated ======
translate W CutOff {Cut Off}
translate W LowPriority {Kör som lågprioriterad process}
# ====== TODO To be translated ======
translate W LogEngines {Log Size}
# ====== TODO To be translated ======
translate W LogName {Add Name}
# ====== TODO To be translated ======
translate W MaxPly {Max Ply}
translate W ClickHereToSeeMoves {Klicka här för att se drag}
translate W ConfigureInformant {Konfigurera Informant-parametrar}
translate W Informant!? {Intressant drag}
translate W Informant? {Dåligt drag}
translate W Informant?? {Blunder}
translate W Informant?! {Tveksamt drag}
translate W Informant+= {Vit har en mindre fördel}
translate W Informant+/- {Vit har en liten fördel}
translate W Informant+- {Vit har en avgörande fördel}
translate W Informant++- {Partiet anses vara vunnet}
translate W Book {Bok}

# Analysis Engine open dialog:
translate W EngineList {Lista över schackprogram}
# ====== TODO To be translated ======
translate W EngineKey {Key}
# ====== TODO To be translated ======
translate W EngineType {Type}
translate W EngineName {Namn}
translate W EngineCmd {Startkommando}
translate W EngineArgs {Parametrar}
translate W EngineDir {Katalog}
translate W EngineElo {Elo}
translate W EngineTime {Datum}
translate W EngineNew {Ny}
translate W EngineEdit {Redigera}
translate W EngineRequired {Fet stil indikerar obligatoriska fält; övriga fält är frivilliga}

# Stats window menus:
menuText W StatsFile "Fil" 0
menuText W StatsFilePrint "Skriv ut till fil..." 0
menuText W StatsFileClose "Stäng fönster" 0
menuText W StatsOpt "Alternativ" 0

# PGN window menus:
menuText W PgnFile "Fil" 0
menuText W PgnFileCopy "Kopiera partiet till Clipbase" 0
menuText W PgnFilePrint "Skriv ut till..." 0
menuText W PgnFileClose "Stäng PGN-fönster" 0
menuText W PgnOpt "Presentation" 0
menuText W PgnOptColor "Färg" 0
menuText W PgnOptShort "Kort (3-raders) huvud" 0
menuText W PgnOptSymbols "Symbolbaserad kommentar" 1
menuText W PgnOptIndentC "Indragna kommentarer" 0
menuText W PgnOptIndentV "Indragna variationer" 7
menuText W PgnOptColumn "Spaltstil (ett drag per rad)" 1
menuText W PgnOptSpace "Utrymme efter dragnummer" 1
menuText W PgnOptStripMarks "Avlägsna koder för färgade fält och pilar" 1
menuText W PgnOptChess "Schack Pieces" 0
menuText W PgnOptScrollbar "Rullningslist" 0
menuText W PgnOptBoldMainLine "Använd Fet Text för Huvudvariationsdrag" 4
menuText W PgnColor "Färger" 0
menuText W PgnColorHeader "Huvud..." 0
menuText W PgnColorAnno "Noteringar..." 0
menuText W PgnColorComments "Kommentarer..." 0
menuText W PgnColorVars "Variationer..." 0
menuText W PgnColorBackground "Bakgrund..." 0
menuText W PgnColorMain "Huvudvariation..." 0
menuText W PgnColorCurrent "Aktuellt drag bakgrund..." 1
menuText W PgnColorNextMove "Nästa drag bakgrund..." 0
menuText W PgnHelp "Hjälp" 0
menuText W PgnHelpPgn "PGN-hjälp" 0
menuText W PgnHelpIndex "Index" 0
translate W PgnWindowTitle {PGN-version av partiet %u}

# Crosstable window menus:
menuText W CrosstabFile "Fil" 0
menuText W CrosstabFileText "Skriv ut till textfil..." 9
menuText W CrosstabFileHtml "Skriv ut till HTML-fil..." 9
menuText W CrosstabFileLaTeX "Skriv ut till LaTeX-fil..." 9
menuText W CrosstabFileClose "Stäng resultattabellsfönstret" 0
menuText W CrosstabEdit "Redigera" 0
menuText W CrosstabEditEvent "Evenemang" 0
menuText W CrosstabEditSite "Plats" 0
menuText W CrosstabEditDate "Datum" 0
menuText W CrosstabOpt "Presentation" 0
menuText W CrosstabOptColorPlain "Ren text" 0
menuText W CrosstabOptColorHyper "Hypertext" 0
# ====== TODO To be translated ======
menuText W CrosstabOptTieWin "Tie-Break by wins" 1
# ====== TODO To be translated ======
menuText W CrosstabOptTieHead "Tie-Break by head-head" 1
menuText W CrosstabOptThreeWin "3 poäng för vinst" 1
menuText W CrosstabOptAges "Ålder i år" 8
menuText W CrosstabOptNats "Nationalitet" 0
# todo
menuText W CrosstabOptTallies "Win/Loss/Draw" 0
menuText W CrosstabOptRatings "Rating" 0
menuText W CrosstabOptTitles "Titlar" 0
menuText W CrosstabOptBreaks "Tie-break poäng" 4
menuText W CrosstabOptDeleted "Inkludera raderade partier" 8
menuText W CrosstabOptColors "Färg (endast Schweizer)" 0
# ====== TODO To be translated ======
menuText W CrosstabOptColorRows "Color Rows" 0
menuText W CrosstabOptColumnNumbers "Numrerade kolumner (Endast alla-mot-alla)" 2
menuText W CrosstabOptGroup "Gruppresultat" 0
menuText W CrosstabSort "Sortera" 0
menuText W CrosstabSortName "Namn" 0
menuText W CrosstabSortRating "Rating" 0
menuText W CrosstabSortScore "Resultat" 0
menuText W CrosstabSortCountry "Land" 0
# todo
menuText W CrosstabType "Format" 0
menuText W CrosstabTypeAll "Alla-möter-alla" 0
menuText W CrosstabTypeSwiss "Schweizer" 0
menuText W CrosstabTypeKnockout "Knock Out" 0
menuText W CrosstabTypeAuto "Auto" 1
menuText W CrosstabHelp "Hjälp" 0
menuText W CrosstabHelpCross "Hjälp för resultattabell" 0
menuText W CrosstabHelpIndex "Hjälpindex" 0
translate W SetFilter {Bestäm filter}
translate W AddToFilter {Utöka filter}
translate W Swiss {Schweizer}
translate W Category {Kategori}

# Opening report window menus:
menuText W OprepFile "Fil" 0
menuText W OprepFileText "Skriv ut till textfil..." 9
menuText W OprepFileHtml "Skriv ut till HTML-fil..." 9
menuText W OprepFileLaTeX "Skriv ut till LaTeX-fil..." 9
menuText W OprepFileOptions "Alternativ..." 0
menuText W OprepFileClose "Stäng rapportfönstret" 0
menuText W OprepFavorites "Favoriter" 1
menuText W OprepFavoritesAdd "Lägg till rapport..." 0
menuText W OprepFavoritesEdit "Redigera favoritrapport..." 0
menuText W OprepFavoritesGenerate "Skapa rapport..." 0
menuText W OprepHelp "Hjälp" 0
menuText W OprepHelpReport "Hjälp för öppningsrapporter" 0
menuText W OprepHelpIndex "Hjälpindex" 0

# Header search:
translate W HeaderSearch {Sök i partihuvud}
translate W EndSideToMove {Sida vid draget vid slutet av partiet}
translate W GamesWithNoECO {Partier utan ECO-kod?}
translate W GameLength {Partilängd}
translate W FindGamesWith {Hitta flaggade partier}
translate W StdStart {Normal utgångsställning}
translate W Promotions {Förvandlingar}
# ====== TODO To be translated ======
translate W UnderPromo {Under Prom.}
translate W Comments {Kommentarer}
translate W Variations {Variationer}
translate W Annotations {Noteringar}
translate W DeleteFlag {Raderingsflagga}
translate W WhiteOpFlag {Vits öppning}
translate W BlackOpFlag {Svarts öppning}
translate W MiddlegameFlag {Mittspel}
translate W EndgameFlag {Slutspel}
translate W NoveltyFlag {Nyhet}
translate W PawnFlag {Bondestruktur}
translate W TacticsFlag {Taktiska ställningar}
translate W QsideFlag {Damflygelsinitiativ}
translate W KsideFlag {Kungsflygelsinitiativ}
translate W BrilliancyFlag {Utmärkt parti}
translate W BlunderFlag {Bortsättningar}
translate W UserFlag {Användare}
translate W PgnContains {PGN innehåller text}

# Game list window:
translate W GlistNumber {Nummer}
translate W GlistWhite {Vit}
translate W GlistBlack {Svart}
translate W GlistWElo {Elo, vit}
translate W GlistBElo {Elo, svart}
translate W GlistEvent {Evenemang}
translate W GlistSite {Plats}
translate W GlistRound {Rond}
translate W GlistDate {Datum}
translate W GlistYear {År}
translate W GlistEventDate {Startdatum}
translate W GlistResult {Resultat}
translate W GlistLength {Längd}
translate W GlistCountry {Land}
translate W GlistECO {ECO}
translate W GlistOpening {Öppning}
translate W GlistEndMaterial {Slutmaterial}
translate W GlistDeleted {Raderad}
translate W GlistFlags {Flaggor}
translate W GlistVariations {Variationer}
translate W GlistComments {Kommentarer}
translate W GlistAnnos {Noteringar}
translate W GlistStart {Start}
translate W GlistGameNumber {Partinummer}
translate W GlistFindText {Sök text}
translate W GlistMoveField {Drag}
translate W GlistEditField {Konfiguration}
translate W GlistAddField {Lägg till}
translate W GlistDeleteField {Ta bort}
translate W GlistColor {Färg}
# ====== TODO To be translated ======
translate W GlistSort {Sort database}
translate W GlistRemoveThisGameFromFilter  {Ta bort}
translate W GlistRemoveGameAndAboveFromFilter  {Ta bort parti (och alla ovanför det)}
translate W GlistRemoveGameAndBelowFromFilter  {Ta bort parti (och alla nedanför det)}
translate W GlistDeleteGame {Ta tillbaka detta parti}
translate W GlistDeleteAllGames {Ta bort alla partier i filtret}
translate W GlistUndeleteAllGames {Ta tillbaka alla partier i filtret}
# ====== TODO To be translated ======
translate W GlistAlignL {Align left}
# ====== TODO To be translated ======
translate W GlistAlignR {Align right}
# ====== TODO To be translated ======
translate W GlistAlignC {Align center}

# Maintenance window:
translate W DatabaseName {Databasnamn:}
translate W TypeIcon {Ikontyp}
translate W NumOfGames {Partier:}
translate W NumDeletedGames {Raderade partier:}
translate W NumFilterGames {Partier i filter:}
translate W YearRange {Tidsperiod:}
translate W RatingRange {Ratingintervall:}
translate W Description {Beskrivning}
translate W Flag {Flagga}
translate W CustomFlags {Anpassade flaggor}
translate W DeleteCurrent {Ta bort aktuellt parti}
translate W DeleteFilter {Ta bort partierna i filtret}
translate W DeleteAll {Ta bort alla partier}
translate W UndeleteCurrent {Återta aktuellt parti}
translate W UndeleteFilter {Återta partierna i filtret}
translate W UndeleteAll {Återta alla partier}
translate W DeleteTwins {Ta bort dubbletter}
translate W MarkCurrent {Markera aktuellt parti}
translate W MarkFilter {Markera partierna i filtret}
translate W MarkAll {Markera alla partier}
translate W UnmarkCurrent {Avmarkera aktuellt parti}
translate W UnmarkFilter {Avmarkera partierna i filtret}
translate W UnmarkAll {Avmarkera alla partier}
translate W Spellchecking {Rättstava}
# ====== TODO To be translated ======
translate W MakeCorrections {Make Corrections}
# ====== TODO To be translated ======
translate W Ambiguous {Ambiguous}
# ====== TODO To be translated ======
translate W Surnames {Surnames}
translate W Players {Spelare}
translate W Events {Evenemang}
translate W Sites {Platser}
translate W Rounds {Ronder}
translate W DatabaseOps {Databashantering}
translate W ReclassifyGames {ECO-klassificera partier}
translate W CompactDatabase {Komprimera databasen}
translate W SortDatabase {Sortera databasen}
translate W AddEloRatings {Lägg till Elorating}
translate W AutoloadGame {Ladda partinummer automatiskt}
translate W StripTags {Avlägsna PGN-taggar}
translate W StripTag {Avlägsna taggar}
translate W CheckGames {Kontrollera partier}
translate W Cleaner {Snygga till databasen}
translate W CleanerHelp {
Databasstädaren i Scid genomför allt det underhåll av databasen du väljer nedan på den aktiva databasen.

De nuvarande inställningarna i ECO-klassificering och Radera dubbletter kommer att appliceras om du väljer dessa åtgärder.
}
translate W CleanerConfirm {
När du väl startat Databasstädaren kan du inte avbryta den!

På en stor databas kan detta ta ett bra tag. Tidsåtgången beror på valda åtgärder och deras inställningar.

Ãr du säker på att du vill påbörja databasunderhållet nu?
}
translate W TwinCheckUndelete {att växla; "u" tar tillbaka båda)}
translate W TwinCheckprevPair {Tidigare par}
translate W TwinChecknextPair {Nästa par}
translate W TwinChecker {Scid: Dublettpartikontrollerare}
translate W TwinCheckTournament {Partier i turnering:}
translate W TwinCheckNoTwin {Ingen dublett  }
translate W TwinCheckNoTwinfound {Ingen dublett detekterades för detta parti.\nFör att visa dubletter med detta fönster, måste du först använda "Ta bort dublettpartier..."-funktionen. }
translate W TwinCheckTag {Dela taggar...}
translate W TwinCheckFound1 {Scid hittade $result dublettpartier}
translate W TwinCheckFound2 { och ange deras borttagningsflaggor}
translate W TwinCheckNoDelete {Det finns inga partier i denna databas att ta bort.}
translate W TwinCriteria1 { Dina inställningar för att hitta dublettpartier är potentiellt sannorlika att\norsaka att icke-dublettpartier med liknande drag blir markerade som dubletter.}
translate W TwinCriteria2 {Det är rekommenderat att om du väljer "Nej" för "samma drag" och att du väljer "Ja" för Färger, Evenemang, Plats, Runda, År och Månads inställningar.\nVill du fortsätta och ta bort dubletter ändå? }
translate W TwinCriteria3 {Det är rekommenderat att du specificerar "Ja" för åtminstonde två av "samma plats", "samma runda" och "samma år" inställningar.\nVill du fortsätta och ta bort dubletter ändå?}
translate W TwinCriteriaConfirm {Scid: Bekräfta dublettinställningar}
translate W TwinChangeTag "Ändra följande partitaggar:\n\n"
translate W AllocRatingDescription "Detta kommando kommer att använda den aktuella stavningskontrollfilen för att lägga till Elo-rating till partier i denna databas. Där en spelare inte har en aktuell rating men hans/hennes rating vid tiden för partiet är listat i stavningskontrollfilen, kommer denna rating att läggas till."
translate W RatingOverride "Skriv över existerande inte-noll rating?"
translate W AddRatings "Lägg till rating till:"
translate W AddedRatings {Scid lade till $r Elo-ratingar i $g partier.}
translate W NewSubmenu "Ny undermeny"

# Comment editor:
translate W AnnotationSymbols  {Symboler:}
translate W Comment {Kommentar:}
translate W InsertMark {Infoga symbol}
translate W InsertMarkHelp {
Infoga/ta bort markering: Välj färg, typ av markering samt ruta.
Infoga/ta bort pil: Höger-klicka två rutor.
}

# Nag buttons in comment editor:
translate W GoodMove {Bra drag}
translate W PoorMove {Dåligt drag}
translate W ExcellentMove {Utmärkt drag}
translate W Blunder {Blunder}
translate W InterestingMove {Intressant drag}
translate W DubiousMove {Tveksamt drag}
translate W WhiteDecisiveAdvantage {Vit har en avgörande fördel}
translate W BlackDecisiveAdvantage {Svart har en avgörande fördel}
translate W WhiteClearAdvantage {Vit har en klar fördel}
translate W BlackClearAdvantage {Svart har en klar fördel}
translate W WhiteSlightAdvantage {Vit har en liten fördel}
translate W BlackSlightAdvantage {Svart har en liten fördel}
translate W Equality {Jämnvikt}
translate W Unclear {Oklar}
translate W Diagram {Diagram}

# Board search:
translate W BoardSearch {Positionssökningar}
translate W FilterOperation {Hantering av aktuellt filter:}
translate W FilterAnd {AND (Restriktivt filter)}
translate W FilterOr {OR (Ackumulativt filter)}
translate W FilterIgnore {IGNORE (Använd ej filter)}
translate W SearchType {Söktyp:}
translate W SearchBoardExact {Exakt position (alla pjäser på samma rutor)}
translate W SearchBoardPawns {Bönder (samma material, alla bönder på samma rutor)}
translate W SearchBoardFiles {Filer (samma material, alla bönder på samma filer)}
translate W SearchBoardAny {Obestämt (samma material, bönder och pjäser på valfria rutor)}
translate W SearchInRefDatabase {Sök i databas}
translate W LookInVars {Sök i variationer}

# Material search:
translate W MaterialSearch {Materialsökning}
translate W Material {Material}
translate W Patterns {Ställningar}
translate W Zero {Inga/-en}
translate W Any {Flera}
translate W CurrentBoard {Aktuell ställning}
translate W CommonEndings {Vanliga slutspel}
translate W CommonPatterns {Vanliga ställningar}
translate W MaterialDiff {Skillnad i material}
translate W squares {rutor}
translate W SameColor {Samma färg}
translate W OppColor {Motsatt färg}
translate W Either {Antingen eller}
translate W MoveNumberRange {Dragintervall}
translate W MatchForAtLeast {Träffa minst}
translate W HalfMoves {halvdrag}

# Common endings in material search:
translate W EndingPawns {Bondeslutspel}
translate W EndingRookVsPawns {Torn mot Bonde (Bönder)}
translate W EndingRookPawnVsRook {Torn och 1 Bonde mot Torn}
translate W EndingRookPawnsVsRook {Torn och Bonde (Bönder) mot Torn}
translate W EndingRooks {Torn mot Torn slutspel}
translate W EndingRooksPassedA {Torn mot Torn slutspel med en fri a-bonde}
translate W EndingRooksDouble {Dubbla Torn slutspel}
translate W EndingBishops {Löpare mot Löpare slutspel}
translate W EndingBishopVsKnight {Löpare mot Springare slutspel}
translate W EndingKnights {Springare mot Springare slutspel}
translate W EndingQueens {Dam mot Dam slutspel}
translate W EndingQueenPawnVsQueen {Dam och 1 Bonde mot Dam}
translate W BishopPairVsKnightPair {Två Löpare mot Två Springare mittspel}

# Common patterns in material search:
translate W PatternWhiteIQP {Vit Isolerad dambonde}
translate W PatternWhiteIQPBreakE6 {Vit Isolerad dambonde: d4-d5 brott mot e6}
translate W PatternWhiteIQPBreakC6 {Vit Isolerad dambonde: d4-d5 brott mot c6}
translate W PatternBlackIQP {Svart Isolerad dambonde}
translate W PatternWhiteBlackIQP {Vit Isolerad dambonde mot Svart Isolerad dambonde}
translate W PatternCoupleC3D4 {Vit c3+d4 Isolaterat Bondepar}
translate W PatternHangingC5D5 {Svart Hängande Bönder på c5 och d5}
translate W PatternMaroczy {Maroczycenter (med Bönder på c4 och e4)}
translate W PatternRookSacC3 {Tornoffer på c3}
translate W PatternKc1Kg8 {O-O-O mot O-O (Kc1 mot Kg8)}
translate W PatternKg1Kc8 {O-O mot O-O-O (Kg1 mot Kc8)}
translate W PatternLightFian {Ljus-Ruta Fianchetton (Löpare-g2 mot Löpare-b7)}
translate W PatternDarkFian {Mörk-Ruta Fianchetton (Löpare-b2 mot Löpare-g7)}
translate W PatternFourFian {Fyra Fianchetton (Löpare på b2,g2,b7,g7)}

# Game saving:
translate W Today {Idag}
translate W ClassifyGame {Klassificera parti}

# Setup position:
translate W EmptyBoard {Töm brädet}
translate W InitialBoard {Utgångsställning}
translate W SideToMove {Färg vid draget}
translate W MoveNumber {Antal drag}
translate W Castling {Rockad}
translate W EnPassantFile {En Passant fil}
translate W ClearFen {Rensa FEN}
translate W PasteFen {Klistra in FEN}
translate W SaveAndContinue {Spara och fortsätt}
translate W DiscardChangesAndContinue {Ignorera Ändringar}
translate W GoBack {Gå tillbaka}

# Replace move dialog:
translate W ReplaceMove {Ersätt drag}
translate W AddNewVar {Lägg till ny variation}
translate W NewMainLine {Ny huvudvariation}
translate W ReplaceMoveMessage {Det finns redan ett drag i denna ställning.

Du kan ersätta detta drag, och förlora samtliga följande, eller lägga till ditt drag som en ny variation.

(Om du stänger av "Fråga före ersätt drag" i Alternativ:Drag menyn slipper du denna fråga i framtiden.)}

# Make database read-only dialog:
translate W ReadOnlyDialog {Om du ger denna databas endast läsbar kan du inte göra några ändringar i den.
Inga partier kan sparas eller ersättas, och du kan inte ändra flaggor för raderbara partier.
Alla sorteringsinställningar eller ECO-klassificeringar kommer att vara temporära.

Du kan göra den skrivbar igen genom att helt enkelt stänga och öppna den igen.

Vill du verkligen ange att databasen endast ska vara läsbar?}

# Exit dialog:
translate W ExitDialog {Vill du verkligen avsluta Scid?}
# ====== TODO To be translated ======
translate W ClearGameDialog {This game has been altered.\nDo you wish to save it?}
translate W ExitUnsaved {De följande databaserna har osparade förändringar. Om du avslutar nu, kommer dessa förändringar att gå förlorade.}

# Import window:
translate W PasteCurrentGame {Klistra in aktuellt parti}
translate W ImportHelp1 {Ange eller klistra in ett parti i PGN-format i området ovan.}
translate W ImportHelp2 {Eventuella felaktigheter kommer att anges här.}
translate W OverwriteExistingMoves {Skriv över existerande drag ?}

# ECO Browser:
translate W ECOAllSections {alla ECO avdelningar}
translate W ECOSection {ECO avdelning}
translate W ECOSummary {Sammanfattning för}
translate W ECOFrequency {Underkodsfrekvens för}

# Opening Report:
translate W OprepTitle {Öppningsrapport}
translate W OprepReport {Rapport}
translate W OprepGenerated {Skapad av}
translate W OprepStatsHist {Statistik och historik}
translate W OprepStats {Statistik}
translate W OprepStatAll {Rapporterade partier}
translate W OprepStatBoth {Båda med rating}
translate W OprepStatSince {Sedan}
translate W OprepOldest {De äldsta partierna}
translate W OprepNewest {De yngsta partierna}
translate W OprepPopular {Aktuell popularitet}
translate W OprepFreqAll {Frekvens totalt:   }
translate W OprepFreq1   {Under det senaste året: }
translate W OprepFreq5   {Under de 5 senaste åren: }
translate W OprepFreq10  {Under de 10 senaste åren: }
translate W OprepEvery {en gång var %u parti}
translate W OprepUp {ökat %u%s gentemot samtliga år}
translate W OprepDown {minskat %u%s gentemot samtliga år}
translate W OprepSame {ingen förändring gentemot samtliga år}
translate W OprepMostFrequent {Spelas mest av}
translate W OprepMostFrequentOpponents {Vanligaste motståndaren}
translate W OprepRatingsPerf {Rating och resultat}
translate W OprepAvgPerf {Genomsnittrating och resultat}
translate W OprepWRating {Vits rating}
translate W OprepBRating {Svarts rating}
translate W OprepWPerf {Vits resultat}
translate W OprepBPerf {Svarts resultat}
translate W OprepHighRating {Partierna med högst genomsnittsrating}
translate W OprepTrends {Resultattrender}
translate W OprepResults {Längd och frekvens}
translate W OprepLength {Partiets längd}
translate W OprepFrequency {Frekvens}
translate W OprepWWins {Vita vinster: }
translate W OprepBWins {Svarta vinster: }
translate W OprepDraws {Remier:      }
translate W OprepWholeDB {Hela databasen}
translate W OprepShortest {Kortaste vinster}
# translate W OprepShortWhite {De kortaste vita vinsterna}
# translate W OprepShortBlack {De kortaste svarta vinsterna}
translate W OprepMovesThemes {Drag och teman}
translate W OprepMoveOrders {Dragordning för att nå rapportställningen}
translate W OprepMoveOrdersOne \
  {Ställningen nåddes bara genom en dragordning:}
translate W OprepMoveOrdersAll \
  {Det fanns %u dragordningar som ledde fram denna ställning:}
translate W OprepMoveOrdersMany \
  {Det fanns %u dragordningar som ledde fram denna ställning. De %u vanligaste är:}
translate W OprepMovesFrom {Drag från rapportställningen}
translate W OprepMostFrequentEcoCodes {De mest förekommande ECO-koderna}
translate W OprepThemes {Positionella teman}
translate W OprepThemeDescription {Temanfrekvens de första %u dragen av varje parti}
# translate W OprepThemeDescription {Antal teman vid drag %u}
translate W OprepThemeSameCastling {Rockad på samma flygel}
translate W OprepThemeOppCastling {Rockad på olika flyglar}
translate W OprepThemeNoCastling {Ingen har gjort rockad}
translate W OprepThemeKPawnStorm {Bondestorm på kungsflygeln}
translate W OprepThemeQueenswap {Dambyte}
translate W OprepThemeWIQP {Isolerad vit dambonde}
translate W OprepThemeBIQP {Isolerad svart dambonde}
translate W OprepThemeWP567 {Vit bonde på 5e/6e/7e raden}
translate W OprepThemeBP234 {Svart bonde på 2a/3e/4e raden}
translate W OprepThemeOpenCDE {Öppen c/d/e linje}
translate W OprepTheme1BishopPair {Endast den ena sidan har löparparet}
translate W OprepEndgames {Slutspel}
translate W OprepReportGames {Antal partier i rapporten}
translate W OprepAllGames    {Samtliga partier}
translate W OprepEndClass {Material i slutställningen}
translate W OprepTheoryTable {Teorisammanställning}
translate W OprepTableComment {Skapad från de %u högst rankade partierna.}
translate W OprepExtraMoves {Ytterligare antal drag i notförteckningen}
translate W OprepMaxGames {Maximalt antal partier i sammanställningen}
translate W OprepViewHTML {Visa HTML}
translate W OprepViewLaTeX {Visa LaTeX}

# Player Report:
translate W PReportTitle {Spelarrapport}
translate W PReportColorWhite {med de vita pjäserna}
translate W PReportColorBlack {med de svarta pjäserna}
# ====== TODO To be translated ======
translate W PReportBeginning {Beginning with}
translate W PReportMoves {efter %s}
translate W PReportOpenings {Öppningar}
translate W PReportClipbase {Töm Clipbase och kopiera liknande partier dit}


# Piece Tracker window:
translate W TrackerSelectSingle {Vänsterklicka för att välja denna pjäs.}
translate W TrackerSelectPair {Vänsterklicka för att välja denna pjäs; använd höger musknapp för att också välja den relaterade pjäsen.}
translate W TrackerSelectPawn {Vänsterklicka för att välja denna pjäs; använd höger musknapp för att välja alla åtta bönder.}
translate W TrackerStat {Statistik}
translate W TrackerGames {% partier med drag till rutan}
translate W TrackerTime {% tid på varje ruta}
translate W TrackerMoves {Drag}
translate W TrackerMovesStart {Ange vid vilket drag sökningen ska börja.}
translate W TrackerMovesStop {Ange vid vilket drag sökningen ska sluta.}

# Game selection dialogs:
translate W SelectAllGames {Alla partier i databasen}
translate W SelectFilterGames {Endast partierna i filtret}
translate W SelectTournamentGames {Endast partierna i den aktuella turneringen}
translate W SelectOlderGames {Endast äldre partier}

# Delete Twins window:
translate W TwinsNote {Partier måste minst ha samma spelare för att kunna identifieras som dubbletter samt uppfylla andra kriterier du kan ange nedan. När dubbletter hittas raderas det kortare partiet. Tips: det bästa är att använda rättstavningen innan dubblettjämförelsen eftersom detta förbättrar möjligheten för upptäckt av dubbletter.}
translate W TwinsCriteria {Kriterium: Dubbletter måste ha...}
translate W TwinsWhich {Ange vilka partier som ska jämföras}
translate W TwinsColors {Samma färger?}
translate W TwinsEvent {Samma evenemang?}
translate W TwinsSite {Samma plats?}
translate W TwinsRound {Samma rond?}
translate W TwinsYear {Samma år?}
translate W TwinsMonth {Samma månad?}
translate W TwinsDay {Samma dag?}
translate W TwinsResult {Samma resultat?}
translate W TwinsECO {Samma ECO-kod?}
translate W TwinsMoves {Samma drag?}
translate W TwinsPlayers {Jämför spelarnas namn:}
translate W TwinsPlayersExact {Exakt kopia}
translate W TwinsPlayersPrefix {Endast de 4 första bokstäverna}
translate W TwinsWhen {När dubbletter tas bort}
translate W TwinsSkipShort {Ignorera alla partier som är kortare än 5 drag?}
translate W TwinsUndelete {Återta alla partier först?}
translate W TwinsSetFilter {Filtrera alla borttagna dubbletter?}
translate W TwinsComments {Spara alltid partier med kommentarer?}
translate W TwinsVars {Spara alltid partier med variationer?}
translate W TwinsDeleteWhich {Ange vilket parti som ska tas bort:}
translate W TwinsDeleteShorter {Det kortare partiet}
translate W TwinsDeleteOlder {Partiet med lägst nummer}
translate W TwinsDeleteNewer {Partiet med högst nummer}
translate W TwinsDelete {Ta bort partier}

# Name editor window:
translate W NameEditType {Typ av namn att redigera}
translate W NameEditSelect {Partier att redigera}
translate W NameEditReplace {Ersätt}
translate W NameEditWith {med}
translate W NameEditMatches {Matchar: Tryck Ctrl+1 till Ctrl+9 för att välja}
translate W CheckGamesWhich {Kontrollera partier}
translate W CheckAll {Alla partier}
translate W CheckSelectFilterGames {Bara partier i filter}

# Classify window:
translate W Classify {Klassificera}
translate W ClassifyWhich {ECO-klassificera vilka partier?}
translate W ClassifyAll {Alla partier (skriv över gamla ECO-koder)}
translate W ClassifyYear {Alla partier spelade under det senaste året}
translate W ClassifyMonth {Alla partier spelade den senaste månaden}
translate W ClassifyNew {Endast partier som ännu ej klassificerats}
translate W ClassifyCodes {ECO-koder som ska användas}
translate W ClassifyBasic {Enbart standardkoder ("B12", ...)}
translate W ClassifyExtended {Scidextensioner ("B12j", ...)}

# Compaction:
translate W NameFile {Namnfil}
translate W GameFile {Partifil}
translate W Names {Namn}
translate W Unused {Ej använd}
translate W SizeKb {Storlek (kb)}
translate W CurrentState {Aktuell status}
translate W AfterCompaction {Efter komprimering}
translate W CompactNames {Namn, komprimera namnfil}
translate W CompactGames {Partier, komprimera partifil}
translate W NoUnusedNames "Det finns inga oanvända namn, så namnfilen är redan fullt komprimerad."
translate W NoUnusedGames "Partifilen är redan fullt komprimerad."
translate W NameFileCompacted {Namnfilen för databasen "[file tail [sc_base filename]]" blev komprimerad.}
translate W GameFileCompacted {Partifilen för databasen "[file tail [sc_base filename]]" blev komprimerad.}

# Sorting:
translate W SortCriteria {Kriterium}
translate W AddCriteria {Lägg till kriterium}
translate W CommonSorts {Normal sortering}
translate W Sort {Sortering}

# Exporting:
translate W AddToExistingFile {Lägg till partier till en existerande fil?}
translate W ExportComments {Exportera kommentarer?}
translate W ExportVariations {Exportera variationer?}
translate W IndentComments {Dra in kommentarer?}
translate W IndentVariations {Dra in variationer?}
translate W ExportColumnStyle {Kolumnstil (ett drag per rad)?}
translate W ExportSymbolStyle {Symbolbaserade kommentarer:}
translate W ExportStripMarks {Avlägsna koder för fält och pilar från kommentarerna?}

# Goto game/move dialogs:
translate W LoadGameNumber {Ange partiets nummer:}
translate W GotoMoveNumber {Gå till drag nummer:}

# Copy games dialog:
translate W CopyGames {kopiera partier}
translate W CopyConfirm {
Vill du verkligen kopiera
de [::utils::thousands $nGamesToCopy] filtrerade partierna
ur databasen "$fromName"
till databasen "$targetName"?
}
translate W CopyErr {Kan ej kopiera partier}
translate W CopyErrSource {källdatabasen}
translate W CopyErrTarget {måldatabasen}
translate W CopyErrNoGames {har inga partier i filtret}
translate W CopyErrReadOnly {kan bara läsas}
translate W CopyErrNotOpen {är ej öppen}

# Colors:
translate W LightSquares {Ljusa fält}
translate W DarkSquares {Mörka fält}
translate W SelectedSquares {Valda fält}
translate W SuggestedSquares {Föreslagna fält}
translate W Grid {Ruta}
translate W Previous {Föregående}
translate W WhitePieces {Vita pjäser}
translate W BlackPieces {Svarta pjäser}
translate W WhiteBorder {Vit kantlinje}
translate W BlackBorder {Svart kantlinje}
translate W ArrowMain   {Huvudpil}
translate W ArrowVar    {Variantpilar}

# Novelty window:
translate W FindNovelty {Hitta nyhet}
translate W Novelty {Nyhet}
translate W NoveltyInterrupt {Nyhetssökningen avbröts}
translate W NoveltyNone {Inga nyheter hittades i detta parti}
translate W NoveltyHelp {
Scid kommer att försöka hitta det första draget som leder till en position som inte annars finns i denna databas eller i spelöppingsboken baserad på ECO.
}

# Sounds configuration:
translate W SoundsFolder {Ljudfilskatalog}
translate W SoundsFolderHelp {Katalogen ska ha filerna King.wav, a.wav, 1.wav, etc}
translate W SoundsAnnounceOptions {Inställningar för Dragannonsering}
translate W SoundsAnnounceNew {Annonsera nya drag när de görs}
translate W SoundsAnnounceForward {Annonsera drag när du går fram ett drag}
translate W SoundsAnnounceBack {Annonsera drag när du går fram eller tillbaka ett drag}

# Upgrading databases:
translate W Upgrading {Uppdaterar}
translate W ConfirmOpenNew {
Denna databas är i ett gammal format (Scid 2) och kan inte öppnas i Scid 3, men en databas i det nya formatet (Scid 3) har redan skapats.

Vill du öppna den senare databasen istället?
}
translate W ConfirmUpgrade {
Denna databas är i ett gammal format (Scid 2). En databas i det nyare formatet måste skapas innan den kan användas i Scid 3.

Genom att uppdatera skapas en databas i det nya formatet med samma innehåll; uppdateringen ändrar ingenting i den gamla databasen.

Detta kan ta ett tag men behöver bara göras en gång. Om du tycker det tar alltför lång tid kan du avbryta processen.

Vill du uppdatera denna databas nu?
}

# Recent files options:
translate W RecentFilesMenu {Antal senast öppnade filer i Arkivmenyn}
translate W RecentFilesExtra {Antal senast öppnade filer i extra undermeny}

# My Player Names options:
translate W MyPlayerNamesDescription {
Ange en lista på dina favoritspelare här nedanför. Skriv ett namn per rad. Jokertecken ("?", t ex, motsvarar ett enstaka tecken medan "*" står för flera tecken) är tillåtna.

Varje gång ett parti med en spelare vars namn står i denna lista öppnas kommer brädet automatiskt att vridas så att partiet visas från spelarens perspektiv.
}
translate W showblunderexists {visa blunder finns}
translate W showblundervalue {visa blundervärde}
translate W showscore {visa värdering}
translate W coachgame {tränarparti}
translate W configurecoachgame {konfigurera tränarparti}
translate W configuregame {Konfigurera parti}
translate W Phalanxengine {Phalanx schackmotor}
translate W Coachengine {Tränarschackmotor}
translate W difficulty {svårighetsgrad}
translate W hard {svår}
translate W easy {lätt}
translate W Playwith {Spela med}
translate W white {vit}
translate W black {svart}
translate W both {båda}
translate W Play {Spela}
translate W Noblunder {Ingen blunder}
translate W blunder {blunder}
translate W Noinfo {-- Ingen information --}
translate W moveblunderthreshold {drag är en blunder om förlust är större än}
translate W limitanalysis {begränsa schackmotors analystid}
translate W seconds {sekunder}
translate W Abort {Avbryt}
translate W Resume {Fortsätt}
# TODO
translate W Restart {Restart}
translate W OutOfOpening {utanför öppning}
translate W NotFollowedLine {Du följde inte variationen}
translate W DoYouWantContinue {Vill du fortsätta ?}
translate W CoachIsWatching {Tränaren observerar}
translate W Ponder {Permanent tänkande}
translate W LimitELO {Begränsa ELO-styrka}
translate W DubiousMovePlayedTakeBack {Ett tveksamt drag spelades, vill du ta tillbaka det ?}
translate W WeakMovePlayedTakeBack {Ett svagt drag spelades, vill du ta tillbaka det ?}
translate W BadMovePlayedTakeBack {Ett dåligt drag spelades, vill du ta tillbaka det ?}
translate W Iresign {Jag ger upp}
translate W yourmoveisnotgood {ditt drag är inte bra}
translate W EndOfVar {Slut på variation}
translate W Openingtrainer {Öppningstränare}
translate W DisplayCM {Visa kandidatdrag}
translate W DisplayCMValue {Visa kandidatdragens värden}
translate W DisplayOpeningStats {Visa statistik}
translate W ShowReport {Visa rapport}
translate W NumberOfGoodMovesPlayed {bra drag spelade}
translate W NumberOfDubiousMovesPlayed {tveksamma drag spelade}
translate W NumberOfTimesPositionEncountered {gånger positionen påträffats}
translate W PlayerBestMove  {Tillåt bara bästa dragen}
translate W OpponentBestMove {Motståndare spelar bästa dragen}
translate W OnlyFlaggedLines {Bara markerade variationer}
translate W resetStats {Nollställ statistik}
translate W Movesloaded {Öppnat drag}
translate W PositionsNotPlayed {Positioner inte spelade}
translate W PositionsPlayed {Positioner spelade}
translate W Success {Framgång}
translate W DubiousMoves {Tveksamma drag}
translate W ConfigureTactics {Konfigurera taktik}
translate W ResetScores {Nollställ poäng}
translate W LoadingBase {Öppnar bas}
translate W Tactics {Taktik}
translate W ShowSolution {Visa lösning}
translate W Next {Nästa}
translate W ResettingScore {Nollställer poäng}
translate W LoadingGame {Öppnar parti}
translate W MateFound {Matt hittad}
translate W BestSolutionNotFound {Bästa lösningen hittades INTE !}
translate W MateNotFound {Matt hittades inte}
translate W ShorterMateExists {En kortare matt finns}
translate W ScorePlayed {Poäng spelad}
translate W Expected {förväntat}
translate W ChooseTrainingBase {Välj träningsbas}
translate W Thinking {Tänker}
translate W AnalyzeDone {Analys klar}
translate W WinWonGame {Vinn vunnet parti}
translate W Lines {Variationer}
translate W ConfigureUCIengine {Konfigurera UCI-schackmotor}
translate W SpecificOpening {Specifik öppning}
translate W StartNewGame {Starta nytt parti}
translate W FixedLevel {Fast nivå}
translate W Opening {Öppning}
translate W RandomLevel {Slumpmässig nivå}
translate W StartFromCurrentPosition {Starta från den aktuella positionen}
translate W FixedDepth {Fast sökdjup}
translate W Nodes {Noder}
translate W Depth {Sökdjup}
translate W Time {Tid}
translate W SecondsPerMove {Sekunder per drag}
# ====== TODO To be translated ======
translate W DepthPerMove {Depth per move}
# ====== TODO To be translated ======
translate W MoveControl {Move Control}
# TODO
translate W TimeLabel {Time per move}
# ====== TODO To be translated ======
translate W AddVars {Add Variations}
# ====== TODO To be translated ======
translate W AddScores {Add Score}
translate W Engine {Schackmotor}
translate W TimeMode {Tidsmod}
translate W TimeBonus {Tid + bonus}
translate W TimeMin {min}
translate W TimeSec {sek}
translate W AllExercisesDone {Alla övningar gjorda}
translate W MoveOutOfBook {Drag utanför bok}
translate W LastBookMove {Sista bokdrag}
translate W AnnotateSeveralGames {Kommentera flera partier\nfrån aktuellt till :}
translate W FindOpeningErrors {Hitta öppningsfel}
translate W MarkTacticalExercises {Markera taktiska övningar}
translate W UseBook {Använd bok}
translate W MultiPV {Flera variationer}
translate W Hash {Hashminne}
translate W OwnBook {Använd schackmotorbok}
translate W BookFile {Öppningsbok}
translate W AnnotateVariations {Kommentera variationer}
translate W ShortAnnotations {Korta kommentarer}
translate W addAnnotatorTag {Lägg till kommentator-tagg}
translate W AddScoreToShortAnnotations {Lägg till värdering till korta kommentarer}
translate W Export {Exportera}
translate W BookPartiallyLoaded {Bok delvis öppnad}
# ====== TODO To be translated ======
translate W AddLine {Add Line}
# ====== TODO To be translated ======
translate W RemLine {Remove Line}
translate W Calvar {Beräkning av variationer}
translate W ConfigureCalvar {Konfiguration}
translate W Reti {Reti}
translate W English {Engelsk}
translate W d4Nf6Miscellaneous {1.d4 Nf6 Diverse}
translate W Trompowsky {Trompowsky}
translate W Budapest {Budapest}
translate W OldIndian {Gammalindisk}
translate W BenkoGambit {Benko-gambit}
translate W ModernBenoni {Modern Benoni}
translate W DutchDefence {Holländskt försvar}
translate W Scandinavian {Skandinaviskt}
translate W AlekhineDefence {Alekhines försvar}
translate W Pirc {Pirc}
translate W CaroKann {Caro-Kann}
translate W CaroKannAdvance {Caro-Kann Avancemang}
translate W Sicilian {Siciliansk}
translate W SicilianAlapin {Siciliansk Alapin}
translate W SicilianClosed {Stängd Siciliansk}
translate W SicilianRauzer {Siciliansk Rauzer}
translate W SicilianDragon {Siciliansk Drake}
translate W SicilianScheveningen {Siciliansk Scheveningen}
translate W SicilianNajdorf {Siciliansk Najdorf}
translate W OpenGame {Öppet parti}
translate W Vienna {Wiener}
translate W KingsGambit {Kungsgambit}
translate W RussianGame {Ryskt parti}
translate W ItalianTwoKnights {Italianskt/Tvåspringar}
translate W Spanish {Spanskt}
translate W SpanishExchange {Spanskt Avbytesvariant}
translate W SpanishOpen {Öpett Spanskt}
translate W SpanishClosed {Stängt Spanskt}
translate W FrenchDefence {Franskt Försvar}
translate W FrenchAdvance {Fransk Avancemang}
translate W FrenchTarrasch {Fransk Tarrasch}
translate W FrenchWinawer {Fransk Winawer}
translate W FrenchExchange {Fransk Avbytesvariant}
translate W QueensPawn {Dambonde}
translate W Slav {Slav}
translate W QGA {Antagen Damgambit}
translate W QGD {Avböjd Damgambit}
translate W QGDExchange {Avböjd Damgambit Avbytesvariant}
translate W SemiSlav {Semi-Slav}
translate W QGDwithBg5 {Avböjd Damgambit med Bg5}
translate W QGDOrthodox {Avböjd Damgambit Ortodox}
translate W Grunfeld {Grünfeld}
translate W GrunfeldExchange {Grünfeld Avbytesvariant}
translate W GrunfeldRussian {Grünfeld Ryskt}
translate W Catalan {Catalan}
translate W CatalanOpen {Öppen Catalan}
translate W CatalanClosed {Stängd Catalan}
translate W QueensIndian {Damindiskt}
translate W NimzoIndian {Nimzo-Indiskt}
translate W NimzoIndianClassical {Nimzo-Indiskt Klassiskt}
translate W NimzoIndianRubinstein {Nimzo-Indiskt Rubinstein}
translate W KingsIndian {Kungsindiskt}
translate W KingsIndianSamisch {Kungsindiskt Sämisch}
translate W KingsIndianMainLine {Kungsindiskt Huvudvariation}

# FICS
translate W ConfigureFics {Konfigurera FICS}
translate W FICSLogin {Logga in}
translate W FICSGuest {Logga in som Gäst}
translate W FICSServerPort {Serverport}
translate W FICSServerAddress {IP-address}
translate W FICSRefresh {Uppdatera}
translate W FICSTimeseal {Timeseal}
translate W FICSTimesealPort {Timeseal-port}
translate W FICSSilence {Konsolfilter}
translate W FICSOffers {Erbjudanden}
translate W FICSGames {Partier}
translate W FICSFindOpponent {Sök motståndare}
translate W FICSTakeback {Ta tillbaka}
translate W FICSTakeback2 {Ta tillbaka 2}
translate W FICSInitTime {Tid (min)}
translate W FICSIncrement {Ökning (sek)}
translate W FICSRatedGame {Ratat parti}
translate W FICSAutoColour {Automatisk}
translate W FICSManualConfirm {Bekräfta manuellt}
translate W FICSFilterFormula {Filtrera med format}
translate W FICSIssueSeek {Sök Issue}
translate W FICSAccept {Acceptera}
translate W FICSDecline {Avböj}
translate W FICSColour {Färg}
translate W FICSSend {Skicka}
translate W FICSConnect {Anslut}
# ====== TODO To be translated ======
translate W FICSShouts {Shouts}
# ====== TODO To be translated ======
translate W FICSTells {Tells}
# ====== TODO To be translated ======
translate W FICSOpponent {Opponent Info}
# ====== TODO To be translated ======
translate W FICSInfo {Info}
# ====== TODO To be translated ======
translate W FICSDraw {Offer Draw}
# ====== TODO To be translated ======
translate W FICSRematch {Rematch}
# ====== TODO To be translated ======
translate W FICSQuit {Quit FICS}
# ====== TODO To be translated ======
translate W FICSCensor {Censor}

translate W CCDlgConfigureWindowTitle {Konfigurera Korrespondensschack}
translate W CCDlgCGeneraloptions {Generella inställningar}
translate W CCDlgDefaultDB {Standarddatabas:}
translate W CCDlgInbox {Inkorg (sökväg):}
translate W CCDlgOutbox {Utkorg (sökväg):}
translate W CCDlgXfcc {Xfcc-Konfiguration:}
translate W CCDlgExternalProtocol {Extern Protokollhanterare (t.ex. Xfcc)}
translate W CCDlgFetchTool {Hämtningsverktyg:}
translate W CCDlgSendTool {Sändverktyg:}
translate W CCDlgEmailCommunication {eMail-kommunikation}
translate W CCDlgMailPrg {eMail-program:}
translate W CCDlgBCCAddr {(B)CC-address:}
translate W CCDlgMailerMode {Mod:}
translate W CCDlgThunderbirdEg {t.ex. Thunderbird, Mozilla Mail, Icedove...}
translate W CCDlgMailUrlEg {t.ex. Evolution}
translate W CCDlgClawsEg {t.ex Sylpheed Claws}
translate W CCDlgmailxEg {t.ex. mailx, mutt, nail...}
translate W CCDlgAttachementPar {Bilage-parameter:}
translate W CCDlgInternalXfcc {Använd internt Xfcc-stöd}
translate W CCDlgConfirmXfcc {Bekräfta drag}
translate W CCDlgSubjectPar {Ämnes-parameter:}
translate W CCDlgDeleteBoxes {Töm In-/Utkorg}
translate W CCDlgDeleteBoxesText {Vill du verkligen tömma dina In- och Utkorgskataloger för Korrespondensschack? Detta kräver en ny synkronisering för att visa den seanaste statusen på dina partier}
translate W CCDlgConfirmMove {Bekräfta drag}
translate W CCDlgConfirmMoveText {Om du bekräftar, kommer följande drag och kommentar att skickas till servern:}
translate W CCDlgDBGameToLong {Inkonsekvent huvudvariation}
translate W CCDlgDBGameToLongError {Huvudvariationen i din databas är längre än partiet i din Inkorg. Om Inkorgen innehåller aktuella partier, dvs precis efter en synkronisering, lades några drag felaktigt till i huvudvariationen i databasen.\nI detta fall var god och förkorta huvudvariationen till (maximalt) drag\n}
translate W CCDlgStartEmail {Starta ett nytt eMail-parti}
translate W CCDlgYourName {Ditt Namn:}
translate W CCDlgYourMail {Din eMail-address:}
translate W CCDlgOpponentName {Motståndarnamn:}
translate W CCDlgOpponentMail {Motståndarens eMail-address:}
translate W CCDlgGameID {Parti-ID (unikt):}
translate W CCDlgTitNoOutbox {Scid: Korrespondensschackutkorg}
translate W CCDlgTitNoInbox {Scid: Korrespondensschackinkorg}
translate W CCDlgTitNoGames {Scid: Inga Korrespondensschackpartier}
translate W CCErrInboxDir {Korrespondensschacksinkorgskatalog:}
translate W CCErrOutboxDir {Korrespondensschacksutkorgskatalog:}
translate W CCErrDirNotUsable {finns inte eller är inte möjlig att använda!\nVar god och kontrollera och korrigera inställningarna.}
translate W CCErrNoGames {innehåller inga partier!\nVar god och hämta dem först.}
translate W CCDlgTitNoCCDB {Scid: Ingen Korrespondensdatabas}
translate W CCErrNoCCDB {Ingen Databas av typ 'Korrespondens' är öppnad. Var god och öppna en innan du använder Korrespondensschackfunktioner.}
translate W CCFetchBtn {Hämta partier från servern och bearbeta Inkorgen}
translate W CCPrevBtn {Gå till tidigare parti}
translate W CCNextBtn {Gå till nästa parti}
translate W CCSendBtn {Skicka drag}
translate W CCEmptyBtn {Töm Inkorgen och Utkorgen}
translate W CCHelpBtn {Hjälp med ikoner och statusindikatorer.\nFör generell Hjälp tryck på F1!}
translate W CCDlgServerName {Servernamn:}
translate W CCDlgLoginName  {Inloggningsnamn:}
translate W CCDlgPassword   {Lösenord:}
translate W CCDlgURL        {Xfcc-URL:}
translate W CCDlgRatingType {Ratingtyp:}
translate W CCDlgDuplicateGame {Icke unikt parti-ID}
translate W CCDlgDuplicateGameError {Detta parti finns fler än en gång i din databas. Var god och ta bort alla dubbletter och komprimera din partifil (Arkiv/Underhåll/Komprimera Databas).}
translate W CCDlgSortOption {Sorterar:}
translate W CCDlgListOnlyOwnMove {Bara partier där jag är vid draget}
translate W CCOrderClassicTxt {Plats, Evenemang, Runda, Resultat, Vit, Svart}
translate W CCOrderMyTimeTxt {Min klocka}
translate W CCOrderTimePerMoveTxt {Tid per drag till nästa tidskontroll}
translate W CCOrderStartDate {Startdatum}
translate W CCOrderOppTimeTxt {Motståndarens klocka}
translate W CCDlgConfigRelay {Konfigurera ICCF-observationer}
translate W CCDlgConfigRelayHelp {Gå till partisidan på http://www.iccf-webchess.com och visa partiet att observera.  Om du ser schackbräder kopiera webadressen från din webläsare till listan nedanför. Bara en webadress per rad!\nExempel: http://www.iccf-webchess.com/MakeAMove.aspx?id=266452}

translate W ExtHWConfigConnection {Konfigurera extern hårdvara}
translate W ExtHWPort {Port}
translate W ExtHWEngineCmd {Schackmotorkommando}
translate W ExtHWEngineParam {Schackmotorparameter}
translate W ExtHWShowButton {Visa knapp}
translate W ExtHWHardware {Hårdvara}
translate W ExtHWNovag {Novag Citrine}
translate W ExtHWInputEngine {Inmatningsmotor}
translate W ExtHWNoBoard {Inget bräde}
translate W IEConsole {Inmatningsmotorkonsol}
translate W IESending {Drag skickade för}
translate W IESynchronise {Synkronisera}
translate W IERotate  {Rotera}
translate W IEUnableToStart {Kan inte starta Inmatningsmotor:}
translate W DoneWithPosition {Klar med position}
translate W Board {Bräde}
translate W showGameInfo {Visa partiinformation}
translate W autoResizeBoard {Ändra storleken på brädet automatiskt}
translate W DockTop {Drag överst}
translate W DockBottom {Drag nederst}
translate W DockLeft {Drag till vänster}
translate W DockRight {Drag till höger}
translate W Undock {Avdocka}
translate W ChangeIcon {Ändra ikon...}
# ====== TODO To be translated ======
translate W More {More}

# Drag & Drop
translate W CannotOpenUri {Åtkomst nekad för foldern '%s'.}
translate W InvalidUri {Innehåll som släpps är inte en giltig URI-lista.}
translate W UriRejected	{Följande filer är förkastade:}
translate W UriRejectedDetail {Bara listade filtyper kan behandlas:}
translate W EmptyUriList {Innehåll som släpps är tomt.}
# ====== TODO To be translated ======
translate W SelectionOwnerDidntRespond {Timeout during drop action: selection owner didn't respond.}

}

##########
#
# ECO Opening name translations:

translateECO W {
  Accelerated {, Accelererad}
  {: Accelerated} Accelererad
  Accepted {, Antagen}
  {: Accepted} Antagen
  Advance Avancemang
  {as Black} {som Svart}
  Attack Angrepp
  Bishop Löpare
  Bishop's Löpar
  Classical Klassisk
  Closed Stängd
  {Closed System} {Stängt system}
  Counterattack Motangrepp
  Countergambit Motgambit
  Declined {, Avböjd}
  Defence Försvar
  deferred förvägrad
  Deferred {, förvägrad}
  Early Tidig
  Exchange Avbyte
  Game Parti
  Improved förbättrad
  King's Kung
  Knight Springar
  Line Variant
  {Main Line} Huvudvariant
  Open Öppen
  Opening Öppning
  Queen's Dam
  Queenswap Damavbyte
  Symmetrical Symmetrisk
  Variation Variation
  Wing Flygel
  with med
  without utan

  Alekhine Aljechin
  Averbakh Averbach
  Botvinnik Botvinnik
  Chigorin Chigorin
  Polugaevsky Polugajevski
  Rauzer Rauzer
  Sveshnikov Sveschnikov

  Austrian Österrikisk
  Berlin Berlin
  Bremen Bremen
  Catalan Katalansk
  Czech Tjeckisk
  Dutch Holländsk
  English Engelsk
  French Fransk
  Hungarian Ungersk
  Indian Indisk
  Italian Italiensk
  Latvian Lettisk
  Meran Meran
  Moscow Moskva
  Polish Polsk
  Prague Prag
  Russian Rysk
  Scandinavian Skandinavisk
  Scheveningen Scheveningen
  Scotch Skottsk
  Sicilian Siciliansk
  Slav Slavisk
  Spanish Spansk
  Swedish Svensk
  Swiss Schweizisk
  Vienna Wiener
  Yugoslav Jugoslavisk

  {Accelerated Fianchetto} {Accelererad Fianchetto}
  {Accelerated Pterodactyl} {Accelererad Pterodactyl}
  {Alekhine Defence} Aljechins Försvar
  {Alekhine Variation} Aljechin-Variant
  {Alekhine: Sämisch Attack} {Aljechin: Wiener-system (Sämisch-Angrepp)}
  {Anderssen Opening} Anderssen-Öppning
  {Anti-King's Indian} Anti-Kungsindisk
  {Austrian Attack} {Österrikiskt Angrepp}
  {Benko Gambit} Volga-Gambit
  {Benko Opening} Benkö-Öppning
  {Berlin Defence} {Berlinförsvar}
  Chameleon Chamaleon
  Chelyabinsk Chelyabinsk
  {Classical Defence} {Klassiskt försvar}
  {Spanish: Classical Defence} {Spanskt: Klassiskt (Cordel-) försvar}
  {Classical Exchange} {Klassiskt Avbyte}
  {Classical Variation} {Klassisk Variant}
  {Closed Berlin} {Stängd Berlin}
  {Open Berlin} {Öppen Berlin}
  {Bird's,} {Bird,}
  {Bird's Defence} Birds försvar
  {Bird's Deferred} {Förvägrad Bird}
  {Bishop's Opening} Löparspel
  {Botvinnik System} Botvinnik-system
  {Central Variation} Centralvariant
  {Centre Attack} Centrumsangrepp
  {Centre Game} Mittgambit
  {Danish Gambit} {Nordisk Gambit}
  Dragon Drake
  {Dutch Variation} {Holländsk Variant}
  {Early Exchange} {Tidigt Avbyte}
  {Early Queenswap} {Tidigt Dambyte}
  {English Attack} {Engelskt Angrepp}
  {English: King's} {Engelskt: Kungsbonde}
  {English Variation} {Engelsk Variant}
  {Englund Gambit} Englunds Gambit
  {Exchange Variation} Avbytesvariant
  {Fianchetto Variation} Fianchettovariant
  {Flohr Variation} Flohr-Variant
  {Four Knights} Fyrspringar
  {Four Knights Game} Fyrspringarspel
  {Four Pawns} Fyrbonde
  {Four Pawns Attack} Fyrbondeangrepp
  {French Variation} {Fransk Variant}
  {From Gambit} {From-Gambit}
  {Goring Gambit} {Göring-Gambit}
  {Grob Gambit} {Grobs Gambit}
  {Hungarian Defence} {Ungerskt försvar}
  {Indian Variation} {Indisk Variant}
  {Italian Game} {Italienskt Parti}
  KGD {Avböjd Kungssgambit}
  {Classical KGD} {Klassisk avböjd Kungsgambit}
  {Keres Variation} Keres-Variant
  KGA {Antagen Kungsgambit}
  {KGA: Bishop's Gambit} Kungslöpargambit
  {KGA: King's Knight Gambit} Kungsspringargambit
  {King's Gambit} Kungsgambit
  {King's Gambit Accepted} {Antagen Kungsgambit}
  {King's Gambit Accepted (KGA)} {Antagen Kungsgambit}
  {King's Indian} Kungsindisk
  KIA {Kungsindiskt Angrepp}
  {King's Knight Gambit} Kungsspringargambit
  {King's Pawn} Kungsbonde
  {Lasker Variation} {Lasker-Variant}
  {Latvian Gambit} {Lettisk Gambit}
  {Maroczy Bind} {Maroczy-bindning}
  {Marshall Variation} Marshall-Variant
  {Modern Attack} {Modernt Angrepp}
  {Modern Steinitz} {Modern Steinitz}
  {Modern Variation} {Modern Variant}
  {Moscow Variation} {Moskva-variant}
  Nimzo-Indian Nimzoindisk
  {Old Benoni} {Klassisk Benoni}
  {Old Indian} Gammalindisk
  {Old Indian Attack} {Gammalindisk Indisk attack}
  {Old Steinitz} Gammal Steinitz-öppning
  {Open Game} {Öppet Parti}
  {Poisoned Pawn} {Förgiftad Bonde}
  {Polish Variation} {Polsk Variant}
  {Polugaevsky Variation} {Polugajevski-Variant}
  {Queen's Gambit} Damgambit
  {Queen's Gambit Accepted} {Antagen Damgambit}
  QGA {Antagen Damgambit}
  {Queen's Gambit Accepted (QGA)} {Antagen Damgambit}
  {Reversed QGA} {Omvänd antagen Damgambit}
  QGD {Avböjd Damgambit}
  {Queen's Gambit Declined (QGD)} {Avböjd Damgambit}
  {Reversed QGD} {Omvänd avböjd Damgambit}
  {Queen's Indian} Damindisk
  {Queen's Pawn} Dambonde
  {Queen's Pawn Game} Dambondespel
  {Reversed Slav} {Omvänd Slavisk}
  {Rubinstein Variation} Rubinstein-Variant
  {Russian Game} {Ryskt Parti}
  {Russian Game (Petroff Defence)} {Ryskt Parti}
  {Russian-Three Knights Game} {Ryskt trespringarspel}
  {Scandinavian (Centre Counter)} Skandinavisk
  Schliemann Jänisch
  {Schliemann (Jänisch)} {Jänisch-Gambit (Schliemann)}
  {Scotch Opening} {Skottsk öppning}
  {Sicilian Defence} {Sicilianskt försvar}
  {Sicilian Variation} {Siciliansk Variant}
  {Slav Defence} {Slaviskt försvar}
  Smith-Morra Morra
  {Smith-Morra Accepted} {Antagen Morra-Gambit}
  {Smith-Morra Gambit} Morra-Gambit
  {Spanish (Ruy Lopez)} {Spanskt Parti}
  {Start position} Utgångsställning
  {Steinitz Deferred} Förvägrad Rubinstein
  {Swedish Variation} {Svensk Variant}
  {Swiss Variation} {Schweizisk Variant}
  {Tarrasch's Gambit} {Tarrasch-Gambit}
  {Three Knights} Trespringar
  {3 Knights} Trespringar
  {Three Knights Game} Trespringarspel
  {Three Pawns Attack} Trebondeangrepp
  {Two Knights} Tvåspringar
  {Two Knights Defence} Tvåspringar-försvar
  {Two Knights Variation} Tvåspringar-variant
  {Two Pawns} Tvåbonde
  {Two Pawns Attack} Tvåbondeangrepp
  {Wing Gambit} Flygel-Gambit
  {Yugoslav Attack} {Jugoslaviskt Angrepp}
}

### Swedish help pages: removed because

### Swedish tip of the day:

set tips(W) {
  {
    Scid har över 30 <a Index>Hjälpsidor</a>, och i de flesta fönster kan du
    genom att trycka <b>F1</b> få hjälp om det fönster du för tillfället har
    aktivt.
  }
  {
    Vissa fönster (t ex Partiinformation och <a Switcher>Databasväljaren</a>)
    har en meny för höger musknapp. Prova att högerklicka i varje fönster så
    ser du vilka som har det och vilka funktioner du kommer åt den vägen.
  }
  {
    Du kan ange drag på mer än ett sätt, så du kan välja vilket som passar dig
    bäst. Du kan använda musen (med eller utan dragförslag) eller tangentbordet
    (med eller utan autokomplettering). Läs hjälpsidan för
    <a Moves>Att ange drag</a> för mer information.
  }
  {
    Om du har databaser du ofta öppnar så kan du lägga till ett
    <a Bookmarks>Bokmärke</a> för varje databas. Du kommer då att kunna öppna
    databaserna snabbare via bokmärkesmenyn.
  }
  {
    Du kan se alla drag i det aktuella partiet (inklusive varianter och kommentarer)
    genom att öppna <a PGN>PGN-fönstret</a>.
    Du navigerar igenom partiet i PGN-fönstret genom att klicka på valfritt drag med
    vänster musknapp. Genom att klicka på draget med mellan- eller högermusknapp så
    får du en förhandsvisning av just den ställningen.
  }
  {
    Du kan kopiera partier mellan databaserna i <a Switcher>Databasväljaren</a> genom
    att dra-och-släppa dem mellan respektive databas.
  }
  {
    Om du ofta använder <a Tree>Trädfönstret</a> med stora databaser, är det värt att välja
    <b>Fyll cachefil</b> från Arkivmenyn i Trädfönstret. Detta innebär att trädstatistik för
    många av de vanligare ställningarna sparas, vilket ger en snabbare trädåtkomst för databasen
    ifråga.
  }
  {
    <a Tree>Trädfönstret</a> kan visa alla drag från den aktuella ställningen. Men om också vill
    se alla dragföljder som har lett till denna ställning kan du få fram det genom att skapa en
   <a OpReport>Öppningsrapport</a>.
  }
  {
    Du kan vänster- eller högerklicka i en kolumn i <a GameList>Partilistan</a> för att ändra
    dess bredd.
  }
  {
    Med <a PInfo>Spelarinformationen</a> aktuell (klicka på endera spelarens namn under brädet i
    huvudfönstret för att få fram den) är det enkelt att <a Searches filtret>Filtrera</a> fram partier
    av en särskild spelares enskilda resultat. Klicka bara på valfritt värde som har angivits med
    <red>röd text</red>.
  }
  {
    När du studerar öppningar kan det vara en poäng att markera valen <b>Bönder</b> eller <b>Filer</b> i
    <a Searches Board>Sök aktuell position</a>. Genom dessa val kan du hitta andra öppningar som ger
    liknande bondestrukturer.
  }
  {
    Du kan högerklicka i partiinformationsdelen av huvudfönstret (under brädet) för att få fram en
    kontextmeny. Du kan t ex göra så att Scid döljer nästa drag i ett parti, vilket kan vara användbart
    om du vill träna genom att "gissa" nästa drag.
  }
  {
    Om du ofta <a Maintenance>Underhåller</a> stora databaser kan du utföra flera underhållsuppgifter
    vid samma tillfälle via <a Maintenance Cleaner>Databasverktyget</a>.
  }
  {
    Om du har en stor databas där de flesta partierna har ett evenemangsdatum och du vill ha partierna i
    datumordning bör du överväga att <a Sorting>Sortera</a> den på evenemangsdatum i första hand och
    evenemang i andra hand, istället för datum och evenemang, då detta kommer att hålla turneringspartierna
    från olika datum samman. (Under förutsättning att alla partier har samma evenemangsdatum naturligtvis).
    Alternativt kan du se till att fälten evenemang, rond och datum är så enhetliga och korrekta som möjligt.
    (ms).
  }
  {
    Det kan vara en bra idé att <a Maintenance Spellcheck>Stavningskontrollera</a> din databas innan du
    <a Maintenance Twins>Tar bort dubbletter</a> då Scid har större möjlighet att hitta dubbletterna och
    markera dessa för borttagning.
  }
  {
    <a Flags>Flaggor</a> är användbara för att markera upp partier med karaktäristika du vill söka på senare,
    såsom bondeställning, taktiska finesser, osv. Du kan söka på flaggor när du söker på fält i partihuvudet.
  }
  {
    Om du går igenom ett parti, och helt enkelt vill testa en ny variant utan att förändra partiet i sig, kan
    du slå på Försöksläget (Trial mode) genom att trycka <b>Ctrl+Mellanslag</b> eller från verktygsraden. Återgå till
    ursprungspartiet när du är klar.
  }
  {
    Om du vill hitta det mest betydelsefulla partiet (med högst rankade spelare) i en viss position kan du
    öppna <a Tree>Trädfönstret</a> och i denna öppna listan med de bästa partierna. I trädfönstret kan du till
    och med begränsa partierna till endast ett särskilt resultat.
  }
  {
    Ett bra sätt att studera en öppning är att i en stor databas slå på träningsläget i <a Tree>Trädfönstret</a>,
    och sedan spela igenom databasen för att se vilka varianter som förekommer oftast.
  }
  {
    Om du har två databaser öppna, och vill ha ett variantträd att studera medan du går igenom ett parti
    i den andra databasen kan du <b>Låsa</b> trädet i den databasen och sedan byta till den andra.
  }
  {
    <a Tmt>Turneringssökaren</a> är inte bara användbar för att lokalisera en särskild
    turnering. Du kan också använda den för att söka efter turneringar en specifik spelare nyligen deltagit
    i, eller att bläddra genom turneringar som genomförts i ett visst land.
  }
  {
    Det finns ett antal vanliga ställningstyper definierade i <a Searches Material>Sök Material/Ställning</a>
    fönstret som du kan ha nytta av när du studerar öppningar och mittspel.
  }
  {
    När du söker på <a Searches Material>Material eller Ställning</a> kan det ofta vara fördelaktigt att begränsa
    sökningen till sådana partier där ställningen eller materialet förekommit i åtminstone några drag. Du slipper
    du få med träffar där situationen du söker uppkom helt tillfälligt.
  }
  {
    Om du har en viktig databas du inte vill radera av misstag kan du välja  <b>Enbart läsbar</b> från <b>Arkiv</b>
    menyn efter att du har öppnat den. Alternativt kan du sätta dess filrättigheter till enbart läsrättigheter.
  }
  {
    Om du använder XBoard eller WinBoard (eller något annat program som kan hantera FEN-notation via Urklippshanteraren)
    och vill kopiera den aktuella ställningen från ditt program är det snabbaste sättet att göra det så här:
    Välj <b>Kopiera position</b> från <b>Arkiv</b>-menyn i Xboard/Winboard, välj sedan <b>Klistra i utgångsställning</b>
    i Redigera menyn i Scid.
  }
  {
    I <a Searches Header>Sök i huvud</a>, är spelare-, evenemang-, plats-, och rondnamn okänsliga för VERSALER och
    gemener och ger träffar varhelst de finns i ett namn. Om du vill kan du ange att du istället vill att sökningen <b>ska</b>
    ta VERSALER/gemener i beaktande. Genom att använda jokertecken inom citationstecken (där "?" = motsvarar obestämt
    enskilt tecken och "*" = noll eller flera tecken). Om du exempelvis anger "*BEL" (med citationstecken) i det platsfältet
    hittar du alla partier spelade i Belgien, men exkluderar de som spelats i Belgrad.
  }
  {
    Om du vill redigera ett drag i ett parti utan att förlora alla de drag som spelats efter detta kan du öppna
    <a Import>Importera ett parti i PGN-format</a> fönstret i Verktygsmenyn. Klicka där på <b>Klistra i aktuellt parti</b>
    , redigera partiet och avsluta med <b>Importera</b>.
  }
  {
    Om du har en ECO klassificeringsfil laddad, kan du nå den mest exakt klassificerade ställningen för det aktuella partiet
    genom att välja <b>Identifiera öppning</b> i <b>Partier</b> menyn (kortkommando: <b>Ctrl+Shift+D</b>).
  }
  {
    När du vill se hur stor en fil är, eller vill se när den senast redigerades innan du öppnar den kan du använda
    <a Finder>Sök filer</a> (Arkiv - Sök filer).
  }
  {
    En <a repetoire>Repetoarfil</a> är ett utmärkt sätt att hålla koll på dina favoritöppningar, eller hitta partier där
    där de har spelats. När du väl har skapat en repetoarfil kan du genomsöka nya filer utifrån repetoarfilen, och titta
    igenom alla partier med just dina öppningar.
  }
  {
    Genom att skapa en <a OpReport>Öppningsrapport</a> har du en utmärkt möjlighet att lära dig en ny spelöppning. Du kan få
    information om resultat, hur remiaktig den är, vilka vanliga positionella teman som dyker upp, och mycket mer.
  }
  {
    Du kan kommentera den aktuella ställningen med de vanligaste symbolerna (!, !?, +=, etc) utan att behöva använda
    <a Comment>Kommentarseditorn<a>. Där du exempelvis vill ange ett bra drag skriver du "!" och trycker sedan ENTER
    så läggs "!" symbolen till draget. Se även hjälpsidan <a Moves>Ange drag</a> för mer detaljerad information.
  }
  {
    Om du bläddrar igenom öppningarna i en databas i <a Tree>Trädfönstret</a>, får du en användbar överblick över hur
    väl öppningen fungerar i sentida partier mellan högratade spelare om du öppnar statistikfönstret (kortkommando: Ctrl+I).
  }
  {
    Du ändrar enkelt huvudfönstrets brädstorlek genom att hålla nere <b>Ctrl</b> och <b>Shift</b> tangenterna, samtidigt
    som du trycker höger- eller vänster piltangent.
  }
  {
    Efter genomförd <a Searches>Sökning</a>, är det enkelt att navigera genom urvalet genom att hålla nere <b>Ctrl</b>
    tangenten samtidigt som du trycker upp- eller nerpiltangenterna för att gå till föregående eller nästa parti i
    <a Searches filtret>Urvalet</a>.
  }
{
  Du kan relativt enkelt rita pilar och färga rutor till dina kommentarer. Öppna <b>Kommentarseditorn</b>, klicka på <b>Infoga symbol</b> och välj önskad färg. Om du nu klickar på en första ruta, och därefter klickar på en andra så dras en pil i önskad färg från den första till den andra rutan. Klickar du bara på en ruta, blir den färgad.
  }
}

# end of swedish.tcl
