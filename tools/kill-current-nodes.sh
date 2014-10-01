#!/bin/sh

# this is an untested hack, but it sure cleans up great!
cat "$CHUTNEY_PATH"/net/nodes/*/pid | xargs kill -KILL
