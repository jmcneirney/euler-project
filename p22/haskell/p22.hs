{-
 Names scores
 Problem 22
 
 Using names.txt (right click and 'Save Link/Target As...'), a 46K text file containing over five-thousand first names, 
 begin by sorting it into alphabetical order. Then working out the alphabetical value for each name, multiply this value 
 by its alphabetical position in the list to obtain a name score.
 
 For example, when the list is sorted into alphabetical order, COLIN, which is worth 3 + 15 + 12 + 9 + 14 = 53, is the 938th 
 name in the list. So, COLIN would obtain a score of 938 × 53 = 49714.
 
 What is the total of all the name scores in the file?
-}

import System.IO
import Data.List.Split
import Data.List
import Data.Char

main = do
    handle <- openFile "./p022_names.txt" ReadMode
    contents <- hGetContents handle

    let names = splitOn(",") contents

    let char_offset = 64;

    -- remove \"
    let names_list = map( filter( \s -> s `elem` ['A'..'Z'] ) ) names

    -- get ordinal value and subtract 64
    let ord_list = map sum $ map ( map( \c -> ord c - char_offset ) ) $ sort names_list

    -- list of tuples
    let zipt = zip [1..(length ord_list)] ord_list

    let total = sum $ map ( \(x,y) -> (x * y) ) zipt

    putStr $ (show total) ++ "\n"

    hClose handle

