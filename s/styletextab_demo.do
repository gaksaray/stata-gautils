clear all
cd
webuse lbw, clear

logit low age lwt i.race smoke ptl ht ui
estimates store m1

logit low age lwt i.race smoke ptl ht ui ftv
estimates store m2

etable, estimates(m1 m2) column(index) center   ///
    mstat(N, nformat(%12.0fc))                  ///
    mstat(chi2)                                 ///
    showstars showstarsnote                     ///
    title("Table title")                        ///
    note("Note: Table notes go here.")          ///
    export(mytable.tex, replace)

styletextab,                                    ///
    usepackage(ucs, opt(mathletters) pre)       ///
    usepackage(inputenc, opt(utf8x) pre)

styletextab,                                                        ///
    usepackage(ucs, opt(mathletters) pre)                           ///
    usepackage(inputenc, opt(utf8x) pre)                            ///
    usepackage(geometry, opt(margin=1in) pre)                       ///
    usepackage(setspace, opt(onehalfspacing))                       ///
    usepackage(endfloat, opt(nofiglist,notablist) pre               ///
               n("\renewcommand\floatplace[1]{%"                    ///
                 "  \begin{center}"                                 ///
                 "    [Insert \csname #1name\endcsname~%"           ///
                 "     \csname thepost#1\endcsname\ about here.]"   ///
                 "  \end{center}}"))

styletextab,                                                        ///
    label(fig:reg1)                                                 ///
    usepackage(ucs, opt(mathletters) pre)                           ///
    usepackage(inputenc, opt(utf8x) pre)                            ///
    usepackage(geometry, opt(margin=1in) pre)                       ///
    usepackage(setspace, opt(onehalfspacing))                       ///
    usepackage(endfloat, opt(nofiglist,notablist) pre               ///
               n("\renewcommand\floatplace[1]{%"                    ///
                 "  \begin{center}"                                 ///
                 "    [Insert \csname #1name\endcsname~%"           ///
                 "     \csname thepost#1\endcsname\ about here.]"   ///
                 "  \end{center}}"))                                ///
    usepackage(parskip) usepackage(lipsum)                          ///
    before(\section*{Regression models})                            ///
    before("Table~\ref{fig:reg1} presents regressions."             ///
           "These regressions are very interesting." \lipsum[1])    ///
    before(Let's see how \dq{they} look:)                           ///
    after(This text comes after Table~\ref{fig:reg1}. \lipsum[2])   ///
    after(\lipsum[3])
