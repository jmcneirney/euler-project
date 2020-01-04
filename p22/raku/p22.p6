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

my @sums;
# do something about the path - currently this will only work the file is run from the current directory
for '../p022_names.txt'.IO.slurp.split(',').sort.pairs -> $pair {
    # push the lower cased value (a name) having striped the "s and subtracing 96 from each
    # chars numeric value then multiplying that by each names position in the list
    @sums.push(($pair.key + 1) * $pair.value.lc.comb(/\w/).map( *.ord -96 ).sum );
}

say [+] @sums

