#-*- tab-width: 8; fill-column: 70 -*-

# Makefile for the TeX-patterns related stuff.

# The purpose of this script is to generate hyphenation patterns for
# use with TeX based on a dictionary hyphenated at compound points and
# a pattern file which handels non-compound words.

# The size of the patterns generated is controlled by the parameters
# given to Patgen and how many words one builds the patterns from.
# The default setting makes large sets of patterns.  There patterns
# hyphenates almost every word in the dictionary correctly.  Compound
# words not in the dictionary might be hyphenated incorrectly.

# It is difficult to tell if such large sets of patterns hyphenates
# words _not_ in the dictionary much better than a smaller set of
# patterns.  The main reason is that it is difficult to produce a
# sensible list of compound words not in the dictionary.  However, I
# prefer to make things right for all words in the dictionary.
# Compound words not in the dictionary can be marked with "- at their
# compound points to secure good hyphenation.

# It takes two days to make nohyph4.tex on a pentium 166 machine with
# the default setup.  There is no point in doing that unless you
# improve the norsk.single.pat or changes the parameters in the script
# in some way.  It you do serious work, please let me know!

# You need a patgen with enough capacity.  The following values in
# patgen.ch works:

# @!trie_size=262143;
# @!triec_size=131071;
# @!max_ops=10200;
# @!max_val=10;
# @!max_dot=20;
# @!max_len=70;

# The easiest way to get such a Patgen program is to compile teTeX
# from the sources, change the patgen.ch file and recompile.

# If you try to read this script, be warned.  I am a die hard sed
# programmer.

SHELL = /bin/bash
PATGEN = ./patgen

# The characters used in the Norwegian language.
UCH=A-ZÆØÅÉÈÔÒÇ
LCH=a-zæøåéèôòç
CH=${LCH}${UCH}

# Regular expression matching the words with spesial casing, e.g. UiO
# etc.  Those words should probably never be hyphenated.
NOHYPHWORDS=^[${UCH}][${CH}]*[${UCH}]

# Files are encoded in iso-latin-1-unix
export LC_CTYPE = LATIN1

.DELETE_ON_ERROR:

all: nohyph1.tex nohyph4.tex

# Configure what words you want to make your patterns from by editing
# the tr table below.  This is a map from the frequency group each
# word belongs to to the weight Patgen should put on each hyphenation
# point in this word.  The old-fashioned way is to use tr[i]=1 for
# every i.  I think this feature is most useful if one wants to make a
# small set of patterns which only fails on rare words.  You can also
# assign different weights on words depending on the kind of word, but
# one has to stop somewhere.

# The words from nynorsk are all given a spesific weight, since no
# frequenzy information is availiable.  The *-hacking below does that.

hyphlist1.txt.gz: ../norsk.words
	grep -v -e 'zyzyzy' $< \
	  | grep -e '${NOHYPHWORDS}' \
	  > $(subst .txt.gz,.tmp,$@)
	grep -v -e 'zyzyzy' $< \
	  | grep -v -e '${NOHYPHWORDS}' \
	 >> $(subst .txt.gz,.tmp,$@)
	sed -e 's/\(xxxx\|yyyy\|zyzyzy\)//' \
	    -e 's/ \*$$/ 1 Y/' \
	    -e 's/ \*//' $(subst .txt.gz,.tmp,$@) \
	  | awk --source 'BEGIN \
			  {tr[0]  = 1; tr[17] = 5; \
	                   tr[1]  = 1; tr[18] = 5; \
	                   tr[2]  = 1; tr[19] = 5; \
	                   tr[3]  = 1; tr[20] = 6; \
	                   tr[4]  = 2; tr[21] = 6; \
	                   tr[5]  = 2; tr[22] = 7; \
	                   tr[6]  = 2; tr[23] = 7; \
	                   tr[7]  = 2; tr[24] = 7; \
	                   tr[8]  = 3; tr[25] = 8; \
	                   tr[9]  = 3; tr[26] = 8; \
	                   tr[10] = 3; tr[27] = 8; \
	                   tr[11] = 4; tr[28] = 8; \
	                   tr[12] = 4; tr[29] = 9; \
	                   tr[13] = 4; tr[30] = 9; \
			   tr[14] = 4; tr[31] = 9; \
			   tr[15] = 5; tr[32] = 9; \
			   tr[16] = 5; tr[33] = 9} \
	                  {if (tr[$$2] > 0) {print $$1, tr[$$2], $$3}}' \
	  | gzip -9 \
	  > $@
	rm $(subst .txt.gz,.tmp,$@)

hyphlist2.txt.gz: hyphlist1.txt.gz  pat19.txt no.tra
	@echo "Hyphenating word components in the source file"
	-gzip -d < hyphlist1.txt.gz \
	  | grep '${NOHYPHWORDS}' \
	  | sed -e 's/ .*//' \
	  > $(subst .txt.gz,.nohyph,$@)
	@echo "Making file for patgen"
	gzip -d < $< \
	  | grep -v -e '${NOHYPHWORDS}' \
	  | sed -e 's/ .*//' \
	        -e 's/[*]/-/g' \
	        -e 's/\.//g' \
	        -e 's/^\(.*\)$$/\1 zzz/' \
	        -e 's/-/ /g' \
	        -e 's/\"\(.\)\1/\1\1 yyy \1/g' \
	  | tr ' ' '\n' \
	  > $(subst .txt.gz,.tmp,$@)

#	Hyphenate each word component with patterns generated from the
# 	source file

	@echo "Running patgen"
#	When providing a hyph_start > hyph_finish, patgen will not
#	generate any patterns, but only hyphenate the given list of
#	words with the given patterns. Note however that, at least
#	with my version of patgen, it does not work as expected when
#	the input words already contain hyphens, which is the case for
#	example in the `diff.nohyph%' rule below. The problem is that
#	the hyphens will not be marked with '*' when found by the
#	patterns.
	echo -e 2 1'\n'y | $(PATGEN) $(subst .txt.gz,.tmp,$@) pat19.txt /dev/null no.tra

	@echo "Parsing Patgen output"
	sed -e 's/z\.*z\.*z/î/' \
	    -e 's/\./-/g' \
	    -e 's/y\.*y\.*y/\"/g' pattmp \
	  | sed -e '$$ p' -e '$$ N' -e ':START' \
	        -e '$$ ! N' \
	        -e 's/\([^î]\)\n\([^î]\)/\1--\2/g' \
	        -e 't START' -e P -e D \
	  | sed -e '/^î$$/ D' -e 's/\(.\)\1--\"--/\"\1/g' \
	 >> $(subst .txt.gz,.nohyph,$@)
	@echo "Writing $@"
	gzip -d < $< \
	 | cut -d ' ' -f 2,3 \
	 | paste -d ' ' $(subst .txt.gz,.nohyph,$@) - \
	 | sed -e 's/sykepenge/syke-penge/' \
	       -e 's/sykepleie/syke-pleie/' \
	 | gzip -9 \
	 > $@
	rm $(subst .txt.gz,.tmp,$@) $(subst .txt.gz,.nohyph,$@) pattmp

