#! /bin/sh
#
# 1. potentially stop running network
# 2. bootstrap a network from scratch as quickly as possible
# 3. tail -F all the tor log files
#
# NOTE: leaves debris around by renaming directory net/nodes
#       and creating a new net/nodes
#
# Usage:
#    cd YOUR-CHUTNEY-DIRECTORY
#    tools/bootstrap-network.sh [network-flavour]
#    network-flavour: one of the files in the networks directory,
#                     (default: 'basic')
#

VOTING_OFFSET=6
CHUTNEY=./chutney
myname=$(basename "$0")

[ -x $CHUTNEY ] || { echo "$myname: missing $CHUTNEY"; exit 1; }
[ -d networks ] || { echo "$myname: missing directory: networks"; exit 1; }
flavour=basic; [ -n "$1" ] && { flavour=$1; shift; }

$CHUTNEY stop networks/$flavour
[ -d net/nodes ] && {
    # XXXX stop may not work if you've changed the network flavour 
    # XXXX between start and stop. So we kill all previous tor nodes.
    echo "$myname: NOTE: killing any leftover tor processes in net/nodes"
    cat net/nodes/*/pid | xargs kill -KILL
    DEST=net/nodes.$(date +%s)
    echo "$myname: NOTE: renaming net/nodes to $DEST"
    mv net/nodes $DEST
}
echo "$myname: boostrapping network: $flavour"
$CHUTNEY configure networks/$flavour

# TODO: Make 'chutney configure' take an optional offset argument and
# use the templating system in Chutney to set this instead of editing
# files like this.
offset=$(expr \( $(date +%s) + $VOTING_OFFSET \) % 300)
CONFOPT="TestingV3AuthVotingStartOffset"
for file in net/nodes/*a/torrc; do
    sed -i.bak -e "s/^${CONFOPT}.*$/${CONFOPT} $offset/1" $file
done

$CHUTNEY start networks/$flavour
$CHUTNEY status networks/$flavour
#echo "tail -F net/nodes/*/notice.log"
