*! version 1.1  20jan2022  Gorkem Aksaray <aksarayg@tcd.ie>
*! Append frame(s) onto current frame
*!
*! Syntax
*! ------
*!   frappend frame_list
*!
*! Description
*! -----------
*!   frappend appends specified frames onto current frame.
*!
*! Example
*! -------
*!   frame create auto
*!   frame auto: sysuse auto, clear
*!
*!   frame create auto2
*!   frame auto2: sysuse auto2, clear
*!
*!   frame default: frappend auto auto2
*!
*! Remarks
*! -------
*!   frappend is inspired by https://www.statalist.org/forums/forum/general-stata-discussion/general/1505424-can-stata-16-frames-be-appended.
*!
*! Changelog
*! ---------
*!   [1.1]
*!     Bug fix: skip input frame when it's the same as current frame.
*!     Changed version requirement to Stata 16.
*!   [1.0]
*!     Initial release.

capture program drop frappend
program define frappend
    version 16
    syntax namelist(name=frlist id="frame list")
    
    foreach fr of local frlist {
        confirm frame `fr'
        
        // skip if starting frame = input frame
        if "`=c(frame)'" == "`fr'" continue
        
        // save input frame as tempfile
        frame `fr' {
            tempfile to_be_appended
            qui save "`to_be_appended'"
        }
        
        append using "`to_be_appended'"
    }
end
