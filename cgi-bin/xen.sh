#!/bin/bash

echo "Content-Type: text/html;charset=utf-8"
echo ""
CURRENT_PATH="`pwd`"

function displayMachine {
echo "<h2>VM List</h2><ul>"
for i in `cat "$CURRENT_PATH/vms"`;
do
	state=`echo "$i"|awk -F" " '{ print $3 }'`
	id=`echo "$i"|awk -F" " '{ print $2 }'`
	name=`echo $i|awk -F" " '{print $1}'`

	echo "<li class='state-$state'>"
	echo $name	
	#some test
	if [ $id != "0" ];then
		case $state in
			5) echo "<a href='?start&name=$name'>[START]</a>";;
			2) echo "<a href='?stop&name=$name'>[STOP]</a><a href='?suspend&name=$name'>[SUSPEND]</a>";;
			3) echo "<a href='?resume&name=$name'>[RESUME]</a>";;
			1) echo "[STARTING PLEASE WAIT ...]";;
			*) echo $state;;
		esac
	else
		echo "[RUNNING]"
	fi
	echo "</li>"
done;
echo "</ul>"
}

function addAndExecute {
	echo "<div class='info'>Adding Command : $1</div>"
	echo $1 >> "$CURRENT_PATH/commands"
}

#starting html page

IFS=$'\n'
echo "<html><head><title>XEN</title><link rel='stylesheet' href='../style.css' /></head><body>"
echo "<div class='page'>
		<div class='header'><h1><a href='xen.sh'>Administration XEN</a></h1></div>
		<div class='content'>"
echo "<a href='?a=refresh'>Refresh Vm stats</a>"



#check parameters

NAME=""
ACTI=""
if [ ! -z $QUERY_STRING ];then
	#SECURITY CHECK
	ACTI=`echo $QUERY_STRING|sed 's/\([a-z]*\).*/\1/'`
	NAME=`echo $QUERY_STRING|sed 's/.*=\([-a-zA-Z0-9]\)/\1/'`

	case $ACTI in 
		"start")
			addAndExecute "/usr/sbin/xm create /etc/xen/$NAME"
			;;
		"suspend")
			addAndExecute "/usr/sbin/xm pause $NAME"
			;;
		"stop")
			addAndExecute "/usr/sbin/xm destroy $NAME"
			;;
		"refresh")
			addAndExecute "$CURRENT_PATH/generate-vms.py > '$CURRENT_PATH/vms'"
			;;
		"resume")
			addAndExecute "/usr/sbin/xm unpause $NAME"
			;;
	esac

fi
#display after exection of parameters
displayMachine
echo "</div><div class='footer'>WXen by LoupZeur &copy;</div></div></html>"

