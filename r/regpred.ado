*! version 1.3  23mar2023  Gorkem Aksaray <aksarayg@tcd.ie>
*! 
*! Syntax
*! ------
*!   regpred, command(cmdspec) GENerate(newvar) [at(atspec) [at(atspec) [...]]] pred_opt
*! 
*!   where
*!     cmdspec is an estimation command
*!     atspec  is varname =exp [if] [in]
*!   
*!   at() option can be repeated.
*! 
*!   by prefix is allowed. If by is specified, each group will have its own
*!   vector of estimation coefficients used in calculating predicted values.
*! 
*!   pred_opt specifies the option(s) to be specified with the predict command
*!   to produce the predicted values.
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
*!   [1.3]
*!     - regpred now allows options to be passed to predict command.
*!       This can be used to produce, for example, residuals or linear
*!       prediction after logistic regression instead of probabilities.
*!     - regpred now allows multiple at() options to estimate predictions
*!       at specified values of multiple covariates.
*!   [1.2]
*!     Bug fix: no observations in estimation command.
*!   [1.1]
*!     Bug fix: insufficient observation in estimation command.
*!   [1.0]
*!     Initial release.

capture program drop regpred
program define regpred, byable(recall, noheader) sortpreserve
    version 16
    syntax, command(string asis) GENerate(name) ///
            [AT1(string) AT2(string) AT3(string) AT4(string) AT5(string) *]
    marksample touse
    
    local cframe "`c(frame)'"
    
    if _byindex() == 1 {
        
        foreach at in at1 at2 at3 at4 at5 {
            if "``at''" != "" {
                local 0 "``at''"
                syntax varname(numeric) =exp [if] [in] [, NOPromote]
            }
        }
        
        confirm new variable `generate'
        qui generate `generate' = .
    }
    
    tempname index
    generate `index' = _n
    
    quietly {
        tempname frtouse
        frame put if `touse', into(`frtouse')
        cwf `frtouse'
        
        keep if `touse'
        capture `command'
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
        generate `est' = cond(e(sample), 1, 0)
        foreach at in at1 at2 at3 at4 at5 {
            if "``at''" != "" {
                replace ``at''
            }
        }
        tempname yhat
        predict `yhat' if e(sample), `options'
        
        cwf `cframe'
        frlink 1:1 `index', frame(`frtouse')
        frget `est' = `est', from(`frtouse')
        frget `yhat' = `yhat', from(`frtouse')
        replace `generate' = `yhat' if `touse' & `est'
        drop `frtouse' `est'
    }
end
