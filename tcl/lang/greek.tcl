#
# greek.tcl:
#
# Οδηγίες για προσθήκη νέας Γλώσσας:
#
# (1) Διαλέξτε ένα γράμμα ως κωδικός για την γλώσσα. Τρέχοντες κωδικοί είναι: 
#      E=English, D=Deutsch, F=Francais, S=Spanish, B=Brasil Portuguese,
#      P=Polish, N=Nederlands, W=Swedish, O=Norsk, C=Czech, H=Hungarian,
#      Y=Serbian, G=Greek.
#
# (2) Διορθώστε το κωδικό γράμμα στο κείμενο "addLanguage ..." και προσθέστε
#     την νέα γλώσσα. Το τελευταίο ψηφίο σε κάθε γραμμή είναι ο δείκτης του
#     γράμματος που υπογραμμίζεται σε κάθε μενού, η αρίθμηση γίνεται από το 0.
#
# (3) Μεταφράστε το κείμενο στα "εισαγωγικά" ή στις {αγκύλες} για κάθε menuText και εντολή.
#
#     Μια εντολή μενού έχει την μορφή:
#         menuText L tag "Ονομασία..." υπογράμμιση {ΜήνυμαΒοήθειας}
#
#     Ένα γενικό μήνυμα έχει την μορφή:
#         translate L tag {μήνυμα}
#
# Σημειώσεις:
#
#     "ΜήνυμαΒοήθειας" μπορείτε να το παραλείψετε, αφού επί του παρόντος δεν χρησιμοποιείτε από το Scid vs. PC
#
#     "υπογράμμιση" είναι ο δείκτης του γράμματος προς υπογράμμιση, ξεκινώντας από το 0
#     ως πρώτο γράμμα. Δύο στοιχεία μενού που εμφανίζονται στο ίδιο μενού
#     πρέπει να έχουν διαφορετικό υπογραμμισμένο γράμμα.
#     Αν έχετε αμφιβολία, απλά χρεισιμοποιήστε το δείκτη "0"

addLanguage G Greek 0 iso8859-7

