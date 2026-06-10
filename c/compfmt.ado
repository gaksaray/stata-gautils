*! version 1.0.0  10jun2026  Gorkem Aksaray <aksarayg@tcd.ie>
*! Compress display formats of numeric and string variables
*!
*! Dev note: num()/str() are internal, type-specific option buckets kept as an
*! extensibility seam, deliberately left out of the help for now. preserve
*! routes into num(); td is a switch. A date() bucket can be added the same
*! way. Document these once they hold enough to be worth it.
*!
*! Changelog
*! ---------
*!   [1.0.0]
*!     - compfmt is now self-contained and no longer depends on the (now
*!       retired) fmtnum and fmtstr modules.
*!     - Internal, type-specific option buckets num() and str() are parsed as
*!       an extensibility seam for future options; the public preserve option
*!       routes into num(). A date() bucket can be added the same way later.
*!     - Carries over fixes from the former fmtnum/fmtstr: per-variable reset
*!       of preserved format attributes, a tidied numeric format regex, and a
*!       guard so that oversized or binary strL variables are left untouched.
*!     - Requires Stata 13 or later (strL operations).

capture program drop compfmt
program compfmt
    version 13
    syntax [varlist] [, num(string) str(string) Preserve td]

    // stash now: the nested syntax calls below reset varlist etc.
    local vars        `varlist'
    local numopts     `"`num'"'
    local stropts     `"`str'"'
    local dateswitch  "`td'"
    local toppreserve "`preserve'"

    // num() bucket (preserve routes in here)
    local 0 `", `numopts'"'
    syntax [, Preserve]
    if "`toppreserve'" != "" local preserve preserve
    local num_preserve "`preserve'"

    // str() takes no sub-options yet
    if `"`stropts'"' != "" {
        di as error "option {bf:str()} takes no sub-options"
        exit 198
    }

    foreach var of varlist `vars' {

        // strings
        capture confirm string variable `var'
        if !_rc {
            local vartype : type `var'
            if "`vartype'" == "strL" {
                capture recast str `var'    // leave binary/oversized strL as is
            }
            else {
                recast strL `var'
                recast str `var'
            }
            continue
        }

        // numerics (incl. dates)
        capture confirm numeric variable `var'
        if _rc continue

        qui compress `var'

        local varfmt : format `var'

        if "`dateswitch'" == "" {
            capture confirm date format `varfmt'
            if !_rc continue
        }

        local just ""   // reset per iteration
        local lz   ""
        local c    ""
        if "`num_preserve'" != "" {
            if regexm("`varfmt'", "^%([-]?)([0]*)[0-9]+\.[0-9]+[fge]([c]?)$") {
                local just = regexs(1) // justification
                local lz   = regexs(2) // leading zeros
                local c    = regexs(3) // commas
            }
        }

        local vartype : type `var'
        if "`vartype'" == "byte"    format `var' %`just'`lz'8.0g`c'
        if "`vartype'" == "int"     format `var' %`just'`lz'8.0g`c'
        if "`vartype'" == "long"    format `var' %`just'`lz'12.0g`c'
        if "`vartype'" == "float"   format `var' %`just'`lz'9.0g`c'
        if "`vartype'" == "double"  format `var' %`just'`lz'10.0g`c'

        local vallab : value label `var'
        if "`vallab'" != "" {
            label values `var' .
            label values `var' `vallab'
        }
    }
end
