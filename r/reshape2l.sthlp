{smcl}
{* v1.5.1  06apr2021}{...}
{viewerjumpto "Syntax" "reshape2l##syntax"}{...}
{viewerjumpto "Description" "reshape2l##description"}{...}
{viewerjumpto "Options" "reshape2l##options"}{...}
{viewerjumpto "Examples" "reshape2l##examples"}{...}
{viewerjumpto "Author" "reshape2l##author"}{...}
{cmd:help reshape2l}{right: {browse "https://github.com/gaksaray/stata-gautils/"}}
{hline}

{title:Title}

{phang}
{bf:reshape2l} {hline 2} Convert data from wide to long form faster


{marker syntax}{...}
{title:Syntax}

{p 8}
{cmd: reshape2l}
{it:stubnames}{cmd:,}
{cmd:i(}{varlist}{cmd:)}
[{cmd:j(}{varname}{cmd:)}
{opt c:ounter}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:reshape2l} converts data from wide to long form.
It is primarily used in situations where {it:stubnames} are followed by numeric parts, which is often the case for raw panel datasets.

{pstd}
{cmd:reshape2l} is similar to {helpb reshape} {helpb reshape##overview:long} but significantly faster, especially for large (and wide) datasets where memory requirement gets very high and {cmd:reshape long} becomes very slow.
It achieves faster speeds by relying on secondary storage rather than memory.
The speed gain of {cmd:reshape2l} over {cmd:reshape long} increases with size and width of the dataset as well as read and write speed of storage device where the
{browse "https://www.stata.com/support/faqs/data-management/statatmp-environment-variable/":STATATMP} folder resides.


{marker options}{...}
{title:Options}

{phang}
{opth i(varlist)} specifies the variables whose unique values denote a logical observation. {opt i()} is required.

{phang}
{opth j(varname)} specifies the variable whose unique values denote a numeric subobservation.

{phang}
{opt counter} prompts the program to display progress messages for the user.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. reshape2l status, i(id)}{p_end}

{phang}{cmd:. reshape2l gdp gnp, i(country) j(month)}{p_end}

{phang}{cmd:. reshape2l `stubs', i(caseid) j(jobid) counter}{p_end}


{marker author}{...}
{title:Author}

{pstd}
Gorkem Aksaray, Koc University, Turkey.{p_end}
{p 4}Email: {browse "mailto:gaksaray@ku.edu.tr":gaksaray@ku.edu.tr}{p_end}
{p 4}Personal Website: {browse "https://sites.google.com/site/gorkemak/":sites.google.com/site/gorkemak}{p_end}
{p 4}GitHub: {browse "https://github.com/gaksaray/":github.com/gaksaray}{p_end}
