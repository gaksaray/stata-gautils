*! version 1.0  28jul2021  Gorkem Aksaray <aksarayg@tcd.ie>
*! Returns dcolumn and %fmt formatting from matrices in stored estimates
*! 
*! Syntax
*! ------
*!   dcols parameters, Decimals(#) [ESTimates(estnames) par STARs
*!                                  General Fixed dcolmat_options]
*!   
*!   decimals specifies the number of decimals
*!   estimates specifies the list of stored estimates to be used
*!   par indicates parameters to be wrapped in parentheses
*!   stars adds 3 to decimals (in lieu of three significance asterisks)
*!   general|fixed specifies the format (fixed is default; see help format)
*!   dcolmat_options are options specific to dcolmat command (eclass is assumed)
*! 
*! Description
*! -----------
*!   dcols returns dcolumn and %fmt specifications to be used along with estout
*!   package for producing LaTeX tables. It is used to produce pretty tables
*!   with dcolumn LaTeX package.
*! 
*! Dependencies
*! ------------
*!   dcolmat (https://github.com/gaksaray/stata-gautils/tree/master/d/dcolmat.ado)
*! 
*! Examples
*! --------
*!   sysuse auto, clear
*!   
*!   regress price mpg rep78
*!   estimates store reg1
*!   regress price mpg rep78 i.foreign
*!   estimates store reg2
*!   
*!   estimates dir
*!   
*!   dcols b, est(reg1 reg2) d(3) nocomma stars par g
*!   return list

capture program drop dcols
program dcols, rclass
    #delimit ;
    syntax
        namelist(name=parameters id="parameters")
        ,
        Decimals(numlist integer min=1 max=1 >=0)
        [ESTimates(namelist min=1) noComma par STARs General Fixed *]
    ;
    #delimit cr
        
    // save name of stored result
    local storedest = e(_estimates_name)
    
    // if estimates option is not specified, loop over all estimates
    if "`estimates'" == "" {
        qui estimates dir
        local estimates = r(names)
    }
    
    local dcols ""
    local fmts ""
    
    capture noisily {
        foreach est of local estimates {
        
            // restore & replay estimate
            qui estimates restore `est'
            qui estimates replay  `est'
            
            // ereturn standard error vector
            capture mata: st_matrix("e(se)", st_matrix("r(table)")[2,])
            
            // get the number of dcolumn integers on specified parameters
            dcolmat `parameters', `comma' eclass `options'
            local integers = r(d)
            
            // make dcolumn
            local _decimals = `decimals'
            if "`par'" != "" {
                local ++integers
                local _decimals = `_decimals' + 1
            }
            if "`stars'" != "" {
                local _decimals = `_decimals' + 3
            }
            local d_`est' d{`integers'.`_decimals'}
            local dcols `dcols' `d_`est''
            
            // make format
            if `decimals' > 0 {
                local integers = `integers' + `decimals' + 1 //+1 for .
            }
            if "`comma'" == "nocomma" {
                local _comma
            }
            else {
                local _comma c
            }
            if "`general'" != "" {
                local fmt g
            }
            else if ("`general'" == "" | "`fixed'" != "") {
                local fmt f
            }
            local f_`est' = "%`integers'.`decimals'`fmt'`_comma'"
            local fmts `fmts' `f_`est''
        }
    }
    if _rc != 0 {
        qui estimates restore `storedest'
        exit _rc
    }
    
    // restore stored estimate
    qui estimates restore `storedest'
    
    // return dcolumn and format
    return local dcols = "`dcols'"
    return local fmts = "`fmts'"
end

/*
// deprecated: no need anymore since the addition of r(table)
capture program drop _makeSE
program _makeSE
    syntax namelist(name=parameters id="parameters")
    
    foreach param of local parameters {
        if "`param'" == "se" {
            capture confirm matrix e(V)
            if _rc != 0 {
                di as err "matrix e(V) not found; e(se) could not be generated"
                exit _rc
            }
            else {
                mata: st_matrix("e(se)", st_matrix("r(table)")[2,]')
            }
        }
        else continue
    }
end
*/
