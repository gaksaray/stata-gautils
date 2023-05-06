*! version 0.4  06may2023  Gorkem Aksaray <aksarayg@tcd.ie>
*! Create indicator variables with automatic variable labels
*! 
*! Syntax
*! ------
*!   categorize varname [, stub(name) label(string) {base|base(#)} order_options]
*!
*!      where order_options are first, last, Before(varname), and After(varname)
*! 
*! 
*! Description
*! -----------
*!   categorize creates indicator variables based on a variable with
*!   integer values, and automatically labels them in the form of
*!   "variable label = value label". It is essentially a more convenient
*!   implementation of tab, gen().
*! 
*! Examples
*! --------
*!   sysuse lifeexp, clear
*!   categorize region, first
*!   categorize region, stub(cont) label(Continent) base(2)
*!   categorize lexp, label(LEXP)

capture program drop categorize
program categorize
    syntax varname [, stub(name local) label(string) base BASE2(numlist min=1 max=1 integer) *]
    
    confirm numeric variable `varlist'
    
    if "`stub'" == "" {
        local stub "`varlist'"
    }
    
    if "`label'" == "" {
        local varlab : variable label `varlist'
        if "`varlab'" != "" local label "`varlab'"
        else                local label "`varlist'"
    }
    
    if "`base'" != "" & "`base2'" != "" {
        di as err "{bf:base} and {bf:base()} options cannot be specified simultaneously"
        exit 198
    }
    
    qui levelsof `varlist', local(varlevels)
    
    if "`base'" != "" {
        local baselevel = word("`varlevels'", 1)
    }
    else if "`base2'" != "" {
        local baselevel = word("`varlevels'", `base2')
    }
    
    tab `varlist'
    
    local stublist ""
    foreach l of local varlevels {
        confirm integer number `l'
        
        local vallab_`l' : label (`varlist') `l'
        
        local newvarlab "`label' = `vallab_`l''"
        
        if "`l'" == "`baselevel'" {
            local baselevellab "`newvarlab'"
            di as txt _n `"(note: base category `baselevel' = "`vallab_`l''" is skipped.)"'
            continue
        }
        
        qui generate `stub'`l' = cond(`varlist' == `l', 1, 0) if !missing(`varlist')
        label variable `stub'`l' "`newvarlab'"
        
        local stublist "`stublist' `stub'`l'"
    }
    
    if "`options'" != "" {
        order `stublist', `options'
    }
    else {
        order `stublist', after(`varlist')
    }
    
    if "`baselevel'" != "" {
        foreach stub in `stublist' {
            note `stub': Base category: `baselevel' (`baselevellab')
        }
    }
end
