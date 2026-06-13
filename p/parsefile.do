**# Torture test

// Run the whole file once: it stops with an error on the first mismatch,
// otherwise it reports success at the end. An omitted option expects "".

capture program drop checkret
program checkret
    syntax [, Path(string) Filename(string) Extension(string)]
    if `"`r(path)'"'      != `"`path'"'      ///
     | `"`r(filename)'"'  != `"`filename'"'  ///
     | `"`r(extension)'"' != `"`extension'"' {
        di as error "parsefile returned unexpected results"
        di as error `"  expected:  path=|`path'|  filename=|`filename'|  extension=|`extension'|"'
        di as error `"  returned:  path=|`r(path)'|  filename=|`r(filename)'|  extension=|`r(extension)'|"'
        exit 9
    }
end

// No path

parsefile using mydata.dta
checkret, filename(mydata) extension(dta)

parsefile using mydata
checkret, filename(mydata)

parsefile using "my data"
checkret, filename("my data")

parsefile using "my data.dta"
checkret, filename("my data") extension(dta)

// Windows paths

parsefile using c:mydata.dta
checkret, path("c:") filename(mydata) extension(dta)

parsefile using myproj\mydata
checkret, path(`"myproj\"') filename(mydata)

parsefile using "my project\my data"
checkret, path(`"my project\"') filename("my data")

parsefile using C:\analysis\data\mydata
checkret, path(`"C:\analysis\data\"') filename(mydata)

parsefile using "C:\my project\my data"
checkret, path(`"C:\my project\"') filename("my data")

parsefile using ..\data\mydata
checkret, path(`"..\data\"') filename(mydata)

parsefile using "..\my project\my data"
checkret, path(`"..\my project\"') filename("my data")

// Unix and Mac paths

parsefile using myproj/mydata
checkret, path("myproj/") filename(mydata)

parsefile using "my project/my data"
checkret, path("my project/") filename("my data")

parsefile using ~friend/mydata.dta
checkret, path("~friend/") filename(mydata) extension(dta)

parsefile using ~/analysis/data/mydata
checkret, path("~/analysis/data/") filename(mydata)

parsefile using "~/my project/my data"
checkret, path("~/my project/") filename("my data")

parsefile using ../data/mydata
checkret, path("../data/") filename(mydata)

parsefile using "../my project/my data"
checkret, path("../my project/") filename("my data")

parsefile using "~:My Data:myfile.raw"
checkret, path("~:My Data:") filename(myfile) extension(raw)

// URLs

parsefile using https://www.stata-press.com/data/r17/autocost
checkret, path("https://www.stata-press.com/data/r17/") filename(autocost)

parsefile using "https://www.stata-press.com/data/r17/popkahn"
checkret, path("https://www.stata-press.com/data/r17/") filename(popkahn)

parsefile using https://www.stata-press.com/data/r17/auto.dta
checkret, path("https://www.stata-press.com/data/r17/") filename(auto) extension(dta)

// Relative paths with "." components (must not stop early)

parsefile using ./mydata.dta
checkret, path("./") filename(mydata) extension(dta)

parsefile using ../a/./b/mydata
checkret, path("../a/./b/") filename(mydata)

// Multiple-dot names (extension splits on the last dot)

parsefile using archive.tar.gz
checkret, filename("archive.tar") extension(gz)

parsefile using my.data.dta
checkret, filename("my.data") extension(dta)

// Dots in a directory name must not leak into the extension

parsefile using ~/my.dir/data
checkret, path("~/my.dir/") filename(data)

// Dotfiles (leading dot is part of the name, not an extension)

parsefile using .gitignore
checkret, filename(".gitignore")

parsefile using .hidden.txt
checkret, filename(".hidden") extension(txt)

// Trailing separators (no final component)

parsefile using mydir/
checkret, path("mydir/")

parsefile using "my dir\"
checkret, path(`"my dir\"')

di as result _n "All parsefile tests passed."