# Result: barnehage-assistent --> barne-hage--assistent


hyphlist3.txt.gz: hyphlist2.txt.gz no.tra1 norsk.single.pat
	@echo "Hyphenating each word component with the singlewords patterns"
	-gzip -d < $< \
	  | grep -e '${NOHYPHWORDS}' \
	  | sed -e 's/ .*//' \
	  > $(subst .txt.gz,.nohyph,$@)
	echo "Making file for patgen"
	gzip -d < $< \
	  | grep -v -e '${NOHYPHWORDS}' \
	  | sed -e 's/ .*//' \
	        -e 's/[*]/-/g' \
	        -e 's/\.//g' \
	        -e 's/^\(.*\)$$/\1 zzz/' \
	        -e 's/--/ ddd /g' \
	        -e 's/-/ /g' \
	        -e 's/\"\(.\)\1/\1\1 yyy \1/g' \
	  | tr ' ' '\n' \
	  > $(subst .txt.gz,.tmp,$@)

#	Hyphenate each word component with the patterns for single words.

	@echo "Running patgen"
	echo -e 2 1'\n'y | \
	$(PATGEN) $(subst .txt.gz,.tmp,$@) norsk.single.pat /dev/null no.tra1

	@echo "Parsing Patgen output"
	sed -e 's/z\.*z\.*z/î/' \
	    -e 's/d\.*d\.*d/â/' \
	    -e 's/\./-/g' \
	    -e 's/y\.*y\.*y/\"/g' pattmp \
	  | sed -e '$$ p' -e '$$ N' -e ':START' \
	        -e '$$ ! N' \
	        -e 's/\([^î]\)\n\([^î]\)/\1--\2/g' \
	        -e 't START' -e P -e D \
	  | sed -e 's/--â--/---/g' \
	  | sed -e '/^î$$/ D' -e 's/\(.\)\1--\"--/\"\1/g' \
	 >> $(subst .txt.gz,.nohyph,$@)

	@echo "Writing $@"
	gzip -d < hyphlist1.txt.gz \
	 | cut -d ' ' -f 2,3 \
	 | paste -d ' ' $(subst .txt.gz,.nohyph,$@) - \
	 | gzip -9 \
	 > $@

	rm $(subst .txt.gz,.tmp,$@) $(subst .txt.gz,.nohyph,$@) pattmp

# Result: barne-hage--assistent --> bar-ne--hage---as-si-stent

# Here we mark the number og hyphen points near the composition of two
# words with a question mark, about 6% of all hyphen points.  I think
# this removes/marks some very ugly hyphenation points.  Here is also
# the place to remove hyphenation points after the first character if
# you want that. In this case using no.tra instead og no.tra1 gives a
# slightly smaller set of patterns.

# The most radical line in the sed-script below is line 4.  Here is a
# list of examples and how many words each pattern matches.

# Line 1 dagligva-rekjede   3293  0.1%
# Line 2 ambassa-deråden   14966  0.7%     (contains line 1)
# Line 3 lønnsu-likhet       563  0.0%
# Line 4 bar-nehage       112119  5.7%
# Line 5 dansemo-ro         4521  0.2%
# Line 6 ha-re              1265  0.0%
# Line 7 di-ettillegget       13  0.0%


# The following note applies to multiple level hyphenation, a future
# feature in TeX.

# This could be improved in the following way: One could mark (with a
# question mark) the not so good hyphen points in norsk.singlewords,
# and maybe add the modern hyphen points before the suffix (gutt-en)
# Espesially good hyphen points could also be marked, and marked with
# --.  Only 36000 hyphen points is in this class; there should be
# more.


hyphlist4.txt.gz: hyphlist3.txt.gz
	@echo "Removing some ugly hyphenation points"
	gzip -d < $< \
	  | sed \
	    -e 's/\(---*[${CH}]\{1,2\}\)-\([${CH}]\{1,2\}---*\)/\1\?\2/g'\
	    -e 's/\(-[${CH}]\{1,2\}\)-\([${CH}]\{2\}---*\)/\1\?\2/g' \
	    -e 's/\(---*[${CH}]\)-/\1\?/g' \
	    -e 's/\([${CH}]\{2\}\)-\([${CH}]\{2\}---*\)/\1\?\2/g' \
	    -e 's/\(\(\".\|---*\)[${CH}]\{2\}\)-\([${CH}]\{2\} \)/\1\?\3/g'\
	    -e 's/^\([${CH}]\{1,2\}\)-\([${CH}]\{1,2\} \)/\1\?\2/g' \
	    -e 's/\([^-]\)-\([${CH}]\"\)/\1\?\2/g' \
	  | gzip -9 > $@

# Do some counting

	@: gzip -l $@ $< \
	   | grep hyphlist \
	   | cut -d ' ' -f5 \
	   | tr '\n' ' ' \
	   | sed -e 's/ $$/]/' -e 's/ /-/' \
	         -e 's/^\(.*\)/echo $$[\1 hyphen points removed/' \
	   | ${SHELL}


# This is the extended hyphenation list for an extended TeX with
# multi-level hyphenation.  This enables us to assign different
# penalties for different hyphenation points.  This is especially
# useful for languages with many compound words.  It requires that
# Mathias Clasens change file is applied to patgen.
#
# The separation in classes can be improved, mainly by reworking the
# singlewords patterns to handle multiple levels.  However, I don't
# know how this can be done fast.  The rule for hyphlist3.txt.gz has
# to be changed to support this.
#
# I use five classes:
#
# 4. The compound points found in the dictionary
# 3. The compound points inserted by the patterns for hyphlist1
# 2. The hyphens inserted by the singlewords patterns, except those
#    flagged in hyphlist4
# 1. The hyphens flagged in hyphlist4.
# 0. Hyphenation is illegal.
#
# A simpler layout would map class 3 to 2 and delete class one.
#
# The original hyphenation algorithm assigns a number to each
# inter-letter position.  If this number modulo 2 is 1, hyphenation is
# allowed, otherwise not.  The generalization used here is to reduce
# modulo the number of hyphen classes, and the rest indicates the
# hyphen class of that point.
#
# Another approach would be to have sets of patterns covering an
# increasing number of possible hyphens, and make TeX try and typeset
# each paragraph with each set of patterns until it succeeds.  TeX
# uses a two-pass system today.  This approach has been considered by
# Clasen, but has not been implemented yet, and it is difficult to say
# which idea is the best.

