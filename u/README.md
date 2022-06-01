# uniqueby

`uniqueby` is a Stata module to report number of unique values by group. It displays and stores the number of unique values of a variable for each group specified in `by()` option.

For example,
```stata
sysuse auto
uniqueby mpg, by(foreign)
```
displays:
```
Number of unique values of mpg is 21
       17 unique values of mpg if foreign = 0 (Domestic)
       13 unique values of mpg if foreign = 1 (Foreign)
```
and saves:
```
macros:
         r(r_foreign1) : "13"
         r(N_foreign1) : "22"
         r(r_foreign0) : "17"
         r(N_foreign0) : "52"
                  r(r) : "21"
                  r(N) : "74"
```
