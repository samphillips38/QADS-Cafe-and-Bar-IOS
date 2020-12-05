#define rmotor 3
#define lmotor 6
#define tmotor 5
#define servo 9
#include <Servo.h>
#include "IRremote.h"

int receiver = 11;
IRrecv irrecv(receiver);
decode_results results;

Servo myservo;

int servo_pos = 90;


int r = 255;
int l = 255;
int t = 255;

void setup() {
  // put your setup code here, to run once:
  pinMode(lmotor, OUTPUT);
  pinMode(rmotor, OUTPUT);
  pinMode(tmotor, OUTPUT);
  Serial.begin(9600);
  digitalWrite(rmotor, LOW);
  digitalWrite(lmotor, LOW);
  digitalWrite(tmotor, LOW);
  myservo.attach(9);
  irrecv.enableIRIn();
  
}


void serialCommand(char command)
{
  
  switch(command)
  {
    case 'l':
      l = l - 10;
      analogWrite(lmotor, l);
      Serial.print("l =");
      Serial.println(l);
      break;

    case 'r':
      r = r - 10;
      analogWrite(rmotor, r);
      Serial.print("r =");
      Serial.println(r);
      break;

    case 't':
      t = t - 10;
      analogWrite(tmotor, t);
      Serial.print("t =");
      Serial.println(t);
      break;

    case 'b':
      myservo.write(180);
      Serial.println("servo at 180");
      break;

     case 'a':
      servo_pos -= 1;
      myservo.write(servo_pos);
      Serial.print("Servo at:  ");
      Serial.println(servo_pos);
      break;

     case 's':
        for (int i = 79; i > 10; i--) {
    myservo.write(i);
    delay(1);
  }

  for (int j = 10; j < 79; j++) {
    myservo.write(j);
    delay(10);
  }
      break;
    
    //Ignore unrecognised characters
    default:
      return;
  }
  
}

void loop() {
  // put your main code here, to run repeatedly:

 serialCommand(Serial.read());

}
