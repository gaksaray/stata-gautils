*! version 1.0  10jul2021  Gorkem Aksaray <gaksaray@ku.edu.tr>
*! Add new variables that are functions of existing variables
*!
*! Syntax
*! ------
*!   mutate fn varlist, fnopts
*!
*!   fn is one of {sq, ln, log, exp}, for square, logarithmic transformation,
*!   and exponentiation, respectively.
*!
*!   fnopts:
*!
*!     for fn = sq
*!       [, scale(integers)]
*!     where
*!       scale divides the squared term by 10 to the power of x.
*!
*!     for fn = ln or log (synonyms)
*!       [, preadd(reals or missings) premultiply(reals or missings)]
*!     where
*!       preadd adds x before taking the log
*!       premultiply multiplies by x before taking the log.
*!
*!     for fn = exp, there are currently no options.
*!   
*!   Function options can take as many numbers as the number of variables in
*!   varlist. For example, if there are 4 variables to mutate sq, you can
*!   specify scale(2 . 3), in which case the first squared term will be scaled
*!   by 10^2, the second squared term will be scaled by 10^1=1 (default), and
*!   the rest of the squared terms will be scaled by 10^3.
*!
*! Examples
*! --------
*!   sysuse auto, clear
*!   local mutated_variables "price trunk weight length"
*!   keep `mutated_variables'
*!   mutate sq  `mutated_variables', scale(3 . 2)
*!   mutate ln  `mutated_variables', preadd(250.5 1 .) premultiply(. . 10)
*!   mutate log `mutated_variables', preadd(250.5 1 .) premultiply(. . 10)
*!   mutate exp `mutated_variables'

capture program drop mutate
program mutate
    version 12
    
    syntax [anything(name=arguments id="arguments")] [, *]
    
    gettoken 1 0: arguments
    
    #delimit ;
    local fnlist    `"
                    "sq",
                    "ln",
                    "log",
                    "exp"
                    "'
    ;
    #delimit cr
    
    if inlist("`1'", `fnlist') {
        local fn `1'
        local Fn = strproper("`fn'")
        local varlist `0'
    }
    else {
        error 198
        exit 198
    }
    
    confirm numeric variable `varlist'
    
    if "`fn'" == "sq" {
        _mutate`Fn' `varlist', `options'
    }
    if inlist("`fn'", "ln", "log") {
        _mutateLn `fn' `varlist', `options'
    }
    if "`fn'" == "exp" {
        _mutate`Fn' `varlist', `options'
    }
end

capture program drop _mutateSq
program define _mutateSq
    syntax varlist [, scale(numlist int miss min=1 >0)]
    
    // set defaults
    local def_scale = 0
    
    local varcount = wordcount("`varlist'")
    local scalecount = wordcount("`scale'")
    if `scalecount' > `varcount' {
        di as err "too many nums in scale()"
        exit 198
    }
    else {
        local lastscale = word("`scale'", `scalecount')
    }
    
    local i = 0
    foreach var of varlist `varlist' {
        local ++i
        
        local scale_i = word("`scale'", `i')
        if "`scale_i'" == "" local scale_i "`lastscale'"
        else if "`scale_i'" == "." local scale_i = `def_scale'
        
        generate `var'sq = `var'^2 / 10^`scale_i', after(`var')
        label var `var'sq "`var'^2 / 10^`scale_i'"
    }
end

capture program drop _mutateLn
program define _mutateLn
    #delimit ;
    syntax
        anything(name=arguments)
        [,
        PREAdd(numlist miss min=1)
        PREMultiply(numlist miss min=1)
        ]
    ;
    #delimit cr
    
    gettoken 1 0: arguments
    local fn "`1'"
    local varlist "`0'"
    
    // set defaults
    local def_preadd = 0
    local def_premultiply = 1
    
    local varcount = wordcount("`varlist'")
    local preaddcount = wordcount("`preadd'")
    local premultiplycount = wordcount("`premultiply'")
    if `preaddcount' > `varcount' {
    	di as err "too many nums in preadd()"
        exit 198
    }
    else {
    	local lastpreadd = word("`preadd'", `preaddcount')
    }
    if `premultiplycount' > `varcount' {
        di as err "too many nums in premultiply()"
        exit 198
    }
    else {
        local lastpremultiply = word("`premultiply'", `premultiplycount')
    }
    
    local i = 0
    foreach var of varlist `varlist' {
    	local ++i
        
        foreach fnopt in preadd premultiply {
            local `fnopt'_i = word("``fnopt''", `i')
            if "``fnopt'_i'" == "" local `fnopt'_i "`last`fnopt''"
            if "``fnopt'_i'" == "." local `fnopt'_i = `def_`fnopt''
        }
        
        generate `fn'`var' = ln((`var' * `premultiply_i') + `preadd_i'), after(`var')
        label var `fn'`var' "`fn'(`var'*`premultiply_i' + `preadd_i')"
    }
end

capture program drop _mutateExp
program define _mutateExp
    syntax varlist [, *]
    
    foreach var of varlist `varlist' {
        qui generate e_`var' = exp(`var'), after(`var')
        label var e_`var' "exp(`var')"
    }
end
