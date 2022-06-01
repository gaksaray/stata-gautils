*! version 1.0  12jul2021  Gorkem Aksaray <gaksaray@ku.edu.tr>
*! Add LaTeX horizontal spaces to variable and value labels
*! 
*! Syntax
*! ------
*!   hspace       [varlist] [, em(real)]
*!   
*!   hspace drop  [varlist]
*!
*! Examples
*! --------
*!  sysuse auto, clear
*!  hspace                      // adds all labels \hspace{1em}
*!  hspace drop                 // drops all \hspace{1em}s
*!  hspace make-turn, em(1.25)  // adds \hspace{1.25em} too all specified labels
*!  hspace rep78-trunk, em(1.5) // changes specified labels to \hspace{1.5em}
*!  hspace drop length-turn     // drops \hspace{}s from specified labels
*!  hspace foreign              // notice the value label as well!
*!  hspace drop _all            // _all is assumed if varlist is empty

capture program drop hspace
program hspace
    
    syntax [anything(name=arguments id="arguments")] [, *]
    
    gettoken 1 0: arguments
    
    local fnlist `" "add", "drop" "'
    
    if inlist("`1'", `fnlist') {
        local fn `1'
        _getVarlist `0'
        local varlist = r(varlist)
    }
    else {
        local fn "add"
        _getVarlist `1' `0'
        local varlist = r(varlist)
    }
    
    qui foreach var of varlist `varlist' {
        
        if "`fn'" == "add" {
            _hspaceOn `var', `options'
        }
        
        if "`fn'" == "drop" {
            _hspaceOff `var'
        }
    }
end

capture program drop _hspaceOn
program define _hspaceOn
    syntax varname [, em(numlist min=1 max=1)]
    
    // Remove any previous \hspace{}
    _hspaceRemove `varlist'
    
    // Set default em space
    if "`em'" == "" {
        local em = 1
    }
    
    // Add \hspace{`em'em} to variable label
    local varlab "`: variable label `varlist''"
    label variable `varlist' "\hspace{`em'em} `varlab'"
    
    // Add \hspace{`em'em} to value labels
    local vallab "`: value label `varlist''"
    if "`vallab'" != "" {
        qui label list `vallab'
        forvalues i = `r(min)'/`r(max)' {
            local vallab_i `: label `vallab' `i''
            label define `vallab' `i' "\hspace{`em'em} `vallab_i'", modify
        }
    }
end

capture program drop _hspaceOff
program define _hspaceOff
    syntax varname
    
    if "`em'" != "" {
        di as err "option {bf:em()} not allowed"
        exit 198
    }
    
    _hspaceRemove `varlist'
end

capture program drop _hspaceRemove
program define _hspaceRemove
    syntax varname
    local varlab "`: variable label `varlist''"
    local vallab "`: value label `varlist''"
    
    if regexm("`varlab'", "^\\hspace{[^}]*}(.*)$") == 1 {
        local varlab = trim(regexs(1))
        label variable `varlist' "`varlab'"
    }
    
    if "`vallab'" != "" {
        qui label list `vallab'
        forvalues i = `r(min)'/`r(max)' {
            local vallab_i `: label `vallab' `i''
            if regexm("`vallab_i'", "^\\hspace{[^}]*}(.*)$") == 1 {
                local vallab_i = trim(regexs(1))
                label define `vallab' `i' "`vallab_i'", modify
            }
        }
    }
end

capture program drop _getVarlist
program _getVarlist, rclass
    syntax [varlist]
    return local varlist "`varlist'"
end
