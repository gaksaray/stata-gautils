{smcl}
{* version 1.0  08jun2026  Gorkem Aksaray <aksarayg@tcd.ie>}{...}
{viewerjumpto "Syntax" "clearlab##syntax"}{...}
{viewerjumpto "Description" "clearlab##description"}{...}
{viewerjumpto "Examples" "clearlab##examples"}{...}
{viewerjumpto "Author" "clearlab##author"}{...}
{vieweralsosee "gautils" "help gautils"}{...}
{cmd:help clearlab}{right: {browse "https://github.com/gaksaray/stata-gautils/"}}
{hline}

{title:Title}

{phang}
{bf:clearlab} {hline 2} Clear all labels and notes


{marker syntax}{...}
{title:Syntax}

{p 8}
{cmd: clearlab}


{marker description}{...}
{title:Description}

{pstd}
{cmd:clearlab} is a small utility program that strips all labels and notes from the
dataset in memory. It removes the dataset label, all variable labels, all value labels,
and all notes, leaving the data themselves untouched. This is convenient when you want
a clean slate before relabeling, or when preparing data for export.

{pstd}
{cmd:clearlab} takes no arguments and acts on the entire dataset. The changes are not
reversible, so save your data beforehand if the labels or notes might be needed later.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. sysuse auto, clear}{p_end}
{phang}{cmd:. describe}{p_end}
{phang}{cmd:. notes}{p_end}
{phang}{cmd:. labelbook}{p_end}
{phang}{cmd:. clearlab}{p_end}
{phang}{cmd:. describe}  // no variable labels{p_end}
{phang}{cmd:. notes}     // no notes{p_end}
{phang}{cmd:. labelbook} // no value labels{p_end}


{marker author}{...}
{title:Author}

{pstd}
Gorkem Aksaray, Trinity College Dublin.{p_end}
{p 4}Email: {browse "mailto:aksarayg@tcd.ie":aksarayg@tcd.ie}{p_end}
{p 4}Personal Website: {browse "https://sites.google.com/site/gorkemak/":sites.google.com/site/gorkemak}{p_end}
{p 4}GitHub: {browse "https://github.com/gaksaray/":github.com/gaksaray}{p_end}
