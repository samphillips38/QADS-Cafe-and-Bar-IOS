#define ENABLE 5
#define DIRA 3
#define DIRB 4

int i;


void setup() {
  // put your setup code here, to run once:
  pinMode(ENABLE,OUTPUT);
  pinMode(DIRA,OUTPUT);
  pinMode(DIRB,OUTPUT);
  pinMode(2, INPUT);
  digitalWrite(2, HIGH);
  Serial.begin(9600);

}

void loop() {
  if(HIGH == digitalRead(2))
  {
    digitalWrite(ENABLE, HIGH);
    digitalWrite(DIRA,HIGH); //one way
    digitalWrite(DIRB,LOW);
  }

  if(LOW == digitalRead(2))
  {
    digitalWrite(ENABLE, LOW);
    digitalWrite(DIRA,LOW); //one way
    digitalWrite(DIRB,HIGH);
  }

  // put your main code here, to run repeatedly:

}
