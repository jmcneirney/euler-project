// Double-base palindromes
// Problem 36
//
// The decimal number, 585 = 1001001001(base2) (binary), is palindromic in both bases.
//
// Find the sum of all numbers, less than one million, which are palindromic in base 10 and base 2.
//
// (Please note that the palindromic number, in either base, may not include leading zeros.)

let sum = [...Array(1_000_000).keys()]
    .filter( (x) => { return x % 2 != 0 } )
    .filter( (y) => { return y.toString() === y.toString().split('').reverse().join('') } )
    .filter( (z) => { return z.toString(2) === z.toString(2).split('').reverse().join('') } )
    .reduce( (a,b) => { return a + b } );

console.log( sum );
