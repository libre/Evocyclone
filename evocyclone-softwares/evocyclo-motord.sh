#!/bin/bash
#
#    Program : Motor Drive Service
#            : RESISTANCECOVID.COM 
#            : https://github.com/libre/resistancecovid/evocyclo/
#     Author : Deraoui Said     <said.deraoui@gmail.com>
#    Purpose :
# Parameters : --help
#            : --version
#         
#      Notes : See --help for details
#======:===============================
set -x
PROGNAME=`basename $0`
PROGPATH=`echo $0 | /bin/sed -e 's,[\\/][^\\/][^\\/]*$,,'`
REVISION=`echo '$Revision: 0.0.1.4 $' | sed -e 's/[^0-9.]//g'`
datelog=`date "+%F_%H-%M-%S"`
PID_PROCESS='/tmp/evo-motordrive.pid'
PID_SPEEDRETURNVALUE='/tmp/evo-motordrive_returnspeed.pid'
PID_MOTORRETURNVALUE='/tmp/evo-motordrive_returnmotor.pid'
PID_BVMRETURN='/tmp/evo-motordrive_returnbvm.pid'
SOCK_SPEEDVALUE='/tmp/evo-motordrive_returnspeed.sock'
SOCK_MOTORVALUE='/tmp/evo-motordrive_returnmotor.sock'
PID_MENU='/tmp/evo-menu.pid'
CYCLE_8="70"
CYCLE_12="80"
CYCLE_16="90"
CYCLE_18="100"
CYCLE_20="105"
CYCLE_24="115"
CYCLE_28="125"
CYCLE_30="130"
CYCLE_36="145"
CYCLE_40="155"
PID_LCD='/tmp/lcd.pid'
PIDMSG_LCD='/tmp/lcd_msg.pid'
PATHMOTORDRIVE='/opt/evocyclone/motordrive'
SLEEPLOOPDEBUG=0
# Function Usage Help.
# Function for internal check si real IP valide.
print_usage() {
        echo "Usage: $PROGNAME [--device 127.0.0.1 --port 2000] [--log /var/log/evo-motordrive.log] [--debug 0|1]"
        echo ""
        echo "$PROGNAME --device 127.0.0.1"
        echo "$PROGNAME --device 2000"		
        echo "$PROGNAME --log Log path file /var/log/evo-motordrive.log (default)"
        echo "$PROGNAME --debug 0 (default) silent, 1 = log in file"
        echo ""		
        echo "Usage: $PROGNAME --help"
        echo "Usage: $PROGNAME --version"
}


print_help() {
        echo "$PROGNAME $REVISION"
        echo ""
        echo "Motor drive Service for EvoCyclo"
		echo "Appliance Respirator"
        echo ""
        print_usage
        echo ""
        echo "EVO-CYCLO Suite. Resistancecovid.com 2020"
        echo ""
        exit 0
#        support
}

# Function check ip is valide.
# Function for internal check si real IP valide.
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

