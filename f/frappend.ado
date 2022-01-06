*! version 1.0  06jan2022  Gorkem Aksaray <gaksaray@ku.edu.tr>
*! Append frame(s) onto current frame
*!
*! Syntax
*! ------
*!
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
*!   [1.0]
*!     Initial release.

capture program drop frappend
program define frappend
version 17
    syntax namelist(name=frlist id="frame list")
    
    foreach fr of local frlist {
        confirm frame `fr'
        
        // store starting frame
        local curframe = c(frame)
        
        // save input frame as tempfile
        frame `fr' {
            tempfile to_be_appended
            qui save "`to_be_appended'"
        }
        
        append using "`to_be_appended'"
    }
end
