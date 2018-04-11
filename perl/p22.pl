# Names scores
# Problem 22
# 
# Using names.txt (right click and 'Save Link/Target As...'), a 46K text file containing over five-thousand first names, 
# begin by sorting it into alphabetical order. Then working out the alphabetical value for each name, multiply this value 
# by its alphabetical position in the list to obtain a name score.
# 
# For example, when the list is sorted into alphabetical order, COLIN, which is worth 3 + 15 + 12 + 9 + 14 = 53, is the 938th 
# name in the list. So, COLIN would obtain a score of 938 × 53 = 49714.
# 
# What is the total of all the name scores in the file?

use v5.26;
use strict;
use warnings;
use Carp;
use Readonly;

Readonly $ALPHABETIC_BASE => 96;

use Data::Dumper;

open( my $NAMES, '<', './p022_names.txt' ) or croak "Unable to read file";

my %names;
my $position = 1;
foreach my $name ( sort split(',', <$NAMES> ) ) {
    $name =~ s/"//g;
    my $val;
    map { $val += ord($_) - $ALPHABETIC_BASE } split('', lc($name));
    $names{$name} = $val * $position;
    $position++;
}

my $total;
foreach my $name_val ( values %names ) {
    $total += $name_val;
}
say $total;
