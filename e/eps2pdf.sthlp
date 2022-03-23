{smcl}
{* *! version 1.0  06feb2021}{...}
{viewerjumpto "Syntax" "eps2pdf##syntax"}{...}
{viewerjumpto "Description" "eps2pdf##description"}{...}
{viewerjumpto "Examples" "eps2pdf##examples"}{...}
{viewerjumpto "Author" "eps2pdf##author"}{...}
{vieweralsosee "gautils" "help gautils"}{...}
{cmd:help eps2pdf}{right: {browse "https://github.com/gaksaray/stata-gautils/"}}
{hline}

{title:Title}

{phang}
{bf:eps2pdf} {hline 2} Convert EPS files to PDF files


{marker syntax}{...}
{title:Syntax}

{p 8}
{cmd: eps2pdf}[{it:filename(s)}, {opt dir:ectory(directory)}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:eps2pdf} is a utility routine that uses Windows shell to convert EPS files
in the directory specified (relative or absolute) by the {opt directory}
(or the working directory if not specified) option to PDF.
It relies on LaTeX's eps2pdf script; therefore minimum LaTeX
system must be installed on the computer.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. eps2pdf}{it: converts all .eps files in the working directory to .pdf}{p_end}
{phang}{cmd:. eps2pdf stsgraph}{p_end}
{phang}{cmd:. eps2pdf stsgraph.eps hazardrates, dir(figures)}{p_end}


{marker author}{...}
{title:Author}

{pstd}
Gorkem Aksaray, Koc University.{p_end}
{p 4}Email: {browse "mailto:gaksaray@ku.edu.tr":gaksaray@ku.edu.tr}{p_end}
{p 4}Personal Website: {browse "https://sites.google.com/site/gorkemak/":sites.google.com/site/gorkemak}{p_end}
{p 4}GitHub: {browse "https://github.com/gaksaray/":github.com/gaksaray}{p_end}
