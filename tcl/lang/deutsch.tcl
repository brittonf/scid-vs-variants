### deutsch.tcl:
#  German language support for Scid.
#  Contributors: Bernhard Bialas, Jürgen Clos et al.
#  Untranslated messages are marked with a "***" comment.
#
#  Hinweis (aus tcl/lang/english.tcl):
#
# (4) [...]
#
#     A menu command has the format:
#         menuText L tag "Name..." underline {HelpMessage...}
#
#     [...]
#
#     where "L" is the language letter, "tag" is the name of the menu entry
#     or the button widget name, and "underline" is the index of the letter
#     to underline, counting from zero as the first letter. Two menu entries
#     that appear in the same menu should have a different underlined letter.

addLanguage D Deutsch 0 iso8859-1

proc setLanguage_D {} {

# File menu:
menuText D File "Datei" 0
menuText D FileNew "Neu..." 0 {Neue Scid-Datenbank anlegen}
menuText D FileOpen "Öffnen..." 0 {Existierende Scid-Datenbank öffnen}
menuText D FileClose "Schließen" 0 {Aktive Scid-Datenbank schließen}
menuText D FileFinder "Finder" 0 {Dateifinderfenster öffnen}
menuText D FileSavePgn "Save Pgn..." 0 {}
menuText D FileOpenBaseAsTree "Öffne DB als Baum" 0   {Öffne DB und verwende sie im Zugbaum-Fenster}
menuText D FileOpenRecentBaseAsTree "Letzte DB als Baum" 0   {Öffne zuletzt verwendete DB im Zugbaum-Fenster}
menuText D FileBookmarks "Lesezeichen" 0 {Lesezeichenmenü (Tasten: Strg+B)}
menuText D FileBookmarksAdd "Lesezeichen zur Liste hinzufügen" 0 \
  {Lesezeichen für die aktuelle Partie und Datenbank}
menuText D FileBookmarksFile "Lesezeichen hinzufügen in Verzeichnis" 26 \
  {Lesezeichen für die aktuelle Stellung und Partie zum Verzeichnis hinzufügen}
menuText D FileBookmarksEdit "Lesezeichen editieren..." 12 \
  {Lesezeichen bearbeiten}
menuText D FileBookmarksList "Listenansicht" 1 \
  {Lesezeichen als Liste zeigen, ohne Unterverzeichnisse}
menuText D FileBookmarksSub "Verzeichnisansicht" 3 \
  {Lesezeichen in Verzeichnissen zeigen, nicht als Gesamtliste}
menuText D FileReadOnly "Schreibschutz..." 3 \
  {Datenbank als schreibgeschützt behandeln, Änderungen verhindern}
menuText D FileSwitch "Datenbank wechseln" 0 \
  {Zu einer anderen geöffneten Datenbank umschalten}
menuText D FileExit "Ende" 0 {Scid beenden}

# Edit menu:
menuText D Edit "Bearbeiten" 0
menuText D EditAdd "Variante hinzufügen" 0 \
  {Füge zu diesem Zug eine Variante hinzu}
menuText D EditPasteVar "Paste Variation" 0
menuText D EditDelete "Variante löschen" 9 \
  {Lösche eine Variante zu diesen Zug}
menuText D EditFirst "Als erste Variante setzen" 4 \
  {Variante an erste Stelle in der Liste setzten}
menuText D EditMain "Variante als Partiefortsetzung" 13 \
  {Variante zur Partiefolge machen (und umgekehrt)}
menuText D EditTrial "Variante testen" 9 \
  {Testmodus starten/stoppen, um eine Idee am Brett auszuprobieren}
menuText D EditStrip "Entfernen" 1 \
   {Kommentare oder Varianten aus der Partie entfernen}
menuText D EditUndo "Rückgängig" 0 {Macht die letzte Änderung rückgängig}
# todo
menuText D EditRedo "Redo" 0
menuText D EditStripComments "Kommentare" 0 \
  {Alle Kommentare und Kommentarzeichen aus dieser Partie entfernen}
menuText D EditStripVars "Varianten" 0 \
  {Alle Varianten aus der Partie entfernen}
menuText D EditStripBegin "Züge ab Anfang" 8 \
  {Entferne Züge ab Partieanfang}
menuText D EditStripEnd "Züge bis Ende" 9 \
  {Entferne Züge bis Partieende}
menuText D EditReset "Ablage leeren" 0 \
   {Inhalt der Ablage-Datenbank löschen}
menuText D EditCopy "Partie in Ablage kopieren" 17 \
  {Diese Partie in die Ablage-Datenbank kopieren}
menuText D EditPaste "Partie aus Ablage einfügen" 19 \
  {Aktive Partie aus der Ablage hier einfügen}
menuText D EditPastePGN "PGN-Partie aus Ablage einfügen..." 1 \
  {Interpretiere den Inhalt der Zwischenablage als PGN-Notation und füge ihn hier ein}
menuText D EditSetup "Stellungseingabe..." 0 \
  {Neue Stellung eingeben (FEN oder manuell)}
menuText D EditCopyBoard "Stellung kopieren" 10 \
  {Aktuelle Brettposition in die Zwischenablage kopieren (im FEN-Format)}
menuText D EditCopyPGN "Stellung PGN" 10 {}
menuText D EditPasteBoard "Stellung einfügen" 12 \
  {Stellung aus der Zwischenablage (im FEN-Format) einfügen}

# Game menu:
menuText D Game "Partie" 0
menuText D GameNew "Neue Partie" 5 \
  {Neue Partie beginnen, dabei alle Änderungen verwerfen}
menuText D GameFirst "Erste Partie laden" 0 {Erste Partie im Filter laden}
menuText D GamePrev "Vorherige Partie laden" 0 \
  {Vorherige Partie im Filter laden}
menuText D GameReload "Partie neu laden" 7 \
  {Diese Partie erneut laden, dabei alle Änderungen verwerfen}
menuText D GameNext "Nächste Partie laden" 0 {Nächste Partie im Filter laden}
menuText D GameLast "Letzte Partie laden" 0 {Letzte Partie im Filter laden}
menuText D GameRandom "Zufällige Partie laden" 1 \
  {Zufällig ausgewählte Partie im Filter laden}
menuText D GameNumber "Lade Partie Nummer..." 14 \
  {Partie durch Angabe der Nummer laden}
menuText D GameReplace "Partie ersetzen..." 8 \
  {Diese Partie sichern, dabei alte Version überschreiben}
menuText D GameAdd "Partie speichern..." 7 \
  {Diese Partie als neue Partie in der Datenbank sichern}
menuText D GameInfo "Set Game Information" 9
menuText D GameBrowse "Spiele durchsuchen" 0
menuText D GameList "Alle Spiele" 0
menuText D GameDelete "Spiel löschen" 0
menuText D GameDeepest "Eröffnung identifizieren" 10 \
  {Zur Position der längstmöglichen Zugfolge nach ECO-Klassifikation gehen}
menuText D GameGotoMove "Zugnummer..." 0 \
  {Zur angegebenen Zugnummer in der aktuellen Partie gehen}
menuText D GameNovelty "Finde Neuerung..." 0 \
  {Ersten Zug dieser Partie finden, der vorher noch nie gespielt wurde}

# Search menu:
menuText D Search "Suchen" 0
menuText D SearchReset "Filter zurücksetzen" 0 \
  {Alle Partien in den Filter einschließen}
menuText D SearchNegate "Filter invertieren" 7 {Alle ausgeschlossenen Partien in den Filter nehmen}
menuText D SearchEnd "Umzug nach Last-Filter" 0
menuText D SearchCurrent "Brett..." 0 \
  {Aktuelle Brettposition suchen}
menuText D SearchHeader "Partiedaten..." 0 \
  {Partiedaten (Spieler, Turnier etc.) suchen}
menuText D SearchMaterial "Material/Muster..." 0 \
  {Nach Material- oder Stellungsmustern suchen}
menuText D SearchMoves {Züge} 0 {}
menuText D SearchUsing "Mit Suchoptionsdatei..." 4 \
  {Mit Suchoptionsdatei suchen}

# Windows menu:
menuText D Windows "Fenster" 0
menuText D WindowsGameinfo "Partieinformation anzeigen" 0 {Partieinformation anzeigen}
menuText D WindowsComment "Kommentareditor" 0 {Kommentareditor öffnen/schließen}
menuText D WindowsGList "Partieliste" 6 {Partieliste öffnen/schließen}
menuText D WindowsPGN "PGN-Fenster" 0 {PGN-Fenster (Partienotation) öffnen/schließen}
menuText D WindowsCross "Kreuztabelle" 0 {Kreuztabelle für diese Partie anzeigen}
menuText D WindowsPList "Spielersuche" 0 {Spielerfinder öffnen/schließen}
menuText D WindowsTmt "Turniersuche" 0 {Turnierfinder öffnen/schließen}
menuText D WindowsSwitcher "Datenbank-Umschalter" 0 \
  {Datenbank-Umschalter öffnen/schließen}
menuText D WindowsMaint "Wartungsfenster" 0 {(Datenbank-)Wartungsfenster öffnen/schließen}
menuText D WindowsECO "ECO-Auswertung" 0 {ECO-Auswertung öffnen/schließen}
menuText D WindowsStats "Statistik" 4 {Filterstatistik öffnen/schließen}
menuText D WindowsTree "Zugbaum" 0 {Zugbaum öffnen/schließen}
menuText D WindowsTB "Endspieltabellen..." 1 {Endspieltabellen öffnen/schließen}
menuText D WindowsBook "Buchfenster" 0 {Buchfenster öffnen/schließen}
menuText D WindowsCorrChess "Fernschachfenster" 0 {Öffnet/schließt das Fernschachfenster}

# Tools menu:
menuText D Tools "Werkzeuge" 0
menuText D ToolsAnalysis "Analyse-Engine..." 0 \
  {Schachanalyse-Programm starten/beenden}
menuText D ToolsEmail "E-Mail-Manager" 7 \
  {E-Mail-Manager öffnen/schließen}
menuText D ToolsFilterGraph "Rel. Filtergrafik" 0 \
  {Filtergrafik mit relativen Werten öffnen/schließen}
menuText D ToolsAbsFilterGraph "Abs. Filtergrafik" 11 \
  {Filtergrafik mit absoluten Werten öffnen/schließen}
menuText D ToolsOpReport "Eröffnungsbericht" 0 \
  {Ausführliche Eröffnungsübersicht für die aktuelle Position erstellen}
menuText D ToolsTracker "Figurenverteilung"  7 \
  {Figurenverteilungsfenster öffnen}
menuText D ToolsTraining "Training"  0 {Trainingswerkzeuge (Taktik, Eröffnungen,...) }
menuText D ToolsComp "Tournament" 2 {Chess engine tournament}
menuText D ToolsTacticalGame "Trainingspartie"  0 {Trainingspartie spielen}
menuText D ToolsSeriousGame "Ernste Partie"  0 {Ernste Partie spielen}
menuText D ToolsTrainTactics "Taktik"  0 {Taktische Stellungen lösen}
menuText D ToolsTrainCalvar "Varianten berechnen"  0 {Training zum Berechnen von Varianten}
menuText D ToolsTrainFindBestMove "Besten Zug finden"  0 {Find best move}
menuText D ToolsTrainFics "Internetpartie"  0 {Internetpartie auf freechess.org}
menuText D ToolsBookTuning "Buch abstimmen" 0 {Buch abstimmen}
menuText D ToolsMaint "Wartung" 0 {Das Scid-Datenbankwartungsfenster}
menuText D ToolsMaintWin "Wartungfenster" 0 \
  {Datenbank-Wartungsfenster öffnen/schließen}
menuText D ToolsMaintCompact "Datenbank komprimieren..." 10 \
  {Datenbank komprimieren, gelöschte Spiele und unbenutzte Namen entfernen}
menuText D ToolsMaintClass "Partien ECO-klassifizieren..." 8 \
{Neuklassifizierung aller Partien nach dem ECO-Code}
menuText D ToolsMaintSort "Sortieren..." 0 \
  {Alle Partien in der aktuellen Datenbank sortieren}
menuText D ToolsMaintDelete "Dubletten löschen..." 0 \
  {Dubletten finden und Löschkennzeichen setzen}
menuText D ToolsMaintTwin "Dubletten prüfen" 10 \
  {Dublettenfenster öffnen/erneuern}
menuText D ToolsMaintNameEditor "Namenseditor" 0 \
  {Namenseditorfenster öffnen/schließen}
menuText D ToolsMaintNamePlayer "Schreibkorrektur Spieler..." 17 \
  {Schreibkorrektur der Spielernamen mit Hilfe der .ssp-Datei}
menuText D ToolsMaintNameEvent "Schreibkorrektur Ereignis..." 17 \
  {Schreibkorrektur der Ereignisse mit Hilfe der .ssp-Datei}
menuText D ToolsMaintNameSite "Schreibkorrektur Ort..." 17 \
  {Schreibkorrektur der Orte mit Hilfe der .ssp-Datei}
menuText D ToolsMaintNameRound "Schreibkorrektur Runde..." 17 \
  {Schreibkorrektur der Runden mit Hilfe der .ssp-Datei}
menuText D ToolsMaintFixBase "Inkonsistenzen beseitigen" 0 {Versuche eine inkonsistente Datenbank zu reparieren}
menuText D ToolsConnectHardware "Hardware verbinden" 0 {Externe Hardware mit Scid verbinden}
menuText D ToolsConnectHardwareConfigure "Konfigurieren..." 0 {Hardware und Verbindung konfigurieren}
menuText D ToolsConnectHardwareNovagCitrineConnect "Novag Citrine verbinden" 0 {Novag Citrine mit Scid verbinden}
menuText D ToolsConnectHardwareInputEngineConnect "Input Engine verbinden" 0 {Input Engine (z.B. DGT Brett) mit Scid verbinden}
menuText D ToolsNovagCitrine "Novag Citrine" 0 {Novag Citrine}
menuText D ToolsNovagCitrineConfig "Einstellungen" 0 {Novag Citrine Einstellungen}
menuText D ToolsNovagCitrineConnect "Verbinden" 0 {Novag Citrine verbinden}
menuText D ToolsPInfo "Spielerinformation"  0 \
  {Spielerinformation öffnen/schließen}
menuText D ToolsPlayerReport "Spielerbericht" 7 \
  {Erzeuge einen Spielerbericht}
menuText D ToolsRating "ELO-Zahl-Verlauf" 4 \
  {Wertungsverlauf beider Spieler grafisch darstellen}
menuText D ToolsScore "Partiebewertungsgraph" 0 {Partie-Bewertungsgraph zeigen}
menuText D ToolsExpCurrent "Partie exportieren" 8 \
  {Aktuelle Partie in eine Textdatei schreiben}
menuText D ToolsExpCurrentPGN "Partie in PGN-Datei exportieren..." 10 \
  {Aktuelle Partie in eine PGN-Datei schreiben}
menuText D ToolsExpCurrentHTML "Partie in HTML-Datei exportieren..." 10 \
  {Aktuelle Partie in eine HTML-Datei schreiben}
menuText D ToolsExpCurrentHTMLJS "Partie in HTML/JavaScript-Datei exportieren..." 15 {Aktuelle Partie wird in eine HTML und JavaScript Datei exportiert.}  
menuText D ToolsExpCurrentLaTeX "Partie in LaTeX-Datei exportieren..." 10 \
  {Aktuelle Partie in eine LaTeX-Datei schreiben}
# ====== TODO To be translated ======
menuText D ToolsExpFilter "Alles im Filter exportieren" 16 \
  {Alle Partien im Filter in eine Textdatei schreiben}
menuText D ToolsExpFilterPGN "Filter in PGN-Datei exportieren..." 10 \
  {Alle Partien im Filter in eine PGN-Datei schreiben}
menuText D ToolsExpFilterHTML "Filter in HTML-Datei exportieren..." 10 \
  {Alle Partien im Filter in eine HTML-Datei schreiben}
menuText D ToolsExpFilterHTMLJS "Filter in HTML/JavaScript exportieren..." 17 {Alle Partien im Filter werden in eine HTML und JavaScript Datei exportiert.}  
menuText D ToolsExpFilterLaTeX "Filter in LaTeX-Datei exportieren..." 10 \
  {Alle Partien im Filter in eine LaTeX-Datei schreiben}
# ====== TODO To be translated ======
# ====== TODO To be translated ======
menuText D ToolsExpFilterGames "Export Gamelist to Text" 19 {Print a formatted Gamelist.}
menuText D ToolsImportOne "Eine PGN-Partie importieren..." 16 \
  {Eine Partie im PGN-Format eingeben oder einfügen}
menuText D ToolsImportFile "PGN-Partien importieren..." 0 \
  {Partien aus einer PGN-Datei lesen}
menuText D ToolsStartEngine1 "Starte Engine1" 0  {Starte Analyse von Analyse-Engine1}
menuText D ToolsStartEngine2 "Starte Engine2" 0  {Starte Analyse von Analyse-Engine2}
menuText D ToolsScreenshot "Foren-Screenshot" 0
#-----AW------
menuText D Play "Spielen" 0 {Partien spielen}
menuText D CorrespondenceChess "Fernschach" 0 {Funktionen für E-Mail und Xfcc basiertes Fernschach}
menuText D CCConfigure "Einstellungen..." 0 {Generelle Einstellungen und externe Werkzeuge}
menuText D CCConfigRelay "Beobachtete Partien..." 10 {Configure games to be observed}
menuText D CCOpenDB "Datenbank öffnen..." 0 {Öffnet die Standarddatenbank für Fernschachpartien}
menuText D CCRetrieve "Partien synchronisieren" 0 {Synchronisiert Partien mit dem Posteingang und mittels (Xfcc-)Hilfsprogramm}
menuText D CCInbox "Posteingang synchronisieren" 12 {Synchronisiert alle Partien im Posteingang}
menuText D CCSend "Zug senden" 0 {Verschickt den letzten Zug via E-Mail oder exterem (Xfcc-)Hilfsprogramm}
menuText D CCResign "Aufgeben" 0 {Partie aufgeben (funktioniert nicht via E-Mail)}
menuText D CCClaimDraw "Remis erklären" 1 {Zug senden und Partie Remis erklären (funktioniert nicht via E-Mail)}
menuText D CCOfferDraw "Remis anbieten" 0 {Zug senden und Remis anbieten (funktioniert nicht via E-Mail)}
menuText D CCAcceptDraw "Remis annehmen" 10 {Remis annehmen (funktioniert nicht via E-Mail)}
menuText D CCNewMailGame "Neue E-Mail Partie..." 0 {Beginnt eine neue Partie via E-Mail}
menuText D CCMailMove "Zug per E-Mail senden..." 9 {Verschickt den letzten Zug per E-Mail}
menuText D CCGamePage "Partieseite (WWW)..." 13 {Ruft die Webseite der Partie auf}
menuText D CCEditCopy "Partieliste in Ablage" 0 {Kopiert die Parieliste als CSV in die Zwischenablage}
#-----AW------

# Options menu:
menuText D Options "Optionen" 0
menuText D OptionsBoard "Schachbrett" 6 {Schachbrettoptionen}
menuText D OptionsColour "Hintergrundfarbe" 0 {Default text widget color}
# ====== TODO To be translated ======
menuText D OptionsBackColour "Background" 0 {Default text widget color}
menuText D OptionsEnableColour "Einschalten" 0 {}
# ====== TODO To be translated ======
menuText D OptionsMainLineColour "Mainline Arrows" 0 {Mainline arrows}
# ====== TODO To be translated ======
menuText D OptionsVarLineColour "Variation Arrows" 0 {Variation arrows}
# ====== TODO To be translated ======
menuText D OptionsRowColour "Rows" 0 {Default tree/book row color}
# ====== TODO To be translated ======
menuText D OptionsSwitcherColour "Switcher" 0 {Default db switcher color}
# ====== TODO To be translated ======
menuText D OptionsProgressColour "Progressbar" 0 {Default progressbar color}
# ====== TODO To be translated ======
menuText D OptionsCrossColour "Crosstable rows" 0 {Default crosstable row color}
menuText D OptionsNames "Meine Spielernamen..." 0 {Editiere meine Spielernamen}
menuText D OptionsExport "Export" 1 {Textausgabeoptionen ändern}
menuText D OptionsFonts "Schriftarten" 3 {Schriftart wechseln}
menuText D OptionsFontsRegular "Normal" 0 {Standardzeichensatz}
menuText D OptionsFontsMenu "Menü" 0 {Schriftart für Menüs}
menuText D OptionsFontsSmall "Klein" 0 {Kleine Zeichen}
menuText D OptionsFontsFixed "Fest" 0 {Schriftart mit fester Breite (nicht-proportional)}
menuText D OptionsGInfo "Partieinformation" 0 {Optionen für Informationsbereich}
menuText D OptionsFics "FICS" 0
# ====== TODO To be translated ======
menuText D OptionsFicsAuto "Autopromote Königin" 0
menuText D OptionsFicsColour "Textfarbe" 0
menuText D OptionsFicsSize "Brettgröße" 0
# ====== TODO To be translated ======
menuText D OptionsFicsButtons "User Buttons" 0
menuText D OptionsFicsCommands "Startbefehle" 0
menuText D OptionsFicsNoRes "Keine Ergebnisse" 0
menuText D OptionsFicsNoReq "Keine Anfragen" 0
# ====== TODO To be translated ======
menuText D OptionsFicsPremove "Allow Premove" 0
menuText D OptionsLanguage "Sprache" 0 {Sprache wählen}
menuText D OptionsMovesTranslatePieces "Figurennamen übersetzen" 0 {Übersetze den ersten Buchstaben der Figurenbezeichnung}
menuText D OptionsMovesHighlightLastMove "Letzen Zug hervorheben" 0 {Rahmt Start- und Zielfeld des letzten Zuges farbig ein}
menuText D OptionsMovesHighlightLastMoveDisplay "Anzeigen" 0 {Hervorhebung des letzen Zuges anzeigen}
menuText D OptionsMovesHighlightLastMoveWidth "Dicke" 0 {Dicke der Linie}
menuText D OptionsMovesHighlightLastMoveColor "Farbe" 0 {Farbe der Linie}
menuText D OptionsMoves "Züge" 0 {Zugeingabeoptionen}
menuText D OptionsMovesAsk "Fragen vor Ersetzen" 0 \
  {Vor Überschreiben existierender Züge nachfragen}
menuText D OptionsMovesAnimate "Animation" 0 \
  {Zeit für Zuganimation einstellen}
menuText D OptionsMovesDelay "Autom. Vorspielen..." 7 \
  {Zeit für automatisches Vorspielen einstellen}
menuText D OptionsMovesCoord "Tastatureingabe" 0 \
  {Zugeingabe über Koordinaten ("g1f3") akzeptieren}
menuText D OptionsMovesSuggest "Zugvorschlag zeigen" 0 \
  {Zugvorschlag ein-/ausschalten}
menuText D OptionsShowVarPopup "Variantenfenster zeigen" 0 { Anzeige des Variantenauswahlfensters ein/ausschalten}  
menuText D OptionsMovesSpace "Leerzeichen nach Zugnummer einfügen" 0 {Leerzeichen nach Zugnummer einfügen}  
menuText D OptionsMovesKey "Autom. Zugergänzung" 10 \
  {Automatische Zugergänzung ein-/ausschalten}
menuText D OptionsMovesShowVarArrows "Pfeile für Varianten anzeigen" 0 {Zeige Pfeile in Varianten an: ja/nein}
menuText D OptionsNumbers "Zahlenformat" 5 {Zahlenformat wählen}
menuText D OptionsStartup "Autostart" 1 {Fenster zum Öffnen bei Start auswählen}
menuText D OptionsTheme "Design" 0 {Verändert das Aussehen der Oberfläche}
menuText D OptionsWindows "Fenster" 6 {Fenster-Optionen}
menuText D OptionsWindowsIconify "Autom. minimieren" 7 \
  {Alle Fenster mit dem Hauptfenster minimieren}
menuText D OptionsWindowsRaise "Autom. Verwaltung" 7 \
  {Bestimmte Fenster (z.B. Zustandsleiste) bei Bedarf öffnen}
menuText D OptionsSounds "Töne..." 0 {Töne für Zugankündigung einstellen} ;# *** Hmm, :-|
menuText D OptionsWindowsDock "Fenster docken" 0 {Fenster docken}
menuText D OptionsWindowsSaveLayout "Layout speichern" 0 {Das Fensterlayout abspeichern}
menuText D OptionsWindowsRestoreLayout "Layout wiederherstellen" 0 {Das gespeicherte Fensterlayout wiederherstellen}
menuText D OptionsWindowsShowGameInfo "Partieinformationen" 0 {Partieinformation anzeigen}
menuText D OptionsWindowsAutoLoadLayout "Automatisch laden: 1. Layout" 0 {Lädt das erste definierte Layout automatisch beim Programmstart}
menuText D OptionsWindowsAutoResize "Brettgröße autom. anpassen" 0 {}
# ====== TODO To be translated ======
menuText D OptionsWindowsFullScreen "Vollbild" 0 {Vollbild Modus umschalten}
menuText D OptionsToolbar "Werkzeugleiste" 0 {Werkzeug- bzw. Symbolleiste Ein/Aus}
menuText D OptionsECO "ECO-Datei laden..." 0 {ECO-Klassifikationsdatei laden}
menuText D OptionsSpell "Schreibkorrekturdatei laden..." 7 \
  {Datei für Scid-Rechtschreibprüfung laden}
menuText D OptionsTable "Endspieltabellenverzeichnis..." 16 \
  {Eine Endspieltabellendatei wählen (und damit alle Tabellen in diesem Verzeichnis)}
menuText D OptionsRecent "Aktuelle Dateien..." 9 \
  {Anzahl der aktuellen Dateien im Dateimenü ändern}
menuText D OptionsBooksDir "Buchverzeichnis..." 0 {Eröffnungsbuchverzeichnis einstellen}
menuText D OptionsTacticsBasesDir "Bases Verzeichnis..." 0 {Verzeichnis für taktische Trainingsdatenbanken einstellen}
menuText D OptionsSave "Optionen speichern" 0 \
  "Alle einstellbaren Optionen in der Datei $::optionsFile sichern"
menuText D OptionsAutoSave "Autom. speichern bei Beenden" 0 \
  {Alle Optionen beim Beenden von Scid automatisch speichern}

# Help menu:
menuText D Help "Hilfe" 0
menuText D HelpContents "Inhalt" 0 {Gehe zum Inhaltsverzeichnis}
menuText D HelpIndex "Index" 4 {Gehe zum Hilfeindex}
menuText D HelpGuide "Kurzanleitung" 4 {Ein Scid-Schnelldurchgang}
menuText D HelpHints "Hinweise" 0 {Die Scid-Kurztips}
menuText D HelpContact "Kontaktinformation" 0 {Hilfe zur Kontaktinformation}
menuText D HelpTip "Tagestip" 0 {Zeigt einen nützlichen Tip an}
menuText D HelpStartup "Startfenster" 0 {Startfenster zeigen}
menuText D HelpAbout "Über Scid" 0 {Informationen zu Scid}

# Game info box popup menu:
menuText D GInfoHideNext "Nächsten Zug verstecken" 13
menuText D GInfoShow "Zugrecht anzeigen" 0
menuText D GInfoCoords "Koordinaten anzeigen" 0
menuText D GInfoMaterial "Materialwerte zeigen" 0
menuText D GInfoFEN "FEN zeigen" 0
menuText D GInfoMarks "Gefärbte Felder und Pfeile zeigen" 0
menuText D GInfoWrap "Umbruch bei langen Zeilen" 0
menuText D GInfoFullComment "Vollständigen Kommentar zeigen" 14
menuText D GInfoPhotos "Fotos zeigen" 1
menuText D GInfoTBNothing "Endspieltabellen: nichts" 18
menuText D GInfoTBResult "Endspieltabellen: nur Ergebnis" 22
menuText D GInfoTBAll "Endspieltabellen: Ergebnis und bester Zug" 31
menuText D GInfoDelete "(Ent)Lösche diese Partie" 5
menuText D GInfoMark "(Un)Markiere diese Partie" 4
menuText D GInfoInformant "Informatorwerte konfigurieren" 0
translate D FlipBoard {Brett drehen}
# ====== TODO To be translated ======
translate D RaiseWindows {Raise windows}
translate D AutoPlay {Abspielen}
translate D TrialMode {Züge ausprobieren}

# General buttons:
# todo
translate D Apply {Übernehmen}
translate D Back {Zurück}
translate D Browse {Durchstöbern}
translate D Cancel {Abbrechen}
translate D Continue {Weiter}
translate D Clear {Leeren}
translate D Close {Schließen}
translate D Contents {Inhalt}
translate D Defaults {Standard}
translate D Delete {Lösche}
translate D Graph {Grafik}
translate D Help {Hilfe}
translate D Import {Importieren}
translate D Index {Index}
translate D LoadGame {Partie laden}
translate D BrowseGame {Partie betrachten}
translate D MergeGame {Partie kombinieren} ;# mischen?! einfügen!?
translate D MergeGames {Partien kombinieren}
translate D Preview {Vorschau} ;# Voransicht!? (KDE)
translate D Revert {Umkehren}
translate D Save {Speichern}
# ====== TODO To be translated ======
translate D DontSave {Don't Save}
translate D Search {Suchen}
translate D Stop {Halt}
translate D Store {Speichern}
translate D Update {Aktualisieren}
translate D ChangeOrient {Fensterausrichtung ändern}
translate D ShowIcons {Icons anzeigen} ;# ***
# ====== TODO To be translated ======
translate D ConfirmCopy {Confirm Copy}
translate D None {Keine}
translate D First {Erste}
translate D Current {Aktuelle}
translate D Last {Letzte}
# ====== TODO To be translated ======
translate D Font {Font}
# ====== TODO To be translated ======
translate D Change {Change}
# ====== TODO To be translated ======
translate D Random {Random}

# General messages:
translate D game {Partie}
translate D games {Partien}
translate D move {Zug}
translate D moves {Züge}
translate D all {Alle}
translate D Yes {Ja}
translate D No {Nein}
translate D Both {Beide}
translate D King {König}
translate D Queen {Dame}
translate D Rook {Turm}
translate D Bishop {Läufer}
translate D Knight {Springer}
translate D Pawn {Bauer}
translate D White {Weiß}
translate D Black {Schwarz}
translate D Player {Spieler}
translate D Rating {Elo}
translate D RatingDiff {Elo-Differenz (Weiß - Schwarz)}
translate D AverageRating {Elo-Durchschnitt}
translate D Event {Turnier}
translate D Site {Ort}
translate D Country {Land}
translate D IgnoreColors {Farben ignorieren}
# ====== TODO To be translated ======
translate D MatchEnd {End pos only}
translate D Date {Datum}
translate D EventDate {Turnierdatum}
translate D Decade {Dekade}
translate D Year {Jahr}
translate D Month {Monat}
translate D Months {Januar Februar März April Mai Juni Juli August September Oktober November Dezember}
translate D Days {Son Mon Die Mit Don Fre Sam}
translate D YearToToday {Ein Jahr zurück}
translate D Result {Ergebnis}
translate D Round {Runde}
translate D Length {Länge}
translate D ECOCode {ECO-Code}
translate D ECO {ECO}
translate D Deleted {Gelöscht}
translate D SearchResults {Suchergebnisse}
translate D OpeningTheDatabase {Datenbank öffnen}
translate D Database {Datenbank}
translate D Filter {Filter}
translate D Reset {Zurücksetzen}
translate D IgnoreCase {Ignoriert Groß}
translate D noGames {keine Partien}
translate D allGames {alle Partien}
translate D empty {leer}
translate D clipbase {Ablage}
translate D score {Punkte}
translate D Start {Start}
translate D StartPos {Stellung}
translate D Total {Summe}
translate D readonly {schreibgeschützt}
translate D altered {geändert}
# ====== TODO To be translated ======
translate D tagsDescript {Extra tags (eg: Annotator "Anand")}
# ====== TODO To be translated ======
translate D prevTags {Use previous}

# Standard error messages:
translate D ErrNotOpen {Dies ist keine geöffnete Datenbank.}
translate D ErrReadOnly \
  {Diese Datenbank ist schreibgeschützt; sie kann nicht geändert werden.}
translate D ErrSearchInterrupted \
  {Suche wurde unterbrochen; Ergebnisse sind unvollständig.}

# Game information:
translate D twin {Dublette}
translate D deleted {gelöscht}
translate D comment {Kommentar}
translate D hidden {versteckt}
translate D LastMove {Letzter Zug}
translate D NextMove {Nächster Zug}
translate D GameStart {Partieanfang}
translate D LineStart {Beginn der Zugfolge}
translate D GameEnd {Partieende}
translate D LineEnd {Ende der Zugfolge}

# Player information:
translate D PInfoAll {Alle Spiele}
translate D PInfoFilter {Filter-Spiele}
translate D PInfoAgainst {Ergebnisse gegen}
translate D PInfoMostWhite {Häufigste Eröffnungen als Weißer}
translate D PInfoMostBlack {Häufigste Eröffnungen als Schwarzer}
translate D PInfoRating {ELO-Historie}
translate D PInfoBio {Biographie}
translate D PInfoEditRatings {Bewertung bearb.}
translate D PinfoEditName {Name ändern}
translate D PinfoLookupName {Name suchen}

# Tablebase information:
translate D Draw {Remis}
translate D stalemate {Patt}
# ====== TODO To be translated ======
translate D checkmate {checkmate}
translate D withAllMoves {mit allen Zügen}
translate D withAllButOneMove {mit allen außer einem Zug}
translate D with {mit}
translate D only {nur}
translate D lose {verlieren}
translate D loses {verliert}
translate D allOthersLose {alle anderen verlieren}
translate D matesIn {setzt Matt in}
translate D longest {längste}
translate D WinningMoves {Gewinnzüge}
translate D DrawingMoves {Remiszüge}
translate D LosingMoves {Verlustzüge}
translate D UnknownMoves {Züge mit unbekanntem Resultat}

# Tip of the day:
translate D Tip {Tipp}
translate D TipAtStartup {Tipp beim Starten}

# Tree window menus:
menuText D TreeFile "Datei" 0
menuText D TreeFileFillWithBase "Cache mit Datenbank füllen" 0 {Die Cache-Datei wird mit allen Partien der aktuellen Datenbank befüllt.}
menuText D TreeFileFillWithGame "Cache mit Partie füllen" 0 {Die Cache-Datei wird mit der aktuellen Partien befüllt.}
menuText D TreeFileSetCacheSize "Cachegröße" 0 {Cachegröße auswählen.}
menuText D TreeFileCacheInfo "Cache Informationen" 0 {Info über Cachenutzung anzeigen.}
menuText D TreeFileSave "Cache-Datei sichern" 12 \
  {Speichere die Zugbaum-Cache-Datei (.stc)}
menuText D TreeFileFill "Cache-Datei füllen" 12 \
  {Fülle die Cache-Datei mit häufigen Eröffnungspositionen}
menuText D TreeFileBest "Beste Partien" 0 \
  {Zeige die Liste bester Partien im Baum}
menuText D TreeFileGraph "Grafikfenster" 0 \
  {Zeige die Grafik für diesen Ast}
menuText D TreeFileCopy "Kopiere Baumfenster in Zwischenablage" 0 \
  {Kopiere die Zugbaum-Statistik in die Zwischenablage}
menuText D TreeFileClose "Baumfenster schließen" 12 {Schließe Zugbaum}
menuText D TreeMask "Maskieren" 0
menuText D TreeMaskNew "Neu" 0 {Neue Maske anlegen}
menuText D TreeMaskOpen "Öffnen" 0 {Maske öffnen}
menuText D TreeMaskOpenRecent "Aktuelle Masken" 0 {Zuletzt geöffnete Masken erneut laden}
menuText D TreeMaskSave "Speichern" 0 {Maske speichern}
menuText D TreeMaskClose "Schließen" 0 {Maske schließen}
# ====== TODO To be translated ======
menuText D TreeMaskFillWithLine "Fill with line" 0 {Fill mask with all previous moves}
menuText D TreeMaskFillWithGame "Mit aktueller Partie füllen" 0 {Maske mit der aktuellen Partie füllen}
menuText D TreeMaskFillWithBase "Mit Datenbank füllen" 0 {Maske mit Datenbankpartien füllen}
menuText D TreeMaskInfo "Info" 0 {Statistik für die aktuelle Maske anzeigen}
menuText D TreeMaskDisplay "Maske als Baum" 0 {Zeigt den Inhalt der aktuellen Maske als Zugbaum}
menuText D TreeMaskSearch "Suchen" 0 {Suchen innerhalb der aktuellen Maske}
menuText D TreeSort "Sortieren" 0
menuText D TreeSortAlpha "Alphabetisch" 0
menuText D TreeSortECO "ECO-Code" 0
menuText D TreeSortFreq "Häufigkeit" 0
menuText D TreeSortScore "Punkte" 0
menuText D TreeOpt "Optionen" 0
menuText D TreeOptSlowmode "Gründliche Suche" 0 {Update mit hoher Genauigkeit, langsamer}
menuText D TreeOptFastmode "Schneller Modus" 0 {Schnelles Update (ignoriert Zugumstellungen)}
menuText D TreeOptFastAndSlowmode "Gründlicher und Schneller Modus" 0 {Zunächst schneller Updatemodus, dann nacharbeit im gründlichen Modus}
menuText D TreeOptStartStop "Automatisch aktualisieren" 0 {Schaltet das automatische aktualisieren ein/aus}
menuText D TreeOptLock "Anbinden" 0 \
  {Zugbaum an aktive Datenbank anbinden(/lösen)}
menuText D TreeOptTraining "Training" 0 {Trainingsmodus ein-/ausschalten}
# ====== TODO To be translated ======
menuText D TreeOptShort "Short Display" 0 {Don't show ELO information}
menuText D TreeOptAutosave "Autom. Cache-Datei sichern" 4 \
  {Beim Schließen des Zugbaums automatisch Cache-Datei sichern}
# ====== TODO To be translated ======
menuText D TreeOptAutomask "Auto-Load Mask" 0 "Auto-Load most recent mask with a tree open."
# ====== TODO To be translated ======
menuText D TreeOptShowBar "Show Progress Bar" 0 "Show tree progress bar."
# ====== TODO To be translated ======
menuText D TreeOptSortBest "Sort Best Games" 0 "Sort Best Games by ELO."
menuText D TreeHelp "Hilfe" 0
menuText D TreeHelpTree "Zugbaumhilfe" 0
menuText D TreeHelpIndex "Index" 0


translate D SaveCache {Cache sichern}
translate D Training {Training}
translate D LockTree {Anbinden}
translate D TreeLocked {angebunden}
translate D TreeBest {Beste}
translate D TreeBestGames {Beste Zugbaumpartien}
translate D TreeAdjust {Filter anpassen}
# Note: the next message is the tree window title row. After editing it,
# check the tree window to make sure it lines up with the actual columns.
translate D TreeTitleRow {    Zug       Häufigkeit    Pkte Remis  Elo  Erflg Jahr ECO}
translate D TreeTitleRowShort {    Zug       Häufigkeit    Pkte Remis}
translate D TreeTotal {SUMME}
translate D DoYouWantToSaveFirst {Soll zuerst gespeichert werden}
translate D AddToMask {Addiere zu Maske}
translate D RemoveFromMask {Entferne von Maske}
# TODO
translate D AddThisMoveToMask {Add Move to Mask}
translate D SearchMask {Suche in einer Maske}
translate D DisplayMask {Maske als Zugbaum}
translate D Nag {NAG Code}
translate D Marker {Marker}
translate D Include {Einbezogene Variante}
translate D Exclude {Ausgeschlossene Variante}
translate D MainLine {Hauptvariante}
translate D Bookmark {Lesezeichen}
translate D NewLine {Neue Variante}
translate D ToBeVerified {Überprüfen}
translate D ToTrain {Trainieren}
translate D Dubious {Zweifelhaft}
translate D ToRemove {Entfernen}
translate D NoMarker {Keine Markierung}
translate D ColorMarker {Farbe}
translate D WhiteMark {Weiß}
translate D GreenMark {Grün}
translate D YellowMark {Gelb}
translate D BlueMark {Blau}
translate D RedMark {Rot}
translate D CommentMove {Zug kommentieren}
translate D CommentPosition {Position kommentieren}
translate D AddMoveToMaskFirst {Zug zuerst zur Maske hinzufüngen}
translate D OpenAMaskFileFirst {Zunächst Maske öffnen}
translate D Positions {Positionen}
translate D Moves {Züge}

# Finder window:
menuText D FinderFile "Datei" 0
menuText D FinderFileSubdirs "Unterverzeichnisse beachten" 0
menuText D FinderFileClose "Dateifinder schließen" 0
menuText D FinderSort "Sortieren" 0
menuText D FinderSortType "Typ" 0
menuText D FinderSortSize "Größe" 0
menuText D FinderSortMod "Modifiziert" 0
menuText D FinderSortName "Namen" 0
menuText D FinderSortPath "Pfad" 0
menuText D FinderTypes "Typen" 0
menuText D FinderTypesScid "Scid-Datenbanken" 0
menuText D FinderTypesOld "Datenbanken im alten Format" 0
menuText D FinderTypesPGN "PGN-Dateien" 0
menuText D FinderTypesEPD "EPD-Dateien" 0
menuText D FinderHelp "Hilfe" 0
menuText D FinderHelpFinder "Dateifinderhilfe" 0
menuText D FinderHelpIndex "Index" 0
translate D FileFinder {Dateifinder}
translate D FinderDir {Verzeichnis}
translate D FinderDirs {Verzeichnisse}
translate D FinderFiles {Dateien}
translate D FinderUpDir {hoch}
translate D FinderCtxOpen {Öffnen}
translate D FinderCtxBackup {Sicherungskopie}
translate D FinderCtxCopy {Kopieren}
translate D FinderCtxMove {Verschieben}
translate D FinderCtxDelete {Löschen}

# Player finder:
menuText D PListFile "Datei" 0
menuText D PListFileUpdate "Aktualisieren" 0
menuText D PListFileClose "Spielerfinder schließen" 7
menuText D PListSort "Sortieren" 0
menuText D PListSortName "Name" 0
menuText D PListSortElo "Elo" 0
menuText D PListSortGames "Partien" 0
menuText D PListSortOldest "Älteste" 0
menuText D PListSortNewest "Neueste" 0

# Tournament finder:
menuText D TmtFile "Datei" 0
menuText D TmtFileUpdate "Aktualisieren" 0
menuText D TmtFileClose "Turnierfinder schließen" 0
menuText D TmtSort "Sortieren" 0
menuText D TmtSortDate "Datum" 0
menuText D TmtSortPlayers "Spieler" 0
menuText D TmtSortGames "Partien" 0
menuText D TmtSortElo "Elo" 0
menuText D TmtSortSite "Ort" 0
menuText D TmtSortEvent "Turnier" 1
menuText D TmtSortWinner "Gewinner" 0
translate D TmtLimit "Listengrenze"
translate D TmtMeanElo "Unterster Elo-Durchschnitt"
translate D TmtNone "Keine zutreffenden Turniere gefunden."

# Graph windows:
menuText D GraphFile "Datei" 0
menuText D GraphFileColor "Als Farb-Postscript speichern..." 4
menuText D GraphFileGrey "Als Graustufen-Postscript speichern..." 4
menuText D GraphFileClose "Fenster schließen" 0
menuText D GraphOptions "Optionen" 0
menuText D GraphOptionsWhite "Weiß" 0
menuText D GraphOptionsBlack "Schwarz" 0
menuText D GraphOptionsBoth "Beide" 0
menuText D GraphOptionsPInfo "Spielerinfo Spieler" 1
translate D GraphFilterTitle "Filtergrafik: Häufigkeit pro 1000 Partien"
translate D GraphAbsFilterTitle "Filtergrafik: Häufigkeit der Partien"
translate D ConfigureFilter "X-Achse für Jahr, Elo und Züge konfigurieren"
translate D FilterEstimate "Schätzen"
translate D TitleFilterGraph "Scid: Filtergrafik"

# Analysis window:
translate D AddVariation {Variante hinzufügen}
translate D AddAllVariations {Alle Varianten hinzufügen}
translate D AddMove {Zug hinzufügen}
translate D Annotate {Autom. kommentieren}
translate D ShowAnalysisBoard {Analysebrett anzeigen}
translate D ShowInfo {Engine-Information anzeigen}
translate D FinishGame {Partie beenden}
translate D StopEngine {Engine anhalten}
translate D StartEngine {Engine starten}
translate D ExcludeMove {Zug ausschließen}
translate D LockEngine {Anbinden an aktuelle Position}
translate D AnalysisCommand {Analysebefehl}
translate D PreviousChoices {Vorherige Wahl}
translate D AnnotateTime {Zeit zwischen den Zügen (in Sek.) einstellen}
translate D AnnotateWhich {Varianten hinzufügen}
translate D AnnotateAll {Für Züge beider Seiten}
translate D AnnotateAllMoves {Alle Züge kommentieren}
translate D AnnotateWhite {Nur für Züge von Weiß}
translate D AnnotateBlack {Nur für Züge von Schwarz}
translate D AnnotateNotBest {Wenn der Partiezug nicht der beste Zug ist}
translate D AnnotateBlundersOnly {Wenn der Partiezug ein offensichtlicher Fehler ist}
# ====== TODO To be translated ======
translate D BlundersNotBest {Blunders/Not Best}
translate D AnnotateBlundersOnlyScoreChange {Analyse berichtet Fehler, Bewertungsänderung von/nach: }
translate D AnnotateTitle {konfigurieren Annotation}
translate D BlundersThreshold {Grenze}
# ====== TODO To be translated ======
translate D ScoreFormat {Score format}
# ====== TODO To be translated ======
translate D CutOff {Cut Off}
translate D LowPriority {Niedrige CPU-Priorität}
translate D LogEngines {Log Größe}
# ====== TODO To be translated ======
translate D LogName {Namen hinzufügen}
# ====== TODO To be translated ======
translate D MaxPly {Max Ply}
translate D ClickHereToSeeMoves {Hier klicken um Züge anzuzeigen}
translate D ConfigureInformant {Informator konfigurieren}
translate D Informant!? {Interessanter Zug}
translate D Informant? {Schwacher Zug}
translate D Informant?? {Fehler}
translate D Informant?! {Zweifelhafter Zug}
translate D Informant+= {Weiß hat leichten Vorteil}
translate D Informant+/- {Weiß hat mäßigen Vorteil}
translate D Informant+- {Weiß hat großen Vorteil}
translate D Informant++- {Partie wird gewonnen}
translate D Book {Buch}

# Analysis Engine open dialog:
translate D EngineList {Analyse-Engines}
# ====== TODO To be translated ======
translate D EngineKey {Key}
# ====== TODO To be translated ======
translate D EngineType {Type}
translate D EngineName {Name}
translate D EngineCmd {Befehl}
translate D EngineArgs {Parameter}
translate D EngineDir {Verzeichnis}
translate D EngineElo {Elo}
translate D EngineTime {Datum}
translate D EngineNew {Neu}
translate D EngineEdit {Bearbeiten}
translate D EngineRequired {Fettgedruckte Parameter erforderlich, andere optional}


# Stats window menus:
menuText D StatsFile "Datei" 0
menuText D StatsFilePrint "Drucken in Datei..." 0
menuText D StatsFileClose "Fenster schließen" 0
menuText D StatsOpt "Optionen" 0

# PGN window menus:
menuText D PgnFile "Datei" 0
menuText D PgnFileCopy "Kopiere Spiel in Zwischenablage" 0
menuText D PgnFilePrint "Drucken in Datei..." 0
menuText D PgnFileClose "PGN-Fenster schließen" 0
menuText D PgnOpt "Ausgabe" 0
menuText D PgnOptColor "Farbige Darstellung" 0
menuText D PgnOptShort "Kurzer (3-Zeilen) Vorspann (Header)" 8
menuText D PgnOptSymbols "Symbolische Darstellung" 0
menuText D PgnOptIndentC "Kommentare einrücken" 0
menuText D PgnOptIndentV "Varianten einrücken" 0
menuText D PgnOptColumn "Tabellarisch (ein Zug pro Zeile)" 0
menuText D PgnOptSpace "Leerzeichen nach Zugnummer" 0
menuText D PgnOptStripMarks "Farbfelder-/Pfeile-Zeichen entfernen" 27
menuText D PgnOptChess "Schachfiguren als Symbole" 6
menuText D PgnOptScrollbar "Bildlaufleiste" 0
menuText D PgnOptBoldMainLine "Partiezüge in Fettdruck" 0
menuText D PgnColor "Farben" 0
menuText D PgnColorHeader "Vorspann..." 0
menuText D PgnColorAnno "Anmerkungen..." 0
menuText D PgnColorComments "Kommentare..." 0
menuText D PgnColorVars "Varianten..." 0
menuText D PgnColorBackground "Hintergrund..." 0
menuText D PgnColorMain "Partieverlauf..." 0
menuText D PgnColorCurrent "Hintergrund aktueller Zug..." 1
menuText D PgnColorNextMove "Hintergrund nächter Zug..." 0
menuText D PgnHelp "Hilfe" 0
menuText D PgnHelpPgn "PGN-Hilfe" 0
menuText D PgnHelpIndex "Index" 0
translate D PgnWindowTitle {Partienotation - Partie %u}

# Crosstable window menus:
menuText D CrosstabFile "Datei" 0
menuText D CrosstabFileText "Ausgabe in Textdatei..." 11
menuText D CrosstabFileHtml "Ausgabe in HTML-Datei..." 11
menuText D CrosstabFileLaTeX "Ausgabe in LaTeX-Datei..." 11
menuText D CrosstabFileClose "Kreuztabelle schließen" 0
menuText D CrosstabEdit "Bearbeiten" 0
menuText D CrosstabEditEvent "Ereignis" 0
menuText D CrosstabEditSite "Ort" 0
menuText D CrosstabEditDate "Datum" 0
menuText D CrosstabOpt "Ausgabe" 0
menuText D CrosstabOptColorPlain "Text" 0
menuText D CrosstabOptColorHyper "Hypertext" 0
# ====== TODO To be translated ======
menuText D CrosstabOptTieWin "Tie-Break by wins" 1
# ====== TODO To be translated ======
menuText D CrosstabOptTieHead "Tie-Break by head-head" 1
# todo
menuText D CrosstabOptThreeWin "3 Punkte für Sieg" 1
menuText D CrosstabOptAges "Alter in Jahren" 0
menuText D CrosstabOptNats "Nationalität" 0
# todo
menuText D CrosstabOptTallies "Sieg/Niederlage/Unentschieden" 0
menuText D CrosstabOptRatings "Elo" 0
menuText D CrosstabOptTitles "Titel" 0
menuText D CrosstabOptBreaks "Stichkampfpunkte" 10
menuText D CrosstabOptDeleted "Inklusive gelöschte Partien" 10
menuText D CrosstabOptColors "Farben (nur Schweizer System)" 0
# ====== TODO To be translated ======
menuText D CrosstabOptColorRows "Color Rows" 0
menuText D CrosstabOptColumnNumbers "Numerierte Spalten (Nur jeder-gegen-jeden-Tabelle)" 2
menuText D CrosstabOptGroup "Punktgruppen" 5
menuText D CrosstabSort "Sortieren" 0
menuText D CrosstabSortName "Name" 0
menuText D CrosstabSortRating "Elo" 0
menuText D CrosstabSortScore "Punkte" 0
menuText D CrosstabSortCountry "Land" 0
# todo
menuText D CrosstabType "Format" 0
menuText D CrosstabTypeAll "Jeder gegen jeden" 0
menuText D CrosstabTypeSwiss "Schweizer System" 0
menuText D CrosstabTypeKnockout "K.o.-System" 0
menuText D CrosstabTypeAuto "Automatisch" 1
menuText D CrosstabHelp "Hilfe" 0
menuText D CrosstabHelpCross "Kreuztabelle-Hilfe" 0
menuText D CrosstabHelpIndex "Index" 0
translate D SetFilter {Filter setzen}
translate D AddToFilter {Zum Filter hinzufügen}
translate D Swiss {Schweizer}
translate D Category {Kategorie}

# Opening report window menus:
menuText D OprepFile "Datei" 0
menuText D OprepFileText "Ausgabe in Textdatei..." 11
menuText D OprepFileHtml "Ausgabe in HTML-Datei..." 11
menuText D OprepFileLaTeX "Ausgabe in LaTeX-Datei..." 11
menuText D OprepFileOptions "Optionen..." 0
menuText D OprepFileClose "Berichtsfenster schließen" 0
menuText D OprepFavorites "Favoriten" 0
menuText D OprepFavoritesAdd "Bericht hinzufügen..." 8
menuText D OprepFavoritesEdit "Favoritenbericht editieren..." 0
menuText D OprepFavoritesGenerate "Berichte erzeugen..." 9

menuText D OprepHelp "Hilfe" 0
menuText D OprepHelpReport "Eröffnungsbericht-Hilfe" 0
menuText D OprepHelpIndex "Index" 0

# Header search:
translate D HeaderSearch {Partiedatensuche}
translate D EndSideToMove {Wer ist beim Partieende am Zug?}
translate D GamesWithNoECO {Partien ohne ECO?}
translate D GameLength {Partielänge}
translate D FindGamesWith {Finde Partien mit den Markierungen (Flags)}
translate D StdStart {Standardausgangsposition}
translate D Promotions {Umwandlungen}
# ====== TODO To be translated ======
translate D UnderPromo {Under Prom.}
translate D Comments {Kommentare}
translate D Variations {Varianten}
translate D Annotations {Anmerkungen}
translate D DeleteFlag {Löschkennzeichen}
translate D WhiteOpFlag {Eröffnung Weiß}
translate D BlackOpFlag {Eröffnung Schwarz}
translate D MiddlegameFlag {Mittelspiel}
translate D EndgameFlag {Endspiel}
translate D NoveltyFlag {Neuerung}
translate D PawnFlag {Bauernstruktur}
translate D TacticsFlag {Taktik}
translate D QsideFlag {Damenflügel}
translate D KsideFlag {Königsflügel}
translate D BrilliancyFlag {Glänzend}
translate D BlunderFlag {Grober Fehler}
translate D UserFlag {Benutzer}
translate D PgnContains {PGN enthält Text}

# Game list window:
translate D GlistNumber {Nummer}
translate D GlistWhite {Weiß}
translate D GlistBlack {Schwarz}
translate D GlistWElo {W-Elo}
translate D GlistBElo {S-Elo}
translate D GlistEvent {Turnier}
translate D GlistSite {Ort}
translate D GlistRound {Runde}
translate D GlistDate {Datum}
translate D GlistYear {Jahr}
translate D GlistEventDate {Turnierdatum}
translate D GlistResult {Ergebnis}
translate D GlistLength {Länge}
translate D GlistCountry {Land}
translate D GlistECO {ECO}
translate D GlistOpening {Eröffnung}
translate D GlistEndMaterial {Endmaterial}
translate D GlistDeleted {Gelöscht}
translate D GlistFlags {Markierungen}
translate D GlistVariations {Varianten}
translate D GlistComments {Kommentare}
translate D GlistAnnos {Anmerkungen}
translate D GlistStart {Stellung}
translate D GlistGameNumber {Partie Nummer:}
translate D GlistFindText {Text finden}
translate D GlistMoveField {Verschieben}
translate D GlistEditField {Konfigurieren}
translate D GlistAddField {Hinzufügen}
translate D GlistDeleteField {Löschen}
translate D GlistColor {Farbe}
# ====== TODO To be translated ======
translate D GlistSort {Sort database}
translate D GlistRemoveThisGameFromFilter  {Partie}
translate D GlistRemoveGameAndAboveFromFilter  {Partie (und alle oberhalb)}
translate D GlistRemoveGameAndBelowFromFilter  {Partie (und alle darunter)}
translate D GlistDeleteGame {(Ent)Lösche Partie}
translate D GlistDeleteAllGames {Lösche alle Partien im Filter} 
translate D GlistUndeleteAllGames {Entlösche alle Partien im Filter} 
# ====== TODO To be translated ======
translate D GlistAlignL {Align left}
# ====== TODO To be translated ======
translate D GlistAlignR {Align right}
# ====== TODO To be translated ======
translate D GlistAlignC {Align center}

# Maintenance window:
translate D DatabaseName {Datenbankname:}
translate D TypeIcon {Symbol}
translate D NumOfGames {Partien:}
translate D NumDeletedGames {Gelöschte Partien:}
translate D NumFilterGames {Partien im Filter:}
translate D YearRange {Jahr-Spanne:}
translate D RatingRange {Elo-Spanne:}
translate D Description {Beschreibung}
translate D Flag {Markierung}
translate D CustomFlags {Benutzerdefinierte Markierungen}
translate D DeleteCurrent {Lösche aktuelle Partie}
translate D DeleteFilter {Lösche Partien im Filter}
translate D DeleteAll {Lösche alle Partien}
translate D UndeleteCurrent {Aktuelle Partie wiederherstellen}
translate D UndeleteFilter {Partien im Filter wiederherstellen}
translate D UndeleteAll {Alle Partien wiederherstellen}
translate D DeleteTwins {Lösche Dubletten}
translate D MarkCurrent {Markiere aktuelle Partie}
translate D MarkFilter {Markiere Partien im Filter}
translate D MarkAll {Markiere alle Partien}
translate D UnmarkCurrent {Entmarkiere aktuelle Partie}
translate D UnmarkFilter {Entmarkiere Partien im Filter}
translate D UnmarkAll {Entmarkiere alle Partien}
translate D Spellchecking {Schreibkorrektur}
translate D MakeCorrections {Korrekturen machen}
translate D Ambiguous {Mehrdeutig}
# ====== TODO To be translated ======
translate D Surnames {Surnames}
translate D Players {Spieler}
translate D Events {Ereignis}
translate D Sites {Ort}
translate D Rounds {Runde}
translate D DatabaseOps {Datenbankoperationen}
translate D ReclassifyGames {Partien ECO-klassifizieren}
translate D CompactDatabase {Datenbank komprimieren}
translate D SortDatabase {Datenbank sortieren}
translate D AddEloRatings {ELO-Zahlen hinzufügen}
translate D AutoloadGame {Automatisch Partie Nr. laden}
translate D StripTags {PGN-Markierungen entfernen}
translate D StripTag {Markierung entfernen}
translate D CheckGames {Konsistenzprüfung}
translate D Cleaner {Bereiniger}
translate D CleanerHelp {
Der Scid-Bereiniger wird für die aktuelle Datenbank alle Wartungsarbeiten ausführen, welche aus der unten stehenden Liste ausgewählt werden.

Aktuelle Einstellungen in den Menüs "ECO-Klassifikation" und "Dubletten löschen" werden angewendet, falls diese Funktionen ausgewählt sind.}
translate D CleanerConfirm {
Ist der Bereiniger einmal gestartet, kann er nicht mehr unterbrochen werden!

Dies kann lange dauern, speziell bei großen Datenbanken, abhängig von den
ausgewählten Funktionen und deren Einstellungen.

Sind Sie sicher, daß Sie die ausgewählten Wartungsarbeiten starten möchten?
}
# Twinchecker
translate D TwinCheckUndelete { umdrehen; "u" beide entlöschen)}
translate D TwinCheckprevPair {Vorheriges Paar}
translate D TwinChecknextPair {Nächstes Paar}
translate D TwinChecker {Scid: Dublettenprüfer}
translate D TwinCheckTournament {Partien im Turnier:}
translate D TwinCheckNoTwin {Keine Dublette}
translate D TwinCheckNoTwinfound {Kein Dublette für diese Partie gefunden.

Um Dubletten anzuzeigen, bitte zuerst die Funktion "Lösche Dubletten" benutzen.}
translate D TwinCheckTag {Nutze Tag...}
translate D TwinCheckFound1 {Scid hat $result Dubletten gefunden}
translate D TwinCheckFound2 { und das Gelöscht-Flag gesetzt}
translate D TwinCheckNoDelete {In dieser Datenbank sind keine Partien zu löschen.}
translate D TwinCriteria1 {Ihre Auswahlkriterien der Dublettensuche haben eine hohe Wahrscheinlichkeit auch Partien mit ähnlichen Zügen als Dubletten zu erkennen.
}
translate D TwinCriteria2 {Es wird empfohlen, dass bei der Auswahl "Nein" für "gleiche Züge" die Auswahl "Ja" für Farbe, Ereignis, Ort, Runde, Jahr und Monat ausgewählt wird.

Wollen Sie fortsetzen und mit dieser Auswahl die Dubletten löschen? }
translate D TwinCriteria3 {Es wird empfohlen, dass bei der Auswahl "Ja" für mindestens 2 der Parameter "gleicher Ort", "gleiche Runde" und "gleiches Jahr" gesetzt werden.

Wollen Sie fortsetzen und mit dieser Auswahl die Dubletten löschen?}
translate D TwinCriteriaConfirm {Scid: Bestätigen der Dublettensuchparameter}
translate D TwinChangeTag "Ändern der folgenden Partie-Tags:\n\n"
translate D AllocRatingDescription "Mit dieser Funktion werden die ELO-Werte aus der Schreibkorrekturdatei den Partien hinzugefügt. Der Wert wird hinzugefügt, wenn ein/e Spieler/in keinen aktuellen Wert in der Partie besitzt, aber in der Korrekturdatei ein Wert für den Zeitraum der Partie vorhanden ist."
translate D RatingOverride "Existierende ELO-Werte überschreiben?"
translate D AddRatings "Elo-Werte hinzufügen:"
translate D AddedRatings {Scid hat $r Elo-Werte in $g Partien hinzugefügt.}

#Bookmark editor
translate D NewSubmenu "Neues Untermenü"

# Comment editor:
translate D AnnotationSymbols  {Kommentarzeichen:}
translate D Comment {Kommentar:}
translate D InsertMark {Markierung einfügen}
translate D InsertMarkHelp {
Markierung einfügen/löschen: Farbe, Typ, Feld wählen.
Pfeil einfügen/löschen: Rechtsklick auf zwei Felder.
}

# Nag buttons in comment editor:
translate D GoodMove {Guter Zug}
translate D PoorMove {Schwacher Zug}
translate D ExcellentMove {Ausgezeichneter Zug}
translate D Blunder {Grober Fehler}
translate D InterestingMove {Interessanter Zug}
translate D DubiousMove {Zweifelhafter Zug}
translate D WhiteDecisiveAdvantage {Weiß hat Vorteil}
translate D BlackDecisiveAdvantage {Schwarz hat Vorteil}
translate D WhiteClearAdvantage {Weiß hat klaren Vorteil}
translate D BlackClearAdvantage {Schwarz hat klaren Vorteil}
translate D WhiteSlightAdvantage {Weiß hat leichten Vorteil}
translate D BlackSlightAdvantage {Schwarz hat leichten Vorteil}
translate D Equality {Gleiche Chancen}
translate D Unclear {Unklar}
translate D Diagram {Diagramm}

# Board search:
translate D BoardSearch {Brettsuchen}
translate D FilterOperation {Durchführung am aktuellen Filter:}
translate D FilterAnd {UND (Beschränke Filter)}
translate D FilterOr {ODER (Zum Filter hinzufügen)}
translate D FilterIgnore {IGNORIERE (Filter zurücksetzen)}
translate D SearchType {Suche nach Typ:}
translate D SearchBoardExact {Exakte Position (alle Steine auf gleichen Feldern)}
translate D SearchBoardPawns {Bauern (gleiche Figuren, alle Bauern auf gleichen Feldern)}
translate D SearchBoardFiles {Linien (gleiches Material, alle Bauern auf gleichen Linien)}
translate D SearchBoardAny {Material (gleiches Material, Bauern und Figuren beliebig)}
translate D SearchInRefDatabase { In folgender Datenbank suchen }
translate D LookInVars {Schaue in Varianten}

# Material search:
translate D MaterialSearch {Materialsuchen}
translate D Material {Material}
translate D Patterns {Muster}
translate D Zero {Null}
translate D Any {Irgendeine}
translate D CurrentBoard {Aktuelle Stellung}
translate D CommonEndings {Endspiele}
translate D CommonPatterns {Gleiche Muster}
translate D MaterialDiff {Materialdifferenz}
translate D squares {Felder}
translate D SameColor {Gleichfarbige}
translate D OppColor {Ungleichfarbige}
translate D Either {Beides}
translate D MoveNumberRange {Zugnummernbereich}
translate D MatchForAtLeast {Zutreffend für mindestens}
translate D HalfMoves {Halbzüge}

# Common endings in material search:
translate D EndingPawns {Bauernendspiele}
translate D EndingRookVsPawns {Turm gegen Bauer(n)}
translate D EndingRookPawnVsRook {Turm und 1 Bauer gegen Turm}
translate D EndingRookPawnsVsRook {Turm und Bauer(n) gegen Turm}
translate D EndingRooks {Turm gegen Turm}
translate D EndingRooksPassedA {Turm gegen Turm mit Freibauer}
translate D EndingRooksDouble {Doppelturm-Endspiele}
translate D EndingBishops {Läufer gegen Läufer}
translate D EndingBishopVsKnight {Läufer gegen Springer}
translate D EndingKnights {Springer gegen Springer}
translate D EndingQueens {Dame gegen Dame} ;# *** Damenendspiele !?
translate D EndingQueenPawnVsQueen {Dame und 1 Bauer gegen Dame}
translate D BishopPairVsKnightPair {Zwei Läufer gegen zwei Springer im Mittelspiel}

# Common patterns in material search:
translate D PatternWhiteIQP {Weißer isolierter Damenbauer}
translate D PatternWhiteIQPBreakE6 {Weißer Isolani: Durchbruch d4-d5 gegen e6}
translate D PatternWhiteIQPBreakC6 {Weißer Isolani: Durchbruch d4-d5 gegen c6}
translate D PatternBlackIQP {Schwarzer isolierter Damenbauer}
translate D PatternWhiteBlackIQP {Weißer gegen schwarzer Damenbauerisolani}
translate D PatternCoupleC3D4 {Isoliertes Bauernpaar c3+d4}
translate D PatternHangingC5D5 {Hängende Bauern c5 und d5 von Schwarz}
translate D PatternMaroczy {Maroczy-Zentrum (mit Bauern auf c4 und e4)}
translate D PatternRookSacC3 {Turmopfer auf c3}
translate D PatternKc1Kg8 {0-0-0 gegen 0-0 (Kc1 gegen Kg8)}
translate D PatternKg1Kc8 {0-0 gegen 0-0-0 (Kg1 gegen Kc8)}
translate D PatternLightFian {Weißfeldrige Fianchettos (Läufer g2 gegen Läufer b7)}
translate D PatternDarkFian {Schwarzfeldrige Fianchettos (Läufer b2 gegen Läufer g7)}
translate D PatternFourFian {Beiderseitiges Doppelfianchetto (Läufer auf b2,g2,b7,g7)}

# Game saving:
translate D Today {Heute}
translate D ClassifyGame {Partie klassifizieren}

# Setup position:
translate D EmptyBoard {Brett leeren}
translate D InitialBoard {Initialisiere Brett}
translate D SideToMove {Zugrecht}
translate D MoveNumber {Zugnummer}
translate D Castling {Rochade}
translate D EnPassantFile {EnPassant-Linie}
translate D ClearFen {FEN löschen}
translate D PasteFen {FEN einfügen}
translate D SaveAndContinue {Speichern und weiter}
translate D DiscardChangesAndContinue {Verwerfen und weiter}
translate D GoBack {Zurück}

# Replace move dialog:
translate D ReplaceMove {Zug ersetzen}
translate D AddNewVar {Neue Variante}
translate D NewMainLine {Neue Hauptvariante}
translate D ReplaceMoveMessage {Hier existiert bereits ein Zug.

Sie können diesen Zug ersetzen - unter Verlust aller nachfolgender Züge - oder mit dem Zug eine neue Variante hinzufügen.

(Sie können diese Anzeige vermeiden, indem Sie die Option "Fragen vor Ersetzen" im Menü Optionen:Züge deaktivieren)}

# Make database read-only dialog:
translate D ReadOnlyDialog {Wenn Sie diese Datenbank mit Schreibschutz
versehen, sind keine Änderungen möglich. Es können keine Partien gespeichert
oder ersetzt und keine Löschkennzeichen geändert werden. Alle Sortierungen oder
ECO-Klassifikationsergebnisse sind nur temporär.

Sie können den Schreibschutz einfach entfernen, indem Sie die Datenbank
schließen und wieder öffnen.
Wollen Sie diese Datenbank wirklich schreibschützen?}

# Exit dialog:
translate D ExitDialog {Möchten Sie Scid beenden?}
# ====== TODO To be translated ======
translate D ClearGameDialog {This game has been altered.\nDo you wish to save it?}
translate D ExitUnsaved {Die folgenden Datenbanken haben ungesicherte Partieänderungen. Wenn Sie jetzt beenden, gehen diese Änderungen verloren.}

# Import window:
translate D PasteCurrentGame {Aktuelle Partie einfügen}
translate D ImportHelp1 {Eingeben oder Einfügen einer Partie im PGN-Format in den oberen Rahmen.}
translate D ImportHelp2 {Hier werden Fehler beim Importieren angezeigt.}
translate D OverwriteExistingMoves {Bestehende Züge überschreiben?}

# ECO Browser:
translate D ECOAllSections {alle ECO-Gruppen}
translate D ECOSection {ECO-Gruppe}
translate D ECOSummary {Zusammenfassung für}
translate D ECOFrequency {Häufigkeit der Untercodes für}

# Opening Report:
translate D OprepTitle {Eröffnungsbericht}
translate D OprepReport {Bericht}
translate D OprepGenerated {Erzeugt durch}
translate D OprepStatsHist {Statistiken und Geschichte}
translate D OprepStats {Statistiken}
translate D OprepStatAll {Alle Berichtspartien}
translate D OprepStatBoth {Beide Spieler}
translate D OprepStatSince {Nach}
translate D OprepOldest {Älteste Partien}
translate D OprepNewest {Neueste Partien}
translate D OprepPopular {Popularität}
translate D OprepFreqAll {Häufigkeit in allen Jahren: }
translate D OprepFreq1   {im letzten Jahr:            }
translate D OprepFreq5   {der letzten  5 Jahre:       }
translate D OprepFreq10  {der letzten 10 Jahre:       }
translate D OprepEvery {Eine pro %u Partien}
translate D OprepUp {mehr als %u%s von allen Jahren}
translate D OprepDown {weniger als %u%s von allen Jahren}
translate D OprepSame {keine Änderung in allen Jahren}
translate D OprepMostFrequent {Häufigste Spieler}
translate D OprepMostFrequentOpponents {Häufigste Gegner}
translate D OprepRatingsPerf {ELO und Performance}
translate D OprepAvgPerf {Durchschnitts-ELO und Performance}
translate D OprepWRating {ELO Weiß}
translate D OprepBRating {ELO Schwarz}
translate D OprepWPerf {Performance Weiß}
translate D OprepBPerf {Performance Schwarz}
translate D OprepHighRating {Spiele mit dem höchsten ELO-Durchschnitt}
translate D OprepTrends {Ergebnistrend}
translate D OprepResults {Ergebnis nach Längen und Häufigkeiten}
translate D OprepLength {Partielänge}
translate D OprepFrequency {Häufigkeit}
translate D OprepWWins {Weißsiege:    }
translate D OprepBWins {Schwarzsiege: }
translate D OprepDraws {Remis:        }
translate D OprepWholeDB {ganze Datenbank}
translate D OprepShortest {Kürzester Sieg}
translate D OprepMovesThemes {Züge und Themen}
translate D OprepMoveOrders {Zugfolgen zum Erreichen der Berichtsposition}
translate D OprepMoveOrdersOne \
  {Es gab nur eine Zugfolge zur erreichten Position:}
translate D OprepMoveOrdersAll \
  {Es gab %u Zugfolgen zur erreichten Position:}
translate D OprepMoveOrdersMany \
  {Es gab  %u Zugfolgen zur erreichten Position. Die ersten %u sind:}
translate D OprepMovesFrom {Züge ab der Berichtsposition}
translate D OprepMostFrequentEcoCodes {Häufigste ECO-Codes}
translate D OprepThemes {Themen}
translate D OprepThemeDescription {Häufigkeit der Themen in den ersten %u Zügen jeder Partie}
translate D OprepThemeSameCastling {Gleichseitige Rochaden}
translate D OprepThemeOppCastling {Verschiedenseitige Rochaden}
translate D OprepThemeNoCastling {Beide Seiten unrochiert}
translate D OprepThemeKPawnStorm {Bauernsturm auf König}
translate D OprepThemeQueenswap {Damen getauscht}
translate D OprepThemeWIQP {Weißer isolierter Damenbauer}
translate D OprepThemeBIQP {Schwarzer isolierter Damenbauer}
translate D OprepThemeWP567 {Weißer Bauer auf Reihe 5/6/7}
translate D OprepThemeBP234 {Schwarzer Bauer auf Reihe 2/3/4}
translate D OprepThemeOpenCDE {Offene c/d/e-Linie}
translate D OprepTheme1BishopPair {Eine Seite hat Läuferpaar}
translate D OprepEndgames {Endspiele}
translate D OprepReportGames {Berichtspartien}
translate D OprepAllGames {Alle Partien}
translate D OprepEndClass {Materialklassifikation von Endspielstellungen}
translate D OprepTheoryTable {Theorietabelle}
translate D OprepTableComment {Erzeugt aus %u Partien mit höchster ELO-Zahl.}
translate D OprepExtraMoves {Zusätzliche Züge in Anmerkungen zur Theorietabelle}
translate D OprepMaxGames {Maximum an Partien in Theorietabelle}
translate D OprepViewHTML {Zeige HTML}
translate D OprepViewLaTeX {Zeige LaTeX}

# Player Report:
translate D PReportTitle {Spielerbericht}
translate D PReportColorWhite {mit den weißen Steinen}
translate D PReportColorBlack {mit den schwarzen Steinen}
# ====== TODO To be translated ======
translate D PReportBeginning {Beginning with}
translate D PReportMoves {nach %s}
translate D PReportOpenings {Eröffnungen}
translate D PReportClipbase {Leere Zwischenablage und kopiere gefundene Spiele}

# Piece Tracker window:
translate D TrackerSelectSingle {Linke Maustaste wählt diese Figur.}
translate D TrackerSelectPair \
  {Linke Maustaste wählt diese Figur; rechte Maustaste wählt das Figurenpaar.}
translate D TrackerSelectPawn \
  {Linke Maustaste wählt diesen Bauern; rechte Maustaste wählt alle 8 Bauern.}
translate D TrackerStat {Statistik}
translate D TrackerGames {% der Partien mit Zug auf das Feld}
translate D TrackerTime {% der Zeit auf jedem Feld}
translate D TrackerMoves {Züge}
translate D TrackerMovesStart \
  {Zugnummer, ab der die Verteilungsberechnung beginnen soll.}
translate D TrackerMovesStop \
  {Zugnummer, wo die Verteilungsberechnung enden soll.}

# Game selection dialogs:
translate D SelectAllGames {Alle Spiele in der Datenbank}
translate D SelectFilterGames {Nur Spiele im Filter}
translate D SelectTournamentGames {Nur Spiele des aktuellen Turniers}
translate D SelectOlderGames {Nur ältere Spiele}

# Delete Twins window:
translate D TwinsNote {Damit zwei Spiele Dubletten sind, müssen diese mindestens die beiden selben Spieler haben und die folgenden Kriterien, die Sie auswählen können, erfüllen. Wenn zwei Dubletten gefunden werden, so wird die kürzere der beiden Spiele gelöscht. Tip: am besten führt man erst eine Schreibkorrektur durch, da dadurch das Finden von Dubletten verbessert wird.}
translate D TwinsCriteria {Kriterium: Dubletten müssen haben ...}
translate D TwinsWhich {Überprüfe, welche Spiele}
translate D TwinsColors {die gleichen Spielerfarben?}
translate D TwinsEvent {das gleich Ereignis?}
translate D TwinsSite {den gleichen Ort?}
translate D TwinsRound {die gleiche Runde?}
translate D TwinsYear {das gleiche Jahr?}
translate D TwinsMonth {den gleichen Monat?}
translate D TwinsDay {den gleichen Tag?}
translate D TwinsResult {das gleiche Ergebnis?}
translate D TwinsECO {den gleichen ECO-Code?}
translate D TwinsMoves {die gleichen Züge?}
translate D TwinsPlayers {Vergleich Spielernamen}
translate D TwinsPlayersExact {Exakte Treffer}
translate D TwinsPlayersPrefix {Nur erste 4 Buchstaben}
translate D TwinsWhen {Beim Löschen der Dubletten}
translate D TwinsSkipShort {Partien unter 5 Zügen ignorieren?}
translate D TwinsUndelete {Zuerst alle Partien entlöschen?}
translate D TwinsSetFilter {Filter auf Dubletten setzen?}
translate D TwinsComments {Spiele mit Kommentar immer behalten?}
translate D TwinsVars {Spiele mit Varianten immer behalten?}
translate D TwinsDeleteWhich {Welche Partie löschen:}
translate D TwinsDeleteShorter {Kürzere Partie}
translate D TwinsDeleteOlder {Kleinere Partienummer}
translate D TwinsDeleteNewer {Größere Partienummer}
translate D TwinsDelete {Lösche Spiele}

# Name editor window:
translate D NameEditType {Namen ändern von}
translate D NameEditSelect {Welche Spiele sollen geändert werden?}
translate D NameEditReplace {Ersetze}
translate D NameEditWith {durch}
translate D NameEditMatches {Entsprechungen: Drücke Strg+1 bis Strg+9 zum Auswählen}
translate D CheckGamesWhich {Konsistenzprüfung}
translate D CheckAll {Alle Partien}
translate D CheckSelectFilterGames {Partien im Filter}

# Classify window:
translate D Classify {Klassifiziere}
translate D ClassifyWhich {ECO-klassifizieren}
translate D ClassifyAll {Alle Spiele (überschreibe alte ECO-Codes)}
translate D ClassifyYear {Alle Spiele  aus dem letzten Jahr}
translate D ClassifyMonth {Alle Spiele aus dem letzten Monat}
translate D ClassifyNew {Nur Spiele ohne ECO-Code}
translate D ClassifyCodes {Verwende}
translate D ClassifyBasic {Normale ECO-Codes ("B12", ...)}
translate D ClassifyExtended {ECO-Codes mit Scid-Erweiterung ("B12j", ...)}

# Compaction:
translate D NameFile {Namendatenbank}
translate D GameFile {Partiendatenbank}
translate D Names {Namen}
translate D Unused {Unbenutzt}
translate D SizeKb {Größe (kB)}
translate D CurrentState {Momentaner Stand}
translate D AfterCompaction {nach Kompression}
translate D CompactNames {Komprimiere Namen}
translate D CompactGames {Komprimiere Partien}
translate D NoUnusedNames "Es gibt keine unbenutzen Namen, die Namensdatei ist vollständig komprimiert."
translate D NoUnusedGames "Die Partiedatei ist vollständig komprimiert."
translate D NameFileCompacted {Die Namesdatei der Datenbank "[file tail [sc_base filename]]" wurde komprimiert.}
translate D GameFileCompacted {Die Partiedatei der Datenbank "[file tail [sc_base filename]]" wurde komprimiert.}

# Sorting:
translate D SortCriteria {Kriterium}
translate D AddCriteria {Füge Sortierkriterium hinzu}
translate D CommonSorts {Übliche Sortierkriterien}
translate D Sort {Sortiere}

# Exporting:
translate D AddToExistingFile {Anhängen an eine bestehende Datei?}
translate D ExportComments {Kommentare exportieren?}
translate D ExportVariations {Varianten exportieren?}
translate D IndentComments {Kommentare einrücken?}
translate D IndentVariations {Varianten einrücken?}
translate D ExportColumnStyle {Tabellarisch (ein Zug pro Zeile)?}
translate D ExportSymbolStyle {Symbolische Notation:}
translate D ExportStripMarks \
  {Felder-/Pfeilemarkierzeichen aus den Kommentaren entfernen?}

# Goto game/move dialogs:
translate D LoadGameNumber {Geben Sie die zu ladende Spielnr. ein:}
translate D GotoMoveNumber {Gehe zu Zugnr.:}

# Copy games dialog:
translate D CopyGames {Kopiere Spiele}
translate D CopyConfirm {
 Möchten sie wirklich die [::utils::thousands $nGamesToCopy]
 Spiele aus dem Filter
 in der Datenbank "$fromName"
 in die Datenbank "$targetName"
 kopieren?
}
translate D CopyErr {Kann Spiele nicht kopieren}
translate D CopyErrSource {Die Quelldatenbank}
translate D CopyErrTarget {Die Zieldatenbank}
translate D CopyErrNoGames {hat keine Spiele im Filter}
translate D CopyErrReadOnly {ist schreibgeschützt}
translate D CopyErrNotOpen {ist nicht geöffnet}

# Colors:
translate D LightSquares {Helle Felder}
translate D DarkSquares {Dunkle Felder}
translate D SelectedSquares {Ausgewählte Felder}
translate D SuggestedSquares {Zugvorschlagsfelder}
# todo
translate D Grid {Grid}
translate D Previous {Vorherige}
translate D WhitePieces {Weiße Steine}
translate D BlackPieces {Schwarze Steine}
translate D WhiteBorder {Weiße Umrandung}
translate D BlackBorder {Schwarze Umrandung}
translate D ArrowMain   {Main Arrow}
translate D ArrowVar    {Var Arrows}

# Novelty window:
translate D FindNovelty {Finde Neuerung}
translate D Novelty {Neuerung}
translate D NoveltyInterrupt {Neuerungensuche abgebrochen}
translate D NoveltyNone {In dieser Partie wurde keine Neuerung gefunden}
translate D NoveltyHelp {
Scid wird den ersten Zug aus der aktuellen Partie finden, welcher zu einer Position führt, die nicht in der gewählten Datenbank oder in dem ECO-Eröffnungsbuch enthalten ist.
}

# Sounds configuration:
translate D SoundsFolder {Sounddateien-Verzeichnis}
translate D SoundsFolderHelp {Das Verzeichnis sollte enthalten: King.wav, a.wav, 1.wav etc.}
translate D SoundsAnnounceOptions {Optionen für Zugankündigung}
	# *** Ist das so gemeint? Ich kann's nicht ausprobieren (keine Soundkarte...).
translate D SoundsAnnounceNew {Kündige neue Züge an, wenn sie ausgeführt werden}
translate D SoundsAnnounceForward {Künde Zug an beim Vorwärtspielen}
translate D SoundsAnnounceBack {Kündige Zug an beim Zurückgehen}

# Upgrading databases:
translate D Upgrading {Upgrading}
translate D ConfirmOpenNew {
Dies ist eine Datenbank im alten (Scid 2.x) Format, die nicht in Scid 3.x
geöffnet werden kann. Aber eine Version im neuen Format wurde schon erstellt.

Wollen Sie die Version der Datenbank im neuen Format öffnen?
}
translate D ConfirmUpgrade {
Dies ist eine Datenbank im alten (Scid 2.x) Format. Vor der Verwendung in
Scid 3 muß eine Version im neuen Format der Datenbank erstellt werden.

Beim Erstellen der neuen Version der Datenbank bleiben die Dateien der alten Version erhalten.

Dieser Vorgang kann eine Zeitlang dauern, muß aber nur einmal durchgeführt
werden. Sie können jederzeit abbrechen, wenn es Ihnen zu lange dauert.

Soll das Erstellen der Datenbank im neuen Format jetzt durchgeführt werden?
}

# Recent files options:
translate D RecentFilesMenu {Anzahl der aktuellen Dateien im Dateimenü}
translate D RecentFilesExtra {Anzahl der aktuellen Dateien im zusätzlichen Untermenü}

# My Player Names options:
translate D MyPlayerNamesDescription {
Geben Sie unten eine Liste der bevorzugten Spielernamen ein, ein Name pro Zeile. Platzhalterzeichen (z.B. "?" für ein beliebiges einzelnes Zeichen, "*" für jede beliebige Folge von Zeichen) sind erlaubt.

Jedesmal, wenn ein Spiel mit einem aufgelisteten Spielernamen geladen wird, wird das Schachbrett im Hauptfenster erforderlichenfalls gedreht, um das Spiel aus der Sicht des betreffenden Spielers zu zeigen.
}
translate D showblunderexists {Enginefehler anzeigen}
translate D showblundervalue {Fehlerwert anzeigen}
translate D showscore {Wert anzeigen}
translate D coachgame {Coach Partie}
translate D configurecoachgame {Trainingspartie konfigurieren}
translate D configuregame {Spiel konfigurieren}
translate D Phalanxengine {Phalanx engine}
translate D Coachengine {Coach Engine}
translate D difficulty {Schwierigkeit}
translate D hard {schwer}
translate D easy {leicht}
translate D Playwith {Spiel mit}
translate D white {Weiß}
translate D black {Schwarz}
translate D both {beide}
translate D Play {Spielen}
translate D Noblunder {Kein Fehler}
translate D blunder {Fehler}
translate D Noinfo {-- Keine Info --}
translate D moveblunderthreshold {fehlerhafter Zug, wenn Verlust größer als}
translate D limitanalysis {Analysezeit der Engine begrenzen}
translate D seconds {Sekunden}
translate D Abort {Abbrechen}
translate D Resume {Fortfahren}
translate D Restart {Neustart}
translate D OutOfOpening {Ende der Eröffnung}
# TODO
translate D NotFollowedLine {You did not follow the line}
translate D DoYouWantContinue {Möchten sie fortfahren?}
translate D CoachIsWatching {Coach schaut zu}
translate D Ponder {Berechnen im Hintergrund}
translate D LimitELO {Stärke begrenzen (ELO)}
translate D DubiousMovePlayedTakeBack {Zweifelhafter Zug gespielt, wollen Sie ihn zurücknehmen?}
translate D WeakMovePlayedTakeBack {Schacher Zug gespielt, wollen Sie ihn zurücknehmen?}
translate D BadMovePlayedTakeBack {Schlechter Zug gespielt, wollen Sie ihn zurücknehmen?}
translate D Iresign {Ich gebe auf}
translate D yourmoveisnotgood {Ihr Zug ist nicht gut}
translate D EndOfVar {Variantenende}
translate D Openingtrainer {Eröffnungstrainer}
translate D DisplayCM {Kandidatenzüge anzeigen}
translate D DisplayCMValue {Wert der Kandidatenzüge anzeigen}
translate D DisplayOpeningStats {Statistik anzeigen}
translate D ShowReport {Bericht anzeigen}
translate D NumberOfGoodMovesPlayed {gute Züge gespielt}
translate D NumberOfDubiousMovesPlayed {zweischneidige Züge gespielt}
translate D NumberOfTimesPositionEncountered {Wiederholungen der Position}
translate D PlayerBestMove  {Nur beste Züge erlauben}
translate D OpponentBestMove {Gegner spielt besten Zug}
translate D OnlyFlaggedLines {Nur markierte Linien}
translate D resetStats {Statistik zurücksetzen}
translate D Movesloaded {Züge geladen}
translate D PositionsNotPlayed {nicht gespielte Positionen}
translate D PositionsPlayed {gespielte Positionen}
translate D Success {Erfolgreich}
translate D DubiousMoves {Zweifelhafte Züge}
translate D ConfigureTactics {Taktik konfigurieren}
translate D ResetScores {Punkte zurücksetzten}
translate D LoadingBase {Lade Datenbank}
translate D Tactics {Taktik}
translate D ShowSolution {Lösung zeigen}
translate D Next {Nächste}
translate D ResettingScore {Punkte zurücksetzen}
translate D LoadingGame {Lade Partie}
translate D MateFound {Matt gefunden}
translate D BestSolutionNotFound {Beste Lösung NICHT gefunden!}
translate D MateNotFound {Matt nicht gefunden}
translate D ShorterMateExists {Kürzeres Matt existiert}
translate D ScorePlayed {Bewertung gepielt}
translate D Expected {erwarted}
translate D ChooseTrainingBase {Trainingsdatenbank auswählen}
translate D Thinking {Denke...}
translate D AnalyzeDone {Analyse beendet}
translate D WinWonGame {Gewinne gewonnene Partie}
translate D Lines {Variantenzahl}
translate D ConfigureUCIengine {UCI Engine konfigurieren}
translate D SpecificOpening {Ausgewählte Eröffnung}
translate D StartNewGame {Neue Partie}
translate D FixedLevel {Festgelegte Stärke}
translate D Opening {Eröffnung}
translate D RandomLevel {Zufallsniveau}
translate D StartFromCurrentPosition {Von aktueller Position starten}
translate D FixedDepth {Feste Tiefe}
translate D Nodes {Knoten} 
translate D Depth {Tiefe}
translate D Time {Zeit} 
translate D SecondsPerMove {Sekunden pro Zug}
# ====== TODO To be translated ======
translate D DepthPerMove {Depth per move}
# ====== TODO To be translated ======
translate D MoveControl {Move Control}
translate D TimeLabel {Zeit pro Zug}
# ====== TODO To be translated ======
translate D AddVars {Add Variations}
# ====== TODO To be translated ======
translate D AddScores {Add Score}
translate D Engine {Engine}
translate D TimeMode {Zeitmodus}
translate D TimeBonus {Zeit + Bonus}
translate D TimeMin {min}
translate D TimeSec {s}
translate D AllExercisesDone {Alle Übungen gemacht}
translate D MoveOutOfBook {Zug nicht mehr im Buch}
translate D LastBookMove {Letzter Buchzug}
translate D AnnotateSeveralGames {Kommentiere mehrere Partien\nvon aktueller bis:}
translate D FindOpeningErrors {Eröffnungsfehler finden}
translate D MarkTacticalExercises {Taktische Übungen markieren}
translate D UseBook {Buch benutzen}
translate D MultiPV {Multivariantenmodus}
translate D Hash {Hash Speicher}
translate D OwnBook {Engine Buch verwenden}
translate D BookFile {Eröffnungsbuch}
translate D AnnotateVariations {Varianten kommentieren}
translate D ShortAnnotations {Kurze Kommentare}
translate D addAnnotatorTag {Kommentar Tag hinzufügen}
translate D AddScoreToShortAnnotations {Bewertung hinzufügen}
translate D Export {Export}
translate D BookPartiallyLoaded {Buch teilweise geladen}
# ====== TODO To be translated ======
translate D AddLine {Add Line}
# ====== TODO To be translated ======
translate D RemLine {Remove Line}
translate D Calvar {Training: Variantenberechnung}
translate D ConfigureCalvar {Konfiguration}
translate D Reti {Reti}
translate D English {Englische Eröffnung}
translate D d4Nf6Miscellaneous {1.d4 Nf6 Verschiedene}
translate D Trompowsky {Trompowsky}
translate D Budapest {Budapest}
translate D OldIndian {Altindische Verteidigung}
translate D BenkoGambit {Benko Gambit}
translate D ModernBenoni {Moderne/Benoni-Verteidigung}
translate D DutchDefence {Holländische Verteidigung}
translate D Scandinavian {Skandinavische Verteidigung}
translate D AlekhineDefence {Aljechin Verteidigung}
translate D Pirc {Pirc-Verteidigung}
translate D CaroKann {Caro-Kann}
translate D CaroKannAdvance {Caro-Kann Vorstoßvariante}
translate D Sicilian {Sizilianisch}
translate D SicilianAlapin {Sizilianisch, Alapin Variante}
translate D SicilianClosed {Geschlossene Sizilianische Verteidigung}
translate D SicilianRauzer {Sizilianisch, Rauzer Angriff}
translate D SicilianDragon {Sizilianisch, Drachenvariante}
translate D SicilianScheveningen {Sizilianisch, Scheveningen}
translate D SicilianNajdorf {Sizilianisch, Najdorf}
translate D OpenGame {Offene Spiele}
translate D Vienna {Wiener Verteidigung}
translate D KingsGambit {Königsgambit}
translate D RussianGame {Russische Verteidigung}
translate D ItalianTwoKnights {Italienische Eröffnung}
translate D Spanish {Spanisch Partie}
translate D SpanishExchange {Spanisch, Abtauschvariante}
translate D SpanishOpen {Spanisch, offene Systeme}
translate D SpanishClosed {Spanisch, geschlossene Systeme}
translate D FrenchDefence {Französische Verteidigung}
translate D FrenchAdvance {Französisch, Vorstoßvariante}
translate D FrenchTarrasch {Französisch, Tarrasch}
translate D FrenchWinawer {Französisch, Winawer}
translate D FrenchExchange {Französisch, Abtauschvariante}
translate D QueensPawn {Damenbauernspiel}
translate D Slav {Slavisch}
translate D QGA {Angenommenes Damengambit}
translate D QGD {Abgelehntes Damengambit}
translate D QGDExchange {Abgelehntes Damengambit, Abtauschvariante}
translate D SemiSlav {Semi-Slawisch}
translate D QGDwithBg5 {Abgelehntes Damengambit mit Lg5}
translate D QGDOrthodox {Abgelehntes Damengambit, Orthodoxe Variante}
translate D Grunfeld {Grünfeld-Verteidigung}
translate D GrunfeldExchange {Grünfeld, Abtauschvariante}
translate D GrunfeldRussian {Grünfeld-Verteidigung, Russische Variante}
translate D Catalan {Katalanische Verteidigung}
translate D CatalanOpen {Katalanisch, offen}
translate D CatalanClosed {Katalanisch, geschlossen}
translate D QueensIndian {Dameninsche Verteidigung}
translate D NimzoIndian {Nimzoindische Verteidigung}
translate D NimzoIndianClassical {Nimzoindisch, Klassische Variante}
translate D NimzoIndianRubinstein {Nimzoinsisch, Rubinstein}
translate D KingsIndian {Königsindische Verteidigung}
translate D KingsIndianSamisch {Königsinsisch, Sämisch}
translate D KingsIndianMainLine {Königsinsisch, Hauptvariante}

translate D ConfigureFics {FICS Konfigurieren}
translate D FICSLogin {Login}
translate D FICSGuest {Gast Login}
translate D FICSServerPort {Serverport}
translate D FICSServerAddress {IP Adresse}
translate D FICSRefresh {Aktualisieren}
translate D FICSTimeseal {Timeseal}
translate D FICSTimesealPort {Timeseal Port}
translate D FICSSilence {Konsolenfilter}
translate D FICSOffers {Herausforderungen}
translate D FICSGames {laufende Partien}
translate D FICSFindOpponent {Gegner suchen}
translate D FICSTakeback {Zurücknehmen}
translate D FICSTakeback2 {2 zurücknehmen}
translate D FICSInitTime {Zeit (min)}
translate D FICSIncrement {Inkrement (s)}
translate D FICSRatedGame {Wertungspartie}
translate D FICSAutoColour {automatisch}
translate D FICSManualConfirm {manuell bestätigen}
translate D FICSFilterFormula {Filterformel anwenden}
translate D FICSIssueSeek {Partie anbieten}
translate D FICSAccept {Annehmen}
translate D FICSDecline {Ablehnen}
translate D FICSColour {Seite wählen:}
translate D FICSSend {senden}
translate D FICSConnect {Verbinden}
# ====== TODO To be translated ======
translate D FICSShouts {Shouts}
# ====== TODO To be translated ======
translate D FICSTells {Tells}
translate D FICSOpponent {Gegner Info}
translate D FICSInfo {Info}
translate D FICSDraw {Remis anbieten}
translate D FICSRematch {Revanche}
translate D FICSQuit {FICS beenden}
# ====== TODO To be translated ======
translate D FICSCensor {Censor}

# Correspondence Chess Dialogs:
translate D CCDlgConfigureWindowTitle {Einstellungen für Fernschach}
translate D CCDlgCGeneraloptions {Allgemeine Einstellungen}
translate D CCDlgDefaultDB {Standarddatenbank:}
translate D CCDlgInbox {Posteingang (Pfad):}
translate D CCDlgOutbox {Postausgang (Pfad):}
translate D CCDlgXfcc {Xfcc Einstellungen:}
translate D CCDlgExternalProtocol {Externe Protokolle (Xfcc)}
translate D CCDlgFetchTool {Hilfsprogramm zum Abholen:}
translate D CCDlgSendTool {Hilfsprogramm zum Senden:}
translate D CCDlgEmailCommunication {E-Mail Kommunikation}
translate D CCDlgMailPrg {E-Mail Programm:}
translate D CCDlgBCCAddr {Adresse für Ausgangskopie:}
translate D CCDlgMailerMode {Modus:}
translate D CCDlgThunderbirdEg {z.B. Thunderbird, Mozilla Mail, Icedove...}
translate D CCDlgMailUrlEg {z.B. Evolution}
translate D CCDlgClawsEg {z.B. Sylpheed Claws}
translate D CCDlgmailxEg {z.B. mailx, mutt, nail...}
translate D CCDlgAttachementPar {Parameter für Anhang:}
translate D CCDlgInternalXfcc {Interne Xfcc-Unterstützung verwenden}
translate D CCDlgConfirmXfcc {Züge bestätigen}
translate D CCDlgSubjectPar {Parameter für Betreff:}
translate D CCDlgDeleteBoxes {Leeren des Postein- und Ausgangs}
translate D CCDlgDeleteBoxesText {Wollen Sie wirklich Ihren Postein- und Ausgang leeren?\nDies erfordert ein erneutes Synchronisieren zum den aktuellen Zustand Ihrer Partien anzuzeigen.}
translate D CCDlgConfirmMove {Zug bestätigen}
translate D CCDlgConfirmMoveText {Durch bestätigen wird folgender Zug und Kommentar an den Server übertragen:}
translate D CCDlgDBGameToLong {Inkonsistente Hauptvariante}
translate D CCDlgDBGameToLongError {Die Hauptvariante dieser Partie in der Datenbank enthält mehr Züge als in der Partie tatsächlich gespielt. Sofern die Partie im Posteingang vollständig und aktuell ist (z. B. direkt nach einer Synchronisation) muß die Hauptvariante in der Datenbank ensprechend gekürzt werden. Der letzte Zug in der Partie ist Nr. \n}
translate D CCDlgStartEmail {Neue E-Mail Partie}
translate D CCDlgYourName {Ihr Name:}
translate D CCDlgYourMail {Ihre E-Mail Adresse:}
translate D CCDlgOpponentName {Name des Gegners:}
translate D CCDlgOpponentMail {E-Mail Adresse des Gegners:}
translate D CCDlgGameID {Partiekennung (eineindeutig):}
translate D CCDlgTitNoOutbox {Scid: Fernschach Postausgang}
translate D CCDlgTitNoInbox {Scid: Fernschach Posteingang}
translate D CCDlgTitNoGames {Scid: Keine Fernschachpartien}
translate D CCErrInboxDir {Der Posteingang für Fernschachpartien unter:}
translate D CCErrOutboxDir {Der Postausgang für Fernschachpartien unter:}
translate D CCErrDirNotUsable {existiert nicht oder ist nicht benutzbar!\nBitte überprüfen und die Einstellungen korrigieren.}
translate D CCErrNoGames {enthält keine Partien!\nBitte sychronisieren Sie zunächst.}
translate D CCDlgTitNoCCDB {Scid: Keine Fernschach-Datenbank}
translate D CCErrNoCCDB {Es wurde keine Datenbank vom Typ 'Fernschach' geöffnet. Bitte öffen Sie eine solche bevor Sie Funktionen des Fernschachmoduls benutzen.}
translate D CCFetchBtn {Partien vom Server abholen\nund Inbox bearbeiten}
translate D CCPrevBtn {Vorhergehende Partie}
translate D CCNextBtn {Nächste Partie}
translate D CCSendBtn {Zug versenden}
translate D CCEmptyBtn {Postein- und ausgang leeren}
translate D CCHelpBtn {Hilfe zu den Icons und Statusindikatoren\nFür allgemeine Hilfe bitte F1!}
translate D CCDlgServerName {Server Name:}
translate D CCDlgLoginName  {Login Name:}
translate D CCDlgPassword   {Passwort:}
translate D CCDlgURL        {Xfcc-URL:}
translate D CCDlgRatingType {Wertungszahl:}
translate D CCDlgDuplicateGame {Nichteindeutige Partie}
translate D CCDlgDuplicateGameError {Diese Partie existiert mehr als einmal in der Datenbank. Bitte löschen Sie alle Doubletten und komprimieren Sie die Datenbank (Datei/Wartung/Datenbank komprimieren).}
translate D CCDlgSortOption {Sortierung:}
translate D CCDlgListOnlyOwnMove {Partien mit anhängigen Zügen}
translate D CCOrderClassicTxt {Ort, Turnier, Runde, Ergebnis, Weiß, Schwarz}
translate D CCOrderMyTimeTxt {Eigene Bedenkzeit}
translate D CCOrderTimePerMoveTxt {Zeit pro Zug bis zur nächsten Zeitkontrolle}
translate D CCOrderStartDate {Startdatum}
translate D CCOrderOppTimeTxt {Gegnerische Bedenkzeit}
translate D CCDlgConfigRelay {Partien auf iccf-webchess beobachten}
translate D CCDlgConfigRelayHelp {Besuchen Sie http://www.iccf-webchess.com und lassen Sie die Partie anzeigen, die Sie beobachten wollen. Wenn das Brett sichtbar ist bitte die Adresse aus dem Browser in untenstehende Liste kopieren. Nur eine URL pro Zeile!\nBeispiel: http://www.iccf-webchess.com/MakeAMove.aspx?id=266452}


translate D ExtHWConfigConnection {Hardware Konfigurieren}
translate D ExtHWPort {Schnittstelle}
translate D ExtHWEngineCmd {Engine Kommando}
translate D ExtHWEngineParam {Engine Parameter}
translate D ExtHWShowButton {Knopf in Werzeugleiste anzeigen}
translate D ExtHWHardware {Hardware}
translate D ExtHWNovag {Novag Citrine}
translate D ExtHWInputEngine {Input Engine}
translate D ExtHWNoBoard {Kein Brett verbunden}
translate D IEConsole {Input Engine Konsole}
translate D IESending {Sende Züge für}
translate D IESynchronise {Synchronisieren}
translate D IERotate  {Brett drehen}
translate D IEUnableToStart {Input Engine konnte nicht gestartet werden:}
translate D DoneWithPosition {Positionsbearbeitung beendet}
translate D Board {Brett}
translate D showGameInfo {Partieinformation anzeigen}
translate D autoResizeBoard {Brettgröße automatisch berechnen}
translate D DockTop {Nach oben}
translate D DockBottom {Nach unten}
translate D DockLeft {Nach links}
translate D DockRight {Nach rechts}
translate D Undock {Fenster befreien}
translate D ChangeIcon {Symbol ändern}
# ====== TODO To be translated ======
translate D More {More}

# Drag & Drop
translate D CannotOpenUri {Die folgenden URI können nicht geöffnet werden:}
translate D InvalidUri {Der Drop-Inhalt ist keine gültige URI-Liste.}
translate D UriRejected	{Die folgenden Dateien wurden zurückgewiesen:}
translate D UriRejectedDetail {Nur die aufgelisteten Dateitypen können gehandhabt werden:}
translate D EmptyUriList {Der Drop-Inhalt ist leer.}
translate D SelectionOwnerDidntRespond {Zeitüberschreitung während der Drop-Aktion: der Eigentümer des Drop-Inhalts antwortete nicht.}

}

##########
#
# ECO Opening name translations:

translateECO D {
  Accelerated {, Beschleunigt}
  {: Accelerated} Beschleunigt
  Accepted {, Angenommen}
  {: Accepted} Angenommen
  Advance Vorstoß
  {as Black} {mit Schwarz}
  Attack Angriff
  Bishop Läufer
  Bishop's Läufer
  Classical Klassisch
  Closed Geschlossen
  {Closed System} {Geschlossenes System}
  Counterattack Gegenangriff
  Countergambit Gegengambit
  Declined {, Abgelehnt}
  Defence Verteidigung
  deferred verzögert
  Deferred {, verzögert}
  Early Frühe
  Exchange Abtausch
  Game Partie
  Improved verbessert
  King's Königs
  Knight Springer
  Line Variante
  {Main Line} Hauptvariante
  Open Offen
  Opening Eröffnung
  Queen's Damen
  Queenswap Damentausch
  Symmetrical Symmetrisch
  Variation Variante
  Wing Flügel
  with mit
  without ohne

  Alekhine Aljechin
  Averbakh Awerbach
  Botvinnik Botwinnik
  Chigorin Tschigorin
  Polugaevsky Polugajewski
  Rauzer Rauser
  Sveshnikov Sweschnikow

  Austrian Österreichisch
  Berlin Berliner
  Bremen Bremer
  Catalan Katalanisch
  Czech Tschechisch
  Dutch Holländisch
  English Englisch
  French Französisch
  Hungarian Ungarisch
  Indian Indisch
  Italian Italienisch
  Latvian Lettisch
  Meran Meraner
  Moscow Moskau
  Polish Polnisch
  Prague Prager
  Russian Russisch
  Scandinavian Skandinavisch
  Scheveningen Scheveninger
  Scotch Schottisch
  Sicilian Sizilianisch
  Slav Slawisch
  Spanish Spanisch
  Swedish Schwedisch
  Swiss Schweizer
  Vienna Wiener
  Yugoslav Jugoslawisch

  {Accelerated Fianchetto} {Beschleunigtes Fianchetto}
  {Accelerated Pterodactyl} {Beschleunigter Pterodactylus}
  {Alekhine Defence} Aljechin-Verteidigung
  {Alekhine Variation} Aljechin-Variante
  {Alekhine: Sämisch Attack} {Aljechin: Wiener System (Sämisch-Angriff)}
  {Anderssen Opening} Anderssen-Eröffnung
  {Anti-King's Indian} Anti-Königsindisch
  {Austrian Attack} {Österreichischer Angriff}
  {Benko Gambit} Wolga-Gambit
  {Benko Opening} Benkö-Eröffnung
  {Berlin Defence} {Berliner Verteidigung}
  Chameleon Chamäleon
  Chelyabinsk Tscheljabinsk
  {Classical Defence} {Klassische Verteidigung}
  {Spanish: Classical Defence} {Spanisch: Klassische (Cordel-) Verteidigung}
  {Classical Exchange} {Klassischer Abtausch}
  {Classical Variation} {Klassische Variante}
  {Closed Berlin} {Geschlossener Berliner}
  {Open Berlin} {Offener Berliner}
  {Bird's,} {Bird,}
  {Bird's Defence} Bird-Verteidigung
  {Bird's Deferred} {Verzögerte Bird}
  {Bishop's Opening} Läuferspiel
  {Botvinnik System} Botwinnik-System
  {Central Variation} Zentralvariante
  {Centre Attack} Zentrumsangriff
  {Centre Game} Mittelgambit
  {Danish Gambit} {Nordisches Gambit}
  Dragon Drachen
  {Dutch Variation} {Holländische Variante}
  {Early Exchange} {Früher Abtausch}
  {Early Queenswap} {Früher Damentausch}
  {English Attack} {Englischer Angriff}
  {English: King's} {Englisch: Königsbauer}
  {English Variation} {Englische Variante}
  {Englund Gambit} Englund-Gambit
  {Exchange Variation} Abtauschvariante
  {Fianchetto Variation} Fianchettovariante
  {Flohr Variation} Flohr-Variante
  {Four Knights} Vierspringer
  {Four Knights Game} Vierspringerspiel
  {Four Pawns} Vierbauern
  {Four Pawns Attack} Vierbauernangriff
  {French Variation} {Französische Variante}
  {From Gambit} {Froms Gambit}
  {Goring Gambit} {Göring-Gambit}
  {Grob Gambit} {Grobs Gambit}
  {Hungarian Defence} {Ungarische Verteidigung}
  {Indian Variation} {Indische Variante}
  {Italian Game} {Italienische Partie}
  KGD {Abgel. Königsgambit}
  {Classical KGD} {Klassisches abgelehntes Königsgambit}
  {Keres Variation} Keres-Variante
  KGA {Angen. Königsgambit}
  {KGA: Bishop's Gambit} Königsläufergambit
  {KGA: King's Knight Gambit} Königsspringergambit
  {King's Gambit} Königsgambit
  {King's Gambit Accepted} {Angen. Königsgambit}
  {King's Gambit Accepted (KGA)} {Angen. Königsgambit}
  {King's Indian} Königsindisch
  KIA {Königsindischer Angriff}
  {King's Knight Gambit} Königsspringergambit
  {King's Pawn} Königsbauer
  {Lasker Variation} {Lasker-Variante}
  {Latvian Gambit} {Lettisches Gambit}
  {Maroczy Bind} {Maroczy-Aufbau}
  {Marshall Variation} Marshall-Variante
  {Modern Attack} {Moderner Angriff}
  {Modern Steinitz} {Moderne Steinitz}
  {Modern Variation} {Moderne Variante}
  {Moscow Variation} {Moskauer Variante}
  Nimzo-Indian Nimzoindisch
  {Old Benoni} {Klassisches Benoni}
  {Old Indian} Altindisch
  {Old Indian Attack} {Altindisch i.A.}
  {Old Steinitz} Steinitz-Verteidigung
  {Open Game} {Offene Partie}
  {Poisoned Pawn} {Vergifteter Bauer}
  {Polish Variation} {Polnische Variante}
  {Polugaevsky Variation} {Polugajewski-Variante}
  {Queen's Gambit} Damengambit
  {Queen's Gambit Accepted} {Angen. Damengambit}
  QGA {Angen. Damengambit}
  {Queen's Gambit Accepted (QGA)} {Angenommenes Damengambit}
  {Reversed QGA} {Angen. Damengambit i.A.}
  QGD {Abgel. Damengambit}
  {Queen's Gambit Declined (QGD)} {Abgelehntes Damengambit}
  {Reversed QGD} {Abgel. Damengambit i.A.}
  {Queen's Indian} Damenindisch
  {Queen's Pawn} Damenbauer
  {Queen's Pawn Game} Damenbauerspiel
  {Reversed Slav} {Slawisch i.A.}
  {Rubinstein Variation} Rubinstein-Variante
  {Russian Game} {Russische Partie}
  {Russian Game (Petroff Defence)} {Russische Partie}
  {Russian-Three Knights Game} {Russisches Dreispringerspiel}
  {Scandinavian (Centre Counter)} Skandinavisch
  Schliemann Jänisch
  {Schliemann (Jänisch)} {Jänisch-Gambit (Schliemann)}
  {Scotch Opening} {Schottische Eröffnung}
  {Sicilian Defence} {Sizilianische Verteidigung}
  {Sicilian Variation} {Sizilianische Variante}
  {Slav Defence} {Slawische Verteidigung}
  Smith-Morra Morra
  {Smith-Morra Accepted} {Angenommenes Morra-Gambit}
  {Smith-Morra Gambit} Morra-Gambit
  {Spanish (Ruy Lopez)} {Spanische Partie}
  {Start position} Ausgangsstellung
  {Steinitz Deferred} Rubinstein-Aufbau
  {Swedish Variation} {Schwedische Variante}
  {Swiss Variation} {Schweizer Variante}
  {Tarrasch's Gambit} {Tarrasch-Gambit}
  {Three Knights} Dreispringer
  {3 Knights} Dreispringer
  {Three Knights Game} Dreispringerspiel
  {Three Pawns Attack} Dreibauernangriff
  {Two Knights} Zweispringer
  {Two Knights Defence} Zweispringer-Verteidigung
  {Two Knights Variation} Zweispringer-Variante
  {Two Pawns} Zweibauern
  {Two Pawns Attack} Zweibauernangriff
  {Wing Gambit} Flügel-Gambit
  {Yugoslav Attack} {Jugoslawischer Angriff}
}


### German help pages removed because they're too old :( S.A

### German tip of the day

set tips(D) {
  {
    Scid hat mehr als 30 <a Index>Hilfeseiten</a> und in den meisten
    Scid-Fenstern liefert die <b>F1</b>-Taste die Hilfeseite zu diesem
    Fenster.
  }
  {
    Einige Scid-Fenster (z.B. Informationsbereich und
    Datenbank-<a Switcher>Umschalter</a>) haben ein Kontextmenu.
    Drücken Sie einfach die rechte Maustaste in jedem Fenster, um zu
    sehen, ob es ein Menü hat und welche Funktionen zur Verfügung
    stehen.
  }
  {
    Scid bietet Ihnen mehr als eine Möglichkeit, Schachzüge einzugeben,
    und läßt Ihnen die Wahl, welche Ihnen am meisten zusagt. Sie können
    die Maus verwenden (mit oder ohne Zugvorschlag) oder die Tastatur
    (mit oder ohne Zugergänzung). Für Details lesen Sie die Hilfeseite
    <a Moves>Züge eingeben</a>.
  }
  {
    Wenn Sie einige Datenbanken häufig öffnen, fügen Sie zu jeder ein
    <a Bookmarks>Lesezeichen</a> hinzu, dann können Sie sie schneller
    mit dem Lesezeichen-Menü öffnen.
  }
  {
    Sie können alle Züge einer Partie (mit allen Varianten und
    Kommentaren) mit dem <a PGN>PGN-Fenster</a> betrachten. Im
    PGN-Fenster können Sie zu jedem beliebigen Zug gehen, indem Sie
    ihn mit der linken Maustaste anklicken oder mit der mittleren
    Maustaste eine Voransicht dieser Stellung erhalten.
  }
  {
    Sie können Partien mit der linken Maustaste per "Drag & Drop" im
    <a Switcher>Datenbank-Umschalter</a> von einer Datenbank in eine
    andere kopieren.
  }
  {
    Scid kann PGN-Dateien selbst dann öffnen, wenn sie mit Gzip
    komprimiert wurden (Dateiname mit Erweiterung .gz). PGN-Dateien
    werden schreibgeschützt geöffnet. Wenn Sie also eine PGN-Datei
    editieren wollen, erstellen Sie eine neue Scid-Datenbank und
    kopieren die PGN-Datei mit dem <a Switcher>Datenbank-Umschalter</a>
    dorthin.
  }
  {
    Wenn Sie eine große Datenbank haben, die Sie oftmals mit dem
    <a Tree>Zugbaumfenster</a> nutzen, lohnt es sich,
    <b>Cache-Datei füllen</b> im Dateimenü des Zugbaumfensters zu
    wählen. Damit merken Sie sich Zugbaum-Statistiken für viele
    häufige Eröffnungspositionen und beschleunigen den Zugriff auf
    den Zugbaum für die Datenbank.
  }
  {
    Das <a Tree>Zugbaum</a>-Fenster kann Ihnen alle Züge zeigen, die
    in der aktuellen Position gespielt wurden, aber wenn Sie auch alle
    Zugfolgen sehen wollen, mit denen diese Stellung erreicht wurde,
    finden Sie diese, wenn Sie einen <a Reports Opening>Eröffnungsbericht</a>
    erstellen.
  }
  {
    Klicken Sie mit der linken oder rechten Maustaste auf die Überschrift
    einer Spalte im <a GameList>Partieliste</a>-Fenster , um ihre
    Breite anzupassen.
  }
  {
    Mit dem Fenster <a PInfo>Spielerinformation</a> (um es zu öffnen,
    klicken Sie einfach auf einen Spielernamen im Informationsbereich
    unter dem Hauptfenster-Schachbrett) können Sie auf einfache Weise
    den <a Searches Filter>Filter</a> so einstellen, daß er alle Partien
    eines bestimmten Spielers mit einem bestimmten Ergebnis enthält,
    indem Sie auf irgendeinen <red>in Rot</red> dargestellten Wert
    klicken.
  }
  {
    Beim Eröffnungsstudium kann es sehr hilfreich sein, für eine wichtige
    Position eine <a Searches Board>Brettsuche</a> mit der <b>Bauern</b>-
    oder <b>Linien</b>-Option durchzuführen, was andere Eröffnungen
    entdecken könnte, die zur selben Bauernstruktur führen.
  }
  {
    Im Informationsbereich (unterhalb des Schachbretts) können Sie mit
    der rechten Maustaste ein Menü zur Gestaltung der Ausgabe aktivieren.
    Zum Beispiel können Sie Scid veranlassen, den nächsten Zug zu
    verstecken, was nützlich ist, wenn man zum Trainieren eine Partie
    nachspielt und die Züge zu erraten versucht.
  }
  {
    Wenn Sie für eine große Datenbank oftmals eine umfangreiche
    Datenbank-<a Maintenance>Wartung</a> durchführen, können Sie
    mehrere Wartungsarbeiten gleichzeitig mit dem
    <a Maintenance Cleaner>Bereiniger</a> ausführen.
  }
  {
    Wenn Sie eine große Datenbank haben, wo die meisten Partien einen
    Turniereintrag besitzen und Sie wollen die Partien nach Datum
    sortiert haben, erwägen Sie ein <a Sorting>Sortieren</a> nach
    Turnierdatum und Turnier anstatt nach Datum und Turnier, da
    Ihnen das hilft, Partien desselben Turniers mit unterschiedlichen
    Daten zusammen zu halten (natürlich unter der Voraussetzung, daß
    sie alle dasselbe Turnierdatum haben).
  }
  {
    Es ist eine gute Idee, vor einem <a Maintenance Twins>Dubletten
    löschen</a> eine <a Maintenance Spellcheck>Schreibkorrektur</a>
    Ihrer Datenbank durchzuführen, da es dies Scid ermöglicht, mehr
    Dubletten zu finden und zum Löschen vorzumerken.
  }
  {
    <a Flags>Markierungen</a> sind nützlich, um Datenbankpartien mit
    Charakteristiken zu versehen, nach denen Sie zu einem späteren
    Zeitpunkt vielleicht suchen wollen, wie etwa Bauernstruktur, Taktik
    etc. Sie können mit der <a Searches Header>Partiedaten-Suche</a>
    nach Markierungen suchen.
  }
  {
    Wenn Sie eine Partie nachspielen und einige Züge ausprobieren
    wollen, ohne die Partie zu verändern, schalten Sie einfach den
    Testmodus ein (mit der Tastenkombination <b>Strg+Leerzeichen</b>
    oder mit dem Symbol aus der Werkzeugleiste), und wenn Sie fertig
    sind, schalten Sie ihn wieder aus, um zur ursprünglichen Partie
    zurückzukommen.
  }
  {
    Um die prominentesten Partien (Spieler mit hohen Elo-Zahlen)
    zu finden, die eine bestimmte Position erreicht haben, öffnen
    Sie das <a Tree>Zugbaum</a>-Fenster und dort die Liste der
    besten Partien. Sie können sogar die Liste der besten Partien
    auf Partien mit einem bestimmten Ergebnis begrenzen.
  }
  {
    Eine ausgezeichnete Methode, eine Eröffnung mit Hilfe einer großen
    Datenbank zu studieren, ist, den Trainingsmodus im
    <a Tree>Zugbaum</a>-Fenster zu aktivieren und dann gegen die
    Datenbank zu spielen, um zu sehen, welche Züge häufig vorkommen.
  }
  {
    Wenn Sie zwei Datenbanken geöffnet haben und die
    <a Tree>Zugbaum</a>-Statistik der ersten Datenbank sehen wollen,
    während Sie eine Partie der zweiten Datenbank untersuchen, drücken
    Sie einfach den Schalter <b>Anbinden</b> im Zugbaumfenster, um die
    Partie an die erste Datenbank zu binden, und wechseln dann zur
    zweiten Datenbank.
  }
  {
    Der <a Tmt>Turnierfinder</a> ist nicht nur zum Auffinden eines
    bestimmten Turniers nützlich, sondern auch um zu sehen, an welchen
    Turnieren ein bestimmter Spieler vor kurzem teilgenommen hat,
    oder um die Spitzenturniere in einem bestimmten Land zu betrachten.
  }
  {
    Es gibt eine Reihe häufiger Stellungsmuster, die im Fenster
    <a Searches Material>Material/Muster</a>-Suche definiert sind und
    die Ihnen beim Eröffnungs- oder Mittelspielstudium nützlich sein
    können.
  }
  {
    Wenn Sie im Fenster <a Searches Material>Material/Muster</a>-Suche
    nach einer bestimmten Materialkonstellation suchen, ist es oftmals
    hilfreich, die Suche auf Partien zu beschränken, die mindestens für
    einige Halbzüge auf das Suchmuster passen, um Partien auszusondern,
    wo die gesuchte Konstellation nur kurz vorkam.
  }
  {
    Wenn Sie eine wichtige Datenbank haben, die Sie nicht versehentlich
    verändern wollen, wählen Sie <b>Schreibschutz...</b> im
    <b>Datei</b>-Menü, nachdem Sie sie geöffnet haben, oder ändern Sie
    ihre Dateizugriffsrechte auf "nur Lesen".
  }
  {
    Wenn Sie XBoard oder WinBoard benutzen (oder ein anderes
    Schachprogramm, das Schachpositionen in FEN-Standardnotation in die
    Zwischenablage kopieren kann) und wollen dessen aktuelle
    Schachposition nach Scid kopieren, ist der schnellste und einfachste
    Weg, <b>Position sichern</b> im Dateimenü von XBoard/Winboard zu
    wählen, danach <b>Stellung einfügen</b> in Scids Menü "Bearbeiten".
  }
  {
    Die <a Searches Header>Partiedaten-Suche</a> ignoriert bei
    Spieler/Turnier/Ort/Runden-Namen Groß- und Kleinschreibung.  Sie
    können sie aber berücksichtigen und gleichzeitig
    Platzhalterzeichen verwenden (mit "?" = irgendein einzelnes
    Zeichen und "*" = null oder mehr Zeichen), wenn Sie den Suchtext
    in Anführungszeichen ("...")  eingeben. Beispielsweise geben Sie
    "*BEL" (mit den Anführungszeichen) im Ortsfeld ein, um alle in
    Belgien, nicht aber in Belgrad gespielten Partien zu finden.
  }
  {
    Wenn Sie einen Partiezug korrigieren wollen, ohne die danach
    gespielten Züge zu verlieren, öffnen Sie das
    <a Import>Import</a>-Fenster, klicken auf <b>Aktuelle Partie
    einfügen</b>, editieren den falschen Zug und wählen dann
    <b>Importieren</b>.
  }
  {
    Wenn Sie eine ECO-Klassifikationsdatei geladen haben, können Sie
    zur am weitest klassifizierten Position der aktuellen Partie mit
    <b>Eröffnung identifizieren</b> im <b>Partie</b>-Menü gehen
    (Tastenkombination: Strg+Umsch+D).
  }
  {
    Wenn Sie vor dem Öffnen einer Datei ihre Größe oder das Datum ihrer
    letzten Modifikation überprüfen wollen, öffnen Sie sie mit dem
    <a Finder>Dateifinder</a>.
  }
  {
    Eine <a Repertoire>Repertoire</a>-Datei ist eine ausgezeichnete
    Methode, Ihre favorisierten Eröffnungsvarianten im Auge zu behalten
    und die Partien zu finden, wo diese Varianten gespielt wurden.
    Wenn Sie erst einmal Ihre Eröffnungen in einer Repertoire-Datei
    gespeichert haben, können Sie jedesmal, wenn Sie eine neue Datei
    mit Partien haben, eine Repertoire-Suche durchführen und die Partien
    mit Ihren favorisierten Eröffnungen betrachten.
  }
  {
    Mit einem <a Reports Opening>Eröffnungsbericht</a> kann man sehr gut
    mehr über eine bestimmte Position lernen. Sie können die Erfolgsrate
    sehen, ob sie zu vielen Kurzremis führt und die typischen
    positionellen Themen.
  }
  {
    Sie können die gebräuchlichsten Kommentarsymbole (!, !?, += etc.)
    dem aktuellen Zug oder der aktuellen Stellung mit Tastenkombinationen
    hinzufügen, ohne den Kommentareditor benutzen zu müssen -- um
    beispielsweise ein "!" hinzuzufügen, tippen Sie "!" und danach die
    Eingabetaste. Zu den Details siehe die Hilfeseite <a Moves>Züge
    eingeben</a>.
  }
  {
    Wenn Sie Eröffnungen in einer Datenbank mit dem <a Tree>Zugbaum</a>
    betrachten, können Sie eine nützlichen Übersicht erhalten, welche
    Erfolge mit der aktuellen Eröffnung in der letzten Zeit und zwischen
    Spitzenspielern erzielt wurden, indem Sie das Statistikfenster
    öffnen (Tastenkombination: Strg-I).
  }
  {
    Sie können die Größe des Hauptfensters ändern, indem Sie die
    <b>Strg</b>-Taste gedrückt halten und dann die Cursortaste
    <b>Links</b> oder <b>Rechts</b> drücken.
  }
  {
    Nach einer <a Searches>Suche</a> können Sie leicht durch alle
    passenden Partien blättern, indem Sie die <b>Strg</b>-Taste gedrückt
    halten und dann die Cursortaste <b>Auf</b> oder <b>Ab</b> drücken,
    um die vorherige bzw. nächste Partie im <a Searches Filter>Filter</a>
    zu laden.
  }
  {
    Über die Tasten <b>F2</b> und <b>F3</b> können direkt die letzten beiden Analyse-Engines gestartet werden, ohne dies nochmal auswählen zu müssen. 
  }
}

### End of file: deutsch.tcl

