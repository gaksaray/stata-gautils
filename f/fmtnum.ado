*! version 1.2  13feb2022  Gorkem Aksaray <gaksaray@ku.edu.tr>
*! Compress display format of numeric variables to their default values
*!
*! Syntax
*! ------
*!   fmtnum [varlist] [, td Preserve]
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
*!   fmtnum skips time and date variables unless td option is specified.
*!   fmtnum preserves format justification, leading zeros, and comman if
*!   preserve option is specified.
*!
*! Example
*! -------
*!   sysuse auto, clear
*!   fmtnum, preserve
*!   fmtnum
*! 
*! Changelog
*! ---------
*!   [1.2]
*!     - fmtnum now skips date variables automatically unless td option is
*!       specified.
*!     - preserve option is added for preserving format justification, leading
*!       zeros, and commas.
*!   [1.1]
*!     - Variables with value labels are now displayed in full length.
*!   [1.0]
*!     - Initial release.

capture program drop fmtnum
program fmtnum
    version 12
    syntax [varlist] [, td Preserve]
    
    foreach var of varlist `varlist' {
        capture confirm numeric variable `var'
        if _rc continue
        
        qui compress `var'
        
        local varfmt : format `var'
        
        if "`td'" == "" {
            capture confirm date format `varfmt'
            if !_rc continue
        }
        
        if "`preserve'" != "" {
            if regexm("`varfmt'", "^%([-]?)([0]*)[1-9]+\.[0-9]+[f|g|e]([c]?)$") {
                local just = regexs(1) // justification
                local lz   = regexs(2) // leading zeros
                local c    = regexs(3) // commas
            }
        }
        
        local vartype : type `var'
        if "`vartype'" == "byte"    format `var' %`just'`lz'8.0g`c'
        if "`vartype'" == "int"     format `var' %`just'`lz'8.0g`c'
        if "`vartype'" == "long"    format `var' %`just'`lz'12.0g`c'
        if "`vartype'" == "float"   format `var' %`just'`lz'9.0g`c'
        if "`vartype'" == "double"  format `var' %`just'`lz'10.0g`c'
        
        local vallab : value label `var'
        if "`vallab'" != "" {
            label values `var' .
            label values `var' `vallab'
        }
    }
end