proc setLanguage_G {} {

# File menu:
menuText G File "Αρχείο" 2
menuText G FileNew "Νέο" 0 {Δημιουργείστε μια νέα βάση δεδομένων}
menuText G FileOpen "Άνοιγμα" 4 {Ανοίξτε μια υπάρχουσα βάση δεδομένων}
menuText G FileClose "Κλείσιμο" 0 {Κλείστε την ενεργή βάση δεδομένων}
menuText G FileFinder "Αναζήτηση Βάσης" 3 {Άνοιγμα παραθύρου Αναζήτηση Βάσης Δεδομένων}
menuText G FileSavePgn "Αποθήκευση ως PGN" 3 {Αποθήκευση παρτίδας ως PGN}
menuText G FileOpenBaseAsTree "Άνοιγμα Βάσης ως Δένδρο" 8 \
  {Άνοιγμα Βάσης και χρησιμοποίησή της στο παράθυρο Δένδρο Κινήσεων}
menuText G FileOpenRecentBaseAsTree "Άνοιγμα Πρόσφατης ως Δένδρο" 8 \
  {Άνοιγμα πρόσφατης Βάσης και χρησιμοποίησή της στο παράθυρο Δένδρο Κινήσεων}
menuText G FileBookmarks "Σελιδοδείκτες" 4 {Μενού σελιδοδεικτών}
menuText G FileBookmarksAdd "Προσθήκη Σελιδοδείκτη" 1 \
  {Σελιδοδείκτης στην τρέχουσα παρτίδα της βάσης δεδομένων και τη θέση}
menuText G FileBookmarksFile "Αρχειοθέτηση Σελιδοδείκτη" 1 \
  {Αρχειοθετήστε έναν σελιδοδείκτη για την τρέχουσα παρτίδα και θέση}
menuText G FileBookmarksEdit "Επεξεργασία Σελιδοδείκτων" 3 \
  {Επεξεργαστείτε τους σελιδοδείκτες}
menuText G FileBookmarksList "Εμφάνιση Καταλόγων ως απλή λίστα" 0 \
  {Εμφάνιση των καταλόγων των σελιδοδεικτών ως απλής λίστα και όχι ως υπομενού}
menuText G FileBookmarksSub "Εμφάνιση των καταλόγων ως Υπομενού" 0 \
  {Εμφάνιση των καταλόγων των σελιδοδεικτών ως υπομενού και όχι ως απλή λίστα}
menuText G FileReadOnly "Προστασία εγγραφής" 15 \
  {Προστασία της τρέχουσας Βάσης Δεδομένων από τυχόν μεταβολές}
menuText G FileSwitch "Αλλαγή Βάσης δεδομένων" 1 \
  {Επιλογή διαφορετικής, ήδη ανοιγμένης, Βάσης Δεδομένων}
menuText G FileExit "Έξοδος" 1 {Έξοδος από το Scid vs. PC}

# Edit menu:
menuText G Edit "Επεξεργασία" 3
menuText G EditAdd "Προσθήκη Βαριάντας" 4 {Προσθήκη Βαριάντας στη συγκεκριμένη θέση}
menuText G EditPasteVar "Επικόλληση Βαριάντας" 1
menuText G EditDelete "Διαγραφή Βαριάντας" 6 {Διαγραφή της Βαριάντας για αυτή την κίνηση}
menuText G EditFirst "Προαγωγή Βαριάντας ως Πρώτης" 2 \
  {Προαγωγή της Βαριάντας στην πρώτη θέση της λίστας}
menuText G EditMain "Προαγωγή Βαριάντας ως Κύριας" 5 \
  {Προαγωγή της Βαριάντας ως κύρια γραμμή}
menuText G EditTrial "Δοκιμή Βαριάντας" 7 \
  {Έναρξη/διακοπή δοκιμής μιας ιδέας στην σκακιέρα}
menuText G EditStrip "Καθαρισμός" 0 {Καθαρισμός σχολίων ή βαριάντων από την παρτίδα}
menuText G EditUndo "Αναίρεση" 1 {Αναίρεση τελευταίας αλλαγής στην παρτίδα}
menuText G EditRedo "Επαναφορά" 7 {Επαναφορά τελευταίας αλλαγής στην παρτίδα}
menuText G EditStripComments "Σχολίων" 0 \
  {Διαγραφή όλων των σχολίων και υπομνημάτων από την παρτίδα}
menuText G EditStripVars "Βαριάντων" 0 {Διαγραφή όλων των βαριάντων από την παρτίδα}
menuText G EditStripBegin "Κινήσεων από Αρχή" 13 \
  {Διαγραφή κινήσεων από την αρχή της παρτίδας}
menuText G EditStripEnd "Κινήσεων μέχρι Τέλος" 15 \
  {Διαγραφή κινήσεων μέχρι το τέλος της παρτίδας}
menuText G EditReset "Άδειασμα Clipbase" 6 \
  {Άδειασμα Προσωρινής Βάσης Δεδομένων (Clipbase)}
menuText G EditCopy "Αντιγραφή στην Clipbase" 0 \
  {Αντιγραφή της παρτίδας στην Προσωρινή Βάση Δεδομένων (Clipbase)}
menuText G EditPaste "Επικόλληση από Clipbase" 0 \
  {Επικόλληση ενεργής παρτίδας της Προσωρινής Βάσης (Clipbase)}
menuText G EditPastePGN "Επικόλληση PGN" 8 \
  {Επικόλληση του κειμένου της προσωρινής μνήμης ως παρτίδας PGN}
menuText G EditSetup "Διαμόρφωση Σκακιέρας" 0 \
  {Τοποθέτηση κομματιών στη σκακιέρα ως αρχικής θέσης}
menuText G EditCopyBoard "Αντιγραφή FEN" 2 \
  {Αντιγραφή τρέχουσας σκακιέρας στην προσωρινή μνήμη (clipboard) με σχολιασμό FEN}
menuText G EditCopyPGN "Αντιγραφή PGN" 4 \
  {Αντιγραφή της τρέχουσας παρτίδας PGN ως κειμένου στην προσωρινή μνήμη (clipboard)}
menuText G EditPasteBoard "Επικόλληση FEN" 6 \
  {Επικόλληση του κειμένου της προσωρινής μνήμης (clipboard) ως θέσης FEN}

# Game menu:
menuText G Game "Παρτίδα" 2
menuText G GameNew "Νέα παρτίδα" 0 {Νέα παρτίδα, απορρίπτωντας οποιεσδήποτε αλλαγές}
menuText G GameFirst "Φόρτωση Πρώτης" 9 {Φόρτωση Πρώτης Παρτίδας Φίλτρου}
menuText G GamePrev "Φόρτωση Προηγούμενης" 12 {Φόρτωση Προηγούμενης Παρτίδας Φίλτρου}
menuText G GameReload "Επαναφόρτωση" 5 {Επαναφόρτωση τρέχουσας παρτίδας, αναιρώντας οποιεσδήποτε αλλαγές}
menuText G GameNext "Φόρτωση Επόμενης" 11 {Φόρτωση επόμενης φιλτραρισμένης παρτίδας}
menuText G GameLast "Φόρτωση Τελευταίας" 8 {Φόρτωση της τελευταίας φιλτραρισμένης παρτίδας}
menuText G GameRandom "Φόρτωση Τυχαίας" 10 {Φόρτωση τυχαίας παρτίδας από τις φιλτραρισμένες}
menuText G GameNumber "Φόρτωση με Αριθμό" 11 {Φόρτωση παρτίδας εισάγωντας τον αριθμό της}
menuText G GameReplace "Αποθήκευση: Αντικατάσταση" 13 {Αποθήκευση παρτίδας αντικαθιστώντας την παλαιότερη εκδοχή της}
menuText G GameAdd "Αποθήκευση: Προσθήκη" 16 {Αποθήκευση της παρτίδας ως νέας στην Βάση Δεδομένων}
menuText G GameInfo "Ορισμός Στοιχείων" 0
menuText G GameBrowse "Προεπισκόπηση" 0
menuText G GameList "Ευρετήριο Όλων" 0
menuText G GameDelete "Διαγραφή Παρτίδας" 0
menuText G GameDeepest "Αναγνώριση Ανοίγματος" 8 {Αναγνώριση Ανοίγματος βάσει της τελευταίας κίνησης που περιέχεται στο βιβλίο ECO}
menuText G GameGotoMove "Μετάβαση σε κίνηση" 4 {Μετάβαση στην κίνηση με τον συγκεκριμένο αριθμό στην παρτίδα}
menuText G GameNovelty "Αναζήτηση Καινοτομίας" 10 {Έυρεση πρώτης κίνησης στην παρτίδα που δεν έχει παιχθεί ποτέ ξανά}

# Search Menu:
menuText G Search "Αναζήτηση" 3
menuText G SearchReset "Μηδενισμός Φίλτρου" 2 {Μηδενισμός φίλτρου ώστε να περιλαμβάνονται όλες οι παρτίδες}
menuText G SearchNegate "Αντιστροφή Φίλτρου" 8 {Αντιστροφή φίλτρου ώστε να περιλαμβάνονται μόνο οι παρτίδες που εξαιρέθηκαν}
menuText G SearchEnd "Φίλτρο στην Τελ. Κίνηση" 15 {Όλες οι φιλτραρισμένες παρτίδες φορτώνονται στη τελική θέση}
menuText G SearchCurrent "Τρέχουσα Θέση" 3 {Αναζήτηση βάσει της τρέχουσας θέσης}
menuText G SearchHeader "Γενικά" 0 {ύρεση βάσει γενικών στοιχείων (Παίκτης, Διοργάνωση, κλπ)}
menuText G SearchMaterial "Υλικό/Σχηματισμός" 0 {Αναζήτηση βάσει Υλικού ή Σχηματισμού}
menuText G SearchMoves "Κινήσεις" 0 {}
menuText G SearchUsing "Φόρτωση Φίλτρου" 4 {Εύρεση χρησιμοποιώντας Φίλτρα που είναι αποθηκευμένα σε αρχείο}

# Windows menu:
menuText G Windows "Παράθυρα" 0
menuText G WindowsGameinfo "Στοιχεία Παρτίδας" 11 {Εμφάνιση/απόκρυψη του πλαισίου Πληροφοριών Παρτίδας}
menuText G WindowsComment "Συντάκτης Σχολίων" 11 {Άνοιγμα/κλείσιμο του Συντάκτη Σχολίων}
menuText G WindowsGList "Ευρετήριο Παρτίδων" 0 {Άνοιγμα/κλείσιμο παραθύρου Ευρετήριο Παρτίδων}
menuText G WindowsPGN "Παρτιδόφυλλο" 8 {Άνοιγμα/κλείσιμο παραθύρου PGN (Παρτιδόφυλλο)}
menuText G WindowsCross "Κατάταξη(Crosstable)" 0 {Άνοιγμα/κλείσιμο Πίνακα Κατάταξης Τουρνουά (Crosstable)}
menuText G WindowsPList "Ευρετήριο Παικτών" 10 {Άνοιγμα/κλείσιμο Ευρετήριο Παικτών}
menuText G WindowsTmt "Ευρετήριο Τουρνουά" 10 {Άνοιγμα/κλείσιμο Ευρετήριο Τουρνουά}
menuText G WindowsSwitcher "Βάσεις Δεδομένων" 0 \
  {Άνοιγμα/κλείσιμο Παραθύρου Επιλογής Βάσης Δεδομένων}
menuText G WindowsMaint "Συντήρηση" 0 \
  {Άνοιγμα/κλείσιμο παραθύρου Συντήρησης}
menuText G WindowsECO "Ευρετήριο ECO" 10 {Άνοιγμα/κλείσιμο παραθύρου Ευρετηρίου ECO}
menuText G WindowsStats "Στατιστικών" 4 \
  {Άνοιγμα/κλείσιμο παραθύρου φιλτραρίσματος Στατιστικών Βάσης Δεδομένων}
menuText G WindowsTree "Δένδρο Κινήσεων" 0 {Άνοιγμα/κλείσιμο παραθύρου Δένδρου Κινήσεων}
menuText G WindowsTB "Φινάλε" 0 {Άνοιγμα/κλείσιμο παραθύρου Βάσης Δεδομένων για Φινάλε (Tablebase)}
menuText G WindowsBook "Ανοίγματα" 0 {Άνοιγμα/κλείσιμο παραθύρου Βιβλίου Ανοιγμάτων}
menuText G WindowsCorrChess "Αλληλογραφίας" 1 {Άνοιγμα/κλείσιμο παραθύρου Αλληλογραφίας}

# Tools menu:
menuText G Tools "Εργαλεία" 0
menuText G ToolsAnalysis "Μηχανές Ανάλυσης" 2 {Ρύθμισεις Μηχανών Ανάλυσης}
menuText G ToolsEmail "Διαχειριστής Email" 14 {Άνοιγμα/κλείσιμο παραθύρου Διαχειριστή Email}
menuText G ToolsFilterGraph "Σχ. Γράφημα Φίλτρου" 0 {Άνοιγμα/κλείσιμο παραθύρου Γραφήματος Φίλτρου με Σχετικές Τιμές}
menuText G ToolsAbsFilterGraph "Απ. Γράφημα Φίλτρου" 0 {Άνοιγμα/κλείσιμο παραθύρου Γραφήματος Φίλτρου με Απόλυτες Τιμές}
menuText G ToolsOpReport "Αναφορά Ανοίγματος" 9 {Δημιουργία Αναφοράς Ανοίγματος για την τρέχουσα θέση}
menuText G ToolsTracker "Παρακολούθηση Κομματιού"  9 {Άνοιγμα παραθύρου Παρακολούθησης Κομματιού}
menuText G ToolsTraining "Εκπαίδευση"  0 {Εκπαιδευτικά εργαλεία (Τακτικά, Ανοιγμάτων, ...) }
menuText G ToolsComp "Τουρνουά Μηχανών" 0 {Τουρνουά Σκακιστικών Μηχανών}
menuText G ToolsTacticalGame "Computer - Phalanx"  11 {Παιχνίδι Τακτικής με το Phalanx}
menuText G ToolsSeriousGame "Computer - UCI Engine"  11 {Παιχνίδι εναντίον UCI μηχανής}
menuText G ToolsTrainTactics "Ματ σε ..Χ.. κινήσεις"  0 {Ασκήσεις "Ματ σε"}
menuText G ToolsTrainCalvar "Υπολογισμός Βαριάντων"  0 {Άσκηση Stoyko}
menuText G ToolsTrainFindBestMove "Άσκηση Καλύτερης Κίνησης"  1 {Άσκηση υπολογισμού Καλύτερης Κίνησης}
menuText G ToolsTrainFics "Διαδίκτυο (FICS)"  0 {Παιχνίδι στο freechess.org}
menuText G ToolsBookTuning "Ρυθμ.Βιβλ.Ανοίγματος" 5 {Ρυθμίσεις βιβλίου ανοίγματος}
menuText G ToolsMaint "Συντήρηση" 0 {Εργαλεία συντήρησης βάσεων δεδομένων}
menuText G ToolsMaintWin "Παράθυρο Συντήρησης" 0 \
  {Ανοίγμα/Κλείσιμο παραθύρου Συντήρησης βάσης δεδομένων}
menuText G ToolsMaintCompact "Συμπίεση Βάσης Δεδομένων" 0 \
  {Συμπιέση αρχείων βάσης δεδομένων απομακρύνοντας διαγραμμένες παρτίδες και μη χρησιμοποιημένα ονόματα}
menuText G ToolsMaintClass "Προσθήκη ECO στις Παρτίδες" 1 \
  {Επανυπολογισμός ECO για όλες τις παρτίδες}
menuText G ToolsMaintSort "Ταξινόμηση Βάσης Δεδομένων" 2 \
  {Ταξινομήση παρτίδων βάσης δεδομένων}
menuText G ToolsMaintDelete "Διαγραφή Διπλών Παρτίδων" 0 \
  {Εύρεση διπλών παρτίδων και επιλογή τους προς διαγραφή}
menuText G ToolsMaintTwin "Παράθυρο Ελέγχου Διπλών Παρτίδων" 9 \
  {Άνοιγμα/ενημέρωση παραθύρου Ελέγχου διπλών παρτίδων}
menuText G ToolsMaintNameEditor "Επεξεργαστής Ονομάτων" 3 \
  {Άνοιγμα/κλείσιμο του παραθύρου Επεξεργαστή Ονομάτων}
menuText G ToolsMaintNamePlayer "Συλλαβισμός Ονομάτων Παικτών" 21 \
  {Έλεγχος Ονομάτων παικτών με την χρήση σχετικού αρχείου παικτών}
menuText G ToolsMaintNameEvent "Συλλαβισμός Ονομάτων Διοργανώσεων" 21 \
  {Έλεγχος ονομάτων διοργανώσεων με την χρήση σχετικού αρχείου}
menuText G ToolsMaintNameSite "Συλλαβισμός Ονομάτων Τοποθεσιών" 21 \
  {Έλεγχος ονομάτων τοποθεσιών με την χρήση σχετικού αρχείου τοποθεσιών}
menuText G ToolsMaintNameRound "Έλεγχος Γύρων Αγώνων" 8 \
  {Έλεγχος γύρων αγώνων με την χρήση σχετικού αρχείου γύρων}
menuText G ToolsMaintFixBase "Επιδιόρθωση Βάσης Δεδομένων" 7 {Προσπάθεια επιδιόρθωσης χαλασμένης Βάσης Δεδομένων}


menuText G ToolsConnectHardware "Σύνδεση Hardware" 3 {Σύνδεση εξωτερικού hardware}
menuText G ToolsConnectHardwareConfigure "Ρύθμιση..." 0 {Ρύθμιση εξωτερικού hardware και σύνδεση}
menuText G ToolsConnectHardwareNovagCitrineConnect "Σύνδεση Novag Citrine" 0 {Σύνδεση του Novag Citrine με το Scid}
menuText G ToolsConnectHardwareInputEngineConnect "Σύνδεση Μηχ. Εισαγωγής" 8 {Σύνδεση Μηχανής Εισαγωγής Κινήσεων (e.g. DGT board) με το Scid}
# these three unused
menuText G ToolsNovagCitrine "Novag Citrine" 0 {Novag Citrine}
menuText G ToolsNovagCitrineConfig "Ρύθμιση" 0 {Ρυθμίσεις Novag Citrine}
menuText G ToolsNovagCitrineConnect "Σύνδεση" 0 {Σύνδεση Novag Citrine}

menuText G ToolsPInfo "Πληροφορίες Παίκτη"  5 \
  {Άνοιγμα/κλείσιμο παραθύρου Πληροφοριών σχετικά με τον Παίκτη}
menuText G ToolsPlayerReport "Αναφορά Παίκτη" 8 \
  {Δημιουργία Αναφοράς σχετικά με τον Παίκτη}
menuText G ToolsRating "Βαθμολογία Παίκτη" 5 \
  {Γράφημα Ιστορικής Βαθμολογίας των Παικτών της παρτίδας}
menuText G ToolsScore "Γράφημα Σκορ" 0 {Εμφάνιση Παραθύρου Γραφήματος Σκορ}
menuText G ToolsExpCurrent "Εξαγωγή Παρτίδας" 1 \
  {Εγγραφή παρτίδας σε αρχείο κειμένου}
menuText G ToolsExpCurrentPGN "Εξαγωγή σε PGN" 0 \
  {Εγγραφή παρτίδας σε αρχείο PGN}
menuText G ToolsExpCurrentHTML "Εξαγωγή σε HTML" 1 \
  {Εγγραφή παρτίδας σε αρχείο HTML}
menuText G ToolsExpCurrentHTMLJS "Εξαγωγή σε HTML με JavaScript" 2 {Εγγραφή παρτίδας σε αρχείο HTML με υποστήριξη JavaScript}  
menuText G ToolsExpCurrentLaTeX "Εξαγωγή σε LaTeX" 3 \
  {Εγγραφή παρτίδας σε αρχείο LaTeX}
# ====== TODO To be translated ======
menuText G ToolsExpFilter "Εξαγωγή Φιλτρ.Παρτίδων" 4 \
  {Εγγραφή Όλων των φιλτραρισμένων παρτίδων σε αρχείο κειμένου}
menuText G ToolsExpFilterPGN "Εξαγωγή σε PGN" 0 \
  {Εγγραφή Όλων των φιλτραρισμένων παρτίδων σε αρχείο PGN}
menuText G ToolsExpFilterHTML "Εξαγωγή σε HTML" 1 \
  {Εγγραφή Όλων των φιλτραρισμένων παρτίδων σε αρχείο HTM}
menuText G ToolsExpFilterHTMLJS "Εξαγωγή σε HTML με JavaScript" 2 {Εγγραφή Όλων των φιλτραρισμένων παρτίδων σε αρχείο HTML με υποστήριξη JavaScript}  
menuText G ToolsExpFilterLaTeX "Εξαγωγή σε LaTeX" 3 \
  {Εγγραφή Όλων των φιλτραρισμένων παρτίδων σε αρχείο LaTeX}
# ====== TODO To be translated ======
# ====== TODO To be translated ======
menuText G ToolsExpFilterGames "Export Gamelist to Text" 19 {Print a formatted Gamelist.}
menuText G ToolsImportOne "Εισαγωγή Κειμένου PGN" 9 \
  {Εισαγωγή Παρτίδας από κείμενο PGN}
menuText G ToolsImportFile "Εισαγωγή Αρχείου PGN" 10 {Εισαγωγή Παρτίδας από αρχείο PGN}
menuText G ToolsStartEngine1 "Εκκίνηση Μηχανής 1" 17  {Εκκίνηση Μηχανής 1}
menuText G ToolsStartEngine2 "Εκκίνηση Μηχανής 2" 17  {Εκκίνηση Μηχανής 2}
menuText G ToolsScreenshot "Στιγμιότυπο Σκακιέρας" 2

# Play menue
menuText G Play "Παιχνίδι" 6

# --- Correspondence Chess
menuText G CorrespondenceChess "Σκάκι Δι'Αλληλογραφίας" 0 {Ενέργειες για Σκάκι Δι'Αλληλογραφίας βάσει eMail και Xfcc}
menuText G CCConfigure "Ρύθμιση..." 2 {Ρύθμιση εξωτερικών εργαλείων και γενικών ρυθμίσεων}
menuText G CCConfigRelay "Παρακολούθηση..." 4 {Ορισμός Παρτίδων υπό Παρακολούθηση}
menuText G CCOpenDB "Άνοιγμα Βάσης..." 8 {Άνοιγμα προεπιλεγμένης Βάσης Δι Αλληλογραφίας}
menuText G CCRetrieve "Ανάκτηση Παρτίδων" 1 {Ανάκτηση Παρτίδων μέσω Xfcc-helper}
menuText G CCInbox "Εισερχόμενα" 1 {Προσπέλαση όλων των εισερχόμενων}
menuText G CCSend "Αποστολή Κίνησης" 0 {Αποστολή Κίνησης μέσω eMail ή Xfcc-helper}

menuText G CCResign "Εγκατάλειψη" 0 {Εγκατάλειψη (όχι μέσω eMail)}
menuText G CCClaimDraw "Διεκδίκηση Ισοπαλίας" 0 {Αποστολή Κίνησης και Διεκδίκηση Ισοπαλίας (χωρίς eMail)}
menuText G CCOfferDraw "Πρόταση Ισοπαλίας" 0 {Αποστολή Κίνησης και πρόταση Ισοπαλίας (όχι μέσω eMail)}
menuText G CCAcceptDraw "Αποδοχή Ισοπαλίας" 5 {Αποδοχή Πρότασης για Ισοπαλία (όχι μέσω eMail)}

menuText G CCNewMailGame "Νέα Παρτίδα με eMail..." 6 {Έναρξη νέας Παρτίδας μέσω eMail}
menuText G CCMailMove "Ταχυδρόμηση Κίνησης..." 0 {Αποστολή Κίνησης μέσω eMail στον Αντίπαλο}
menuText G CCGamePage "Σελίδα Παρτίδας..." 0 {Ανάκτηση Παρτίδας μέσω web browser}

# menu in cc window:
menuText G CCEditCopy "Αντιγραφή Ευρετηρίου Παρτίδων σε Clipbase" 0 {Αντιγραφή Παρτίδων ως λίστα CSV στο clipbase}


#  B    GHiJKL    Q  TUV XYZ

# Options menu:
menuText G Options "Ρυθμίσεις" 2
menuText G OptionsBoard "Σκακιέρα/Κομμάτια" 0 {Ρύθμιση Εμφάνισης Σκακιέρας}
menuText G OptionsColour "Χρώμα Φόντου" 7 {Προπιλεγμένο Χρώμα Φόντου Κειμένου}
# ====== TODO To be translated ======
menuText G OptionsBackColour "Background" 0 {Default text widget color}
# ====== TODO To be translated ======
menuText G OptionsEnableColour "Enable" 0 {}
# ====== TODO To be translated ======
menuText G OptionsMainLineColour "Mainline Arrows" 0 {Mainline arrows}
# ====== TODO To be translated ======
menuText G OptionsVarLineColour "Variation Arrows" 0 {Variation arrows}
# ====== TODO To be translated ======
menuText G OptionsRowColour "Rows" 0 {Default tree/book row color}
# ====== TODO To be translated ======
menuText G OptionsSwitcherColour "Switcher" 0 {Default db switcher color}
# ====== TODO To be translated ======
menuText G OptionsProgressColour "Progressbar" 0 {Default progressbar color}
# ====== TODO To be translated ======
menuText G OptionsCrossColour "Crosstable rows" 0 {Default crosstable row color}
menuText G OptionsNames "Τα Ονόματά μου" 3 {Επεξεργασία των Ονομάτων μου}
menuText G OptionsExport "Εξαγωγές" 1 {Ρύθμιση Επιλογών Εξαγωγής}
menuText G OptionsFonts "Γραμματοσειρές" 0 {Ρύθμιση Γραμματοσειρών}
menuText G OptionsFontsRegular "Κανονική" 0 {Ρύθμιση Κανονικής Γραμματοσειράς}
menuText G OptionsFontsMenu "Μενού" 0 {Ρύθμιση Γραμματοσειράς Μενού}
menuText G OptionsFontsSmall "Μικρής" 1 {Ρύθμιση Μικρής Γραμματοσειράς}
menuText G OptionsFontsFixed "Σταθερής" 0 {Ρύθμιση Σταθερής Γραμματοσειράς}
menuText G OptionsGInfo "Πληροφορίες Παρτίδας" 17 {Ρύθμιση Πληροφοριών Παρτίδας}
menuText G OptionsFics "FICS" 0 {Free Chess Internet Server}
menuText G OptionsFicsAuto "Αυτομ.Προαγωγή σε Βασίλισσα" 0
menuText G OptionsFicsColour "Χρώμα Κειμένου" 10
# ====== TODO To be translated ======
menuText G OptionsFicsSize "Board Size" 0
# ====== TODO To be translated ======
menuText G OptionsFicsButtons "User Buttons" 0
# ====== TODO To be translated ======
menuText G OptionsFicsCommands "Init Commands" 0
menuText G OptionsFicsNoRes "Χωρίς Αποτελέσματα" 3
menuText G OptionsFicsNoReq "Χωρίς Αιτήματα" 9
# ====== TODO To be translated ======
menuText G OptionsFicsPremove "Allow Premove" 0

menuText G OptionsLanguage "Γλώσσα" 2 {Επιλογής Γλώσσας Μενού}
menuText G OptionsMovesTranslatePieces "Μετάφραση Κομματιών" 0 {Μετάφραση Πρώτου Γράμματος Κομματιών}
menuText G OptionsMovesHighlightLastMove "Επισήμανση Τελευταίας Κίνησης" 3 {Επισήμανση Τελευταίας Κίνησης}
menuText G OptionsMovesHighlightLastMoveDisplay "Εμφάνιση" 0 {DΕμφανίζει την  Τελευταία Κίνηση Επισημανσμένη}
menuText G OptionsMovesHighlightLastMoveWidth "Πλάτος" 0 {Πλάτος Γραμμής}
menuText G OptionsMovesHighlightLastMoveColor "Χρώμα" 0 {Χρώμα Γραμμής}
menuText G OptionsMoves "Κινήσεις" 0 {Επιλογές εισαγωγής κίνησης}
menuText G OptionsMovesAsk "Ερώτηση Αντικατάστασης Κίνησης" 1 \
  {Ερώτηση πριν την αντικατάσταση υπάρχουσας κίνησης}
menuText G OptionsMovesAnimate "Χρόνος Animation" 0 \
  {Ορισμός χρόνου για animation κίνησης}
menuText G OptionsMovesDelay "Χρ.Καθυστέρηση Αναπαραγωγής" 5 \
  {Ορισμός χρόνου καθυστέρησης της Αναπαραγωγής}
menuText G OptionsMovesCoord "Κίνηση με Συντεταγμένες" 11 \
  {Αποδοχή Κινήσεων με Συντεταγμένες (πχ "g1f3")}
menuText G OptionsMovesSuggest "Εμφάνιση Προτεινόμενης" 0 \
  {Εμφάνιση ή μη Προτεινόμενης Κίνησης}
menuText G OptionsShowVarPopup "Εμφάνιση Παραθύρου Βαριάντων" 9 {Εμφάνιση ή μη Παραθύρου Βαριάντων}  
menuText G OptionsMovesSpace "Προσθ.Κενού Μετά Αριθμ.Κίνησης" 6 {Προσθήκη κενού μετά από τον αριθμό της κίνησης}  
menuText G OptionsMovesKey "Αυτόματη Συμπλήρωση" 0 \
  {Ενεργοποίηση/Απενεργοποίηση αυτόματης συμπλήρωσης εισαγωγής από το πληκτρολόγιο}
menuText G OptionsMovesShowVarArrows "Εμφάνιση Τόξων Βαριάντων" 9 {Ενεργοποίηση/Απενεργοποίηση Εμφάνισης Τόξων Βαριάντων}
menuText G OptionsNumbers "Μορφή Αριθμών" 0 {Επιλογή μορφής εμφάνισης Αριθμών}
menuText G OptionsStartup "Εκκίνηση" 0 {Επιλογή παραθύρων εμφάνισης κατά την εκκίνηση}
menuText G OptionsTheme "Θέματα" 0 {Θέματα Ttk}
menuText G OptionsWindows "Παράθυρα" 0 {Ρύθμισεις Παραθύρων}
menuText G OptionsWindowsIconify "Αυτ.Ελαχιστοποίηση" 4 \
  {Ελαχιστοποίηση όλων των παραθύρων όταν το κεντρικό παράθυρο ελαχιστοποιείται}
menuText G OptionsWindowsRaise "Αυτ.Μεγιστοποίηση" 4 \
  {Μεγιστοποίηση ορισμένων παραθύρων (πχ Μπάρα Εργασίας) όταν εμφανίζονται}
menuText G OptionsSounds "Ήχοι" 1 {Ρυθμίσεις εκφώνησης κινήσεων}
menuText G OptionsWindowsDock "Ομαδοποίηση" 0 {Ομαδοποίηση παραθύρων (απαιτεί επανεκκίνηση)}
menuText G OptionsWindowsSaveLayout "Αποθήκευση layout" 3 {Αποθήκευση layout}
menuText G OptionsWindowsRestoreLayout "Επαναφορά layout" 1 {Επαναφορά layout}
menuText G OptionsWindowsShowGameInfo "Εμφάνιση Πληροφοριών" 0 {Εμφανίζει πληροφορίες σχετικά με την παρτίδα}
menuText G OptionsWindowsAutoLoadLayout "Αυτ.Φόρτωση πρώτου layout" 1 {Αυτόματη φόρτωση του πρώτου layout κατά την εκκίνηση}
menuText G OptionsWindowsAutoResize "Αυτ.Διαστάσεις Σκακιέρας" 4 {Αυτόματοποίηση διαστάσεων σκακιέρας}
# ====== TODO To be translated ======
menuText G OptionsWindowsFullScreen "Fullscreen" 0 {Toggle fullscreen mode}
menuText G OptionsToolbar "Μπάρα Εργαλείων" 10 {Ρυθμίσεις κεντρικής μπάρας εργαλείων}
menuText G OptionsECO "Φόρτωση αρχ.ECO" 12 {Φόρτωση αρχείου ECO}
menuText G OptionsSpell "Φόρτωση αρχ.Συλλαβισμού" 13 \
  {Φόρτωση του αρχείου ελέγχου συλλαβισμού Scid}
menuText G OptionsTable "Κατάλογος Φινάλε" 10 \
  {Επιλογή βάσης φινάλε; όλες οι βάσεις φινάλε που είναι σε ένα κατάλογο θα χρησιμοποιηθούν}
menuText G OptionsRecent "Πρόσφατα Αρχεία" 1 {Επιλογή του αριθμού των πρόσφατων αρχείων που θα εμφανίζονται στο μενού Αρχεία}
menuText G OptionsBooksDir "Κατάλογος Ανοιγμάτων" 10 {Επιλογή του καταλόγου βιβλίων ανοιγμάτων}
menuText G OptionsTacticsBasesDir "Κατάλογος Βάσεων" 10 {Επιλογή του καταλόγου Βάσεων, για τακτικές ασκήσεις (εκπαίδευση)}
menuText G OptionsSave "Αποθήκευση Ρυθμίσεων" 18 "Αποθήκευση όλων των ρυθμίσεων στο αρχείο $::optionsFile"
menuText G OptionsAutoSave "Αυτομ.Αποθηκ.στην Έξοδο" 11 \
  {Αυτόματη αποθήκευση όλων των ρυθμίσεων κατά την έξοδο του προγράμματος Scid}

# Help menu:
menuText G Help "Βοήθεια" 0
menuText G HelpContents "Βοήθεια" 0 {Εμφάνιση περιεχομένων Βοήθειας}
menuText G HelpIndex "Ευρετήριο" 0 {Εμφάνιση του ευρετηρίου της Βοήθειας}
menuText G HelpGuide "Σύντομος Οδηγός" 0 {Εμφάνιση του σύντομου οδηγού Βοήθειας}
menuText G HelpHints "Υποδείξεις" 0 {Εμφάνιση των υποδείξεων της Βοήθειας}
menuText G HelpContact "Επικοινωνία" 0 {Εμφάνιση πληροφοριών επικοινωνίας με κατασκευαστή}
menuText G HelpTip "Υπόδειξη Ημέρας" 2 {Εμφάνιση χρήσιμων Υποδείξεων του Scid}
menuText G HelpStartup "Παράθυρο Εκκίνησης" 0 {Εμφάνιση του παραθύρου Εκκίνησης}
menuText G HelpAbout "Σχετικά" 0 {Πληροφορίες σχετικά με το Scid Vs PC}

# Game info box popup menu:
menuText G GInfoHideNext "Απόκρυψη Επόμενης" 6
menuText G GInfoShow "Ποιος παίζει" 9
menuText G GInfoCoords "Εμφάνιση Συντεταγμένων" 10
menuText G GInfoMaterial "Εμφάνιση Διαφοράς" 9
menuText G GInfoFEN "FEN" 0
menuText G GInfoMarks "Εμφάνιση Χρωμ. Τετραγώνων & Τόξων" 9
menuText G GInfoWrap "Wrap Μεγάλων Γραμμών" 7
menuText G GInfoFullComment "Εμφάνιση Πλήρη Σχολίων" 10
menuText G GInfoPhotos "Εμφάνιση Φωτογραφιών" 9
menuText G GInfoTBNothing "Φινάλε: Χωρίς" 11
menuText G GInfoTBResult "Φινάλε: Μόνο αποτελέσματα" 9
menuText G GInfoTBAll "Φινάλε: Αποτελέσματα & Καλύτερη Κινήση" 21
menuText G GInfoDelete "Διαγραφή (ή μη) Παρτίδας" 1
menuText G GInfoMark "Επισήμανση (ή μη) Παρτίδας" 1
menuText G GInfoInformant "Ρύθμιση Αξιών Χαρακτηρισμών" 1
# ====== TODO To be translated ======
translate G FlipBoard {Flip board}
# ====== TODO To be translated ======
translate G RaiseWindows {Raise windows}
# ====== TODO To be translated ======
translate G AutoPlay {Autoplay}
# ====== TODO To be translated ======
translate G TrialMode {Trial mode}

# General buttons:
translate G Apply {Εφαρμογή}
translate G Back {Πίσω}
translate G Browse {Περιήγηση}
translate G Cancel {Ακύρωση}
translate G Continue {Συνέχεια}
translate G Clear {Καθαρ}
translate G Close {Κλείσιμο}
translate G Contents {Περιεχόμενα}
translate G Defaults {Προεπιλογή}
translate G Delete {Διαγραφή}
translate G Graph {Γράφημα}
translate G Help {Βοήθεια}
translate G Import {Εισαγωγή}
translate G Index {Ευρετήριο}
translate G LoadGame {Φόρτωση}
translate G BrowseGame {Προεπισκ.}
translate G MergeGame {Συγχώνευση}
translate G MergeGames {Συγχών.Παρτίδων}
# translate G Ok {Ok}
translate G Preview {Προεπισκ.}
translate G Revert {Επαναφ.}
translate G Save {Αποθήκευση}
# ====== TODO To be translated ======
translate G DontSave {Don't Save}
translate G Search {Αναζήτηση}
translate G Stop {Διακοπή}
translate G Store {Αποθήκευση}
translate G Update {Ενημέρωση}
translate G ChangeOrient {Αλλαγή προσανατολισμού}
translate G ShowIcons {Εικονίδια}
# ====== TODO To be translated ======
translate G ConfirmCopy {Confirm Copy}
translate G None {Κενό}
translate G First {Πρώτη}
translate G Current {Τρέχουσα}
translate G Last {Τελευταία}
# ====== TODO To be translated ======
translate G Font {Font}
# ====== TODO To be translated ======
translate G Change {Change}
# ====== TODO To be translated ======
translate G Random {Random}

# General messages:
translate G game {Παρτίδα}
translate G games {Παρτίδες}
translate G move {Κίνηση}
translate G moves {Κινήσεις}
translate G all {όλα}
translate G Yes {Ναι}
translate G No {Όχι}
translate G Both {Οποιοσδήποτε}
translate G King {Βασιλιάς}
translate G Queen {Βασίλισσα}
translate G Rook {Πύργος}
translate G Bishop {Αξιωματικός}
translate G Knight {Ίππος}
translate G Pawn {Πιόνι}
translate G White {Λευκά}
translate G Black {Μαύρα}
translate G Player {Παίκτης}
translate G Rating {ELO}
translate G RatingDiff {Διαφορά ELO}
translate G AverageRating {Μέσο ELO}
translate G Event {Διοργάνωση}
translate G Site {Τόπος}
translate G Country {Χώρα}
translate G IgnoreColors {Aγνόηση χρώματος}
# ====== TODO To be translated ======
translate G MatchEnd {End pos only}
translate G Date {Ημερομηνία}
translate G EventDate {Ημέρα Διοργάνωσης}
translate G Decade {Δεκαετία}
translate G Year {Έτος}
translate G Month {Μήνας}
translate G Months {Ιανουάριος Φεβρουάριος Μάρτιος Απρίλιος Μάϊος Ιούνιος Ιούλιος Αύγουστος Σεπτέμβριος Οκτώμβριος Νοέμβριος Δεκέμβριος}
translate G Days {Κυρ Δευ Τρ Τετ Πεμ Παρ Σαβ}
translate G YearToToday {Τρέχον έτος}
translate G Result {Αποτέλεσμα}
translate G Round {Γύρος}
translate G Length {Μήκος}
translate G ECOCode {Κωδ. ECO}
translate G ECO {ECO}
translate G Deleted {Διαγραμμένη}
translate G SearchResults {Αποτελέσματα Αναζήτησης}
translate G OpeningTheDatabase {Άνοιγμα Βάσης}
translate G Database {Βάση}
translate G Filter {Φίλτρο}
# ====== TODO To be translated ======
translate G Reset {Reset}
translate G IgnoreCase {Αγνόηση κεφαλαίων}
translate G noGames {κανένα}
translate G allGames {όλα}
translate G empty {άδειο}
translate G clipbase {clipbase}
translate G score {Σκορ}
translate G Start {Έναρξη}
translate G StartPos {Αρχική Θέση}
translate G Total {Σύνολο}
translate G readonly {read-only}
# ====== TODO To be translated ======
translate G altered {altered}
# ====== TODO To be translated ======
translate G tagsDescript {Extra tags (eg: Annotator "Anand")}
# ====== TODO To be translated ======
translate G prevTags {Use previous}

# Standard error messages:
translate G ErrNotOpen {Η Βάση δεν είναι ανοικτή.}
translate G ErrReadOnly {Η Βάση είναι read-only και δεν τροποποιείται.}
translate G ErrSearchInterrupted {Η Αναζήτηση διεκόπη, τα αποτελέσματα είναι ελλειπή.}

# Game information:
translate G twin {Διπλή}
translate G deleted {Διεγραμμένη}
translate G comment {Σχόλιο}
translate G hidden {κρυφή}
translate G LastMove {Τελ.κίνηση}
translate G NextMove {Επόμενη}
translate G GameStart {Αρχή παρτίδας}
translate G LineStart {Αρχή βαριάντας}
translate G GameEnd {Τέλος παρτίδας}
translate G LineEnd {Τέλος βαριάντας}

# Player information:
translate G PInfoAll {Όλες τις παρτίδες}
translate G PInfoFilter {Φιλτραρισμένες παρτίδες}
translate G PInfoAgainst {Εναντίον}
translate G PInfoMostWhite {Συνήθη ανοίγματα ως Λευκός}
translate G PInfoMostBlack {Συνήθη ανοιγμάτα ως Μαύρος}
translate G PInfoRating {Ιστορικό Βαθμολογίας}
translate G PInfoBio {Βιογραφία}
translate G PInfoEditRatings {Τροπ.Βαθμολογίας}
# ====== TODO To be translated ======
translate G PinfoEditName {Edit Name}
# ====== TODO To be translated ======
translate G PinfoLookupName {Lookup Name}

# Tablebase information:
translate G Draw {Ισοπαλία}
translate G stalemate {ΠΑΤ}
# ====== TODO To be translated ======
translate G checkmate {checkmate}
translate G withAllMoves {με όλες τις κινήσεις}
translate G withAllButOneMove {με όλες εκτός από μία κίνηση}
translate G with {με}
translate G only {μόνο}
translate G lose {χάνει}
translate G loses {χάνουν}
translate G allOthersLose {όλες οι άλλες χάνουν}
translate G matesIn {ματ σε}
translate G longest {μακρύτερη}
translate G WinningMoves {Κινήσεις που κερδίζουν}
translate G DrawingMoves {Κινήσεις ισοπαλίας}
translate G LosingMoves {Κινήσεις που χάνουν}
translate G UnknownMoves {Κινήσεις αγνώστου αποτελέσματος}

# Tip of the day:
translate G Tip {Υπόδειξη}
translate G TipAtStartup {Εμφάνιση Υπόδειξης στην Εκκίνηση}

# Tree window menus:
menuText G TreeFile "Δένδρο" 0
menuText G TreeFileFillWithBase "Γέμισμα Cache από Βάση" 18 {Γέμισμα της προσωρινής μνήμης με όλες τις παρτίδες της παρούσας Βάσης}
menuText G TreeFileFillWithGame "Γέμισμα Cache από Παρτίδα" 18 {Γέμισμα της προσωρινής μνήμης με την συγκεκριμένη παρτίδα}
menuText G TreeFileSetCacheSize "Μέγεθος Cache" 0 {Ορισμός μεγέθους προσωρινής μνήμης}
menuText G TreeFileCacheInfo "Πληροφ. Cache" 5 {Πληροφορίες χρήσης προσωρινής μνήμης}
menuText G TreeFileSave "Αποθήκευση Cache" 3 {Αποθήκευση σε αρχείο προσωρινής μνήμης (.stc)}
menuText G TreeFileFill "Γέμισμα Αρχείου Cache" 0 \
  {Γέμισμα της προσωρινής μνήμης με συνηθισμένες θέσεις ανοιγμάτων}
menuText G TreeFileBest "Καλύτερες Παρτίδες" 0 {Εμφάνιση των καλύτερων παρτίδων του Δένδρου}
menuText G TreeFileGraph "Γράφημα" 0 {Εμφάνιση Γραφήματος για το Δένδρο}
menuText G TreeFileCopy "Αντιγραφή Δένδρου στο Clipboard" 1 \
  {Αντιγραφή στατιστικών Δένδρου στο clipboard}
menuText G TreeFileClose "Κλείσιμο Παραθύρου" 1 {Κλείσιμο παραθύρου Δένδρου}
menuText G TreeMask "Μάσκα" 0
menuText G TreeMaskNew "Νέα" 0 {Νέα μάσκα}
menuText G TreeMaskOpen "Άνοιγμα" 5 {Άνοιγμα μάσκας}
menuText G TreeMaskOpenRecent "Άνοιγμα πρόσφατης" 12 {Άνοιγμα πρόσφατης μάσκας}
menuText G TreeMaskSave "Αποθήκευση" 3 {Αποθήκευση μάσκας}
menuText G TreeMaskClose "Κλείσιμο" 0 {Κλείσιμο μάσκας}
# ====== TODO To be translated ======
menuText G TreeMaskFillWithLine "Fill with line" 0 {Fill mask with all previous moves}
menuText G TreeMaskFillWithGame "Γέμισμα με Παρτίδα" 11 {Γέμισμα μάσκας με την παρτίδα}
menuText G TreeMaskFillWithBase "Γέμισμα με Βάση" 11 {Γέμισμα μάσκας με όλες τις παρτίδες της Βάσης}
menuText G TreeMaskInfo "Στατιστικά" 0 {Εμφάνιση στατιστικών για την συγκεκριμένη μάσκα}
menuText G TreeMaskDisplay "Εμφάνιση χάρτη" 0 {Εμφάνιση δεδομένων μάσκας σε μορφή δένδρου}
menuText G TreeMaskSearch "Αναζήτηση" 0 {Αναζήτηση στην παρούσα μάσκα}
menuText G TreeSort "Ταξινόμηση" 0
menuText G TreeSortAlpha "Αλφαβητική" 0
menuText G TreeSortECO "Βάσει ECO" 0
menuText G TreeSortFreq "Συχνότητα" 1
menuText G TreeSortScore "Σκορ" 0
menuText G TreeOpt "Ρυθμίσεις" 0
menuText G TreeOptSlowmode "Αργός ρυθμός" 1 {Αργός ρυθμός ενημερώσεων (Μεγάλη ακρίβεια)}
menuText G TreeOptFastmode "Γρήγορος ρυθμός" 0 {Γρήγορος ρυθμός ενημερώσεων (χωρίς μεταβατικές κινήσεις)}
menuText G TreeOptFastAndSlowmode "Συνδυαστικός ρυθμός" 0 {Πρώτα γρήγορος ρυθμός και μετά αργός ρυθμός ενημερώσεων}
menuText G TreeOptStartStop "Αυτόματη ανανέωση" 0 {Διακόπτης Αυτόματης Ανανέωσης του Δένδρου Κινήσεων}
menuText G TreeOptLock "Κλείδωμα" 0 {Διακόπτης Κλειδώματος του Δένδρου Κινήσεων στη τρέχουσα Βάση}
menuText G TreeOptTraining "Εκπαίδευση" 0 {Διακόπτης Εκπαίδευσης Κινήσεων Δένδρου}
# ====== TODO To be translated ======
menuText G TreeOptShort "Short Display" 0 {Don't show ELO information}
menuText G TreeOptAutosave "Αυτομ.Αποθήκευση Cache" 0 \
  {Αυτόματη αποθήκευση της προσωρινής μνήμης με το κλείσιμο του παραθύρου}
# ====== TODO To be translated ======
menuText G TreeOptAutomask "Auto-Load Mask" 0 "Auto-Load most recent mask with a tree open."
# ====== TODO To be translated ======
menuText G TreeOptShowBar "Show Progress Bar" 0 "Show tree progress bar."
# ====== TODO To be translated ======
menuText G TreeOptSortBest "Sort Best Games" 0 "Sort Best Games by ELO."
menuText G TreeHelp "Βοήθεια" 0
menuText G TreeHelpTree "Βοήθεια Δένδρου" 0
menuText G TreeHelpIndex "Ευρετήριο" 0
translate G SaveCache {Αποθήκευση}
translate G Training {Εκπαίδευση}
translate G LockTree {Κλείδωμα}
translate G TreeLocked {κλειδωμένο}
translate G TreeBest {Καλύτερη}
translate G TreeBestGames {Καλύτερες Παρτίδες}
# ====== TODO To be translated ======
translate G TreeAdjust {Adjust Filter}
# Note: the next message is the tree window title row. After editing it,
# check the tree window to make sure it lines up with the actual columns.
translate G TreeTitleRow {    Κίνηση     Συχνότητα  Σκορ Ισοπ Μ-ELO  Αποδ Μ-Έτη ECO}
translate G TreeTitleRowShort {    Κίνηση     Συχνότητα  Σκορ Ισοπ}
translate G TreeTotal {ΣΥΝΟΛΟ   }
translate G DoYouWantToSaveFirst {Να αποθηκευτεί}
translate G AddToMask {Προσθήκη σε Μάσκα}
translate G RemoveFromMask {Αφαίρεση από Μάσκα}
translate G AddThisMoveToMask {Προσθήκη κίνησης σε μάσκα}
translate G SearchMask {Αναζήτηση σε Μάσκα}
translate G DisplayMask {Εμφάνιση Μάσκας}
translate G Nag {Κωδικός Nag}
translate G Marker {Σημάδι}
translate G Include {Συμπερίλαβε}
translate G Exclude {Απέκλεισε}
translate G MainLine {Κύρια Γραμμή}
translate G Bookmark {Σελιδοδείκτης}
translate G NewLine {Νέα γραμμή}
translate G ToBeVerified {Προς εξακρίβωση}
translate G ToTrain {Εκπαιδευτική}
translate G Dubious {Αμφίβολη}
translate G ToRemove {Προς αφαίρεση}
translate G NoMarker {Χωρίς σημάδι}
translate G ColorMarker {Χρώμα}
translate G WhiteMark {Άσπρο}
translate G GreenMark {Πράσινο}
translate G YellowMark {Κίτρινο}
translate G BlueMark {Μπλε}
translate G RedMark {Κόκκινο}
translate G CommentMove {Σχόλιο κίνησης}
translate G CommentPosition {Σχόλιο θέσης}
translate G AddMoveToMaskFirst {Προσθήκη Κίνησης σε μάσκα πρώτα}
translate G OpenAMaskFileFirst {Άνοιγμα αρχείου μάσκας πρώτα}
translate G Positions {Θέσεις}
translate G Moves {Κινήσεις}

# Finder window:
menuText G FinderFile "Αναζήτηση" 0
menuText G FinderFileSubdirs "Αναζήτηση σε Υποκαταλόγους" 0
menuText G FinderFileClose "Κλείσιμο" 0
menuText G FinderSort "Ταξινόμηση με" 0
menuText G FinderSortType "Τύπος" 0
menuText G FinderSortSize "Παρτίδες" 0
menuText G FinderSortMod "Μεταβολή" 0
menuText G FinderSortName "Όνομα" 1
menuText G FinderSortPath "Διαδρομή" 0
menuText G FinderTypes "Τύποι" 0
menuText G FinderTypesScid "Βάσεις Scid" 0
menuText G FinderTypesOld "Βάσεις Scid παλιάς μορφής" 1
menuText G FinderTypesPGN "Αρχεία PGN" 1
menuText G FinderTypesEPD "Αρχεία EPD" 2
menuText G FinderHelp "Βοήθεια" 0
menuText G FinderHelpFinder "Βοήθεια Αναζήτησης" 0
menuText G FinderHelpIndex "Ευρετήριο" 0
translate G FileFinder {Αναζήτηση Βάσης}
translate G FinderDir {Κατάλογος}
translate G FinderDirs {Κατάλογοι}
translate G FinderFiles {Αρχεία}
translate G FinderUpDir {πάνω}
translate G FinderCtxOpen {Άνοιγμα}
translate G FinderCtxBackup {Backup}
translate G FinderCtxCopy {Αντιγραφή}
translate G FinderCtxMove {Μετακίνηση}
translate G FinderCtxDelete {Διαγραφή}

# Player finder:
menuText G PListFile "Ευρετήριο Παικτών" 0
menuText G PListFileUpdate "Ενημέρωση" 0
menuText G PListFileClose "Κλείσιμο" 0
menuText G PListSort "Ταξινόμηση" 0
menuText G PListSortName "Όνομα" 0
menuText G PListSortElo "Elo " 0
menuText G PListSortGames "Παρτίδες" 0
menuText G PListSortOldest "Παλιά" 0
menuText G PListSortNewest "Νέα" 2

# Tournament finder:
menuText G TmtFile "Ευρετήριο Τουρνουά" 0
menuText G TmtFileUpdate "Ενημέρωση" 0
menuText G TmtFileClose "Κλείσιμο" 0
menuText G TmtSort "Ταξινόμηση" 0
menuText G TmtSortDate "Ημερομ." 0
menuText G TmtSortPlayers "Παίκτες" 0
menuText G TmtSortGames "Παρτίδ." 0
menuText G TmtSortElo "Elo" 0
menuText G TmtSortSite "Τόπος" 0
menuText G TmtSortEvent "Διοργάνωση" 1
menuText G TmtSortWinner "Νικητής" 0
translate G TmtLimit "Μέγεθος"
translate G TmtMeanElo "Μ.Ο.Elo  "
translate G TmtNone "Δεν βρέθηκαν σχετικά τουρνουά."

# Graph windows:
menuText G GraphFile "Αρχείο" 0
menuText G GraphFileColor "Αποθήκευση Έγχρωμου PostScript" 3
menuText G GraphFileGrey "Αποθήκευση Γκρίζου PostScript" 4
menuText G GraphFileClose "Κλείσιμο" 0
menuText G GraphOptions "Ρυθμίσεις" 0
menuText G GraphOptionsWhite "Λευκά" 0
menuText G GraphOptionsBlack "Μαύρα" 0
menuText G GraphOptionsBoth "Αμφότεροι" 1
menuText G GraphOptionsPInfo "Παίκτης Πληροφορίες" 0
translate G GraphFilterTitle "Συχνότητα άνα 1000 Παρτίδες"
translate G GraphAbsFilterTitle "Συχνότητα Παρτίδας"
translate G ConfigureFilter "Ρύθμιση X άξονα"
translate G FilterEstimate "Εκτίμηση"
translate G TitleFilterGraph "Scid: Γράφημα φίλτρου"

# Analysis window:
translate G AddVariation {Προσθήκη Βαριάντας}
translate G AddAllVariations {Προσθήκη Όλων των Βαριάντων}
translate G AddMove {Προσθήκη Κίνησης}
translate G Annotate {Σχολιασμός}
translate G ShowAnalysisBoard {Εμφάνιση Σκακιέρας Ανάλυσης}
translate G ShowInfo {Εμφάνιση Πληροφοριών Μηχανής}
translate G FinishGame {Συνέχιση Παρτίδας}
translate G StopEngine {Διακοπή Μηχανής}
translate G StartEngine {Έναρξη Μηχανής}
# ====== TODO To be translated ======
translate G ExcludeMove {Exclude Move}
translate G LockEngine {Κλείδωμα Μηχανής στην παρούσα θέση}
translate G AnalysisCommand {Εντολή Ανάλυσης}
translate G PreviousChoices {Προηγούμενες Επιλογές}
translate G AnnotateTime {Δευτερόλεπτα ανά Κίνηση}
translate G AnnotateWhich {Ποια πλευρά}
translate G AnnotateAll {Κινήσεις αμφοτέρων}
translate G AnnotateAllMoves {Όλες οι κινήσεις}
translate G AnnotateWhite {Μόνο κινήσεις Λευκού}
translate G AnnotateBlack {Μόνο κινήσεις Μαύρου}
translate G AnnotateNotBest {Όταν η κίνηση δεν είναι η Καλύτερη}
translate G AnnotateBlundersOnly {Όταν η κίνηση είναι Σοβαρό Σφάλμα}
# ====== TODO To be translated ======
translate G BlundersNotBest {Blunders/Not Best}
translate G AnnotateBlundersOnlyScoreChange {Η Ανάλυση σχολιάζει ως Σοβαρό Σφάλμα, με διαφορά υλικού από/σε: }
translate G AnnotateTitle {Ρυθμίσεις Σχολιαστή}
translate G BlundersThreshold {Threshold}
# ====== TODO To be translated ======
translate G ScoreFormat {Score format}
# ====== TODO To be translated ======
translate G CutOff {Cut Off}
translate G LowPriority {Χαμηλή Προτεραιότητα CPU}
# ====== TODO To be translated ======
translate G LogEngines {Log Size}
# ====== TODO To be translated ======
translate G LogName {Add Name}
# ====== TODO To be translated ======
translate G MaxPly {Max Ply}
translate G ClickHereToSeeMoves {Πατήστε για εμφάνιση κινήσεων}
translate G ConfigureInformant {Ρύθμιση Τιμών Πληροφοριών}
translate G Informant!? {Ενδιαφέρουσα Κίνηση}
translate G Informant? {Λάθος Κίνηση}
translate G Informant?? {Σοβαρό Σφάλμα}
translate G Informant?! {Αμφίβολη Κίνηση}
translate G Informant+= {Μικρό προβάδισμα Λευκού}
translate G Informant+/- {Μέτριο προβάδισμα Λευκού}
translate G Informant+- {Αποφασιστικό προβάδισμα Λευκού}
translate G Informant++- {Η Παρτίδα έχει κερδηθεί}

# Book window
translate G Book {Ανοίγματα}

# Analysis Engine open dialog:
translate G EngineList {Μηχανές Ανάλυσης}
# ====== TODO To be translated ======
translate G EngineKey {Key}
# ====== TODO To be translated ======
translate G EngineType {Type}
translate G EngineName {Όνομα}
translate G EngineCmd {Εντολή}
translate G EngineArgs {Παράμετροι}
translate G EngineDir {Κατάλογος}
translate G EngineElo {Elo}
translate G EngineTime {Ημερομηνία}
translate G EngineNew {Νέα}
translate G EngineEdit {Επεξεργασία}
translate G EngineRequired {Τα έντονα πεδία είναι υποχρεωτικά; τα υπόλοιπα προαιρετικά}

# Stats window menus:
menuText G StatsFile "Στατιστικά" 0
menuText G StatsFilePrint "Εκτύπωση σε αρχείο" 0
menuText G StatsFileClose "Κλείσιμο" 0
menuText G StatsOpt "Ρυθμίσεις" 0

# PGN window menus:
menuText G PgnFile "Pgn" 0
menuText G PgnFileCopy "Αντιγραφή σε Clipboard" 1
menuText G PgnFilePrint "Αποθήκευση ως" 3
menuText G PgnFileClose "Κλείσιμο" 0
menuText G PgnOpt "Ρυθμίσεις" 0
menuText G PgnOptColor "Έγχρωμη εμφάνιση" 0
menuText G PgnOptShort "Σύντομη Κεφαλίδα" 10
menuText G PgnOptSymbols "Συμβολικός Σχολιασμός" 1
menuText G PgnOptIndentC "Στοίχιση Σχολίων" 10
menuText G PgnOptIndentV "Στοίχιση Βαριάντων" 9
menuText G PgnOptColumn "Μορφή Στήλης" 0
menuText G PgnOptSpace "Κενό μετά από αριθμό Κίνησης" 3
menuText G PgnOptStripMarks "Διαγραφή Τετραγώνων/Τόξων" 0
menuText G PgnOptChess "Κομμάτια" 4
menuText G PgnOptScrollbar "Μπάρα κύλισης" 1
menuText G PgnOptBoldMainLine "Κύρια Γραμμή Τονισμένη" 1
menuText G PgnColor "Χρώματα" 0
menuText G PgnColorHeader "Κεφαλίδα" 0
menuText G PgnColorAnno "Σχολιασμοί" 0
menuText G PgnColorComments "Σχόλια" 2
menuText G PgnColorVars "Βαριάντες" 0
menuText G PgnColorBackground "Φόντο" 0
menuText G PgnColorMain "Κύρια γραμμή" 0
menuText G PgnColorCurrent "Τρέχουσα κίνηση" 1
menuText G PgnColorNextMove "Επόμενη κίνηση" 0
menuText G PgnHelp "Βοήθεια" 0
menuText G PgnHelpPgn "PGN Βοήθεια" 0
menuText G PgnHelpIndex "Ευρετήριο" 0
translate G PgnWindowTitle {PGN: Παρτίδα %u}

# Crosstable window menus:
menuText G CrosstabFile "Κατάταξη(Crosstable)" 0
menuText G CrosstabFileText "Αποθήκευση ως Κείμενο" 3
menuText G CrosstabFileHtml "Αποθήκευση ως HTML" 14
menuText G CrosstabFileLaTeX "Αποθήκευση ως LaTex" 14
menuText G CrosstabFileClose "Κλείσιμο" 0
menuText G CrosstabEdit "Επεξεργασία" 0
menuText G CrosstabEditEvent "Διοργάνωση" 0
menuText G CrosstabEditSite "Τόπος" 0
menuText G CrosstabEditDate "Ημερομηνία" 0
menuText G CrosstabOpt "Ρυθμίσεις" 0
menuText G CrosstabOptColorPlain "Απλό Κείμενο" 0
menuText G CrosstabOptColorHyper "Hypertext" 0
# ====== TODO To be translated ======
menuText G CrosstabOptTieWin "Tie-Break by wins" 1
# ====== TODO To be translated ======
menuText G CrosstabOptTieHead "Tie-Break by head-head" 1
menuText G CrosstabOptThreeWin "3 Πόντοι για Νίκη" 0
menuText G CrosstabOptAges "Ηλικία σε έτη" 0
menuText G CrosstabOptNats "Εθνικότητα" 1
menuText G CrosstabOptTallies "Νίκη/Χαμ/Ισοπ" 0
menuText G CrosstabOptRatings "Elo" 0
menuText G CrosstabOptTitles "Τίτλοι" 0
menuText G CrosstabOptBreaks "Σκορ Ισοπαλίας" 1
menuText G CrosstabOptDeleted "Συμπερίληψη Διαγραμμένων" 9
menuText G CrosstabOptColors "Χρώματα (Μόνο σε Σουηδικό)" 0
# ====== TODO To be translated ======
menuText G CrosstabOptColorRows "Color Rows" 0
menuText G CrosstabOptColumnNumbers "Αριθμ.Στήλες (Μόνο σε Όλοι-εναντίον-Όλων)" 2
menuText G CrosstabOptGroup "Σκορ Ομάδας" 7
menuText G CrosstabSort "Ταξινόμηση με" 0
menuText G CrosstabSortName "Όνομα" 0
menuText G CrosstabSortRating "Elo" 0
menuText G CrosstabSortScore "Σκορ" 0
menuText G CrosstabSortCountry "Χώρα" 0
# todo
menuText G CrosstabType "Format" 0
menuText G CrosstabTypeAll "Όλοι-εναντίον-Όλων" 0
menuText G CrosstabTypeSwiss "Σουηδικό" 0
menuText G CrosstabTypeKnockout "Γύροι" 0
menuText G CrosstabTypeAuto "Αυτόματα" 1
menuText G CrosstabHelp "Βοήθεια" 0
menuText G CrosstabHelpCross "Βοήθεια Crosstable" 0
menuText G CrosstabHelpIndex "Ευρετήριο Βοήθειας" 0
translate G SetFilter {Φίλτρο}
translate G AddToFilter {Προσθήκη σε Φίλτρο}
translate G Swiss {Σουηδικό}
translate G Category {Κατηγορία}

# Opening report window menus:
menuText G OprepFile "Αναφορά" 0
menuText G OprepFileText "Εκτύπωση σε Κείμενο" 12
menuText G OprepFileHtml "Εκτύπωση σε HTML" 12
menuText G OprepFileLaTeX "Εκτύπωση σε LaTeX" 12
menuText G OprepFileOptions "Ρυθμίσεις" 0
menuText G OprepFileClose "Κλείσιμο Αναφοράς" 0
menuText G OprepFavorites "Αγαπημένα" 1
menuText G OprepFavoritesAdd "Προσθήκη Αναφοράς" 0
menuText G OprepFavoritesEdit "Επεξεργασίας Αγαπημένων" 0
menuText G OprepFavoritesGenerate "Δημιουργία Αναφορών" 0
menuText G OprepHelp "Βοήθεια" 0
menuText G OprepHelpReport "Βοήθειας Αναφοράς" 0
menuText G OprepHelpIndex "Ευρετήριο Βοήθειας" 0

# Header search:
translate G HeaderSearch {Γενική Αναζήτηση}
translate G EndSideToMove {Ποιος παίζει την τελευταία κίνηση}
translate G GamesWithNoECO {Παρτίδες χωρίς ECO;}
translate G GameLength {Μήκος Παρτίδας}
translate G FindGamesWith {Εύρεση παρτίδων με σημαίες}
translate G StdStart {Μη τυπική έναρξη}
translate G Promotions {Προαγωγές}
# ====== TODO To be translated ======
translate G UnderPromo {Under Prom.}
translate G Comments {Σχόλια}
translate G Variations {Βαριάντες}
translate G Annotations {Σχολιασμοί}
translate G DeleteFlag {Σημαία Διαγραφής}
translate G WhiteOpFlag {Άνοιγμα Λευκού}
translate G BlackOpFlag {Άνοιγμα Μαύρου}
translate G MiddlegameFlag {Μέση Παρτίδας}
translate G EndgameFlag {Φινάλε}
translate G NoveltyFlag {Καινοτομία}
translate G PawnFlag {Δομή Πιονιών}
translate G TacticsFlag {Τακτική}
translate G QsideFlag {Σε πλευρά Βασίλισσας}
translate G KsideFlag {Σε πλευρά Βασιλιά}
translate G BrilliancyFlag {Εξαιρετική}
translate G BlunderFlag {Σοβαρό Σφάλμα}
translate G UserFlag {Χρήστη}
translate G PgnContains {PGN με σχόλια}

# Game list window:
translate G GlistNumber {Αριθμός}
translate G GlistWhite {Λευκός}
translate G GlistBlack {Μαύρος}
translate G GlistWElo {Λ-Elo}
translate G GlistBElo {Μ-Elo}
translate G GlistEvent {Διοργάνωση}
translate G GlistSite {Τόπος}
translate G GlistRound {Γύρος}
translate G GlistDate {Ημέρα}
translate G GlistYear {Έτος}
translate G GlistEventDate {ΗμέραΔιοργ}
translate G GlistResult {Αποτέλεσμα}
translate G GlistLength {Μήκος}
translate G GlistCountry {Χώρα}
translate G GlistECO {ECO}
translate G GlistOpening {Άνοιγμα}
translate G GlistEndMaterial {Τελικό_Υλικό}
translate G GlistDeleted {Διαγραμμένη}
translate G GlistFlags {Σημαίες}
translate G GlistVariations {Βαριάντες}
translate G GlistComments {Σχόλια}
translate G GlistAnnos {Σχολιασμοί}
translate G GlistStart {Έναρξη}
translate G GlistGameNumber {Αριθμός Παρτίδας}
translate G GlistFindText {Αναζήτηση}
translate G GlistMoveField {Κίνηση}
translate G GlistEditField {Ρύθμιση}
translate G GlistAddField {Προσθήκη}
translate G GlistDeleteField {Αφαίρεση}
translate G GlistColor {Χρώμα}
# ====== TODO To be translated ======
translate G GlistSort {Sort database}

# menu shown with right mouse button down on game list. 
translate G GlistRemoveThisGameFromFilter  {Αφαίρεση}
translate G GlistRemoveGameAndAboveFromFilter  {Αφαίρεση παρτίδας (και όλες οι παραπάνω)}
translate G GlistRemoveGameAndBelowFromFilter  {Aφαίρεση παρτίδας (και όλες οι παρακάτω)}
translate G GlistDeleteGame {Διαγραφή ή Μη Παρτίδας} 
translate G GlistDeleteAllGames {Διαγραφή φιλτραρισμένων} 
translate G GlistUndeleteAllGames {Μη Διαγραφή φιλτραρισμένων} 
# ====== TODO To be translated ======
translate G GlistAlignL {Align left}
# ====== TODO To be translated ======
translate G GlistAlignR {Align right}
# ====== TODO To be translated ======
translate G GlistAlignC {Align center}

# Maintenance window:
translate G DatabaseName {Όνομα Βάσης:}
translate G TypeIcon {Τύπος Εικονιδίου}
translate G NumOfGames {Παρτίδες:}
translate G NumDeletedGames {Διαγραμμένες παρτίδες:}
translate G NumFilterGames {Φιλτραρισμένες παρτίδες:}
translate G YearRange {Εύρος ετών:}
translate G RatingRange {Εύρος Elo:}
translate G Description {Περιγραφή}
translate G Flag {Σημαία}
translate G CustomFlags {Προσαρμοσμένες σημαίες}
translate G DeleteCurrent {Διαγραφή Τρέχουσας}
translate G DeleteFilter {Διαγραφή Φιλτραρισμένων}
translate G DeleteAll {Διαγραφή Όλων}
translate G UndeleteCurrent {Μη Διαγραφή Τρέχουσας}
translate G UndeleteFilter {Μη Διαγραφή Φιλτραρισμένων}
translate G UndeleteAll {Μη Διαγραφή Όλων}
translate G DeleteTwins {Διαγραφή Διπλών}
translate G MarkCurrent {Επισήμανση Τρέχουσας}
translate G MarkFilter {Επισήμανση Φιλτραρισμένων}
translate G MarkAll {Επισήμανση Όλων}
translate G UnmarkCurrent {Μη Επισήμανση Τρέχουσας}
translate G UnmarkFilter {Μη Επισήμανση Φιλτραρισμένων}
translate G UnmarkAll {Μη Επισήμανση Όλων}
translate G Spellchecking {Συλλαβισμός}
# ====== TODO To be translated ======
translate G MakeCorrections {Make Corrections}
# ====== TODO To be translated ======
translate G Ambiguous {Ambiguous}
# ====== TODO To be translated ======
translate G Surnames {Surnames}
translate G Players {Παικτών}
translate G Events {Διοργανώσεων}
translate G Sites {Τόπων}
translate G Rounds {Γύρων}
translate G DatabaseOps {Ενέργειες Βάσης}
translate G ReclassifyGames {Προσθήκη ECO σε παρτίδες}
translate G CompactDatabase {Συμπίεση Βάσης}
translate G SortDatabase {Ταξινόμηση Βάσης}
translate G AddEloRatings {Προσθήκη ELO σε παρτίδες}
translate G AutoloadGame {Αυτόματη Φόρτωση Παρτίδας}
translate G StripTags {Αφαίρεση Ετικετών PGN}
translate G StripTag {Αφαίρεση Ετικέτας}
translate G CheckGames {Έλεγχος παρτίδων}
translate G Cleaner {Καθαριστής}
translate G CleanerHelp {
Ο Καθαριστής του Scid θα πραγματοποιήσει όλες τις ενέργειες συντήρησης που θα επιλέξετε παρακάτω, στη τρέχουσα Βάση.

Οι τρέχουσες ρυθμίσεις στο χαρακτηρισμό ECO και στη διαγραφή διπλών παρτίδων θα εφαρμοστούν μόνο αν τις επιλέξετε.
}
translate G CleanerConfirm {
Αν η διαδικασία συντήρησης ξεκινήσει, δεν μπορεί να διακοπεί!

Μπορεί να χρειαστεί μεγάλος χρόνος για την ολοκλήρωσή της σε μεγάλες Βάσεις Δεδομένων, σε συνάρτηση πάντα με τις σχετικές επιλογές που πραγματοποιήσατε προηγουμένως και τις ρυθμίσεις τους.

Είστε σίγουροι ότι θέλετε να εφαρμόσετε τις επιλεγμένες εργασίες;}

# Twinchecker
translate G TwinCheckUndelete {για εναλλαγή)}
translate G TwinCheckprevPair {Προηγούμενο ζεύγος}
translate G TwinChecknextPair {Επόμενο ζεύγος}
translate G TwinChecker {Έλεγχος Διπλών Παρτίδων}
translate G TwinCheckTournament {Παρτίδες στο τουρνουά:}
translate G TwinCheckNoTwin {Χωρίς Διπλές  }
translate G TwinCheckNoTwinfound {Δεν βρέθηκε όμοια παρτίδα.\nΓια να εμφανιστούν οι διπλές παρτίδες σε αυτό το παράθυρο, πρώτα πρέπει να χρησιμοποιήσετε την "Διαγραφή Διπλών". }
translate G TwinCheckTag {Αντιγραφή Ετικετών...}
translate G TwinCheckFound1 {Το Scid εντόπισε $result διπλές παρτίδες}
translate G TwinCheckFound2 { και έθεσε την σημαία προς διαγραφή τους}
translate G TwinCheckNoDelete {Δεν υπάρχουν παρτίδες στην Βάση για διαγραφή.}
# bug here... can't use \n\n
translate G TwinCriteria1 {Προσοχή!! Αδύναμα Κριτήρια\n}
translate G TwinCriteria2 {Έχετε επιλέξει "Όχι" για "Ίδιες Κινήσεις", το οποίο είναι λάθος.\n
Να συνεχίσω;}
translate G TwinCriteria3 {Πρέπει να επιλέξετε "Ναι" σε δύο τουλάχιστον από τις επιλογές "Ίδιος Τόπος", "Ίδιος Γύρος", και "Ίδιο Έτος".\n
Να συνεχίσω;}
translate G TwinCriteriaConfirm {Scid: Επιβεβαιώση επιλογών Διπλών Παρτίδων}
translate G TwinChangeTag "Αλλαγή των επόμενων ετικετών της παρτίδας:\n\n"
translate G AllocRatingDescription "Αυτή η ενέργεια θα χρησιμοποιήσει το τρέχον αρχείο συλλαβισμού για να προσθέσει τα ELO στις παρτίδες της Βάσης. Όταν κάποια παρτίδα δεν έχει το Elo του παίκτη, αλλά για την ημέρα που παίκτηκε η παρτίδα υπάρχει σχετικό ELO στο αρχείο συλλαβισμού, αυτό το ELO θα προστεθεί στην παρτίδα."
translate G RatingOverride "Να διορθώσω υπάρχοντα μη μηδενικά ELO;"
translate G AddRatings "Προσθήκη ELO σε:"
translate G AddedRatings {Το Scid πρόσθεσε $r ELO σε $g παρτίδες.}

#Bookmark editor
translate G NewSubmenu "Προσθήκη Μενού"

# Comment editor:
translate G AnnotationSymbols  {Σχολιασμοί}
translate G Comment {Σχόλια}
translate G InsertMark {Σημάδια}
translate G InsertMarkHelp {
Προσθήκη/αφαίρεση σημαδιού: Διαλέξτε χρώμα, τύπο, τετράγωνο.
Προσθήκη/αφαίρεση τόξου: Δεξί-κλικ σε δύο τετράγωνα.
}

# Nag buttons in comment editor:
translate G GoodMove {Καλή κίνηση}
translate G PoorMove {Κακή κίνηση}
translate G ExcellentMove {Εξαιρετική κίνηση}
translate G Blunder {Σοβαρό Σφάλμα}
translate G InterestingMove {Ενδιαφέρουσα κίνηση}
translate G DubiousMove {Αμφίβολη κίνηση}
translate G WhiteDecisiveAdvantage {Αποφασιστικό προβάδισμα Λευκού}
translate G BlackDecisiveAdvantage {Αποφασιστικό προβάδισμα Μαύρου}
translate G WhiteClearAdvantage {Καθαρό προβάδισμα Λευκού}
translate G BlackClearAdvantage {Καθαρό προβάδισμα Μαύρου}
translate G WhiteSlightAdvantage {Μικρό προβάδισμα Λευκού}
translate G BlackSlightAdvantage {Μικρό προβάδισμα Μαύρου}
translate G Equality {Ισότητα}
translate G Unclear {Αβέβαιο}
translate G Diagram {Διάγραμμα}

# Board search:
translate G BoardSearch {Αναζήτηση Θέσης}
translate G FilterOperation {Ρυθμίσεις Φίλτρου}
translate G FilterAnd {Περιορισμός Φίλτρου (KAI)}
translate G FilterOr {Προσθήκη στο Φίλτρο (Ή)}
translate G FilterIgnore {Μηδενισμός Φίλτρου}
translate G SearchType {Τύπος Αναζήτησης}
translate G SearchBoardExact {Ακριβώς η ίδια θέση (όλα τα κομμάτια στα ίδια τετράγωνα)}
translate G SearchBoardPawns {Πιόνια (ίδιο υλικό, όλα τα πιόνια στα ίδια τετράγωνα)}
translate G SearchBoardFiles {Στήλες (ίδιο υλικό, όλα τα πιόνια στις ίδιες στήλες)}
translate G SearchBoardAny {Οποιαδήποτε (ίδιο υλικό, πιόνια και κομμάτια οπουδήποτε)}
translate G SearchInRefDatabase { Αναζήτηση στη Βάση }
translate G LookInVars {Αναζήτηση σε βαριάντες}

# Material search:
translate G MaterialSearch {Αναζήτηση Υλικού}
translate G Material {Υλικό}
translate G Patterns {Σχηματισμοί}
translate G Zero {Μηδενισμός}
translate G Any {Όλα}
translate G CurrentBoard {Τρέχουσα Θέση}
translate G CommonEndings {Συχνά Φινάλε}
translate G CommonPatterns {Συχνοί Σχηματισμοί}
translate G MaterialDiff {Διαφορά Υλικού}
translate G squares {τετράγωνα}
translate G SameColor {Ίδιο χρώμα}
translate G OppColor {Αντίθετο χρώμα}
translate G Either {Οποιουδήποτε}
translate G MoveNumberRange {Εύρος αριθμού κίνησης}
translate G MatchForAtLeast {Ομοιότητα τουλάχιστον}
translate G HalfMoves {Μισών κινήσεων}

# Common endings in material search:
translate G EndingPawns {Πιονιών}
translate G EndingRookVsPawns {Πύργος εναντίον Πιόνι(α)}
translate G EndingRookPawnVsRook {Πύργος και 1 πιόνι εναντίον Πύργου}
translate G EndingRookPawnsVsRook {Πύργος και Πιόνι(α) εναντίον Πύργου}
translate G EndingRooks {Πύργος εναντίον Πύργου}
translate G EndingRooksPassedA {Πύργος εναντίον Πύργου με ελεύθερο το α-πιόνι}
translate G EndingRooksDouble {Διπλών Πύργων}
translate G EndingBishops {Αξιωματικός εναντίον Αξιωματικού}
translate G EndingBishopVsKnight {Αξιωματικός εναντίον Ίππου}
translate G EndingKnights {Ίππος εναντίον Ίππου}
translate G EndingQueens {Βασίλισσα εναντίον Βασίλισσας}
translate G EndingQueenPawnVsQueen {Βασίλισσα και 1 πιόνι εναντίον Βασίλισσας}
translate G BishopPairVsKnightPair {Δύο Αξιωματικοί εναντίον Δύο Ίππων στο Μέσον}

# Common patterns in material search:
translate G PatternWhiteIQP {Λευκό IQP}
translate G PatternWhiteIQPBreakE6 {Λευκό IQP: d4-d5 break vs. e6}
translate G PatternWhiteIQPBreakC6 {Λευκό IQP: d4-d5 break vs. c6}
translate G PatternBlackIQP {Μαύρο IQP}
translate G PatternWhiteBlackIQP {Λευκό IQP vs. Μαύρο IQP}
translate G PatternCoupleC3D4 {Λευκό c3+d4 Απομονωμένο Ζεύγος πιονιών}
translate G PatternHangingC5D5 {Μαύρα Απειλούμενα πιόνια στα c5 και d5}
translate G PatternMaroczy {Κέντρο Maroczy (με πιόνια στα c4 και e4)}
translate G PatternRookSacC3 {Θυσία Πύργου στο c3}
translate G PatternKc1Kg8 {O-O-O vs. O-O (Kc1 vs. Kg8)}
translate G PatternKg1Kc8 {O-O vs. O-O-O (Kg1 vs. Kc8)}
translate G PatternLightFian {Φιανκέτο στα Λευκο-τετράγωνα (Αξιωματικός στο g2 vs. Αξιωματικού στο b7)}
translate G PatternDarkFian {Φιανκέτο στα Σκουρο-τετράγωνα (Αξιωματικός στο b2 vs. Αξιωματικού στο g7)}
translate G PatternFourFian {Τέσσερα Φιανκέτα (Αξιωματικοί στα b2,g2,b7,g7)}

# Game saving:
translate G Today {Σήμερα}
translate G ClassifyGame {Χαρακτηρισμός παρτίδας}

# Setup position:
translate G EmptyBoard {Άδεια σκακιέρα}
translate G InitialBoard {Αρχική σκακιέρα}
translate G SideToMove {Πλευρά που παίζει}
translate G MoveNumber {Αριθμός κίνησης}
translate G Castling {Ροκέ}
translate G EnPassantFile {En Passant στήλη}
translate G ClearFen {Καθαρισμός FEN}
translate G PasteFen {Επικόλληση FEN}

translate G SaveAndContinue {Αποθήκευση και συνέχεια}
translate G DiscardChangesAndContinue {Αναίρεση Αλλαγών}
translate G GoBack {Επιστροφή}

# Replace move dialog:
translate G ReplaceMove {Αντικατάσταση Κίνησης}
translate G AddNewVar {Προσθήκη Βαριάντας}
translate G NewMainLine {Νέα Κύρια Γραμμή}
translate G ReplaceMoveMessage {Η Κίνηση Υπάρχει.

Παρακαλώ Επιλέξτε.
Αντικατάσταση της Κίνησης θα διαγράψει όλες τις επόμενες κινήσεις..}

# Make database read-only dialog:
translate G ReadOnlyDialog {Επιθυμείτε να ενεργοποιήσετε την προστασία εγγραφής για την συγκεκριμένη Βάση (read-only);

(Για να την απενεργοποιήσετε, απλά κλείστε την και ανοίξτε την ξανά.)}

# Exit dialog:
translate G ExitDialog {Επιθυμείτε να κλείσετε το ScidvsPC;}
# ====== TODO To be translated ======
translate G ClearGameDialog {This game has been altered.\nDo you wish to save it?}
translate G ExitUnsaved {Οι ακόλουθες Βάσεις περιέχουν μη αποθηκευμένες παρτίδες. Αν κλείσετε την εφαρμογή τώρα, οι αλλαγές θα χαθούν.}

# Import window:
translate G PasteCurrentGame {Επικόλληση Παρτίδας}
translate G ImportHelp1 {Εισάγετε ή επικολλήστε PGN κείμενο στο παραπάνω πλαίσιο.}
translate G ImportHelp2 {Οποιαδήποτε σφάλματα κατά την εισαγωγή της παρτίδας θα εμφανιστούν εδώ.}
translate G OverwriteExistingMoves {Αντικατάσταση υφιστάμενων κινήσεων;}

# ECO Browser:
translate G ECOAllSections {Όλες οι ενότητες ECO}
translate G ECOSection {Ενότητα ECO}
translate G ECOSummary {Συγκεντρωτικά για}
translate G ECOFrequency {Συχνότητα υποκατηγοριών για}

# Opening Report:
translate G OprepTitle {Αναφορά Ανοίγματος}
translate G OprepReport {Αναφορά}
translate G OprepGenerated {Δημιουργήθηκε από το}
translate G OprepStatsHist {Στατιστικά και Ιστορικό}
translate G OprepStats {Στατιστικά}
translate G OprepStatAll {Παρτίδες Αναφοράς}
translate G OprepStatBoth {Με αξιολόγηση Elo}
translate G OprepStatSince {Από το}
translate G OprepOldest {Παλαιότερες παρτίδες}
translate G OprepNewest {Πρόσφατες παρτίδες}
translate G OprepPopular {Συχνότητα Τρέχουσα}
translate G OprepFreqAll {Συχνότητα σε όλα τα έτη: }
translate G OprepFreq1   {Το τελευταίο έτος:       }
translate G OprepFreq5   {Τα τελευταία 5 έτη:      }
translate G OprepFreq10  {Τα τελευταία 10 έτη:     }
translate G OprepEvery {Μία φορά κάθε %u παρτίδες}
translate G OprepUp {πάνω %u%s για όλα τα έτη}
translate G OprepDown {κάτω %u%s για όλα τα έτη}
translate G OprepSame {χωρίς διαφορά για όλα τα έτη}
translate G OprepMostFrequent {Συχνότεροι παίκτες}
translate G OprepMostFrequentOpponents {Συχνότεροι αντίπαλοι}
translate G OprepRatingsPerf {Βαθμολογία Elo και Απόδοση}
translate G OprepAvgPerf {Μέσος όρος Βαθμολογίας Elo και Απόδοσης}
translate G OprepWRating {Βαθμολογία Elo Λευκού }
translate G OprepBRating {Βαθμολογία Elo Μαύρου}
translate G OprepWPerf {Απόδοση Λευκού }
translate G OprepBPerf {Απόδοση Μαύρου}
translate G OprepHighRating {Παρτίδες με τον υψηλότερο μέσο όρο Βαθμολογίας Elo}
translate G OprepTrends {Τάσεις Αποτελεσμάτος}
translate G OprepResults {Μήκος και συχνότητα αποτελέσματος}
translate G OprepLength {Μήκος Παρτίδας}
translate G OprepFrequency {Συχνότητα}
translate G OprepWWins {Νίκες Λευκών: }
translate G OprepBWins {Νίκες Μαύρων: }
translate G OprepDraws {Ισοπαλίες:      }
translate G OprepWholeDB {ολόκληρη η Βάση}
translate G OprepShortest {Συντομότερες νίκες}
translate G OprepMovesThemes {Κινήσεις και Θέματα}
translate G OprepMoveOrders {Σειρές κινήσεων που καταλήγουν στην αναφερόμενη θέση}
translate G OprepMoveOrdersOne \
  {Βρέθηκε μόνο μία σειρά κινήσεων που καταλήγει στη θέση αυτή:}
translate G OprepMoveOrdersAll \
  {Βρέθηκαν %u σειρές κινήσεων που καταλήγουν στη θέση αυτή:}
translate G OprepMoveOrdersMany \
  {Βρέθηκαν %u σειρές κινήσεων που καταλήγουν στη θέση αυτή. Οι κορυφαίες %u είναι:}
translate G OprepMovesFrom {Κινήσεις για την αναφερόμενη θέση}
translate G OprepMostFrequentEcoCodes {Οι συχνότεροι κωδικοί ECO}
translate G OprepThemes {Θέματα θέσης}
translate G OprepThemeDescription {Συχνότητα θεμάτων για τις πρώτες %u κινήσεις κάθε παρτίδας}
translate G OprepThemeSameCastling {Same-side castling}
translate G OprepThemeOppCastling {Opposite castling}
translate G OprepThemeNoCastling {Both Kings uncastled}
translate G OprepThemeKPawnStorm {Kingside pawn storm}
translate G OprepThemeQueenswap {Queens exchanged}
translate G OprepThemeWIQP {White Isolated Queen Pawn}
translate G OprepThemeBIQP {Black Isolated Queen Pawn}
translate G OprepThemeWP567 {White Pawn on 5/6/7th rank}
translate G OprepThemeBP234 {Black Pawn on 2/3/4th rank}
translate G OprepThemeOpenCDE {Open c/d/e file}
translate G OprepTheme1BishopPair {Only one side has Bishop pair}
translate G OprepEndgames {Φινάλε}
translate G OprepReportGames {Report games}
translate G OprepAllGames {All games}
translate G OprepEndClass {Υλικό στο τέλος κάθε παρτίδας}
translate G OprepTheoryTable {Πίνακας Θεωρίας}
translate G OprepTableComment {Δημιουργήθηκε από τις %u παρτίδες με την υψηλότερη Βαθμολογία Elo.}
translate G OprepExtraMoves {Συμπληρωματικές κινήσεις για τον Πίνακα Θεωρίας}
translate G OprepMaxGames {Μέγιστος αριθμός παρτίδων για τον Πίνακα Θεωρίας}
translate G OprepViewHTML {Προβολή HTML}
translate G OprepViewLaTeX {Προβολή LaTeX}

# Player Report:
translate G PReportTitle {Αναφορά Παίκτη}
translate G PReportColorWhite {με τα Λευκά κομμάτια}
translate G PReportColorBlack {με τα Μαύρα κομμάτια}
# ====== TODO To be translated ======
translate G PReportBeginning {Beginning with}
translate G PReportMoves {μετά από %s}
translate G PReportOpenings {Ανοίγματα}
translate G PReportClipbase {Άδειασμα clipbase και αντιγραφή παρτίδων που ταιριάζουν}

# Piece Tracker window:
translate G TrackerSelectSingle {Με αριστερό κλικ επιλογή κομματιού.}
translate G TrackerSelectPair {Με αριστερό κλικ επιλογή κομματιού, με δεξί κλικ επιλογή του όμοιού του.}
translate G TrackerSelectPawn {Με αριστερό κλικ επιλογή πιονιού, με δεξί κλικ επιλογή και των (8) πιονιών.}
translate G TrackerStat {Στατιστικά}
translate G TrackerGames {% παρτίδων με κίνηση στο τετράγωνο}
translate G TrackerTime {% χρόνου σε κάθε τετράγωνο}
translate G TrackerMoves {Κινήσεις}
translate G TrackerMovesStart {Εισάγετε τον αριθμό κίνησης όπου θα ξεκινήσει η παρακολούθηση.}
translate G TrackerMovesStop {Εισάγετε τον αριθμό κίνησης όπου θα σταματήσει η παρακολούθηση.}

# Game selection dialogs:
translate G SelectAllGames {Όλες οι Παρτίδες}
translate G SelectFilterGames {Μόνο Παρτίδες Φίλτρου}
translate G SelectTournamentGames {Μόνο Παρόντος Τουρνουά}
translate G SelectOlderGames {Μόνο Παλιές Παρτίδες}

# Delete Twins window:
translate G TwinsNote {Για να επισημανθεί ως διπλή, οι παρτίδες πρέπει να έχουν τους ίδιους Παίκτες και άλλα κριτήρια, όπως τα παρακάτω. Πριν το εντοπισμό καλό είναι να εκτελείται πρώτα ο Συλλαβισμός Ονομάτων. }
translate G TwinsCriteria {Κριτήρια Διπλής Παρτίδας}
translate G TwinsWhich {Εξέταση Όλων/Φίλτρου}
translate G TwinsColors {Παίκτης με ίδιο χρώμα}
translate G TwinsEvent {Ίδια Διοργάνωση}
translate G TwinsSite {Ίδιος Τόπος}
translate G TwinsRound {Ίδιος Γύρος}
translate G TwinsYear {Ίδιο Έτος}
translate G TwinsMonth {Ίδιος Μήνας}
translate G TwinsDay {Ίδια Ημέρα}
translate G TwinsResult {Ίδιο Αποτέλεσμα}
translate G TwinsECO {Ίδιος κωδικός ECO}
translate G TwinsMoves {Ίδιες Κινήσεις}
translate G TwinsPlayers {Ονόματα Παικτών}
translate G TwinsPlayersExact {Ακριβές Ταίριασμα}
translate G TwinsPlayersPrefix {Μόνο τα 4 Πρώτα Γράμματα}
translate G TwinsWhen {Όταν διαγράφονται οι Διπλές Παρτίδες}
translate G TwinsSkipShort {Αγνόηση Παρτίδων με λιγότερες από 5 κινήσεις}
translate G TwinsUndelete {Πρώτα αναίρεση όλων των Διαγραμμένων}
translate G TwinsSetFilter {Όρισμός φίλτρου στις υπό διαγραφή Διπλές Παρτίδες}
translate G TwinsComments {Πάντοτε διατήρηση παρτίδων με σχόλια}
translate G TwinsVars {Πάντοτε διατήρηση παρτίδων με βαριάντες}
translate G TwinsDeleteWhich {Διαγραφή ποιας παρτίδας;}
translate G TwinsDeleteShorter {Συντομότερη παρτίδα}
translate G TwinsDeleteOlder {Με μικρότερο αριθμό παρτίδας}
translate G TwinsDeleteNewer {Με μεγαλύτερο αριθμό παρτίδας}
translate G TwinsDelete {Διαγραφή Παρτίδων}

# Name editor window:
translate G NameEditType {Τύπος Ονόματος προς Επεξεργασία}
translate G NameEditSelect {Παρτίδες προς Επεξεργασία}
translate G NameEditReplace {Αντικατάσταση}
translate G NameEditWith {Με}
translate G NameEditMatches {Ομοιότητες: Πατήστε Ctrl+1 έως Ctrl+9 για επιλογή}

# Check games window:
translate G CheckGamesWhich {Έλεγχος Παρτίδων}
translate G CheckAll {Όλες οι παρτίδες}
translate G CheckSelectFilterGames {Παρτίδες Φίλτρου}

# Classify window:
translate G Classify {Κατάταξη}
translate G ClassifyWhich {Κατάταξη ECO}
translate G ClassifyAll {Όλες οι παρτίδες (αντικατάσταση παλιών κωδικών ECO)}
translate G ClassifyYear {Όλες οι παρτίδες του τελευταίου χρόνου}
translate G ClassifyMonth {Όλες οι παρτίδες του τελευταίου μήνα}
translate G ClassifyNew {Μόνο παρτίδες χωρίς κωδικό ECO}
translate G ClassifyCodes {Χρήση Κωδικών ECO}
translate G ClassifyBasic {Μόνο Βασικοί κωδικοί ("B12", ...)}
translate G ClassifyExtended {Με Επεκτάσεις Scid ("B12j", ...)}

# Compaction:
translate G NameFile {Αρχείο Ονομάτων}
translate G GameFile {Αρχείο Παρτίδων}
translate G Names {Ονόματα}
translate G Unused {Αχρησιμ.}
translate G SizeKb {Μέγεθ.(kb)}
translate G CurrentState {Παρούσα Κατάσταση}
translate G AfterCompaction {Μετά από συμπίεση}
translate G CompactNames {Συμπίεση Αρχείου Ονομάτων}
translate G CompactGames {Συμπίεση Αρχείου Παρτίδων}
translate G NoUnusedNames "Δεν υπάρχουν αχρησιμοποίητα ονόματα, έτσι το αρχείο ονομάτων είναι πλήρως συμπιεσμένο."
translate G NoUnusedGames "Το αρχείο παρτίδων είναι ήδη συμπιεσμένο."
translate G NameFileCompacted {Το Αρχείο Ονομάτων για την Βάση "[file tail [sc_base filename]]" συμπιέστηκε.}
translate G GameFileCompacted {Το Αρχείο Παρτίδων για την Βάση "[file tail [sc_base filename]]" συμπιέστηκε.}

# Sorting:
translate G SortCriteria {Κριτήρια}
translate G AddCriteria {Προσθήκη Κριτηρίων}
translate G CommonSorts {Συχνές ταξινομήσεις}
translate G Sort {Ταξινόμηση}

# Exporting:
translate G AddToExistingFile {Προσθήκη παρτίδων σε υπάρχον αρχείο;}
translate G ExportComments {Εξαγωγή Σχολίων;}
translate G ExportVariations {Εξαγωγή Βαριάντων;}
translate G IndentComments {Εσοχές Σχολίων;}
translate G IndentVariations {Εσοχές Βαριάντων;}
translate G ExportColumnStyle {Μορφή Στήλης (κίνηση ανά γραμμή);}
translate G ExportSymbolStyle {Μορφή Συμβολισμού Σχολιασμού:}
translate G ExportStripMarks {Αφαίρεση τετραγώνων/τόξων από Σχόλια;}

# Goto game/move dialogs:
translate G LoadGameNumber {Φόρτωση Αριθμ.Παρτίδας}
translate G GotoMoveNumber {Μετάβαση σε Κίνηση}

# Copy games dialog:
translate G CopyGames {Αντιγραφή παρτίδων}
translate G CopyConfirm {
Αντιγραφή [::utils::thousands $nGamesToCopy] παρτίδας(-ων)
από "$fromName" σε "$targetName";
}
translate G CopyErr {Αδύναμία αντιγραφής παρτίδων}
translate G CopyErrSource {Βάση προέλευσης}
translate G CopyErrTarget {Βάση προορισμού}
translate G CopyErrNoGames {δεν υπάρχουν παρτίδες στο φίλτρο}
translate G CopyErrReadOnly {είναι read-only}
translate G CopyErrNotOpen {δεν είναι ανοικτή}

# Colors:
translate G LightSquares {Λευκά τετράγωνα}
translate G DarkSquares {Μαύρα τετράγωνα}
translate G SelectedSquares {Επιλεγμένα}
translate G SuggestedSquares {Προτεινόμενα}
translate G Grid {Πλαίσιο}
translate G Previous {Προηγούμενη}
translate G WhitePieces {Λευκά κομμάτια}
translate G BlackPieces {Μαύρα κομμάτια}
translate G WhiteBorder {Λευκό περίγραμμα}
translate G BlackBorder {Μαύρο περίγραμμα}
translate G ArrowMain   {Τόξο Κύριας}
translate G ArrowVar    {Τόξο Βαριάντας}

# Novelty window:
translate G FindNovelty {Αναζήτηση Καινοτομίας}
translate G Novelty {Καινοτομία}
translate G NoveltyInterrupt {Η αναζήτηση Καινοτομίας διεκόπη}
translate G NoveltyNone {Δεν βρέθηκε Καινοτομία στη παρτίδα}
translate G NoveltyHelp {
Το ScidvsPC θα βρει την πρώτη κίνηση της παρτίδας που καταλήγει σε θέση που δεν υπάρχει στην επιλεγμένη Βάση ή στο βιβλίο ανοιγμάτων ECO.
}

# Sounds configuration:
translate G SoundsFolder {Κατάλογος Αρχείων Ήχων}
translate G SoundsFolderHelp {TΟ Κατάλογος πρέπει να περιέχει τα αρχεία King.wav, a.wav, 1.wav, κλπ}
translate G SoundsAnnounceOptions {Ρυθμίσεις Αναγγελίας Κινήσεων}
translate G SoundsAnnounceNew {Αναγγελία νέων κινήσεων όταν γίνονται}
translate G SoundsAnnounceForward {Αναγγελία κινήσεων κατά την μετακίνηση προς τα εμπρός}
translate G SoundsAnnounceBack {Αναγγελία κινήσεων κατά την μετακίνηση προς τα πίσω}

# Upgrading databases:
translate G Upgrading {Αναβάθμιση}
translate G ConfirmOpenNew {
Αυτή η Βάση Δεδομένων είναι παλιάς έκδοσης (si3), που δεν μπορεί να ανοιχθεί στο Scid 4.0, αλλά μία νέα έκδοση (si4) της έχει ήδη δημιουργηθεί.

Επιθυμείτε να ανοίξετε την νέα έκδοση αυτής της Βάσης;
}
translate G ConfirmUpgrade {
Αυτή είναι Βάση Δεδομένων έκδοσης "si3". Πρέπει να αναβαθμιστεί σε "si4" για να χρησιμοποιηθεί από το  Scid vs. PC 4.0.

Η διαδικασία αυτή είναι μη αναστρέψιμη και γίνεται μόνο μία φορά. Μπορείτε να ακυρώσετε την διαδικασία αν καθυστερεί πολύ.

Επιθυμείτε να γίνει η αναβάθμιση τώρα;
}

# Recent files options:
translate G RecentFilesMenu {Αριθμός προσφ.αρχείων στο μενού Αρχείο}
translate G RecentFilesExtra {Αριθμός προσφ.αρχείων στο υπομενού}

translate G MyPlayerNamesDescription {
Εισάγετε παρακάτω τα προτιμώμενα ονόματα Παικτών, ένα για κάθε γραμμή.
Κάθε φορά που φορτώνεται μια παρτίδα, με όνομα παίκτη που υπάρχει στη λίστα, η σκακιέρα θα περιστρέφεται, αν χρειάζεται, ώστε να προβάλεται η παρτίδα από τη μεριά του.
}

#Coach
translate G showblunderexists {ένδειξη Σοβαρού Σφάλματος του phalanx}
translate G showblundervalue {ένδειξη αξίας Σοβαρού Σφάλματος}
translate G showscore {ένδειξη σκορ}
translate G coachgame {παρτίδα διδασκαλίας}
translate G configurecoachgame {Ρυθμίσεις Παρτίδας Τακτικής}
translate G configuregame {Configure UCi game}
translate G Phalanxengine {Ρυθμίσεις Παρτίδας UCI}
translate G Coachengine {Μηχανή Προπόνησης}
translate G difficulty {επίπεδο δυσκολίας}
translate G hard {δύσκολο}
translate G easy {εύκολο}
translate G Playwith {Παίξιμο με}
translate G white {Λευκά}
translate G black {Μαύρα}
translate G both {οποιαδήποτε}
translate G Play {Έναρξη}
translate G Noblunder {Χωρίς Σοβαρό Σφάλμα}
translate G blunder {Σοβαρό Σφάλμα}
translate G Noinfo {-- χωρίς πληροφορίες --}
translate G moveblunderthreshold {η κίνηση είναι Σοβαρό Σφάλμα αν η απώλεια είναι μεγαλύτερη από}
translate G limitanalysis {Χρόνος σκέψης Προπονητή}
translate G seconds {δευτερόλεπτα}
translate G Abort {Ακύρωση}
translate G Resume {Συνέχιση}
translate G Restart {Επανεκκίνηση}
translate G OutOfOpening {Εκτός ανοίγματος}
translate G NotFollowedLine {Δεν ακολουθήσατε την γραμμή}
translate G DoYouWantContinue {Θέλετε να συνεχίσετε ;}
translate G CoachIsWatching {Ο Προπονητής παρακολουθεί}
translate G Ponder {Διαρκής σκέψη}
translate G LimitELO {Περιορισμός δυναμικότητας ELO}
translate G DubiousMovePlayedTakeBack {Παίχθηκε Αμφίβολη κίνηση, επιθυμείτε να πάρετε πίσω ;}
translate G WeakMovePlayedTakeBack {Παίχθηκε Αδύνατη κίνηση, επιθυμείτε να την πάρετε πίσω ;}
translate G BadMovePlayedTakeBack {Παίχθηκε Κακή Κίνηση, επιθυμείτε να την πάρετε πίσω ;}
translate G Iresign {Εγκαταλείπω}
translate G yourmoveisnotgood {η κίνηση δεν είναι καλή}
translate G EndOfVar {Τέλος βαριάντας}
translate G Openingtrainer {Προπονητής Ανοίγματος}
translate G DisplayCM {Εμφάνιση υποψήφιας κίνησης}
translate G DisplayCMValue {Εμφάνιση αξίας υποψήφιας κίνησης}
translate G DisplayOpeningStats {Προβολή στατιστικών}
translate G ShowReport {Προβολή αναφοράς}
translate G NumberOfGoodMovesPlayed {παίχθηκαν καλές κινήσεις}
translate G NumberOfDubiousMovesPlayed {παίχθηκαν αμφίβολες κινήσεις}
translate G NumberOfTimesPositionEncountered {φορές εμφανίσης θέσης}
translate G PlayerBestMove  {Επέτρεψε μόνο τις καλύτερες}
translate G OpponentBestMove {Ο Αντίπαλος παίζει τις καλύτερες}
translate G OnlyFlaggedLines {Μόνο επισημανσμένες γραμμές}
translate G resetStats {Μηδενισμός στατιστικών}
translate G Movesloaded {Φορτωμένες Κινήσεις}
translate G PositionsNotPlayed {Θέσεις που δεν παίχθηκαν}
translate G PositionsPlayed {Θέσεις που παίχθηκαν}
translate G Success {Επιτυχία}
translate G DubiousMoves {Αμφίβολες κινήσεις}
translate G ConfigureTactics {Επιλογή Παζλ}
translate G ResetScores {Μηδενισμός Σκορ}
translate G LoadingBase {Φόρτωση Βάσης}
translate G Tactics {Τακτικής}
translate G ShowSolution {Εμφάνιση λύσης}
translate G Next {Επόμενη}
translate G ResettingScore {Μηδενισμός σκορ}
translate G LoadingGame {Φόρτωση παρτίδας}
translate G MateFound {Βρέθηκε το ΜΑΤ}
translate G BestSolutionNotFound {Η Καλύτερη λύση ΔΕΝ βρέθηκε !}
translate G MateNotFound {ΔΕΝ βρέθηκε το ΜΑΤ}
translate G ShorterMateExists {Υπάρχει πιο σύντομο ΜΑΤ}
translate G ScorePlayed {Σκορ Κίνησης που παίχθηκε}
translate G Expected {αναμενόμενη}
translate G ChooseTrainingBase {Επιλέξτε Βάση Εκπαίδευσης}
translate G Thinking {Σκέφτεται}
translate G AnalyzeDone {Η ανάλυση ολοκληρώθηκε}
translate G WinWonGame {Η παρτίδα κερδήθηκε}
translate G Lines {Γραμμές}
translate G ConfigureUCIengine {Ρύθμιση Μηχανής}
translate G SpecificOpening {Συγκεκριμένο Άνοιγμα}
translate G StartNewGame {Έναρξη νέας παρτίδας}
translate G FixedLevel {Σταθερό επίπεδο}
translate G Opening {Άνοιγμα}
translate G RandomLevel {Τυχαίο επίπεδο}
translate G StartFromCurrentPosition {Έναρξη από την τρέχουσα θέση}
translate G FixedDepth {Σταθερό βάθος}
translate G Nodes {Nodes}
translate G Depth {Βάθος}
translate G Time {Χρόνος} 
translate G SecondsPerMove {Δευτερόλεπτα Κίνησης}
# ====== TODO To be translated ======
translate G DepthPerMove {Depth per move}
# ====== TODO To be translated ======
translate G MoveControl {Move Control}
translate G TimeLabel {Χρόνος Κίνησης}
# ====== TODO To be translated ======
translate G AddVars {Add Variations}
# ====== TODO To be translated ======
translate G AddScores {Add Score}
translate G Engine {Μηχανή}
translate G TimeMode {Τύπος χρόνου}
translate G TimeBonus {Χρόνος + bonus}
translate G TimeMin {λεπτ}
translate G TimeSec {δευτ}
translate G AllExercisesDone {Όλες οι ασκήσεις τελείωσαν}
translate G MoveOutOfBook {Κίνηση εκτός βιβλίου}
translate G LastBookMove {Τελευταία κίνηση βιβλίου}
translate G AnnotateSeveralGames {Ομαδικός Σχολιασμός\nΑπό τρέχουσα έως :}
translate G FindOpeningErrors {Μόνο λάθη ανοίγματος}
translate G MarkTacticalExercises {Επισήμανση τακτικών}
translate G UseBook {Χρήση βιβλίου}
translate G MultiPV {Πολλαπλές βαριάντες}
translate G Hash {Μνήμη Hash}
translate G OwnBook {Χρήση βιβλίου μηχανής}
translate G BookFile {Βιβλίο Ανοιγμάτων}
translate G AnnotateVariations {Επεξεργασία υπο-βαριαντών}
translate G ShortAnnotations {Σύντομος σχολιασμός}
translate G addAnnotatorTag {Προσθήκη Ετικέτας Σχολιαστή}
translate G AddScoreToShortAnnotations {Προσθήκη σκορ στο σχολιασμό}
translate G Export {Εξαγωγή}
translate G BookPartiallyLoaded {Φόρτωση Βιβλίου μερικώς}
# ====== TODO To be translated ======
translate G AddLine {Add Line}
# ====== TODO To be translated ======
translate G RemLine {Remove Line}
translate G Calvar {Υπολογισμός Βαριάντων}
translate G ConfigureCalvar {Ρύθμιση}
# Opening names used in tacgame.tcl
translate G Reti {Ρέτι}
translate G English {Αγγλική}
translate G d4Nf6Miscellaneous {1.d4 Nf6 διάφορα}
translate G Trompowsky {Trompowsky}
translate G Budapest {Βουδαπέστης}
translate G OldIndian {Παλιά Ινδική}
translate G BenkoGambit {Μπένκο Γκαμπί}
translate G ModernBenoni {Μοντέρνο Μπενόνι}
translate G DutchDefence {Ολλανδική Άμυνα}
translate G Scandinavian {Σκανδιναβική}
translate G AlekhineDefence {Άμυνα Αλιέχιν}
translate G Pirc {Πιρς}
translate G CaroKann {Κάρο-Καν}
translate G CaroKannAdvance {Κάρο-Καν προώθησης}
translate G Sicilian {Σικελική}
translate G SicilianAlapin {Σικελική Αλάπιν}
translate G SicilianClosed {Σικελική Κλειστή}
translate G SicilianRauzer {Σικελική Ράουζερ}
translate G SicilianDragon {Σικελική Δράκος}
translate G SicilianScheveningen {Σικελική Σεβενίγκεν}
translate G SicilianNajdorf {Σικελική Νάιντορφ}
translate G OpenGame {Ανοικτό παιχνίδι}
translate G Vienna {Βιενέζικη}
translate G KingsGambit {Γκαμπί Βασιλιά}
translate G RussianGame {Ρωσική}
translate G ItalianTwoKnights {Ιταλική/Δύο Ίπποι}
translate G Spanish {Ισπανική}
translate G SpanishExchange {Ισπανική Αλλαγής}
translate G SpanishOpen {Ισπανική Ανοικτή}
translate G SpanishClosed {Ισπανική Κλειστή}
translate G FrenchDefence {Γαλλική Άμυνα}
translate G FrenchAdvance {Γαλλική Προώθησης}
translate G FrenchTarrasch {Γαλλική Ταρρας}
translate G FrenchWinawer {Γαλλική Winawer}
translate G FrenchExchange {Γαλλική Αλλαγής}
translate G QueensPawn {Πιόνι Βασίλισσας}
translate G Slav {Σλαβική}
translate G QGA {QGA}
translate G QGD {QGD}
translate G QGDExchange {QGD Αλλαγής}
translate G SemiSlav {Ημι-Σλαβική}
translate G QGDwithBg5 {QGD με Bg5}
translate G QGDOrthodox {QGD Ορθόδοξη}
translate G Grunfeld {Grunfeld}
translate G GrunfeldExchange {Grunfeld Αλλαγής}
translate G GrunfeldRussian {Grunfeld Ρωσική}
translate G Catalan {Καταλανική}
translate G CatalanOpen {Καταλανική Ανοικτή}
translate G CatalanClosed {Καταλανική Κλειστή}
translate G QueensIndian {Ινδική της Βασίλισσας}
translate G NimzoIndian {Νιμζο-Ινδική}
translate G NimzoIndianClassical {Νιμζο-Ινδική Κλασσική}
translate G NimzoIndianRubinstein {Νιμζο-Ινδική Ρουμπισταϊν}
translate G KingsIndian {Ινδική του Βασιλιά}
translate G KingsIndianSamisch {Ινδική του Βασιλιά Samisch}
translate G KingsIndianMainLine {Ινδική του Βασιλιά Κύρια Γραμμή}

# FICS
translate G ConfigureFics {Ρύθμιση FICS}
translate G FICSLogin {Login}
translate G FICSGuest {Login ως Guest}
translate G FICSServerPort {Server port}
translate G FICSServerAddress {IP Address}
translate G FICSRefresh {Ανανέωση}
translate G FICSTimeseal {Timeseal}
translate G FICSTimesealPort {Timeseal port}
translate G FICSSilence {Φίλτρο Κονσόλας}
translate G FICSOffers {Προσφορές}
translate G FICSGames {Παρτίδες}
translate G FICSFindOpponent {Εύρεση Αντιπ.}
translate G FICSTakeback {Αναίρεση}
translate G FICSTakeback2 {Αναίρεση 2}
translate G FICSInitTime {Χρόνος (λεπτ)}
translate G FICSIncrement {Αύξηση (δευτ)}
translate G FICSRatedGame {Με αξιολόγηση}
translate G FICSAutoColour {Αυτόματο}
translate G FICSManualConfirm {Επιβεβαίωση χειροκ.}
translate G FICSFilterFormula {Φίλτρο με φόρμουλα}
translate G FICSIssueSeek {Issue seek}
translate G FICSAccept {Αποδοχή}
translate G FICSDecline {Απόρριψη}
translate G FICSColour {Χρώμα}
translate G FICSSend {Αποστολή}
translate G FICSConnect {Σύνδεση}
# ====== TODO To be translated ======
translate G FICSShouts {Shouts}
# ====== TODO To be translated ======
translate G FICSTells {Tells}
# ====== TODO To be translated ======
translate G FICSOpponent {Opponent Info}
# ====== TODO To be translated ======
translate G FICSInfo {Info}
# ====== TODO To be translated ======
translate G FICSDraw {Offer Draw}
# ====== TODO To be translated ======
translate G FICSRematch {Rematch}
# ====== TODO To be translated ======
translate G FICSQuit {Quit FICS}
# ====== TODO To be translated ======
translate G FICSCensor {Censor}

# Correspondence Chess Dialogs:
translate G CCDlgConfigureWindowTitle {Ρυθμίσεις Σκάκι Δι Αλληλογραφίας}
translate G CCDlgCGeneraloptions {Γενικές Ρυθμίσεις}
translate G CCDlgDefaultDB {Κύρια Βάση:}
translate G CCDlgInbox {Εισερχόμενα (διαδρομή):}
translate G CCDlgOutbox {Εξερχόμενα (διαδρομή):}
translate G CCDlgXfcc {Ρυθμίσεις Xfcc:}
translate G CCDlgExternalProtocol {Εξωτερικός Protocol Handler (πχ Xfcc)}
translate G CCDlgFetchTool {Εργαλείο Λήψης:}
translate G CCDlgSendTool {Εργαλείο Αποστολής:}
translate G CCDlgEmailCommunication {Επικοινωνία eMail}
translate G CCDlgMailPrg {Πρόγραμμα Αλληλογραφίας:}
translate G CCDlgBCCAddr {(B)CC Διεύθυνση:}
translate G CCDlgMailerMode {Mode:}
translate G CCDlgThunderbirdEg {πχ Thunderbird, Mozilla Mail, Icedove...}
translate G CCDlgMailUrlEg {πχ Evolution}
translate G CCDlgClawsEg {πχ Sylpheed Claws}
translate G CCDlgmailxEg {πχ mailx, mutt, nail...}
translate G CCDlgAttachementPar {Επισύναψη Παράμετροι:}
translate G CCDlgInternalXfcc {Χρήση ενσωματωμένου Xfcc}
translate G CCDlgConfirmXfcc {Επιβεβαίωση κινήσεων}
translate G CCDlgSubjectPar {Θέμα Παράμετροι:}
translate G CCDlgDeleteBoxes {Άδειασμα Εισ-/Εξερχομένων}
translate G CCDlgDeleteBoxesText {Επιθυμείτε πράγματι να αδειάσετε τους καταλόγους Εισερχομένων και Εξερχομένων του Σκάκι Δι' Αλληλογραφίας;\nΘα χρειαστεί νέος συγχρονισμός για την τελευταία ενημέρωση των παρτίδων.}
translate G CCDlgConfirmMove {Επιβεβαίωση Κίνησης}
translate G CCDlgConfirmMoveText {Αν το επιβεβαιώσετε, τα ακόλουθα, κίνηση και σχόλιο, θα αποσταλούν στον Διακομιστή:}
translate G CCDlgDBGameToLong {Ασυνεπής Κύρια Γραμμή}
translate G CCDlgDBGameToLongError {Η Κύρια Γραμμή της βάσης είναι μεγαλύτερη από την παρτίδα στα Εισερχόμενα. Αν τα Εισερχόμενα περιέχουν τις τρέχουσες παρτίδες, π.χ. μετά από συγχρονισμό, κάποιες κινήσεις προστέθηκαν εσφαλμένα στην Κύρια Γραμμή.

Σε αυτή την περίπτωση σβήστε την Κύρια Γραμμή στη (μέγιστη) κίνηση
}

translate G CCDlgStartEmail {Έναρξη Νέας Παρτίδας Δι'Αλληλογραφίας}
translate G CCDlgYourName {Το Όνομά Σας:}
translate G CCDlgYourMail {Η Διεύθυνση eMail Σας:}
translate G CCDlgOpponentName {Όνομα Αντιπάλου:}
translate G CCDlgOpponentMail {Διεύθυνση eMail Αντιπάλου:}
translate G CCDlgGameID {Κωδικός Παρτίδας (μοναδικός):}

translate G CCDlgTitNoOutbox {Scid: Δι'Αλληλογραφίας Εξερχόμενα}
translate G CCDlgTitNoInbox {Scid: Δι'Αλληλογραφίας Εισερχόμενα}
translate G CCDlgTitNoGames {Scid: Χωρίς Παρτίδες Δι'αλληλογραφίας}
translate G CCErrInboxDir {Κατάλογος εισερχομένων δι'αλληλογραφίας:}
translate G CCErrOutboxDir {Κατάλογος εξερχομένων δι'αλληλογραφίας:}
translate G CCErrDirNotUsable {δεν υπάρχει ή δεν είναι προσβάσιμη!\nΠαρακαλώ ελέγξτε και διορθώστε τις ρυθμίσεις.}
translate G CCErrNoGames {δεν περιέχονται παρτίδες!\nΠαρακαλώ συγχρονίστε πρώτα.}

translate G CCDlgTitNoCCDB {Scid: Χωρίς Βάση Δι'αλληλογραφίας}
translate G CCErrNoCCDB {Καμία Βάση τύπου 'Δι'Αλληλογραφίας" δεν είναι ανοικτή. Παρακαλώ ανοίξτε μία πριν χρησιμοποιήσετε κάποια λειτουργία του Σκάκι Δι' Αλληλογραφίας.}

translate G CCFetchBtn {Συγχρονισμός παρτίδων από τον Σέρβερ και έλεγχος Εισερχομένων}
translate G CCPrevBtn {Άνοιγμα προηγούμενης παρτίδας}
translate G CCNextBtn {Άνοιγμα επόμενης παρτίδας}
translate G CCSendBtn {Αποστολή κίνησης}
translate G CCEmptyBtn {Άδεισμα Εισ- και Εξερχομένων}
translate G CCHelpBtn {Βοήθεια για εικονίδια και τους δείκτες κατάστασης.\nΓια γενική Βοήθεια πατήστε F1!}

translate G CCDlgServerName {Όνομα Σέρβερ}
translate G CCDlgLoginName  {Όνομα Login}
translate G CCDlgPassword   {Κωδικός}
translate G CCDlgURL        {Xfcc-URL}
translate G CCDlgRatingType {Τύπος Βαθμολογίας}

translate G CCDlgDuplicateGame {Μη μοναδικό ID παρτίδας}
translate G CCDlgDuplicateGameError {Αυτή η παρτίδα υπάρχει περισσότερες από μία φορές στη βάση. Παρακαλώ διαγράψτε όλα τις διπλές και συμπιέστε το αρχείο παρτίδων (Αρχείο/Συντήρηση/Συμπίεση Βάσης Δεδομένων).}

translate G CCDlgSortOption {Ταξινόμηση:}
translate G CCDlgListOnlyOwnMove {Μόνο Παρτίδες που έχω την κίνηση}
translate G CCOrderClassicTxt {Τόπος, Διοργάνωση, Γύρος, Αποτέλεσμα, Λευκά, Μαύρα}
translate G CCOrderMyTimeTxt {Ο Χρόνος μου}
translate G CCOrderTimePerMoveTxt {Χρόνος κίνησης μέχρι την επόμενη}
translate G CCOrderStartDate {Ημερομηνία έναρξης}
translate G CCOrderOppTimeTxt {Χρόνος Αντιπάλου}

translate G CCDlgConfigRelay {Παρακολούθηση παρτίδων}
translate G CCDlgConfigRelayHelp {Άνοιγμα σελίδας http://www.iccf-webchess.com και προβολή παρτίδας που θέλετε να παρακολουθήσετε. Αν βλέπετε την σκακιέρα αντιγράψτε το URL από το φυλλομετρητή σας στη παρακάτω λίστα. Ένα URL για κάθε γραμμή μόνο!\nΠαράδειγμα: http://www.iccf-webchess.com/MakeAMove.aspx?id=266452}


# Connect Hardware dialoges
translate G ExtHWConfigConnection {Ρύθμιση εξωτερικού hardware}
translate G ExtHWPort {Θύρα}
translate G ExtHWEngineCmd {Εντολή Μηχανής}
translate G ExtHWEngineParam {Παράμετροι Μηχανής}
translate G ExtHWShowButton {Προβολή κουμπιού στο κεντρικό παράθυρο}
translate G ExtHWHardware {Hardware}
translate G ExtHWNovag {Novag Citrine}
translate G ExtHWInputEngine {Μηχανή Εισόδου}
translate G ExtHWNoBoard {χωρίς σκακιέρα}

# Input Engine dialogs
translate G IEConsole {Κονσόλα Μηχανής Εισόδου}
translate G IESending {Αποστολή Κινήσεων για}
translate G IESynchronise {Συγχρονισμός}
translate G IERotate  {Περιστροφή}
translate G IEUnableToStart {Αδυναμία εκκίνησης Μηχανής Εισόδου:}
# Calculation of Variations
translate G DoneWithPosition {Τέλος με θέση}

translate G Board {Σκακιέρα}
translate G showGameInfo {Εμφάνιση πληροφοριών παρτίδας}
translate G autoResizeBoard {Αυτόματο μέγεθος σκακιέρας}
translate G DockTop {Θέσε Πάνω}
translate G DockBottom {Θέσε Κάτω}
translate G DockLeft {Θέσε Αριστερά}
translate G DockRight {Θέσε Δεξιά}
translate G Undock {Αποκόλληση}

# Switcher window
translate G ChangeIcon {Αλλαγή εικονιδίου}
# ====== TODO To be translated ======
translate G More {More}

# Drag & Drop
translate G CannotOpenUri {Αδυναμία ανοίγματος URI:}
translate G InvalidUri {Το περιεχόμενο δεν είναι έγκυρο URI.}
translate G UriRejected	{Τα ακόλουθα αρχεία απορρίφθηκαν:}
translate G UriRejectedDetail {Μόνο οι συγκεκριμένοι τύποι αρχείων λειτουργούν:}
translate G EmptyUriList {Το περιεχόμενο είναι άδειο.}
translate G SelectionOwnerDidntRespond {Λήξη προθεσμίας: η εφαρμογή δεν αποκρίθηκε.}

}
# end of greek.tcl
