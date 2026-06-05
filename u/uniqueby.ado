*! version 1.3  05jun2026  Gorkem Aksaray <aksarayg@tcd.ie>
*!
*! Changelog
*!   [v1.3]
*!     - Compound if expressions with | were causing error when combined with
*!       the by() option. This is now fixed.
*!     - Negative integer by() values produced an illegal stored-result name
*!       (e.g., r(r_x-1)) and caused an error. This is now fixed.
*!     - Group results are now stored as r(N_by#)/r(r_by#).
*!     - Added a version statement.
*!     - Added a compact option to be used in combination with the by() option.
*!       It suppresses 0 unique values in the output for a more compact view.
*!   [v1.2]
*!     - Returned items were locals, not scalars as reported. This is now
*!       fixed.
*!   [v1.1]
*!     - Using string variables or noninteger numeric variables in by() was
*!       causing error, and uniqueby could not name stored results correctly.
*!       This is now fixed. uniqueby now stores these results only when the
*!       by() variable is integer numeric.
*!     - Some minor cosmetic changes.
*!   [v1.0]
*!     - Initial release.

capture program drop uniqueby
program uniqueby, rclass
    version 15
    syntax varname [if/] [in][, by(varname) compact]
    
    if "`by'" == "" & "`compact'" != "" {
        di as err "option {bf:compact} must be combined with {bf:by()}"
        exit 198
    }
    
    if "`if'" != "" {
        local ifexp  " & (`if')"
        local ifcond "if `if'"
    }
    
    qui levelsof `varlist' `ifcond' `in'
    return scalar N = r(N)
    return scalar r = r(r)
    di as text "Number of unique values of {bf:`varlist'} is `r(r)'"
    
    if "`by'" != "" {
        qui levelsof `by', local(bylevels)
        
        // numeric by() variable:
        capture confirm numeric variable `by'
        if !_rc {
            
            // check whether all values are (nonnegative) integer
            local numint "numint"
            foreach bylevel of local bylevels {
                capture confirm integer number `bylevel'
                if _rc | `bylevel' < 0 {
                    local numint ""
                }
            }
            
            foreach bylevel of local bylevels {
                qui levelsof `varlist' if `by' == `bylevel' `ifexp' `in'
                if "`numint'" != "" {
                    return scalar N_by`bylevel' = r(N)
                    return scalar r_by`bylevel' = r(r)
                }
                if "`compact'" != "" & `r(r)' == 0 {
                    local omitted_msg "omitted_msg"
                    continue
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
        
        if "`omitted_msg'" != "" {
            di as text _n _skip(7) "(0 unique values omitted)"
        }
        
    }
end
