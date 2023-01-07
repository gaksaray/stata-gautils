*! version 1.5.1  06apr2021  Gorkem Aksaray <aksarayg@tcd.ie>

capture program drop reshape2l
program reshape2l
	version 12
	syntax newvarlist, i(varlist) [j(name) Counter]
	
	local stublist `varlist'
	
	* Confirm j is a new variable if specified
	if "`j'" != "" {
		confirm new variable `j'
	}
	
	* Error if any stub is the same as j
	if subinword("`stublist'", "`j'", "", .) != "`stublist'" {
		noi di as err "j = {bf:`j'} cannot be used as a stub"
		error 101
		exit
	}
	
	local jlist "" // will be used for `jnote'
	local passcount = 0 // will be used to calculate `min' and `max'
	
	* Unabbreviate used variable list for all stubs
	foreach stub of local stublist {

		// unabbreviate variables starting with `stub'
		capture unab `stub'vars : `stub'*
		if _rc {
			noi di as err "no variables with stub {bf:`stub'} found"
			exit _rc
		}
		
		// pick the numeric or string after `stub'
		local `stub'num = `: word count ``stub'vars''
		forvalues n = 1/``stub'num' {
			local `stub'var = word("``stub'vars'", `n')
			local w = regexr("``stub'var'", "^`stub'", "")
			
			capture confirm number `w'
			
			// if w is string
			if _rc {
				noi di as err "warning: variable {bf:``stub'var'} contains nonnumeric `j' {bf:`w'}"
			}
			
			// if w is numeric
			else if !_rc {
				local ++passcount
				
				local r = real("`w'")
				
				// add r to jlist
				local jlist = "`jlist'" + " `r' "
				
				// calculate range of r
				if `n' == 1 & `passcount' == 1 { //record r as is in the first pass
					local min = `r'
					local max = `r'
				}
				else {
					local min = min(`r', `min')
					local max = max(`r', `max')
				}
				local usedvarlist `usedvarlist' `stub'`r'
			}
		}
	}
	
	* Save unused variable list
	qui ds `i' `usedvarlist', not
	local unusedvarlist `r(varlist)'
	
	* Simplify jlist to produce jnote
	forvalues n = `min'/`max' {
		if strpos("`jlist'", " `n' ") != 0 {
			local jnote `jnote' `n'
		}
	}
	di as text "(note: j = `jnote')"
	
	* Save main data
	tempfile main
	qui save "`main'"
	
	* Get the list of `n'th variable of all stubs
	forvalues n = `min'/`max' {
		foreach stub of local stublist {
			capture confirm variable `stub'`n'
			if !_rc {
				local vars`n' `vars`n'' `stub'`n'
			}
		}
	}
	
	* Set counter
	if "`counter'" != "" {
		local displist "10, 20, 30, 40, 50, 60, 70, 80, 90, 101"
		local count = 0
		forvalue n = `min'/`max' {
			if "`vars`n''" == "" continue
			local ++count
		}
		local cratio "(100 / `count')"
		di "Progress:"
	}
	
	local N = 0
	forvalues n = `min'/`max' {
		
		* Pass `n' if the list of `n'th variables of all stubs is empty
		if "`vars`n''" == "" continue
		local ++N
		
		* Reload main data
		qui use `i' `vars`n'' `unusedvarlist' using "`main'", clear
		
		* Delete the number after `stub'
		foreach stub of local stublist {
			capture confirm variable `stub'`n'
			if !_rc {
				rename `stub'`n' `stub'
			}
		}
		
		* Generate j
		if "`j'" == "" {
			local j _j
		}
		generate `j' = `n'
		
		* Build `files' for concentation
		tempfile temp
		qui save "`temp'", replace
		local files `"`files'"`temp'" "'
		macro drop _vars
		
		* Counter display
		if "`counter'" != "" {
			local pct = `N' * `cratio'
			local intpct = `pct' - mod(`pct', 10)
			if inlist(`intpct', `displist') {
				local displist = subinstr("`displist'", "`intpct', ", "", .)
				di %2.0f `intpct' "%"
			}
		}
	}
	
	* Concatenate
	if "`counter'" != "" {
		di "... appending"
	}
	clear
	qui append using `files', nolabel nonotes
	
	* Order and sort
	order `i' `j' `unusedvarlist'
	sort  `i' `j'
end
