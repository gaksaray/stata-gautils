*! version 1.2  14jan2022  Gorkem Aksaray <gaksaray@ku.edu.tr>
*! 
*! Syntax
*! ------
*!   regpred, command(cmdspec) GENerate(newvar) [at(atspec)]
*!   
*!   where
*!     cmdspec is command [arguments] [, cmdoptions]
*!     atspec  is varname = #
*!   
*!   by prefix is allowed. If by is specified, each group will have its own
*!   vector of estimation coefficients used in calculating predicted values.
*! 
*! Description
*! -----------
*!   regpred saves predicted values of an estimation model by group.
*! 
*! Example
*! -------
*!   sysuse auto, clear
*!   regpred,                                                   ///
*!      command(reg price rep78 headroom if trunk > 10, robust) ///
*!      gen(yhat_base)
*!   by foreign: regpred,                                       ///
*!      command(reg price rep78 headroom, robust)               ///
*!      gen(yhat_byf) at(headroom = 5)
*!   bysort foreign mpg: regpred,                               ///
*!      command(reg price rep78 headroom , robust)              ///
*!      gen(yhat_byfm) at(headroom = 5)
*! 
*! Changelog
*! ---------
*!   [1.2]
*!     Bug fix: no observations in estimation command.
*!   [1.1]
*!     Bug fix: insufficient observation in estimation command.
*!   [1.0]
*!     Initial release.

capture program drop regpred
program define regpred, byable(recall, noheader) sortpreserve
    version 16
    syntax, command(string asis) GENerate(name) [at(string)]
    marksample touse
    
    local cframe "`c(frame)'"
    
    if _byindex() == 1 {
        
        if "`at'" != "" {
            tokenize "`at'", parse(=)
            confirm numeric variable `1'
            if "`2'" != "=" {
                di as err "option at incorrectly specified"
                exit 198
            }
            confirm number `3'
        }
        
        confirm new variable `generate'
        qui generate `generate' = .
    }
    
    tempname index
    gen `index' = _n
    
    quietly {
        tempname frtouse
        frame put if `touse', into(`frtouse')
        cwf `frtouse'
        
        keep if `touse'
        cap `command'
        if _rc != 0 cwf `cframe'
        if _rc == 2000 {
            di "no observations"
            exit 2000
        }
        if _rc == 2001 {
            di "insufficient observations"
            exit 2001
        }
        tempname est
        gen `est' = cond(e(sample), 1, 0)
        if "`at'" != "" {
            replace `at'
        }
        tempname yhat
        predict `yhat' if e(sample)
        
        cwf `cframe'
        frlink 1:1 `index', frame(`frtouse')
        frget `est' = `est', from(`frtouse')
        frget `yhat' = `yhat', from(`frtouse')
        replace `generate' = `yhat' if `touse' & `est'
        drop `frtouse' `est'
    }
end
