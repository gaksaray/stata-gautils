*! version 1.0  20jan2022  Gorkem Aksaray <gaksaray@ku.edu.tr>
*! Merge a target frame with current frame
*!
*! Syntax
*! ------
*!   frmerge {1:1 | m:1 | 1:m | m:m | 1:1 _n}, frame(framename) merge_options
*!
*! Description
*! -----------
*!   frmerge merges specified frames with current frame using the usual merge
*!   syntax (see help merge).
*!
*! Example
*! -------
*!   frame create auto
*!   frame auto: sysuse auto, clear
*!
*!   frame create auto2
*!   frame auto2: sysuse auto2, clear
*!
*!   frame auto: frmerge 1:1 make, frame(auto2)
*!
*! Changelog
*! ---------
*!   [1.0]
*!     Initial release.

capture program drop frmerge
program frmerge
    version 16
    syntax anything, frame(name local) *
    
    confirm frame `frame'
    
    if "`=c(frame)'" == "`frame'" {
        noi di as err "cannot specify the current frame as input frame"
        exit 198
    }
    
    frame `frame' {
        tempfile to_be_merged
        qui save "`to_be_merged'"
    }
    
    merge `anything' using "`to_be_merged'", `options'
end
