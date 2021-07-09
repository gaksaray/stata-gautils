*! version 1.0  07feb2021  Gorkem Aksaray

capture program drop uniqueby
program uniqueby, rclass sortpreserve
	syntax varname [if/] [in][, by(varname)]
	
	if "`if'" != "" {
		local ifexp & `if'
		local ifcond if `if'
	}
	
	qui levelsof `varlist' `ifcond' `in'
	return local N `r(N)'
	return local r `r(r)'
	di as text "Number of unique values of {bf:`varlist'} is `r(r)'"
	
	if "`by'" != "" {
		qui levelsof `by', local(bylevels)
		foreach bylevel of local bylevels {
			qui levelsof `varlist' if `by' == `bylevel' `ifexp' `in'
			return local N_`by'`bylevel' `r(N)'
			return local r_`by'`bylevel' `r(r)'
			if "`:value label `by''" != "" {
				di as text %9.0f `r(r)' " unique values of {bf:`varlist'} if {bf:`by'} = `bylevel' (`:label `:value label `by'' `bylevel'')"
			}
			else {
				di as text %9.0f `r(r)' " unique values of {bf:`varlist'} if {bf:`by'} = `bylevel'"
			}
		}
	}
end
