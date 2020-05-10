import scala.io.Source

object p22 {

   val strip_quotes  = (name: String) => name.stripPrefix("\"").stripSuffix("\"");
   val chars_to_nums = (name: String) => name.toCharArray().map( _.toByte.toInt - 64 )

   val file  = Source.fromFile("./p022_names.txt")
   val names = file.mkString

   val name_list = names.split(",")
   
   val names_to_nums = 
        name_list.map( strip_quotes ).sorted
                 .map( chars_to_nums )  /// this repeated use of map seems bad ... idk
                 .map( _.sum )
                 .zipWithIndex
                 .map( i => { i._1 * (i._2 + 1) } )

   val total = names_to_nums.sum
                 
   // You're going through the list and stripping the quotes
   // Then you going through the list and blah blah blah
   //  Seems like you wouldn't want to go through the list more 
   //  than once. Do you want to do everything you need to do on one pass?
   
}
