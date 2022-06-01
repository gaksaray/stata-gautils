{smcl}
{* version 1.0  07feb2021}{...}
{viewerjumpto "Syntax" "maxvarlen##syntax"}{...}
{viewerjumpto "Description" "maxvarlen##description"}{...}
{viewerjumpto "Stored results" "maxvarlen##results"}{...}
{viewerjumpto "Examples" "maxvarlen##examples"}{...}
{viewerjumpto "Author" "maxvarlen##author"}{...}
{vieweralsosee "gautils" "help gautils"}{...}
{cmd:help maxvarlen}{right: {browse "https://github.com/gaksaray/stata-gautils/"}}
{hline}

{title:Title}

{phang}
{bf:maxvarlen} {hline 2} Calculate maximum character length of variables names or labels


{marker syntax}{...}
{title:Syntax}

{p 8}
{cmd: maxvarlen} {varlist} [{cmd:,} {opt lab:els}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:maxvarlen} calcualates and saves the maximum character length of names
of variables specified in {varlist}, or of their labels if {opt labels} is
specified.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. sysuse auto}{p_end}
{phang}{cmd:. maxvarlen make price mpg}{p_end}
{phang}{cmd:. maxvarlen make price mpg, labels}{p_end}
{phang}{cmd:. maxvarlen _all}{p_end}
{phang}{cmd:. maxvarlen _all, lab}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:maxvarlen} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(chars)}}number of characters{p_end}
{p2colreset}{...}


{marker author}{...}
{title:Author}

{pstd}
Gorkem Aksaray, Koc University.{p_end}
{p 4}Email: {browse "mailto:gaksaray@ku.edu.tr":gaksaray@ku.edu.tr}{p_end}
{p 4}Personal Website: {browse "https://sites.google.com/site/gorkemak/":sites.google.com/site/gorkemak}{p_end}
{p 4}GitHub: {browse "https://github.com/gaksaray/":github.com/gaksaray}{p_end}
