/*
 * EvoCyclone FW Motor Drive
 * #Resistancecovid.com
 *  https://github.com/libre/evocyclone
 *  https://github.com/libre/evocyclone-motordrive
 *  Author : said.deraoui@gmail.com
 *
 * All RESISTANCECOVID code is released under the GNU General Public License.
 * See COPYRIGHT.txt and LICENSE.txt.
 *
 * Version 0.1.4
 *
 *   ROADMAP Inprogress Coming soon : 0.1.X :
 *              + Intégration potentiomètre
 *              + Add Jumper pour master mode et slave mode.
 *              + Add led intensité speed.
 *              + Add bouton Start/stop
 *
 *   Track Version
 *   0.1.4 :
 *      + Remplacement capteur HCR04 par IR LM393
 *      + Debug detect absence in use.
 *   0.1.2 :
 *      + HC-SR04
 *              + Add routine stop motor to not detect ballon.
 *      + Routin Led is power ON not detect ballon.
 *              + Add Jumpter for disable the sensor.
 *   0.1.1 :
 *      + Update code and defaut speed.
 *   0.1.0 Inital version
 *
 */

int run;
unsigned long run_tmr;
unsigned long run_cycle;
unsigned long val;
char cmd;
int bavu;
int speed;
int old_0;
int Vers = '0.1.4';
/*
* Constantes LedAlert
*/

int LedAlertPin = 12;

/*
* Constantes Switch Sensor disabled
*/
int SwitchOut = 2;
int SwitchIN = 3;
int result = 0;
int result2 = 0;
int valuetest = 0;
int JumperStatus = 0;
int DebugMode = 1;

/*
* Constantes pin Capteur LM
*/
int PinCapteurBavu = 10;

/*
* Constantes pour moteur A et B
*/

#define BRAKE 0
#define CW    1
#define CCW   2
#define CS_THRESHOLD 15   // Definition of safety current (Check: "1.3 Monster Shield Example").

//MOTOR 1
#define MOTOR_A1_PIN 7
#define MOTOR_B1_PIN 8

//MOTOR 2
#define MOTOR_A2_PIN 4
#define MOTOR_B2_PIN 9

//Define Motor Sensors
#define PWM_MOTOR_1 5
#define PWM_MOTOR_2 6
#define CURRENT_SEN_1 A2
#define CURRENT_SEN_2 A3
#define EN_PIN_1 A0
#define EN_PIN_2 A1
#define MOTOR_1 0
#define MOTOR_2 1

short usSpeed = 70;  //default motor speed
unsigned short usMotor_Status = BRAKE;

/* Led Alert Off */
void LedAlertOff(){
        digitalWrite(LedAlertPin, LOW);
}

/* Led Alert On */
void LedAlertOn(){
        digitalWrite(LedAlertPin, HIGH);
}

/* Led Alert Test */
void TestLed(){
   for (int i=0; i <= 10; i++){
                digitalWrite(LedAlertPin, HIGH);
                delay(500);
                digitalWrite(LedAlertPin, LOW);
   }
        digitalWrite(LedAlertPin, LOW);
}

/* Print Serial Speed */
void PrintSpeed() {
  Serial.print("Speed : ");
  Serial.println(usSpeed);
}

/* Test Sensor Serial Debug */
void TestSensor() {
  bool val = digitalRead (PinCapteurBavu) ; // Lecture de la valeur du signal
  if (val == HIGH) {
    Serial.println("BVM not detected            [FAILD]");
  }
  else
  {
    Serial.println("BVM detected                [PASSED]");
  }
  Serial.println("------------------------------------");
  delay(500); // pause de 500ms entre les mesures
}

/* IncreaseSpeed */
void IncreaseSpeed(){
  usSpeed = usSpeed + 5;
  if(usSpeed > 255)
  {
    usSpeed = 255;
  }
  if (DebugMode == 2) {
         Serial.println("Increase Speed");
  }
  motorGo(MOTOR_1, usMotor_Status, usSpeed);
  motorGo(MOTOR_2, usMotor_Status, usSpeed);
}

/* DecreaseSpeed */
void DecreaseSpeed(){
  usSpeed = usSpeed - 5;
  if(usSpeed < 0)
  {
    usSpeed = 0;
  }
  motorGo(MOTOR_1, usMotor_Status, usSpeed);
  motorGo(MOTOR_2, usMotor_Status, usSpeed);
  if (DebugMode == 2) {
         Serial.println("Decrease Speed");
  }
}

