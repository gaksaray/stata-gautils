{smcl}
{* *! version 0.1.3  21may2023  Gorkem Aksaray <aksarayg@tcd.ie>}{...}
{viewerjumpto "Syntax" "svlog##syntax"}{...}
{viewerjumpto "Description" "svlog##description"}{...}
{viewerjumpto "Remarks" "svlog##remarks"}{...}
{viewerjumpto "Author" "svlog##author"}{...}
{vieweralsosee "gautils" "help gautils"}{...}
{vieweralsosee "log" "help log"}{...}
{cmd:help svlog}{right: {browse "https://github.com/gaksaray/stata-gautils/"}}
{hline}

{title:Title}

{phang}
{bf:svlog} {hline 2} Save logs to /logs/ folder with time and date stamp


{title:Syntax}{marker syntax}

{p 8 17 2}
{cmd:svlog}
{it:script_name}
[{cmd:,} {opt notd} {opt noun} {opt clear} {opt dir(subdirectory)}]

{p 8 17 2}
{cmd:svlog close}
[{cmd:,} {opt view}]

{p 8 17 2}
{cmd:svlog clear}
[{it:script_name}]
[{cmd:,} {opt dir(subdirectory)}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{* syntab:tab}{...}
{synopt:[{opt no}]{opt td}}do not add time and date to log filename; {opt td} is default{p_end}
{synopt:[{opt no}]{opt un}}do not add username (provided by the operating system) of the user currently using Stata to log filename; {opt un} is default{p_end}
{synopt:{opt clear}}run {opt svlog clear} before opening log file{p_end}
{synopt:{opt dir(subdirectory)}}locate and save /logs/ folder within the subdirectory{p_end}
{synopt:{opt view}}view the log file immediately after it is closed{p_end}
{synoptline}
{p2colreset}{...}


{title:Description}{marker description}

{pstd}
{cmd:svlog} is a wrapper for {help log}.
It opens a {help SMCL} log file with the name _current_log,
and saves it, with the {it:script_name}
and optionally (by default) a time and date stamp,
to ./logs/ (or optionally {it:subdirectory}/logs/) folder.

{pstd}
{cmd:svlog close} closes the current log named _current_log.

{pstd}
{cmd:svlog clear} clears the /logs/ folder from the log files with names including {it:script_name}.
If {it:script_name} is omitted, it deletes all logs in the /logs/ (or {it:subdirectory}/logs/) folder.


{title:Remarks}{marker remarks}

{pstd}
Usual {cmd:log} commands such as {cmd:log off}{c |}{cmd:on} or {cmd:log query} can be used within a script along with {cmd:svlog}.


{title:Author}{marker author}

{pstd}
Gorkem Aksaray, Trinity College Dublin.{break}
Email: {browse "mailto:aksarayg@tcd.ie":aksarayg@tcd.ie}{break}
Personal Website: {browse "https://sites.google.com/site/gorkemak/":sites.google.com/site/gorkemak}{break}
GitHub: {browse "https://github.com/gaksaray/":github.com/gaksaray}{break}
