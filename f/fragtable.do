version 17
clear all
cd ~

sysuse auto, clear
regress price mpg
estimates store m1
etable, est(m1) export(table1.tex,replace) // full document with table env.
capture mkdir results
fragtable, saving(results/regtab1, replace) // only tabular env.
