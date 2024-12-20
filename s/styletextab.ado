*! version 1.4.0 11oct2024  Gorkem Aksaray <aksarayg@tcd.ie>
*! Restyle LaTeX tables exported by the collect suite of commands
*! 
*! Changelog
*! ---------
*!   [1.4.0]
*!     - Added inject() option to inject lines of LaTeX code after any row
*!       within the tabular environment.
*!   [1.3.1]
*!     - Automatic conversion of hyphens as minus signs was causing special
*!       characters to disappear. This is now fixed.
*!   [1.3]
*!     - Added three size options: pt() for setting the size of the main
*!       font used in the document, papersize() for setting the paper size,
*!       and tabsize() for setting the size of the font used in the table.
*!   [1.2.2]
*!     - usepackage() option when specified with LaTeX package names that
*!       do not satisfy the naming convention of Stata (e.g., unicode-math)
*!       was causing error. This is now fixed.
*!   [1.2.1]
*!     - Automatic conversion of hyphens as minus signs to en dashes in math
*!       mode to ensure proper typographic representation.
*!   [1.2]
*!     - Added usepackage() option to add LaTeX packages to the preamble.
*!     - geometry and lipsum options are removed as they are now redundant
*!       with the addition of usepackage() option.
*!     - beforetext() and aftertext() options can now add multiple lines
*!       delimited by quotation marks. They also automatically define \sq{}
*!       and \dq{} macros for single and double quotes used within text.
*!     - Better handling of repeatable options.
*!   [1.1]
*!     - Allow for multiple paragraphs of text before and after table.
*!     - Added lipsum() and geometry() options.
*!   [1.0]
*!     - Initial public release.

