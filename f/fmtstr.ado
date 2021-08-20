*! version 1.1  20aug2021  Gorkem Aksaray <gaksaray@ku.edu.tr>
*! Compress display format of string variables to their shortest visible form
*!
*! Syntax
*! ------
*!   fmtstr [varlist]
*!
*! Example
*! -------
*!   sysuse auto, clear
*!   format make // it's %-18s
*!   fmtstr
*!   format make // now it's %-17s!
*! 
*! Changelog
*! ---------
*!   [2021.08.20]
*!     - Added optional varlist argument.

capture program drop fmtstr
program fmtstr
    version 12
    syntax [varlist]
    
    foreach var of varlist `varlist' {
        capture confirm string variable `var'
        if !_rc {
            recast strL `var'
            recast str `var'
        }
    }
end