hyphliste.txt.gz:  hyphlist4.txt.gz
	@echo "Making extended hyphen list (four levels)"
	gzip -d < hyphlist4.txt.gz \
	  | sed -e 's/---/-4/g' \
	        -e 's/--/-3/g' \
	        -e 's/-\([^1-9]\)/-2\1/g' \
	        -e 's/?/-/g' \
	  | gzip -9 \
	  > hyphliste.txt.gz
	rm -f hyphliste.patinput

# Here we make the files read by Patgen.  The only problem is the
# 'o"ppussing' words.  An example: The word 'nordka"pplatået' is
# hyphenated nord-kapp-pla-tå-et', but for TeXnical reasons the
# components 'nord-ka' and 'pla-tå-et' must be handeled correctly by
# the patterns.

# It is important that the line numbers does not change, so we can
# find the frequency and type of word from hyphlist1.txt.gz.  So we
# first take all words and removes ", to try to avoid hyphenations
# like `op-pussing' (which could happen if the word is not coded
# correctly), and add the components of the spesial words at last.  We
# don't find the file mark of those components, unfortunately.

%.patinput: %.txt.gz
	gzip -d < $(subst .patinput,.txt.gz,$@) \
	  | sed -e 's/^\(.*\)[ 	]\([0-9]\).*/\2\1/' \
		-e 's/\"//g' \
		-e 's/-\(.\)$$/\1/' \
	  | tr  -d '?' \
	  > $@
	gzip -d < $(subst .patinput,.txt.gz,$@) \
	  | grep -e '\"' \
	  | sed -e 's/^\(.*\)[ 	]\([0-9]\).*/\2\1/' \
		-e ':START' \
		-e 's/\([1-9]\)\(.*\)\"./\1\2 \1/' \
		-e 't START' \
	  | tr ' ' '\n' \
	  | tr -d '?' \
	  >> $@

# Rule to get the wrong hyphenations from the file pattmp made after
# each patgen run.  The tricky part is to sort the words on the word
# cathegory (useful for me when debuging).

feil.%: pattmp
	gzip -d < hyphlist1.txt.gz \
	  | cut -d ' ' -f 3 \
	  | paste -d ' ' pattmp - \
	  | grep [.-] \
	  | sed -e 's/^\([^0-9]\)/1\1/' \
	        -e 's/^\([0-9]\)\([^ ]* \)/\2\1 /' \
	  | gzip -9 \
	  > $@


feils.%: pattmp
	grep '[.-]' pattmp | gzip -9 > $@

# The translate files needed by Patgen.
no.tra:
	echo -e ' 2 2\n a A\n b B\n c C\n ç Ç\n d D\n e E\n é É\n è È\n ê Ê\n f F\n g G\n h H\n i I\n j J\n k K\n l L\n m M\n n N\n o O\n ô Ô\n ó Ó\n ò Ò\n p P\n q Q\n r R\n s S\n t T\n u U\n v V\n w W\n x X\n y Y\n z Z\n æ Æ \n ø Ø\n å Å' > no.tra

no.tra1: no.tra
	sed -e 's/ 2 2/ 1 2/' no.tra > no.tra1

no.trae: no.tra
	sed -e 's/ 2 2/ 1 2.-*5/' no.tra > no.trae

# Below the patterns based directly on the hyphenation from the
# dictionaries are made.  Those are used to hyphenate some more words
# by the target hyphlist2.txt.gz, such that 'barnehage-assistent'
# becomes 'barne-hage-assistent' since 'barne-hage' is hyphenated as
# it is in the dictionary.

# The numbers after echo are the parameters given to Patgen.  If you
# change these in a clever way, you can generate smaller sets of
# patterns doing the same job.


# A first course in TeX patterns and patgen parameters:

# As you know, TeX patterns tell TeX where it can hyphenate words.  A
# pattern a1b2c means that it is legal to hyphenate between a and bc
# (since 1 is odd) and illegal to hyphenate between ab and c (since 2
# is even). An additional pattern ab3cd means that it is legal to
# hyphenate between ab and c if c is followed by d, and ab4cde overrides
# this rule if d is followed by e.  Get it?

# Patgen reads a list of hyphenated words generates patterns with 1's
# (first level), then adds 2's and so on.  It is not hard to see that
# this is a heavy job, if not deep magic.

# The echo -e 'x x\n y1 y2\n z1 z2 z3' below is where patgen gets its
# parameters from.  x is the pattern level.  The numbers y1 and y2
# indicates minimal and maximal pattern lengths.  As in the above
# example, it is wise to let the maximal length increase with the
# level.  The numbers z1, z2 and z3 are good weight, bad weight and
# thershold.  Assume one pattern does the right thing in a1 cases and
# the wrong thing in a2 cases.  It is included if a1*z1 - a2*z2 >= z3.
# The numbers defined in the awk script when making hyphlist1
# indicates the weight a particular word has.

# Now you are ready to try to make small and effective sets of
# patterns.  Edit the Patgen parameters and play on.  In my
# experience, the parameters doesn't matter too much though, at least
# if you are searching for `perfect' patterns.


pat0.txt:
	rm -f pat0.txt
	touch pat0.txt

pat11.txt: pat0.txt hyphlist1.txt.gz no.tra
	${MAKE} hyphlist1.patinput
	echo -e '1 1\n2 5\n1 2 20\nn' | \
	$(PATGEN) hyphlist1.patinput $< $@ no.tra

pat12.txt: pat11.txt hyphlist1.txt.gz no.tra
	${MAKE} hyphlist1.patinput
	echo -e '2 2\n2 6\n1 2 12\nn' | \
	$(PATGEN) hyphlist1.patinput $< $@ no.tra

pat13.txt: pat12.txt hyphlist1.txt.gz no.tra
	${MAKE} hyphlist1.patinput
	echo -e '3 3\n2 6\n1 2 10\nn' | \
	$(PATGEN) hyphlist1.patinput $< $@ no.tra

pat14.txt: pat13.txt hyphlist1.txt.gz no.tra
	${MAKE} hyphlist1.patinput
	echo -e '4 4\n2 7\n1 2 7\ny' | \
	$(PATGEN) hyphlist1.patinput $< $@ no.tra
	${MAKE} feil.$@.gz

