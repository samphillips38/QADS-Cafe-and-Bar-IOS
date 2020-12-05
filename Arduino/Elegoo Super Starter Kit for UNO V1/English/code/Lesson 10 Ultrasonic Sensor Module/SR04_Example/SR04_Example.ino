//www.elegoo.com
//2016.12.08
#include "SR04.h"
#define TRIG_PIN 12
#define ECHO_PIN 11
SR04 sr04 = SR04(ECHO_PIN,TRIG_PIN);
long a;

void setup() {
  pinMode(4, OUTPUT);
   Serial.begin(9600);
   delay(1000);
}

void loop() {
   a=sr04.Distance();
   Serial.print(a);
   Serial.println("cm");
   delay(10);

   if(a < 20)
   {
    digitalWrite(4, HIGH);
   }
   if(a > 20)
   {
    digitalWrite(4, LOW);
   }
}
