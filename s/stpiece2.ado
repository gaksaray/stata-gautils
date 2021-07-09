*! version 1.0  09jul2021  Gorkem Aksaray <gaksaray@ku.edu.tr>
*! Estimate piecewise-constant exponential model (allows factor variables)
*! 
*! Syntax
*! ------
*!   stpiece [varlist] [if] [in] [, tp(numlist) tv(varlist) presplit(#) nopreserve]
*! 
*! Example
*! -------
*!   webuse cancer, clear
*!   generate n = _n
*!   stset studytime, failure(died) id(n)
*!   stpiece, tp(0(10)40)
*!   stpiece i.drug, tp(0(10)40) tv(age) preserve
*!   stpiece i.drug, tv(age) pre(4)
*! 
*! Acknowledgement
*! ---------------
*!   This is a modern rewrite of stpiece command by Jesper B. Sorensen.
*!   See https://ideas.repec.org/c/boc/bocode/s396801.html.

capture program drop stpiece2
program stpiece2
    version 12
    #delimit ;
    syntax [varlist(default=none numeric fv)] [if] [in]
    [,
    tp(numlist >=0) tv(varlist) PREsplit(integer -1) noPREserve *
    ]
	;
    #delimit cr
    
    if "`preserve'" == "" {
        preserve
    }
    
    if "`presplit'" == "-1" {
        if "`tp'" == "" {
            di as err "tp() option must be specified if the data is not presplit"
            exit 198
        }
        qui stsplit tp, at(`tp')
        qui tab tp, gen(_tp)
        local i = r(r)
        drop tp
    }
    else {
        local i "`presplit'"
    }
    qui ds _tp*
    local tplist = r(varlist)
    
    if "`tv'" != "" {
        foreach var of varlist `tv' {
            local stub = substr("`var'", 1, 4)
            local j = 0
            while `j' < `i' {
                local ++j
                cap qui gen _`stub'_tp`j' = `var' * _tp`j'
            }
        }
        qui ds _`stub'_tp*
        local tvlist = r(varlist)
    }
    
    streg `tplist' `tvlist' `varlist' `if' `in', nocons d(e) `options'
end