### Phalanx Makefile
# editted by S.A to handle defaults passed by Scid Makefile

LINK ?= $(CC)

### DEFINES
### -DSHOW_FORCED_MOVES
### -DPBOOK_FILE=\"pbook.phalanx\"
### -DSBOOK_FILE=\"sbook.phalanx\"
### -DLEARN_FILE=\"learn.phalanx\"
### -DPBOOK_DIR=\"/usr/local/lib\"
### -DSBOOK_DIR=\"/usr/local/lib\"
### -DLEARN_DIR=\"/var/local/lib\"
### -DQCAPSONLY

DEFINES = #-DGNUFUN 

OBJ = .o/phalanx.o .o/bcreate.o .o/search.o .o/io.o .o/data.o \
      .o/evaluate.o .o/genmoves.o .o/moving.o .o/hash.o .o/static.o \
      .o/levels.o .o/book.o .o/killers.o .o/endgame.o .o/learn.o .o/easy.o

phalanx: .o $(OBJ)
	$(LINK) $(CFLAGS) $(DEFINES) $(LDFLAGS) $(OBJ) -o phalanx

.o/%.o: Makefile %.c
	$(CC) $(CFLAGS) $(DEFINES) -c $*.c -o .o/$*.o

.o:
	mkdir .o

clean:
	rm -rf .o phalanx *.lrn learn.phalanx

backup:
	tar -czvf Archive/phalanx.tgz \
	Makefile *.c *.h pbook.phalanx sbook.phalanx test.fin

