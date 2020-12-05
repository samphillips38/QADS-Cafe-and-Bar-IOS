#include <Stepper.h>

const int stepsPerRevolution = 2048;  // change this to fit the number of steps per revolution
const int rolePerMinute = 15;         // Adjustable range of 28BYJ-48 stepper is 0~17 rpm

// initialize the stepper library on pins 8 through 11:
Stepper myStepper(stepsPerRevolution, 8, 10, 9, 11);

const int SW_pin = 2; // digital pin connected to switch output
const int X_pin = A0; // analog pin connected to X output
const int Y_pin = A1; // analog pin connected to Y output

void setup() {
  myStepper.setSpeed(rolePerMinute);
  pinMode(SW_pin, INPUT);
  digitalWrite(SW_pin, HIGH);
  
  // initialize the serial port:
  Serial.begin(9600);
  // put your setup code here, to run once:

}

void loop() {

  if ( analogRead(X_pin) > 550) {
    myStepper.step(1);
    Serial.print(analogRead(X_pin));
    Serial.print("\n");
  }

if (analogRead(X_pin) < 450) {
  myStepper.step(-1);
  Serial.print(analogRead(X_pin));
  Serial.print("\n");

}
  
  // put your main code here, to run repeatedly:

}
