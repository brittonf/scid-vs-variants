
### Polish menus for Scid.
# Contributed by Michal Rudolf and Adam Umiastowski.

addLanguage P Polish 0 utf-8

proc setLanguage_P {} {

menuText P File "Plik" 0
menuText P FileNew "Nowy..." 0 {Twórz nową bazę Scid}
menuText P FileOpen "Otwórz..." 0 {Otwórz istniejącą bazę Scid}
menuText P FileClose "Zamknij" 0 {Zamknij aktywną bazę Scid}
menuText P FileFinder "Poszukiwacz plików" 0 {Otwórz okno poszukiwacza plików}
menuText P FileSavePgn "Zapisz PGN" 0 {Zapisz bazę w formacie PGN}
menuText P FileOpenBaseAsTree "Otwórz bazę jako drzewo" 0   {Otwórz bazę i użyj jej jako drzewa}
menuText P FileOpenRecentBaseAsTree "Otwórz ostatnio otwieraną bazę jako drzewo" 0   {Otwórz ostatnio otwieraną bazę i użyj jej jako drzewa}
menuText P FileBookmarks "Zakładki" 2 {Menu zakładek (klawisz: Ctrl+B)}
menuText P FileBookmarksAdd "Dodaj zakładkę" 0 \
  {Dodaj zakładkę do aktualnej bazy i pozycji}
menuText P FileBookmarksFile "Wstaw zakładkę" 0 \
  {Wstaw do wybranego katalogu zakładkę do aktualnej bazy i pozycji}
menuText P FileBookmarksEdit "Edycja zakładek..." 0 \
  {Edytuj menu zakładek}
menuText P FileBookmarksList "Wyświetlaj katalogi jako listę" 0 \
  {Wyświetlaj katalogi zakładek jako listę, nie jako zagnieżdżone menu}
menuText P FileBookmarksSub "Wyświetl katalogi jako menu" 0 \
  {Wyświetlaj katalogi zakładek jako zagnieżdżone menu, nie jako listę}

menuText P FileReadOnly "Tylko do odczytu..." 0 \
  {Zabezpiecz bazę przed zapisem}
menuText P FileSwitch "Przełącz bazę" 1 \
  {Przełącz na inną otwartą bazę} 
menuText P FileExit "Koniec" 0 {Zamknij Scida}

menuText P Edit "Edytuj" 0
menuText P EditAdd "Dodaj wariant" 0 {Dodaj wariant do ruchu w partii}
menuText P EditPasteVar "Wklej wariant" 0
menuText P EditDelete "Usuń wariant" 0 {Usuń wariant dla tego posunięcia}
menuText P EditFirst "Twórz pierwszy wariant" 0 \
  {Przesuń wariant na pierwsze miejsce na liście}
menuText P EditMain "Zmień wariant na tekst partii" 0 \
   {Zamień wariant i tekst partii}
menuText P EditTrial "Sprawdź wariant" 0 \
  {Włącz/wyłącz tryb sprawdzania wariantów}
menuText P EditStrip "Usuń" 2 \
  {Usuń komentatarze i warianty}
menuText P EditUndo "Undo" 0 {Cofnij zmianę w ostatniej partii}
menuText P EditRedo "Redo" 0
menuText P EditStripComments "Komentarze" 0 \
  {Usuń wszystkie komentarze z aktualnej partii}
menuText P EditStripVars "Warianty" 0 \
  {Usuń wszystkie warianty z aktualnej partii}
menuText P EditStripBegin "Poprzednie posunięcia" 0 \
  {Usuń wszystkie posunięcia do bieżącej pozycji}
menuText P EditStripEnd "Następne posunięcia" 0 \
  {Usuń wszystkie posunięcia od bieżącej pozycji do końca partii}
menuText P EditReset "Opróżnij schowek" 0 \
  {Opróżnij schowek bazy}
menuText P EditCopy "Kopiuj partię do schowka" 0 \
  {Kopiuj partię do schowka}
menuText P EditPaste "Wklej aktywną partię ze schowka" 0 \
  {Wklej aktywną partię ze schowka}
menuText P EditPastePGN "Wklej tekst ze schowka jako partię PGN..." 10 \
  {Zinterpretuj zawartość schowka jako partię w formacie PGN i wklej ją tutaj}
menuText P EditSetup "Ustaw pozycję początkową..." 6 \
  {Ustaw pozycję początkową partii}
menuText P EditCopyBoard "Kopiuj pozycję" 7 \
  {Kopiuj aktualną pozycję w notacji FEN do schowka}
menuText P EditCopyPGN "Kopiuj PGN" 0 {}
menuText P EditPasteBoard "Ustaw pozycję ze schowka" 3 \
  {Ustaw pozycję ze schowka}

menuText P Game "Partia" 1
menuText P GameNew "Opuść partię" 0 \
  {Opuść partię, rezygnując z wszelkich zmian}
menuText P GameFirst "Pierwsza partia" 2 {Wczytaj pierwszą partię z filtra}
menuText P GamePrev "Pokaż poprzedniż partię" 0 \
  {Wczytaj poprzednią wyszukaną partię}
menuText P GameReload "Wczytaj ponownie aktualną partię"  10 \
  {Wczytaj partię ponownie, rezygnując z wszelkich zmian}
menuText P GameNext "Następna partia" 0 \
  {Wczytaj następną wyszukaną partię}
menuText P GameLast "Ostatnia partia" 5 {Wczytaj ostatnią partię z filtra}
menuText P GameRandom "Losowa partia z filtra" 8 {Wczytaj losową partię z filtra}
menuText P GameNumber "Wczytaj partię numer..." 17 \
  {Wczytaj partię wprowadzając jej numer}
menuText P GameReplace "Zapisz: zastąp partię..." 3 \
  {Zapisz partię, zastąp poprzednią wersję}
menuText P GameAdd "Zapisz: dodaj nową partię..." 8 \
  {Zapisz tę partię jako nowa partię w bazie}
menuText P GameInfo "Ustaw informacje o partii" 0
menuText P GameBrowse "Przeglądaj partie" 0
menuText P GameList "Lista partii" 0
menuText P GameDelete "Usuń partię" 0
menuText P GameDeepest "Rozpoznaj debiut" 0 \
  {Przejdź do najdłuższego wariantu z książki debiutowej}
menuText P GameGotoMove "Przejdź do posunięcia nr..." 13 \
  {Przejdź do posunięcia o podanym numerze}
menuText P GameNovelty "Znajdź nowinkę..." 7 \
  {Znajdź pierwsze posunięcie partii niegrane wcześniej}
menuText P Search "Szukaj" 0
menuText P SearchReset "Resetuj filtr" 0 \
  {Wstaw wszystkie partie do filtra}
menuText P SearchNegate "Odwróć filtr" 0 {Zamień partie w filtrze i poza nim}
menuText P SearchEnd "Przejdź do ostatniego filtra" 0
menuText P SearchCurrent "Aktualna pozycja..." 0 \
  {Szukaj aktualnej pozycji}
menuText P SearchHeader "Nagłówek..." 0 \
  {Szukaj informacji o nagłówkach (nazwiska, nazwy turnieju itp.)}
menuText P SearchMaterial "Materiał/wzorzec..." 0 \
  {Szukaj według materiału lub wzorca}
menuText P SearchMoves {Posunięcia} 0 {}
menuText P SearchUsing "Stosuj plik poszukiwania..." 0 \
  {Szukaj stosując plik z opcjami poszukiwania}

menuText P Windows "Okna" 1
menuText P WindowsGameinfo {Pokaż informacje o partii} 0 {Otwórz/zamknij okno informacji o partii}
menuText P WindowsComment "Edytor komentarzy" 0 \
  {Otwórz/zamknij edytor komentarzy}
menuText P WindowsGList "Lista partii" 0 {Otwórz/zamknij listę partii}
menuText P WindowsPGN "Okno PGN" 0 {Otwórz/zamknij (zapis partii) PGN }
menuText P WindowsCross "Tabela turniejowa" 0 {Pokaż tabelę turniejową dla aktualnej partii}
menuText P WindowsPList "Zawodnicy" 2 {Otwórz/zamknij przeglądarkę zawodników}
menuText P WindowsTmt "Turnieje" 0 {Otwórz/zamknij przeglądarkę turniejów}
menuText P WindowsSwitcher "Przełącznik baz" 12 \
  {Otwórz/zamknij przełącznik baz}
menuText P WindowsMaint "Zarządzanie bazą" 0 \
  {Otwórz/zamknij okno zarządzania bazą}
menuText P WindowsECO "Przeglądarka kodów debiutowych" 0 \
  {Otwórz/zamknij przeglądarkę kodów debiutowych}
menuText P WindowsStats "Statystyka" 0 \
  {Otwórz/zamknij statystykę}
menuText P WindowsTree "Drzewo wariantów" 0 {Otwórz/zamknij drzewo wariantów}
menuText P WindowsTB "Tablica końcówek" 8 \
  {Otwórz/zamknij okno tablicy końcówek}
menuText P WindowsBook "Książka debiutowa" 0 {Otwórz/zamknij książkę debiutową}
menuText P WindowsCorrChess "Gra korespondencyjna" 0 {Otwórz/zamknij okno gry korespondencyjnej}

menuText P Tools "Narzędzia" 0
menuText P ToolsAnalysis "Program analizujący..." 8 \
  {Uruchom/zatrzymaj program analizujący}
menuText P ToolsEmail "Zarządzanie pocztą e-mail" 0 \
  {Otwórz/zamknij zarządzanie adresami e-mail}
menuText P ToolsFilterGraph "Uśredniony wykres filtra" 7 \
  {Otwórz/zamknij wykres filtra w przeliczeniu na 1000 partii}
menuText P ToolsAbsFilterGraph "Wykres filtra" 7 {Otwórz/zamknij wykres filtra}
menuText P ToolsOpReport "Raport debiutowy" 0 \
  {Utwórz raport debiutowy dla aktualnej pozycji}
menuText P ToolsTracker "Śledzenie figur"  1 {Otwórz/zamknij okno śledzenia figur} 
menuText P ToolsTraining "Trening"  0 {Narzędzia do treningu taktyki i debiutów}
menuText P ToolsComp "Turniej komputerowy" 2 {Turniej programów komputerowych}
menuText P ToolsTacticalGame "Partia taktyczna"  0 {Rozegraj partię z taktyką}
menuText P ToolsSeriousGame "Partia turniejowa"  1 {Rozegraj partię turniejową}
menuText P ToolsTrainTactics "Taktyka"  0 {Rozwiązuj zadania taktyczne}
menuText P ToolsTrainCalvar "Liczenie wariantów"  0 {Ćwicz liczenie wariantów}
menuText P ToolsTrainFindBestMove "Znajdź najlepszy ruch"  0 {Znajdź najlepszy ruch}
menuText P ToolsTrainFics "Internet"  0 {Graj w szachy na freechess.org}
menuText P ToolsBookTuning "Konfiguracja książki debiutowej" 0 {Konfiguruj książkę debiutową}

menuText P ToolsMaint "Obsługa" 1 {Narzędzia obsługi bazy Scid}
menuText P ToolsMaintWin "Obsługa" 0 \
  {Otwórz/zamknij obsługę bazy Scid}
menuText P ToolsMaintCompact "Porządkuj bazę..." 0 \
  {Porządkuj bazę, usuwając skasowane partie i nieużywane nazwiska}
menuText P ToolsMaintClass "Klasyfikacja debiutowa partii..." 0 \
  {Przelicz klasyfikację debiutowa wszystkich partii}
menuText P ToolsMaintSort "Sortuj bazę..." 0 \
  {Sortuj wszystkie partie w bazie}
menuText P ToolsMaintDelete "Usuń podwójne partie..." 0 \
  {Szukaj podwójnych partii i oznacz je do skasowania}
menuText P ToolsMaintTwin "Wyszukiwanie podwójnych partii" 0 \
  {Otwórz/uaktualnij wyszukiwanie podwójnych partii}
menuText P ToolsMaintNameEditor "Edytor nazwisk" 0 \
  {Otwórz/zamknij edytor nazwisk}
menuText P ToolsMaintNamePlayer "Sprawdź pisownię nazwisk..." 17 \
  {Sprawdź pisownię nazwisk przy pomocy pliku nazwisk}
menuText P ToolsMaintNameEvent "Sprawdź pisownię nazw zawodów..." 22 \
  {Sprawdź pisownię nazw zawodów przy pomocy pliku turniejów}
menuText P ToolsMaintNameSite "Sprawdź pisownię nazw miejscowości..." 22 \
  {Sprawdź pisownię nazw miejscowości przy pomocy pliku miejscowości}
menuText P ToolsMaintNameRound "Sprawdź numery rund..." 15 \
  {Sprawdź numery rund przy pomocy pliku}
menuText P ToolsMaintFixBase "Napraw bazę" 0 {Spróbuj naprawić uszkodzoną bazę}

menuText P ToolsConnectHardware "Podłącz urządzenie" 0 {Podłącz zewnętrzne urządzenie}
menuText P ToolsConnectHardwareConfigure "Konfiguruj..." 0 {Konfiguruj zewnętrzne urządzenie i połączenie}
menuText P ToolsConnectHardwareNovagCitrineConnect "Podłącz Novag Citrine" 0 {Podłącz Novag Citrine}
menuText P ToolsConnectHardwareInputEngineConnect "Podłącz urządzenie wejściowe" 0 {Podłącz urządzenie wejściowe, na przykład DGT}
menuText P ToolsNovagCitrine "Novag Citrine" 0 {Novag Citrine}
menuText P ToolsNovagCitrineConfig "Konfiguracja" 0 {Konfiguracja Novag Citrine}
menuText P ToolsNovagCitrineConnect "Podłącz" 0 {Podłącz Novag Citrine}
menuText P ToolsPInfo "Informacje o zawodniku"  0 \
  {Otwórz/odśwież okno informacji o zawodniku}
menuText P ToolsPlayerReport "Raport o graczu" 9 \
  {Utwórz raport o graczu} 
menuText P ToolsRating "Wykres rankingu" 0 \
  {Wykres historii rankingu grających partię}
menuText P ToolsScore "Wykres wyników" 1 {Pokaż wykres wyników}
menuText P ToolsExpCurrent "Eksportuj partię" 0 \
  {Zapisz partię do pliku tekstowego}
menuText P ToolsExpCurrentPGN "Do pliku PGN..." 9 \
  {Zapisz partię do pliku PGN}
menuText P ToolsExpCurrentHTML "Do pliku HTML..." 9 \
  {Zapisz partię do pliku HTML}
menuText P ToolsExpCurrentHTMLJS "Eksportuj partię do HTML z JavaScriptem..." 15 {Zapisz aktualną partię do pliku HTML z JavaScriptem}  
menuText P ToolsExpCurrentLaTeX "Do pliku LaTeX-a..." 9 \
  {Zapisz partię do pliku LaTeX-a}
# ====== TODO To be translated ======
menuText P ToolsExpFilter "Eksportuj wyszukane partie" 1 \
  {Zapisz wyszukane partie do pliku tekstowego}
menuText P ToolsExpFilterPGN "Do pliku PGN..." 9 \
  {Zapisz wyszukane partie do pliku PGN}
menuText P ToolsExpFilterHTML "Do pliku HTML..." 9 \
  {Zapisz wyszukane partie do pliku HTML}
menuText P ToolsExpFilterHTMLJS "Eksportuj filtr do HTML z Javascriptem..." 17 {Zapisz wszystkie partie w filtrze do pliku HTML z Javascriptem}  
menuText P ToolsExpFilterLaTeX "Do pliku LaTeX..." 9 \
  {Zapisz wyszukane partie do pliku LaTeX}
# ====== TODO To be translated ======
# ====== TODO To be translated ======
menuText P ToolsExpFilterGames "Export Gamelist to Text" 19 {Print a formatted Gamelist.}
menuText P ToolsImportOne "Wklej partię w formacie PGN..." 0 \
  {Pobierz partię z pliku PGN}
menuText P ToolsImportFile "Importuj plik PGN..." 2 \
  {Pobierz partie z pliku PGN}
menuText P ToolsStartEngine1 "Uruchom program 1" 0  {Uruchom program 1}
menuText P ToolsStartEngine2 "Uruchom program 2" 0  {Uruchom program 2}
menuText P ToolsScreenshot "Zrzut ekranu" 0

menuText P Play "Gra" 0
menuText P CorrespondenceChess "Szachy korespondencyjne" 0 {Funkcje do gry korespondencyjnej przez e-mail i Xfcc}
menuText P CCConfigure "Konfiguruj..." 0 {Konfiguruj ustawienia i narzędzia zewnętrzne}
menuText P CCConfigRelay "Konfiguruj obserwowane..." 1 {Konfiguruj obserwowane partie}
menuText P CCOpenDB "Otwórz bazę..." 0 {Otwórz domyślną bazę korespondencyjną}
menuText P CCRetrieve "Pobierz partie" 0 {Pobierz partie zewnętrznym narzędziem Xfcc}
menuText P CCInbox "Przetwórz skrzynkę wejściową" 0 {Przetwórz wszystkie pliki w skrzynce wejściowej}
menuText P CCSend "Wyślij posunięcie" 0 {Wyślij posunięcie przez e-mail lub zewnętrzne narzędzie Xfcc}
menuText P CCResign "Poddaj się" 0 {Poddaj się (nie przez e-mail)}
menuText P CCClaimDraw "Reklamuj remis" 0 {Wyślij posunięcie i reklamuj remis (nie przez e-mail)}
menuText P CCOfferDraw "Zaproponuj remis" 0 {Wyślij posunięcie i zaproponuj remis (nie przez e-mail)}
menuText P CCAcceptDraw "Przyjmij remis" 0 {Przyjmij propozycję remisu (nie przez e-mail)}
menuText P CCNewMailGame "Nowa partia e-mail..." 0 {Rozpocznij nową partię e-mail}
menuText P CCMailMove "Wyślij posunięcie przez e-mail..." 0 {Wyślij posunięcie przez e-mail}
menuText P CCGamePage "Strona partii..." 0 {Otwórz stronę partii w przeglądarce}
menuText P CCEditCopy "Kopiuj listę partii do schowka" 0 {Skopiuj listę partii w formacie CSV do schowka}

menuText P Options "Opcje" 0
menuText P OptionsBoard "Szachownica" 0 {Konfiguracja wyglądu szachownicy}
menuText P OptionsColour "Kolor tła" 0 {Domyślny kolor tła}
# ====== TODO To be translated ======
menuText P OptionsBackColour "Background" 0 {Default text widget color}
# ====== TODO To be translated ======
menuText P OptionsEnableColour "Enable" 0 {}
# ====== TODO To be translated ======
menuText P OptionsMainLineColour "Mainline Arrows" 0 {Mainline arrows}
# ====== TODO To be translated ======
menuText P OptionsVarLineColour "Variation Arrows" 0 {Variation arrows}
# ====== TODO To be translated ======
menuText P OptionsRowColour "Rows" 0 {Default tree/book row color}
# ====== TODO To be translated ======
menuText P OptionsSwitcherColour "Switcher" 0 {Default db switcher color}
# ====== TODO To be translated ======
menuText P OptionsProgressColour "Progressbar" 0 {Default progressbar color}
# ====== TODO To be translated ======
menuText P OptionsCrossColour "Crosstable rows" 0 {Default crosstable row color}
menuText P OptionsNames "Moje nazwiska" 0 {Modyfikuj listę moich graczy}
menuText P OptionsExport "Eksport" 0 {Zmień opcje eksportu tekstu}
menuText P OptionsFonts "Czcionka" 0 {Zmień czcionkę}
menuText P OptionsFontsRegular "Podstawowa" 0 {Zmień podstawową czcionkę}
menuText P OptionsFontsMenu "Menu" 0 {Zmień czcionkę menu} 
menuText P OptionsFontsSmall "Mała" 0 {Zmień małą czcionkę}
menuText P OptionsFontsFixed "Stała" 0 {Zmień czcionkę stałej szerokości}
menuText P OptionsGInfo "Informacje o partii" 0 {Sposób wyświetlania informacji o partii}
menuText P OptionsFics "FICS" 0
menuText P OptionsFicsAuto "Autopromote Królowa" 0
menuText P OptionsFicsColour "Kolor tekstu" 0
# ====== TODO To be translated ======
menuText P OptionsFicsSize "Board Size" 0
# ====== TODO To be translated ======
menuText P OptionsFicsButtons "User Buttons" 0
# ====== TODO To be translated ======
menuText P OptionsFicsCommands "Init Commands" 0
menuText P OptionsFicsNoRes "Bez rezultatu" 0
menuText P OptionsFicsNoReq "Bez wyzwania" 0
# ====== TODO To be translated ======
menuText P OptionsFicsPremove "Allow Premove" 0
menuText P OptionsLanguage "Język" 0 {Wybierz język}
menuText P OptionsMovesTranslatePieces "Tłumacz oznaczenia figur" 0 {Tłumacz pierwsze litery figur}
menuText P OptionsMovesHighlightLastMove "Podświetl ostatnie posunięcie" 0 {Podświetl ostatnie posunięcie}
menuText P OptionsMovesHighlightLastMoveDisplay "Pokaż" 0 {Pokaż ostatnie posunięcie}
menuText P OptionsMovesHighlightLastMoveWidth "Grubość" 0 {Grubość linii}
menuText P OptionsMovesHighlightLastMoveColor "Kolor" 0 {Kolor linii}
menuText P OptionsMoves "Posunięcia" 0 {Wprowadzanie posunięć}
menuText P OptionsMovesAsk "Zapytaj przed zastąpieniem posunięć" 0 \
  {Zapytaj przed zastąpieniem aktualnych posunięć}
menuText P OptionsMovesAnimate "Szybkość animacji" 1 \
  {Ustaw czas przeznaczony na animację jednego posunięcia} 
menuText P OptionsMovesDelay "Automatyczne przeglądanie..." 0 \
  {Ustaw opóźnienie przy automatycznym przeglądaniu partii}
menuText P OptionsMovesCoord "Posunięcia w formacie \"g1f3\"" 0 \
  {Akceptuj posunięcia wprowadzone w formacie "g1f3"}
menuText P OptionsMovesSuggest "Pokaż proponowane posunięcia" 1 \
  {Włącz/wyłącz proponowanie posunięć}
menuText P OptionsShowVarPopup "Pokaż okno wariantów" 0 {Włącz/wyłącz wyświetlanie okna wariantów}  
menuText P OptionsMovesSpace "Dodaj spację po numerze posunięcia" 0 {Dodawaj spację po numerze posunięcia}  
menuText P OptionsMovesKey "Automatyczne dopełnianie posunięć" 1 \
  {Wącz/wyłącz automatyczne dopełnianie posunięć wprowadzanych z klawiatury}
menuText P OptionsMovesShowVarArrows "Pokaż strzałki wariantów" 0 {Włącz/wyłącz strzałki pokazujące ruchy wariantów}
menuText P OptionsNumbers "Format zapisu liczb" 0 {Wybierz format zapisu liczb}
menuText P OptionsStartup "Start" 0 {Wybierz okna, które mają być widoczne po uruchomieniu programu}
menuText P OptionsTheme "Theme" 0 {Zmień wygląd interfejsu}
menuText P OptionsWindows "Okna" 0 {Opcje okien}
menuText P OptionsWindowsIconify "Minimalizuj wszystkie okna" 0 \
  {Schowaj wszystkie okna przy minimalizacji głównego okna}
menuText P OptionsWindowsRaise "Automatyczne uaktywnianie" 0 \
  {Automatycznie uaktywniaj niektóre okna (np. pasek postępu), gdy są zasłonięte}
menuText P OptionsSounds "Dźwięki..." 0 {Konfiguruj dźwięki zapowiadające ruchy}
menuText P OptionsWindowsDock "Zadokuj okna" 0 {Zadokuj okna}
menuText P OptionsWindowsSaveLayout "Zapamiętaj wygląd" 0 {Zapamiętaj wygląd}
menuText P OptionsWindowsRestoreLayout "Przywróć wygląd" 0 {Przywróć wygląd}
menuText P OptionsWindowsShowGameInfo "Pokaż informacje o partii" 0 {Pokaż informacje o partii}
menuText P OptionsWindowsAutoLoadLayout "Automatycznie ładuj pierwszy wygląd na starcie" 0 {Automatycznie ładuj pierwszy wygląd na starcie}
menuText P OptionsWindowsAutoResize "Automatycznie zmień rozmiar szachownicy" 0 {Automatycznie zmień rozmiar szachownicy}
menuText P OptionsWindowsFullScreen "Pełny ekran" 0 {Przełącz pełny ekran}
menuText P OptionsToolbar "Pasek narzędziowy" 6 \
  {Schowaj/pokaż pasek narzędziowy}
menuText P OptionsECO "Wczytaj książkę debiutową..." 16 \
  {Wczytaj plik z klasyfikacją debiutów}
menuText P OptionsSpell "Wczytaj plik sprawdzania pisowni..." 13 \
  {Wczytaj plik do sprawdzania pisowni nazwisk i nazw}
menuText P OptionsTable "Katalog z bazą końcówek..." 10 \
  {Wybierz bazę końcówek; użyte zostaną wszystkie bazy z tego katalogu}
menuText P OptionsRecent "Ostatnie pliki..." 0 \
  {Zmień liczbę ostatnio otwartych plików, wyświetlanych w menu Plik} 

menuText P OptionsBooksDir "Katalog książek debiutowych..." 0 {Ustaw katalog książek debiutowych}
menuText P OptionsTacticsBasesDir "Katalog baz..." 0 {Ustaw katalog baz treningowych}
menuText P OptionsSave "Zapamiętaj opcje" 0 \
  "Zapamiętaj wszystkie ustawienia w pliku $::optionsFile"
menuText P OptionsAutoSave "Automatycznie zapisuj opcje" 0 \
  {Automatycznie zapisz opcje przy zamykaniu programu}

menuText P Help "Pomoc" 2
menuText P HelpContents "Spis treści" 0 {Pokaż spis treści pomocy} 
menuText P HelpIndex "Spis treści" 0 {Pokaż indeks pomocy}
menuText P HelpGuide "Krótki przewodnik" 0 {Pokaż krótki przewodnik}
menuText P HelpHints "Podpowiedzi" 0 {Pokaż podpowiedzi}
menuText P HelpContact "Informacja o autorze" 0 \
  {Pokaż informację o autorze i stronie Scid-a}
menuText P HelpTip "Porada dnia" 0 {Pokaż poradę Scida}
menuText P HelpStartup "Okno powitalne" 2 {Pokazuj okno startowe}
menuText P HelpAbout "O programie" 0 {Informacje o programie Scid}

# Game info box popup menu:
menuText P GInfoHideNext "Ukryj następne posunięcie" 0
menuText P GInfoShow "Strona na posunięciu" 0
menuText P GInfoCoords "Przełącz koordynaty" 0
menuText P GInfoMaterial "Pokaż materiał" 0
menuText P GInfoFEN "Pokaż pozycję w formacie FEN" 16
menuText P GInfoMarks "Pokazuj kolorowe pola i strzałki" 5 
menuText P GInfoWrap "Zawijaj długie linie" 0
menuText P GInfoFullComment "Pokaż cały komentarz" 6
menuText P GInfoPhotos "Pokaż zdjęcia" 5
menuText P GInfoTBNothing "Tablica końcówek: nic" 0
menuText P GInfoTBResult "Tablica końcówek: tylko wynik" 18
menuText P GInfoTBAll "Tablica końcówek: wszystko" 18
menuText P GInfoDelete "Usuń/przywróć tę partię" 0
menuText P GInfoMark "Włącz/wyłącz zaznaczenie tej partii" 0
menuText P GInfoInformant "Konfiguruj oceny Informatora" 0
# ====== TODO To be translated ======
translate P FlipBoard {Flip board}
# ====== TODO To be translated ======
translate P RaiseWindows {Raise windows}
# ====== TODO To be translated ======
translate P AutoPlay {Autoplay}
# ====== TODO To be translated ======
translate P TrialMode {Trial mode}

# General buttons:
translate P Apply {Zastosuj}
translate P Back {Z powrotem}
translate P Browse {Przeglądaj}
translate P Cancel {Anuluj}
translate P Continue {Kontynuuj}
translate P Clear {Wyczyść}
translate P Close {Zamknij}
translate P Contents {Spis treści}
translate P Defaults {Domyślne}
translate P Delete {Usuń}
translate P Graph {Wykres}
translate P Help {Pomoc}
translate P Import {Pobierz}
translate P Index {Indeks}
translate P LoadGame {Wczytaj partię}
translate P BrowseGame {Przeglądaj partię}
translate P MergeGame {Dołącz partię}
translate P MergeGames {Połącz wszytkie partie}
translate P Preview {Podgląd}
translate P Revert {Odwróć}
translate P Save {Zapisz}
# ====== TODO To be translated ======
translate P DontSave {Don't Save}
translate P Search {Szukaj}
translate P Stop {Stop}
translate P Store {Zapamiętaj}
translate P Update {Uaktualnij}
translate P ChangeOrient {Zmień położenie okna}
translate P ShowIcons {Pokaż ikony}
# ====== TODO To be translated ======
translate P ConfirmCopy {Confirm Copy}
translate P None {Brak}
translate P First {Pierwsza}
translate P Current {Aktualną}
translate P Last {Ostatnią}
# ====== TODO To be translated ======
translate P Font {Font}
translate P Change {Zmień}
translate P Random {Losowo}

# General messages:
translate P game {partia}
translate P games {partie}
translate P move {posunięcie}
translate P moves {pos.}
translate P all {wszystkie}
translate P Yes {Tak}
translate P No {Nie}
translate P Both {Oba}
translate P King {Król}
translate P Queen {Hetman}
translate P Rook {Wieża}
translate P Bishop {Goniec}
translate P Knight {Skoczek}
translate P Pawn {Pion}
translate P White {Białe}
translate P Black {Czarne}
translate P Player {Gracz}
translate P Rating {Ranking}
translate P RatingDiff {Różnica rankingów}
translate P AverageRating {Średni ranking}
translate P Event {Turniej}
translate P Site {Miejsce}
translate P Country {Kraj}
translate P IgnoreColors {Ignoruj kolory}
# ====== TODO To be translated ======
translate P MatchEnd {End pos only}
translate P Date {Data}
translate P EventDate {Turniej data}
translate P Decade {Dekada} 
translate P Year {Rok}
translate P Month {Miesiąc}
translate P Months {Styczeń Luty Marzec Kwiecień Maj Czerwiec Lipiec Sierpień Wrzesień Październik Listopad Grudzień}
translate P Days {N Pn Wt Śr Cz Pt So}
translate P YearToToday {Ostatni rok}
translate P Result {Wynik}
translate P Round {Runda}
translate P Length {Długość}
translate P ECOCode {Kod ECO}
translate P ECO {ECO}
translate P Deleted {Usunięta}
translate P SearchResults {Wyniki wyszukiwania}
translate P OpeningTheDatabase {Otwieranie bazy}
translate P Database {Bazy}
translate P Filter {Filtr}
translate P Reset {Przeładuj}
translate P IgnoreCase {Ignorować wielkość}
translate P noGames {brak partii}
translate P allGames {wszystkie partie}
translate P empty {brak}
translate P clipbase {schowek}
translate P score {punkty}
translate P Start {Pozycja}
translate P StartPos {Pozycja początkowa}
translate P Total {Razem}
translate P readonly {tylko do odczytu}
translate P altered {porzucone}
# ====== TODO To be translated ======
translate P tagsDescript {Extra tags (eg: Annotator "Anand")}
# ====== TODO To be translated ======
translate P prevTags {Use previous}

# Standard error messages:
translate P ErrNotOpen {To nie jest otwarta baza.} 
translate P ErrReadOnly {Ta baza jest tylko do odczytu; nie można jej zmienić.}
translate P ErrSearchInterrupted {Wyszukiwanie zostało przerwane. Wyniki będą niepełne.}

# Game information:
translate P twin {powtórzona}
translate P deleted {usunięta}
translate P comment {komentarz}
translate P hidden {ukryte}
translate P LastMove {Poprzednie}
translate P NextMove {następne}
translate P GameStart {Początek partii}
translate P LineStart {Początek wariantu}
translate P GameEnd {Koniec partii}
translate P LineEnd {Koniec wariantu}

# Player information:
translate P PInfoAll {wszystkie partie}
translate P PInfoFilter {partie z filtra}
translate P PInfoAgainst {Wyniki - }
translate P PInfoMostWhite {Najczęstsze debiuty białymi}
translate P PInfoMostBlack {Najczęstsze debiuty czarnymi}
translate P PInfoRating {Historia rankingu}
translate P PInfoBio {Biografia}
translate P PInfoEditRatings {Modyfikuj rankingi} 
translate P PinfoEditName {Edytuj Nazwisko}
translate P PinfoLookupName {Wyszukaj Nazwisko}

# Tablebase information:
translate P Draw {remis}
translate P stalemate {pat}
# ====== TODO To be translated ======
translate P checkmate {checkmate}
translate P withAllMoves {po dowolnym posunięciu}
translate P withAllButOneMove {po dowolnym posunięciu oprócz}
translate P with {po}
translate P only {tylko}
translate P lose {przegrywają}
translate P loses {przegrywa}
translate P allOthersLose {inne posunięcia przegrywają}
translate P matesIn {matują w}
translate P longest {najlepsze}
translate P WinningMoves {Wygrywające posunięcia}
translate P DrawingMoves {Remisujące posunięcia} 
translate P LosingMoves {Przegrywające posunięcia} 
translate P UnknownMoves {Posunięcia o nieznanej ocenie} 

# Tip of the day:
translate P Tip {Porada}
translate P TipAtStartup {Pokaż poradę przy starcie}

# Tree window menus:
menuText P TreeFile "Plik" 0
menuText P TreeFileFillWithBase "Wypełnij bufor bazą" 0 {Wypełnij plik bufora wszystkimi partiami w aktualnej bazie}
menuText P TreeFileFillWithGame "Wypełnij bufor partią" 0 {Wypełnij plik bufora aktualną partią}
menuText P TreeFileSetCacheSize "Wielkość bufora" 0 {Ustaw wielkość bufora}
menuText P TreeFileCacheInfo "Informacje o buforze" 0 {Wyświetl informacje o wykorzystaniu bufora}
menuText P TreeFileSave "Zapisz bufor" 7 {Zapisz plik bufora (.stc)}
menuText P TreeFileFill "Twórz standardowy plik cache" 0 {Wstaw typowe pozycje debiutowe do bufora}
menuText P TreeFileBest "Najlepsze partie" 0 {Pokaż listę najlepszych partii}
menuText P TreeFileGraph "Pokaż wykres" 0 {Pokaż wykres dla tej gałęzi drzewa}
menuText P TreeFileCopy "Kopiuj drzewo do schowka" 0 \
  {Skopiuj drzewo ze statystykami do schowka}
menuText P TreeFileClose "Zamknij" 0 {Zamknij okno drzewa}
menuText P TreeMask "Maska" 0
menuText P TreeMaskNew "Nowa" 0 {Nowa maska}
menuText P TreeMaskOpen "Otwórz" 0 {Otwórz maskę}
menuText P TreeMaskOpenRecent "Otwórz ostatnią maskę" 0 {Otwórz ostatnią maskę}
menuText P TreeMaskSave "Zapisz" 0 {Zapisz maskę}
menuText P TreeMaskClose "Zamknij" 0 {Zamknij maskę}
# ====== TODO To be translated ======
menuText P TreeMaskFillWithLine "Fill with line" 0 {Fill mask with all previous moves}
menuText P TreeMaskFillWithGame "Wypełnij maskę partią" 0 {Wypełnij maskę partią}
menuText P TreeMaskFillWithBase "Wypełnij maskę bazą" 0 {Wypełnij maskę wszystkimi partiami w bazie}
menuText P TreeMaskInfo "Informacje" 0 {Pokaż statystykę aktualnej maski}
menuText P TreeMaskDisplay "Pokaż mapę maski" 0 {Pokaż dane maski jako drzewo}
menuText P TreeMaskSearch "Znajdź" 0 {Znajdź w aktualnej masce}
menuText P TreeSort "Sortowanie" 0
menuText P TreeSortAlpha "Alfabetycznie" 0
menuText P TreeSortECO "Kod ECO" 0
menuText P TreeSortFreq "Częstość" 0
menuText P TreeSortScore "Punkty" 0
menuText P TreeOpt "Opcje" 0
menuText P TreeOptSlowmode "Tryb dokładny" 0 {Wolne uaktualnianie (duża dokładność)}
menuText P TreeOptFastmode "Tryb szybki" 0 {Tryb szybki (bez transpozycji)}
menuText P TreeOptFastAndSlowmode "Tryb mieszany" 0 {Tryb szybki, a potem dokładne uaktualnienie}
menuText P TreeOptStartStop "Automatyczne odświeżanie" 0 {Włącz/wyłącz automatyczne odświeżanie drzewa}
menuText P TreeOptLock "Blokada" 0 {Zablokuj/odblokuj drzewo na aktualnej bazie}
menuText P TreeOptTraining "Trening" 0 {Włącz/wyłącz tryb treningowy}
# ====== TODO To be translated ======
menuText P TreeOptShort "Short Display" 0 {Don't show ELO information}
menuText P TreeOptAutosave "Automatyczny zapis bufora" 0 \
  {Automatycznie zapisz plik bufora przy wyjściu}
# ====== TODO To be translated ======
menuText P TreeOptAutomask "Auto-Load Mask" 0 "Auto-Load most recent mask with a tree open."
# ====== TODO To be translated ======
menuText P TreeOptShowBar "Show Progress Bar" 0 "Show tree progress bar."
# ====== TODO To be translated ======
menuText P TreeOptSortBest "Sort Best Games" 0 "Sort Best Games by ELO."
menuText P TreeHelp "Pomoc" 2
menuText P TreeHelpTree "Drzewo" 0
menuText P TreeHelpIndex "Spis treści" 0

translate P SaveCache {Zapisz bufor}
translate P Training {Trening}
translate P LockTree {Blokada}
translate P TreeLocked {zablokowane}
translate P TreeBest {Najlepsze}
translate P TreeBestGames {Najlepsze partie}
translate P TreeAdjust {Ustaw filtr}
# Note: the next message is the tree window title row. After editing it,
# check the tree window to make sure it lines up with the actual columns.
translate P TreeTitleRow {    Pos.        Częstość   Wynik Remis  Rav Rperf Rok   ECO}
translate P TreeTitleRowShort {    Pos.        Częstość   Wynik Remis}
translate P TreeTotal {RAZEM}
translate P DoYouWantToSaveFirst {Zapisać najpierw}
translate P AddToMask {Dodaj do maski}
translate P RemoveFromMask {Usuń z maski}
translate P AddThisMoveToMask {Dodaj posunięcie do maski}
translate P SearchMask {Szukaj wedłu maski}
translate P DisplayMask {Wyświetl maskę}
translate P Nag {Kod NAG}
translate P Marker {Znacznik}
translate P Include {Dołącz}
translate P Exclude {Wyklucz}
translate P MainLine {Wariant główny}
translate P Bookmark {Zakładka}
translate P NewLine {Nowy wariant}
translate P ToBeVerified {Do sprawdzenia}
translate P ToTrain {Do przećwiczenia}
translate P Dubious {Wątpliwe}
translate P ToRemove {Do usunięcia}
translate P NoMarker {Bez znacznika}
translate P ColorMarker {Kolor}
translate P WhiteMark {Biały}
translate P GreenMark {Zielony}
translate P YellowMark {Żółty}
translate P BlueMark {Niebieski}
translate P RedMark {Czerwony}
translate P CommentMove {Komentuj posunięcie}
translate P CommentPosition {Komentuj pozycję}
translate P AddMoveToMaskFirst {Najpierw dodaj posunięcie do maski}
translate P OpenAMaskFileFirst {Najpierw otwórz plik maski}
translate P Positions {Pozycje}
translate P Moves {Posunięcia}

# Finder window:
menuText P FinderFile "Plik" 0
menuText P FinderFileSubdirs "Przeszukuj podkatalogi" 0
menuText P FinderFileClose "Zamknij wyszukiwacza plików" 0
menuText P FinderSort "Sortowanie" 0
menuText P FinderSortType "Typ" 0
menuText P FinderSortSize "Rozmiar" 0
menuText P FinderSortMod "Zmieniony" 0
menuText P FinderSortName "Nazwa" 0
menuText P FinderSortPath "Ścieżka" 0
menuText P FinderTypes "Typy" 0
menuText P FinderTypesScid "Bazy Scid-a" 0
menuText P FinderTypesOld "Bazy Scid-a (stary format)" 1
menuText P FinderTypesPGN "Pliki PGN" 0
menuText P FinderTypesEPD "Książki debiutowe EPD" 0
menuText P FinderHelp "Pomoc" 2
menuText P FinderHelpFinder "Pomoc poszukiwacza plików" 1
menuText P FinderHelpIndex "Spis treści" 0
translate P FileFinder {Poszukiwacz plików}
translate P FinderDir {Katalog}
translate P FinderDirs {Katalogi}
translate P FinderFiles {Pliki}
translate P FinderUpDir {wyżej}
translate P FinderCtxOpen {Otwórz}
translate P FinderCtxBackup {Utwórz kopię}
translate P FinderCtxCopy {Kopiuj}
translate P FinderCtxMove {Przenieś}
translate P FinderCtxDelete {Usuń}

# Player finder:
menuText P PListFile "Plik" 0
menuText P PListFileUpdate "Uaktualnij" 0
menuText P PListFileClose "Zamknij przeglądarkę zawodników" 0
menuText P PListSort "Sortowanie" 0
menuText P PListSortName "Nazwisko" 0
menuText P PListSortElo "Elo" 0
menuText P PListSortGames "Partie" 0
menuText P PListSortOldest "Najstarsza" 0
menuText P PListSortNewest "Najnowsza" 0

# Tournament finder:
menuText P TmtFile "Plik" 0
menuText P TmtFileUpdate "Uaktualnij" 0
menuText P TmtFileClose "Zamknij turnieje" 0
menuText P TmtSort "Sortowanie" 0
menuText P TmtSortDate "Data" 0
menuText P TmtSortPlayers "Zawodnicy" 0
menuText P TmtSortGames "Partie" 0
menuText P TmtSortElo "Elo" 0
menuText P TmtSortSite "Miejsce" 0
menuText P TmtSortEvent "Turniej" 0
menuText P TmtSortWinner "Zwycięzca" 0
translate P TmtLimit "Wielkość listy"
translate P TmtMeanElo "Min. średnie ELO"
translate P TmtNone "Nie znaleziono turniejów."

# Graph windows:
menuText P GraphFile "Plik" 0
menuText P GraphFileColor "Zapisz jako kolorowy PostScript" 12
menuText P GraphFileGrey "Zapisz jako zwykły PostScript..." 0
menuText P GraphFileClose "Zamknij okno" 6
menuText P GraphOptions "Opcje" 0
menuText P GraphOptionsWhite "Białe" 0
menuText P GraphOptionsBlack "Czarne" 0
menuText P GraphOptionsBoth "Oba kolory" 1
menuText P GraphOptionsPInfo "Gracz z Informacji o graczu" 0
translate P GraphFilterTitle "Filtr: częstość na 1000 partii" 
translate P GraphAbsFilterTitle "Wykres filtra: częstość partii"
translate P ConfigureFilter {Konfiguruj oś X: rok, ranking i posunięcia}
translate P FilterEstimate "Oszacuj"
translate P TitleFilterGraph "Scid: wykres filtra"

# Analysis window:
translate P AddVariation {Dodaj wariant}
translate P AddAllVariations {Dodaj wszystkie warianty}
translate P AddMove {Dodaj posunięcie}
translate P Annotate {Komentuj}
translate P ShowAnalysisBoard {Pokaż pozycję końcową}
translate P ShowInfo {Pokaż informacje o programie}
translate P FinishGame {Zakończ partię}
translate P StopEngine {Zatrzymaj program}
translate P StartEngine {Uruchom program}
# ====== TODO To be translated ======
translate P ExcludeMove {Exclude Move}
translate P LockEngine {Zablokuj program na analizie aktualnej pozycji}
translate P AnalysisCommand {Program do analizy}
translate P PreviousChoices {Poprzednie programy}
translate P AnnotateTime {Czas między ruchami (w sekundach)}
translate P AnnotateWhich {Dodaj warianty}
translate P AnnotateAll {Dla obu stron}
translate P AnnotateAllMoves {Wszystkie}
translate P AnnotateWhite {Dla białych}
translate P AnnotateBlack {Dla czarnych}
translate P AnnotateNotBest {Tylko posunięcia lepsze niż w partii}
translate P AnnotateBlundersOnly {Tylko oczywiste błędy}
# ====== TODO To be translated ======
translate P BlundersNotBest {Blunders/Not Best}
translate P AnnotateBlundersOnlyScoreChange {Tylko błędy ze zmianą oceny z/na: }
translate P AnnotateTitle {Konfiguracja komentarza}
translate P BlundersThreshold {Granica błędu}
# ====== TODO To be translated ======
translate P ScoreFormat {Score format}
translate P CutOff {Odcięcie}
translate P LowPriority {Niski priorytet CPU} 
translate P LogEngines {Loguj enginy}
translate P LogName {Dodaj Nazwisko}
# ====== TODO To be translated ======
translate P MaxPly {Max Ply}
translate P ClickHereToSeeMoves {Kliknij, by zobaczyć posunięcia}
translate P ConfigureInformant {Konfiguruj oceny Informatora}
translate P Informant!? {Ciekawe posunięcie}
translate P Informant? {Błąd}
translate P Informant?? {Poważny błąd}
translate P Informant?! {Wątpliwe posunięcie}
translate P Informant+= {Niewielka przewaga}
translate P Informant+/- {Wyraźna przewaga}
translate P Informant+- {Rozstrzygająca przewaga}
translate P Informant++- {Wygrana}
translate P Book {Książka debiutowa}

# Analysis Engine open dialog:
translate P EngineList {Programy szachowe}
# ====== TODO To be translated ======
translate P EngineKey {Key}
# ====== TODO To be translated ======
translate P EngineType {Type}
translate P EngineName {Nazwa}
translate P EngineCmd {Polecenie}
translate P EngineArgs {Parametry} 
translate P EngineDir {Katalog}
translate P EngineElo {Elo}
translate P EngineTime {Data}
translate P EngineNew {Dodaj}
translate P EngineEdit {Edytuj}
translate P EngineRequired {Pola wytłuszczone są konieczne; reszta opcjonalna} 

# Stats window menus:
menuText P StatsFile "Plik" 0
menuText P StatsFilePrint "Zapisz do pliku..." 7
menuText P StatsFileClose "Zamknij" 0
menuText P StatsOpt "Opcje" 0

# PGN window menus:
menuText P PgnFile "Plik" 0
menuText P PgnFileCopy "Kopiuj partię do schowka" 0
menuText P PgnFilePrint "Zapisz do pliku..." 7
menuText P PgnFileClose "Zamknij" 0
menuText P PgnOpt "Wygląd" 0
menuText P PgnOptColor "Wyświetlanie w kolorach" 0
menuText P PgnOptShort "Krótki (3-wierszowy) nagłówek" 0
menuText P PgnOptSymbols "Symbole Informatora" 0
menuText P PgnOptIndentC "Wcinaj komentarze" 7
menuText P PgnOptIndentV "Wcinaj warianty" 7
menuText P PgnOptColumn "Kolumny (jedno posunięcie w wierszu)" 0
menuText P PgnOptSpace "Spacja po numerze ruchu" 0
menuText P PgnOptStripMarks "Usuń kody kolorowych pól i strzałek" 0
menuText P PgnOptChess "Użyj czcionki szachowej" 0
menuText P PgnOptScrollbar "Pasek przewijania" 0
menuText P PgnOptBoldMainLine "Wytłuść tekst partii" 2
menuText P PgnColor "Kolory" 0
menuText P PgnColorHeader "Nagłówek..." 0
menuText P PgnColorAnno "Uwagi..." 3
menuText P PgnColorComments "Komentarze..." 0
menuText P PgnColorVars "Warianty..." 0
menuText P PgnColorBackground "Tło..." 0
menuText P PgnColorMain "Główny wariant..." 0
menuText P PgnColorCurrent "Tło aktualnego posunięcia..." 1
menuText P PgnColorNextMove "Tło następnego posunięcia..." 0
menuText P PgnHelp "Pomoc" 2
menuText P PgnHelpPgn "PGN" 0
menuText P PgnHelpIndex "Spis treści" 0
translate P PgnWindowTitle {Tekst partii - partia  %u}

# Crosstable window menus:
menuText P CrosstabFile "Plik" 0
menuText P CrosstabFileText "Zapisz w pliku tekstowym..." 15
menuText P CrosstabFileHtml "Zapisz w pliku HTML..." 15
menuText P CrosstabFileLaTeX "Zapisz w pliku LaTeX-a..." 15
menuText P CrosstabFileClose "Zamknij" 0
menuText P CrosstabEdit "Edytuj" 0
menuText P CrosstabEditEvent "Turniej" 0
menuText P CrosstabEditSite "Miejsce" 0
menuText P CrosstabEditDate "Data" 0
menuText P CrosstabOpt "Wyświetlanie" 0
menuText P CrosstabOptColorPlain "Zwykły tekst" 0
menuText P CrosstabOptColorHyper "Hipertekst" 0
# ====== TODO To be translated ======
menuText P CrosstabOptTieWin "Tie-Break by wins" 1
# ====== TODO To be translated ======
menuText P CrosstabOptTieHead "Tie-Break by head-head" 1
menuText P CrosstabOptThreeWin "3 punkty za wygraną" 1
menuText P CrosstabOptAges "Wiek" 0
menuText P CrosstabOptNats "Narodowość" 0
menuText P CrosstabOptTallies "Zwycięstwo/Przegrana/Remis" 0
menuText P CrosstabOptRatings "Ranking" 0
menuText P CrosstabOptTitles "Tytuł" 0
menuText P CrosstabOptBreaks "Punkty pomocnicze" 1
menuText P CrosstabOptDeleted "Uwzględniaj usunięte partie" 0
menuText P CrosstabOptColors "Kolory (tylko szwajcar)" 0
# ====== TODO To be translated ======
menuText P CrosstabOptColorRows "Color Rows" 0
menuText P CrosstabOptColumnNumbers "Numerowane kolumny (tylko turniej kołowy)" 0
menuText P CrosstabOptGroup "Grupuj po liczbie punktów" 0
menuText P CrosstabSort "Sortowanie" 0
menuText P CrosstabSortName "Nazwisko" 0
menuText P CrosstabSortRating "Ranking" 0
menuText P CrosstabSortScore "Punkty" 0
menuText P CrosstabSortCountry "Kraj" 0
# todo
menuText P CrosstabType "Format" 0
menuText P CrosstabTypeAll "Turniej kołowy" 0
menuText P CrosstabTypeSwiss "Szwajcar" 0
menuText P CrosstabTypeKnockout "Knockout" 0
menuText P CrosstabTypeAuto "Automatycznie" 0
menuText P CrosstabHelp "Pomoc" 2
menuText P CrosstabHelpCross "Tabela turniejowa" 0
menuText P CrosstabHelpIndex "Spis treści" 0
translate P SetFilter {Ustaw filtr}
translate P AddToFilter {Dodaj do filtra}
translate P Swiss {Szwajcar}
translate P Category {Kategoria} 

# Opening report window menus:
menuText P OprepFile "Plik" 0
menuText P OprepFileText "Zapisz w pliku tekstowym..." 15
menuText P OprepFileHtml "Zapisz w pliku HTML..." 15
menuText P OprepFileLaTeX "Zapisz w pliku LaTeX-a..." 15
menuText P OprepFileOptions "Opcje" 2
menuText P OprepFileClose "Zamknij okno raportu" 0
menuText P OprepFavorites "Ulubione" 1 
menuText P OprepFavoritesAdd "Dodaj raport..." 0 
menuText P OprepFavoritesEdit "Modyfikuj ulubione..." 0
menuText P OprepFavoritesGenerate "Twórz raporty..." 0 
menuText P OprepHelp "Pomoc" 2
menuText P OprepHelpReport "Pomoc raportu debiutowego" 0
menuText P OprepHelpIndex "Spis treści" 0

# Header search:
translate P HeaderSearch {Wyszukiwanie wg nagłówka}
translate P EndSideToMove {Strona na posunięciu po zakończeniu partii}
translate P GamesWithNoECO {Partie bez ECO?}
translate P GameLength {Długość}
translate P FindGamesWith {Znajdź partie}
translate P StdStart {cała partia}
translate P Promotions {z promocją}
# ====== TODO To be translated ======
translate P UnderPromo {Under Prom.}
translate P Comments {Komentarze}
translate P Variations {Warianty}
translate P Annotations {Uwagi}
translate P DeleteFlag {Usuwanie}
translate P WhiteOpFlag {Debiut - białe}
translate P BlackOpFlag {Debiut - czarne}
translate P MiddlegameFlag {Gra środkowa}
translate P EndgameFlag {Końcówka}
translate P NoveltyFlag {Nowinka}
translate P PawnFlag {Struktura pionowa}
translate P TacticsFlag {Taktyka}
translate P QsideFlag {Gra na skrzydle hetmańskim}
translate P KsideFlag {Gra na skrzydle królewskim}
translate P BrilliancyFlag {Nagroda za piękność}
translate P BlunderFlag {Podstawka}
translate P UserFlag {Inne}
translate P PgnContains {PGN zawiera tekst}

# Game list window:
translate P GlistNumber {Numer}
translate P GlistWhite {Białe}
translate P GlistBlack {Czarne}
translate P GlistWElo {B-Elo}
translate P GlistBElo {C-Elo}
translate P GlistEvent {Turniej}
translate P GlistSite {Miejsce}
translate P GlistRound {Runda}
translate P GlistDate {Data}
translate P GlistYear {Rok}
translate P GlistEventDate {Turniej-Data}
translate P GlistResult {Wynik}
translate P GlistLength {Długość}
translate P GlistCountry {Kraj}
translate P GlistECO {ECO}
translate P GlistOpening {Debiut}
translate P GlistEndMaterial {Materiał}
translate P GlistDeleted {Usunięta}
translate P GlistFlags {Oznaczenie}
translate P GlistVariations {Warianty}
translate P GlistComments {Komentarze}
translate P GlistAnnos {Uwagi}
translate P GlistStart {Pozycja początkowa}
translate P GlistGameNumber {Numer partii}
translate P GlistFindText {Znajdź tekst}
translate P GlistMoveField {Przesuń}
translate P GlistEditField {Konfiguruj}
translate P GlistAddField {Dodaj}
translate P GlistDeleteField {Usuń}
translate P GlistColor {Kolor}
# ====== TODO To be translated ======
translate P GlistSort {Sort database}
translate P GlistRemoveThisGameFromFilter  {Usuń}
translate P GlistRemoveGameAndAboveFromFilter  {Usuń tę i poprzednie partie}
translate P GlistRemoveGameAndBelowFromFilter  {Usuń tę i następne partie}
translate P GlistDeleteGame {Usuń/przywróć tę partię} 
translate P GlistDeleteAllGames {Usuń wszystkie partie z filtra} 
translate P GlistUndeleteAllGames {Przywróć wszystkie partie z filtra} 
# ====== TODO To be translated ======
translate P GlistAlignL {Align left}
# ====== TODO To be translated ======
translate P GlistAlignR {Align right}
# ====== TODO To be translated ======
translate P GlistAlignC {Align center}

# Maintenance window:
translate P DatabaseName {Nazwa bazy:}
translate P TypeIcon {Ikona}
translate P NumOfGames {Liczba partii:}
translate P NumDeletedGames {Liczba usuniętych partii:}
translate P NumFilterGames {Liczba partii w filtrze:}
translate P YearRange {Data:}
translate P RatingRange {Ranking:}
translate P Description {Opis} 
translate P Flag {Oznaczenie:}
translate P CustomFlags {Flagi użytkownika}
translate P DeleteCurrent {Usuń aktualną partię}
translate P DeleteFilter {Usuń partie z filtra}
translate P DeleteAll {Usuń wszystkie partie}
translate P UndeleteCurrent {Odzyskaj aktualną partię}
translate P UndeleteFilter {Odzyskaj partie z filtra}
translate P UndeleteAll {Odzyskaj wszystkie partie}
translate P DeleteTwins {Usuń powtórzone partie}
translate P MarkCurrent {Zaznacz aktualną partię}
translate P MarkFilter {Zaznacz partie z filtra}
translate P MarkAll {Zaznacz wszystkie partie z filtra}
translate P UnmarkCurrent {Usuń zaznaczenie aktualnej partii}
translate P UnmarkFilter {Usuń zaznaczenie partii z filtra}
translate P UnmarkAll {Usuń zaznaczenie wszystkich partii}
translate P Spellchecking {Pisownia}
# ====== TODO To be translated ======
translate P MakeCorrections {Make Corrections}
# ====== TODO To be translated ======
translate P Ambiguous {Ambiguous}
# ====== TODO To be translated ======
translate P Surnames {Surnames}
translate P Players {Zawodnicy}
translate P Events {Turnieje}
translate P Sites {Miejsca}
translate P Rounds {Rundy}
translate P DatabaseOps {Operacje bazodanowe}
translate P ReclassifyGames {Klasyfikacja debiutowa}
translate P CompactDatabase {Uporządkuj bazę}
translate P SortDatabase {Sortuj bazę}
translate P AddEloRatings {Dodaj rankingi ELO}
translate P AutoloadGame {Domyślna partia}
translate P StripTags {Usuń znaczniki PGN} 
translate P StripTag {Usuń znacznik}
translate P CheckGames {Sprawdź partie}
translate P Cleaner {Zestaw zadań}
translate P CleanerHelp {
Zestaw zadań pozwala wykonać od razu kilka operacji porządkowania bazy. Operacje wybrane z listy zostaną wykonane na aktualnej bazie.
Do klasyfikacji debiutowej i usuwania powtórzonych partii użyte zostaną aktualne ustawienia.
}
translate P CleanerConfirm {
Kiedy wykonanie zestawu zadań zostanie rozpoczęte, nie będzie można już go przerwać.
Na dużej bazie może to zająć dużo czasu (zależy to również od wybranego zestawu zadań i ich
ustawień).
Na pewno wykonać wybrane zadania?
}
translate P TwinCheckUndelete {Żeby przełączyć; "u" przywraca obie)}
translate P TwinCheckprevPair {Poprzednia para}
translate P TwinChecknextPair {Następna para}
translate P TwinChecker {Scid: wyszukiwarka powtórzonych partii}
translate P TwinCheckTournament {Partie w turnieju:}
translate P TwinCheckNoTwin {Bez powtórzeń  }
translate P TwinCheckNoTwinfound {Brak powtórzeń tej partii.\nŻeby zobaczyć powtórzone partie, użyj najpierw funkcji "Znajdź powtórzone partie...". }
translate P TwinCheckTag {Dziel znaczniki...}
translate P TwinCheckFound1 {Scid znalazł $result powtórzonych partii}
translate P TwinCheckFound2 { i ustawił ich flagę usunięcia}
translate P TwinCheckNoDelete {W tej bazie brak partii do usunięcia.}
translate P TwinCriteria1 { Aktualne ustawienia do wyszukiwania powtórzeń mogą spowodować\noznaczenie różnych partii o podobnym przebiegu jako powtórzeń.}
translate P TwinCriteria2 {Przy ustawieniu "Nie" dla "tych samych posunięć", zaleca się wybranie "Tak" dla koloru, turnieju, miejsca, rundy, roku i miesiąca.\nCzy kontynuować i usunąć powtórzone partie? }
translate P TwinCriteria3 {Zaleca się wybranie "Tak" przynajmniej dla dwóch z opcji: "to samo miejsce", "ta sama runda" i "ten sam rok".\nCzy kontynuować i usunąć powtórzone partie?}
translate P TwinCriteriaConfirm {Scid: potwierdź ustawienia wyszukiwania powtórzeń}
translate P TwinChangeTag "Zmień następujące znaczniki:\n\n"
translate P AllocRatingDescription "To polecenie używa aktualnego pliku do sprawdzania pisowni, żeby dodać rankingi Elo do partii w bazie. Jeśli gracz nie ma przypisanego rankingu, ale plik pisowni zawiera potrzebne informacje, ranking zostanie dodany."
translate P RatingOverride "Zastąpić istniejące rankingi?"
translate P AddRatings "Dodaj rankingi do:"
translate P AddedRatings {Scid dodał $r rankingów Elo w $g partiach.}
translate P NewSubmenu "Nowe podmenu"

# Comment editor:
translate P AnnotationSymbols  {Symbole:}
translate P Comment {Komentarz:}
translate P InsertMark {Wstaw znak}
translate P InsertMarkHelp {
Dodaj/usuń znacznik: wybierz kolor, typ i pole.
Dodaj/usuń strzałkę: kliknij prawym przyciskiem na dwóch polach.
} 

# Nag buttons in comment editor:
translate P GoodMove {Silne posunięcie}
translate P PoorMove {Słabe posunięcie}
translate P ExcellentMove {Znakomite posunięcie}
translate P Blunder {Podstawka}
translate P InterestingMove {Ciekawe posunięcie}
translate P DubiousMove {Wątpliwe posunięcie}
translate P WhiteDecisiveAdvantage {Białe mają decydującą przewagę} 
translate P BlackDecisiveAdvantage {Czarne mają decydującą przewagę} 
translate P WhiteClearAdvantage {Białe mają wyraźną przewagę} 
translate P BlackClearAdvantage {Czarne  mają wyraźną przewagę} 
translate P WhiteSlightAdvantage {Białe mają niewielką przewagę} 
translate P BlackSlightAdvantage {Czarne mają niewielką przewagę}
translate P Equality {Równowaga} 
translate P Unclear {Niejasna pozycja}
translate P Diagram {Diagram}

# Board search:
translate P BoardSearch {Wyszukiwanie wg pozycji}
translate P FilterOperation {Operacje na aktualnym filtrze:}
translate P FilterAnd {I (ogranicz filtr)}
translate P FilterOr {LUB (dodaj do filtra)}
translate P FilterIgnore {NOWY (ignoruj poprzedni filtr)}
translate P SearchType {Typ wyszukiwania:}
translate P SearchBoardExact {Identyczna pozycja (bierki na tych samych polach)}
translate P SearchBoardPawns {Pionki (ten sam materiał, pionki na tych samych polach)}
translate P SearchBoardFiles {Kolumny (ten sam materiał, pionki na tych samych kolumnach)}
translate P SearchBoardAny {Materiał (ten sam materiał, pozycja dowolna)}
translate P SearchInRefDatabase { Szukaj w bazie }
translate P LookInVars {Przeszukuj warianty}

# Material search:
translate P MaterialSearch {Wyszukiwanie wg materiału}
translate P Material {Materiał}
translate P Patterns {Wzorce}
translate P Zero {Brak}
translate P Any {Dowolny}
translate P CurrentBoard {Aktualna pozycja}
translate P CommonEndings {Typowe końcówki}
translate P CommonPatterns {Typowe wzorce}
translate P MaterialDiff {Przewaga materialna}
translate P squares {pola}
translate P SameColor {jednopolowe}
translate P OppColor {różnopolowe}
translate P Either {dowolne}
translate P MoveNumberRange {Zakres posunięć}
translate P MatchForAtLeast {Pasuje min.}
translate P HalfMoves {półruchy}

# Common endings in material search:
translate P EndingPawns {Końcówki pionowe} 
translate P EndingRookVsPawns {Wieża na pion(y)} 
translate P EndingRookPawnVsRook {Wieża i pion na wieżę}
translate P EndingRookPawnsVsRook {Wieża i pion(y) na wieżę}
translate P EndingRooks {Końcówki wieżowe}
translate P EndingRooksPassedA {Końcówki wieżowe z wolnym pionem a}
translate P EndingRooksDouble {Końcówki czterowieżowe}
translate P EndingBishops {Końcówki gońcowe}
translate P EndingBishopVsKnight {Końcówki goniec na skoczka}
translate P EndingKnights {Końcówki skoczkowe}
translate P EndingQueens {Końcówki hetmańskie}
translate P EndingQueenPawnVsQueen {Hetman i pion na hetmana}
translate P BishopPairVsKnightPair {Dwa gońce na dwa skoczki w grze środkowej}

# Common patterns in material search:
translate P PatternWhiteIQP {Izolowany pion u białych} 
translate P PatternWhiteIQPBreakE6 {Izolowowany pion u białych: przełom d4-d5 przy pionku e6}
translate P PatternWhiteIQPBreakC6 {Izolowowany pion u białych: przełom d4-d5 przy pionku c6}
translate P PatternBlackIQP {Izolowany pion u czarnych}
translate P PatternWhiteBlackIQP {Izolowane piony u obu stron}
translate P PatternCoupleC3D4 {Wiszące białe piony c3+d4}
translate P PatternHangingC5D5 {Wiszące czarne piony c5+d5}
translate P PatternMaroczy {Struktura Maroczego (piony na c4 i e4)} 
translate P PatternRookSacC3 {Ofiara wieży na c3}
translate P PatternKc1Kg8 {Różnostronne roszady (Kc1 i Kg8)}
translate P PatternKg1Kc8 {Różnostronne roszady (Kg1 i Kc8)}
translate P PatternLightFian {Białopolowe fianchetto (Gg2 i Gb7)}
translate P PatternDarkFian {Czarnopolowe fianchetto (Gb2 i Gg7)}
translate P PatternFourFian {Poczwórne fianchetto (gońce na b2, g2, b7, g7)}

# Game saving:
translate P Today {Dzisiaj}
translate P ClassifyGame {Klasyfikacja debiutowa}

# Setup position:
translate P EmptyBoard {Pusta szachownica}
translate P InitialBoard {Pozycja początkowa}
translate P SideToMove {Na posunięciu}
translate P MoveNumber {Posunięcie nr}
translate P Castling {Roszada}
translate P EnPassantFile {Bicie w przelocie}
translate P ClearFen {Kopiuj FEN}
translate P PasteFen {Wklej pozycję FEN}
translate P SaveAndContinue {Zapisz i kontynuuj}
translate P DiscardChangesAndContinue {Porzuć Zmiany}
translate P GoBack {Anuluj}

# Replace move dialog:
translate P ReplaceMove {Zmień posunięcie}
translate P AddNewVar {Dodaj wariant}
translate P NewMainLine {Nowy wariant główny}
translate P ReplaceMoveMessage {Posunięcie już istnieje.

Możesz je zastąpić, usuwając dalszy ciąg partii lub dodać nowy wariant.

(Można wyłączyć to ostrzeżenie, wyłączając opcję  "Zapytaj przed zastąpieniem posunięć" w menu
Opcje:Posunięcia)}

# Make database read-only dialog:
translate P ReadOnlyDialog {Jeśli zabezpieczysz tę bazę przed zapisem, zmiany będą zablokowane
żadna partia nie będzie zapisana ani zmodyfikowana, żadne flagi nie będą zmienione.
Sortowanie i klasyfikacja debiutowa będą tylko tymczasowe.

Żeby usunąć zabezpieczenie przez zapisem, wystarczy zamknąć bazę i otworzyć ją ponownie.

Na pewno zabezpieczyć bazę przed zapisem?}

# Exit dialog:
translate P ExitDialog {Na pewno zakończyć pracę z programem?}
# ====== TODO To be translated ======
translate P ClearGameDialog {This game has been altered.\nDo you wish to save it?}
translate P ExitUnsaved {Następujące bazy zawierają niezapisane zmiany. Jeśli zamkniesz program teraz, zmiany zostaną utracone.} 

# Import window:
translate P PasteCurrentGame {Wklej aktualną partię}
translate P ImportHelp1 {Wprowadź lub wklej partię w formacie PGN w poniższą ramkę.}
translate P ImportHelp2 {Tu będą wyświetlane błędy przy importowaniu partii.}
translate P OverwriteExistingMoves {Zastąpić istniejące posunięcia?}

# ECO Browser:
translate P ECOAllSections {Wszystkie kody ECO}
translate P ECOSection {Część ECO}
translate P ECOSummary {Podsumowanie dla}
translate P ECOFrequency {Częstości kodów dla}

# Opening Report:
translate P OprepTitle {Raport debiutowy}
translate P OprepReport {Raport}
translate P OprepGenerated {Utworzony przez}
translate P OprepStatsHist {Statystyka i historia}
translate P OprepStats {Statystyka}
translate P OprepStatAll {Wszystkie partie}
translate P OprepStatBoth {Obaj zawodnicy z Elo}
translate P OprepStatSince {Od}
translate P OprepOldest {Najdawniejsze partie}
translate P OprepNewest {Ostatnie partie}
translate P OprepPopular {Popularność}
translate P OprepFreqAll {Częstość w całej bazie:         }
translate P OprepFreq1   {W ostatnim roku:                }
translate P OprepFreq5   {W ostatnich pięciu latach:      }
translate P OprepFreq10  {W ostatnich dziesięciu latach:  }
translate P OprepEvery {co %u partii}
translate P OprepUp {więcej o %u%s niż w całej bazie}
translate P OprepDown {mniej o %u%s niż w całej bazie}
translate P OprepSame {jak w całej bazie}
translate P OprepMostFrequent {Gracze najczęściej stosujący wariant}
translate P OprepMostFrequentOpponents {Przeciwnicy} 
translate P OprepRatingsPerf {Rankingi i wyniki}
translate P OprepAvgPerf {średnie rankingi i wyniki}
translate P OprepWRating {Ranking białych}
translate P OprepBRating {Ranking czarnych}
translate P OprepWPerf {Wynik białych}
translate P OprepBPerf {Wynik czarnych}
translate P OprepHighRating {Partie graczy o najwyższym średnim rankingu}
translate P OprepTrends {Wyniki}
translate P OprepResults {Długość partii i częstości}
translate P OprepLength {Długość partii}
translate P OprepFrequency {Częstość}
translate P OprepWWins {Zwycięstwa białych:  }
translate P OprepBWins {Zwycięstwa czarnych: }
translate P OprepDraws {Remisy:              }
translate P OprepWholeDB {cała baza}
translate P OprepShortest {Najkrótsze zwycięstwa}
translate P OprepMovesThemes {Posunięcia i motywy}
translate P OprepMoveOrders {Posunięcia prowadzące do badanej pozycji}
translate P OprepMoveOrdersOne \
  {Badana pozycja powstawała jedynie po posunięciach:}
translate P OprepMoveOrdersAll \
  {Badana pozycja powstawała na %u sposobów:}
translate P OprepMoveOrdersMany \
  {Badana pozycja powstawała na %u sposobów. Najczęstsze %u to:}
translate P OprepMovesFrom {Posunięcia w badanej pozycji}
translate P OprepMostFrequentEcoCodes {Najczęstsze kody ECO} 
translate P OprepThemes {Motywy pozycyjne}
translate P OprepThemeDescription {Częstość motywów w pierwszych %u posunięciach partii} 
translate P OprepThemeSameCastling {Jednostronne roszady}
translate P OprepThemeOppCastling {Różnostronne roszady}
translate P OprepThemeNoCastling {Obie strony bez roszady}
translate P OprepThemeKPawnStorm {Atak pionowy na skrzydle królewskim}
translate P OprepThemeQueenswap {Wymiana hetmanów}
translate P OprepThemeWIQP {Izolowany pion białych} 
translate P OprepThemeBIQP {Izolowany pion czarnych}
translate P OprepThemeWP567 {Biały pion na 5/6/7 linii}
translate P OprepThemeBP234 {Czarny pion na 2/3/4 linii}
translate P OprepThemeOpenCDE {Otwarta kolumna c/d/e}
translate P OprepTheme1BishopPair {Jedna ze stron ma parę gońców}
translate P OprepEndgames {Końcówki}
translate P OprepReportGames {Partie raportu}
translate P OprepAllGames {Wszystkie partie}
translate P OprepEndClass {Materiał w pozycji końcowej}
translate P OprepTheoryTable {Teoria}
translate P OprepTableComment {Utworzono z %u partii o najwyższym średnim rankingu.}
translate P OprepExtraMoves {Dodatkowe posunięcia w przypisach}
translate P OprepMaxGames {Maksymalna liczba partii w teorii}
translate P OprepViewHTML {Źródło HTML} 
translate P OprepViewLaTeX {Źródło LaTeX} 

# Player Report:
translate P PReportTitle {Raport o graczu}
translate P PReportColorWhite {białymi}
translate P PReportColorBlack {czarnymi}
# ====== TODO To be translated ======
translate P PReportBeginning {Beginning with}
translate P PReportMoves {po %s}
translate P PReportOpenings {Debiuty}
translate P PReportClipbase {Wyczyść schowek i skopiuj do niego wybrane partie}

# Piece Tracker window:
translate P TrackerSelectSingle {Lewy przycisk wybiera tę figurę.}
translate P TrackerSelectPair {Lewy przycisk wybiera tę figurę; prawy obie takie figury.}
translate P TrackerSelectPawn {Lewy przycisk wybiera tego piona; prawy wszystkie 8 pionów.}
translate P TrackerStat {Statystyka}
translate P TrackerGames {% partie z posunięciem na tym polu}
translate P TrackerTime {% czasu na tym polu}
translate P TrackerMoves {Posunięcia}
translate P TrackerMovesStart {Podaj numer posunięcia, od którego zacząć śledzenie.}
translate P TrackerMovesStop {Podaj numer posunięcia, na którym skończyć śledzenie.}

# Game selection dialogs:
translate P SelectAllGames {Wszystkie partie w bazie}
translate P SelectFilterGames {Partie w filtrze}
translate P SelectTournamentGames {Tylko partie z aktualnego turnieju}
translate P SelectOlderGames {Tylko wcześniejsze partie}

# Delete Twins window:
translate P TwinsNote {Partie zostaną uznane za identyczne, jeśli zostały rozegrane przez tych samych graczy i spełniają ustawione poniżej kryteria. Krótsza z partii zostanie usunięta. Uwaga: dobrze przez wyszukaniem powtórzonych partii sprawdzić pisownię nazwisk.}
translate P TwinsCriteria {Kryteria: co musi być jednakowe w obu partiach?}
translate P TwinsWhich {Przeszukiwane partie}
translate P TwinsColors {Kolory}
translate P TwinsEvent {Turniej:}
translate P TwinsSite {Miejsce:}
translate P TwinsRound {Runda:}
translate P TwinsYear {Rok:}
translate P TwinsMonth {Miesiąc:}
translate P TwinsDay {Dzień:}
translate P TwinsResult {Wynik:}
translate P TwinsECO {Kod ECO:}
translate P TwinsMoves {Posunięcia:}
translate P TwinsPlayers {Porównywanie nazwisk:}
translate P TwinsPlayersExact {Dokładne}
translate P TwinsPlayersPrefix {Tylko pierwsze 4 litery}
translate P TwinsWhen {Usuwanie znalezionych powtórzonych partii}
translate P TwinsSkipShort {Pomijać partie krótsze niż 5 posunięć?}
translate P TwinsUndelete {Odzyskać wszystkie partie przed poszukiwaniem?}
translate P TwinsSetFilter {Wstawić wszystkie usunięte partie do filtra?}
translate P TwinsComments {Zawsze zachowywać partie komentowane?}
translate P TwinsVars {Zawsze zachowywać partie z wariantami?}
translate P TwinsDeleteWhich {Którą partię usunąć:} 
translate P TwinsDeleteShorter {Krótszą} 
translate P TwinsDeleteOlder {O niższym numerze}
translate P TwinsDeleteNewer {O wyższym numerze}
translate P TwinsDelete {Usuń partie}

# Name editor window:
translate P NameEditType {Nazwa do wyboru}
translate P NameEditSelect {Partie do edycji}
translate P NameEditReplace {Zastąp}
translate P NameEditWith {przez}
translate P NameEditMatches {Pasujące: Ctrl+1 do Ctrl+9 wybiera}
translate P CheckGamesWhich {Sprawdź partie}
translate P CheckAll {Wszystkie}
translate P CheckSelectFilterGames {Tylko partie z filtra}

# Classify window:
translate P Classify {Przyporządkowanie ECO}
translate P ClassifyWhich {Partie do przyporządkowania ECO}
translate P ClassifyAll {Wszystkie partie (zmiana starych kodów ECO)}
translate P ClassifyYear {Wszystkie partie z ostatniego roku}
translate P ClassifyMonth {Wszystkie partie z ostatniego miesiąca}
translate P ClassifyNew {Tylko partie bez kodu ECO}
translate P ClassifyCodes {Kody ECO}
translate P ClassifyBasic {Tylko podstawowe ("B12", ...)}
translate P ClassifyExtended {Rozszerzone kody Scida ("B12j", ...)}

# Compaction:
translate P NameFile {Plik nazw}
translate P GameFile {Plik z partiami}
translate P Names {Nazwy}
translate P Unused {Nieużywane}
translate P SizeKb {Rozmiar (kb)}
translate P CurrentState {Status}
translate P AfterCompaction {Po uporządkowaniu}
translate P CompactNames {Uporządkuj nazwy}
translate P CompactGames {Uporządkuj partie}
translate P NoUnusedNames "Brak nieużywanych nazw, plik nazw jest już uporządkowany."
translate P NoUnusedGames "Plik partii jest już uporządkowany."
translate P NameFileCompacted {Plik nazw dla bazy "[file tail [sc_base filename]]" został uporządkowany.}
translate P GameFileCompacted {Plik partii dla bazy "[file tail [sc_base filename]]" został uporządkowany.}

# Sorting:
translate P SortCriteria {Kryteria sortowania}
translate P AddCriteria {Dodaj kryteria}
translate P CommonSorts {Standardowe kryteria}
translate P Sort {Sortuj}

# Exporting:
translate P AddToExistingFile {Dodać partie do pliku?}
translate P ExportComments {Eksportować komentarze?}
translate P ExportVariations {Eksportować warianty?}
translate P IndentComments {Wcinaj komentarze?}
translate P IndentVariations {Wcinaj warianty?}
translate P ExportColumnStyle {Kolumny (jedno posunięcie w wierszu)?}
translate P ExportSymbolStyle {Styl znaków komentarza:}
translate P ExportStripMarks {Usuwać z komentarzy kody kolorowania pól/strzałek?} 

# Goto game/move dialogs:
translate P LoadGameNumber {Podaj numer partii do wczytania:}
translate P GotoMoveNumber {Idź do posunięcia nr:}

# Copy games dialog:
translate P CopyGames {Kopiuj partie}
translate P CopyConfirm {
 Czy na pewno skopiować
 [::utils::thousands $nGamesToCopy] partii z filtra
 w bazie "$fromName"
 do bazy "$targetName"?
}
translate P CopyErr {Nie można skopiować partii}
translate P CopyErrSource {baza źródłowa}
translate P CopyErrTarget {baza docelowa}
translate P CopyErrNoGames {nie ma partii w filtrze}
translate P CopyErrReadOnly {jest tylko do odczytu}
translate P CopyErrNotOpen {nie jest otwarta}

# Colors:
translate P LightSquares {Jasne pola}
translate P DarkSquares {Ciemne pola}
translate P SelectedSquares {Wybrane pola}
translate P SuggestedSquares {Wybrane posunięcie}
translate P Grid {Krata}
translate P Previous {Poprzednie}
translate P WhitePieces {Białe figury}
translate P BlackPieces {Czarne figury}
translate P WhiteBorder {Kontur białych figur}
translate P BlackBorder {Kontur czarnych figur}
translate P ArrowMain   {Główna strzałka}
translate P ArrowVar    {Strzałka wariantów}

# Novelty window:
translate P FindNovelty {Znajdź nowinkę}
translate P Novelty {Nowinka}
translate P NoveltyInterrupt {Poszukiwanie nowinki przerwano}
translate P NoveltyNone {Nie znaleziono nowinki w partii}
translate P NoveltyHelp {
Scid znajdzie pierwsze posunięcie w partii, po którym powstanie pozycja niewystępująca ani w bazie, ani w książce debiutowej.
}

# Sounds configuration:
translate P SoundsFolder {Katalog plików dźwiękowych}
translate P SoundsFolderHelp {Katalog powinien zawierać pliki King.wav, a.wav, 1.wav itd.}
translate P SoundsAnnounceOptions {Ustawienia ogłaszania posunięć}
translate P SoundsAnnounceNew {Ogłaszaj nowe posunięcia}
translate P SoundsAnnounceForward {Ogłaszaj posunięcia przy przeglądaniu}
translate P SoundsAnnounceBack {Ogłaszaj posunięcia przy cofaniu}

# Upgrading databases:
translate P Upgrading {Konwersja}
translate P ConfirmOpenNew {
Ta baza jest zapisana w starym formacie (Scid 2) i nie może zostać otwarta w nowszej wersji
Scid-a. Baza została już automatycznie przekonwertowana do nowego formatu.

Czy otworzyć nową wersję bazy?
}
translate P ConfirmUpgrade {
Ta baza jest zapisana w starym formacie (Scid 2) i nie może zostać otwarta w nowszej wersji Scid-a. Żeby móc otworzyć bazę, trzeba przekonwertować ją do nowego formatu.

Konwersja utworzy nową wersję bazy - stara wersja nie zostanie zmieniona ani usunięta.

Może to zająć trochę czasu, ale jest to operacja jednorazowa. Możesz ją przerwać, jeśli potrwa za długo.

Przekonwertować bazę?
}

# Recent files options:
translate P RecentFilesMenu {Liczba ostatnich plików w menu Plik} 
translate P RecentFilesExtra {Liczba ostatnich plików w dodatkowym podmenu} 

# My Player Names options:
translate P MyPlayerNamesDescription {
Podaj listę preferowanych nazwisk graczy, po jednym w wierszu. W nazwiskach można stosować znaki specjalne (np. "?" - dowolny znak, "*" - dowolna sekwencja znaków).

Wszystkie partie grane przez jednego z graczy z listy będą wyświetlane z jego perspektywy.
}
translate P showblunderexists {pokaż błąd}
translate P showblundervalue {pokaż wagę błędu}
translate P showscore {pokaż ocenę}
translate P coachgame {partia treningowa}
translate P configurecoachgame {konfiguruj partię treningową}
translate P configuregame {Konfiguracja partii}
translate P Phalanxengine {Program Phalanx}
translate P Coachengine {Program treningowy}
translate P difficulty {poziom trudności}
translate P hard {wysoki}
translate P easy {niski}
translate P Playwith {Graj}
translate P white {białymi}
translate P black {czarnymi}
translate P both {oboma kolorami}
translate P Play {Gra}
translate P Noblunder {Bez błędów}
translate P blunder {błąd}
translate P Noinfo {-- Brak informacji --}
translate P moveblunderthreshold {posunięcie jest błędem, jeśli strata jest większa niż}
translate P limitanalysis {ogranicz czas analizy}
translate P seconds {sekund}
translate P Abort {Przerwij}
translate P Resume {Wznów}
# TODO
translate P Restart {Restart}
translate P OutOfOpening {Po debiucie}
translate P NotFollowedLine {Nie grałeś wariantu}
translate P DoYouWantContinue {Na pewno kontynuować?}
translate P CoachIsWatching {Trener się przygląda}
translate P Ponder {Ciągłe myślenie}
translate P LimitELO {Ogranicz siłę Elo}
translate P DubiousMovePlayedTakeBack {Zagrałeś wątpliwe posunięcie, chcesz je cofnąć?}
translate P WeakMovePlayedTakeBack {Zagrałeś słabe posunięcie, chcesz je cofnąć?}
translate P BadMovePlayedTakeBack {Zagrałeś bardzo słabe posunięcie, chcesz je cofnąć?}
translate P Iresign {Poddaję się}
translate P yourmoveisnotgood {twoje posunięcie nie jest dobre}
translate P EndOfVar {Koniec wariantu}
translate P Openingtrainer {Trening debiutowy}
translate P DisplayCM {Pokaż ruchy-kandydaty}
translate P DisplayCMValue {Pokaż ocenę ruchów-kandydatów}
translate P DisplayOpeningStats {Pokaż statystykę}
translate P ShowReport {Pokaż raport}
translate P NumberOfGoodMovesPlayed {liczba dobrych posunięć}
translate P NumberOfDubiousMovesPlayed {liczba wątpliwych posunięć}
translate P NumberOfTimesPositionEncountered {liczba wystąpień pozycji}
translate P PlayerBestMove  {Tylko najlepsze posunięcia}
translate P OpponentBestMove {Przeciwnik gra najlepsze posunięcia}
translate P OnlyFlaggedLines {Tylko zaznaczone warianty}
translate P resetStats {Wyczyść statystykę}
translate P Movesloaded {Posunięcia wczytane}
translate P PositionsNotPlayed {Pozycje nie rozgrywane}
translate P PositionsPlayed {Pozycje rozgrywane}
translate P Success {Sukces}
translate P DubiousMoves {Wątpliwe posunięcia}
translate P ConfigureTactics {Konfiguruj taktykę}
translate P ResetScores {Wyczyść punkty}
translate P LoadingBase {Wczytaj bazę}
translate P Tactics {Taktyka}
translate P ShowSolution {Pokaż rozwiązanie}
translate P Next {Następne}
translate P ResettingScore {Czyszczenie punktów}
translate P LoadingGame {Wczytywanie partii}
translate P MateFound {Znaleziono mata}
translate P BestSolutionNotFound {Nie znaleziono rozwiązania!}
translate P MateNotFound {Nie znaleziono mata}
translate P ShorterMateExists {Istnieje krótsze rozwiązanie}
translate P ScorePlayed {Ocena zagranego posunięcia}
translate P Expected {oczekiwana ocena}
translate P ChooseTrainingBase {Wybierz bazę treningową}
translate P Thinking {Analiza}
translate P AnalyzeDone {Analiza zakończona}
translate P WinWonGame {Wygraj wygraną partię}
translate P Lines {Warianty}
translate P ConfigureUCIengine {Konfiguruj program UCI}
translate P SpecificOpening {Wybrany program}
translate P StartNewGame {Rozpocznij nową partię}
translate P FixedLevel {Stały poziom}
translate P Opening {Debiut}
translate P RandomLevel {Losowy poziom}
translate P StartFromCurrentPosition {Rozpocznij od aktualnej pozycji}
translate P FixedDepth {Stała głębokość}
translate P Nodes {Pozycje} 
translate P Depth {Głębokość}
translate P Time {Czas} 
translate P SecondsPerMove {Sekundy na posunięcie}
# ====== TODO To be translated ======
translate P DepthPerMove {Depth per move}
# ====== TODO To be translated ======
translate P MoveControl {Move Control}
# TODO
translate P TimeLabel {Czas na posunięcie}
# ====== TODO To be translated ======
translate P AddVars {Add Variations}
# ====== TODO To be translated ======
translate P AddScores {Add Score}
translate P Engine {Program}
translate P TimeMode {Tempo gry}
translate P TimeBonus {Czas + dodatek}
translate P TimeMin {min}
translate P TimeSec {s}
translate P AllExercisesDone {Wszystkie zadania zakończone}
translate P MoveOutOfBook {Posunięcie spoza książki debiutowej}
translate P LastBookMove {Ostatnie posunięcie w książce debiutowej}
translate P AnnotateSeveralGames {Komentuj kilka partii\ od aktualnej do:}
translate P FindOpeningErrors {Znajdź błędy debiutowe}
translate P MarkTacticalExercises {Oznacz zadania taktyczne}
translate P UseBook {Użyj książki debiutowej}
translate P MultiPV {Wiele wariantów}
translate P Hash {Pamięć bufora}
translate P OwnBook {Użyj książki debiutowej programu}
translate P BookFile {Książka debiutowa}
translate P AnnotateVariations {Komentuj warianty}
translate P ShortAnnotations {Skrócone komentarze}
translate P addAnnotatorTag {Dodaj znacznik komentatora}
translate P AddScoreToShortAnnotations {Dodaj ocenę do skróconych komentarzy}
translate P Export {Eksportuj}
translate P BookPartiallyLoaded {Książka częściowo wczytana}
# ====== TODO To be translated ======
translate P AddLine {Add Line}
# ====== TODO To be translated ======
translate P RemLine {Remove Line}
translate P Calvar {Liczenie wariantów}
translate P ConfigureCalvar {Konfiguracja}
translate P Reti {Debiut Reti}
translate P English {Partia angielska}
translate P d4Nf6Miscellaneous {1.d4 Nf6 inne}
translate P Trompowsky {Trompowsky}
translate P Budapest {Gambit budapeszteński}
translate P OldIndian {Obrona staroindyjska}
translate P BenkoGambit {Gambit wołżański}
translate P ModernBenoni {Modern Benoni}
translate P DutchDefence {Obrona holenderska}
translate P Scandinavian {Obrona skandynawska}
translate P AlekhineDefence {Obrona Alechina}
translate P Pirc {Obrona Pirca}
translate P CaroKann {Obrona Caro-Kann}
translate P CaroKannAdvance {Obrona Caro-Kann, 3.e5}
translate P Sicilian {Obrona sycylijska}
translate P SicilianAlapin {Obrona sycylijska, wariant Ałapina}
translate P SicilianClosed {Obrona sycylijska, wariant zamknięty}
translate P SicilianRauzer {Obrona sycylijska, wariant Rauzera}
translate P SicilianDragon {Obrona sycylijska, wariant smoczy}
translate P SicilianScheveningen {Obrona sycylijska, wariant Scheveningen}
translate P SicilianNajdorf {Obrona sycylijska, wariant Najdorfa}
translate P OpenGame {Debiuty otwarte}
translate P Vienna {Partia wiedeńska}
translate P KingsGambit {Gambit królewski}
translate P RussianGame {Partia rosyjska}
translate P ItalianTwoKnights {Partia włoska/obrona dwóch skoczków}
translate P Spanish {Partia hiszpańska}
translate P SpanishExchange {Partia hiszpańska, wariant wymienny}
translate P SpanishOpen {Partia hiszpańska, wariant otwarty}
translate P SpanishClosed {Partia hiszpańska, wariant zamknięty}
translate P FrenchDefence {Obrona francuska}
translate P FrenchAdvance {Obrona francuska, 3.e5}
translate P FrenchTarrasch {Obrona francuska, wariant Tarrascha}
translate P FrenchWinawer {Obrona francuska, wariant Winawera}
translate P FrenchExchange {Obrona francuska, wariant wymienny}
translate P QueensPawn {Debiut piona hetmańskiego}
translate P Slav {Obrona słowiańska}
translate P QGA {Przyjęty gambit hetmański}
translate P QGD {Nieprzyjęty gabit hetmański}
translate P QGDExchange {Gambit hetmański, wariant wymienny}
translate P SemiSlav {Obrona półsłowiańska}
translate P QGDwithBg5 {Gambit hetmański z Bg5}
translate P QGDOrthodox {Gambit hetmański, wariant ortodoksalny}
translate P Grunfeld {Obrona Grünfelda}
translate P GrunfeldExchange {Obrona Grünfeld, wariant wymienny}
translate P GrunfeldRussian {Obrona Grünfelda, wariant rosyjski}
translate P Catalan {Partia katalońska}
translate P CatalanOpen {Partia katalońska, wariant otwarty}
translate P CatalanClosed {Partia katalońska, wariant zamknięty}
translate P QueensIndian {Obrona hetmańsko-indyjska}
translate P NimzoIndian {Obrona Nimzowitscha}
translate P NimzoIndianClassical {Obrona Nimzowitscha, wariant klasyczny}
translate P NimzoIndianRubinstein {Obrona Nimzowitscha, wariant Rubinsteina}
translate P KingsIndian {Obrona królewsko-indyjska}
translate P KingsIndianSamisch {Obrona królewsko-indyjska, wariant Sämischa}
translate P KingsIndianMainLine {Obrona królewsko-indyjska, wariant główny}

# FICS todo
translate P ConfigureFics {Konfiguruj FICS}
translate P FICSLogin {Zaloguj się}
translate P FICSGuest {Zaloguj się jako gość}
translate P FICSServerPort {Port serwera}
translate P FICSServerAddress {Adres IP}
translate P FICSRefresh {Odśwież}
translate P FICSTimeseal {Timeseal}
translate P FICSTimesealPort {Port Timeseal}
translate P FICSSilence {Filtr konsoli}
translate P FICSOffers {Propozycje}
translate P FICSGames {Partie}
translate P FICSFindOpponent {Znajdź przeciwnika}
translate P FICSTakeback {Cofnij}
translate P FICSTakeback2 {Cofnij 2}
translate P FICSInitTime {Czas (min)}
translate P FICSIncrement {Inkrement (sec)}
translate P FICSRatedGame {Partia liczona do rankingu}
translate P FICSAutoColour {Automatycznie}
translate P FICSManualConfirm {Potwierdź ręcznie}
translate P FICSFilterFormula {Filtruj przy użyciu formuły}
translate P FICSIssueSeek {Szukaj przeciwnika}
translate P FICSAccept {Akceptuj}
translate P FICSDecline {Odrzuć}
translate P FICSColour {Kolor}
translate P FICSSend {Wyślij}
translate P FICSConnect {Połącz}
# ====== TODO To be translated ======
translate P FICSShouts {Shouts}
# ====== TODO To be translated ======
translate P FICSTells {Tells}
translate P FICSOpponent {Informacja o przeciwniku}
translate P FICSInfo {Informacja}
translate P FICSDraw {Proponuj remis}
translate P FICSRematch {Rewanż}
translate P FICSQuit {Wyłącz FICS}
# ====== TODO To be translated ======
translate P FICSCensor {Censor}

translate P CCDlgConfigureWindowTitle {Konfiguruj grę korespondencyjną}
translate P CCDlgCGeneraloptions {Ustawienia ogólne}
translate P CCDlgDefaultDB {Domyślna baza:}
translate P CCDlgInbox {Skrzynka odbiorcza (ścieżka):}
translate P CCDlgOutbox {Skrzynka nadawcza (ścieżka):}
translate P CCDlgXfcc {Konfiguracja Xfcx:}
translate P CCDlgExternalProtocol {Zewnętrzna obsługa protokołów (np. Xfcc)}
translate P CCDlgFetchTool {Narzędzie pobierania:}
translate P CCDlgSendTool {Narzędzie wysyłania:}
translate P CCDlgEmailCommunication {Komunikacja e-mail}
translate P CCDlgMailPrg {Program pocztowy:}
translate P CCDlgBCCAddr {Adres (U)DW:}
translate P CCDlgMailerMode {Tryb:}
translate P CCDlgThunderbirdEg {np. Thunderbird, Mozilla Mail, Icedove...}
translate P CCDlgMailUrlEg {np. Evolution}
translate P CCDlgClawsEg {np Sylpheed Claws}
translate P CCDlgmailxEg {np. mailx, mutt, nail...}
translate P CCDlgAttachementPar {Parametr załącznika:}
translate P CCDlgInternalXfcc {Użyj wbudowanej obsługi Xfcc}
translate P CCDlgConfirmXfcc {Potwierdź posunięcia}
translate P CCDlgSubjectPar {Parametr tematu:}
translate P CCDlgDeleteBoxes {Opróżnij skrzynki nadawczą i odbiorczą}
translate P CCDlgDeleteBoxesText {Na pewno opróżnić foldery nadawczy i odbiorczy dla szachów korespondencyjnych? To wymaga synchronizacji, by wyświetlić aktualny stan Twoich partii}
translate P CCDlgConfirmMove {Potwierdź posunięcie}
translate P CCDlgConfirmMoveText {Jeśli potwierdzisz, następujące posunięcie i komentarz zostaną wysłane na serwer:}
translate P CCDlgDBGameToLong {Niezgodny wariant główny}
translate P CCDlgDBGameToLongError {Wariant główny w Twojej bazie jest dłuższy niż w skrzynce odbiorczej. Jeśli skrzynka odbiorcza zawiera aktualny stan partii, posunięcia zostały błędnie dodane do głównej bazy.\nW takim wypadku proszę skrócić wariant główny co najmniej do posunięcia\n}
translate P CCDlgStartEmail {Rozpocznij nową partię e-mail}
translate P CCDlgYourName {Imię i nazwisko:}
translate P CCDlgYourMail {Adres e-mail:}
translate P CCDlgOpponentName {Imię i nazwisko przeciwnika:}
translate P CCDlgOpponentMail {Adres e-mail przeciwnika:}
translate P CCDlgGameID {Unikatowy identyfikator partii:}
translate P CCDlgTitNoOutbox {Scid: skrzynka nadawcza}
translate P CCDlgTitNoInbox {Scid: skrzynka odbiorcza}
translate P CCDlgTitNoGames {Scid: brak partii korespondencyjnych}
translate P CCErrInboxDir {Katalog odbiorczy szachów korespondencyjnych:}
translate P CCErrOutboxDir {Katalog nadawczy szachów korespondencyjnych:}
translate P CCErrDirNotUsable {nie istnieje lub jest niedostępny.\nProszę sprawdzić i poprawić ustawienia.}
translate P CCErrNoGames {nie zawiera żadnych partii!\nProszę najpierw je pobrać.}
translate P CCDlgTitNoCCDB {Scid: brak bazy korespondencyjnej}
translate P CCErrNoCCDB {Nie otwarto bazy typu 'Szachy korespondencyjne'. Proszę otworzyć ją przed użyciem funkcji do gry korespondencyjnej.}
translate P CCFetchBtn {Pobierz partie z serwera i przetwórz skrzynkę odbiorczą}
translate P CCPrevBtn {Przejdź do poprzedniej partii}
translate P CCNextBtn {Przejdź do następnej partii}
translate P CCSendBtn {Wyślij posunięcie}
translate P CCEmptyBtn {Opróżnij skrzynkę odbiorczą i nadawczą}
translate P CCHelpBtn {Pomoc dla ikon i znaczników stanu.\nProszę wcisnąć F1, by zobaczyć ogólną pomoc.}
translate P CCDlgServerName {Nazwa serwera:}
translate P CCDlgLoginName  {Nazwa użytkownika:}
translate P CCDlgPassword   {Hasło:}
translate P CCDlgURL        {Adres Xfcc:}
translate P CCDlgRatingType {Typ rankingu:}
translate P CCDlgDuplicateGame {Nieunikatowy identyfikator partii}
translate P CCDlgDuplicateGameError {Ta partia jest powtórzona w bazie danych. Proszę usunąć wszystkie powtórzenia i uporządkować plik bazy  delete (Plik/Obsługa/Uporządkuj).}
translate P CCDlgSortOption {Sortowanie:}
translate P CCDlgListOnlyOwnMove {Tylko partie, gdzie jestem na posunięciu}
translate P CCOrderClassicTxt {Miejsce, turniej, runda, wynik, białe, czarne}
translate P CCOrderMyTimeTxt {Mój czas}
translate P CCOrderTimePerMoveTxt {Czas na posunięcie do następnej kontroli}
translate P CCOrderStartDate {Data rozpoczęcia}
translate P CCOrderOppTimeTxt {Czas przeciwnika}
translate P CCDlgConfigRelay {Konfiguruj obserwowanie ICCF}
translate P CCDlgConfigRelayHelp {Przejdź na stronę partii na http://www.iccf-webchess.com i wyświetl partię do obserwowania. Jeśli widzisz szachownicę, skopiuj adres z przeglądarki do listy poniżej (jeden adres na wiersz).\nPrzykład: http://www.iccf-webchess.com/MakeAMove.aspx?id=266452}
translate P ExtHWConfigConnection {Konfiguruj urządzenie zewnątrzne}
translate P ExtHWPort {Port}
translate P ExtHWEngineCmd {Polecenie programu}
translate P ExtHWEngineParam {Parametr programu}
translate P ExtHWShowButton {Pokaż przycisk}
translate P ExtHWHardware {Sprzęt}
translate P ExtHWNovag {Novag Citrine}
translate P ExtHWInputEngine {Program wejściowy}
translate P ExtHWNoBoard {Brak szachownicy}
translate P IEConsole {Terminal programu wejściowego}
translate P IESending {Posunięcia wysłane do}
translate P IESynchronise {Synchronizuj}
translate P IERotate  {Obróć}
translate P IEUnableToStart {Nie można uruchomić programu wejściowego:}
translate P DoneWithPosition {Pozycja zakończona}
translate P Board {Szachownica}
translate P showGameInfo {Pokaż informacje o partii}
translate P autoResizeBoard {Automatycznie zmień wielkość szachownicy}
translate P DockTop {Przenieś do góry}
translate P DockBottom {Przenieś do dołu}
translate P DockLeft {Przenieś na lewo}
translate P DockRight {Przenieś na prawo}
translate P Undock {Odłącz}
translate P ChangeIcon {Zmień ikonę}
# ====== TODO To be translated ======
translate P More {More}


# Drag & Drop
translate P CannotOpenUri {Nie można otworzyć adresu URI:}
# ====== TODO To be translated ======
translate P InvalidUri {Drop content is not a valid URI list.}
translate P UriRejected	{Następujące pliki są usunięte:}
# ====== TODO To be translated ======
translate P UriRejectedDetail {Only the listed file types can be handled:}
# ====== TODO To be translated ======
translate P EmptyUriList {Drop content is empty.}
# ====== TODO To be translated ======
translate P SelectionOwnerDidntRespond {Timeout during drop action: selection owner didn't respond.}

}

### Tips of the day in Polish:

set tips(P) {
  {
    Scid ma ponad 30 <a Index>stron pomocy</a> i w większości okien Scida
    naciśnięcie klawisza <b>F1</b> spowoduje wyświetlenie odpowiedniej
    strony.
  }
  {
    Niektóre okna Scida (np. informacje pod szachownicą,
    <a Switcher>przełącznik baz</a>) mają menu przywoływane prawym przyciskiem
    myszy. Spróbuj nacisnąć prawy przycisk myszy w każdym oknie, by
    sprawdzić, czy menu jest dostępne i jakie funkcje zawiera.
  }
  {
    Scid pozwala wprowadzać posunięcia na kilka różnych sposobów.
    Możesz użyć myszy (z wyświetlaniem możliwych posunięć lub bez)
    albo klawiatury (z opcjonalnym automatycznym dopełnianiem).
    Więcej informacji można znaleźć na stronie pomocy
    <a Moves>Wprowadzenie posunięć</a>.
  }
  {
    Jeśli masz kilka baz, które otwierasz często, dodaj
    <a Bookmarks>zakładkę</a> dla każdej z nich. Umożliwi to łatwe
    otwieranie baz z menu.
  }
  {
    Możesz obejrzeć wszystkie posunięcia w aktualnej partii
    (z wariantami i komentarzami lub bez) w <a PGN>Oknie PGN</a>.
    W oknie PGN możesz przejść do dowolnego posunięcia, klikając
    na nim lewym przyciskiem myszy oraz użyć środkowego lub prawego
    przycisku myszy do obejrzenia aktualnej pozycji.
  }
  {
    Możesz kopiować partie z bazy do bazy przeciągając je lewym
    przyciskiem myszy w oknie <a Switcher>Przełącznika baz</a>.
  }
  {
    Scid może otwierać pliki PGN, nawet jeśli są one skompresowane
    Gzip-em (z rozszerzeniem .gz). Pliki PGN mogą być jedynie
    czytane, więc jeśli chcesz coś zmienić, utwórz nową bazę Scida
    i skopiuj do niej partie z pliku PGN.
  }
  {
    Jeśli masz dużą bazę i często używasz okna <a Tree>Drzewa wariantów</a>,
    warto wybrać polecenie <b>Twórz standardowy plik cache/b>
    z menu Plik okna Drzewo wariantów. Statystyki dla najpopularniejszych
    pozycji debiutowych zostaną zapamiętane w pliku, co przyspieszy
    działanie drzewa.
  }
  {
    <a Tree>Drzewo wariantów</a> może pokazać wszystkie posunięcia
    z aktualnej pozycji, ale jeśli chcesz zobaczyć wszystkie kolejności
    posunięć prowadzące do aktualnej pozycji, możesz użyć
    <a OpReport>Raportu debiutowego</a>.
  }
  {
    W <a GameList>liście partii</a> kliknij lewym lub prawym przyciskiem
    myszy na nagłówku wybranej kolumny, by zmienić jej szerokość.
  }
  {
    W oknie <a PInfo>Informacja o graczu</a> (kliknij na nazwisku gracza
    w polu pod szachownicą, by je otworzyć) możesz łatwo ustawić
    <a Searches Filter>filtr</a> zawierający wszystkie partie danego
    gracza zakończeone wybranym wynikiem, klikając na dowolnej wartości
    wyświetlanej na <red>czerowono</red>.
  }
  {
    Podczas pracy nad debiutem warto użyć funkcji
    <a Searches Board>wyszukiwania pozycji</a> z opcją <b>Pionki</b> lub
    <b>Kolumny</b>. Pozowli to znaleźć inne warianty debiutowe z tą
    samą strukturą pionową.
  }
  {
    W polu informacji o partii (pod szachownicą) można użyć prawego
    przycisku myszy, by wyświetlić menu konfiguracji pola. Można
    np. ukryć następne posunięcie, co jest przydatne przy rozwiązywaniu
    zadań.
  }
  {
    Jeśli często używasz funkcji <a Maintenance>obsługi</a> na dużej
    bazie, możesz użyć okna <a Maintenance Cleaner>Zestaw zadań</a>
    do wykonania kilka funkcji naraz.
  }
  {
    Jeśli masz dużą bazę, w której większość partii ma ustawiony
    znacznik EventDate, możesz <a Sorting>posortować</a> ją
    wg tego znacznika (zamiast Daty). Dzięki temu wszystkie partie
    z jednego turnieju znajdą się koło siebie.
  }
  {
    Przed użyciem funkcji <a Maintenance Twins>usuwania podwójnych partii</a>
    dobrze jest <a Maintenance Spellcheck>sprawdzić pisownię</a>
    nazwisk w bazie, co usprawni wyszukiwanie powtórzeń.
  }
  {
    <a Flags>Flagi</a> są przydatne do oznaczania partii, które
    zawierają ważne motywy taktyczne, struktury pionowe, nowinki itd.
    Potem możesz znaleźć takie partie
    <a Searches Header>wyszukiwaniem wg nagłówka</a>.
  }
  {
    Jeśli przeglądasz partię i chcesz sprawdzić jakiś wariant nie
    zmieniając partii, możesz włączyć tryb testowania wariantu
    (klawisz <b>Ctrl+spacja</b> lub ikona na pasku narzędziowym).
    Po wyłączeniu trybu testowania powrócisz do pozycji z partii.
  }
  {
    ¯eby znaleźć najważniejsze partie (z najsilniejszymi przeciwnikami),
    w których powstała aktualna pozycja, otwórz <a Tree>Drzewo wariantów</a>
    i wybierz listę najlepszych partii. Możesz nawet wybrać tylko
    partie zakończone konkretnym wynikiem.
  }
  {
    Dobrą metodą na naukę debiutu przy użyciu dużej bazy jest
    włączenie trybu treningu w <a Tree>Drzewie wariantów</a>
    i gra z programem. Pozwala to sprawdzić, które posunięcia są
    grane najczęściej.
  }
  {
    Jeśli masz otwarte dwie bazy i chcesz obejrzeć
    <a Tree>Drzewo wariantów</a> dla pierwszej bazy, przeglądając
    partię z drugiej, kliknij przycisk <b>Blokada</b> na drzewie,
    by zablokować je na pierwszej bazie, a następnie przełącz się
    do drugiej bazy.
  }
  {
    Okno <a Tmt>Turnieje</a> jest przydatne nie tylko do znajdowania
    turniejów, ale pozwala także sprawdzić, w jakich turniejach grał
    ostatnio dany zawodnik i jakie turnieje są rozgrywane w wybranym
    kraju.
  }
  {
    Możesz użyć jednego z wielu typowych wzorców w oknie
    <a Searches Material>Wyszukiwania wg materiału</a> do znalezienia
    partii do studiowania debiutów lub gry środkowej.
  }
  {
    W oknie <a Searches Material>Wyszukiwanie wg materiału</a>, możesz
    ograniczyć liczbę znajdowanych partii przez warunek, by
    podany stosunek materiału utrzymywał się przynajmniej przez
    kilka półruchów.
  }
  {
    Jeśli masz ważną bazę, której nie chcesz przez przypadek zmienić,
    włącz <b>Tylko do odczytu...</b> w menu <b>Plik</b> po jej otwarciu
    (albo zmień prawa dostępu do pliku).
  }
  {
    Jeśli używasz XBoard-a lub WinBoard-a (albo programu szachowego,
    który pozwala na skopiowania pozycji w notacji FEN do schowka)
    i chcesz skopiować aktualną pozycję do Scid-a, wybierz
    <b>Copy position</b> w menu File programu XBoard/Winboard, a potem
    <b>Wklej aktywną partię ze schowka</b> z menu Edycja Scid-a.
  }
  {
    W oknie <a Searches Header>Wyszukiwanie wg nagłówka</a>,
    szukane nazwy graczy/turnieju/miejsca/rundy są znajdowane niezależnie
    od wielkości liter i również wewnątrz nazw.
    Zamiast tego możesz użyć poszukiwania z symbolami wieloznacznymi
    (gdzie "?" oznacza dowolny znak, zaś "*" - 0 lub więcej znaków),
    wpisując szukany tekst w cudzysłowie. Wielkość liter zostanie
    uwzględniona. Na przykład "*BEL" znajdzie wszystkie turnieje grane
    w Belgii (ale nie w Belgradzie).
  }
  {
    Jeśli chcesz poprawić posunięcie nie zmieniając następnych,
    otwórz okno <a Import>Pobierz partię</a>, wciśnij
    <b>Wklej aktualną partię</b>, zmień błędne posunięcie i wciśnij
    <b>Pobierz</b>.
  }
  {
    Jeśli plik klasyfikacji debiutowej ECO jest wczytany, możesz przejść
    do ostatniej sklasyfikowanej pozycji w partii za pomocą polecenia
    <b>Rozpoznaj debiut</b> w menu <b>Partia</b> (klawisz Ctrl+Shift+D).
  }
  {
    Jeśli chcesz sprawdzić wielkość lub datę modyfikacji pliku
    przed jego otwarciem, użyj okna <a Finder>Poszukiwacza plików</a>.
  }
  {
    <a OpReport>Raport debiutowy</a> pozwala dowiedzieć się więcej
    o konkretnej pozycji. Możesz zobaczyć wyniki, nazwiska najczęściej
    grających ją zawodników, typowe motywy pozycyjne itd.
  }
  {
    Możesz dodać większość typowych symboli (!, !?, += itd.) do
    aktualnego posunięcia lub pozycji za pomocą skrótów klawiszowych,
    bez potrzeby otwierania okna <a Comment>Edytora komentarzy</a>
    -- np. wciśnięcie "!" i Enter spowoduje dodanie symbolu "!".
    Na stronie <a Moves>Wprowadzanie posunięć</a> można znaleźć
    więcej informacji.
  }
  {
    Możesz łatwo przeglądać debiuty w bazie w oknie
    <a Tree>Drzewo wariantów</a>. W oknie Statystyka (klawisz Ctrl+I)
    można znaleźć informacje o ostatnich wynikach w wariancie oraz
    o partiach granych przez silnych graczy.
  }
  {
    Możesz zmienić wielkość szachownicy, naciskając <b>lewo</b> lub <b>prawo</b>
    przy wciśniętych klawiszach <b>Ctrl</b> i <b>Shift</b>.
  }
  {
    Po <a Searches>wyszukiwaniu</a> możesz łatwo przeglądać wszystkie
    znalezione partie, naciskając klawisz <b>góra</b> lub <b>dół</b>
    przy wciśniętym <b>Ctrl</b> by obejrzeć poprzednią/następną partię
    w filtrze.
  }
}

# end of polish.tcl
