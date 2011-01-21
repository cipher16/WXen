#!/bin/bash

CPATH="`pwd`/cgi-bin"
function exec_commande {

	while read line; do $line;echo "$line `date`">>"$CPATH/executed";done < "$CPATH/commands"
	$CPATH/generate-vms.py >"$CPATH/vms"
	> "$CPATH/commands"
	sleep 1
	exec_commande
}

exec_commande
