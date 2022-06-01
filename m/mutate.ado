*! version 1.3  01jul2022  Gorkem Aksaray <gaksaray@ku.edu.tr>
*! Add new variables that are functions of existing variables
*!
*! Syntax
*! ------
*!   mutate fn varlist, fnopts
*!
*!   fn is one of {sq, sqrt, ln, log, exp}, for square, square root, logarithm,
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
*!     for fn = sqrt and fn = exp, there are currently no options.
*!   
*!   Function options can take as many numbers as the number of variables in
*!   varlist. For example, if there are 4 variables to mutate sq, you can
*!   specify scale(2 . 3), in which case the first squared term will be scaled
*!   by 10^2, the second squared term will be scaled by 10^0=1 (default), and
*!   the rest of the squared terms will be scaled by 10^3.
*!
*! Examples
*! --------
*!   sysuse auto, clear
*!   local mutated_variables "price trunk weight length"
*!   keep `mutated_variables'
*!   mutate sq   `mutated_variables', scale(3 . 2)
*!   mutate ln   `mutated_variables', preadd(250.5 1 .) premultiply(. . 10)
*!   mutate log  `mutated_variables', preadd(250.5 1 .) premultiply(. . 10)
*!   mutate sqrt `mutated_variables'
*!   mutate exp  `mutated_variables'
*!
*! Changelog
*! ---------
*!   [1.3]
*!     Added square root function.
*!   [1.2]
*!     Simplified mutate sq labelling when scale is 0 or 1.
*!     Simplified mutate ln labelling when preadd is 0 or premultiply is 1.
*!   [1.1]
*!     Using mutate without any option was causing error. This is now fixed.
*!   [1.0]
*!     Initial release.

capture program drop mutate
program mutate
    version 12
    
    syntax [anything(name=arguments id="arguments")] [, *]
    
    gettoken 1 0: arguments
    
    #delimit ;
    local fnlist    `"
                    "sq",
                    "sqrt",
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
    if "`fn'" == "sqrt" {
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
    
    // set parameter defaults
    local def_scale = 0
    
    local varcount = wordcount("`varlist'")
    local scalecount = wordcount("`scale'")
    if `scalecount' > `varcount' {
        di as err "too many nums in scale()"
        exit 198
    }
    else {
        if "`scale'" != "" {
            local lastscale = word("`scale'", `scalecount')
        }
        else {
            local lastscale "`def_scale'" // default value if opt not specified
        }
    }
    
    local i = 0
    foreach var of varlist `varlist' {
        local ++i
        
        local scale_i = word("`scale'", `i')
        if "`scale_i'" == "" {
            local scale_i "`lastscale'"
        }
        else if "`scale_i'" == "." {
            local scale_i = `def_scale'
        }
        
        generate `var'sq = `var'^2 / 10^`scale_i', after(`var')
        
        local lbl_scale_i
        if `scale_i' == 0 {
            local lbl_scale_i
        }
        else if `scale_i' == 1 {
            local lbl_scale_i " / 10"
        }
        else if `scale_i' > 1 {
            local lbl_scale_i " / 10^`scale_i'"
        }
        label var `var'sq "`var'^2`lbl_scale_i'"
    }
end

capture program drop _mutateSqrt
program define _mutateSqrt
    syntax varlist [, *]
    
    foreach var of varlist `varlist' {
        qui generate `var'sqrt = sqrt(`var'), after(`var')
        label var `var'sqrt "sqrt(`var')"
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
    
    // set parameter defaults
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
        if "`preadd'" != "" {
            local lastpreadd = word("`preadd'", `preaddcount')
        }
        else {
            local lastpreadd "`def_preadd'" // default val if opt not specified
        }
    }
    if `premultiplycount' > `varcount' {
        di as err "too many nums in premultiply()"
        exit 198
    }
    else {
        if "`premultiply'" != "" {
            local lastpremultiply = word("`premultiply'", `premultiplycount')
        }
        else {
            local lastpremultiply "`def_premultiply'" // default val if opt not specified
        }
    }
    
    local i = 0
    foreach var of varlist `varlist' {
        local ++i
        
        foreach fnopt in preadd premultiply {
            local `fnopt'_i = word("``fnopt''", `i')
            if "``fnopt'_i'" == "" {
                local `fnopt'_i "`last`fnopt''"
            }
            if "``fnopt'_i'" == "." {
                local `fnopt'_i = `def_`fnopt''
            }
        }
        
        generate `fn'`var' = ln((`var' * `premultiply_i') + `preadd_i'), after(`var')
        
        local lbl_preadd_i
        local lbl_premultiply_i
        if `preadd_i' != 0 {
            local lbl_preadd_i " + `preadd_i'"
        }
        if `premultiply_i' != 1 {
            local lbl_premultiply_i "*`premultiply_i'"
        }
        label var `fn'`var' "`fn'(`var'`lbl_premultiply_i'`lbl_preadd_i')"
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
