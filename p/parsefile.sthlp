{smcl}
{* version 1.2  13jun2026  Gorkem Aksaray <aksarayg@tcd.ie>}{...}
{viewerjumpto "Syntax" "parsefile##syntax"}{...}
{viewerjumpto "Description" "parsefile##description"}{...}
{viewerjumpto "Remarks" "parsefile##remarks"}{...}
{viewerjumpto "Examples" "parsefile##examples"}{...}
{viewerjumpto "Stored results" "parsefile##results"}{...}
{viewerjumpto "Author" "parsefile##author"}{...}
{vieweralsosee "gautils" "help gautils"}{...}
{cmd:help parsefile}{right: {browse "https://github.com/gaksaray/stata-gautils/"}}
{hline}

{title:Title}

{phang}
{bf:parsefile} {hline 2} Parse the path, file name, and extension from the using modifier


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:parsefile} {cmd:using} {it:{help filename:filespec}}


{marker description}{...}
{title:Description}

{pstd}
{cmd:parsefile} breaks the file specification given in a {helpb using} modifier
into its directory path, file name, and extension, and posts them to {cmd:r()}.
It is a small programmer's utility, meant to be called from other commands that
need to take apart a {cmd:using} filespec; it displays nothing of its own.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:parsefile} accepts any file specification: a bare file name, a relative or
absolute path, or a URL, with or without enclosing quotes.

{pstd}
The path is split from the file name at the {it:last} occurrence of any of the
characters {cmd:~}, {cmd::}, {cmd:/}, or {cmd:\}. These cover the forward slash
of Unix and URLs, the backslash and drive colon of Windows, the tilde of a Unix
home directory, and the colon of a classic Mac path. Everything up to and
including that separator is returned in {cmd:r(path)}, and the remainder is the
final component that is split into name and extension. A specification with no
separator has an empty {cmd:r(path)}.

{pstd}
The file name and extension are split at the {it:last} period in that final
component: {cmd:r(extension)} is the text after it and {cmd:r(filename)} the text
before it. Thus {cmd:archive.tar.gz} yields a file name of {cmd:archive.tar} and
an extension of {cmd:gz}. A component with no period has an empty
{cmd:r(extension)}.

{pstd}
A {it:leading} period is not treated as an extension separator, so dotfiles such
as {cmd:.gitignore} are returned whole as the file name, with no extension.

{pstd}
A specification that ends in a separator, such as the bare directory
{cmd:mydir/}, has an empty {cmd:r(filename)}. Spaces are preserved within both
the path and the file name.


{marker examples}{...}
{title:Examples}

{pstd}A plain file name{p_end}
{phang}{cmd:. parsefile using mydata.dta}{p_end}
{pmore}{cmd:r(filename)} = {cmd:mydata}, {cmd:r(extension)} = {cmd:dta}{p_end}

{pstd}A Windows path{p_end}
{phang}{cmd:. parsefile using C:\data\mydata.dta}{p_end}
{pmore}{cmd:r(path)} = {cmd:C:\data\}, {cmd:r(filename)} = {cmd:mydata}, {cmd:r(extension)} = {cmd:dta}{p_end}

{pstd}A Unix path with no extension{p_end}
{phang}{cmd:. parsefile using ~/project/mydata}{p_end}
{pmore}{cmd:r(path)} = {cmd:~/project/}, {cmd:r(filename)} = {cmd:mydata}{p_end}

{pstd}A URL{p_end}
{phang}{cmd:. parsefile using https://www.stata-press.com/data/r17/auto.dta}{p_end}
{pmore}{cmd:r(path)} = {cmd:https://www.stata-press.com/data/r17/}, {cmd:r(filename)} = {cmd:auto}, {cmd:r(extension)} = {cmd:dta}{p_end}

{pstd}A name with several periods (the extension is taken after the last one){p_end}
{phang}{cmd:. parsefile using archive.tar.gz}{p_end}
{pmore}{cmd:r(filename)} = {cmd:archive.tar}, {cmd:r(extension)} = {cmd:gz}{p_end}

{pstd}A dotfile (the leading period stays with the name){p_end}
{phang}{cmd:. parsefile using .gitignore}{p_end}
{pmore}{cmd:r(filename)} = {cmd:.gitignore}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:parsefile} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(path)}}directory portion of the specification, empty if none{p_end}
{synopt:{cmd:r(filename)}}file name{p_end}
{synopt:{cmd:r(extension)}}file extension, empty if none provided{p_end}
{p2colreset}{...}


{marker author}{...}
{title:Author}

{pstd}
Gorkem Aksaray, Trinity College Dublin.{p_end}
{p 4}Email: {browse "mailto:aksarayg@tcd.ie":aksarayg@tcd.ie}{p_end}
{p 4}Personal Website: {browse "https://sites.google.com/site/gorkemak/":sites.google.com/site/gorkemak}{p_end}
{p 4}GitHub: {browse "https://github.com/gaksaray/":github.com/gaksaray}{p_end}
