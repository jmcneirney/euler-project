//  Names scores
//  Problem 22
//  
//  Using names.txt (right click and 'Save Link/Target As...'), a 46K text file containing over five-thousand first names, 
//  begin by sorting it into alphabetical order. Then working out the alphabetical value for each name, multiply this value 
//  by its alphabetical position in the list to obtain a name score.
//  
//  For example, when the list is sorted into alphabetical order, COLIN, which is worth 3 + 15 + 12 + 9 + 14 = 53, is the 938th 
//  name in the list. So, COLIN would obtain a score of 938 × 53 = 49714.
//  
//  What is the total of all the name scores in the file?


import scala.io.Source

object p22 {

   val strip_quotes  = (name: String) => name.stripPrefix("\"").stripSuffix("\"");
   val sum_chars_to_nums = (name: String) => {
       name.toCharArray().map( _.toByte.toInt - 64 ).sum
   }

   val file  = Source.fromFile("./p022_names.txt")
   val names = file.mkString

   val name_list = names.split(",")
   
   val names_to_nums = 
        name_list.map( strip_quotes ).sorted
                 .map( sum_chars_to_nums )
                 .zipWithIndex
                 .map( i => { i._1 * (i._2 + 1) } )

   val total = names_to_nums.sum

   println( total )
}

