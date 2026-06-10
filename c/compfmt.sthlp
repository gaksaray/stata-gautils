{smcl}
{* version 1.0.0  10jun2026  Gorkem Aksaray <aksarayg@tcd.ie>}{...}
{viewerjumpto "Syntax" "compfmt##syntax"}{...}
{viewerjumpto "Description" "compfmt##description"}{...}
{viewerjumpto "Options" "compfmt##options"}{...}
{viewerjumpto "Examples" "compfmt##examples"}{...}
{viewerjumpto "Author" "compfmt##author"}{...}
{vieweralsosee "gautils" "help gautils"}{...}
{cmd:help compfmt}{right: {browse "https://github.com/gaksaray/stata-gautils/"}}
{hline}

{title:Title}

{phang}
{bf:compfmt} {hline 2} Compress display formats to suit each variable's type


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:compfmt} [{varlist}] [{cmd:,} {opt td} {opt preserve}]

{synoptset 16 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{opt td}}also reformat time and date variables, which are otherwise skipped{p_end}
{synopt :{opt preserve}}keep the justification, leading zeros, and commas of numeric formats{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:compfmt} gives each variable in {varlist} the most compact display format
appropriate for its type. Variables of different types may be mixed freely in
one call, and any type not present is ignored; with no {varlist}, all variables
are processed.

{pstd}
A {it:string} variable is recast to fit its longest value, shrinking both its
storage type and its display width; see {helpb recast}. A long or binary
{cmd:strL} that will not fit an ordinary {cmd:str#} type is left untouched.

{pstd}
A {it:numeric} variable is first reduced to its smallest storage type with
{helpb compress}, then given the default display format for that type:

{p2colset 13 25 29 2}{...}
{p2col :{cmd:byte}}{cmd:%8.0g}{p_end}
{p2col :{cmd:int}}{cmd:%8.0g}{p_end}
{p2col :{cmd:long}}{cmd:%12.0g}{p_end}
{p2col :{cmd:float}}{cmd:%9.0g}{p_end}
{p2col :{cmd:double}}{cmd:%10.0g}{p_end}
{p2colreset}{...}

{pstd}
The format therefore follows the {it:compressed} type rather than the original:
a {cmd:double} that holds only small whole numbers ends up a {cmd:byte} with
format {cmd:%8.0g}.

{pstd}
Time and date variables, numeric variables carrying a {cmd:%t} format such as
{cmd:%td} or {cmd:%tc}, are left untouched by default; the {opt td} option
includes them.


{marker options}{...}
{title:Options}

{phang}
{opt td} reformats time and date variables (those with a {cmd:%t} format) as
ordinary numeric variables. Without it, they are recognized by their format and
skipped, so their date display is preserved.

{phang}
{opt preserve} keeps the justification, leading zeros, and commas of a numeric
variable's existing format while otherwise resetting it to the type default.
With it, {cmd:%09.0fc} becomes {cmd:%08.0gc} instead of {cmd:%8.0g}: the leading
zero and comma carry over, and the rest reverts to the default.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang}{cmd:. sysuse auto, clear}{p_end}

{pstd}Compress every display format in the dataset{p_end}
{phang}{cmd:. compfmt}{p_end}
{phang}{cmd:. describe}{p_end}

{pstd}Compress selected variables, keeping format attributes{p_end}
{phang}{cmd:. format price %09.0fc}{p_end}
{phang}{cmd:. compfmt price mpg, preserve}{p_end}

{pstd}Include a date variable rather than skipping it{p_end}
{phang}{cmd:. generate d = mdy(1, 1, 2020)}{p_end}
{phang}{cmd:. format d %td}{p_end}
{phang}{cmd:. compfmt d, td}{p_end}


{marker author}{...}
{title:Author}

{pstd}
Gorkem Aksaray, Trinity College Dublin.{p_end}
{p 4}Email: {browse "mailto:aksarayg@tcd.ie":aksarayg@tcd.ie}{p_end}
{p 4}Personal Website: {browse "https://sites.google.com/site/gorkemak/":sites.google.com/site/gorkemak}{p_end}
{p 4}GitHub: {browse "https://github.com/gaksaray/":github.com/gaksaray}{p_end}
