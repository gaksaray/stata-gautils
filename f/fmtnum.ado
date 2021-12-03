*! version 1.1  03dec2021  Gorkem Aksaray <gaksaray@ku.edu.tr>
*! Compress display format of numeric variables to their default values
*!
*! Syntax
*! ------
*!   fmtnum [varlist]
*!
*! Description
*! -----------
*!   fmtnum sets the display format associated with the numeric variables
*!   specified to their default values according to their type:
*!   
*!                         byte    %8.0g
*!                         int     %8.0g
*!                         long    %12.0g
*!                         float   %9.0g
*!                         double  %10.0g
*!
*! Example
*! -------
*!   sysuse auto, clear
*!   fmtnum
*! 
*! Changelog
*! ---------
*!   [1.1]
*!     Variables with value labels are now displayed in full length.
*!   [1.0]
*!     Initial release.

capture program drop fmtnum
program fmtnum
    version 12
    syntax [varlist]
    
    foreach var of varlist `varlist' {
        capture confirm numeric variable `var'
        if _rc continue
        
        qui compress `var'
        
        local vartype : type `var'
        if "`vartype'" == "byte"    format `var' %8.0g
        if "`vartype'" == "int"     format `var' %8.0g
        if "`vartype'" == "long"    format `var' %12.0g
        if "`vartype'" == "float"   format `var' %9.0g
        if "`vartype'" == "double"  format `var' %10.0g
        
        local vallab : value label `var'
        if "`vallab'" != "" {
            label values `var' .
            label values `var' `vallab'
        }
    }
end
