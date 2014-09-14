#!/bin/sh

# this is a bit of a hack

# we assume "chutney" appears somewhere in the tor command line for test procs
# (and doesn't appear in any tor processes you don't want killed)

ps uxw | grep tor | grep chutney | grep "$CHUTNEY__PATH" | cut -d" " -f2 | xargs kill -KILL
