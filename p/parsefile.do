**# Torture test

// Windows

parsefile using mydata.dta
ret list

parsefile using c:mydata.dta
ret list

parsefile using "my data"
ret list

parsefile using "my data.dta"
ret list

parsefile using myproj\mydata
ret list

parsefile using "my project\my data"
ret list

parsefile using C:\analysis\data\mydata
ret list

parsefile using "C:\my project\my data"
ret list

parsefile using ..\data\mydata
ret list

parsefile using "..\my project\my data"
ret list

// Mac and Unix

parsefile using mydata.dta
ret list

parsefile using ~friend/mydata.dta
ret list

parsefile using "my data"
ret list

parsefile using "my data.dta"
ret list

parsefile using myproj/mydata
ret list

parsefile using "my project/my data"
ret list

parsefile using ~/analysis/data/mydata
ret list

parsefile using "~/my project/my data"
ret list

parsefile using ../data/mydata
ret list

parsefile using "../my project/my data"
ret list

parsefile using "~:My Data:myfile.raw"
ret list

// URL

parsefile using https://www.stata-press.com/data/r17/autocost
ret list

parsefile using "https://www.stata-press.com/data/r17/popkahn"
ret list
