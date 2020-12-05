#include <Servo.h>
#include <Stepper.h>

Servo myservo;  // create servo object to control a servo
// twelve servo objects can be created on most boards

int pos = 0;    // variable to store the servo position
const int X_pin = A0; // analog pin connected to X output
const int Y_pin = A1; // analog pin connected to Y output
const int stepsPerRevolution = 2048;  // change this to fit the number of steps per revolution
const int rolePerMinute = 15;         // Adjustable range of 28BYJ-48 stepper is 0~17 rpm

// initialize the stepper library on pins 8 through 11:
Stepper myStepper(stepsPerRevolution, 8, 10, 6, 11);

void setup() {
  myStepper.setSpeed(rolePerMinute);
  pinMode(4, INPUT);
  digitalWrite(4, HIGH);
  Serial.begin(9600);
  myservo.attach(9);  // attaches the servo on pin 9 to the servo object
}

void loop() {
  int digitalVal = digitalRead(4);
  if(HIGH == digitalVal)
  {
    if(analogRead(Y_pin) > 750)
    {
      myservo.write(myservo.read() - 1);
      delay(20);
    }

    if(analogRead(Y_pin) < 250)
    {
      myservo.write(myservo.read() + 1);
      delay(20);
    }
  }

  if(analogRead(X_pin) < 250)
  {
    myStepper.step(10);
    delay(10);
  }

  if(analogRead(X_pin) > 750)
  {
    myStepper.step(-10);
    delay(10);
  }
}
