//Server Set up
#define gun_servo_pin 9
#define sweep_servo_pin 10
#include <Servo.h>
Servo gun_servo;
Servo sweep_servo;

//Ultrasonic sensor set up
#include "SR04.h"
#define TRIG_PIN 12
#define ECHO_PIN 11
SR04 sr04 = SR04(ECHO_PIN, TRIG_PIN);
long dist;
int averaged_dist = 0;
int dist_counter = 0;

int gun_servo_pos = 0;
int sweep_servo_pos = 0;
bool boris_happy = true;

void setup() {
  // put your setup code here, to run once:
  gun_servo.attach(gun_servo_pin);
  sweep_servo.attach(sweep_servo_pin);
  pinMode(gun_servo_pin, OUTPUT);
  pinMode(sweep_servo_pin, OUTPUT);
  pinMode(2, OUTPUT);
  digitalWrite(2, HIGH);
  Serial.begin(9600);
  delay(100);
}

void shoot() {

  for (int i = 79; i > 10; i--) {
    gun_servo.write(i);
    delay(1);
  }

  for (int j = 10; j < 79; j++) {
    gun_servo.write(j);
    delay(10);
  }


}



void loop() {
  // put your main code here, to run repeatedly:
  dist=sr04.Distance();
  
  averaged_dist = (averaged_dist*5 + dist)/6;


  if (averaged_dist < 150) {
    dist_counter += 1;
  }
  else {
    dist_counter = 0;
  }


  if (dist_counter == 5) {
    boris_happy = false;
    dist_counter = 0;
  }
  
  //update sweep servo if needed
  if ((boris_happy == true) && (dist_counter == 0)) {
    sweep_servo_pos += 1;
    if (sweep_servo_pos == 90) {
      sweep_servo_pos = -90;
    }
    sweep_servo.write(abs(sweep_servo_pos) + 50);
  }
  
  else if (boris_happy == false) {
    shoot();
    Serial.println("Dead");
    boris_happy = true;
  }
 

  delay(10);
}