# Function Check Speed Cycle and update LCD_CYCLE
# Interaction to LCD Process and update state to LCD. 
function update_lcdcycle() {
	INIT_STATUT_SPEED=`timeout 1 $PATHMOTORDRIVE/status-speed.sh $DEVICE $PORT`
	STATUS_SPEED=`echo $INIT_STATUT_SPEED | awk ' {print $3 }'`
	if [ "${CYCLE_8}" = "${STATUS_SPEED}" ] ; then 
		echo "$datelog Speed Detected 8 Cycles/min 	[OK]" >> $LOGFILE
		speeddetect=1
		echo "8 Cycles/min ($STATUS_SPEED)" > $PIDMSG_LCD
		echo "LCD_CYCLE" > $PID_LCD		
	fi
	if [ "${CYCLE_12}" = "${STATUS_SPEED}" ] ; then 
		echo "$datelog Speed Detected 12 Cycles/min 	[OK]" >> $LOGFILE
		speeddetect=1
		echo "12 Cycles/min ($STATUS_SPEED)" > $PIDMSG_LCD
		echo "LCD_CYCLE" > $PID_LCD		
	fi
	if [ "${CYCLE_16}" = "${STATUS_SPEED}" ] ; then 
		echo "$datelog Speed Detected 16 Cycles/min 	[OK]" >> $LOGFILE
		speeddetect=1
		echo "16 Cycles/min ($STATUS_SPEED)" > $PIDMSG_LCD
		echo "LCD_CYCLE" > $PID_LCD		
	fi
	if [ "${CYCLE_18}" = "${STATUS_SPEED}" ] ; then 
		echo "$datelog Speed Detected 18 Cycles/min 	[OK]" >> $LOGFILE
		speeddetect=1
		echo "18 Cycles/min ($STATUS_SPEED)" > $PIDMSG_LCD
		echo "LCD_CYCLE" > $PID_LCD		
	fi
	if [ "${CYCLE_20}" = "${STATUS_SPEED}" ] ; then 
		echo "$datelog Speed Detected 20 Cycles/min 	[OK]" >> $LOGFILE
		speeddetect=1
		echo "20 Cycles/min ($STATUS_SPEED)" > $PIDMSG_LCD
		echo "LCD_CYCLE" > $PID_LCD		
	fi
	if [ "${CYCLE_24}" = "${STATUS_SPEED}" ] ; then 
		echo "$datelog Speed Detected 24 Cycles/min 	[OK]" >> $LOGFILE
		speeddetect=1
		echo "24 Cycles/min ($STATUS_SPEED)" > $PIDMSG_LCD
		echo "LCD_CYCLE" > $PID_LCD		
	fi
	if [ "${CYCLE_30}" = "${STATUS_SPEED}" ] ; then 
		echo "$datelog Speed Detected 30 Cycles/min 	[OK]" >> $LOGFILE
		speeddetect=1
		echo "30 Cycles/min ($STATUS_SPEED)" > $PIDMSG_LCD
		echo "LCD_CYCLE" > $PID_LCD		
	fi
	if [ "${CYCLE_36}" = "${STATUS_SPEED}" ] ; then 
		echo "$datelog Speed Detected 36 Cycles/min 	[OK]" >> $LOGFILE
		speeddetect=1
		echo "36 Cycles/min ($STATUS_SPEED)" > $PIDMSG_LCD
		echo "LCD_CYCLE" > $PID_LCD		
	fi
	if [ "${CYCLE_40}" = "${STATUS_SPEED}" ] ; then 
		echo "$datelog Speed Detected 40 Cycles/min 	[OK]" >> $LOGFILE
		speeddetect=1
		echo "40 Cycles/min ($STATUS_SPEED)" > $PIDMSG_LCD
		echo "LCD_CYCLE" > $PID_LCD		
	fi
	if [ "${speeddetect}" != 1 ] ; then 
		echo "$datelog Speed Not Detected ??? Cycles/min [WARNING]" >> $LOGFILE
		speeddetect=1
		echo "??? Cycles/min ($STATUS_SPEED)" > $PIDMSG_LCD
		echo "LCD_CYCLE" > $PID_LCD		
	fi 
}

# Function Update State Motor status 
# Update to PID_MOTORRETURNVALUE file
function state_motor() {
	# Detect Order Start Motor.
	INIT_STATUT_MOTOR=`timeout 1 $PATHMOTORDRIVE/status-motor.sh $DEVICE $PORT`
	STATUS_MOTOR=`echo $INIT_STATUT_MOTOR | awk ' {print $3 }'`
	echo "$datelog Motor Status : $STATUS_MOTOR 	[OK]" >> $LOGFILE
	echo "$STATUS_MOTOR" > $PID_MOTORRETURNVALUE	
}

# Function Update State Motor status 
# Update to PID_SPEEDRETURNVALUE file
function state_speed() {
	INIT_STATUT_SPEED=`timeout 1 $PATHMOTORDRIVE/status-speed.sh $DEVICE $PORT`
	STATUS_SPEED=`echo $INIT_STATUT_SPEED | awk ' {print $3 }'`
	echo "$datelog Motor Speed Status : $STATUS_SPEED [OK]" >> $LOGFILE
	echo "$STATUS_SPEED" > $PID_SPEEDRETURNVALUE	
}

# Function Update State Ballon test
# Update to PID_BVMRETURN file
function state_bvm() { 
	INIT_STATUT_BVM=`timeout 1 $PATHMOTORDRIVE/test-bvm.sh $DEVICE $PORT|grep PASSED`
	STATUS_BVM=`echo $INIT_STATUT_BVM | awk ' {print $3 }' | wc -l`
	if [ ${STATUS_BVM} -eq 1 ] ; then 
		echo "$datelog Motor Speed Status : $STATUS_BVM [OK]" >> $LOGFILE
		echo "PASSED" > $PID_BVMRETURN
	else
		echo "ERROR" > $PID_BVMRETURN		
		echo "$datelog BVM Not detected: $STATUS_BVM [WARNING]" >> $LOGFILE
	fi
}

