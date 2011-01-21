#!/bin/bash

CURRENT_PATH="`pwd`/cgi-bin"
function exec_commande {
	while read line
	do
		if [ "$line" == "refresh" ]
		then 
			$CURRENT_PATH/generate-vms.py > $CURRENT_PATH/vms	
		else
			$line
		fi
		echo "$line `date`">>"$CURRENT_PATH/executed"
	done < "$CURRENT_PATH/commands"
	
	> "$CURRENT_PATH/commands"
	sleep 1
	
	exec_commande
}

exec_commande
