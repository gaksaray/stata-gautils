*! version 2.0  18jan2022  Gorkem Aksaray <gaksaray@ku.edu.tr>
*!
*! Syntax
*! ------
*!   frapply [framename1], command(command) into(framename2, replace CHange)
*!
*!   where the syntax of command is
*!
*!     command [ || command [ || command [...]]]
*!
*!   command can be specified as any destructive Stata command, such as collapse
*!   or contract. Commands can also be daisy chained. The end result will be put
*!   into a new (or existing, if replace option is specified) frame while the
*!   current frame is preserved.
*!
*!   framename1 specifies which frame to apply the command(s). This is synonymous 
*!   with using frame prefix as in frame framename1: frapply. (When both frame
*!   prefix and framename1 are specified, the former will be discarded.)
*!   
*! Description
*! -----------
*!   frapply applies a command or a series of commands to the dataset in the
*!   current frame while preserving it, and puts the end result into another
*!   frame. Any otherwise destructive commands such as drop/keep, collapse,
*!   contract etc. can be run without changing the current dataset. This can
*!   be particularly useful in interactive/experimental settings where we want
*!   to quickly summarize and/or subset the data without changing it.
*!
*! Examples
*! --------
*!
*!   // running frapply on multiple datasets
*!   clear all
*!   frame rename default auto1
*!   frame create auto2
*!   
*!   frame auto1: sysuse auto
*!   frame auto2: sysuse auto2
*!   
*!   frapply auto1, command(collapse mpg, by(foreign)) into(copy1, replace)
*!   cwf copy1 // includes summary stats; auto1 is not changed
*!   
*!   frapply auto2, command(contract mpg foreign) into(copy2, replace)
*!   cwf copy2 // includes frequencies; auto2 is not changed
*!   
*!   frames dir
*!   
*!   // applying serial commands interactively
*!   clear all
*!   sysuse auto
*!   
*!   # delimit ;
*!   frapply,
*!       command(
*!           keep if price > 5000 || // you may change these numbers
*!           keep if mpg   > 15   || // and run frapply again
*!           collapse price mpg, by(foreign)
*!       )
*!       into(subset, replace change)
*!   ;
*!   # delimit cr
*!   
*!   // saving predicted values
*!   clear all
*!   sysuse auto
*!   frapply, command(qui reg price mpg || predict yhat || collapse yhat) into(res, ch)
*!   
*!   // listing means by group
*!   clear all
*!   sysuse auto
*!   frapply, command(collapse price mpg, by(foreign) || list) into(temp, replace)
*!
*! Dependencies
*! ------------
*!   frput (from gautils package)
*!     net install frput, from("https://raw.github.com/gaksaray/stata-gautils/master/f")
*!
*! Changelog
*! ---------
*!   [2.0]
*!     Changes in syntax: (1) framename1 argument for specifying applied frame
*!     directly, and (2) replace and newly added change options are now within
*!     into() option.
*!   [1.0]
*!     Initial release.

capture program drop frapply
program define frapply
    version 16
    syntax [name(name=from)], command(string asis) into(string asis)
    
    // from frame check
    if "`from'" != "" {
        confirm frame `from'
        local cframe "`from'"
    }
    else {
        local cframe = c(frame)
    }
    
    // into frame check
    capture frameoption `into'
    if _rc {
        display as error `"Illegal into option: `into'"'
        exit 498
    }
    local intoname "`r(name)'"
    local intoreplace "`r(replace)'"
    local intochange "`r(change)'"
    if `"`intoname'"' == "`cframe'" {
        display as error "into() option may not specify the applied frame"
        exit 498
    }
    if `"`intoreplace'"' == "" {
        confirm new frame `intoname'
        local replace ""
    }
    else {
        local replace "replace"
    }
    if `"`intochange'"' == "" {
        local change ""
    }
    else {
        local change "change"
    }
    
    // multiple command check
    local cmdchk `"`command'"'
    while `"`cmdchk'"' != "" {
        gettoken cmd cmdchk : cmdchk, parse("|")
        if `"`cmd'"' == "|" {
            if substr(`"`cmdchk'"', 1, 1) == "|" {
                gettoken cmd cmdchk : cmdchky, parse("|")
                continue
            }
            else {
                noi display as err "| invalid name"
                exit 198
            }
        }
    }
    
    frame `cframe' {
        preserve
        while `"`command'"' != "" {
            gettoken cmd command : command, parse("|")
            if `"`cmd'"' == "|" continue
            `cmd'
        }
        frput, into(`intoname') `replace'
        restore
    }
    capture frame `change' `intoname'
end

capture program drop frameoption
program define frameoption, rclass
    version 16.0
    syntax name(name=name) [, replace CHange]
    
    return local change "`change'"
    return local replace "`replace'"
    return local name "`name'"
end