# Check pre-processing Check First
# All precheck processing 
function check() {

	# Test is running 
	if [ -a $PID_PROCESS ]; then
		TESTPID=`ps ax | awk '{ print $7 }' | grep MOTOR | wc -l`
		if [ $TESTPID -lt 1 ]; then 
			echo "$datelog Motor Service running !!!! 		[STOPED]"
			exit 1
		fi
		echo "$datelog File lock present ... 			[Unlocking]"
		rm -rf $PID_PROCESS
	fi
	
	
	# Check Debug status
	if [ -z "${DEBUGSTATUS}" ]; then 
		DEBUGSTATUS=0
	fi
	if [ "${DEBUGSTATUS}" = "0" ]; then 
		LOGFILE = /dev/null
		echo "$datelog Starting log webservice DEBUG = 0	[OK]" >> $LOGFILE
	fi 		
	if [ "${DEBUGSTATUS}" = "1" ]; then 
		# Check logfile default value
		if [ "${LOGFILE}" = "" ]; then
				LOGFILE="/tmp/evo-motordrive.log"
		fi	
		echo "$datelog Starting log webservice DEBUG = 1	[OK]" >> $LOGFILE
	fi 	
	# Check device empty
	if [ "${DEVICE}" = "" ]; then
		echo "$datelog Device Not found Detected 			[ERROR]" >> $LOGFILE
		echo "$datelog Device Not found Detected 			[ERROR]"
		echo "$datelog STOP STOP STOP"		
		stopping
	fi
	
	# Check Valide IP 
#	if valid_ip $DEVICE; then
#		echo "$datelog IP Testing OK						[OK]" >> $LOGFILE
#	else 
#		# Stop not work bad IP
#		echo "$datelog BAD IP Detected for start server		[ERROR]" >> $LOGFILE
#		echo "$datelog BAD IP Detected for start server		[ERROR]"
#		echo "$datelog STOP STOP STOP"		
#		stopping
#	fi	
	
	# PORT
	if [ "${PORT}" = "" ]; then
		echo "$datelog PORT Not found Detected 				[ERROR]" >> $LOGFILE
		echo "$datelog PORT Not found Detected 				[ERROR]"
		echo "$datelog STOP STOP STOP"		
		stopping
	fi
	
	# Check PID LCD Service is started
	if [ -a $PID_LCD ]; then
		LCD_ORDER = "$PID_LCD"
		echo "$datelog Pid LCD Process Detected				[OK]" >> $LOGFILE
	else 
		LCD_ORDER = '/dev/null'
		echo "$datelog Pid LCD Process Not Detected			[WARNING]" >> $LOGFILE
	fi
	
	# Check PID MENU Service is started
	if [ -a $PID_MENU ]; then
		MENU_ORDRE = "$PID_MENU"
		echo "$datelog Pid LCD Process Detected				[OK]" >> $LOGFILE
	else 
		MENU_ORDRE = '/dev/null'
		echo "$datelog Pid MENU Process Not Detected		[WARNING]" >> $LOGFILE
	fi
	
	# Init Check status communication Motor Drive
	INIT_MOTOR=`timeout 1 $PATHMOTORDRIVE/status-motor.sh $DEVICE $PORT`
	STATUS_MOTOR=`echo $INIT_MOTOR | awk -F ':' ' {print $2 }'`	
	# Check Communication is working ?
	if [ ${STATUS_MOTOR} = "" ] ; then 
		echo "$datelog Return Status motor not found 		[ERROR]" >> $LOGFILE
		echo "$datelog Communication Motor Drive			[ERROR]"
		echo "$datelog STOP STOP STOP"		
		stopping
	fi
	# Init Communication is oK 
	# Update Value from stepper drive (state, speed and BVM test). 
	state_motor
	state_speed
	state_bvm
	# Ok Send signale starting service. 
	echo "STARTING" > $PID_PROCESS
	echo "$datelog Service starting							[Wait]" >> $LOGFILE
	starting
}

