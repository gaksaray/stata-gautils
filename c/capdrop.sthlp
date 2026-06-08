{smcl}
{* version 1.0.1  08jun2026  Gorkem Aksaray <aksarayg@tcd.ie>}{...}
{viewerjumpto "Syntax" "capdrop##syntax"}{...}
{viewerjumpto "Description" "capdrop##description"}{...}
{viewerjumpto "Examples" "capdrop##examples"}{...}
{viewerjumpto "Author" "capdrop##author"}{...}
{vieweralsosee "gautils" "help gautils"}{...}
{cmd:help capdrop}{right: {browse "https://github.com/gaksaray/stata-gautils/"}}
{hline}

{title:Title}

{phang}
{bf:capdrop} {hline 2} Drop a list of variables without an error


{marker syntax}{...}
{title:Syntax}

{p 8}
{cmd: capdrop} {varlist}


{marker description}{...}
{title:Description}

{pstd}
{cmd:capdrop} drops the variables in {varlist} from the dataset in memory. It is a
tolerant version of {helpb drop}: it behaves like {cmd:capture drop}, so any name that
is not currently in the dataset is silently skipped rather than stopping execution with
an error. This is convenient inside do-files and programs when you want to drop a group
of variables that may or may not be present.

{pstd}
{varlist} may include variable name abbreviations, wildcards ({cmd:*} and {cmd:?}), and
hyphenated ranges (such as {cmd:mpg-trunk}); any tokens that match no current variable
are ignored.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. sysuse auto, clear}{p_end}
{phang}{cmd:. capdrop price pricesq}        // drops price with no error{p_end}
{phang}{cmd:. capdrop rep?? junk*}          // wildcards; drops rep78{p_end}
{phang}{cmd:. capdrop mpg-trunk gear_ratio} // a range plus a single variable{p_end}


{marker author}{...}
{title:Author}

{pstd}
Gorkem Aksaray, Trinity College Dublin.{p_end}
{p 4}Email: {browse "mailto:aksarayg@tcd.ie":aksarayg@tcd.ie}{p_end}
{p 4}Personal Website: {browse "https://sites.google.com/site/gorkemak/":sites.google.com/site/gorkemak}{p_end}
{p 4}GitHub: {browse "https://github.com/gaksaray/":github.com/gaksaray}{p_end}
