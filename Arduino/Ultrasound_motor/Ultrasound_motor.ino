
#define ENABLE 5
#define DIRA 3
#define DIRB 4
#include "SR04.h"
#define TRIG_PIN 12
#define ECHO_PIN 11
SR04 sr04 = SR04(ECHO_PIN,TRIG_PIN);

long a;

int i;

void setup() {
  // put your setup code here, to run once:
   pinMode(ENABLE,OUTPUT);
   pinMode(DIRA,OUTPUT);
   pinMode(DIRB,OUTPUT);
   pinMode(4, OUTPUT);
   Serial.begin(9600);
   delay(1000);
   analogWrite(ENABLE,0);
   digitalWrite(DIRA,HIGH);
   digitalWrite(DIRB,LOW);

 
}

void loop() {
  // put your main code here, to run repeatedly:
  // Find the distance
   a=sr04.Distance();
   Serial.print(a);
   Serial.println("cm");
   delay(100);

   if(a < 25)
   {
    analogWrite(ENABLE,a*10);
    digitalWrite(DIRA,HIGH);
    digitalWrite(DIRB,LOW);
   }
   if(a > 25)
   {
    analogWrite(ENABLE,255);
    digitalWrite(DIRA,HIGH);
    digitalWrite(DIRB,LOW);
   }

   
}
