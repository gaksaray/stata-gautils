*! version 1.1  07jan2023  Gorkem Aksaray <aksarayg@tcd.ie>
*! Parse file name and extension from the using modifier
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
*!     r(extension) file extension if an extension is provided in using

capture program drop parsefile
program parsefile, rclass
    syntax using/
    
    local next "next"
    while "`next'" != "." & "`using'" != "" {
        gettoken next using : using, parse("~:/\")
    }
    gettoken filename extension : next, parse(".")
    gettoken period extension : extension, parse(".")
    return local filename "`filename'"
    return local extension "`extension'"
end
