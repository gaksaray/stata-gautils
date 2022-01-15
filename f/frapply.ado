*! version 1.0  16jan2022  Gorkem Aksaray <gaksaray@ku.edu.tr>
*!
*! Syntax
*! ------
*!   frapply, command(command) into(framename) [replace]
*!
*!   where the syntax of command is
*!
*!     command [ || command [ || command [...]]]
*!
*!   command can be specified as any destructive Stata command, such as collapse
*!   or contract. The end result will be put into a new (or existing, if replace
*!   option is specified) frame while the current frame is preserved.
*!
*! Description
*! -----------
*!   frapply is for running commands that would normally be destructive
*!   (such as drop/keep, collapse, contract etc.) on a dataset while preserving
*!   it but instead posting the end result into another frame. This is especially
*!   useful in interactive/experimental settings where we want to quickly examine
*!   summarized or subset data without changing the actual dataset.
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
*!   frame auto1: frapply, command(collapse mpg, by(foreign)) into(copy1) replace
*!   cwf copy1 // includes summary stats; auto1 is not changed
*!   
*!   frame auto2: frapply, command(contract mpg foreign) into(copy2) replace
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
*!       into(subset) replace
*!   ;
*!   # delimit cr
*!   cwf subset
*!
*!   // saving predicted values
*!   clear all
*!   sysuse auto
*!   frapply, command(qui reg price mpg || predict yhat || collapse yhat) into(res)
*!   cwf res
*!
*!   // listing means by group
*!   clear all
*!   sysuse auto
*!   frapply, command(collapse price mpg, by(foreign) || list) into(temp) replace
*!
*! Dependencies
*! ------------
*!   frput (from gautils package)
*!     net install frput, from("https://raw.github.com/gaksaray/stata-gautils/master/f")
*!
*! Changelog
*! ---------
*!   [1.0]
*!     Initial release.

capture program drop frapply
program frapply
    version 16
    syntax, command(string asis) into(name local) [replace]
    
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
                noi di as err "| invalid name"
                exit 198
            }
        }
    }
    
    local cframe = c(frame)
    frame `cframe' {
        preserve
        while `"`command'"' != "" {
            gettoken cmd command : command, parse("|")
            if `"`cmd'"' == "|" continue
            `cmd'
        }
        frput, into(`into') `replace'
        restore
    }
end
