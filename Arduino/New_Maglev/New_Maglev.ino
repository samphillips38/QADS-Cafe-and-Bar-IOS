
// Good vals = target = 918, kp = 0.95 the rest 0

#define default_target_val 820
#define default_kp 0.8
#define default_kd 3 //normally23.7
#define default_ki 0.000

#define target_val_increment 1
#define kp_increment 0.1
#define kd_increment 0.1
#define ki_increment 0.0001

#define hall_filter 5 //this is the number fo points considered in running average.
#define pwm_update_period 10 //This is the time in ms between updates of the pwm. Below 3 is max speed but may be unstable.
#define MAGNET_CHARACTERISTIC[] = {0.0, 0.0, -0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.6, 0.7, 1.0, 1.5, 1.5, 1.7, 2.0, 2.5, 3.0, 3.5, 4.0, 4.6, 5.1, 5.5, 6.0, 6.6, 7.1, 7.5, 8.2, 8.5, 9.2, 9.7, 10.1, 10.6, 11.5, 11.7, 12.5, 12.9, 13.5, 14.0, 14.5, 15.0, 15.5, 16.0, 16.7, 17.5, 18.0, 18.5, 19.0, 19.5, 20.0, 20.5, 21.0, 21.5, 22.0, 22.5, 23.0, 23.5, 24.0, 24.5, 25.0, 25.6, 26.0, 26.5, 27.0, 27.6, 28.5, 29.0, 29.7, 30.4, 30.7, 31.3, 31.5, 32.0, 32.5, 33.1, 33.6, 34.2, 35.0, 35.2, 35.9, 36.2, 36.5, 37.0, 37.5, 38.0, 38.3, 39.0, 39.6, 40.0, 41.0, 41.6, 42.0, 42.6, 43.0, 43.3, 43.9, 44.4, 45.0, 45.2, 45.9, 46.3, 46.6, 47.0, 47.6, 48.0, 48.7, 49.1, 50.0, 50.0, 50.5, 51.0, 51.2, 52.0, 52.6, 53.1, 53.6, 54.2, 54.6, 55.0, 55.3, 56.0, 56.0, 56.6, 57.0, 57.6, 58.0, 58.6, 59.0, 59.3, 60.0, 60.3, 60.4, 61.0, 61.3, 62.1, 63.0, 63.4, 64.1, 64.1, 64.2, 64.6, 64.6, 65.0, 65.4, 66.1, 66.6, 67.1, 67.7, 68.0, 68.3, 69.0, 69.0, 69.3, 69.9, 70.2, 70.9, 71.1, 72.0, 72.3, 73.1, 74.0, 74.0, 74.1, 74.3, 75.0, 75.0, 75.1, 75.5, 75.6, 76.0, 76.3, 76.1, 77.0, 77.3, 78.0, 78.3, 79.0, 79.2, 79.2, 80.0, 80.1, 80.8, 81.3, 82.0, 82.7, 83.0, 83.0, 83.1, 83.1, 83.7, 84.0, 84.0, 84.2, 84.7, 85.0, 85.0, 85.0, 85.0, 85.6, 86.0, 86.8, 86.2, 87.0, 88.0, 88.2, 89.1, 90.0, 90.3, 90.0, 90.1, 90.2, 90.0, 90.5, 91.0, 91.2, 92.0, 92.0, 92.4, 92.2, 93.0, 93.0, 93.0, 93.0, 93.0, 93.0, 93.0, 93.2, 94.0, 95.0, 95.2, 96.4, 96.0, 96.2, 96.2, 96.2, 97.0, 97.0, 97.4, 97.1, 97.5, 98.0, 97.6, 98.0, 98.0, 98.5, 99.0, 99.2, 99.6, 99.3};


const int hallpin = 1;
const int coil = 10;
int hall_reading = 0;
int last_hall_reading = 0;
int pwm_start = 0;
int integral_error = 0;
int duty_cycle = 0;
float kp = default_kp;
float kd = default_kd;
float ki = default_ki;
int target_val = default_target_val;


void setup() {
  // put your setup code here, to run once:
  pinMode(hallpin, INPUT);
  pinMode(coil, OUTPUT);
  Serial.begin(9600);
  analogWrite(coil, 255);
  

}


void cycle() {

  last_hall_reading = hall_reading;
  hall_reading = (hall_reading*(hall_filter-1) + analogRead(hallpin))/hall_filter;
  if (pwm_update_period < millis() - pwm_start) // If the pwm_update_period has passed then update
  {
    pwm_start = millis();

    //Negative error - lower the duty cycle
    int error = target_val - hall_reading;
    int deriv = last_hall_reading - hall_reading;

    
    integral_error = integral_error + error;

    duty_cycle = 125 + kp*error + kd*deriv + ki*integral_error; 
    duty_cycle = constrain(duty_cycle, 0, 255);

    analogWrite(coil, duty_cycle);
  }

 
}


void serialCommand(char command) //function to edit control weightings
{
  char output[255];
  
  switch(command)
  {
    case 'P':
      kp += kp_increment;
      break;
    case 'p':
      kp -= kp_increment;
      if(0 > kp) kp = 0;
      break;
      
    case 'D':
      kd += kd_increment;
      break;
    case 'd':
      kd -= kd_increment;
      if(0 > kd) kd = 0;
      break;
    
    case 'I':
      ki += ki_increment;
      break;
    case 'i':
      ki -= ki_increment;
      if(0 > ki) ki = 0;
      break;
      
    case 'T':
      target_val += target_val_increment;
      break;
    case 't':
      target_val -= target_val_increment;
      if(0 > target_val) target_val = 0;
      break;
    
    //Print current settings. Also printed after any of the above cycles.
    case 'V':
    case 'v':
      break;
    
    //Ignore unrecognised characters
    default:
      return;
  }

  Serial.print("Target: ");
  Serial.print(target_val);
  Serial.print("    kp: ");
  Serial.print(kp, 1);
  Serial.print("    kd: ");
  Serial.print(kd, 1);
  Serial.print("    ki: ");
  Serial.print(ki, 4);
  Serial.print("    Hall Reading: ");
  Serial.print(hall_reading);
  Serial.print("    Duty Cycle: ");
  Serial.println(duty_cycle);
  
}




void loop() {

  // Read any commands form the serial input
  if (0 < Serial.available()) {
    serialCommand(Serial.read());
  }


  //run the cycle  
  cycle();



}
