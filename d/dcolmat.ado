*! version 1.0  28jul2021  Gorkem Aksaray <gaksaray@ku.edu.tr>
*! Returns maximum number of integer digits of numeric matrices
*!
*! Description
*! -----------
*!   dcolmat returns maximum number of integer digits of numeric matrices
*!   with optional comma separators and negative sign.
*!
*! Syntax
*! ------
*!   dcolmat matnames [, Eclass noComma noLZ DIAGonal]
*!   
*!   eclass specifies that matnames to be returned by an estimation command
*!   nocomma specifies that comma separators to be omitted
*!   nolz specifies leading zeros to be omitted
*!   diagonal specifies that diagonals of matnames to be used
*!
*! Examples
*! --------
*!   clear all
*!   input v1 v2 v3 v4 v5
*!       0.1 0.1 0.1 0.1 0.1
*!       0.001 0.001 -0.001 -0.001 -0.001
*!       0.1234567 1.1 . .z 1234567.5 // digits do not matter
*!   end
*!   forval i = 1/5 {
*!       mkmat v`i', matrix(v`i')
*!       mat list v`i'
*!   }
*!   dcolmat v1             //  0.0 -> r(d) = 1
*!   dcolmat v1, nolz       //   .0 -> r(d) = 0
*!   dcolmat v2             //  1.0 -> r(d) = 1
*!   dcolmat v2, nolz       //  1.0 -> r(d) = 1
*!   dcolmat v3             // -0.0 -> r(d) = 2
*!   dcolmat v3, nolz       //  -.0 -> r(d) = 1
*!   dcolmat v4             // -0.0 -> r(d) = 2
*!   dcolmat v4, nolz       //  -.0 -> r(d) = 1
*!   dcolmat v5             // 1,234,567.0 -> r(d) = 9 (7 + 2 comma)
*!   dcolmat v5, nocomma    //   1234567.0 -> r(d) = 7
*!   dcolmat v1 v2 v3 v4 v5 // returns the maximum r(d) = 9

capture program drop dcolmat
program dcolmat, rclass
    syntax namelist(name=matnames id="matrices") [, *]
    
    local maxd = 0
    foreach matname of local matnames {
        _getIntegerDigits `matname', `options'
        local maxd = max(`maxd', r(d))
    }
    
    return scalar d = `maxd'
end

capture program drop _getIntegerDigits
program _getIntegerDigits, rclass
    syntax name(name=matname id="matrix") [, Eclass noComma noLZ DIAGonal]
    
    tempname mat
    
    if "`eclass'" != "" {
        _confirmMatScalar `matname', eclass
        matrix `mat' = e(`matname')
    }
    else {
        _confirmMatScalar `matname'
        matrix `mat' = `matname'
    }
    
    mata {
        e = st_matrix("`mat'")'
        
        if ("`diagonal'" != "") {
            e = diagonal(e)
        }
        
        // grab sign of e
        s = sign(e)
        
        // grab integer part of e
        i = trunc(e) :* s
        
        // grab decimal part of e
        d = abs(e) - abs(i)
        if (sum(d) == 0) st_local("decimals", strofreal(0))
        
        // number of commas
        if ("`comma'" == "nocomma") {
            n_comma = 0
        }
        else {
            n_comma = trunc(max(strlen(strofreal(i, "%999.0g"))) / 3 - epsilon(1))
        }
        
        // nolz (no leading zeros)
        if ("`lz'" == "nolz") {
            i = 0 :/ i + i // converts nonzeros to 0 and zeros to missing
        }
        
        i = subinstr(strofreal(s), "1", "") + strofreal(i)
        
        // max length including negative sign and commas
        maxlen = max(strlen(subinstr(i, ".", ""))) + n_comma
        
        // save integer length of e()
        st_local("integers", strofreal(maxlen))
    }
    
    return scalar d = `integers'
end

capture program drop _confirmMatScalar
program _confirmMatScalar
    syntax name(name=matname id="matrix") [, Eclass]
    
    if "`eclass'" != "" {
        capture confirm matrix e(`matname')
        if _rc != 0 {
            capture confirm scalar e(`matname')
            if _rc != 0 {
                di as err "matrix or scalar e(`matname') not found"
                exit _rc
            }
        }
    }
    else {
        capture confirm matrix `matname'
        if _rc != 0 {
            capture confirm scalar `matname'
            if _rc != 0 {
                di as err "matrix or scalar `matname' not found"
                exit _rc
            }
        }
    }
end
