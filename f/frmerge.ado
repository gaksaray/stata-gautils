*! version 1.3  01apr2023  Gorkem Aksaray <aksarayg@tcd.ie>
*! Merge a target frame with the current dataset
*!
*! Syntax
*! ------
*!   frmerge {1:1|m:1|1:m|m:m|1:1 _n} varlist1, frame(framename [varlist2])
*!                                              [merge_options]
*!   
*!   varlist1 contains the key variables in the current dataset.
*!   
*!   frame(framename [varlist2]) specifies the name of the frame to be
*!   merged and optionally the names of key variables on which to match.
*!   If varlist2 is not specified, the key variables are assumed to have the
*!   same names in both frames. It can also have . (period) in it, which is
*!   synonymous with specifying the same variable name as the current dataset.
*!   
*!   merge_options are the same options as factory merge command.
*!
*! Description
*! -----------
*!   frmerge merges specified frames with current dataset using the usual merge
*!   syntax (see help merge).
*!
*! Example
*! -------
*!   frame create auto
*!   frame auto: sysuse auto, clear
*!   
*!   frame create auto2
*!   frame auto2 {
*!       sysuse auto2, clear
*!       rename foreign frgn
*!   }
*!   
*!   frame auto: frmerge 1:1 make foreign, frame(auto2 . frgn)
*!
*! Changelog
*! ---------
*!   [1.3]
*!     frmerge now preserves sorting. sort option is removed.
*!   [1.1]
*!     frmerge now allows for different key variables for current and target
*!     frames. sort option added. Error messages added.
*!   [1.0]
*!     Initial release.

capture program drop frmerge
program frmerge, sortpreserve
    version 16
    syntax anything, frame(string) [*]
    
    gettoken mtype  varlist1 : anything
    gettoken frame2 varlist2 : frame
    
    if "`=c(frame)'" == "`frame'" {
        noi di as err "cannot specify the current frame as input frame"
        exit 198
    }
    confirm frame `frame2'
    
    gettoken n _varlist1: varlist1
    if "`n'" == "_n" {
        local varlist1 "`_varlist1'"
        
        qui cap assert "`varlist1'" == ""
        if _rc {
            di as smcl as err "{it:varlist} cannot be specified after {bf:1:1 _n}"
            di as smcl as err "{p 4 4 2}"
            di as smcl as err "{bf:1:1 _n} specifies a sequential merge and"
            di as smcl as err "in that case there are no key variables;"
            di as smcl as err "if you want a match merge on key variables,"
            di as smcl as err "omit the {bf:_n} and specify {bf:1:1} varlist"
            di as smcl as err "{p_end}"
            exit 198
        }
    }
    else {
        local varlist1 "`n' `_varlist1'"
        local n ""
    }
    
    if "`mtype'" == "1:1" & "`varlist1'" == "_n" {
        qui cap assert "`varlist2'" == ""
        if _rc {
            noi di as err "{bf:merge 1:1 _n} speficied; {bf:varlist2} must be empty"
            exit 198
        }
    }
    else {
        local wc_vl1 = wordcount("`varlist1'")
        local wc_vl2 = wordcount("`varlist2'")
        if `wc_vl2' > 0 {
            qui cap assert `wc_vl1' == `wc_vl2'
            if _rc {
                di as smcl as err "variables misspecified"
                di as smcl as err "{p 4 4 2}"
                di as smcl as err "You specified `wc_vl1' variables after the"
                di as smcl as err "{bf:frmerge `mtype'} command, but `wc_vl2'"
                di as smcl as err "variable in the {bf:frame()} option."
                di as smcl as err "There must be a one-to-one correspondence"
                di as smcl as err "between the two variable lists."
                di as smcl as err "{p_end}"
                exit 198
            }
        }
    }
    
    frame `frame2' {
        preserve
        
        // rename vars
        local _varlist1 "`varlist1'"
        if ("`varlist2'" != "") foreach var2 of local varlist2 {
            gettoken var1 _varlist1 : _varlist1
            if "`var2'" == "." continue
            rename `var2' `var1'
        }
        
        // save as temp
        tempfile to_be_merged
        qui save "`to_be_merged'"
        
        restore
    }
    
    merge `mtype' `n' `varlist1' using "`to_be_merged'", `options'
end