pat15.txt: pat14.txt hyphlist1.txt.gz no.tra
	${MAKE} hyphlist1.patinput
	echo -e '5 5\n2 8\n2 4 9\ny' | \
	$(PATGEN) hyphlist1.patinput $< $@ no.tra
	${MAKE} feil.$@.gz

pat16.txt: pat15.txt hyphlist1.txt.gz no.tra
	${MAKE} hyphlist1.patinput
	echo -e '6 6\n2 10\n1 2 4\ny' | \
	$(PATGEN) hyphlist1.patinput $< $@ no.tra
	${MAKE} feil.$@.gz

pat17.txt: pat16.txt hyphlist1.txt.gz no.tra
	${MAKE} hyphlist1.patinput
	echo -e '7 7\n2 12\n1 2 2\ny' | \
	$(PATGEN) hyphlist1.patinput $< $@ no.tra
	${MAKE} feil.$@.gz

pat18.txt: pat17.txt hyphlist1.txt.gz no.tra
	${MAKE} hyphlist1.patinput
	echo -e '8 8\n2 15\n1 1 1\ny' | \
	$(PATGEN) hyphlist1.patinput $< $@ no.tra
	${MAKE} feil.$@.gz

pat19.txt: pat18.txt hyphlist1.txt.gz no.tra
	${MAKE} hyphlist1.patinput
	echo -e '9 9\n2 15\n2 2 1\ny' | \
	$(PATGEN) hyphlist1.patinput $< $@ no.tra
	${MAKE} feil.$@.gz
	rm hyphlist1.patinput

# This generates patterns which allows more hyphenation points.  It
# generates a bit smaller pattern file than those above, since one
# doesn't pay attention to the fact that for example
# `barne-hageassistent' looks a bit ugly.  Still probably only good
# for ragged text.


pat21.txt: pat0.txt hyphlist2.txt.gz no.tra
	${MAKE} hyphlist2.patinput
	echo -e '1 1\n2 5\n1 2 20\nn' | \
	$(PATGEN) hyphlist2.patinput $< $@ no.tra

pat22.txt: pat21.txt hyphlist2.txt.gz no.tra
	${MAKE} hyphlist2.patinput
	echo -e '2 2\n2 6\n1 2 12\nn' | \
	$(PATGEN) hyphlist2.patinput $< $@ no.tra

pat23.txt: pat22.txt hyphlist2.txt.gz no.tra
	${MAKE} hyphlist2.patinput
	echo -e '3 3\n2 6\n1 2 10\nn' | \
	$(PATGEN) hyphlist2.patinput $< $@ no.tra

pat24.txt: pat23.txt hyphlist2.txt.gz no.tra
	${MAKE} hyphlist2.patinput
	echo -e '4 4\n2 7\n1 2 7\ny' | \
	$(PATGEN) hyphlist2.patinput $< $@ no.tra
	${MAKE} feil.$@.gz

pat25.txt: pat24.txt hyphlist2.txt.gz no.tra
	${MAKE} hyphlist2.patinput
	echo -e '5 5\n2 8\n2 4 9\ny' | \
	$(PATGEN) hyphlist2.patinput $< $@ no.tra
	${MAKE} feil.$@.gz

pat26.txt: pat25.txt hyphlist2.txt.gz no.tra
	${MAKE} hyphlist2.patinput
	echo -e '6 6\n2 10\n1 2 4\ny' | \
	$(PATGEN) hyphlist2.patinput $< $@ no.tra
	${MAKE} feil.$@.gz

pat27.txt: pat26.txt hyphlist2.txt.gz no.tra
	${MAKE} hyphlist2.patinput
	echo -e '7 7\n2 12\n1 2 2\ny' | \
	$(PATGEN) hyphlist2.patinput $< $@ no.tra
	${MAKE} feil.$@.gz

pat28.txt: pat27.txt hyphlist2.txt.gz no.tra
	${MAKE} hyphlist2.patinput
	echo -e '8 8\n2 15\n1 1 1\ny' | \
	$(PATGEN) hyphlist2.patinput $< $@ no.tra
	${MAKE} feil.$@.gz

pat29.txt: pat28.txt hyphlist2.txt.gz no.tra
	${MAKE} hyphlist2.patinput
	echo -e '9 9\n2 15\n2 2 1\ny' | \
	$(PATGEN) hyphlist2.patinput $< $@ no.tra
	${MAKE} feil.$@.gz
	rm hyphlist2.patinput


# Here we generate the standard patterns used by TeX.  The trick is to
# hyphenate each component of a word with the old an relatively
# managable patterns.  The patterns file become big, but it will
# seldom let you down.  You might want to experiment with the values
# given to patgen to make your own patterns, even if DEK would not
# like it. (A TeX document should be formatted exactly the same way
# today and in fifty years on any machine.  A sweet dream, but it is
# just not going to happen.)


pat41.txt: pat0.txt hyphlist4.txt.gz no.tra1
	${MAKE} hyphlist4.patinput
	echo -e '1 1\n2 4\n1 2 20\nn' | \
	$(PATGEN) hyphlist4.patinput $< $@ no.tra1

pat42.txt: pat41.txt hyphlist4.txt.gz no.tra1
	${MAKE} hyphlist4.patinput
	echo -e '2 2\n2 4\n1 2 15\nn' | \
	$(PATGEN) hyphlist4.patinput $< $@ no.tra1

pat43.txt: pat42.txt hyphlist4.txt.gz no.tra1
	${MAKE} hyphlist4.patinput
	echo -e '3 3\n2 5\n1 2 12\nn' | \
	$(PATGEN) hyphlist4.patinput $< $@ no.tra1

pat44.txt: pat43.txt hyphlist4.txt.gz no.tra1
	${MAKE} hyphlist4.patinput
	echo -e '4 4\n2 6\n3 5 13\ny' | \
	$(PATGEN) hyphlist4.patinput $< $@ no.tra1
	${MAKE} feil.$@.gz

pat45.txt: pat44.txt hyphlist4.txt.gz no.tra1
	${MAKE} hyphlist4.patinput
	echo -e '5 5\n2 7\n3 5 12\ny' | \
	$(PATGEN) hyphlist4.patinput $< $@ no.tra1
	${MAKE} feil.$@.gz

pat46.txt: pat45.txt hyphlist4.txt.gz no.tra1
	${MAKE} hyphlist4.patinput
	echo -e '6 6\n2 8\n2 3 4\ny' | \
	$(PATGEN) hyphlist4.patinput $< $@ no.tra1
	${MAKE} feil.$@.gz

