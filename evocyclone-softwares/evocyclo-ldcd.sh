#!/bin/bash
#
#    Program : EvoCyclone LCD Service
#            : RESISTANCECOVID.COM 
#            : https://github.com/libre/resistancecovid/evocyclo/
#     Author : Deraoui Said     <said.deraoui@gmail.com>
#    Purpose :
# Parameters : --help
#            : --version
#         
#      Notes : See --help for details
#============:==============================================================
#set -x
PROGNAME=`basename $0`
PROGPATH=`echo $0 | /bin/sed -e 's,[\\/][^\\/][^\\/]*$,,'`
REVISION=`echo '$Revision: 0.0.1.4 $' | sed -e 's/[^0-9.]//g'`
datelog=`date "+%F_%H-%M-%S"`
PID_LCD='/tmp/lcd.pid'
PIDMSG_LCD='/tmp/lcd_msg.pid'
PID_MENU='/tmp/evo-menu.pid'
PATHLCD='/opt/evocyclone/lcd'
SLEEPDEBUG=0
print_usage() {
        echo "Usage: $PROGNAME [--log /var/log/evo-motordrive.log] [--debug 0|1]"
        echo ""		
        echo "$PROGNAME --log Log path file /var/log/evo-motordrive.log (default)"
        echo "$PROGNAME --debug 0 (default) silent, 1 = log in file"
}
print_help() {
        echo "$PROGNAME $REVISION"
        echo ""
        echo "LCD Service for EvoCyclo"
		echo "Appliance Respirator"
        echo ""
        print_usage
        echo ""
        echo "EVO-CYCLO Suite. Resistancecovid.com 2020"
        echo ""
        exit 0
#        support
}

# Check mounting processing
check() {

	# Test is running 
	if [ -a $PID_LCD ]; then
		TESTPID=`ps ax | awk '{ print $7 }' | grep LCD | wc -l`
		if [ $TESTPID -lt 1 ]; then 
			echo "$datelog Service running !!!! 		[STOPED]"
			exit 1
		fi
		echo "$datelog File lock present ... 			[Unlocking]"
		rm -rf $PID_LCD
	fi
	
	# Check Debug status
	if [ -z "${DEBUGSTATUS}" ]; then 
		DEBUGSTATUS=0
	fi
	
	# Debug 0 
	if [ "${DEBUGSTATUS}" = "0" ]; then 
		LOGFILE = "/dev/null"
		echo "$datelog Starting log webservice DEBUG = 0	[OK]" >> $LOGFILE
	fi
	# Debug 1 
	if [ "${DEBUGSTATUS}" = "1" ]; then 
		# Check logfile default value
		if [ "${LOGFILE}" = "" ]; then
			LOGFILE="/tmp/evo-motordrive.log"
		fi	
		echo "$datelog Starting log webservice DEBUG = 1	[OK]" >> $LOGFILE
	fi
	
	# Check PID MENU Service is started
	if [ -a $PID_MENU ]; then
		MENU_ORDRE = $PID_MENU
		echo "$datelog Pid Menu Process Detected				[OK]" >> $LOGFILE
	else 
		MENU_ORDRE = '/dev/null'
		echo "$datelog Pid MENU Process Not Detected		[WARNING]" >> $LOGFILE
	fi
	
	echo "STARTING_LCD" > $PID_LCD
	echo "$datelog Service starting						[Wait]"
	starting
}

