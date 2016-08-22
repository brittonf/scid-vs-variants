### Toga Makefile
# editted by S.A to handle defaults passed by Scid Makefile

EXE = fruit

OBJS = attack.o board.o book.o eval.o fen.o hash.o list.o main.o material.o \
       move.o move_check.o move_do.o move_evasion.o move_gen.o move_legal.o \
       option.o pawn.o piece.o posix.o protocol.o pst.o pv.o random.o recog.o \
       search.o search_full.o see.o sort.o square.o trans.o util.o value.o \
       vector.o

# rules

all: $(EXE) .depend

clean:
	rm -rf *.o .depend gmon.out $(EXE)

# optimisation

CXXFLAGS += -fstrict-aliasing
CXXFLAGS += -fomit-frame-pointer

# dependencies

$(EXE): $(OBJS)
	$(CXX) $(CXXFLAGS) $(LDFLAGS) -o $@ $(OBJS)

.depend:
	$(CXX) $(CXXFLAGS) $(OBJS:.o=.cpp) > $@