pat47.txt: pat46.txt hyphlist4.txt.gz no.tra1
	${MAKE} hyphlist4.patinput
	echo -e '7 7\n2 9\n1 2 2\ny' | \
	$(PATGEN) hyphlist4.patinput $< $@ no.tra1
	${MAKE} feil.$@.gz

pat48.txt: pat47.txt hyphlist4.txt.gz no.tra1
	${MAKE} hyphlist4.patinput
	echo -e '8 8\n2 9\n1 1 1\ny' | \
	$(PATGEN) hyphlist4.patinput $< $@ no.tra1
	${MAKE} feil.$@.gz

pat49.txt: pat48.txt hyphlist4.txt.gz no.tra1
	${MAKE} hyphlist4.patinput
	echo -e '9 9\n2 10\n1 2 1\ny' | \
	$(PATGEN) hyphlist4.patinput $< $@ no.tra1
	${MAKE} feil.$@.gz
	rm hyphlist4.patinput

# Here comes the calls to the extended patgen.  One could generate
# patterns with only two hyphenation classes too.  I don't know if
# those are considerably smaller yet.  This takes a LONG time, and is
# purely experimental, and one needs Mathias Clasens patches to TeX to
# be able to use the patterns for typesetting.

pate1.txt: pat0.txt hyphliste.txt.gz no.trae
	${MAKE} hyphliste.patinput
	echo -e '1 1\n2 4\n1 2 20\ny' | \
	patgen-ext hyphliste.patinput $< $@ no.trae
	${MAKE} feil.$@.gz

pate2.txt: pate1.txt hyphliste.txt.gz no.trae
	${MAKE} hyphliste.patinput
	echo -e '2 2\n2 4\n1 2 20\ny' | \
	patgen-ext hyphliste.patinput $< $@ no.trae
	${MAKE} feil.$@.gz

pate3.txt: pate2.txt hyphliste.txt.gz no.trae
	${MAKE} hyphliste.patinput
	echo -e '3 3\n2 4\n1 2 20\ny' | \
	patgen-ext hyphliste.patinput $< $@ no.trae
	${MAKE} feil.$@.gz

pate4.txt: pate3.txt hyphliste.txt.gz no.trae
	${MAKE} hyphliste.patinput
	echo -e '4 4\n2 5\n1 2 20\ny' | \
	patgen-ext hyphliste.patinput $< $@ no.trae
	${MAKE} feil.$@.gz

pate5.txt: pate4.txt hyphliste.txt.gz no.trae
	${MAKE} hyphliste.patinput
	echo -e '5 5\n2 4\n1 2 15\ny' | \
	patgen-ext hyphliste.patinput $< $@ no.trae
	${MAKE} feil.$@.gz

pate6.txt: pate5.txt hyphliste.txt.gz no.trae
	${MAKE} hyphliste.patinput
	echo -e '6 6\n2 5\n1 2 18\ny' | \
	patgen-ext hyphliste.patinput $< $@ no.trae
	${MAKE} feil.$@.gz

pate7.txt: pate6.txt hyphliste.txt.gz no.trae
	${MAKE} hyphliste.patinput
	echo -e '7 7\n2 5\n1 2 15\ny' | \
	patgen-ext hyphliste.patinput $< $@ no.trae
	${MAKE} feil.$@.gz

pate8.txt: pate7.txt hyphliste.txt.gz no.trae
	${MAKE} hyphliste.patinput
	echo -e '8 8\n2 6\n1 2 15\ny' | \
	patgen-ext hyphliste.patinput $< $@ no.trae
	${MAKE} feil.$@.gz

pate9.txt: pate8.txt hyphliste.txt.gz no.trae
	${MAKE} hyphliste.patinput
	echo -e '9 9\n2 6\n1 2 12\ny' | \
	patgen-ext hyphliste.patinput $< $@ no.trae
	${MAKE} feil.$@.gz

pate10.txt: pate9.txt hyphliste.txt.gz no.trae
	${MAKE} hyphliste.patinput
	echo -e '10 10\n2 7\n3 5 13\ny' | \
	patgen-ext hyphliste.patinput $< $@ no.trae
	${MAKE} feil.$@.gz

pate11.txt: pate10.txt hyphliste.txt.gz no.trae
	${MAKE} hyphliste.patinput
	echo -e '11 11\n2 7\n1 2 7\ny' | \
	patgen-ext hyphliste.patinput $< $@ no.trae
	${MAKE} feil.$@.gz

pate12.txt: pate11.txt hyphliste.txt.gz no.trae
	${MAKE} hyphliste.patinput
	echo -e '12 12\n2 7\n1 2 7\ny' | \
	patgen-ext hyphliste.patinput $< $@ no.trae
	${MAKE} feil.$@.gz

pate13.txt: pate12.txt hyphliste.txt.gz no.trae
	${MAKE} hyphliste.patinput
	echo -e '13 13\n2 7\n1 2 7\ny' | \
	patgen-ext hyphliste.patinput $< $@ no.trae
	${MAKE} feil.$@.gz

pate14.txt: pate13.txt hyphliste.txt.gz no.trae
	${MAKE} hyphliste.patinput
	echo -e '14 14\n2 7\n1 2 7\ny' | \
	patgen-ext hyphliste.patinput $< $@ no.trae
	${MAKE} feil.$@.gz

pate15.txt: pate14.txt hyphliste.txt.gz no.trae
	${MAKE} hyphliste.patinput
	echo -e '15 15\n2 8\n1 2 5\ny' | \
	patgen-ext hyphliste.patinput $< $@ no.trae
	${MAKE} feil.$@.gz

pate16.txt: pate15.txt hyphliste.txt.gz no.trae
	${MAKE} hyphliste.patinput
	echo -e '16 16\n2 8\n1 2 5\ny' | \
	patgen-ext hyphliste.patinput $< $@ no.trae
	${MAKE} feil.$@.gz

pate17.txt: pate16.txt hyphliste.txt.gz no.trae
	${MAKE} hyphliste.patinput
	echo -e '17 17\n2 8\n1 2 5\ny' | \
	patgen-ext hyphliste.patinput $< $@ no.trae
	${MAKE} feil.$@.gz

pate18.txt: pate17.txt hyphliste.txt.gz no.trae
	${MAKE} hyphliste.patinput
	echo -e '18 18\n2 8\n1 2 5\ny' | \
	patgen-ext hyphliste.patinput $< $@ no.trae
	${MAKE} feil.$@.gz

pate19.txt: pate18.txt hyphliste.txt.gz no.trae
	${MAKE} hyphliste.patinput
	echo -e '19 19\n2 8\n1 2 5\ny' | \
	patgen-ext hyphliste.patinput $< $@ no.trae
	${MAKE} feil.$@.gz