# Starting Loop Daemon Process
# Core loop
function starting() {
	while true; do 
		# Check Processing normaly rested processing detect motor drive is running or not. 
		CHECKSTARTING=`cat $PID_PROCESS`	
		if [ $CHECKSTARTING = "STARTING" ]; then
			# Detect Order Start Motor.
			state_motor
			CHECKMOTORSTATUS=`cat $PID_MOTORRETURNVALUE`
			if [ $CHECKMOTORSTATUS = "Stop" ]  ; then 
				echo "$datelog Motor Status is Stopped			[OK]" >> $LOGFILE
				echo "LCD_STOP" > $PID_LCD
				echo "START" > $PID_PROCESS
			elif [ $CHECKMOTORSTATUS = "Reverse" ]  ; then
				echo "$datelog Motor Status is Reverse Start	[OK]" >> $LOGFILE
				echo "START" > $PID_PROCESS
				update_lcdcycle
			elif [ $CHECKMOTORSTATUS = "Forward" ]  ; then
				echo "$datelog Motor Status is Forward Start	[OK]" >> $LOGFILE
				INIT_STATUT_SPEED=`timeout 1 $PATHMOTORDRIVE/status-speed.sh $DEVICE $PORT`
				STATUS_SPEED=`echo $INIT_STATUT_SPEED | awk ' {print $3 }'`
				echo "START" > $PID_PROCESS
				update_lcdcycle
			else
				echo "$datelog Motor Status not found !			[ERROR]" >> $LOGFILE
				echo "ERROR DRIVE STATUS" > $PIDMSG_LCD
				echo "LCD_ERROR" > $PID_LCD
				echo "STOP" > $PID_PROCESS
				stopping
			fi
		fi
		
		if [ $CHECKSTARTING = "START" ]; then
			SOCKETORDERMOTOR=`cat $SOCK_MOTORVALUE`
			MOTORRETURNVALUE=`cat $PID_MOTORRETURNVALUE`
			# Si ordre est différent de la valeur réel 
			if [ "${SOCKETORDERMOTOR}" != "${MOTORRETURNVALUE}" ] ; then 
				# Si Order est Forward 
				if [ "${SOCKETORDERMOTOR}" = "Forward" ] ; then 
					# Si Status est Stop vers Forward 
					if [ "${MOTORRETURNVALUE}" = "Stop" ] ; then
						echo "$datelog Motor Status is Stop go > Forward[OK]" >> $LOGFILE
						state_bvm
						STATUS_BVM=`cat $PID_BVMRETURN`
						if [ "${STATUS_BVM}" = "ERROR" ] ; then 
							echo "$datelog Motor Status is Stop go > Forward[ ERROR ]" >> $LOGFILE
							echo "ERROR BVM NOT FOUND" > $PIDMSG_LCD
							echo "LCD_ERROR" > $PID_LCD
							break
						fi	
						
						state_speed
						STATUS_SPEED=`cat $PID_SPEEDRETURNVALUE`						
						SPEEDORDER=`cat $SOCK_SPEEDVALUE`
						SpeedDiff = $(($STATUS_SPEED - $SPEEDORDER))
						if [ SpeedDiff != 0 ] ; then 
							if ! test "${SpeedDiff}" -gt 0 2> /dev/null ; then
								echo "$datelog Negative Speed		[OK]" >> $LOGFILE
								NumberOfDiff = $(($SpeedDiff / 5))
								COUNTER="$NumberOfDiff"
								# Construct order
								 while [  "${COUNTER}" -lt "${NumberOfDiff}" ]; do
									 timeout 1 $PATHMOTORDRIVE/push-downspeed.sh $DEVICE $PORT
									 let COUNTER-=1
								 done
								# Order is OK
								state_speed
								# Starting Motor 
								echo "$datelog $STATUS_SPEED > Starting Motor	[OK]" >> $LOGFILE
								timeout 2 $PATHMOTORDRIVE/start-forward.sh $DEVICE $PORT
								state_motor
								# Update LCD 
								update_lcdcycle
							else 
								echo "$datelog Positive Speed	[OK]" >> $LOGFILE
								NumberOfDiff = $(($SpeedDiff / 5))
								COUNTER="$NumberOfDiff"
								# Construct order
								while [  "${COUNTER}" -lt "${NumberOfDiff}" ]; do
									timeout 1 $PATHMOTORDRIVE/push-upspeed.sh $DEVICE $PORT
									let COUNTER-=1
								done
								# Order is OK
								state_speed
								echo "$datelog $STATUS_SPEED > Starting Motor [OK]" >> $LOGFILE
								timeout 2 $PATHMOTORDRIVE/start-forward.sh $DEVICE $PORT
								state_motor
								# Update LCD 
								update_lcdcycle					
							fi
							
						else
							state_bvm
							STATUS_BVM=`cat $PID_BVMRETURN`
							if [ "${STATUS_BVM}" = "ERROR" ] ; then 
								echo "$datelog Motor Status is Stop go > Forward[ ERROR ]" >> $LOGFILE
								echo "ERROR BVM NOT FOUND" > $PIDMSG_LCD
								echo "LCD_ERROR" > $PID_LCD
								break
							fi	
							# Same speed value order to status : 
							echo "$datelog Speed is same value 		[OK]" >> $LOGFILE
							state_speed	
							# Starting Motor 
							echo "$datelog $STATUS_SPEED > Starting Motor	[OK]" >> $LOGFILE
							timeout 2 $PATHMOTORDRIVE/start-forward.sh $DEVICE $PORT
							state_motor
							# Update LCD 
							update_lcdcycle							
						fi
					
					# Si status est Reverse vers Forward
					elif [ "${MOTORRETURNVALUE}" = "Reverse" ] ; then
						echo "$datelog Motor Status is Reverse go > Forward[OK]" >> $LOGFILE
						state_bvm
						STATUS_BVM=`cat $PID_BVMRETURN`
						if [ "${STATUS_BVM}" = "ERROR" ] ; then 
							echo "$datelog Motor Status is Stop go > Forward[ ERROR ]" >> $LOGFILE
							echo "ERROR BVM NOT FOUND" > $PIDMSG_LCD
							echo "LCD_ERROR" > $PID_LCD
							break
						fi	
						state_speed
						STATUS_SPEED=`cat $PID_SPEEDRETURNVALUE`						
						SPEEDORDER=`cat $SOCK_SPEEDVALUE`
						SpeedDiff=$(($STATUS_SPEED - $SPEEDORDER))
						timeout 2 $PATHMOTORDRIVE/stop.sh $DEVICE $PORT
						if [ SpeedDiff != 0 ] ; then 
							if ! test "${SpeedDiff}" -gt 0 2> /dev/null ; then
								echo "$datelog Negative Speed		[OK]" >> $LOGFILE
								NumberOfDiff = $(($SpeedDiff / 5))
								COUNTER="$NumberOfDiff"
								# Construct order
								 while [  "${COUNTER}" -lt "${NumberOfDiff}" ]; do
									 timeout 1 $PATHMOTORDRIVE/push-downspeed.sh $DEVICE $PORT
									 let COUNTER-=1
								 done
								# Order is OK
								state_speed
								# Starting Motor 
								echo "$datelog $STATUS_SPEED > Starting Motor	[OK]" >> $LOGFILE
								timeout 2 $PATHMOTORDRIVE/start-forward.sh $DEVICE $PORT
								state_motor
								# Update LCD 
								update_lcdcycle
							else 
								echo "$datelog Positive Speed	[OK]" >> $LOGFILE
								NumberOfDiff = $(($SpeedDiff / 5))
								COUNTER="$NumberOfDiff"
								# Construct order
								while [  "${COUNTER}" -lt "${NumberOfDiff}" ]; do
									timeout 1 $PATHMOTORDRIVE/push-upspeed.sh $DEVICE $PORT
									let COUNTER-=1
								done
								# Order is OK
								state_speed	
								# Starting Motor 
								echo "$datelog $STATUS_SPEED > Starting Motor [OK]" >> $LOGFILE
								timeout 2 $PATHMOTORDRIVE/start-forward.sh $DEVICE $PORT
								state_motor
								# Update LCD 
								update_lcdcycle						
							fi
						else							
							state_bvm
							STATUS_BVM=`cat $PID_BVMRETURN`
							if [ "${STATUS_BVM}" = "ERROR" ] ; then 
								echo "$datelog Motor Status is Stop go > Forward[ ERROR ]" >> $LOGFILE
								echo "ERROR BVM NOT FOUND" > $PIDMSG_LCD
								echo "LCD_ERROR" > $PID_LCD
								break
							fi								
							# Same speed value order to status : 
							echo "$datelog Speed is same value 		[OK]" >> $LOGFILE
							# Order is OK
							state_speed
							# Starting Motor 
							echo "$datelog $STATUS_SPEED > Starting Motor	[OK]" >> $LOGFILE
							timeout 2 $PATHMOTORDRIVE/start-forward.sh $DEVICE $PORT
							state_motor
							# Update LCD 
							update_lcdcycle							
						fi
					fi 
				fi

				# Si Ordre est Reverse 
				elif [ "${SOCKETORDERMOTOR}" = "Reverse" ] ; then 
					# Si Status est Stop vers Reverse 
					if [ "${MOTORRETURNVALUE}" = "Stop" ] ; then
						echo "$datelog Motor Status is Stop go > Reverse[OK]" >> $LOGFILE
						state_bvm
						STATUS_BVM=`cat $PID_BVMRETURN`
						if [ "${STATUS_BVM}" = "ERROR" ] ; then 
							echo "$datelog Motor Status is Stop go > Forward[ ERROR ]" >> $LOGFILE
							echo "ERROR BVM NOT FOUND" > $PIDMSG_LCD
							echo "LCD_ERROR" > $PID_LCD
							break
						fi								
					
						state_speed
						STATUS_SPEED=`cat $PID_SPEEDRETURNVALUE`						
						SPEEDORDER=`cat $SOCK_SPEEDVALUE`
						SpeedDiff = $(($STATUS_SPEED - $SPEEDORDER))
						if [ SpeedDiff != 0 ] ; then 
							if ! test "${SpeedDiff}" -gt 0 2> /dev/null ; then
								echo "$datelog Negative Speed		[OK]" >> $LOGFILE
								NumberOfDiff = $(($SpeedDiff / 5))
								COUNTER="$NumberOfDiff"
								# Construct order
								 while [  "${COUNTER}" -lt "${NumberOfDiff}" ]; do
									 timeout 1 $PATHMOTORDRIVE/push-downspeed.sh $DEVICE $PORT
									 let COUNTER-=1
								 done
								# Order is OK
								state_bvm
								STATUS_BVM=`cat $PID_BVMRETURN`
								if [ "${STATUS_BVM}" = "ERROR" ] ; then 
									echo "$datelog Motor Status is Stop go > Forward[ ERROR ]" >> $LOGFILE
									echo "ERROR BVM NOT FOUND" > $PIDMSG_LCD
									echo "LCD_ERROR" > $PID_LCD
									break
								fi								
							
								state_speed
								STATUS_SPEED=`cat $PID_SPEEDRETURNVALUE`						
								# Starting Motor 
								echo "$datelog $STATUS_SPEED > Starting Motor	[OK]" >> $LOGFILE
								timeout 2 $PATHMOTORDRIVE/start-reverse.sh $DEVICE $PORT
								state_motor
								# Update LCD 
								update_lcdcycle
							else 
								echo "$datelog Positive Speed	[OK]" >> $LOGFILE
								NumberOfDiff = $(($SpeedDiff / 5))
								COUNTER="$NumberOfDiff"
								# Construct order
								while [  "${COUNTER}" -lt "${NumberOfDiff}" ]; do
									timeout 1 $PATHMOTORDRIVE/push-upspeed.sh $DEVICE $PORT
									let COUNTER-=1
								done
								# Order is OK
								state_bvm
								STATUS_BVM=`cat $PID_BVMRETURN`
								if [ "${STATUS_BVM}" = "ERROR" ] ; then 
									echo "$datelog Motor Status is Stop go > Forward[ ERROR ]" >> $LOGFILE
									echo "ERROR BVM NOT FOUND" > $PIDMSG_LCD
									echo "LCD_ERROR" > $PID_LCD
									break
								fi								
							
								state_speed
								STATUS_SPEED=`cat $PID_SPEEDRETURNVALUE`	
								# Starting Motor 
								echo "$datelog $STATUS_SPEED > Starting Motor [OK]" >> $LOGFILE
								timeout 2 $PATHMOTORDRIVE/start-reverse.sh $DEVICE $PORT
								state_motor
								# Update LCD 
								update_lcdcycle						
							fi
							
						else
							# Same speed value order to status : 
							echo "$datelog Speed is same value 		[OK]" >> $LOGFILE
							# Order is OK
							state_bvm
							STATUS_BVM=`cat $PID_BVMRETURN`
							if [ "${STATUS_BVM}" = "ERROR" ] ; then 
								echo "$datelog Motor Status is Stop go > Forward[ ERROR ]" >> $LOGFILE
								echo "ERROR BVM NOT FOUND" > $PIDMSG_LCD
								echo "LCD_ERROR" > $PID_LCD
								break
							fi														
							state_speed
							STATUS_SPEED=`cat $PID_SPEEDRETURNVALUE`	
							# Starting Motor 
							echo "$datelog $STATUS_SPEED > Starting Motor	[OK]" >> $LOGFILE
							timeout 2 $PATHMOTORDRIVE/start-reverse.sh $DEVICE $PORT
							state_motor
							# Update LCD 
							update_lcdcycle								
						fi
					
					# Si status est Reverse vers Reverse
					elif [ "${MOTORRETURNVALUE}" = "Reverse" ] ; then
						echo "$datelog Motor Status is Reverse go > Reverse[OK]" >> $LOGFILE
						state_bvm
						STATUS_BVM=`cat $PID_BVMRETURN`
						if [ "${STATUS_BVM}" = "ERROR" ] ; then 
							echo "$datelog Motor Status is Stop go > Forward[ ERROR ]" >> $LOGFILE
							echo "ERROR BVM NOT FOUND" > $PIDMSG_LCD
							echo "LCD_ERROR" > $PID_LCD
							break
						fi								
				
						state_speed
						STATUS_SPEED=`cat $PID_SPEEDRETURNVALUE`						
						SPEEDORDER=`cat $SOCK_SPEEDVALUE`
						SpeedDiff = $(($STATUS_SPEED - $SPEEDORDER))
						timeout 2 $PATHMOTORDRIVE/stop.sh $DEVICE $PORT
						if [ SpeedDiff != 0 ] ; then 
							if ! test "${SpeedDiff}" -gt 0 2> /dev/null ; then
								echo "$datelog Negative Speed		[OK]" >> $LOGFILE
								NumberOfDiff = $(($SpeedDiff / 5))
								COUNTER="$NumberOfDiff"
								# Construct order
								 while [  "${COUNTER}" -lt "${NumberOfDiff}" ]; do
									 timeout 1 $PATHMOTORDRIVE/push-downspeed.sh $DEVICE $PORT
									 let COUNTER-=1
								 done
								# Order is OK
								state_speed
								STATUS_SPEED=`cat $PID_SPEEDRETURNVALUE`	
								# Starting Motor 
								echo "$datelog $STATUS_SPEED > Starting Motor	[OK]" >> $LOGFILE
								timeout 2 $PATHMOTORDRIVE/start-reverse.sh $DEVICE $PORT
								state_motor
								# Update LCD 
								update_lcdcycle
							else 
								echo "$datelog Positive Speed	[OK]" >> $LOGFILE
								NumberOfDiff = $(($SpeedDiff / 5))
								COUNTER="$NumberOfDiff"
								# Construct order
								while [  "${COUNTER}" -lt "${NumberOfDiff}" ]; do
									timeout 1 $PATHMOTORDRIVE/push-upspeed.sh $DEVICE $PORT
									let COUNTER-=1
								done
								# Order is OK
								state_bvm
								STATUS_BVM=`cat $PID_BVMRETURN`
								if [ "${STATUS_BVM}" = "ERROR" ] ; then 
									echo "$datelog Motor Status is Stop go > Forward[ ERROR ]" >> $LOGFILE
									echo "ERROR BVM NOT FOUND" > $PIDMSG_LCD
									echo "LCD_ERROR" > $PID_LCD
									break
								fi								
								state_speed
								STATUS_SPEED=`cat $PID_SPEEDRETURNVALUE`	
								# Starting Motor 
								echo "$datelog $STATUS_SPEED > Starting Motor [OK]" >> $LOGFILE
								timeout 2 $PATHMOTORDRIVE/start-reverse.sh $DEVICE $PORT
								state_motor
								# Update LCD 
								update_lcdcycle						
							fi
						else
							# Same speed value order to status : 
							echo "$datelog Speed is same value 		[OK]" >> $LOGFILE
							state_bvm
							STATUS_BVM=`cat $PID_BVMRETURN`
							if [ "${STATUS_BVM}" = "ERROR" ] ; then 
								echo "$datelog Motor Status is Stop go > Forward[ ERROR ]" >> $LOGFILE
								echo "ERROR BVM NOT FOUND" > $PIDMSG_LCD
								echo "LCD_ERROR" > $PID_LCD
								break
							fi								
							# Order is OK
							state_speed
							STATUS_SPEED=`cat $PID_SPEEDRETURNVALUE`	
							# Starting Motor 
							echo "$datelog $STATUS_SPEED > Starting Motor	[OK]" >> $LOGFILE
							timeout 2 $PATHMOTORDRIVE/start-reverse.sh $DEVICE $PORT
							state_motor
							# Update LCD 
							update_lcdcycle							
						fi
						
				# Si Ordre est Stop 
				elif [ "${SOCKETORDERMOTOR}" = "Stop" ] ; then
					# Same speed value order to status : 
					echo "$datelog Order is Stop 		[OK]" >> $LOGFILE
					# Order is OK
					state_speed
					STATUS_SPEED=`cat $PID_SPEEDRETURNVALUE`	
					# Starting Motor 
					echo "$datelog $STATUS_SPEED > Starting Motor	[OK]" >> $LOGFILE
					timeout 2 $PATHMOTORDRIVE/stop.sh $DEVICE $PORT
					state_motor
					# Update LCD 
					update_lcdcycle
				fi
			fi
			
			# Detect Orderngress speed or Degress speed. 
			state_speed
			STATUS_SPEED=`cat $PID_SPEEDRETURNVALUE`						
			SPEEDORDER=`cat $SOCK_SPEEDVALUE`
			state_bvm
			STATUS_BVM=`cat $PID_BVMRETURN`
			if [ "${STATUS_BVM}" = "ERROR" ] ; then 
				echo "$datelog Motor Status is Stop go > Forward[ ERROR ]" >> $LOGFILE
				echo "ERROR BVM NOT FOUND" > $PIDMSG_LCD
				echo "LCD_ERROR" > $PID_LCD
				break
			fi	
			if [ "${SOCKETORDERMOTOR}" != "${STATUS_SPEED}" ] ; then
				SpeedDiff = $(($STATUS_SPEED - $SPEEDORDER))
				if [ SpeedDiff != 0 ] ; then 
					if ! test "${SpeedDiff}" -gt 0 2> /dev/null ; then
						echo "$datelog Negative Speed		[OK]" >> $LOGFILE
						NumberOfDiff = $(($SpeedDiff / 5))
						COUNTER="$NumberOfDiff"
						# Construct order
						 while [  "${COUNTER}" -lt "${NumberOfDiff}" ]; do
							 timeout 1 $PATHMOTORDRIVE/push-downspeed.sh $DEVICE $PORT
							 let COUNTER-=1
						 done
						# Order is OK
						state_speed
						STATUS_SPEED=`cat $PID_SPEEDRETURNVALUE`	
						# Starting Motor 
						echo "$datelog $STATUS_SPEED > Starting Motor	[OK]" >> $LOGFILE
						state_motor
						# Update LCD 
						update_lcdcycle
					else 
						echo "$datelog Positive Speed	[OK]" >> $LOGFILE
						NumberOfDiff = $(($SpeedDiff / 5))
						COUNTER="$NumberOfDiff"
						# Construct order
						while [  "${COUNTER}" -lt "${NumberOfDiff}" ]; do
							timeout 1 $PATHMOTORDRIVE/push-upspeed.sh $DEVICE $PORT
							let COUNTER-=1
						done
						# Order is OK
						state_speed
						STATUS_SPEED=`cat $PID_SPEEDRETURNVALUE`	
						# Starting Motor 
						echo "$datelog $STATUS_SPEED > Starting Motor [OK]" >> $LOGFILE
						state_motor
						# Update LCD 
						update_lcdcycle							
					fi								
				fi	
			fi
		fi
		
		
		
		# Order Deamon Stop
		if [ $CHECKSTARTING = "STOP" ]; then 
			echo "$datelog PID Order stop Deamon			 	[STOPING]"
			state_motor
			state_speed
			state_bvm
			update_lcdcycle
			stopping
		fi
		
		# Order Deamon Stop
		if [ $CHECKSTARTING = "RELOAD" ]; then 
			echo "$datelog PID Order Reload Deamon			 	[RELOAD]"
			state_motor
			state_speed
			state_bvm
			update_lcdcycle
			stopping
		fi		
		
		# sleep $SLEEPLOOPDEBUG
	done

}

