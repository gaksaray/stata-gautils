*! version 1.0  30jun2021  Gorkem Aksaray <gaksaray@ku.edu.tr>
*! Capture drop a list of variables without an error
*! 
*! Syntax
*! ------
*!   capdrop varlist
*!
*! Examples
*! --------
*!   sysuse auto, clear
*!   capdrop price pricesq        // drops price with no errors
*!   capdrop rep?? junk*          // drops rep78 (you may use wildcards)
*!   capdrop mpg-trunk gear_ratio // drops four non-consecutive variables

capture program drop capdrop
program capdrop
    version 12
    syntax anything
    foreach word of local anything {
        if strpos("`word'", "-") != 0 | ///
           strpos("`word'", "*") != 0 | ///
           strpos("`word'", "?") != 0 {
            capture ds `word'
            if !_rc {
                drop `r(varlist)'
            }
        }
        else {
            capture confirm variable `word'
            if !_rc {
                drop `word'
            }
        }
    }
end