pate20.txt: pate19.txt hyphliste.txt.gz no.trae
	${MAKE} hyphliste.patinput
	echo -e '20 20\n2 8\n1 2 5\ny' | \
	patgen-ext hyphliste.patinput $< $@ no.trae
	${MAKE} feil.$@.gz

pate21.txt: pate20.txt hyphliste.txt.gz no.trae
	${MAKE} hyphliste.patinput
	echo -e '21 21\n2 9\n1 2 4\ny' | \
	patgen-ext hyphliste.patinput $< $@ no.trae
	${MAKE} feil.$@.gz
pate22.txt: pate21.txt hyphliste.txt.gz no.trae
	${MAKE} hyphliste.patinput
	echo -e '22 22\n2 9\n1 2 4\ny' | \
	patgen-ext hyphliste.patinput $< $@ no.trae
	${MAKE} feil.$@.gz
pate23.txt: pate22.txt hyphliste.txt.gz no.trae
	${MAKE} hyphliste.patinput
	echo -e '23 23\n2 9\n1 2 4\ny' | \
	patgen-ext hyphliste.patinput $< $@ no.trae
	${MAKE} feil.$@.gz
pate24.txt: pate23.txt hyphliste.txt.gz no.trae
	${MAKE} hyphliste.patinput
	echo -e '24 24\n2 10\n1 2 4\ny' | \
	patgen-ext hyphliste.patinput $< $@ no.trae
	${MAKE} feil.$@.gz
pate25.txt: pate24.txt hyphliste.txt.gz no.trae
	${MAKE} hyphliste.patinput
	echo -e '25 25\n2 10\n1 2 4\ny' | \
	patgen-ext hyphliste.patinput $< $@ no.trae
	${MAKE} feil.$@.gz
pate26.txt: pate25.txt hyphliste.txt.gz no.trae
	${MAKE} hyphliste.patinput
	echo -e '26 26\n2 10\n1 2 3\ny' | \
	patgen-ext hyphliste.patinput $< $@ no.trae
	${MAKE} feil.$@.gz

pate27.txt: pate26.txt hyphliste.txt.gz no.trae
	${MAKE} hyphliste.patinput
	echo -e '27 27\n2 10\n1 2 3\ny' | \
	patgen-ext hyphliste.patinput $< $@ no.trae
	${MAKE} feil.$@.gz

pate28.txt: pate27.txt hyphliste.txt.gz no.trae
	${MAKE} hyphliste.patinput
	echo -e '28 28\n2 10\n1 2 3\ny' | \
	patgen-ext hyphliste.patinput $< $@ no.trae
	${MAKE} feil.$@.gz

pate29.txt: pate28.txt hyphliste.txt.gz no.trae
	${MAKE} hyphliste.patinput
	echo -e '29 29\n2 10\n1 2 3\ny' | \
	patgen-ext hyphliste.patinput $< $@ no.trae
	${MAKE} feil.$@.gz

pate30.txt: pate29.txt hyphliste.txt.gz no.trae
	${MAKE} hyphliste.patinput
	echo -e '30 30\n2 10\n1 1 2\ny' | \
	patgen-ext hyphliste.patinput $< $@ no.trae
	${MAKE} feil.$@.gz


# Here we generate the files that is actually used by TeX.  Note that
# Norwegian is the first language (up to my knowledge) where multiple
# level hyphenation patterns are availiable.  If one set up TeX with
# two different Norwegian languages, one could use nohyph1.tex for
# raggedright and nohyph4.tex for straight margins.  Please help to
# encourage the e[e]TeX team to implement multi-level-hyphenation in a
# proper way.

nohyph%.tex: pat%9.txt #pate30.txt
	@echo 'Writing header'
	@echo -e '% Generated by a script written by Rune Kleveland\n\
	% (runekl@math.uio.no) from dictionaries availiable from\n\
	% http://www.uio.no:/~runekl/dictionary.html\n\
	%\n\
	\message{Norsk hyphenation patterns}\n\
	\\begingroup\n\
	% æ, Æ\n\
	\uccode`^^c6=`^^c6\n\
	\uccode`^^e6=`^^c6\n\
	\lccode`^^c6=`^^e6\n\
	\lccode`^^e6=`^^e6\n\
	% ø, Ø\n\
	\uccode`^^d8=`^^d8\n\
	\uccode`^^f8=`^^d8\n\
	\lccode`^^d8=`^^f8\n\
	\lccode`^^f8=`^^f8\n\
	% Å,å\n\
	\uccode`^^c5=`^^c5\n\
	\uccode`^^e5=`^^c5\n\
	\lccode`^^c5=`^^e5\n\
	\lccode`^^e5=`^^e5\n\
	% ç, Ç\n\
	\uccode`^^c7=`^^c7\n\
	\uccode`^^e7=`^^c7\n\
	\lccode`^^c7=`^^e7\n\
	\lccode`^^e7=`^^e7\n\
	% è, È\n\
	\uccode`^^c8=`^^c8\n\
	\uccode`^^e8=`^^c8\n\
	\lccode`^^c8=`^^e8\n\
	\lccode`^^e8=`^^e8\n\
	% é, É\n\
	\uccode`^^c9=`^^c9\n\
	\uccode`^^e9=`^^c9\n\
	\lccode`^^c9=`^^e9\n\
	\lccode`^^e9=`^^e9\n\
	% ê, Ê\n\
	\uccode`^^ca=`^^ca\n\
	\uccode`^^ea=`^^ca\n\
	\lccode`^^ca=`^^ea\n\
	\lccode`^^ea=`^^ea\n\
	% ò, Ò\n\
	\uccode`^^d2=`^^d2\n\
	\uccode`^^f2=`^^d2\n\
	\lccode`^^d2=`^^f2\n\
	\lccode`^^f2=`^^f2\n\
	% ó, Ó\n\
	\uccode`^^d3=`^^d3\n\
	\uccode`^^f3=`^^d3\n\
	\lccode`^^d3=`^^f3\n\
	\lccode`^^f3=`^^f3\n\
	% ô, Ô\n\
	\uccode`^^d4=`^^d4\n\
	\uccode`^^f4=`^^d4\n\
	\lccode`^^d4=`^^f4\n\
	\lccode`^^f4=`^^f4\n\
	\patterns{% just type <return> if you are not using INITEX' \
	| sed -e 's/^ *//' > $@
	@echo 'Writing patterns'
	sed -e s/å/^^e5/g \
	    -e s/æ/^^e6/g \
	    -e s/ø/^^f8/g \
	    -e s/ç/^^e7/g \
	    -e s/è/^^e8/g \
	    -e s/é/^^e9/g \
	    -e s/ê/^^ea/g \
	    -e s/ò/^^f2/g \
	    -e s/ó/^^f3/g \
	    -e s/ô/^^f4/g \
	    -e '$$ s/$$/\}/' \
	    $< \
	  >> $@
	@echo -e '\endgroup\n\endinput' >> $@

