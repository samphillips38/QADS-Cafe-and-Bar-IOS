//www.elegoo.com
//2016.12.08
/*****************************************/
const int ledPin = 13;//the led attach to
int led = 8;

void setup()
{ 
  pinMode(ledPin,OUTPUT);//initialize the ledPin as an output
  pinMode(2,INPUT);
  pinMode(led, OUTPUT);
  digitalWrite(2, HIGH);
} 
/******************************************/
void loop() 
{  
  int digitalVal = digitalRead(2);
  if(HIGH == digitalVal)
  {
    digitalWrite(led, HIGH);
    digitalWrite(ledPin,LOW);//turn the led off
  }
  else
  {
    digitalWrite(led, LOW);
    digitalWrite(ledPin,HIGH);//turn the led on 
  }
}
/**********************************************/
