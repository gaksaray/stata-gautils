*! version 1.4  17apr2023  Gorkem Aksaray <aksarayg@tcd.ie>
*! Add new variables that are functions of existing variables
*!
*! Syntax
*! ------
*!   mutate fn varlist, fnopts Label(label_string, [upper | lower | proper])
*!
*!   fn is one of:
*!     sq for square
*!     sqrt for square root
*!     ln or log for logarithm
*!     e or exp for exponentiation
*!
*!   fn can be also written in the form of Fn or FN (for example Sq or SQ for
*!   square). The newly created variables will be named accordingly. For example,
*!   if fn=sq, new variables will be named varlistsq; whereas if fn=Sq, they
*!   will be named varlistSq. By default, when fn = {sq|sqrt} mutate creates
*!   varlistfn; when fn=ln it creates lnvarlist, and when fn=exp it creates
*!   e_varlist.
*!
*!   fnopts:
*!     for fn=sq
*!       [, scale(integers)]
*!     where
*!       scale divides the squared term by 10 to the power of x.
*!
*!     for fn = ln or log (synonyms)
*!       [, PREMultiply(reals or missings) PREAdd(reals or missings)]
*!     where
*!       premultiply multiplies by x before taking the log.
*!       preadd adds x before taking the log
*!
*!     for fn = sqrt and fn = exp, there are currently no options.
*!   
*!   Function options can take as many numbers as the number of variables in
*!   varlist. For example, if there are 4 variables to mutate sq, you can
*!   specify scale(2 . 3), in which case the first squared term will be scaled
*!   by 10^2, the second squared term will be scaled by 10^0=1 (default), and
*!   the rest of the squared terms will be scaled by 10^3.
*!   
*!   label_string is an expression of label added to created variables
*!   It can include special symbols to be replaced as follows:
*!     @ - label of mutated (original) variable
*!         This can be manipulated by one of upper, lower, or proper options
*!         (see help f_strupper)
*!     # - first option (scale when fn=sq; premultiply when fn=ln or =log)
*!     % - second option (10^scale when fn=sq; preadd when fn=ln or log)
*!
*!   If label option is not specified, mutate uses variable names (along with
*!   the actual formula used) to label new variables.
*!
*! Examples
*! --------
*!   sysuse auto, clear
*!   local varlist "price trunk weight length"
*!   keep `varlist'
*!   mutate sq   `varlist', scale(3 . 2)
*!   mutate ln   `varlist', prem(. . 10) prea(250.5 1 .) l(Ln(@), lower)
*!   mutate log  `varlist', prem(. . 10) prea(250.5 1 .) l(Log @, proper)
*!   mutate sqrt `varlist'
*!   mutate exp  `varlist'
*!
*! Changelog
*! ---------
*!   [1.4]
*!     Added label option. Allowed variations of fn to name new variables.
*!   [1.3.1]
*!     Minor bug fix: better varlist expansion.
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
    
    gettoken fn varlist: arguments
    
    local _fn = strlower("`fn'") // internal representation of fn
    if !inlist("`_fn'", "sq", "sqrt", "ln", "log", "e", "exp") {
        error 198
        exit 198
    }
    
    qui ds `varlist'
    confirm numeric variable `r(varlist)'
    
    if "`_fn'" == "sq" {
        _mutate_sq      `varlist', _fn(`_fn') fn(`fn') `options'
    }    
    if "`_fn'" == "sqrt" {
        _mutate_sqrt    `varlist', _fn(`_fn') fn(`fn') `options'
    }
    if inlist("`_fn'", "ln", "log") {
        _mutate_ln      `varlist', _fn(`_fn') fn(`fn') `options'
    }
    if inlist("`_fn'", "e", "exp") {
        _mutate_exp     `varlist', _fn(`_fn') fn(`fn') `options'
    }
    
end

capture program drop _mutate_sq
program define _mutate_sq
    syntax varlist, _fn(string) fn(string) ///
        [scale(numlist int miss min=1 >0) Label(string asis)]
    
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
        
        generate `var'`fn'= `var'^2 / 10^`scale_i', after(`var')
        
        local lab_scale_i ""
        if `scale_i' == 0 {
            local lab_scale_i
        }
        else if `scale_i' == 1 {
            local lab_scale_i " / 10"
        }
        else if `scale_i' > 1 {
            local lab_scale_i " / 10^`scale_i'"
        }
        
        if `"`label'"' != "" {
            _parse_label `label'
            _mutate_label `var', ///
                labstr(`r(labstr)') strmode(`r(strmode)') ///
                opt1(`scale_i') opt2(`= 10^`scale_i'')
            label variable `var'`fn' "`r(label)'"
        }
        else {
            label variable `var'`fn' "`var'^2`lab_scale_i'"
        }
    }
end

capture program drop _mutate_sqrt
program define _mutate_sqrt
    syntax varlist, _fn(string) fn(string) ///
        [Label(string asis)]
    
    foreach var of varlist `varlist' {
        generate `var'`fn' = sqrt(`var'), after(`var')
        
        if `"`label'"' != "" {
            _parse_label `label'
            _mutate_label `var', ///
                labstr(`r(labstr)') strmode(`r(strmode)')
            label variable `var'`fn' "`r(varlab)'"
        }
        else {
            label variable `var'`fn' "sqrt(`var')"
        }
    }
end

capture program drop _mutate_ln
program define _mutate_ln
    syntax varlist, _fn(string) fn(string) ///
        [PREAdd(numlist miss min=1) PREMultiply(numlist miss min=1) Label(string asis)]
    
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
        
        local lab_preadd_i
        local lab_premultiply_i
        if `premultiply_i' != 1 {
            local lab_premultiply_i "*`premultiply_i'"
        }
        else if `premultiply_i' == 1 {
            local premultiply_i ""
        }
        if `preadd_i' != 0 {
            local lab_preadd_i " + `preadd_i'"
        }
        else if `preadd_i' == 0 {
            local preadd_i ""
        }
        if `"`label'"' != "" {
            _parse_label `label'
            _mutate_label `var', ///
                labstr(`r(labstr)') strmode(`r(strmode)') ///
                opt1(`premultiply_i') opt2(`preadd_i')
            label variable `fn'`var' "`r(label)'"
        }
        else {
            label variable `fn'`var' "`_fn'(`var'`lab_premultiply_i'`lab_preadd_i')"
        }
    }
