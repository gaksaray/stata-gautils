*! version 1.0  22jan2022  Gorkem Aksaray <gaksaray@ku.edu.tr>
*! Parse file name from the using modifier
*!
*! Syntax
*! ------
*!   parsefile using
*!
*! Saved results
*! -------------
*!   parsefile saves the following in r():
*!
*!   Scalars
*!     r(filename)  file name

capture program drop parsefile
program parsefile, rclass
    syntax using/ [, EXTension]
    
    local next "next"
    while "`next'" != "." & "`using'" != "" {
        gettoken next using : using, parse("~:/\")
    }
    gettoken filename : next, parse(".")
    return local filename "`filename'"
end
