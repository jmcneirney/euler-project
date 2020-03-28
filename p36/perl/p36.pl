# Double-base palindromes
# Problem 36
#
# The decimal number, 585 = 1001001001(base2) (binary), is palindromic in both bases.
#
# Find the sum of all numbers, less than one million, which are palindromic in base 10 and base 2.
#
# (Please note that the palindromic number, in either base, may not include leading zeros.)
#!/usr/bin/env perl

use strict;
use warnings;

my $count = 1_000_000;
my $sum ;
for my $num (1..$count-1 ) {
    my @num_array = split('', $num);

    # since binary nums can't have leading zeros they can't have trailing 
    # zeros and therefore can't be even so skip em
    next if $num % 2 == 0;
    if( $num == +join('', reverse @num_array ) ) {
        my $bin = sprintf("%b", $num);
        my @bin = split('', $bin );

        my $bin_reverse = join('', reverse @bin );
        $sum += $num if( $bin == $bin_reverse );
    }
}

print $sum . "\n";

