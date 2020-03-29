# The decimal number, 585 = 10010010012 (binary), is palindromic in both bases.
# Find the sum of all numbers, less than one million, which are palindromic in base 10 and base 2.
# (Please note that the palindromic number, in either base, may not include leading zeros.)

# This is soooo ... unbelievably  ...  sloooooooooow 
# [1..1_000_000].grep(* !%% 2 ).grep( -> $x { $x == $x.comb.reverse.join } ).grep( -> $y { my $base = $y.base(2); $base == $base.comb.reverse.join } ).sum.say;

[1..1_000_000].grep( * !%% 2 ).grep( -> $x { $x == $x.flip } ).grep( -> $y { $y.base(2) == $y.base(2).flip } ).sum.say
