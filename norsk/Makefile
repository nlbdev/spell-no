# Makefile for the Norwegian dictionary for Ispell v. 2.0
# Copyright (C) 2000, Rune Kleveland
#
# Maintainer: Toralf Lund
# Email : toralf - at - procaptura - dot - com
# License : GPL

SHELL = /bin/sh
ISPELLDIST=../..
CONFIG		=	$(ISPELLDIST)/config.sh
ISPELL		=	PATH=$(ISPELLDIST):${PATH} ispell
BUILDHASH	=	PATH=$(ISPELLDIST):${PATH} buildhash

# The following variables make it easy to adapt this Makefile to
# numerous languages.
#
LANGUAGE	=	norsk
DICTIONARY	=	$(LANGUAGE).mch
HASHFILE	=	$(LANGUAGE).hash
VERSION         =       3.0
# Version no for aspell dictionary output
ASPELL_VERSION	=	0.60

DISTFILES 	= *.pl *.c *.h *.in *.words\
	          Makefile README* forkort.txt


#
# The following variables may be overridden by the superior Makefile,
# based on the LANGUAGES variable in config.X.
#
AFFIXES	=	$(LANGUAGE).aff

# What characters and flags do we use for Norwegian?

LCH=\"abcdefghijklmnopqrstuvwxyzæøåéêèóôòçî
UCH=ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅÉÊÈÓÔÒÇÎ
CH=${LCH}${UCH}
PRE=a-s
SUFFNORM=][t-zA-Z^
SUFFCOMP=\\\\\\\`_
SUFF=${SUFFNORM}${SUFFCOMP}
#SUFF=][t-zA-Z\\\\\\\`^_


# The awk scripts below tells which words from each category that
# should be in the dictionary.  The line

# /^[-${LCH}]{4}\[${SUFF}]/   {if ($$2>4) {print $$1,$$2}} 

# says that words with length 4 containing only lowercase letters with
# frequency greater then 5 should be included.  Edit the scripts as
# you like, but please don't make syntactic errors.  Awk forgives
# nothing.  Remember that it is more likely that a mistyping turns out
# to be a legal word if the word is short.  `re' is legal!

# The CHOOSEFLAG script sets the limit for flag inclusion.  Example:
# adgangs-tegn is a common word, but the form adgangstegnenes scores 0
# on frequency.  It will be excluded by the script below if you don't
# change it.

# The CHOOSEROOT script selects the root words to be included after
# the uncommonly used flags have been deleted.  The key used is the
# frequency category of of the union of all words this root and its
# flags generates.

# The reason for the two pass system is that the space required by a
# root word is much bigger than what is required by just a flag.

# You are of course free to change the selection system.

# The B file contains all kinds of words.


CATHEGORIES=B A N M S K D O C

# Delete all suffix rules except the one we need to compile C code
# included here, so that make won't try to do stupid things like
# generate norsk.words based on norsk.words.<cathegory>

.SUFFIXES:

.SUFFIXES: .c





# Configuration for the words file.

# The words file is a plain text file containing words in alphabetical
# order.  It is used by ispell via the look/grep programs to display
# words starting with a specific string or matching a specific
# pattern.  It is also useful if one want to make a dictionary for
# some stupid spell-checker in a word processor.

# Lets make this simple.

WORDSFILTER='{if ($$2>9) {print $$1}}'

# Configuration for building ispell dictionaries.

# The frequency category works best for B, A and N categories.

# Very young people and people which don't speak Norwegian natively
# will probably be much more happy with a smaller dictionary than the
# complete one.  A smaller dictionary should also be considered if the
# machine is low on memory.  Below is a quite advanced system for
# building such dictionaries.

# It is possible to remove all words that is accepted by ispell in
# controlled compoundwords mode with frequency indicator less than
# COMPOUNDLIMIT.  Thus if `naturvern' and `direktorat' are words which
# is marked as allowed in compounds, it might not be nessesary to
# include `naturverndirektorat' in the dictionary.

# However, if one misspells `naturverndirektorat', ispell will not be
# able to make a suggestion for this word.  And one must use the
# controlled compoundwords mode to accept this word, and that is not
# as secure as the -B mode.

# In sum; It is nice if ispell can make a suggestion words like
# `angrefrisperiode', but it consumes space and memory.
COMPOUNDLIMIT=5

# There is a system for selecting words to include in the Ispell
# dictionary.  Unfortunately it is rather complex and not too easy to
# use, but this was what I came up with, so you must use it or invent
# your own.  The good thing is that one can select both flags and
# roots, depending on how the root word looks line and the frequency
# og all forms coming from the flag or the root.

# Somewhere in the long pipe making the input file for buildhash, the
# data looks like
#
# gutte-drøm/ 17
# gutte-drøm/A 18
# gutte-drøm/E 14
# gutte-drøm/G 7
#
# thus the frequenzy indicator for each flag is availiable.  Awk is
# used to pick the flags we want, and the variable holding the program
# is CHOOSEFLAG[CATHEGORY]. Don't throw away the root, since that
# messes things up badly.
#
# Later in the pipe the data looks like
#
# gutte-drøm/17A18E14G7 19
#
# The second field (19) is the frequenzy indicator for all words
# comming from the root gutt.  So here we can throw away a root with
# all its derivied forms if we like.

DEFAULTROOTFILTER='{print $$1,$$2}' # This selects all words in a file

# Don't include all rare words allowed in compounds.

define DEFAULTFLAGFILTER
'!/[${SUFFCOMP}]/      {print $$1,$$2} \
/\/[${SUFFCOMP}]/      {if ($$2>6) {print $$1,$$2}}'
endef

# Select all words by default.  Then override with more elaborate
# rules if desired.


CHOOSEFLAGB=${DEFAULTFLAGFILTER} # Normal words
CHOOSEFLAGA=${DEFAULTFLAGFILTER} # `newspaper' words, but very useful.
CHOOSEFLAGN=${DEFAULTFLAGFILTER} # Words from NOU
CHOOSEFLAGM=${DEFAULTFLAGFILTER} # Words from mathematics
CHOOSEFLAGS=${DEFAULTFLAGFILTER} # Samnorsk, radical forms
CHOOSEFLAGK=${DEFAULTFLAGFILTER} # Conservative writing
CHOOSEFLAGD=${DEFAULTFLAGFILTER} # Words from Dagbladet
CHOOSEFLAGO=${DEFAULTFLAGFILTER} # Words from technical oil business
CHOOSEFLAGC=${DEFAULTFLAGFILTER} # Sammendragning

CHOOSEROOTB=${DEFAULTROOTFILTER} # Normal words
CHOOSEROOTA=${DEFAULTROOTFILTER} # `newspaper' words, but very useful.
CHOOSEROOTN=${DEFAULTROOTFILTER} # Words from NOU
CHOOSEROOTM=${DEFAULTROOTFILTER} # Words from mathematics
CHOOSEROOTS=${DEFAULTROOTFILTER} # Samnorsk, radical forms
CHOOSEROOTK=${DEFAULTROOTFILTER} # Conservative writing
CHOOSEROOTD=${DEFAULTROOTFILTER} # Words from Dagbladet
CHOOSEROOTO=${DEFAULTROOTFILTER} # Words from technical oil business
CHOOSEROOTC=${DEFAULTROOTFILTER} # Sammendragning

# Here is an example of an awk script that excludes some short
# uncommon words, and some long very uncommon words.  It is most
# likely that you want to exclude short uncommon words, since those
# are most likely to be typed by mistake.  Exclude long words to save
# memory.  Also see the COMPOUNDLIMIT variable above if you want to
# make a resource-friendly dictionary.

# define CHOOSEFLAGB
# '/\/[ ${PRE}]/                                  {print $$1,$$2}  \
# /^[-${LCH}]{1,2}\/[${SUFF}]/        {if ($$2>6) {print $$1,$$2}} \
# /^[-${LCH}]{3}\/[${SUFF}]/          {if ($$2>5) {print $$1,$$2}} \
# /^[-${LCH}]{4}\/[${SUFF}]/          {if ($$2>3) {print $$1,$$2}} \
# /^[-${LCH}]{5,7}\/[${SUFF}]/        {if ($$2>1) {print $$1,$$2}} \
# /^[-${LCH}]{8,}\/[${SUFF}]/         {if ($$2>=0) {print $$1,$$2}} \
# /^[${UCH}][-${CH}]{1,2}\/[${SUFF}]/ {if ($$2>4) {print $$1,$$2}} \
# /^[${UCH}][-${CH}]{3}\/[${SUFF}]/   {if ($$2>3) {print $$1,$$2}} \
# /^[${UCH}][-${CH}]{4}\/[${SUFF}]/   {if ($$2>2) {print $$1,$$2}} \
# /^[${UCH}][-${CH}]{5,7}\/[${SUFF}]/ {if ($$2>1) {print $$1,$$2}} \
# /^[${UCH}][-${CH}]{8,}\/[${SUFF}]/  {if ($$2>=0) {print $$1,$$2}}'
# endef

# define CHOOSEROOTB
# '/^[-${LCH}]{1,2}\//       {if ($$2>8) {print $$1,$$2}} \
# /^[-${LCH}]{3}\//          {if ($$2>6) {print $$1,$$2}} \
# /^[-${LCH}]{4}\//          {if ($$2>5) {print $$1,$$2}} \
# /^[-${LCH}]{5,7}\//        {if ($$2>2) {print $$1,$$2}} \
# /^[-${LCH}]{8,}\//         {if ($$2>1) {print $$1,$$2}} \
# /^[${UCH}][-${CH}]{1,2}\// {if ($$2>8) {print $$1,$$2}} \
# /^[${UCH}][-${CH}]{3}\//   {if ($$2>6) {print $$1,$$2}} \
# /^[${UCH}][-${CH}]{4}\//   {if ($$2>3) {print $$1,$$2}} \
# /^[${UCH}][-${CH}]{5,7}\// {if ($$2>2) {print $$1,$$2}} \
# /^[${UCH}][-${CH}]{8,}\//  {if ($$2>1) {print $$1,$$2}}'
# endef




all: $(HASHFILE) nynorsk.hash myspell

myspell: nb_NO.aff nb_NO.dic nn_NO.aff nn_NO.dic 

myspell-dist: nb_NO.zip nn_NO.zip

aspell-dist: aspell6-nb-$(ASPELL_VERSION).tar.bz2 aspell6-nn-$(ASPELL_VERSION).tar.bz2

install: install-norsk install-nynorsk install-scripts

install-norsk install-nynorsk: install-%: %.hash $(CONFIG)
	@. $(CONFIG); \
	  set -x; \
	  [ -d $$LIBDIR ]  ||  (mkdir $$LIBDIR; chmod 755 $$LIBDIR); \
	  cd $$LIBDIR; rm -f $(subst .hash,.aff,$<) $<
	@. $(CONFIG); \
	  set -x; \
	  cp $(subst .hash,.aff,$<) $< $$LIBDIR
	@. $(CONFIG); \
	  set -x; \
	  cd $$LIBDIR; \
	  chmod 644 $(subst .hash,.aff,$<) $<

install-scripts:  inorsk-compwordsmaybe inorsk-hyphenmaybe $(CONFIG)
	@. $(CONFIG); \
	  set -x; \
	  [ -d $$BINDIR ]  ||  (mkdir $$BINDIR; chmod 755 $$BINDIR); \
	  cd $$BINDIR; \
	  rm -f inorsk-compwordsmaybe inorsk-hyphenmaybe
	@. ${CONFIG}; \
	  set -x; \
	  $$INSTALL inorsk-compwordsmaybe inorsk-hyphenmaybe $$BINDIR

$(HASHFILE) nynorsk.hash: %.hash: %.mch %.aff
	rm -f $@
	$(BUILDHASH) $< $(subst .hash,.aff,$@) $@

norsk.aff nynorsk.aff: %.aff: %.aff.in
	sed -e 's/stringchar *î *Î//' -e 's/[îÎ]//g' $< > $@


# Special affix rules to use during the munch phase. These handle the fact that
# the input word list has <root>-xxxx or <root><suffix>-xxxx for
# roots that may be used when forming compounds.
nb_NO.aff.munch nn_NO.aff.munch: %.aff.munch: %.aff
	sed -e 's/\(SFX.*\)-/\1-xxxx/' -e 's/\([^-]\)xxxx/\1-xxxx/g' -e 's/^COMPOUND.*//' $< > $@
	@echo >> $@
	echo 'SFX z N 1 # Get munch to insert z-flag (compound marker)' >> $@
	echo 'SFX z   0 -xxxx  .' >> $@

norsk.aff.null nynorsk.aff.null: %.aff.null: %.aff.in
	sed -e '/^prefixes.*/,//d' $< > $@
	echo -e 'suffixes\nflag *z:\nX X X X X  >   XXXXX' >> $@

# MySpell support (6 Jun 2002, 26 Apr 2004 toralf@procaptura.com)
# *** FIXME: Also generate "TRY" line
# Note: Among other things, the conversion involves a change from upper-case
#       to lower-case. The script must be run under the correct language
#       environment to make sure the case conversion is correct for all
#       characters. 
define ISPELL2MYAFF
	echo "SET ISO8859-1" > $@
	echo "TRY aerndtislogmkpbhfjuvæøåyqxzvcwéèóôôçîAERNDTISLOGMKPBHFJUVÆØÅYQXZVCWÉÈÓÔÔÇ" >> $@
	LANG=nb_NO perl iaff2myaff.pl $< >> $@
endef

nb_NO.aff: norsk.aff
	$(ISPELL2MYAFF)

nn_NO.aff: nynorsk.aff
	$(ISPELL2MYAFF)

nb_NO.dic: $(DICTIONARY)
	wc -l < $< > $@
	cat $< >> $@

nn_NO.dic: nynorsk.mch
	wc -l < $< > $@
	cat $< >> $@

README_%.txt: README.myspell
	cp $< $@

%.zip: %.dic %.aff README_%.txt
	zip $@ $^

# Aspell:
aspell:
	install -d -m 775 $@

aspell/%.dat: aspell-%.info.in
	rm -f $@
	sed -n -e 's/^lang/name/p' -e 's/^doc_encoding/charset/p' $^ > $@
	echo "special \" -*- . -*-" >> $@
	echo "run-together true" >> $@
	echo "soundslike none" >> $@

aspell/Copyright: README.myspell aspell
	cp -f $< $@
	chmod +w $@

aspell/nb.wl: $(DICTIONARY) aspell
	cp -f $< $@

aspell/nn.wl: nynorsk.mch aspell
	cp -f $< $@

aspell/%_affix.dat: %_NO.aff aspell
	cp -f $< $@

# *** Should perhaps try to pick up the following from the actual "aspell-lang" dist
aspell/proc: aspell-proc.pl aspell
	cp -f $< $@

$(foreach l, nb nn, aspell/aspell6-$l-$(ASPELL_VERSION).tar.bz2): aspell/aspell6-%-$(ASPELL_VERSION).tar.bz2 : aspell/%.dat aspell/Copyright aspell/%_affix.dat aspell/%.wl aspell/proc aspell-%.info.in
	rm -f $(dir $@)/info
	sed -e 's/@VERSION@/$(ASPELL_VERSION)/' aspell-$*.info.in > $(dir $@)/info	
	cd $(dir $@); perl proc create;\
	./configure; \
	make $*.cwl; \
	make dist-nogen

$(foreach l, nb nn, aspell6-$l-$(ASPELL_VERSION).tar.bz2): % : aspell/%
	cp -f $< $@


# First of all, create a separate wordlist for each cathegory. It is sorted
# exactly the same way as (other) generated data, as 'join' command will
# otherwise work incorrectly.
# Note:     Do not use pattern ("%") directly in target as it would pick up
#           additional files like norsk.words.sq
$(addprefix ${LANGUAGE}.words.,${CATHEGORIES}): ${LANGUAGE}.words.% : ${LANGUAGE}.words
	sed -e "s/#.*//" -e "s/[[:space:]]*$$//" $< | egrep "$*$$" | sort > $@

# The following ugly code munches a part of the base file, keeping the
# indications of the frequency of the words.  It also removes some
# redundant flags that munchlist does not find.  That part could be
# improved.


# The first pipe produces a list of all words in the % category, with
# each root word followed by one line for each flag containing the
# root word and the flag.  The prefix flags are treated as part of the
# root word, except that there is one line containing just the root
# word (the last bug I catched...) The hyphen character is ignored
# when the list is sorted.  Some redundant flags are also removed.
# Isn't it amazing how much you can do with sed?

# ispell's 'munchlist' does not work very well here. Among other things, it
# will probably fail with a stack overflow on the B dictionary. We therefore
# use the 'munch' utility from MySpell instead; its source code is expected to
# be available on this directory

$(addprefix munch0.,${CATHEGORIES}): munch0.%: ${LANGUAGE}.words.%
	rm -f $@
	wc -l < $< > $@
	sed -e 's/ .*//' -e 's/ \*//' $< >> $@

$(addprefix munch1.,${CATHEGORIES}): munch1.% : munch munch0.% nb_NO.aff.munch
	./$^ 2> /dev/null | tail +2 > $@

$(addprefix munch2.,${CATHEGORIES}): munch2.%: munch1.%
	perl expndflg.pl $< | sort  '-t/' -u +0f -1 +0 > $@


# *** Mulige problemer:
#     /R og /E slettet en del flere steder enn med gammel versjon. Det
#     ser ut for meg som om det er riktig å fjerne flaggene på alle disse
#     stedene.
#     <ord>/ak ekspanderes til <ord>/a og <ord>/k, men *kanskje* er det riktig
#     å beholde <ord>/ak


$(addprefix munch3.,${CATHEGORIES}): munch3.%: unmunch munch2.% nb_NO.aff.munch ${LANGUAGE}.words.%
# This pipe produce a file containing the a line number of munch2 and
# the frequency indicator for that line.  Note that the summation rule
# is not the usual one.
	echo "Write frequency info for munch2.$* to $@";\
	./$< munch2.$* nb_NO.aff.munch 2> /dev/null \
	  | sed -e 's/^[-${CH}]\+ //' \
	  | perl -e '$$n=1; while(<>) { chop($$_); foreach $$w (split/ /, $$_) { print "$$w $$n\n" } $$n++ }' \
	  | sort \
	  | join - ${LANGUAGE}.words.$* \
	  | sed -e 's/\* //' \
	  | cut -d ' ' -f2,3 \
	  | sort -n | perl -e 'while(<>) { chop($$_); \
	     ($$n, $$f)=split(/ /, $$_); \
	     if($$n!=$$p) { print("\n") if($$p); print($$n); $$p=$$n }; \
	     print(" $$f") }; print("\n");' \
	  | awk --source '\
		{i = 1;\
		s = 0;\
		{while (i<NF)\
		{i=i+1;\
		if ($$i<5) {s=s+$$i} else {s = s + exp(exp(($$i+9)/15)-1)}}};\
		if (s<=5) {t=s} else {t=-9+15*log(1+log(s))};\
		print $$1, int(t)}' > $@

munched.%: munch2.% munch3.%
# This pipe produces the file containing the munched list of words,
# where the rare words we don't want are removed.  What we don't want
# depends on the category of words, and is defined at the start of
# this Makefile.
# Note: The below perl expression will print one line of the format
#       <word>/<flag data list> based on "<word>/<flag data>" input lines. It
#       will also collect prefix flags from <flag data>, and ensure each
#       is mentioned only once in <flag data list> - hence the manipulation
#       involving ${PRE}/$pre
	@echo "Collect data from $^ in $@"
	@cat -n munch2.$* \
	  | join - munch3.$* \
	  | cut -d ' ' -f2,3 \
	  | awk --re-interval --source ${CHOOSEFLAG$*} \
	  | uniq \
	  | perl -e 'while(<>) { chop($$_); \
	     ($$w, $$f)=split("/", $$_); \
	     ($$f, $$n)=split(/ /, $$f); \
	     if($$w ne $$p) { print("$${freq}\n") if($$p); print($$w, "/"); $$p=$$w; undef $$pre; undef $$freq};\
	     $$f=~s/[$$pre]//g if($$pre); $$pre.=($$f=~m/([${PRE}]+)/)[0]; print("$$f"); $$freq="$${freq} $$n"};\
	     print("$${freq}\n");' \
	  | awk --source '\
		{i = 1;\
		s = 0;\
		{while (i<NF)\
		{i++;\
		if ($$i<5) {s=s+$$i} else {s = s + exp(exp(($$i+9)/15)-1)}}};\
		if (s<=5) {t=s} else {t=-9+15*log(1+log(s))};\
		print $$1, int(t)}' \
	  | awk --re-interval --source ${CHOOSEROOT$*} \
	  | uniq \
	  > $@

# Here we make the dictionary that is read by the ispell's builhash
# program.  The main difficulty is to delete compound words with
# frequency indicator less than COMPOUNDLIMIT accepted in controlled
# compoundwords mode.

# *All* words, with line numbers
# Note: cat -n <file list> will number files individually (at least on some
#       platforms), so have a seprate cat to "collect files" first.
%.all: forkort.txt $(addprefix munched.,${CATHEGORIES})
	cat $^ | cat -n > $@

# All words with some compound flag, i.e. presumably all words except the
# compunds. (Note that line numbers and frequency indicators are removed here.)
%.root: %.aff %.all
	grep "\/.*[z\\_\`]" $*.all | tr -d '\- 	0-9' > $@

# Hash file for the above
%.root.hash: %.root
	$(BUILDHASH) $< $(AFFIXES) $@

# Candiates for removal: Compounds with freqency indicator smaller than
# COMPOUNDLIMIT.  This could be improved.  One could insist that the
# words forming a word that should be deleted are separated by a
# hyphen at the correct point.  That would complicate things.
%.comp: %.aff %.all
	perl -n -e 's/^\s*//; print $$_ if(m/-/ && !m/\/.*[z\_\`]/ && (split())[2]<${COMPOUNDLIMIT})' $*.all > $@


# Test which of the above words are accepted by ispell when using a dictionary
# containing all words from the orignal list *except* the compounds.
# Pass lines of affix-expanded compounds to ispell -l; this will print words
# that are _NOT_ spelled correctly according to the above mentioned dictionary,
# in the original sequence and separated by newline. Use a special end-of-line
# marker (must *not* be a valid word - "EOL" is used in this case) to allow
# these words top be assembled back into the orignal line organisation.
# Output is line numbers of lines where all the words were accepted, i.e. that
# are empty after the assembly, so they give only whitespace before numbers
# when pasting with original input starting with line no - use match operator
# in perl to print (only) these line numbers.
# *** Match operator is set up so that output list also contains trailing
#     line not for lines that match. Somewhat ugly.

%.rm: %.comp unmunch nb_NO.aff %.root.hash
	cat $< \
	  | tr -d '\-0-9 ' \
	  | unmunch - nb_NO.aff 2>/dev/null \
	  | perl -p -e 's/$$/ -EOL-/' \
	  | $(ISPELL) -l -d ./$*.root.hash \
	  | perl -p -e 's/\n/ /; s/EOL /\n/' \
	  | paste - $<\
	  | perl -n -e 'print (m/^\s*([0-9]+).*(\n)/)' > $@

# Combine numbers of lines to remove (see above) with numbered word list,
# using a "merge sort" on numbers with removal of duplicates. If a line number
# in the wordlist matches a number in the removal list, the wordlist
# entry is considered a duplicate and removed. The removal number will remain,
# but we then remove all lines containing a number only.
# *** TODO: There will be some "compound" entries that didn't fit in in
#           the munching, i.e. that end with xxxx and have no flag that may
#           remove this string; should handle those somehow.

$(DICTIONARY): %.mch : %.rm %.all
	@echo "Removing `cat $< | wc -l` compound root words"
	sort -n -m -s +0 -1 -u $< $*.all \
	  | perl -p -e 's/^[0-9]*\n//; tr /- 	0-9//d' | LANG=nb_NO sort > $@


# Keep some of the  intermediate files from the above process to make
# debugging easier, and because some of the steps take a LONG time
.PRECIOUS: munch1.% munch2.% munch3.% %.comp %.root



# TODO:
# If a rare word lies close to a common word, it might be wise to
# remove it from the dictionary.  One possible way is to use a patched
# version of ispell that tries to find matches for all words, also
# those in the dictionary.  Then find the frequency for those words,
# and produce a closeness index from this.  This shouldn't be too hard
# to implement.  The patch for the required ispell flag (-s) is only
# a few lines.  The trickery to use it is more.


munch0.nynorsk: words.nynorsk
	rm -f $@
	wc -l < $< > $@
	sed -e 's/ .*//' -e 's/ \*//' $< >> $@

# Note: Need to remove line count from munch output and re-insert later, since
#       the following command may remove some lines
nynorsk.mch: munch munch0.nynorsk nn_NO.aff.munch
	./$^ 2> /dev/null | tail +2 | perl -p -e 'tr /- 	0-9//d'\
	 | LANG=nn_NO sort > $@

words.norsk: $(addprefix norsk.words.,B A N D S)
# Here is a rule to make a list of the most common Norwegian words.
# Which words to include is defined at the top of this Makefile.  Such
# a file is needed to make the word competition work for Norwegian.
# Stupid spell checkers might also want such a file.
	cat $^ \
	  | tr -d '*' \
	  | awk --re-interval --source ${WORDSFILTER} \
	  | tr -d '\"-' \
	  | grep -v 'xxxx' \
	  | LANG=nb_NO sort -f \
	  > $@

words.nynorsk: norsk.words
# No frequency information availiable yet for nynorsk.  So all we can
# do is poick the words marked with a star.
	grep -v '^\#' $<\
	  | grep '\*' \
	  | sed -e 's/ .*//' \
	  | LANG=nn_NO sort -f \
	  > $@ 

# Here is a target that picks words with given frequency.
words.${LANGUAGE}.%: $(addprefix ${LANGUAGE}.words.,B A N D S)
	cat $^\
	  | grep  ' $* ' \
	  | sed -e 's/ .*//' \
	  | tr -d - \
	  | grep -v 'xxxx' \
	  | LANG=nb_NO sort -f \
	  > $@

dist: ispell-$(LANGUAGE)-$(VERSION).tar.gz
	rm -rf $(LANGUAGE)


ispell-$(LANGUAGE)-$(VERSION).tar.gz: $(LANGUAGE)
	tar cvf - $< | gzip > $@

$(LANGUAGE):
	install -d -m 775 $@
	install -m 444 $(DISTFILES) $@

clean:
	rm -f core *.hash *.stat *.cnt munch[0123].* \
	      $(addprefix ${LANGUAGE}.words.,${CATHEGORIES})\
	      ${DICTIONARY} ny${DICTIONARY} n[bn]*.dic\
	      ${AFFIXES} ny${AFFIXES} n[bn]*.aff\
	      ${AFFIXES}.munch ny${AFFIXES} n[bn]*.aff.munch\
	      *.comp[123].* munched.* core* munch

#	The following target is used in the English makefile, and is
#	required to be present in all other language Makefiles as
#	well, even though it doesn't have to do anything in those
#	directories.
#
kitclean:

#
#	The following target is used in the English makefile, and is
#	required to be present in all other language Makefiles as
#	well, even though it doesn't have to do anything in those
#	directories.
#
dictclean:
	rm -f $(addprefix munch*.,${CATHEGORIES}) \
	      words.${LANGUAGE}

