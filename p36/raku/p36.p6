# The decimal number, 585 = 10010010012 (binary), is palindromic in both bases.
# Find the sum of all numbers, less than one million, which are palindromic in base 10 and base 2.
# (Please note that the palindromic number, in either base, may not include leading zeros.)

# This is soooo ... unbelievably  ...  sloooooooooow ( ~14 sec )
# [1..1_000_000].grep(* !%% 2 ).grep( -> $x { $x == $x.comb.reverse.join } ).grep( -> $y { my $base = $y.base(2); $base == $base.comb.reverse.join } ).sum.say;

# this is less unbelievably slow but still slow ( ~6 sec )
# [1..1_000_000].grep( * !%% 2 ).grep( -> $x { $x == $x.flip } ).grep( -> $y { $y.base(2) == $y.base(2).flip } ).sum.say

# faster but still slow ( < 5 sec )

my @pals;
for (1,3 ... 1_000_000) -> $x {
    next unless $x == $x.flip; # 12321 == 12321
    next unless $x.base(2) == $x.base(2).flip; # 10101 == 10101
    @pals.push($x);
}

say [+] @pals;
