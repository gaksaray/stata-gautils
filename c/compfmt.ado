*! version 0.1.0  29apr2022  Gorkem Aksaray <aksarayg@tcd.ie
*!
*! Syntax
*! ------
*!   compfmt [varlist] [, td Preserve]
*!
*! Description
*! -----------
*!   compfmt is a wrapper for fmtnum and fmtstr modules.

capture program drop compfmt
program compfmt
    version 12
    syntax [varlist] [, *]
    
    qui which fmtstr
    qui which fmtnum
    
    fmtstr `varlist'
    fmtnum `varlist', `options'
end
