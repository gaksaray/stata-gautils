*! version 1.0  06feb2021  Gorkem Aksaray

capture program drop eps2pdf
program eps2pdf
	syntax [anything(name=filelist id="file list")][, DIRectory(string)]
	
	local initdir "`c(pwd)'"
	
	if "`directory'" != "" {
		qui cd `"`directory'"'
	}
	
	if "`filelist'" != "" {
		local filelist = subinstr("`filelist'", ".eps", "", .)
		foreach file of local filelist {
			local files `files' `file'.eps
		}
	}
	else {
		local files : dir "`c(pwd)'" files "*.eps"
	}
	
	if wordcount(`"`files'"') == 0 {
		di as err "no .eps files in the specified folder"
		qui cd `"`initdir'"'
		exit
	}
	
	foreach file of local files {
		local filename = subinstr("`file'", ".eps", "", .)
		shell eps2pdf `filename'.eps --outfile=`filename'.pdf
	}
	
	qui cd `"`initdir'"'
end
