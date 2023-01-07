{smcl}
{* *! version 1.0.1  22apr2021}{...}
{viewerjumpto "Syntax" "stpiece2##syntax"}{...}
{viewerjumpto "Description" "stpiece2##description"}{...}
{viewerjumpto "Author" "stpiece2##author"}{...}
{vieweralsosee "gautils" "help gautils"}{...}
{cmd:help stpiece2}{right: {browse "https://github.com/gaksaray/stata-gautils/"}}
{hline}

{title:Title}

{phang}
{bf:stpiece2} {hline 2} Estimation of piecewise-constant hazard rate models


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd: stpiece2}
[{help varlist}] [{help if}] [{help in}]
[, {opt tp}{cmd:(}{help numlist}{cmd:)}
   {opt tv}{cmd:(}{help varlist}{cmd:)}
   {opt pre:split(#)}
   {opt nopre:serve}
   {help streg:{it:streg_options}}]


{marker description}{...}
{title:Description}

{pstd}
This is a modern rewriting of the {browse "https://ideas.repec.org/c/boc/bocode/s396801.html":stsplit} command by Jesper B. Sorensen with the same functionality while allowing factor variables to be used in {it: varlist}.

{pstd}
{cmd:stpiece} is a wrapper that uses a number of existing Stata routines to estimate piecewise-constant hazard rate models.
A piecewise-constant model is an exponential hazard rate model where the constant rate is allowed to vary within pre-defined time-segments.
See the discussion in, for example, Blossfeld and Rohwer (1995).
Estimation of this model in Stata is usually a multi-step process, since one must manually define the time pieces and if necessary split the spells.
{cmd:stpiece} automates this process.

{pstd}
{cmd:stpiece} allows you to define the time intervals (time pieces) with the {opt tp} option and then splits the data for. In addition, {cmd:stpiece} will allow you to specify, with the {opt tv} option, variables whose effects you think may be non-proportional, i.e. they may vary between time pieces.

{pstd}
By default, {cmd:stpiece} will {cmd:{help preserve}} your data before creating the time pieces. This is typically convenient as it leaves your data "as is," thereby avoiding any problems that can arise when you split the spells and then decide to change your outcome variable.  However, it does slow the program down, since the data must be re-split before each model estimation. The {opt nopreserve} option will cause {cmd:stpiece} to change the data. You can then use the {opt presplit} option to avoid having to split the data again.

{pstd}
The data must be {cmd:{help st}}. In order to create time pieces, an id variable must be declared with {cmd:{help stset}}.


{marker options}{...}
{title:Options}

{pstd}
{opt tp}{cmd:()} allows you to define the time periods using a {help numlist}.
The logic is the same as for {cmd: stsplit}.
The time pieces are listed in the output as {opt _tp#}, where # indexes the time pieces sequentially, starting at 1.

{pstd}
{opt tv}{cmd:()} allows you to specify variables whose effects vary between time pieces.
These variables appear in the output as {it:_stub}_tp#, where {it: stub} is the first four letters of the variable name, and # indexes time pieces sequentially, starting at 1.
For example, specifying {opt tv}{cmd:(}educat{cmd:)} for a model with four time pieces would result in variables labelled _educ_tp1 - _educ_tp4.
The user must be sensitive to the possibility of variable name conflicts.

{pstd}
{opt presplit}{cmd:(#)} is useful if the data has already been split and the time pieces have already been defined.
# specifies how many time pieces exist.
In this case, the variables identifying the time peices must follow the convention defined by the option {opt tp}.
In other words, the time period dummy variables must be of the form _tp#, starting at _tp1 and increasing sequentially. Note that it is possible to combine {opt tv} with {opt presplit}.

{pstd}
{opt nopreserve} tells {cmd:stpiece} that you are willing to let it change your data.
There are two advantages: 1) speed (particularly in large data sets) derived from not having to run {cmd:stsplit} again; and 2) you retain the split dataset and the variables created by {cmd:stpiece} after it finishes.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse cancer, clear}{p_end}
{phang2}{cmd:. generate n = _n}{p_end}
{phang2}{cmd:. stset studytime, failure(died) id(n)}{p_end}

{pstd}Estimate the piecewise-constant model{p_end}
{phang2}{cmd:. stpiece2, tp(0(10)40)}{p_end}
{phang2}{cmd:. stpiece2 i.drug, tp(0(10)40) tv(age) nopreserve}{p_end}
{phang2}{cmd:. stpiece2 i.drug, tv(age) pre(4)}{p_end}


{marker references}{...}
{title:References}

{pstd}
Blossfeld, Hans-Peter, and Gotz Rohwer. 1995. Techniques of Event History Modeling. Mahwah, NJ: Lawrence Erlbaum.


{title:Note}

{pstd}
The parameter estimates generated by {cmd:stpiece} will not match exactly with the results produced by Transition Data Analysis (TDA).
This is due to a minor difference between TDA and {cmd:stsplit} in how they define time pieces.
Specifically, TDA defines time pieces in the manner [t0,t1) while {cmd:stsplit} defines time pieces in the manner (t0,t1].
The estimates can be made to agree by subtracting a very small constant from the finishing times when using {cmd:stpiece}, but all that is achieved by this is making the software packages agree.


{marker author}{...}
{title:Author}

{pstd}
Gorkem Aksaray, Trinity College Dublin.{p_end}
{p 4}Email: {browse "mailto:aksarayg@tcd.ie":aksarayg@tcd.ie}{p_end}
{p 4}Personal Website: {browse "https://sites.google.com/site/gorkemak/":sites.google.com/site/gorkemak}{p_end}
{p 4}GitHub: {browse "https://github.com/gaksaray/":github.com/gaksaray}{p_end}
