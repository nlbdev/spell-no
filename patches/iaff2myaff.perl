#!/usr/bin/perl
use locale;			# For lc() to handle non-ASCII charcters

foreach $fileName (@ARGV) {
    open(FILE, $fileName);
    while(chop($line=<FILE>)) {
	$line=~s/#.*//;		# Strip comments
	if($typeId && $line=~m/flag/) {
	    ($id, $combine, $compound, @rewrite)=parseFlag(\*FILE, $line);
	    
	    if($compound) {
		print("\n# *** FIXME: The following rule set is applicable\n");
		print("#            to compounds only:\n");
		print("# ", $typeId, " ", $id, " ", ($combine?"Y":"N"), " ",
		      $#rewrite+1, "\n");
		foreach $r (@rewrite) {
		    print("# ", $typeId, " ", $id, "   ", $r, "\n");
		}
	    } else {
		print("\n", $typeId, " ", $id, " ", ($combine?"Y":"N"), " ",
		      $#rewrite+1, "\n");
		foreach $r (@rewrite) {
		    print($typeId, " ", $id, "   ", $r, "\n");
		}
	    }
	} elsif($line=~m/suffixes/) {
	    $typeId="SFX";
	} elsif($line=~m/prefixes/) {
	    $typeId="PFX";
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
    
    # Skip to rules...
    while(chop($line=<$fileRef>) && $line=~m/^\s*#/) { # Skip comments etc.
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
	push(@rules, "$remove\t$add\t$from");
	do {
	    chop($line=<$fileRef>);
	} while($line && $line=~m/^\s*#/); # Handle lines "commented out" etc.
    }
    
    
    return ($id, $comb, $comp, @rules);
}

