*! version 1.2  10jul2021  Gorkem Aksaray <gaksaray@ku.edu.tr>

capture program drop dichotomize
program dichotomize
    version 12
    #delimit ;
	syntax varname
    ,
    GENerate(name)
    [
	INlist(numlist) leq(numlist min=1 max=1) geq(numlist min=1 max=1)
	LABel(string)
	first last after(varname) before(varname)
    ]
    ;
	#delimit cr
    
	confirm new variable `generate'
	
	if "`inlist'" != "" {
		if wordcount("`inlist'") > 250 { // exceeds the inlist() limit
			di as err "number of inlist() arguments may not exceed 250"
			exit 130
		}
		local inlist = subinstr("`inlist'", " ", ", ", .)
	}
	
	// define base conditions (cond _i (inlist), _l(leq), and _g(geq))
	if "`inlist'" != "" {
		local cond_i inlist(`varlist', `inlist')
	}
	if "`leq'" != "" {
		local cond_l `varlist' <= `leq'
	}
	if "`geq'" != "" {
		local cond_g `varlist' >= `geq'
	}
	
	// define range condition (cond _r (range))
	if "`leq'" != "" & "`geq'" == "" {
		local cond_r `cond_l'
	}
	if "`leq'" == "" & "`geq'" != "" {
		local cond_r `cond_g'
	}
	if "`leq'" != "" & "`geq'" != "" {
		if `leq' < `geq' {
			local cond_r `cond_l' | `cond_g'
		}
		if `leq' >= `geq' {
			local cond_r inrange(`varlist', `geq', `leq')
		}
	}
	
	// define end condition (i.e., paste conditions)
	if "`cond_i'" != "" & "`cond_r'" == "" {
		local cond `cond_i'
	}
	if "`cond_i'" == "" & "`cond_r'" != "" {
		local cond `cond_r'
	}
	if "`cond_i'" != "" & "`cond_r'" != "" {
		local cond `cond_i' | `cond_r'
	}
	
	// order error messages
	if "`before'" != "" & "`after'" != "" {
		di as err "before() may not be combined with after"
		exit 198
	}
	if "`before'" != "" & "`first'" != "" {
		di as err "before() may not be combined with first"
		exit 198
	}
	if "`before'" != "" & "`last'" != "" {
		di as err "before() may not be combined with last"
		exit 198
	}
	if "`after'" != "" & "`first'" != "" {
		di as err "before() may not be combined with after"
		exit 198
	}
	if "`after'" != "" & "`last'" != "" {
		di as err "before() may not be combined with after"
		exit 198
	}
	if "`first'" != "" & "`last'" != "" {
		di as err "first may not be combined with last"
		exit 198
	}
	
	// set placement (order)
	local placement ", after(`varlist')" // default placement is after dichotomized variable
	if "`before'" != "" {
		local placement ", before(`before')"
	}
	if "`after'" != "" {
		local placement ", after(`after')"
	}
	if "`first'" != "" {
		local placement ", first"
	}
	if "`last'" != "" {
		local placement ", last"
	}
	
	// create the dichotomous variable
	generate `generate' = cond(`cond', 1, 0) if !missing(`varlist')
	if "`label'" != "" {
		label variable `generate' `"`label'"'
	}
	order `generate' `placement'
end
