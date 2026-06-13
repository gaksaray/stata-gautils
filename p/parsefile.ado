*! version 1.2  13jun2026  Gorkem Aksaray <aksarayg@tcd.ie>
*! Parse the path, file name, and extension from the using modifier
*!
*! Changelog
*! ---------
*!   [1.2]
*!     - Bug fix: a "." path component (e.g., ./mydata) stopped parsing
*!       early, returning "." as the file name.
*!     - The extension is now taken after the last period rather than the
*!       first, so multi-part names such as archive.tar.gz parse correctly.
*!     - A leading period is treated as part of the file name, so dotfiles
*!       such as .gitignore are returned whole with no extension.
*!     - Added r(path), the directory portion of the specification.
*!     - Now requires Stata 14 (strrpos).

capture program drop parsefile
program parsefile, rclass
    version 14
    syntax using/

    local spec `"`using'"'

    local next ""
    while `"`using'"' != "" {
        gettoken next using : using, parse("~:/\")
    }

    if length(`"`next'"') == 1 & strpos("~:/\", `"`next'"') {
        local next ""
    }

    local path = substr(`"`spec'"', 1, length(`"`spec'"') - length(`"`next'"'))

    local dotpos = strrpos(`"`next'"', ".")
    if `dotpos' > 1 {
        local filename  = substr(`"`next'"', 1, `dotpos' - 1)
        local extension = substr(`"`next'"', `dotpos' + 1, .)
    }
    else {
        local filename `"`next'"'
        local extension ""
    }

    return local path      `"`path'"'
    return local filename  `"`filename'"'
    return local extension `"`extension'"'
end
