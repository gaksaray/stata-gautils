*! version 0.2  08jan2023  Gorkem Aksaray <aksarayg@tcd.ie>
*! Fragmentize LaTeX tables exported by collect suite of commands
*! 
*! Syntax
*! ------
*!   fragtable using filename[.tex] [, SAVing(filename[.tex] [, replace]) NOIsily]
*! 
*! Example
*! -------
*!   sysuse auto, clear
*!   regress price mpg
*!   estimates store m1
*!   etable, est(m1) export(table1.tex, replace) tableonly // full table env.
*!   capture mkdir results
*!   fragtable, saving(results/regtab1.tex, replace) // only tabular env.

capture program drop fragtable
program fragtable
    version 17
    
    syntax [using/] [, SAVing(string asis) NOIsily]
    
    if `"`using'"' == "" {
        if `"`s(filename)'"' == "" {
            di as err "last LaTeX table from {bf: collect export} not found"
            exit 197
        }
        else {
            local using `"`s(filename)'"'
        }
    }
    
    if `"`saving'"' == "" {
        local saving `"`using'"'
        local replace "replace"
    }
    if `"`saving'"' != "" {
        local _using `"`using'"' // protect main `using'
        local 0 `"using `saving'"'
        syntax using/ [, replace]
        local saving `"`using'"'
        local replace "`replace'"
        local using `"`_using'"'
    }
    
    mata: st_local("suffix", pathsuffix(`"`using'"'))
/*
    if `"`suffix'"' == "" {
        local suffix ".tex"
        local using `"`using'`suffix'"'
    }
*/
    if `"`suffix'"' != ".tex" {
        di as err "{p 0 0 2}"
        di as err "incorrect file type specified"
        di as err "in {bf:using};"
        di as err "only .tex files allowed"
        di as err "{p_end}"
        exit 198
    }
    
    mata: st_local("suffix", pathsuffix(`"`saving'"'))
/*
    if `"`suffix'"' == "" {
        local suffix ".tex"
        local saving `"`saving'`suffix'"'
    }
*/
    if `"`suffix'"' != ".tex" {
        di as err "{p 0 0 2}"
        di as err "incorrect file type specified"
        di as err "in {bf:saving()};"
        di as err "only .tex files allowed"
        di as err "{p_end}"
        exit 198
    }
    
    confirm file `"`using'"'
    
    tempname fh
    tempname tf
    tempfile tmp
    local linenum = 0
    file open `fh' using `"`using'"', read
    file open `tf' using `"`tmp'"', write
    file read `fh' line
    local keepline = 0
    while r(eof)==0 {
        if strpos(`"`macval(line)'"', "\begin{tabular}") != 0 {
            local keepline = 1
        }
        if strpos(`"`macval(line)'"', "\end{tabular}") != 0 {
            file write `tf' `"`macval(line)'"'
            if "`noisily'" != "" di `"`macval(line)'"' _n
            local keepline = 0
        }
        if `keepline' == 1 {
            if "`noisily'" != "" di as txt `"`macval(line)'"'
            file write `tf' `"`macval(line)'"' _n
        }
        file read `fh' line
    }
    file close `tf'
    
    copy `"`tmp'"' `"`saving'"', `replace'
    mata: st_local("basename", pathbasename(`"`saving'"'))
    di as txt `"(fragment table saved to file {browse `"`saving'"':`basename'})"'
end