/* Print version */
void Version() {
  Serial.println("EvoCyclone FW Motor Drive");
  Serial.println(); //Print function list for user selection
  Serial.print("Version");
  Serial.println(Vers);
  Serial.println("Author : Saïd Deraoui");
  Serial.println("Author : Thierry Moréa");
  Serial.println("Contributor : Vapula");
  Serial.println("");
  Serial.println("RESISTANCECOVID.COM");
  Serial.println("EUVSVIRUS.ORG");
  Serial.println("------------------------------------");
}

/* Print Debug Serial */
void ActiveDebug() {
  if (DebugMode == 1) {
        DebugMode = 2;
        Serial.println("DEBUG MODE      [ENABLED]");
  } else {
        DebugMode = 1;
        Serial.println("DEBUG MODE      [DISABLE]");
  }
}

/* Print Help */
void Help() {
  Serial.println("Invalid option entered.");
  Serial.println(); //Print function list for user selection
  Serial.println("Enter number for control option:");
  Serial.println("S. STOP");
  Serial.println("F. FORWARD");
  Serial.println("R. REVERSE");
  Serial.println("C. READ CURRENT");
  Serial.println("D. ENABLE/DISABLE DEBUG SERIAL");
  Serial.println("+. INCREASE SPEED");
  Serial.println("-. DECREASE SPEED");
  Serial.println("H. THE HELP");
  Serial.println("V. FW VERSION");
  Serial.println("L. TEST ALERT LED");
  Serial.println("T. TEST BALLON SENSOR");
  Serial.println("M. CURRENT STATUS MOTOR");  
  Serial.println("------------------------------------");
}

/* Default Init Setup starting */
void setup(){

  /* Initialise Jumper switch */
  pinMode(SwitchOut, OUTPUT);
  pinMode(SwitchIN, INPUT);

  /* Initialise Led Alert */
  pinMode(LedAlertPin, OUTPUT);

  // Setup Motor
  pinMode(MOTOR_A1_PIN, OUTPUT);
  pinMode(MOTOR_B1_PIN, OUTPUT);
  pinMode(MOTOR_A2_PIN, OUTPUT);
  pinMode(MOTOR_B2_PIN, OUTPUT);
  pinMode(PWM_MOTOR_1, OUTPUT);
  pinMode(PWM_MOTOR_2, OUTPUT);
  pinMode(CURRENT_SEN_1, OUTPUT);
  pinMode(CURRENT_SEN_2, OUTPUT);
  pinMode(EN_PIN_1, OUTPUT);
  pinMode(EN_PIN_2, OUTPUT);
  pinMode(PinCapteurBavu,INPUT);
  /* Check Jumper*/
  if ( SwitchIN == LOW ) {
        JumperStatus = 1;
        /* init Presence Bavu */
        if (digitalRead(PinCapteurBavu) == HIGH) { /* Bavu present */
                        bavu=1;
                        LedAlertOn();
                } else {
                        bavu=2;
                        LedAlertOff();
                }
        }
  Serial.begin(9600);
}

