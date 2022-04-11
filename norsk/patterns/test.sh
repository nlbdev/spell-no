#!/usr/bin/env bash

set -e

total=0
failures=0

while read test; do
	actual=$(hyphen/example -d $1 <(echo "$test" | cut -f1) | tail -n+2 | cut -c4-)
	for expected in $(echo "$test" | cut -f2); do
		if ! grep -qiFx "$expected" <(echo "$actual"); then
			((failures=failures+1))
			echo -n "$test	#	" >&2
			echo "$actual" | paste -sd "\t" - >&2
			break
		fi
	done
	((total=total+1))
done

if [ $failures -gt 0 ]; then
	echo "FAILED: $failures failures out of $total tests"
	exit 1
else
	echo "SUCCESS: $total tests passed"
fi

