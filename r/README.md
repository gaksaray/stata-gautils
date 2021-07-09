# reshape2l

`reshape2l` is a Stata module to quickly convert data from wide to long form. It is primarily used in situations where *stubnames* are followed by numeric parts, which is often the case for raw panel datasets.

`reshape2l` is similar to [`reshape long`](https://www.stata.com/help.cgi?reshape) but significantly faster, especially for large (and wide) datasets where memory requirement gets very high and `reshape long` becomes very slow. It achieves faster speeds by relying on secondary storage rather than memory. The speed gain of `reshape2l` over `reshape long` increases with size and width of the dataset as well as read and write speed of storage device where the [STATATMP](https://www.stata.com/support/faqs/data-management/statatmp-environment-variable/) folder resides.

## Test

You can compare the speed of `reshape2l` against `reshape long`:

```stata
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
```

On my laptop with SSD, here are the results:

```stata
. timer list
   1:    614.39 /        1 =     614.3910
   2:     58.44 /        1 =      58.4410
```
