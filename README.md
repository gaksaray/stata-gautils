# stata-gautils

This is a collection of Stata utility modules that I developed and use across
several of my projects.

## Installation

You may install individual packages or the whole repository from within Stata.
First, use the following command to set your current net location:
```stata
net from "https://raw.githubusercontent.com/gaksaray/stata-gautils/master"
```

Next, you can browse among subdirectories by `net cd` command, desribe and
download any package:
```stata
net cd r
net describe reshape2l
net install reshape2l
net cd ..
net cd m
net describe maxvarlen
net install maxvarlen
```

To install all packages directly within Stata, use the following command:
```stata
capture ado uninstall gautils
net install gautils, from("https://raw.githubusercontent.com/gaksaray/stata-gautils/master")
```
and to update:
```stata
ado update gautils, update
```

To see the list of all commands in `gautils` package after installation, type `help gautils`.
To see how a specific command works, type `help [command]` within Stata to view `.sthlp` file.
For commands with no help files, you can type `which [command]` as I tend to include a short
explanation of the command along with its syntax and several examples at the top of `.ado` files.
