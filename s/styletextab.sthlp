{smcl}
{* *! version 0.1  06may2023}{...}
{viewerjumpto "Syntax" "styletextab##syntax"}{...}
{viewerjumpto "Description" "styletextab##description"}{...}
{viewerjumpto "Options" "styletextab##options"}{...}
{viewerjumpto "Remarks" "styletextab##remarks"}{...}
{viewerjumpto "Examples" "styletextab##examples"}{...}
{viewerjumpto "Author" "styletextab##author"}{...}
{vieweralsosee "gautils" "help gautils"}{...}
{cmd:help styletextab}{right: {browse "https://github.com/gaksaray/stata-gautils/"}}
{hline}

{title:Title}

{phang}
{bf:styletextab} {hline 2} Style LaTeX tables exported by the collect suite of commands


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd: styletextab}
[{cmd:using} {it:{help filename}}]
[{cmd:,} {cmd:saving(}{it:filename} [{cmd:,} {opt replace}]{cmd:)} {it:options}]

{synoptset 21}{...}
{synopthdr}
{synoptline}
{synopt:{opt frag:ment}}keep only LaTeX {it:tabular} environment{p_end}
{synopt:{opt table:only}}keep only LaTeX {it:table} environment{p_end}
{synopt:[{opt no:]}{opt book:tabs}}specify whether to use LaTeX booktabs rules (default is {opt booktabs}){p_end}
{synopt:{opt lab:el}{cmd:(}{it:marker}{cmd:)}}label the table for cross-referencing{p_end}
{synopt:{opt ls:cape}}wrap the table in a LaTeX {it:landscape} environment{p_end}
{synopt:{opt before:text}{cmd:(}{it:string}{cmd:)}}add text before table{p_end}
{synopt:{opt after:text}{cmd:(}{it:string}{cmd:)}}add text after table{p_end}


{marker description}{...}
{title:Description}

{pstd}
{cmd:styletextab} improves the look of default LaTeX tables
exported by the {cmd:collect} suite of commands
by integrating more advanced LaTeX packages such as
{browse "https://ftp.heanet.ie/mirrors/ctan.org/tex/macros/latex/contrib/booktabs/booktabs.pdf":booktabs} (for better vertical spacing around horizontal rules),
{browse "https://ftp.heanet.ie/mirrors/ctan.org/tex/macros/latex/contrib/threeparttable/threeparttable.pdf":threeparttable} (for better formatting of table notes), and
{browse "https://ftp.heanet.ie/mirrors/ctan.org/tex/macros/latex/contrib/pdflscape/pdflscape.pdf":pdflscape} (for landscape tables).

{pstd}
The usual workflow involves running {cmd:styletextab}
right after {cmd:collect} exports, although not necessarily.
{cmd:styletextab} can edit any .tex file specified by {opt using} option
and save to any .tex file specified by {opt saving()} option.
File suffixes are optional (.tex is assumed).
If {opt using} option is omitted,
{cmd:styletextab} assumes that you want to convert the most recent LaTeX table exported.
If {opt saving} option is omitted,
{cmd: styletextab} assumes that you want to overwrite.


{marker options}{...}
{title:Options}

{phang}
{cmd:tableonly} keeps the {it:table} section only:

{p 8 8 2} {it:\begin{tabular}} {p_end}
{p 8 8 2} ... {p_end}
{p 8 8 2} {it:\end{tabular}} {p_end}

{p 8 8 2} The resulting .tex file can be included in a LaTeX document via {bf:\input} macro.

{phang}
{cmd:fragment} keeps the {it:tabular} section only:

{p 8 8 2} {it:\begin{table}[!h]} {p_end}
{p 8 8 2} ... {p_end}
{p 8 8 2} {it:\end{table}} {p_end}

{p 8 8 2} The resulting .tex file can be manually wrapped inside a custom {it:table} environment in a LaTeX document via {bf:\input} macro. {p_end}

{phang}
[{cmd:no}]{cmd:booktabs} replaces the default {bf:\cline} with the {bf:\cmidrule} macro from LaTeX's {bf:booktabs} package.

{phang}
{cmd:label(}{it:marker}{cmd:)} adds an additional line right after {bf:\caption} with {bf:\label} macro specifying the label marker for the table. This is used for cross-referencing the table within a LaTeX document.

{phang}
{cmd:lscape} invokes LaTeX's {bf:pdflscape} package to wrap the table in a landscape layout. This makes it easier to view tables that are too wide to fit in a portait page (for example, regression comparison tables with more than 5-6 models).

{phang}
{cmd:beforetext(}string{cmd:)} and {cmd:aftertext(}string{cmd:)} add separate lines of text before and after the table (only relevant if {opt fragment} and {opt tableonly} options are not specified).


