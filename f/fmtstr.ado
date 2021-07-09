*! version 1.0  02jul2021  Gorkem Aksaray <gaksaray@ku.edu.tr>
*! Compress display format of string variables to their shortest visible form
*! 
*! Example
*! -------
*!   sysuse auto, clear
*!   format make // it's %-18s
*!   fmtstr
*!   format make // now it's %-17s!

capture program drop fmtstr
program fmtstr
    version 12
    foreach var of varlist _all {
        capture confirm string variable `var'
        if !_rc {
            recast strL `var'
            recast str `var'
        }
    }
end
