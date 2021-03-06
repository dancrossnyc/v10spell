# Configuration here:
prefix = /usr/local
PREFIX = $(prefix)
LIBDIR = $(PREFIX)/lib/v10spell
BINDIR = $(PREFIX)/bin
MANDIR = $(PREFIX)/share/man/man1
XCFLAGS =
# End of configuration

HFILES = code.h

CFLAGS = -Wall -O -DLIBDIR='"$(LIBDIR)/"' $(XCFLAGS)

all:	sprog brspell amspell

bin:	spell.sh
	-mkdir -p $(BINDIR)
	cp spell.sh $(BINDIR)/v10spell

man:	spell.1
	-mkdir -p $(MANDIR)
	cp spell.1 $(MANDIR)/v10spell.1

spell.sh: spellsh.in
	sed -e 's;LIBDIR;$(LIBDIR);g' -e 's;BINDIR;$(BINDIR);g' < spellsh.in > spell.sh
	chmod +x spell.sh

lib:	sprog amspell brspell
	-mkdir -p $(LIBDIR)
	cp sprog $(LIBDIR)/sprog
	strip $(LIBDIR)/sprog
	cp amspell $(LIBDIR)/amspell
	cp brspell $(LIBDIR)/brspell
	rm -f sprog amspell brspell
	
brspell: pcode  list british local stop
	./pcode list british local stop >brspell

amspell: pcode  list american local stop
	./pcode list american local stop >amspell

pcode:	pcode.o
	$(CC) $(CFLAGS) -o pcode pcode.o

sprog:	sprog.o
	$(CC) $(CFLAGS) -o sprog sprog.o

%.o:	%.c $(HFILES)
	$(CC) $(CFLAGS) -c $*.c

install: bin lib man

clean:
	rm -f *.[v2o] amspell brspell pcode sprog spell.sh
