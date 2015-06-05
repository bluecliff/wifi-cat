#!/bin/sh

CheckProcess() {
	if [ "$1" = "" ];
	then
		return 0
	fi

	PROCESS_NUM=`ps | grep "$1" | grep -v "grep" | wc -l`
	if [ $PROCESS_NUM -eq 1 ];
	then
		return 1
	else
		return 0
	fi
	}

while [ 1 ] ; do
	CheckProcess "wificat"
	if [ $? -eq 1 ];
	then
		sleep 40s
	else
		/etc/init.d/wificat start
	fi
	done