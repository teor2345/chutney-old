#!/bin/sh

# this is an untested hack, but it sure cleans up great!

# we assume "chutney" appears somewhere in the tor command line for test procs
# (and doesn't appear in any tor processes you don't want killed)

# I'd use grep "$CHUTNEY_PATH", but that doesn't seem to work
ps -xw -o pid=,command= | \
  grep chutney | grep tor | cut -c 1-5 | xargs kill -KILL