/* Default Loop */
void loop(){
  int ser;
  digitalWrite(EN_PIN_1, HIGH);
  digitalWrite(EN_PIN_2, HIGH);
  /* Test si capteur actif sur jumper */
  /* Test Catpeur */
  if (digitalRead(PinCapteurBavu) == HIGH) { /* Bavu present */
          bavu=1;
          LedAlertOn();
          Stop();
        } else {
           if(run != 0) {
                 bavu=2;
                 if(run != 1) {
                      usMotor_Status = CCW;
                      motorGo(MOTOR_1, usMotor_Status, usSpeed);
                      motorGo(MOTOR_2, usMotor_Status, usSpeed);
                 } else {
                      usMotor_Status = CW;
                      motorGo(MOTOR_1, usMotor_Status, usSpeed);
                      motorGo(MOTOR_2, usMotor_Status, usSpeed);
                 }
                 LedAlertOff();
            } else {
               bavu=2;
               LedAlertOff();
            }

        }
  if (Serial.available()) {
    ser=Serial.read();
    switch(ser) {
      case 'F': /* Forward */
                /* Test Catpeur */
          if (digitalRead(PinCapteurBavu) == HIGH) { /* Bavu present */
            if (DebugMode == 2) {
                Serial.println("ERROR Forward");
            }
            bavu=1;
            LedAlertOn();
            Stop();
          } else {
            bavu=2;
            run=1;
            LedAlertOff();
            usMotor_Status = CW;
            motorGo(MOTOR_1, usMotor_Status, usSpeed);
            motorGo(MOTOR_2, usMotor_Status, usSpeed);
            if (DebugMode == 2) {
              Serial.println("Forward Passed");
            }
          }
          break;
      case '+': /* IncreaseSpeed */
                IncreaseSpeed();
                break;
      case '-': /* DecreaseSpeed */
                DecreaseSpeed();
                break;
          case 'H': /* Help */
                Help();
                break;
          case 'R': /* Rervers */
            /* Test Catpeur */
            if (digitalRead(PinCapteurBavu) == HIGH) { /* Bavu present */
                      if (DebugMode == 2) {
                        Serial.println("ERROR Reverse");
                      }
                      bavu=1;
                      LedAlertOn();
                      Stop();
            } else {
                bavu=2;
                run=2;
                LedAlertOff();
                usMotor_Status = CCW;
                motorGo(MOTOR_1, usMotor_Status, usSpeed);
                motorGo(MOTOR_2, usMotor_Status, usSpeed);
                if (DebugMode == 2) {
                        Serial.println("Reverse Passed");
                }
            }
          break;
                Reverse();
                break;
          case 'T': /* Test Sensor */
                TestSensor();
                break;
          case 'V': /* FW Info */
                Version();
                break;
          case 'L': /* Test Led */
                TestLed();
                break;
          case 'D': /* Active Debug */
                ActiveDebug();
                break;
          case 'S': /* Stop Motor*/
				run=0;
                if (DebugMode == 2) {
                  Serial.println("Stop Motor");
                }
                usMotor_Status = BRAKE;
                motorGo(MOTOR_1, usMotor_Status, 0);
                motorGo(MOTOR_2, usMotor_Status, 0);
                break;
          case 'C': /* Current Speed */
                PrintSpeed();
                break;
          case 'M': /* Current Motor status */
				if (run == 2) {
					Serial.println("Status:Reverse");
				} 
				if (run == 1) {
					Serial.println("Status:Forward");
				} else { 
					Serial.println("Status:Stop");
				}
				
				
                PrintSpeed();
                break;
		  case '1':
        break;
      case '2':
        break;
      case '3':
                break;
      case '4':
                break;
      case '5':
                break;
      case '6':
                break;
      case '7':
                break;
      case '8':
                break;
      case '9':
                break;
    }
  }
  delay(10); // Delay a little bit to improve simulation performance
}

/* Stop Motor */
void Stop() {
        if (DebugMode == 2) {
          Serial.println("Stop Motor");
        }
        usMotor_Status = BRAKE;
        motorGo(MOTOR_1, usMotor_Status, 0);
        motorGo(MOTOR_2, usMotor_Status, 0);
}

/* Start Motor Forward */
void Forward() {
  usMotor_Status = CW;
  motorGo(MOTOR_1, usMotor_Status, usSpeed);
  motorGo(MOTOR_2, usMotor_Status, usSpeed);
}

/* Start Motor Reverse */
void Reverse(){
  usMotor_Status = CCW;
  motorGo(MOTOR_1, usMotor_Status, usSpeed);
  motorGo(MOTOR_2, usMotor_Status, usSpeed);
}

/* Command control motor */
void motorGo(uint8_t motor, uint8_t direct, uint8_t pwm) {
  if(motor == MOTOR_1)
  {
    if(direct == CW)
    {
      digitalWrite(MOTOR_A1_PIN, LOW);
      digitalWrite(MOTOR_B1_PIN, HIGH);
    }
    else if(direct == CCW)
    {
      digitalWrite(MOTOR_A1_PIN, HIGH);
      digitalWrite(MOTOR_B1_PIN, LOW);
    }
    else
    {
      digitalWrite(MOTOR_A1_PIN, LOW);
      digitalWrite(MOTOR_B1_PIN, LOW);
    }

    analogWrite(PWM_MOTOR_1, pwm);
  }
  else if(motor == MOTOR_2)
  {
    if(direct == CW)
    {
      digitalWrite(MOTOR_A2_PIN, LOW);
      digitalWrite(MOTOR_B2_PIN, HIGH);
    }
    else if(direct == CCW)
    {
      digitalWrite(MOTOR_A2_PIN, HIGH);
      digitalWrite(MOTOR_B2_PIN, LOW);
    }
    else
    {
      digitalWrite(MOTOR_A2_PIN, LOW);
      digitalWrite(MOTOR_B2_PIN, LOW);
    }

    analogWrite(PWM_MOTOR_2, pwm);
  }
}

