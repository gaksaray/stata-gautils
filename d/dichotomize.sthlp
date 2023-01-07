{smcl}
{* *! version 1.2  10jul2021}{...}
{viewerjumpto "Syntax" "dichotomize##syntax"}{...}
{viewerjumpto "Description" "dichotomize##description"}{...}
{viewerjumpto "Options" "dichotomize##options"}{...}
{viewerjumpto "Examples" "dichotomize##examples"}{...}
{viewerjumpto "Author" "dichotomize##author"}{...}
{vieweralsosee "gautils" "help gautils"}{...}
{cmd:help dichotomize}{right: {browse "https://github.com/gaksaray/stata-gautils/"}}
{hline}

{title:Title}

{phang}
{bf:dichotomize} {hline 2} Dichotomize a numeric variable


{marker syntax}{...}
{title:Syntax}

{p 8 20 2}
{cmd:dichotomize} {varname}{cmd:,}
{help dichotomize##truecond:{it:truecond}}
{opth gen:erate(newvar)}
[{opt lab:el("label")}
{help dichotomize##placement:{it:placement}}]

{marker truecond}
{synoptset 16}{...}
{synopthdr:truecond}
{synoptline}
{synopt :{opth in:list(numlist)}}specify the values of the variable to be true; useful for converting categorical variables{p_end}
{synopt :{opt leq(#)}}specify the highest value to be true{p_end}
{synopt :{opt geq(#)}}specify the lowest value to be true{p_end}
{synoptline}
{syntab: {it:truecond} options can be specified simultaneously to set the values of the {varname} to be converted to 1; the rest of the non-missing values will be automatically converted to 0}
{p2colreset}{...}

{marker placement}
{synoptset 16}{...}
{synopthdr:placement}
{synoptline}
{synopt :{opt first}}place the new variable to beginning of dataset{p_end}
{synopt :{opt last}}place the new variable to end of dataset{p_end}
{synopt :{opth b:efore(varname)}}place the new variable before {it:varname}{p_end}
{synopt :{opth a:fter(varname)}}place the new variable after {it:varname}{p_end}
{synoptline}
{syntab: the default behavior is to place the new variable right after the original variable}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:dichotomize} creates a binary variable out of a numeric {varname}. It provides convenience by combining functions of {help generate}, {help replace}, {help label}, and {help order} in one line.


{marker options}{...}
{title:Options}

{phang}
{opth inlist(numlist)} specifies the values of the variable to be converted to 1.
The rest of the values will be automatically converted to 0.

{phang}
{opt leq(#)} and {opt geq(#)} specify the range of the values of the variable to be converted to 1, respectively as "less than or equal to" and "greater than or equal to".
When used together, if the number specified in {opt leq(#)} is less than the number of specified in {opt geq(#)}, then the ranges are non-overlapping and thus both are converted to 1.
If, on the other hand, the number specified in {opt leq(#)} is greater than the number specified in {opt geq(#)}, the overlapping range is converted to 1
(i.e., inrange({it:z},{it:a},{it:b}) where {it:a} is set by {opt geq(a)} and {it:b} is set by {opt leq(b)}). 

{phang}
{opt label("label")} specifies the label for the created binary variable.

{phang}
{opth generate(newvar)} specifies the name of the created binary variable.

{phang}
{opt first} places the new variable to the beginning of the dataset.

{phang}
{opt last} places the new variable to the end of the dataset.

{phang}
{opth before(varname)} places the new variable before {it:varname}.

{phang}
{opth after(varname)} places the new variable after {it:varname}.
The default behavior is to place the new variables right after the original variable.


{marker examples}{...}
{title:Examples}

{phang2}{cmd:. sysuse webauto}{p_end}
{phang2}{cmd:. dichotomize mpg, inlist(25/41) generate(mpg_hi) label("High milage")}{p_end}
{phang2}{cmd:. dichotomize mpg, leq(25) gen(mpg_low) lab("Low milage")}{p_end}
{phang2}{cmd:. dichotomize mpg, leq(25) geq(20) gen(mpg_mid) lab("Mid milage")}{p_end}
{phang2}{cmd:. dichotomize mpg, leq(15) geq(35) gen(mpg_ext) lab("Too low-high milage")}{p_end}
{phang2}{cmd:. dichotomize mpg, in(15 17) geq(35) leq(35) gen(mpg_cherry) lab("Cherry-picked milage") before(trunk)}{p_end}

{marker author}{...}
{title:Author}

{pstd}
Gorkem Aksaray, Trinity College Dublin.{p_end}
{p 4}Email: {browse "mailto:aksarayg@tcd.ie":aksarayg@tcd.ie}{p_end}
{p 4}Personal Website: {browse "https://sites.google.com/site/gorkemak/":sites.google.com/site/gorkemak}{p_end}
{p 4}GitHub: {browse "https://github.com/gaksaray/":github.com/gaksaray}{p_end}
