*! version 1.0  22jun2021  Gorkem Aksaray <gaksaray@ku.edu.tr>
*! Clear all variable labels, value labels, and notes from the dataset
*!
*! Examples
*! --------
*!   sysuse auto, clear
*!   describe
*!   notes
*!   labelbook
*!   clearlab
*!   describe  // no variable labels
*!   notes     // no notes
*!   labelbook // no value labels

capture program drop clearlab
program clearlab
    version 12
    label data ""
    foreach var of varlist _all {
        label variable `var'
    }
    _strip_labels _all
    label drop _all
    qui notes drop _all
end
