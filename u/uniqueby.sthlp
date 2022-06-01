{smcl}
{* version 1.1  02feb2022  Gorkem Aksaray <gaksaray@ku.edu.tr>}{...}
{viewerjumpto "Syntax" "uniqueby##syntax"}{...}
{viewerjumpto "Description" "uniqueby##description"}{...}
{viewerjumpto "Options" "uniqueby##options"}{...}
{viewerjumpto "Stored results" "uniqueby##results"}{...}
{viewerjumpto "Examples" "uniqueby##examples"}{...}
{viewerjumpto "Author" "uniqueby##author"}{...}
{vieweralsosee "gautils" "help gautils"}{...}
{cmd:help uniqueby}{right: {browse "https://github.com/gaksaray/stata-gautils/"}}
{hline}

{title:Title}

{phang}
{bf:uniqueby} {hline 2} Report number of unique values by group


{marker syntax}{...}
{title:Syntax}

{p 8}
{cmd: uniqueby} {varname} {ifin} [{cmd:,} {opt by(varname)}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:uniqueby} displays and stores the number of unique values of {varname} for each group
specifed in {opt by(varname)}.


{marker options}{...}
{title:Options}

{phang}
{opt by(varname)} specifies the group by which the unique values are displayed.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. sysuse auto}{p_end}
{phang}{cmd:. uniqueby mpg if foreign == 0}{p_end}
{phang}{cmd:. uniqueby mpg if foreign == 1}{p_end}
{phang}{cmd:. uniqueby mpg, by(foreign)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:uniqueby} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(r)}}number of distinct values{p_end}

{p2col 7 15 19 2: and if {opt by(varname)} is specified and all groups are integer numeric...}{p_end}
{synopt:{cmd:r(N}_{it:group#}{cmd:)}  }number of observations in group #{p_end}
{synopt:{cmd:r(r}_{it:group#}{cmd:)}  }number of distinct values in group #{p_end}
{p2colreset}{...}


{marker author}{...}
{title:Author}

{pstd}
Gorkem Aksaray, Koc University.{p_end}
{p 4}Email: {browse "mailto:gaksaray@ku.edu.tr":gaksaray@ku.edu.tr}{p_end}
{p 4}Personal Website: {browse "https://sites.google.com/site/gorkemak/":sites.google.com/site/gorkemak}{p_end}
{p 4}GitHub: {browse "https://github.com/gaksaray/":github.com/gaksaray}{p_end}
