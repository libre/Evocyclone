#!/bin/bash
#
#    Program : Motor Drive Service
#            : RESISTANCECOVID.COM 
#            : https://github.com/libre/resistancecovid/evocyclo/
#     Author : Deraoui Said     <said.deraoui@gmail.com>
#    Purpose :
#         
#      Notes : See --help for details
#============:==============================================================

hash screen >/dev/null 2>&1 || { echo "screen not found, please install screen package."; exit 1; }
hash nc >/dev/null 2>&1 || { echo "nc not found, please install nc package."; exit 1; }
hash python >/dev/null 2>&1 || { echo "python not found, please install python package."; exit 1; }
hash php >/dev/null 2>&1 || { echo "php not found, please install php package."; exit 1; }

if [ -z $1 ] ; then
	echo "Install or not install "
	echo "ex: install"
	echo "ex: remove"
	exit 1
fi

if [ $1 == "install" ]; then
	echo "Copy EvoCyclone				[WAIT]"
	mkdir /opt/evocyclone/
	cp -rf evocyclone/* /opt/evocyclone
	echo "Copy EvoCyclone				[OK]"
	echo "Chmod Execute Mode EvoCyclone	[WAIT]"
	chmod +x /opt/evocyclone/motordrive/*
	chmod +x /opt/evocyclone/lcd/*
	chmod +x /opt/evocyclone/*
	echo "Chmod Execute Mode EvoCyclone	[OK]"
	echo "EvoCyclone startup 			[WAIT]"
	cp -rf initd/evocyclone /etc/init.d/evocyclone
	chmod +x /etc/init.d/evocyclone
	echo "/etc/init.d/evocyclone start" >> /etc/rc.local
	echo "EvoCyclone startup 			[OK]"
	echo "EvoCyclone suite installed..."
fi
if [ $1 == "remove" ]; then
	echo "Remove Startup EvoCyclone		[WAIT]"
	sed '/^/etc/init.d/evocyclone/d' /etc/rc.local
	echo "Remove Startup EvoCyclone		[OK]"
	echo "Remove Files EvoCyclone		[WAIT]"
	rm -rf /opt/evocyclone/
	rm -f /etc/init.d/evocyclone
	echo "Remove Files EvoCyclone		[OK]"
	echo "EvoCyclone suite uninstalled and removed..."
fi
echo "Setup Processing finished"
exit 0