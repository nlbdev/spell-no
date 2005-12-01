#!/usr/bin/perl
use locale;			# For lc() to handle non-ASCII charcters

foreach $fileName (@ARGV) {
    open(FILE, $fileName);
    while(chop($line=<FILE>)) {
	$line=~s/#.*//;		# Strip comments
	if($typeId && $line=~m/flag/) {
	    ($id, $combine, $compound, @rewrite)=parseFlag(\*FILE, $line);
	    
	    if($compound) {
		print STDERR ("Warning: Compund suffix \"$typeId $id\"",
			      " may be incorrect in output.\n");
		
		print("\n# *** FIXME: The following rule set is applicable only when\n");
		print("#            forming compunds. Not sure if the syntax is correct\n");
		print($typeId, " ", $id, " ", ($combine?"Y":"N"), " ",
		      $#rewrite+1, "\n");
		foreach $r (@rewrite) {
		    $r=~s/\S*\s*\S*/$&-/; # Insert '-' after 2nd char sequence
		    $r=~s/0-/-/;
		    
		    print($typeId, " ", $id, "   ", $r, "\n");
		}
	    } else {
		if($#rewrite<0) {
		    print STDERR ("Warning: No entries found for", 
				  " \"$typeId $id\"; affix skipped.\n");
		} else {
		    print("\n", $typeId, " ", $id, " ", ($combine?"Y":"N"), " ",
			  $#rewrite+1, "\n");
		    foreach $r (@rewrite) {
			print($typeId, " ", $id, "   ", $r, "\n");
		    }
		}
	    }
	} elsif($line=~m/suffixes/) {
	    $typeId="SFX";
	} elsif($line=~m/prefixes/) {
	    $typeId="PFX";
	} elsif($line=~m/compoundwords/) {
	    ($compundFlag)=($line=~m/controlled\s*([A-Za-z])/);
	    print("\nCOMPOUNDFLAG ", $compundFlag, "\n") if($compundFlag);
	} elsif($line=~m/compoundmin/) {
	    ($compundMin)=($line=~m/compoundmin\s*([0-9]+)/);
	    print("\nCOMPOUNDMIN ", $compundMin, "\n") if($compundMin);
	}
    }
    close(FILE, $fileName);
}

sub parseFlag {
    my($fileRef, $line)=@_;
    my($id, $comb, $comp, @rules)=("A", 0, 0);

    $comb=1 if($line=~m/\*/);
    $comp=1 if($line=~m/~/);
    ($id)=($line=~m/flag.*(.)\s*:/);
    
    # Skip initial comments/blank lines...
    while(chop($line=<$fileRef>) && $line=~m/^\s*(\#|$)/) { 
    }

    while($line=~m/>/) {
	my($from, $to, $remove, $add);

	$line=~s/#.*//;
	$line=~s/\s//g;
	$line=~s/Î//g;		# ***
	$line=lc($line);

	
	($from, $to)=split('>', $line);
	($remove, $add)=($to=~m/-([^,]*),(.*)/);
	if(!$remove) {
	    $remove="0";
	    $add=$to;
	}
	if(!$add || $add eq "-") {
	    $add="0";
	}
	push(@rules, "$remove  $add  $from");
	do {
	    chop($line=<$fileRef>);
	} while($line && $line=~m/^\s*#/); # Handle lines "commented out" etc.
    }
    
    
    return ($id, $comb, $comp, @rules);
}

