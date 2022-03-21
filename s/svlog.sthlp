{smcl}
{* *! version 0.1.1  21mar2022  Gorkem Aksaray <gaksaray@ku.edu.tr>}{...}
{vieweralsosee "log" "log"}{...}
{cmd:help svlog}{right: {browse "https://github.com/gaksaray/stata-gautils/"}}
{hline}

{title:Title}

{phang}
{bf:svlog} {hline 2} Save logs to /logs/ folder with time and date stamp


{title:Syntax}

{p 8 17 2}
{cmd:svlog}
{it:script_name}
[{cmd:,} {opt notd} {opt clear} {opt dir(subdirectory)}]

{p 8 17 2}
{cmd:svlog close}
[{cmd:,} {opt view}]

{p 8 17 2}
{cmd:svlog clear}
[{cmd:,} {opt dir(subdirectory)}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{* syntab:tab}{...}
{synopt:[{opt no}]{opt td}}do not write time and date stamp to log file; {opt td} is default{p_end}
{synopt:{opt clear}}run {opt svlog clear} before opening log file{p_end}
{synopt:{opt dir(subdirectory)}}locate and save /logs/ folder within the subdirectory{p_end}
{synopt:{opt view}}view the log file immediately after it is closed{p_end}
{synoptline}
{p2colreset}{...}


{title:Description}

{pstd}
{cmd:svlog} is a wrapper for {help log}.
It opens a log file with the name _current_log, and saves it with the {it:script_name} and optionally (by default) a time and date stamp
to ./logs/ (or optionally {it:subdirectory}/logs/) folder.

{pstd}
{cmd:svlog close} closes the current log named _current_log.

{pstd}
{cmd:svlog clear} clears the /logs/ folder from the log files with names including {it:script_name}.


{title:Author}

{pstd}
Gorkem Aksaray, Koç University.{break}
Email: {browse "mailto:gaksaray@ku.edu.tr":gaksaray@ku.edu.tr}{break}
Personal Website: {browse "https://sites.google.com/site/gorkemak/":sites.google.com/site/gorkemak}{break}
GitHub: {browse "https://github.com/gaksaray/":github.com/gaksaray}{break}
