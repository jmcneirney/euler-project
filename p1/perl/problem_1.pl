# If we list all the natural numbers below 10 that are multiples of 3 or 5, we get 3, 5, 6 and 9. The sum of these multiples is 23.
# Find the sum of all the multiples of 3 or 5 below 1000.

#!/usr/bin/env perl

use strict;
use warnings;
use v5.16;
use Readonly;

Readonly my $max => 1000;

my $sum;
foreach my $num ( 3 .. $max -1 ) {
    next unless $num % 3 == 0 || $num % 5 == 0;
    $sum += $num;
}

say $sum;

