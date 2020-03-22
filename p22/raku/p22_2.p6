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


my $names = "../p022_names.txt".IO.slurp;
say $names.split(',').sort
    .map( -> Str $name {
           # for each name - split on empty string - remove "s
           # comb(/\w/) words only - i.e. remove double quotes
           $name.comb(/\w/).map(
               -> Str $char --> Int { $char.ord - 64 } 
           )
         }
     )
    .map( -> Seq $list --> Int { 
             # sum the ordinal char values for each name
             $list.reduce(
                -> Int $x, Int $y --> Int { $x + $y }
             )
         }
     )
    .pairs.map( -> Pair $x --> Int {
            # pairs returns the element from the list
            # with its index
            ($x.key +1) * $x.value 
        }
     )
    .reduce( -> Int $x, Int $y --> Int {
         $x + $y
     } );

# This appears to be a good bit slower than p22.p6
