*! version 0.1  06may2023  Gorkem Aksaray <aksarayg@tcd.ie>
*! Style LaTeX tables exported by the collect suite of commands
*! 
*! Changelog
*! ---------
*!   [0.1]
*!     - Initial version.

capture program drop styletextab
program styletextab, rclass
    version 18
    syntax [using/] [, SAVing(string asis)                  ///
                       FRAGment TABLEonly LScape noBOOKtabs ///
                       LABel(string) BEFOREtext(string) AFTERtext(string)]
    
    if `"`using'"' == "" {
        if `"`s(filename)'"' == "" {
            di as err "last TeX table from {bf: collect export} not found"
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
    else if `"`saving'"' != "" {
        local _using `"`using'"' // protect main `using'
        local 0 `"using `saving'"'
        syntax using/ [, replace]
        local saving `"`using'"'
        local replace "`replace'"
        local using `"`_using'"'
    }
    
    mata: suffix = subinstr(pathsuffix(`"`using'"'), ".", "")
    mata: st_local("suffix", suffix)
    
    if `"`suffix'"' == "" {
        local suffix "tex"
        local using `"`using'.`suffix'"'
    }
    else if `"`suffix'"' != "tex" {
        di as err "{p 0 0 2}"
        di as err "incorrect file type specified"
        di as err "in {bf:using};"
        di as err "only .tex files allowed"
        di as err "{p_end}"
        exit 198
    }
    
    mata: suffix = subinstr(pathsuffix(`"`saving'"'), ".", "")
    mata: st_local("suffix", suffix)
    
    if `"`suffix'"' == "" {
        local suffix "tex"
        local saving `"`saving'.`suffix'"'
    }
    else if `"`suffix'"' != "tex" {
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
    file open `fh' using `"`using'"', read
    file open `tf' using `"`tmp'"', write
    
    if "`fragment'" == "" {
    if "`tableonly'" == "" {
    
    * preamble
    file write `tf' "\documentclass{article}" _n
    if "`lscape'" != "" {
        file write `tf' "\usepackage{pdflscape}" _n
    }
    if "`booktabs'" != "nobooktabs" {
        file write `tf' "\usepackage{booktabs}" _n
    }
    file write `tf' "\usepackage{multirow}" _n
    file write `tf' "\usepackage[para,flushleft]{threeparttable}" _n
    file write `tf' "\usepackage{amsmath}" _n
    file write `tf' "\usepackage{ulem}" _n
    file write `tf' "\usepackage[table]{xcolor}" _n
    
    file write `tf' "\begin{document}" _n
    
    * beforetext
    if "`beforetext'" != "" {
        file write `tf' _n "`beforetext'" _n(2)
    }
    
    } // tableonly
    if "`lscape'" != "" {
        file write `tf' "\begin{landscape}" _n
    }
    file write `tf' "\begin{table}[!h]" _n
    
    * caption
    file seek `fh' tof
    file read `fh' line
    while r(eof) == 0 {
        if strpos(`"`macval(line)'"', "\caption") != 0 {
            file write `tf' `"`macval(line)'"' _n
            if "`label'" != "" {
                file write `tf' "\label{`label'}" _n
            }
        }
        else if `"`macval(line)'"' == "\centering" {
            file write `tf' `"`macval(line)'"' _n
            file seek `fh' eof
        }
        file read `fh' line
    }
    
    file write `tf' "\begin{threeparttable}" _n
    
    } // fragment
    
    * tabular
    file seek `fh' tof
    file read `fh' line
    local keepline = 0
    while r(eof) == 0 {
        if strpos(`"`macval(line)'"', "\begin{tabular}") != 0 {
            local keepline = 1
        }
        if `keepline' == 1 {
            if "`booktabs'" == "nobooktabs" & strpos(`"`macval(line)'"', "\cmidrule") != 0 {
                local newline = subinstr(`"`macval(line)'"', "\cmidrule", "\cline", .)
                file write `tf' `"`newline'"' _n
            }
            else if "`booktabs'" != "nobooktabs" & strpos(`"`macval(line)'"', "\cline") != 0 {
                local newline = subinstr(`"`macval(line)'"', "\cline", "\cmidrule", .)
                file write `tf' `"`newline'"' _n
            }
            else {
                file write `tf' `"`macval(line)'"' _n
            }
        }
        if strpos(`"`macval(line)'"', "\end{tabular}") != 0 {
            local keepline = 0
        }
        file read `fh' line
    }
    
    if "`fragment'" == "" {
    
    file write `tf' "\begin{tablenotes}" _n
    
    * footnotes
    file seek `fh' tof
    file read `fh' line
    local keepline = 0
    while r(eof) == 0 {
        if `"`macval(line)'"' == "\footnotesize{" {
            local keepline = 1
        }
        if `keepline' == 1 {
            file write `tf' `"`macval(line)'"' _n
        }
        if `"`macval(line)'"' == "}" {
            local keepline = 0
        }
        file read `fh' line
    }
    
    file write `tf' "\end{tablenotes}" _n
    file write `tf' "\end{threeparttable}" _n
    file write `tf' "\end{table}" _n
    if "`lscape'" != "" {
        file write `tf' "\end{landscape}" _n
    }
    
    if "`tableonly'" == "" {
    
    * aftertex
    if "`aftertext'" != "" {
        file write `tf' _n "`aftertext'" _n(2)
    }
    
    file write `tf' "\end{document}" _n
    
    } // tableonly
    } // fragment
    
    file close `fh'
    file close `tf'
    
    copy `"`tmp'"' `"`saving'"', `replace'
    mata: st_local("basename", pathbasename(`"`saving'"'))
    di as txt `"(LaTeX table saved to file {browse `"`saving'"':`basename'})"'
end
