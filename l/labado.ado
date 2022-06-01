*! version 1.0  29jul2021  Gorkem Aksaray <gaksaray@ku.edu.tr>
*! Save variable labels as an ado program
*! 
*! Syntax
*! ------
*!   labado [varlist] [using] [, COLumn(#) replace]
*!
*!   _all is assumed if varlist is unspecified
*!   default ado file name is _varlab.ado if using is not specified
*!   column specifies the gap between the variable names and labels inside
*!     the ado file
*!   replace specifies the ado file to be rewritten
*! 
*! Description
*! -----------
*!   labado saves variable labels by creating an ado file including
*!   a program that returns the list of saved labels. This is especially
*!   useful to save variable labels from one dataset and use them in
*!   tandem with estout to produce labelled tables out of saved estimates
*!   without loading the original dataset with variable labels.
*!
*! Examples
*! --------
*!   sysuse auto, clear
*!   labado using "`=c(sysdir_personal)'/_varlab.ado", replace
*!   which _varlab
*!   viewsource _varlab
*!   _varlab, prefix(_) suffix(_)
*!   local varlabels = r(varlabels)
*!   return list
*!   clearlab //another module from gautils
*!   eststo: reg price mpg
*!   esttab, label //no label on mpg
*!   esttab, varlabels(`varlabels' _cons "_Constant_") varwidth(25) //label on mpg

capture program drop labado
program define labado
    version 12
    syntax [varlist] [using/] [, COLumn(integer 45) replace]
    
    if "`using'" != "" {
        mata st_local("using", addsuffix(`"`using'"', ".ado"))
    }
    else {
        local using "_varlab.ado"
    }
    
    if regexm(`"`using'"', "([^\\\/]*).ado$") local adofname = regexs(1)
    
    file close _all
    tempname tempado
    file open  tempado using "`using'", write `replace'
    file write tempado "*! `adofname': return saved variable labels" _n
    file write tempado "capture program drop `adofname'" _n
    file write tempado "program define `adofname', rclass" _n
    file write tempado "    syntax [, prefix(string) suffix(string)]" _n
    file write tempado "" _n
    file write tempado "    #delimit ;" _n
    file write tempado "    local varlabels" _n
    
    foreach var of varlist `varlist' {
        file write tempado "        `var'" _column(`column') `""\`prefix'`: variable label `var''\`suffix'""' _n
    }
    
    file write tempado "    ;" _n
    file write tempado "    #delimit cr" _n
    file write tempado "" _n
    file write tempado "    return local varlabels \`varlabels'" _n
    file write tempado "end" _n
    file close tempado
end

mata:
string scalar addsuffix(string scalar name, string scalar suffix) {
    return(pathsuffix(name) == "" ? name + suffix : name)
}
end
