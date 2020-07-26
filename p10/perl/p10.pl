
# The sum of the primes below 10 is 2 + 3 + 5 + 7 = 17.
# Find the sum of all the primes below two million.

use strict;
use warnings;

use Data::Dumper;

my $size = 2_000_000;
my @primes = (1 .. $size);
$primes[0] = 'x'; # 1

foreach my $candidate ( 2 .. sqrt($size) + 1 ) {
    next if $primes[$candidate - 1] eq 'x';

    # is the element marked
    #  No? Then it's prime.
    #   - square it and from that point mark all multiples as not prime
    #  Move on to the next number - 3
    #  is it marked? No? Then it's prime.
    #   - square it 3 -> (9) and from that point mark all multiples of 3 as not prime
    #  Do this for all nums 2 -> sqrt( size )
    my $square_of_candidate = $candidate * $candidate;
    for (my $i = $square_of_candidate; $i < $size + 1; $i++) {
        $primes[$i-1] = "x" if $i % $candidate == 0;
    }
}

my $total;
map { $total += $_ } grep { $_ ne 'x' } @primes;
print $total;

