# Having trouble debugging error during export stage in Flatpak



# strace output

```
-ff
If the -o filename option is in effect, each processes trace is written to filename.pid where pid is the numeric process id of each process. This is incompatible with -c, since no per-process counts are kept.

-t
Prefix each line of the trace with the time of day.

-yy
Print protocol specific information associated with socket file descriptors.

-s strsize
Specify the maximum string size to print (the default is 32). Note that filenames are not considered strings and are always printed in full.

-o filename
Write the trace output to the file filename rather than to stderr. Use filename.pid if -ff is used. If the argument begins with '|' or with '!' then the rest of the argument is treated as a command and all output is piped to it. This is convenient for piping the debugging output to a program without affecting the redirections of executed programs.
```

```
mkdir strace_output/
strace -o strace_output/flatpak_strace.out -yy -s 4096 -t -ff  flatpak-builder --force-clean --disable-cache --delete-build-dirs -v --user --repo=scarlett_os-repo scarlett_os-repo org.scarlett.ScarlettOS.json
```
