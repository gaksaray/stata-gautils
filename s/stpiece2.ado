*! version 1.0.1  22apr2021  Gorkem Aksaray <aksarayg@tcd.ie>
*!
*! Description
*! -----------
*!   stpiece2 estimates piecewise-constant exponential model while allowing for
*!   factor variables in model specification.
*! 
*! Syntax
*! ------
*!   stpiece2 [varlist] [if] [in] [, tp(numlist) tv(varlist) presplit(#) nopreserve]
*! 
*! Example
*! -------
*!   webuse cancer, clear
*!   generate n = _n
*!   stset studytime, failure(died) id(n)
*!   stpiece2, tp(0(10)40)
*!   stpiece2 i.drug, tp(0(10)40) tv(age) preserve
*!   stpiece2 i.drug, tv(age) pre(4)
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
    
    streg `tplist' `tvlist' `varlist' `if' `in', nocons dist(e) `options'
end
