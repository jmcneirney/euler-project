# If we list all the natural numbers below 10 that are multiples of 3 or 5, we get 3, 5, 6 and 9. 
# The sum of these multiples is 23. Find the sum of all the multiples of 3 or 5 below 1000.

use List::Util qw(sum);
use strict;
use warnings;

my $less_than_val = 1000;

my @list = (1..$less_than_val);

my $sum1 = sum( grep {($_ % 3 == 0 || $_ % 5 == 0) && $_ < $less_than_val} @list ) . "\n";

# Or, alternatively w/o List::Util
my @list_3_5 =  grep {($_ % 3 == 0 || $_ % 5 == 0) && $_ < $less_than_val} @list;
my $sum2;
foreach my $add_me ( @list_3_5 ) {
    $sum2 += $add_me;
}

# or
my $sum3;
map { $sum3 += $_ } grep {($_ % 3 == 0 || $_ % 5 == 0) && $_ < $less_than_val} @list;
print "$sum3\n" if( ($sum1 == $sum2) && ( $sum2 == $sum3 ) );

