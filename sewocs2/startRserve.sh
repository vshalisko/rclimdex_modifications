#!/bin/bash

ps -ef | grep -v grep | grep 26311

if [ $? -eq 1 ]
then
	echo "Starting Rserve"
	R CMD Rserve --gui-none --RS-port 26311
	if [ $? -eq 1 ]
	then
		echo "Rserve failed"
	else
		ps axl | grep Rserve
	fi
else
	echo "Rserve is already running"
fi

ps -ef | grep -v grep | grep xvfb-auth.conf

if [ $? -eq 1 ]
then
	echo "Stating Xvfb"
	nohup Xvfb :200 -screen 0 1280x1024x24 -auth /etc/xvfb-auth.conf -shmem -fbdir /var/tmp/ > /dev/null 2>&1 &
	ps -ef | grep -v grep | grep Xvfb
	if [ $? -eq 1 ]
	then
		echo "Xvfb failed"
	else
		ps axl | grep Xvfb
	fi
else
	echo "Xvfb is already running"
fi


