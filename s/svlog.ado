*! version 0.1.3  21may2023  Gorkem Aksaray <aksarayg@tcd.ie>

capture program drop svlog
program define svlog
    version 12
    gettoken subcmd 0: 0, parse(" ,")
    if "`subcmd'" == "close" {
        _logclose `0' 
    }
    else if "`subcmd'" == "clear" {
        _logclear `0'
    }
    else {
        _log `subcmd' `0'
    }
end

capture program drop _logclose
program _logclose
    syntax [, view]
    qui log query _current_log
    local filename = r(filename)
    capture log close _current_log
    if "`view'" == "" {
        di as txt `"(log written to {view "`filename'"})"'
    }
    else if "`view'" != "" {
         view `"`filename'"'
    }
end

capture program drop _logclear
program _logclear
    syntax [anything(name=script id="script")] [, dir(string)]
    
    if "`dir'" == "" {
        local logdir "./logs"
    }
    else {
        local logdir "`dir'/logs"
    }
    
    local filelist : dir "`logdir'/" files "`script'*.smcl", respectcase
    foreach file of local filelist {
        erase "`logdir'/`file'"
    }
end

capture program drop _log
program _log, rclass
    syntax anything(name=script id="script") [, noDT noUN clear dir(string)]
    
    capture log close _current_log
    
    if "`dir'" == "" {
        local logdir "./logs"
    }
    else {
        local logdir `"`dir'/logs"'
    }
    
    capture mkdir `logdir'
    
    if "`clear'" != "" {
        _logclear `script', dir(`dir')
    }
    
    local logfile "`logdir'/`script'"
    
    if "`dt'" != "nodt" {
        local datetime : di %tcCCYY-NN-DD!_HH.MM.SS `=clock("$S_DATE $S_TIME", "DMYhms")'
        local logfile "`logfile'_`datetime'"
    }
    if "`un'" != "noun" {
        local username = c(username)
        local logfile "`logfile'_`username'"
    }
    
    log using "`logfile'.smcl", replace name(_current_log) nomsg
    
    return local script = "`script'"
end
