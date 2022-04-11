#!/usr/bin/env perl

while (<>) {
	chomp;
	my $in = $_;
	if ($in =~ s/["-]//g) {
		print "$in";
		my @parts = split(/(?<=["-])|(?=["-])/,$_);
		my @hyphens = grep { not ++$n % 2 } @parts;
		@parts = grep { not ++$n % 2 } @parts;
		for my $i (0..$#hyphens) {
			my @p = @parts;
			my $out = join("",splice(@p, 0, $i + 1))."$hyphens[$i]".join("", @p);
			$out =~ s/"(.)\1/\1\1=\1/;
			$out =~ s/-/=/g;
			print "\t$out"
		}
		print "\n";
	}
}