# Starting Deamon Server Process. 
starting() {
	while true; do
		TTRUE=`cat $PID_LCD`
		if [ $TTRUE == "STARTING_LCD" ]; then 
			cd $PATHLCD
			screen -dmS LCD sh -c "python $PATHLCD/stop.py"
			echo "$datelog Service LCD running !!!! 	[OK]" >> $LOGFILE
			echo "LCD_START" > $PID_LCD
		fi 
		TESTPID=`ps ax | awk '{ print $7 }' | grep LCD | wc -l`
		if [ $TESTPID -lt 1 ]; then
			echo "$datelog Service not running !!!! 	[ERROR]"
			echo "$datelog Service not running !!!! 	[ERROR]" >> $LOGFILE
			rm -rf $PID_LCD
			exit 1
		fi
		T4TRUE=`cat $PID_LCD`
		if [ $T4TRUE == "LCD_RUNNING" ]; then 
			screen -X -S LCD kill
			screen -dmS LCD sh -c "python $PATHLCD/running.py"
			echo "LCD_START" > $PID_LCD
			echo "$datelog PID Order LCD Running 		[RUNNING]" >> $LOGFILE
		fi
		T4TRUE=`cat $PID_LCD`
		if [ $T4TRUE == "LCD_CYCLE" ]; then 
			data=`cat $PIDMSG_LCD`
			screen -X -S LCD kill
			screen -dmS LCD sh -c "python $PATHLCD/runningcycle.py -m ${data}"
			echo "$datelog PID Order LCD Error code $data [OK]"	 >> $LOGFILE			
			echo "LCD_ERROROK" > $PID_LCD
		fi		
		T5TRUE=`cat $PID_LCD`
		if [ $T5TRUE == "LCD_ERROR" ]; then 
			data=`cat $PIDMSG_LCD`
			screen -X -S LCD kill
			screen -dmS LCD sh -c "python $PATHLCD/error.py -m ${data}"
			echo "$datelog PID Order LCD Error code $data [OK]"	 >> $LOGFILE				
			sleep 1
			echo "LCD_ERROROK" > $PID_LCD
		fi
		T6TRUE=`cat $PID_LCD`
		if [ $T6TRUE == "LCD_STOP" ]; then 
			screen -X -S LCD kill
			screen -dmS LCD sh -c "python $PATHLCD/stop.py"
			echo "$datelog PID Order LCD Status stop [OK]"  >> $LOGFILE			
			echo "LCD_STOPED" > $PID_LCD
		fi
		T7TRUE=`cat $PID_LCD`
		if [ $T7TRUE == "STOP" ]; then 
			echo "$datelog PID Order stop service	 	[STOPING]" >> $LOGFILE
			stopping
		fi
		T7TRUE=`cat $PID_LCD`
		if [ $T7TRUE == "RELOAD" ]; then 
			echo "$datelog PID Order reload service	 	[RELOADING]" >> $LOGFILE
			reload
		fi		
		### Integration Menu Interaction 
		#
		MENUCHECK=`cat $PID_LCD`
		if [ $MENUCHECK == "LCD_MENU_MASTER_1" ]; then 
			screen -X -S LCD kill
			screen -dmS LCD sh -c "python $PATHLCD/menu_master_1.py"
			echo "$datelog PID Order LCD Menu Master 1 [OK]"  >> $LOGFILE			
			echo "LCD_MENUOK" > $PID_LCD
		fi
		MENUCHECK=`cat $PID_LCD`
		if [ $MENUCHECK == "LCD_MENU_MASTER_2" ]; then 
			screen -X -S LCD kill
			screen -dmS LCD sh -c "python $PATHLCD/menu_master_2.py"
			echo "$datelog PID Order LCD Menu Master 2 [OK]"  >> $LOGFILE			
			echo "LCD_MENUOK" > $PID_LCD
		fi
		MENUCHECK=`cat $PID_LCD`
		if [ $MENUCHECK == "LCD_MENU_MASTER_3" ]; then 
			screen -X -S LCD kill
			screen -dmS LCD sh -c "python $PATHLCD/menu_master_3.py"
			echo "$datelog PID Order LCD Menu Master 3 [OK]"  >> $LOGFILE			
			echo "LCD_MENUOK" > $PID_LCD
		fi

		MENUCHECK=`cat $PID_LCD`
		if [ $MENUCHECK == "LCD_MENU_STATUS_1" ]; then 
			screen -X -S LCD kill
			screen -dmS LCD sh -c "python $PATHLCD/menu_status_1.py"
			echo "$datelog PID Order LCD Menu Status 1 [OK]"  >> $LOGFILE			
			echo "LCD_MENUOK" > $PID_LCD
		fi
		MENUCHECK=`cat $PID_LCD`
		if [ $MENUCHECK == "LCD_MENU_STATUS_2" ]; then 
			screen -X -S LCD kill
			screen -dmS LCD sh -c "python $PATHLCD/menu_status_2.py"
			echo "$datelog PID Order LCD Menu Status 2 [OK]"  >> $LOGFILE			
			echo "LCD_MENUOK" > $PID_LCD
		fi
		MENUCHECK=`cat $PID_LCD`
		if [ $MENUCHECK == "LCD_MENU_STATUS_3" ]; then 
			screen -X -S LCD kill
			screen -dmS LCD sh -c "python $PATHLCD/menu_status_3.py"
			echo "$datelog PID Order LCD Menu Status 3 [OK]"  >> $LOGFILE			
			echo "LCD_MENUOK" > $PID_LCD
		fi
		
		MENUCHECK=`cat $PID_LCD`
		if [ $MENUCHECK == "LCD_MENU_SPEED_1" ]; then 
			screen -X -S LCD kill
			screen -dmS LCD sh -c "python $PATHLCD/menu_speed_1.py"
			echo "$datelog PID Order LCD Menu Speed 1 [OK]"  >> $LOGFILE			
			echo "LCD_MENUOK" > $PID_LCD
		fi
		MENUCHECK=`cat $PID_LCD`
		if [ $MENUCHECK == "LCD_MENU_SPEED_2" ]; then 
			screen -X -S LCD kill
			screen -dmS LCD sh -c "python $PATHLCD/menu_speed_2.py"
			echo "$datelog PID Order LCD Menu Speed 2 [OK]"  >> $LOGFILE			
			echo "LCD_MENUOK" > $PID_LCD
		fi
		MENUCHECK=`cat $PID_LCD`
		if [ $MENUCHECK == "LCD_MENU_SPEED_3" ]; then 
			screen -X -S LCD kill
			screen -dmS LCD sh -c "python $PATHLCD/menu_speed_3.py"
			echo "$datelog PID Order LCD Menu Speed 3 [OK]"  >> $LOGFILE			
			echo "LCD_MENUOK" > $PID_LCD
		fi
		sleep $SLEEPDEBUG
	 done
}

# Stoping Deamon Server Process.
stopping() {
	screen -X -S LCD kill
	rm -rf $LOGFILE
	rm -rf $PIDMSG_LCD
	echo "$datelog Stoped LCD service	 		[STOP]"
	exit 0
}

# Stoping Deamon Server Process.
reload() {
	screen -X -S LCD kill
	rm -rf $LOGFILE
	rm -rf $PIDMSG_LCD
	check
	starting
	echo "$datelog Service LCD reloaded !"
	exit 0
}

while test -n "$1"; do
        case "$1" in
                -H|-h|--help)
					print_help
					exit 0
					;;
                -V|-v|--version)
					print_revision $PROGNAME $REVISION
					exit 0
					;;
                --device)
                    DEVICE=$2;
                    shift;
                    ;;
                --port)
                    PORT=$2;
                    shift;
                    ;;
                --log)
                    LOGFILE=$2;
                    shift;
                    ;;
                --debug)
                    DEBUGSTATUS=$2;
                    shift;
                    ;;				
                *)
                    echo "Unknown argument: $1"
					print_usage
                    exit 2
                    ;;
        esac
        shift
done
check
echo "Unknow Error Phase running"
exit 1

