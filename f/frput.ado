*! version 1.0  15jan2022  Gorkem Aksaray <gaksaray@ku.edu.tr>
*!
*! Syntax
*! ------
*!   frput [varlist] [if] [in], into(framename) [replace]
*!   
*!   This is the same syntax as frame put with the replace option, which
*!   allows one to overwrite an existing frame specified in into() option.
*!
*! Description
*! -----------
*!   frput copies selected variables or observations to another frame
*!   with an option to replace the specified frame. It is essentially
*!   a wrapper for frame put command.
*!
*! Changelog
*! ---------
*!   [1.0]
*!     Initial release.

capture program drop frput
program frput
    version 16
    syntax [varlist] [if] [in], into(name local) [replace]

    tempname tmpframe
    frame put `varlist' `if' `in', into(`tmpframe')
    frame copy `tmpframe' `into', `replace'

end