{marker remarks}{...}
{title:Remarks}

{pstd}
Stata 17 introduced {cmd:collect} suite of commands
({help collect}, {help table}, {help etable}, and, with version 18, {help dtable}),
all of which can {help collect export:export} tables as LaTeX files.
By default, the output is a standalone compilable document.
{help collect_export##tex_opttbl:TeX export options} include {opt tableonly}
for exporting only the {it:table} environment,
which can be included in a LaTeX document via {bf:\input} macro.
Additionally, {help collect_style_tex##syntax:TeX style options} include
{opt begintable} for specifying whether to use {it:table} environment
(or to keep the {it:tabular} environment only)
and {opt centering} for specifying whether to center table horizontally
on the page via {bf:\centering}.
Although one can always produce a fragment (i.e., {it:tabular}-only) table
and wrap it in a custom table environment in a separate document,
the default standalone document mode is useful for
quickly inspecting the look of the LaTeX tables.

{pstd}
However, the default output has several basic visual flaws:
horizontal lines are drawn by {bf:\cline},
footnotes are centered by default and do not have the same width as the table,
and there is no option to rotate the table.
{cmd:styletextab}, by default, improves exported LaTeX tables
by replacing {bf:\cline} with the nicer-looking {bf:\cmidrule} of the
{browse "https://ftp.heanet.ie/mirrors/ctan.org/tex/macros/latex/contrib/booktabs/booktabs.pdf":booktabs} package, and
by wrapping footnotes within the {bf:\tablenotes} environment of the
{browse "https://ftp.heanet.ie/mirrors/ctan.org/tex/macros/latex/contrib/threeparttable/threeparttable.pdf":threeparttable} package.
Optionally, it can rotate tables (i.e., switches to landscape layout)
by wrapping tables within the {bf:\landscape} environment of
{browse "https://ftp.heanet.ie/mirrors/ctan.org/tex/macros/latex/contrib/pdflscape/pdflscape.pdf":pdflscape} package.

{pstd}
{cmd:styletextab} works by dividing a .tex table file into its sections,
and uses {help file} commands to reformat it to improve their look.
An advantage of {cmd:styletextab} is that it can go from one mode
to another without creating the table from scratch.


{marker examples}{...}
{title:Examples}

{pstd}Export a collect table as .tex file:{p_end}
{phang}{cmd:. sysuse auto, clear}{p_end}
{phang}{cmd:. regress price mpg}{p_end}
{phang}{cmd:. estimates store m1}{p_end}
{phang}{cmd:. regress price mpg i.foreign}{p_end}
{phang}{cmd:. estimates store m2}{p_end}
{phang}{cmd:. etable, estimates(m1 m2) mstat(N) column(index) ///}{p_end}
{phang}{cmd:> {space 4}showstars showstarsnote{space 20} ///}{p_end}
{phang}{cmd:> {space 4}title("Table title"){space 24}///}{p_end}
{phang}{cmd:> {space 4}note("Note: Table notes go here."){space 10}///}{p_end}
{phang}{cmd:> {space 4}export(mytable.tex, replace)}{p_end}

{pstd}Restyle with default settings (booktabs + threeparttable):{p_end}
{phang}{cmd:. styletextab} {p_end}

{pstd}Switch to landscape and save it as a different file:{p_end}
{phang}{cmd:. styletextab using mytable, saving(mytable_lscape) lscape}{p_end}

{pstd}Add a label marker, and some text before and after table:{p_end}
{phang}{cmd:. styletextab, {space 41} ///}{p_end}
{phang}{cmd:> {space 4}label(fig:reg1){space 35} ///}{p_end}
{phang}{cmd:> {space 4}before(Table~\ref{fig:reg1} presents regressions.) ///}{p_end}
{phang}{cmd:> {space 4}after(This text comes after Table~\ref{fig:reg1}.)}{p_end}

{pstd}Table environment only:{p_end}
{phang}{cmd:. styletextab, tableonly}{p_end}
{pstd}{it:(going back to standalone document from mytable.tex would keep caption and footnotes)}

{pstd}Tabular environment only:{p_end}
{phang}{cmd:. styletextab, fragment}{space 1}{p_end}
{pstd}{it:(going back to standalone document from mytable.tex would not include caption and footnotes)}


{marker author}{...}
{title:Author}

{pstd}
Gorkem Aksaray, Trinity College Dublin.{p_end}
{p 4}Email: {browse "mailto:aksarayg@tcd.ie":aksarayg@tcd.ie}{p_end}
{p 4}Personal Website: {browse "https://sites.google.com/site/gorkemak/":sites.google.com/site/gorkemak}{p_end}
{p 4}GitHub: {browse "https://github.com/gaksaray/":github.com/gaksaray}{p_end}
