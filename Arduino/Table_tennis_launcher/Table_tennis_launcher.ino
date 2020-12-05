//Initialise pins
#define rmotor 11
#define lmotor 6
#define tmotor 5
#define feed_servo_pin 9
#define sweep_servo_pin 10
#define receiver 3

//Initialise Servo
#include <Servo.h>
Servo feed_servo;
Servo sweep_servo;

//Initialise IR Reciever
#include "IRremote.h"
#include "IRremoteInt.h"
IRrecv irrecv(receiver);
decode_results results; 

//Initialise servo position and aim
int feed_pos = 180;
int sweep_aim = 90;

//Initialise motor speeds
int rval = 0;
int lval = 0;
int tval = 0;

//Initialise settings
bool idle = true;
int timestep = 20;
int spin_setting = 5; // 1 = top, 2 = back, 3 = right, 4 = left, 5 = power, 6 = random

void setup() {
  // Initialise Pins
  feed_servo.attach(feed_servo_pin);
  sweep_servo.attach(sweep_servo_pin);
  pinMode(rmotor, OUTPUT);
  pinMode(lmotor, OUTPUT);
  pinMode(tmotor, OUTPUT);
  pinMode(feed_servo_pin, OUTPUT);
  pinMode(sweep_servo_pin, OUTPUT);
  irrecv.enableIRIn(); // Start the receiver
  Serial.begin(9600);

  //Initialise motor settings
  digitalWrite(rmotor, LOW);
  digitalWrite(lmotor, LOW);
  digitalWrite(tmotor, LOW);

}

//Function Sets the motors depending on the input spin setting
void setmotor(int spin) {

  lval = rval = tval = 245;

  if (spin == 6) { //Randomise spin
    spin = random(1, 6);
  }

  if (spin == 1) { //Top spin
    rval = lval = 200;
  }

  else if (spin == 2) { //Back spin
    tval = 120;
  }

  else if (spin == 3) { //Right spin
    rval = 120;
  }
  
  else if (spin == 4) { //Left spin
    lval = 120;
  }

  else if (spin == 5) { //Power
  }

  analogWrite(rmotor, 255); //Allows the system to run with ir module as pin 3 and 11 pwm is disabled
  analogWrite(lmotor, lval);
  analogWrite(tmotor, tval);
}

//Deal with received signal
void translateIR() {

  if (irrecv.decode(&results)) {
  
    switch(results.value)
  
    {
    case 0xFFA25D: //Power Button pressed
      idle = !idle;
      break;

    case 0xFF629D: //Vol+ button pressed
      spin_setting = 1; //Top spin
      break;

    case 0xFFA857: //Vol- button pressed
      spin_setting = 2; //Back spin
      break;
  
    case 0xFF22DD: //FAST BACK button pressed
      spin_setting = 3; //Right spin
      break;

    case 0xFFC23D: //FAST FORWARD button pressed
      spin_setting = 4; //Left spin
      break;

    case 0xFF02FD: //PAUSE button pressed
      spin_setting = 5; //Power
      break;
      
    case 0xFFE21D: //FUNC/STOP button pressed
      spin_setting = 6; //Random
      break;

    case 0xFFE01F: //DOWN button pressed
      timestep += 1;  
      timestep = constrain(timestep, 0, 50);  
      break;

    case 0xFF906F: //UP button pressed
      timestep -= 1;
      timestep = constrain(timestep, 0, 50); 
      break;

    case 0xFF9867: //EG button pressed
      //reset all values
      timestep = 20;
      spin_setting = 6;
      feed_servo.write(180); 
    break;

    case 0xFF6897: //0 button pressed
      sweep_servo.write(sweep_servo.read() + 10);    
      break;
      
    case 0xFF30CF: //1 button pressed
      sweep_servo.write(sweep_servo.read() - 10);
      break;


//    case 0xFFB04F: Serial.println("ST/REPT");    break;
//    case 0xFF18E7: Serial.println("2");    break;
//    case 0xFF7A85: Serial.println("3");    break;
//    case 0xFF10EF: Serial.println("4");    break;
//    case 0xFF38C7: Serial.println("5");    break;
//    case 0xFF5AA5: Serial.println("6");    break;
//    case 0xFF42BD: Serial.println("7");    break;
//    case 0xFF4AB5: Serial.println("8");    break;
//    case 0xFF52AD: Serial.println("9");    break;
//    case 0xFFFFFFFF: Serial.println(" REPEAT");break;  
  
    default: 
      Serial.println("other button");
  
    }// End Case
  
    delay(50); // Do not get immediate repeat

    irrecv.resume();

  }

  else {
  }
  
}

void loop() {

  //Read for IR signals
  translateIR();

  if (idle == false) {

    //Update Feeder servo position
    if (feed_pos == 180) {
      feed_pos = -180;
    }
   
    feed_servo.write(abs(feed_pos));
    feed_pos += 1;

    //Update Sweep servo position
    if (feed_pos == 180) {
      sweep_aim = random(81, 115);
    }
    
    if (sweep_aim > sweep_servo.read()) {
      sweep_servo.write(sweep_servo.read() + 1);
    }
    else if (sweep_aim < sweep_servo.read()) {
      sweep_servo.write(sweep_servo.read() - 1);
    }


    //Set the motors
    if (feed_pos == constrain(timestep - 140, -179, 180)) {
      setmotor(spin_setting);
    }
    else if (feed_pos == 0) {
      digitalWrite(rmotor, LOW);
      digitalWrite(lmotor, LOW);
      digitalWrite(tmotor, LOW);
    }

    //Wait for all to update
    delay(timestep);
    
  }
  else {
    digitalWrite(rmotor, LOW);
    digitalWrite(lmotor, LOW);
    digitalWrite(tmotor, LOW);
  }
}
