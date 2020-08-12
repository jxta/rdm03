#!/bin/sh

jupyter notebook password

if [ $? = '0' ]; then
	echo change passwd
	pkill tini
else
	echo no change passwd
	exit 0
fi


