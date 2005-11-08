# Simple Makefile to translate a TeX readable hyphenation patterns
# file into a Patgen (and human) readable file.

all: nohyph1.txt nohyph2.txt nohyphsimen.txt ukhyph.txt

%.txt: %.tex
	cat $< \
	  | sed -e '1,/^[ 	]*\\patterns/ D' \
                -e 's/\^\^e0/à/g' \
		-e 's/\^\^e1/á/g' \
		-e 's/\^\^e2/â/g' \
		-e 's/\^\^e3/ã/g' \
		-e 's/\^\^e4/ä/g' \
		-e 's/\^\^e5/å/g' \
		-e 's/\^\^e6/æ/g' \
		-e 's/\^\^e7/ç/g' \
		-e 's/\^\^e8/è/g' \
		-e 's/\^\^e9/é/g' \
		-e 's/\^\^ea/ê/g' \
		-e 's/\^\^eb/ë/g' \
		-e 's/\^\^ec/ì/g' \
		-e 's/\^\^ed/í/g' \
		-e 's/\^\^ee/î/g' \
		-e 's/\^\^ef/ï/g' \
		-e 's/\^\^f0/ð/g' \
		-e 's/\^\^f1/ñ/g' \
		-e 's/\^\^f2/ò/g' \
		-e 's/\^\^f3/ó/g' \
		-e 's/\^\^f4/ô/g' \
		-e 's/\^\^f5/õ/g' \
		-e 's/\^\^f6/ö/g' \
		-e 's/\^\^f7/÷/g' \
		-e 's/\^\^f8/ø/g' \
		-e 's/\^\^f9/ù/g' \
		-e 's/\^\^fa/ú/g' \
		-e 's/\^\^fb/û/g' \
		-e 's/\^\^fc/ü/g' \
		-e 's/\^\^fd/ý/g' \
		-e 's/\^\^fe/þ/g' \
		-e 's/\^\^ff/ÿ/g' \
		-e '/\}/,$$ D' \
	  > $@

clean:
	-rm -f nohyph1.txt nohyph2.txt nohyphsimen.txt ukhyph.txt
