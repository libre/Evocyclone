#!/bin/bash
#
#    Program : webservice
#            :
#      Author : Deraoui Said     <said.deraoui@childdefense.eu>
#    Purpose :
# Parameters : --help
#                      : --version
#         
#      Notes : See --help for details
#============:==============================================================
#set -x 
PROGNAME=`basename $0`
PROGPATH=`echo $0 | /bin/sed -e 's,[\\/][^\\/][^\\/]*$,,'`
REVISION=`echo '$Revision: 0.1.0.0 $' | sed -e 's/[^0-9.]//g'`
datelog=`date "+%F_%H-%M-%S"`

print_usage() {
        echo "Usage: $PROGNAME [-ip IPLAN] [-port 80] [-webroot /var/web] [-log /tmp/weblog]"
        echo "          -ip ( LAN GW default)"
        echo "          -port ( 80 default)"
		echo "          -webroot  ( /var/web/ default)"
		echo "          -log /tmp/webservice.log (default)"
        echo ""
        echo "Usage: $PROGNAME --help"
        echo "Usage: $PROGNAME --version"
}
print_help() {
        echo "$PROGNAME $REVISION"
        echo ""
        echo ""
        print_usage
        echo ""
        echo "IA SpySpot Suite. © You2Diy.com 2020"
        echo ""
        exit 0
#        support
}
# Function check ip is valide. 
function valid_ip() {
    local  ip=$IP
    local  stat=1
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}
# Check mounting processing
check() {
	#Check running root proection
	if [ $UID = 0 ]; then
		echo "ROOT DETECTED /!\ Please not run as root"
	#	exit 1
	fi
	# LOG
	if [ "${LOG}" = "" ]; then
			LOG="/tmp/webservice.log"
			echo "$datelog Starting log webservice					[OK]" >> $LOG
	fi	
	# IP
	if [ "${IP}" = "" ]; then
			IP="0.0.0.0"
			echo "$datelog Not ip specified ... All  IP for Use [OK]" >> $LOG
	fi
	# Check valide IP
	if valid_ip $IP; then
		stat='good'
		echo "$datelog IP Testing OK										[OK]" >> $LOG
	else 
		# Stop not work bad IP
		stat='bad'
		echo "$datelog BAD IP Detected for start server		[OK]" >> $LOG
		IP="0.0.0.0"
		echo "$datelog Not ip specified ... All  IP for Use [OK]" >> $LOG
	fi
	# PORT
	if [ "${PORT}" = "" ]; then
			IP="80"
			echo "$datelog Port not specified use $IP default 	[OK]" >> $LOG
	fi
	# WEBROOT
	if [ "${WEBROOT}" = "" ]; then
			WEBROOT="/var/web"
			echo "$datelog Webroot use default $WEBROOT	[OK]" >> $LOG
	fi
	# Webroot exist
	if [ ! -d "$WEBROOT" ]; then
		echo "$datelog Webroot  folder not exist	[ERROR]" >> $LOG
		echo "$datelog Web ERROR 					[STOPED]" >> $LOG
		exit 1
	fi
	echo "$datelog All check OK							[Starting]" >> $LOG
	# Test is running 
	if [ -a /tmp/web.pid ]; then
		TESTPID=`ps ax | awk '{ print $5 }' | grep php | wc -l`
		if [ $TESTPID != 0 ]; then 
			echo "$datelog Service running !!!! 		[STOPED]" >> $LOG
			exit 1
		fi
		echo "$datelog File lock present ... 			[Unlocking]" >> $LOG
		rm -rf /tmp/web.pid
	fi
	echo "STARTING" > /tmp/web.pid
	echo "$datelog Service starting						[Wait]" >> $LOG
	starting
}

# Starting Deamon Server Process. 
starting() {
	while true; do
		TTRUE=`cat /tmp/web.pid`
		if [ $TTRUE == "STARTING" ]; then 
			/usr/bin/php -S $IP:$PORT -t $WEBROOT >> $LOG &
			#runuser -l box-$HOSTNAME -c 'ulimit -SHa' "/usr/bin/php -S $IP:$PORT -t $WEBROOT >> $LOG"
			echo "STARTED" > /tmp/web.pid
			sleep 5
		fi 
		TESTPID=`ps ax | awk '{ print $5 }' | grep php | wc -l`
		if [ $TESTPID = 0 ]; then
			echo "$datelog Service not running !!!! 	[ERROR]" >> $LOG
			rm -rf /tmp/web.pid
			exit 1
		fi
		T3TRUE=`cat /tmp/web.pid`
		if [ $T3TRUE = "STOP" ]; then 
			echo "$datelog PID Order stop web	 	[STOPING]" >> $LOG
			stopping
		fi
		T4TRUE=`cat /tmp/web.pid`
		if [ $T4TRUE = "RELOAD" ]; then 
			echo "$datelog PID Order Reload Web..." >> $LOG
			reload
		fi		
		T2TRUE=`cat /tmp/web.pid`
		if [ $T2TRUE != "STARTED" ]; then 
			echo "$datelog Not status !!!!	 				[ERROR]" >> $LOG
			rm -rf /tmp/web.pid
			exit 1
		fi
		sleep 5
	 done
}

# Stoping Deamon Server Process.
stopping() {
	rm -rf /tmp/web.pid
	killall -9 php
	echo "$datelog Stoped service	 		[STOP]" >> $LOG
	exit 0
}

# Stoping Deamon Server Process.
reload() {
	stopping
	starting
	echo "$datelog Service Web reloaded !" >> $LOG
	exit 0
}

while test -n "$1"; do
        case "$1" in
			--help)
				print_help
				exit $STATE_OK
				;;
			-V)
				print_revision $PROGNAME $REVISION
				exit $STATE_OK
				;;
			-ip)
				IP=$2;
				shift;
				;;
			-port)
				PORT=$2;
				shift;
				;;
			-log)
				LOG=$2;
				shift;
				;; 
			-webroot)
				WEBROOT=$2;
				shift;
				;;
			*)
				echo "Unknown argument: $1"
				print_usage
				exit $STATE_UNKNOWN
				;;
        esac
        shift
done
check
echo "Unknow Error Phase running"
exit 1
