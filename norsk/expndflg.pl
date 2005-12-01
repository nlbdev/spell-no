#!/usr/bin/perl
# Purpose: Expand list so that there is one line for each word/flag character 
#          combination, and remove combinations that would lead to redundancies
# Remarks: This script is reverse-engineered from old, slow and messy sed/awk
#          commands in Makefile for "ispell norsk"

foreach $fileName (@ARGV) {
    open(FILE, $fileName);

    chop($line=<FILE>);
    $line=~tr/î/-/ if($line);
    
    while($line) {
	chop($nextLine=<FILE>);
	$nextLine=~tr/î/-/ if($nextLine);

	$line=~s/(e(t\/.*T.*|r\/.*I.*))V/$1/;
	$line=~s/(e\/.*[TB].*)W/$1/;
	$line=~s/([^ei]um\/.*B.*)I/$1/;
	
	my($word, $flags)=split('/', $line);
	
	$flags=~s/^(.*[AB]|)E/$1/ if($nextLine=~m/^${word}er\/AI/);
	
	print($word, "/\n");
	    
	# Note: The below 'm' operator will return a list of letters
	#       in $flags, since a list if every possible match is returned
	#       when using 'g' flag, and '.' matches any single character.
	foreach $flag (($flags=~m/./g)) {
	    print($word, "/");
	    
	    if(!($flag=~m/[a-s]/g)) {
		foreach $prefix (($flags=~m/[a-s]/g)) {
		    print($prefix);
		    }
	    }
	    print($flag, "\n");
	}

	if($flags=~m/[A-Zt-z]/ && !($word=~m/(re|er)$/)) {
	    $nextLine=~s/(${word}e\/.*)R/$1/;
	    $nextLine=~s/\/$//; # Remove separator if no flags are left
	}
	
        $line=$nextLine;
    }
    close(FILE);
}