# Below this point is some code I used to compare my patterns with the
# patterns already availiable.  If you want to improve the patterns, I
# suggest you start with generating norsk.singlewords and the
# diff-files.  To do this you need to obtain the patterns you wish to
# compare with (nohyph1.tex, nohyph2.tex and nohyphsimen.tex) and put
# them in the oldpatterns directory.  Then edit norsk.singlewords to
# fix what you don't like, remove the dependencies for
# norsk.singlewords to avoid overwriting your edited file, and make
# pats9.txt.  This is your new norsk.single.pat file.  Now you can
# be a man and make your very own TeX patterns.



norsk.singlewords:  norsk.single.pat no.tra1 hyphlist2.txt.gz
	gzip -d < hyphlist2.txt.gz \
	  | cut -d ' ' -f 1 \
	  | grep -v -e ${NOHYPHWORDS} \
	  | sed -e 's/\"\(.\)\1/\1\1-\1/g' \
	  | tr '-' '\n' \
	  | sort \
	  | uniq -c \
	  | sort -r -s -k1,1 \
	  | sed -e 's/^.*[0-9][0-9]*.//' \
	  > $@
	echo -e 2 1'\n'y | \
	$(PATGEN) $@ $< /dev/null no.tra1
	cat pattmp | tr '.' '-' > $@
	rm -f pattmp

norsk.singlewords.sorted: norsk.singlewords
	sed -e 's/^\(.*\)$$/----\1\î\1/' @<
	 | tr 'î' '\n' \
	 | sed -e '/----/ s/[\*-4]//g' \
	 | sed -e N -e 's/\n/ ----/' \
	 | sort  '-t/' -u +0f -1 +0 \
	 | sed -e 's/.*----//' \
	 > $@


# Make lists of words where the hyphenation in norsk.singlewords
# disagree with the old patterns.

oldpatterns/nohyph%.txt:
	cd oldpatterns && ${MAKE} all

diff.nohyph%: norsk.singlewords oldpatterns/nohyph%.txt no.tra
	echo -e '2 1 \ny' | \
	$(PATGEN) norsk.singlewords $(subst diff.,oldpatterns/,$@).txt /dev/null no.tra
	grep -v '^[${CH}]-[*${CH}]*$$' pattmp | grep [-.] > $@

# A little more clever script.  Look at the result or the regexps to
# see which words are in which file.  Only useful if you want to
# improve the patterns for single words or if you want to check
# quality of patterns compared to the old ones.  If you have
# suggestions for improvement, please let me know!

diff-files: norsk.singlewords oldpatterns/nohyph1.txt oldpatterns/nohyph2.txt oldpatterns/nohyphsimen.txt no.tra no.tra1
	echo -e '2 1 \ny' | \
	$(PATGEN) norsk.singlewords oldpatterns/nohyph1.txt /dev/null no.tra
	mv pattmp diff-file1.tmp
	echo -e '2 1 \ny' | \
	$(PATGEN) norsk.singlewords oldpatterns/nohyphsimen.txt /dev/null no.tra
	paste diff-file1.tmp pattmp | \
	sed -e 's/	/                                  /' \
	    -e 's/^\(.\{35\}\) */\1/' | \
	grep -v -e '^\(.-\)\?[*${CH}]\+ *\(.-\)\?[*${CH}]\+$$' > diff-file2.tmp
	rm diff-file1.tmp
	sed -e 's/^\([^ ]\+\) .*/\1/' -e 's/\.//g' diff-file2.tmp > hyph.tmp
	echo -e '2 1 \ny' | \
	$(PATGEN) hyph.tmp oldpatterns/nohyph2.txt /dev/null no.tra1
	paste diff-file2.tmp pattmp | \
	sed -e 's/	/                                  /' \
	    -e 's/^\(.\{70\}\) */\1/' \
	    -e 's/           \([${CH}]\)/ \1/g'  > diff-file
	rm diff-file2.tmp hyph.tmp
	-grep -e '^\([^ ]\+\) *\1 *\1$$' diff-file | gzip -9 > diff-file1.gz
	-grep -v -e '^\([^ ]\+\) *\1 *\1$$' diff-file | \
	 grep -e '^\([^ ]\+\) *\1 ' | gzip -9 > diff-file2.gz
	-grep -v -e '^\([^ ]\+\) \+\1 ' diff-file | \
	 grep -e '^[*${CH}]\+ ' | gzip -9 > diff-file3.gz
	-grep -v -e '^\([^ ]\+\) \+\1 ' diff-file | \
	 grep -e '^[^ ]\+ \+[*${CH}]\+ ' | gzip -9 > diff-file4.gz
	-grep -v -e '^\([^ ]\+\) \+\1 ' diff-file | \
	 grep -v -e '^\([^ ]\+ \+\)\?[*${CH}]\+ ' | gzip -9 > diff-file5.gz
	rm diff-file

lightclean:
	rm -f hyphlist[124].patinput

clean :
	rm -f hyph_no_NO.zip                  \
	      hyph_no_NO.dic                  \
	      hyph_no_NO.dic.tmp              \
	      hyphlist{1,2,3,4}.patinput      \
	      hyphlist{1,2,3,4}.txt.gz        \
	      no.tra                          \
	      no.tra1                         \
	      pat0.txt                        \
	      pat{1,4}{1,2,3,4,5,6,7,8,9}.txt \
	      norsk.nonstandard.pat           \
	      pattmp                          \
	      test-data                       \
	      test.log

# Here we generate patterns from the file norsk.singlewords.

pats1.txt: pat0.txt norsk.singlewords no.tra1
	echo -e '1 1\n2 3\n1 2 10\nn' | \
	$(PATGEN) norsk.singlewords $< $@ no.tra1

pats2.txt: pats1.txt norsk.singlewords no.tra1
	echo -e '2 2\n2 4\n1 2 6\ny' | \
	$(PATGEN) norsk.singlewords $< $@ no.tra1
	${MAKE} feils.$@.gz

pats3.txt: pats2.txt norsk.singlewords no.tra1
	echo -e '3 3\n2 5\n1 2 5\ny' | \
	$(PATGEN) norsk.singlewords $< $@ no.tra1
	${MAKE} feils.$@.gz

