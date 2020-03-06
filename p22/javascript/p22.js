// Names scores
// Problem 22
// 
// Using names.txt (right click and 'Save Link/Target As...'), a 46K text file containing over five-thousand first names, 
// begin by sorting it into alphabetical order. Then working out the alphabetical value for each name, multiply this value 
// by its alphabetical position in the list to obtain a name score.
// 
// For example, when the list is sorted into alphabetical order, COLIN, which is worth 3 + 15 + 12 + 9 + 14 = 53, is the 938th 
// name in the list. So, COLIN would obtain a score of 938 × 53 = 49714.
// 
// What is the total of all the name scores in the file?

const fs = require('fs');

let names = fs.readFileSync('./p022_names.txt', 'utf8');

let sums = names.split(',').sort().map(
    (name) => {
        // remove double quotes before getting the ordinal value then subtract 64
        let temp = name.replace(/\"/g, '').split('').map( (c) => c.charCodeAt() - 64 )
        return temp;
    }
 ).map(
    (z) => {
        return z.reduce( (a,b) => { 
            return a + b
        } )
    }
 ).map(
    (a,b) => { 
        return a * (b+1)
    }
 ).reduce(
    (a,b) => {
        return a + b 
    }
 );

console.log( sums )
