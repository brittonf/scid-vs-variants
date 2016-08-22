.PHONY : clean
.PRECIOUS:

EXTRA_CFLAGS  	= -pipe -Wno-format-security #-fno-stack-protector

.SUFFIXES: .c
.PRECIOUS:

INCLUDE	= $(TCL_INCLUDE) $(TK_INCLUDE) $(X_INCLUDE) -I../tk$(TCL_VERSION)
CFLAGS	+= $(OPTIMIZE) $(C_DEBUG) $(PROFILING) -Wall

SRC	= unix/TkDND_XDND.c
OBJS	= $(SRC:.c=.o)

all: unix/TkDND_XDND.o

clean:
	@rm -f TkDND_XDND.o

depend:
#	makedepend -fMakefile -Y -- -I../tk$(TCL_VERSION) -- -w1 $(SRC) 2>/dev/null
#	@if [ -h Makefile.bak ]; then \
#		cp Makefile Makefile.bak; \
#		mv Makefile.bak Makefile; \
#	fi

.c.o:
#	@echo "Compiling `awk 'BEGIN { printf "%-30s", "$<" }'`  [$(CFLAGS:  = )]"
	$(CC) -c $(CFLAGS) $(EXTRA_CFLAGS) $(INCLUDE) $<

