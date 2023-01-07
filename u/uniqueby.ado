*! version 1.1  02feb2022  Gorkem Aksaray <aksarayg@tcd.ie>
*!
*! Changelog
*!   [v1.1]
*!     - Using string variables or noninteger numeric variables in by() was
*!       causing error, and uniqueby could not name stores results correctly.
*!       This is now fixed. uniqueby now stores these results only when the
*!       by() variable is integer numeric.
*!     - Some minor cosmetic changes.
*!   [v1.0]
*!     - Initial release.

capture program drop uniqueby
program uniqueby, rclass
    syntax varname [if/] [in][, by(varname)]
    
    if "`if'" != "" {
        local ifexp  " & `if'"
        local ifcond "if `if'"
    }
    
    qui levelsof `varlist' `ifcond' `in'
    return local N `r(N)'
    return local r `r(r)'
    di as text "Number of unique values of {bf:`varlist'} is `r(r)'"
    
    if "`by'" != "" {
        qui levelsof `by', local(bylevels)
        
        // numeric by() variable:
        capture confirm numeric variable `by'
        if !_rc {
            
            // check whether all values are integer
            local numint "numint"
            foreach bylevel of local bylevels {
                capture confirm integer number `bylevel'
                if _rc {
                    local numint ""
                }
            }
            
            foreach bylevel of local bylevels {
                qui levelsof `varlist' if `by' == `bylevel' `ifexp' `in'
                if "`numint'" != "" {
                    return local N_`by'`bylevel' `r(N)'
                    return local r_`by'`bylevel' `r(r)'
                }
                local byvallab : value label `by'
                if "`byvallab'" != "" {
                    di as text %9.0f `r(r)' " unique values of {bf:`varlist'} if {bf:`by'} = `bylevel' (`:label `byvallab' `bylevel'')"
                }
                else {
                    di as text %9.0f `r(r)' " unique values of {bf:`varlist'} if {bf:`by'} = `bylevel'"
                }
            }
        }
        
        // string by() variable:
        capture confirm string variable `by'
        if !_rc {
            foreach bylevel of local bylevels {
                qui levelsof `varlist' if `by' == "`bylevel'" `ifexp' `in'
                di as text %9.0f `r(r)' " unique values of {bf:`varlist'} if {bf:`by'} = `bylevel'"
            }
        }
        
    }
end
