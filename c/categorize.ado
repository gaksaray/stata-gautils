*! version 0.3  19jan2023  Gorkem Aksaray <aksarayg@tcd.ie>
*! Create indicator variables with corresponding value labels
*! 
*! Syntax
*! ------
*!   sysuse varname [, stub(name) label(string) {base|base(#)} order_options]
*!
*!      where order_options are first, last, Before(varname), and After(varname)
*! 
*! Examples
*! --------
*!   sysuse lifeexp, clear
*!   categorize region, first
*!   categorize region, stub(cont) label(Continent) base(2)
*!   categorize lexp, label(LEXP)

capture program drop categorize
program categorize
    cap syntax varname [, stub(name local) label(string) base(numlist min=1 max=1 integer) ///
                          first last Before(varname) After(varname)]
    if _rc {
        syntax varname [, stub(name local) label(string) base                              ///
                          first last Before(varname) After(varname)]
    }
    
    confirm numeric variable `varlist'
    tab `varlist'
    
    if "`stub'" == "" {
        local stub "`varlist'"
    }
    
    if "`label'" == "" {
        local varlab : variable label `varlist'
        if "`varlab'" != "" local label "`varlab'"
        else                local label "`varlist'"
    }
    
    qui levelsof `varlist', local(ls)
    
    if "`base'" == "base" {
        local base = word("`ls'", 1)
    }
    else if "`base'" != "" {
        if strpos(" `ls' ", " `base' ") == 0 {
            di as err _n "{bf:base()} options is incorrectly specified"
            exit 198
        }
    }
    
    local stublist ""
    foreach l of local ls {
        confirm integer number `l'
        
        local vallab_`l' : label (`varlist') `l'
        
        local newvarlab "`label' = `vallab_`l''"
        
        if "`l'" == "`base'" {
            local basevarlab "`newvarlab'"
            di _n "Base category `base' (`basevarlab') is skipped."
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
    
    if "`base'" != "" {
        foreach stub in `stublist' {
            note `stub': Base category: `base' (`basevarlab')
        }
    }
end
