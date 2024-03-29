{smcl}
{* version 1.5  24dec2021  Gorkem Aksaray <aksarayg@tcd.ie>}{...}
{viewerjumpto "Syntax" "grpvars##syntax"}{...}
{viewerjumpto "Description" "grpvars##description"}{...}
{viewerjumpto "Options" "grpvars##options"}{...}
{viewerjumpto "Examples" "grpvars##examples"}{...}
{viewerjumpto "Stored results" "grpvars##results"}{...}
{viewerjumpto "Author" "grpvars##author"}{...}
{vieweralsosee "gautils" "help gautils"}{...}
{hi:help grpvars}{right: {browse "https://github.com/gaksaray/stata-gautils/"}}
{hline}

{title:Title}

{pstd}{hi:grpvars} {hline 2} Create and manage variable groups


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:grpvars} {varlist}{cmd:,} {opt name(grpname)}
[{help grpvars##option_table:{it:refcat_options}}]

{p 8 16 2}
{cmd:grpvars add}|{cmd:remove} {varlist}
[{cmd:,} {opt name(grpname)}
{help grpvars##option_table:{it:refcat_options}}]

{p 8 16 2}
{cmd:grpvars replace}
[{cmd:(}]{help varlist:{it:out}}[{cmd:)}] [{cmd:(}]{help varlist:{it:in}}[{cmd:)}]
[{cmd:,} {opt name(grpname)}
{help grpvars##option_table:{it:refcat_options}}]

{p 8 16 2}
{cmd:grpvars list}|{cmd:drop}|{cmd:keep}
[{cmd:,} {opt name(grpname)}]

{p 8 16 2}
{cmd: grpvars dir}

{p 8 16 2}
{cmd: grpvars clear}

{p 8 16 2}
{cmd: grpvars vl}
[{cmd:,} {help grpvars##option_table:{it:refcat_options}} {it:excluding} {opt title}]


{marker option_table}{...}
{synoptset 16 tabbed}{...}
{synopthdr:refcat_options}
{synoptline}
{syntab:Title}
{synopt :{opt t:itle(string)}}specify a title for the variable group{p_end}
{synopt :{opt p:refix(string)}}specify a string to be added at the beginning of title{p_end}
{synopt :{opt s:uffix(string)}}specify a string to be added at the end of title{p_end}

{syntab:Formatting}
{synopt :{opt latex}|{opt tex}|{opt html}}specify whether formatting options are for LaTeX or HTML{p_end}
{synopt :{opt it:alic}}make title italic{p_end}
{synopt :{opt b:old}}make title bold{p_end}
{synopt :{opt em:space(#)}}specify \hspace spacing (only for LaTeX){p_end}
{synoptline}


{marker description}{...}
{title:Description}

{pstd}
{cmd:grpvars} is a collection of commands to create and manage variable groups.
A variable group is essentially a list of variables saved in a global macro
with the name specified by the {opt name()} option. {cmd:grpvars} commands can
conveniently manipulate these macros, and maintain their properties in memory.
This is especially useful for managing sets of variables to be used in several
tables. For example, you can specify the base model for the whole project, and
rather than redefining the global macro for the variable list,
add/remove/replace variables according to the specific needs of the current
table. This enables one to more easily narrate the variable selection process.
{cmd:grpvars} also maintains $refcat global macro if {opt title} option is
specified, to be used in {help estout##refcat:estout}.

{pstd}
{cmd:grpvars} by itself creates (or overwrites to) a variable group. {opt name}
option is required.

{pstd}
{cmd:grpvars add}|{cmd:remove} adds or removes {it:varlist} to/from the variable group specified by the {opt name} option (or all groups if {opt name} is not specified).

{pstd}
{cmd:grpvars replace} replaces either a variable, or a sequence of multiple
variables, with the specified variables. Parentheses are not required, except
if a sequence of variables are to be replaced.

{pstd}
{cmd:grpvars list} lists the variables inside the group specified by the
{opt name} option. If {opt name} option is omitted, it lists all variables in
all variable groups.

{pstd}
{cmd:grpvars drop} drop the group specified by the {opt name} option. If
{opt name} option is omitted, it drops all groups, i.e., triggers
{cmd:grpvars clear} command.

{pstd}
{cmd:grpvars keep} keeps the group specified by the {opt name} option and
drops the rest of the groups.

{pstd}
{cmd:grpvars clear} drops all groups from memory.

{pstd}
{cmd:grpvars vl} picks up all user-defined variable lists saved by the
{help vl} command as variable groups.
It clears all previously saved variable groups,
goes through each variable list defined by {cmd:vl},
saves their labels as titles (defined by {help vl label}),
and reformats all titles according to {it:refcat_options}.
Needless to say, {cmd:vl set} or {cmd:vl rebuild} must be run before running
{cmd: grpvars vl}, and the user-defined variable lists must be labeled.


{marker options}{...}
{title:Options}

{phang}
{cmd:title(}{it:string}{cmd:)} specifies a title for the variable group.
The title is added to the $refcat global macro, which includes the first
variable in variable group and the specified title. For example, a variable
group that consists {it: var1 var2 var3} with title {it: Title} is going to
be represented as {it: var1 "Title"} in $refcat.

{pstd}
The rest of the options modify the title specified by the {opt title} option,
and thus have no functionality if {opt title} is not specified.

{phang}
{cmd:prefix(}{it:string}{cmd:)} specifies a prefix to be added at the
beginning of title.

{phang}
{cmd:prefix(}{it:string}{cmd:)} specifies a prefix to be added at the
end of title.

{phang}
{cmd:latex}|{cmd:tex}|{cmd:html} specifies whether the rest of the options are
evaluated as LaTeX or HTML. {cmd:tex} is a synonym for {cmd:latex}.

{phang}
{cmd:italic} makes the title italic.

{phang}
{cmd:bold} makes the title bold.

{phang}
{cmd:emspace(}#{cmd:)} adds \hspace(#em) to the title, if {opt latex} or
{opt tex} is specified.


{marker examples}{...}
{title:Examples}

{pstd}Setup and define a variable group{p_end}

        {com}. grpvars clear
        {com}. sysuse auto, clear
        {txt}(1978 Automobile Data)
        
        {com}. grpvars mpg rep78, name(x_main) title("Main variables")
        {txt}x_main:{space 8}{res}{res}mpg rep78{txt}
        
        {com}. grpvars dir
        {txt}vargroups:{space 6}{res}{res}x_main
        {txt}refcat:{space 8}{res}{res}mpg "Main variables"{txt}

{pstd}Add and remove variables{p_end}

        {com}. grpvars add weight length, name(x_main)
        {txt}x_main:{space 8}{res}{res}mpg rep78 weight length{txt}
        {txt}

{pstd}We did not need to specify {opt name()}, as {it: x_main} is the only
variable group, but it is generally better to be explicit. If there were other
groups, {cmd:weight} and {cmd:length} would have been added to all of them.

        {com}. grpvars add weight length, name(x_main)
        {err}variable {bf:weight} is already in group x_main
        {err}variable {bf:length} is already in group x_main
        {txt}x_main:{space 8}{res}{res}mpg rep78 weight length{txt}

        {com}. grpvars remove mpg turn, name(x_main)
        {err}variable {bf:turn} not found in group x_main
        {txt}x_main:{space 8}{res}{res}rep78 weight length{txt}
        
        {com}. grpvars dir
        {txt}vargroups:{space 6}{res}{res}x_main
        {txt}refcat:{space 8}{res}{res}rep78 "Main variables"{txt}

{pstd}Replace variables{p_end}

        {com}. grpvars headroom trunk, name(x_inter) title("Interior variables")
        {txt}x_inter:{space 8}{res}{res}headroom trunk{txt}
        
        {com}. grpvars replace headroom turn
        {txt}x_inter:{space 8}{res}{res}turn trunk{txt}
        
        {com}. grpvars dir
        {txt}vargroups:{space 6}{res}{res}x_main x_inter
        {txt}refcat:{space 9}{res}{res}rep78 "Main variables" turn "Interior variables"{txt}
        
        {com}. grpvars replace (turn trunk) (headroom displacement), ///
        >     name(x_inter) title("Controls") tex b it em(5)
        {txt}x_inter:{space 8}{res}{res}headroom displacement
        
        {com}. grpvars dir
        {txt}vargroups:{space 6}{res}{res}x_main x_inter{txt}
        {txt}refcat:{space 9}{res}{res}rep78 "Main variables" headroom "\hspace{c -(}5em{c )-}\textbf{c -(}\textit{c -(}Controls{c )-}{c )-}"
        {txt}

{pstd}Using {opt vl} subcommand after {help vl}{p_end}

        {com}. grpvars drop, name(x_inter)
        {com}. vl create x_other = (gear_ratio displacement)
        {txt}note: {bf:$x_other} initialized with 2 variables.{txt}
        
        {com}. vl label x_other "Other controls"
        {com}. grpvars vl, tex italic
        {txt}x_other:{space 8}{res}{res}gear_ratio displacement
        
        {com}. grpvars dir
        {txt}vargroups:{space 6}{res}{res}x_main x_other{txt}
        {txt}refcat:{space 9}{res}{res}rep78 "Main variables" gear_ratio "\textit{Other controls}"{txt}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:grpvars} maintains two global macros, in addition to those created for
inividual variable groups. {cmd:$vargroups} contains a list of all variable
groups defined. {cmd:$refcat} contains the list of titles, if {opt title}
option was set.

{pstd}
{cmd:grpvars list, name()} returns {cmd:r(varlist)} macro containing the collection
of variables in variable groups specified by {opt name()}, and {cmd:r(k)} scalar
containing the number of variables in this list.

{pstd}
{cmd:grpvars dir} returns {cmd:r(vargroups)} macro containing the list of names
of variable groups, and {cmd:r(n_vargroups)} scalar containing the number of
variable groups in memory.


{marker author}{...}
{title:Author}

{pstd}
Gorkem Aksaray, Trinity College Dublin.{p_end}
{p 4}Email: {browse "mailto:aksarayg@tcd.ie":aksarayg@tcd.ie}{p_end}
{p 4}Personal Website: {browse "https://sites.google.com/site/gorkemak/":sites.google.com/site/gorkemak}{p_end}
{p 4}GitHub: {browse "https://github.com/gaksaray/":github.com/gaksaray}{p_end}
