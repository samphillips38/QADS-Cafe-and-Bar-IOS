//www.elegoo.com
//2016.12.08

int buzzer = 12;//the pin of the active buzzer
int buttonA = 9;
int buttonB = 8;
void setup()
{
 pinMode(buzzer,OUTPUT);//initialize the buzzer pin as an output
 pinMode(buttonA, INPUT_PULLUP);
 pinMode(buttonB, INPUT_PULLUP);
}
void loop()
{
 if(digitalRead(buttonA) == LOW)
 {
  digitalWrite(buzzer, HIGH);
 }
 if(digitalRead(buttonB) == LOW)
 {
  digitalWrite(buzzer, LOW);
 }
} 
