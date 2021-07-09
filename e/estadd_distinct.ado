*! version 1.0  30jun2021  Gorkem Aksaray <gaksaray@ku.edu.tr>
*! Add estout scalar for the number of distinct values
*!
*! Dependencies
*! ------------
*!   ssc install distinct
*!
*! Examples
*! --------
*!   sysuse auto, clear
*!   eststo clear
*!   eststo: regress price mpg
*!   eststo: regress price mpg i.foreign
*!   estadd ndistinct rep78, name(rep): est1 est2 // or simply use * wildcard
*!   esttab, nobase scalars(N N_rep)

capture program drop estadd_distinct
program estadd_distinct, eclass
    version 12
    syntax varlist [, name(namelist max=1)]
    
    if "`name'" != "" {
        local returnname "`name'"
    }
    else {
        local returnname "distinct"
    }
    
    distinct `varlist' if e(sample), joint
    ereturn scalar N_`returnname' = r(ndistinct)
end
