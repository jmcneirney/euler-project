# If we list all the natural numbers below 10 that are multiples of 3 or 5, we get 3, 5, 6 and 9. 
# The sum of these multiples is 23. Find the sum of all the multiples of 3 or 5 below $less_than_value.

# (3|5) < Junction (3 or 5)
my $sum1 = [3..999].grep( * %% (3 | 5) ).sum;

# using reduction meta-operator
my $sum2 = [+] [3..999].grep( * %% (3 | 5) );

say $sum1 if $sum1 == $sum2;
