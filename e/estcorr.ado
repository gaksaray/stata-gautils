*! version 1.0  02jul2021  Gorkem Aksaray <aksarayg@tcd.ie>
*! Post correlations in sequential manner
*!
*! Description
*! -----------
*!   This module is a wrapper for estpost correlate. It saves correlations
*!   in a sequential manner such that the output is a lower triangular
*!   matrix. Furthermore, it has the ability to group correlations into
*!   two groups so that a wide correlations table can be divided into two
*!   narrower tables, which can then be combined into a one long table.
*!   It also returns two macros, r(coeflabels) and r(mnumbers), that can be
*!   used as arguments in esttab (or estout) to automatically label
*!   coefficients and number columns.
*!
*! Dependencies
*! ------------
*!   ssc install estout
*!
*! Example
*! -------
*!   sysuse auto, clear
*!   eststo clear
*!   local varlist "price mpg rep78 headroom trunk weight length"
*!   estcorr `varlist', split
*!   eststo dir
*!   esttab estPt1*, nogaps compress
*!   esttab estPt2*, nogaps compress
*!   
*!   local varlist "price mpg rep78 headroom trunk weight length"
*!   estcorr `varlist', pre(cor) splitat(4) listwise qui
*!   eststo dir
*!   esttab corPt1*, nogaps compress
*!   esttab corPt2*, nogaps compress
	
capture program drop estcorr
program estcorr, rclass
    version 12
    #delimit ;
	syntax varlist [if]
    [,
    PREfix(name)
    split splitat(numlist int min=1 max=1 >0)
    LISTwise CASEwise *
    ]
    ;
    #delimit cr
    
    if strpos("`options'", "matrix") > 0 {
    	di as err "matrix option not allowed"
        exit 198
    }
	
	if "`prefix'" == "" {
		local prefix "est"
	}
	
	if "`splitat'" != "" {
		local split "split"
	}
	
	if "`split'" != "" {
		if "`splitat'" != "" {
			local splitcol `splitat'
		}
		else {
			local splitcol = floor(wordcount("`varlist'") / 2)
		}
	}
	else {
		local splitcol = wordcount("`varlist'")
	}
	
	if "`listwise'" != "" | "`casewise'" != "" {
		local lwvars = subinstr(stritrim("`varlist'"), " ", ", ", .)
		tempname lwsample
		qui generate `lwsample' = 1 if !missing(`lwvars')
		
		if "`if'" != "" {
			local if "`if' & `lwsample' == 1"
		}
		else {
			local if "if `lwsample' == 1"
		}
	}
	
	// Part I:
	
	if "`split'" != "" {
		local pre `prefix'Pt1_
	}
	else {
		local pre `prefix'
	}
	
	local mnumbers
	local coeflabels
	local vars `varlist'
	local i 1
	
	foreach var in `vars' {
		if inrange(`i', 1, `splitcol') {
			eststo `pre'`i': estpost correlate `var' `vars' `if', `options'
			local mnumbers `"`mnumbers' "(`i')""'
		}
		local coeflabels `"`coeflabels' `var' "(`i') `: variable label `var''""'
		local vars : list vars - var
		local ++i
	}
	
	if "`split'" == "" {
		return local mnumbers `"`mnumbers'"'
		return local coeflabels `"`coeflabels'"'
	}
	else {
		return local splitcol `"`splitcol'"'
		return local mnumbers1 `"`mnumbers'"'
		return local coeflabels1 `"`coeflabels'"'
	}
	
	// Part II:
	
	if "`split'" != "" {
	
		local pre `prefix'Pt2_
	
		local mincol = `splitcol' + 1
		local maxcol = floor(wordcount("`varlist'") / 2) * 2
		
		local mnumbers
		local coeflabels
		local vars `varlist'
		local i 1
		
		foreach var in `vars' {
			if inrange(`i', `mincol', `maxcol') {
				eststo `pre'`i': estpost correlate `var' `vars' `if', `options'
				local mnumbers `"`mnumbers' "(`i')""'
			}
			if `i' >= `mincol' {
				local coeflabels `"`coeflabels' `var' "(`i') `: variable label `var''""'
			}
			local vars : list vars - var
			local ++i
		}
		
		return local mnumbers2 `"`mnumbers'"'
		return local coeflabels2 `"`coeflabels'"'
	}
	
	qui capture drop `lwsample'
end