pats4.txt: pats3.txt norsk.singlewords no.tra1
	echo -e '4 4\n2 6\n1 2 4\ny' | \
	$(PATGEN) norsk.singlewords $< $@ no.tra1
	${MAKE} feils.$@.gz

pats5.txt: pats4.txt norsk.singlewords no.tra1
	echo -e '5 5\n2 7\n1 2 3\ny' | \
	$(PATGEN) norsk.singlewords $< $@ no.tra1
	${MAKE} feils.$@.gz

pats6.txt: pats5.txt norsk.singlewords no.tra1
	echo -e '6 6\n2 7\n1 1 2\ny' | \
	$(PATGEN) norsk.singlewords $< $@ no.tra1
	${MAKE} feils.$@.gz

pats7.txt: pats6.txt norsk.singlewords no.tra1
	echo -e '7 7\n2 8\n1 1 1\ny' | \
	$(PATGEN) norsk.singlewords $< $@ no.tra1
	${MAKE} feils.$@.gz

pats8.txt: pats7.txt norsk.singlewords no.tra1
	echo -e '8 8\n2 9\n1 1 1\ny' | \
	$(PATGEN) norsk.singlewords $< $@ no.tra1
	${MAKE} feils.$@.gz

pats9.txt: pats8.txt norsk.singlewords no.tra1
	echo -e '9 9\n2 10\n1 1 1\ny' | \
	$(PATGEN) norsk.singlewords $< $@ no.tra1
	${MAKE} feils.$@.gz


# Some code I used to compare with the comercial program
# hyphenologist.  Is seems that there is little to learn from that
# program.

hyphenologist.verygood: norsk.singlewords.multi
	cat norsk.singlewords.multi \
	  | tr -d - \
	  | tr -d '\*-' \
	  | tr '?' '\-' \
	  > $@

patw1.txt: pat0.txt hyphenologist.verygood no.tra1
	echo -e '1 1\n2 3\n1 2 10\nn' | \
	$(PATGEN) hyphenologist.verygood $< $@ no.tra1

patw2.txt: patw1.txt hyphenologist.verygood no.tra1
	echo -e '2 2\n2 4\n1 2 6\ny' | \
	$(PATGEN) hyphenologist.verygood $< $@ no.tra1
	${MAKE} feils.$@.gz

patw3.txt: patw2.txt hyphenologist.verygood no.tra1
	echo -e '3 3\n2 5\n1 2 5\ny' | \
	$(PATGEN) hyphenologist.verygood $< $@ no.tra1
	${MAKE} feils.$@.gz

patw4.txt: patw3.txt hyphenologist.verygood no.tra1
	echo -e '4 4\n2 6\n1 2 4\ny' | \
	$(PATGEN) hyphenologist.verygood $< $@ no.tra1
	${MAKE} feils.$@.gz

patw5.txt: patw4.txt hyphenologist.verygood no.tra1
	echo -e '5 5\n2 7\n1 2 3\ny' | \
	$(PATGEN) hyphenologist.verygood $< $@ no.tra1
	${MAKE} feils.$@.gz

patw6.txt: patw5.txt hyphenologist.verygood no.tra1
	echo -e '6 6\n2 7\n1 1 2\ny' | \
	$(PATGEN) hyphenologist.verygood $< $@ no.tra1
	${MAKE} feils.$@.gz

patw7.txt: patw6.txt hyphenologist.verygood no.tra1
	echo -e '7 7\n2 8\n1 2 2\ny' | \
	$(PATGEN) hyphenologist.verygood $< $@ no.tra1
	${MAKE} feils.$@.gz

patw8.txt: patw7.txt hyphenologist.verygood no.tra1
	echo -e '8 8\n2 8\n1 1 1\ny' | \
	$(PATGEN) hyphenologist.verygood $< $@ no.tra1
	${MAKE} feils.$@.gz

patw9.txt: patw8.txt hyphenologist.verygood no.tra1
	echo -e '9 9\n2 9\n1 1 1\ny' | \
	$(PATGEN) hyphenologist.verygood $< $@ no.tra1
	${MAKE} feils.$@.gz

# For now the non-standard hyphenation patterns are not generated from
# norsk.words (from the words with a " in them), but from a separate
# list of words in norsk.nonstandard.words.
norsk.nonstandard.pat : norsk.nonstandard.words
	cat $< | LC_CTYPE=UTF-8 perl make-nonstandard-patterns.pl >$@

# Create patterns file for OpenOffice.org (Libhyphen)
hyph_no_NO.dic: pat49.txt norsk.nonstandard.pat
	cat $^ >hyph_no_NO.dic.tmp
	LC_CTYPE=UTF-8 perl hyphen/substrings.pl hyph_no_NO.dic.tmp $@ ISO8859-1 2 3
	rm hyph_no_NO.dic.tmp

# FIXME: to process the full list of words would take too long (0,1 seconds per word x 584822 words = 16 hours)
.PHONY : check
check : hyphen/example hyph_no_NO.dic test-data.small
	cat $(word 3,$^) | bash test.sh $(word 2,$^) 2>test.log

test-data : hyphlist1.txt.gz
	gzip -d < $< \
	  | grep -v -e '${NOHYPHWORDS}' \
	  | sed -e 's/ .*//' \
	        -e 's/[*]/-/g' \
	        -e 's/\.//g' \
	  | LC_CTYPE=C \
	    perl make-test-data.pl >$@

hyphen/example : hyphen/Makefile
	${MAKE} -C $(dir $@) $(notdir $@)

hyphen/Makefile : hyphen/configure
	cd $(dir $@) && ./configure

hyphen/configure : hyphen/configure.ac
	cd $(dir $@) && autoreconf -fvi

hyph_no_NO.zip : hyph_no_NO.dic
	zip $@ $^

.PHONY : zip
zip : hyph_no_NO.zip

VERSION := 1.1.0

# Publish ZIP in Maven repo
.PHONY : publish
publish : hyph_no_NO.zip
	mvn org.apache.maven.plugins:maven-deploy-plugin:3.0.0-M2:deploy-file \
		-Durl=https://maven.pkg.github.com/nlbdev/spell-no \
		-DrepositoryId=github-spell-no \
		-Dfile=$< \
		-DgroupId=no.nlb \
		-DartifactId=spell-no-patterns \
		-Dversion=$(VERSION) \
		-Dpackaging=zip \
		-DgeneratePom=true \
		-DgeneratePom.description="Norwegian hyphenation dictionary"