capture program drop styletextab
program styletextab, rclass
    version 18
    
    // Repeatable options
    local repeated_option_maxcount = 9 // can increase if needed!
    forvalues i = 0/`repeated_option_maxcount' {
        local usepackage "`usepackage' USEPackage`i'(string asis)"
        local beforetext "`beforetext' BEFOREtext`i'(string asis)"
        local  aftertext " `aftertext'  AFTERtext`i'(string asis)"
        local     inject "    `inject'     INJECT`i'(string asis)"
    }
    
    syntax [using/] [,                                      ///
                     SAVing(string asis)                    ///
                     FRAGment                               ///
                     TABLEonly                              ///
                     LScape                                 ///
                     noBOOKtabs                             ///
                     LABel(string)                          ///
                     `usepackage'                           ///
                     `beforetext'                           ///
                     `aftertext'                            ///
                     `inject'                               ///
                     pt(numlist min=1 max=1 >=10 <=12 int)  ///
                     PAPERsize(string)                      ///
                     TABSize(string)                        ///
                    ]
    
    local global_skip = 2
    
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
    
    capture assert ///
        inlist("`papersize'", "a0", "a1", "a2", "a3", "a4", "a5", "a6")        | ///
        inlist("`papersize'", "b0", "b1", "b2", "b3", "b4", "b5", "b6")        | ///
        inlist("`papersize'", "c0", "c1", "c2", "c3", "c4", "c5", "c6")        | ///
        inlist("`papersize'", "b0j", "b1j", "b2j", "b3j", "b4j", "b5j", "b6j") | ///
        inlist("`papersize'", "ansia", "ansib", "ansic", "ansid", "ansie")     | ///
        inlist("`papersize'", "letter", "executive", "legal", "")
    if _rc == 9 {
        di as err "{p 0 0 2}"
        di as err "incorrect paper size specified"
        di as err "{p_end}"
        exit 198
    }
    
    capture assert ///
        inlist("`tabsize'", "tiny", "scriptsize", "footnotesize", "small", "normalsize", "large", "Large", "LARGE", "huge", "Huge", "")
    if _rc == 9 {
        di as err "{p 0 0 2}"
        di as err "incorrect table size specified"
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
    if "`pt'" != "" {
        local pt "`pt'pt"
    }
    if "`papersize'" != "" {
        local papersize "`papersize'paper"
    }
    local docclassopts = subinstr(`"`= strtrim("`pt' `papersize'")'"', " ", ",", .)
    file write `tf' "\documentclass[`docclassopts']{article}" _n
    if `"`usepackage0'"' != "" {
        forvalues i = 0/`repeated_option_maxcount' {
            if `"`usepackage`i''"' != "" {
                local 0 `"`usepackage`i''"'
                syntax anything(name=pkgname id="package name") [, ///
                    opt(string) opts(string) pre Nextlines(string asis)]
                if "`pre'" == "" {
                    continue
                }
                if "`opt'" != "" & "`opts'" != "" {
                    di as err "options opt() and opts() may not be used simultaneously"
                    exit 198
                }
                if "`opt'" == "" & "`opts'" == "" {
                    file write `tf' `"\usepackage{`pkgname'}"' _n
                }
                else if "`opt'" != "" {
                    file write `tf' `"\usepackage[`opt']{`pkgname'}"' _n
                }
                else if "`opts'" != "" {
                    file write `tf' "\usepackage[" _n
                    tokenize "`opts'", parse(",")
                    if "`1'" == "," {
                        macro shift
                        continue
                    }
                    file write `tf' _skip(`global_skip') "`1'"
                    macro shift
                    while "`1'" != "" {
                        if "`1'" == "," {
                            macro shift
                            continue
                        }
                        file write `tf' "," _n _skip(`global_skip') "`1'"
                        macro shift
                    }
                    file write `tf' _n `"]{`pkgname'}"' _n
                }
                tokenize `"`nextlines'"', parse(`"""')
                while "`1'" != "" {
                    file write `tf' `"`1'"' _n
                    macro shift
                }
            }
        }
    }
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
    if `"`usepackage0'"' != "" {
        forvalues i = 0/`repeated_option_maxcount' {
            if `"`usepackage`i''"' != "" {
                local 0 `"`usepackage`i''"'
                syntax anything(name=pkgname id="package name") [, ///
                    opt(string) opts(string) pre Nextlines(string asis)]
                if "`pre'" != "" {
                    continue
                }
                if "`opt'" != "" & "`opts'" != "" {
                    di as err "options opt() and opts() may not be used simultaneously"
                    exit 198
                }
                if "`opt'" == "" & "`opts'" == "" {
                    file write `tf' `"\usepackage{`pkgname'}"' _n
                }
                else if "`opt'" != "" {
                    file write `tf' `"\usepackage[`opt']{`pkgname'}"' _n
                }
                else if "`opts'" != "" {
                    file write `tf' "\usepackage[" _n
                    tokenize "`opts'", parse(",")
                    if "`1'" == "," {
                        macro shift
                        continue
                    }
                    file write `tf' _skip(`global_skip') "`1'"
                    macro shift
                    while "`1'" != "" {
                        if "`1'" == "," {
                            macro shift
                            continue
                        }
                        file write `tf' "," _n _skip(`global_skip') "`1'"
                        macro shift
                    }
                    file write `tf' _n `"]{`pkgname'}"' _n
                }
                tokenize `"`nextlines'"', parse(`"""')
                while "`1'" != "" {
                    file write `tf' `"`1'"' _n
                    macro shift
                }
            }
        }
    }
    if `"`beforetext0'`aftertext0'"' != "" {
        file write `tf' "\newcommand{\sq}[1]{\`#1'}" _n
        file write `tf' "\newcommand{\dq}[1]{\`\`#1''}" _n
    }
    
    file write `tf' "\begin{document}" _n
    
    * beforetext
    if `"`beforetext0'"' != "" {
        forvalues i = 0/`repeated_option_maxcount' {
            if `"`beforetext`i''"' != "" {
                file write `tf' _n
                tokenize `"`beforetext`i''"', parse(`"""')
                while "`1'" != "" {
                    file write `tf' `"`1'"' _n
                    macro shift
                }
            }
        }
        file write `tf' _n
    }
    
    } // tableonly
    if "`lscape'" != "" {
        file write `tf' "\begin{landscape}" _n
    }
    file write `tf' "\begin{table}[!h]" _n
    if "`tabsize'" != "" {
        file write `tf' "\\`tabsize'" _n
    }
    
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
            local _rownum = 0
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
            else if regexm(`"`macval(line)'"', "\\multicolumn{([0-9])}{([|]?[clr][|]?)}{-([^\}]*)}") {
                local newline = ///
                    regexreplaceall(`"`macval(line)'"', ///
                                    "\\multicolumn{[0-9]}{[|]?[clr][|]?}{-[^\}]*}", ///
                                    " \multicolumn{"+regexs(1)+"}{"+regexs(2)+"}{\\$-\\$"+regexs(3)+"}", ///
                                    0, 1)
                file write `tf' `"`newline'"' _n
            }
            else {
                file write `tf' `"`macval(line)'"' _n
            }
            
            // inject
            if substr(`"`macval(line)'"', -1, 1) != "&" {
                local ++ _rownum
            }
            if strpos(`"`macval(line)'"', "\end{tabular}") != 0 {
                local _rownum
            }
            forvalues i = 0/`repeated_option_maxcount' {
                if `"`inject`i''"' != "" {
                    local 0 `"`inject`i''"'
                    syntax anything(name=rownum id="row number"), ///
                        Nextlines(string asis)
                    confirm integer number `rownum'
                    if "`rownum'" == "`_rownum'" {
                        tokenize `"`nextlines'"', parse(`"""')
                        while "`1'" != "" {
                            file write `tf' `"`1'"' _n
                            macro shift
                        }
                        local inject`i' // consume inject so it's not reused later!
                    }
                }
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
    
    * aftertext
    if `"`aftertext0'"' != "" {
        forvalues i = 0/`repeated_option_maxcount' {
            if `"`aftertext`i''"' != "" {
                file write `tf' _n
                tokenize `"`aftertext`i''"', parse(`"""')
                while "`1'" != "" {
                    file write `tf' `"`1'"' _n
                    macro shift
                }
            }
        }
        file write `tf' _n
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
