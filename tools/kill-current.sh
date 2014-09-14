#!/bin/sh

cat "$CHUTNEY_PATH"/net/nodes/*/pid | xargs kill -KILL
