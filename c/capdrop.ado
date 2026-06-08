*! version 1.0.1  08jun2026  Gorkem Aksaray <aksarayg@tcd.ie>
*! Capture drop a list of variables without an error
*!
*! Changelog
*! ---------
*!   [v1.0.1]
*!     - Hyphenated ranges written with spaces around the dash (e.g.,
*!       mpg - trunk) were split into separate tokens, so only the range
*!       endpoints were dropped. Spaces around the range operator are now
*!       stripped before parsing, so the full range is dropped, matching the
*!       behavior of drop.
*!   [v1.0.0]
*!     - Initial release.

capture program drop capdrop
program capdrop
    version 12
    syntax anything
    while strpos("`anything'", " -") | strpos("`anything'", "- ") {
        local anything : subinstr local anything " -" "-", all
        local anything : subinstr local anything "- " "-", all
    }
    foreach word of local anything {
        if strpos("`word'", "-") != 0 | ///
           strpos("`word'", "*") != 0 | ///
           strpos("`word'", "?") != 0 {
            capture ds `word'
            if !_rc {
                drop `r(varlist)'
            }
        }
        else {
            capture confirm variable `word'
            if !_rc {
                drop `word'
            }
        }
    }
end
