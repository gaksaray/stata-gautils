clear
set seed 1987
set obs 10000

generate id = _n
gen sex = runiform() < 0.5

forvalues i = 1/1000 {
	generate x`i' = runiform()
	generate y`i' = rnormal()
	generate z`i' = rlogistic()
}

tempfile testdata
save "`testdata'"

timer clear

use "`testdata'", clear

timer on 1
reshape long x y z, i(id) j(denom)
timer off 1

use "`testdata'", clear

timer on 2
reshape2l x y z, i(id) j(denom)
timer off 2

timer list