end

capture program drop _mutate_exp
program define _mutate_exp
    syntax varlist, _fn(string) fn(string) ///
        [Label(string asis)]
    
    foreach var of varlist `varlist' {
        generate `fn'_`var' = exp(`var'), after(`var')
        
        if `"`label'"' != "" {
            _parse_label `label'
            _mutate_label `var', ///
                labstr(`r(labstr)') strmode(`r(strmode)')
            label var `fn'_`var' "`r(label)'"
        }
        else {
            label var `fn'_`var' "`_fn'(`var')"
        }
    }
end

capture program drop _parse_label
program define _parse_label, rclass
    syntax anything(name=labstr) [, lower upper proper]
    
    if ("`lower'" != "") + ("`upper'" != "") + ("`proper'" != "") > 1 {
        error 198
        exit
    }
    if "`lower'"  != "" {
        local strmode "strlower"
    }
    if "`upper'"  != "" {
        local strmode "strupper"
    } 
    if "`proper'" != "" {
        local strmode "strproper"
    }
    
    return local labstr "`labstr'"
    return local strmode "`strmode'"
end

capture program drop _mutate_label
program define _mutate_label, rclass
    syntax varname [, labstr(string) strmode(string) opt1(numlist) opt2(numlist)]
    
    local varlab : variable label `varlist'
    if "`strmode'" != "" {
        local varlab = `strmode'("`varlab'")
    }
    
    if "`opt1'" != "" {
        local opt1 = trim(strofreal(`opt1', "%99.0gc"))
    }
    if "`opt2'" != "" {
        local opt2 = trim(strofreal(`opt2', "%99.0gc"))
    }
    
    local newlab = subinstr("`labstr'", "@", "`varlab'", .)
    local newlab = subinstr("`newlab'", "#", "`opt1'", .)
    local newlab = subinstr("`newlab'", "%", "`opt2'", .)
    
    return local label "`newlab'"
end
