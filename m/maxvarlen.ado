*! version 1.1  09jul2021  Gorkem Aksaray <gaksaray@ku.edu.tr>
*! Calculate and return maximum character length of list of variables
*! or their variable labels.
*!
*! Syntax
*! ------
*!   maxvarlen varlist [, LABels]
*!
*! Examples
*! --------
*!   sysuse auto, clear
*!   maxvarlen rep78 headroom         // r(chars) = 8 in "headroom"
*!   maxvarlen rep78 headroom, labels // r(chars) = 18 in "Repair record 1978"

capture program drop maxvarlen
qui program maxvarlen, rclass
	syntax varlist [, LABels]
			
	local maxvarlen 0
	foreach var of local varlist {
		if "`labels'" != "" {
			local varlen = strlen("`: variable label `var''")
		}
		else if "`labels'" == "" {
			local varlen = strlen("`var'")
		}
		if `varlen' > `maxvarlen' {
			local maxvarlen `varlen'
		}
	}
	
	return scalar chars = `maxvarlen'
	di as text `maxvarlen'
end