# Stoping Deamon Server Process.
# Post-Processing Order stop daemon. 
function stopping() {
	rm -rf $PID_PROCESS='/tmp/evo-motordrive.pid'
	rm -rf $PID_SPEEDRETURNVALUE='/tmp/evo-motordrive_returnspeed.pid'
	rm -rf $PID_MOTORRETURNVALUE='/tmp/evo-motordrive_returnmotor.pid'
	rm -rf $SOCK_SPEEDVALUE='/tmp/evo-motordrive_returnspeed.sock'
	rm -rf $SOCK_MOTORVALUE='/tmp/evo-motordrive_returnmotor.sock'	
	echo "$datelog Stoped Motor service	 		[STOP]" >> $LOGFILE
	echo "$datelog Stoped Motor service	 		[STOP]"
	exit 0
}

# Stoping Deamon Server Process.
# Reload process 
function reload() {
	rm -rf $PID_PROCESS='/tmp/evo-motordrive.pid'
	rm -rf $PID_SPEEDRETURNVALUE='/tmp/evo-motordrive_returnspeed.pid'
	rm -rf $PID_MOTORRETURNVALUE='/tmp/evo-motordrive_returnmotor.pid'
	echo "$datelog Service LCD reloaded !"	
	check
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
                    exit 1
                    ;;
        esac
        shift
done
check
echo "Unknow Error running"
exit 1

