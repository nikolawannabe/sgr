const int BRIGHTNESSCAP = 255;
const int redPin =  15;
const int greenPin =  14;
const int bluePin =  12;
int rbrightness = 0; 
int gbrightness = BRIGHTNESSCAP/3; 
int bbrightness = 2 * (BRIGHTNESSCAP / 3); 

int rincrement = 1;  // brightness increment
int gincrement = 1;  // brightness increment
int bincrement = 1;  // brightness increment
int rshiftIncrement = rincrement;
int gshiftIncrement = gincrement;
int bshiftIncrement = bincrement;
int incomingByte;      // a variable to read incoming serial data into
boolean target = false;
int rTarget;
int gTarget;
int bTarget;
int lightOn = 0;

void setup() {
  // initialize serial communication:
  Serial.begin(9600);
  pinMode(redPin, OUTPUT);
  pinMode(greenPin, OUTPUT);
  pinMode(bluePin, OUTPUT);
}

void loop() {
  if (Serial.available() > 0) {
    incomingByte = Serial.read();
    if (incomingByte == 'H') {
       lightOn = 1;
       target = false;
      } 
    if (incomingByte == 'L') {
      lightOn = 0;
      target = false;
      digitalWrite(redPin, LOW);
      digitalWrite(greenPin,LOW);
      digitalWrite(bluePin, LOW);
    }
    if (incomingByte == 'R') {
      target = true;
      resetIncrements();
      rTarget = BRIGHTNESSCAP;
      gTarget = 0;
      bTarget = 0;
    }
     if (incomingByte == 'G') {
      target = true;
      resetIncrements();
      rTarget = 0;
      gTarget = BRIGHTNESSCAP;
      bTarget = 0;
    }
     if (incomingByte == 'B') {
      target = true;
      resetIncrements();
      rTarget = 0;
      gTarget = 0;
      bTarget = BRIGHTNESSCAP;
    }
  }
  
  if (lightOn == 1)
  {
    if (target)
    {
      shiftTo(rTarget, gTarget, bTarget);
    } else
    {
      shift();
    }
  }
   delay(20);  // wait for 20 milliseconds to see the dimming effect
}

void shift()
{
    rbrightness = rbrightness + rincrement;  // increment brightness for next loop iteration
    gbrightness = gbrightness + gincrement;  // increment brightness for next loop iteration
    bbrightness = bbrightness + bincrement;  // increment brightness for next loop iteration
  
    if (rbrightness <= 0 || rbrightness >= BRIGHTNESSCAP) {  
      rincrement = -rincrement;
    }
    if (gbrightness <= 0 || gbrightness >= BRIGHTNESSCAP) {  
        gincrement = -gincrement;
      }  
    if (bbrightness <= 0 || bbrightness >= BRIGHTNESSCAP) {  
        bincrement = -bincrement;
      }    
    rbrightness = constrain(rbrightness, 0, BRIGHTNESSCAP);
    gbrightness = constrain(gbrightness, 0, BRIGHTNESSCAP);
    bbrightness = constrain(bbrightness, 0, BRIGHTNESSCAP);
    analogWrite(redPin, rbrightness);
    analogWrite(greenPin, gbrightness);
    analogWrite(bluePin, bbrightness);
}

void resetIncrements()
{
  rshiftIncrement = 1;
  gshiftIncrement = 1;
  bshiftIncrement = 1;
}
void shiftTo(int rMax, int gMax, int bMax)
{
    rbrightness = rbrightness + rshiftIncrement;  // increment brightness for next loop iteration
    gbrightness = gbrightness + gshiftIncrement;  // increment brightness for next loop iteration
    bbrightness = bbrightness + bshiftIncrement;  // increment brightness for next loop iteration
  
    if (rbrightness < 0 || rbrightness > rMax) {  
      rshiftIncrement = -rshiftIncrement;
    }
    if (gbrightness < 0 || gbrightness > gMax) {  
        gshiftIncrement = -gshiftIncrement;
      }  
    if (bbrightness < 0 || bbrightness > bMax) {  
        bshiftIncrement = -bshiftIncrement;
      }
    if (rbrightness == rMax)    
    {
      rshiftIncrement = 0;
    }
    if (gbrightness == gMax)    
    {
      gshiftIncrement = 0;
    }
    if (bbrightness == bMax)    
    {
      bshiftIncrement = 0;
    }
    rbrightness = constrain(rbrightness, 0, BRIGHTNESSCAP);
    gbrightness = constrain(gbrightness, 0, BRIGHTNESSCAP);
    bbrightness = constrain(bbrightness, 0, BRIGHTNESSCAP);
    analogWrite(redPin, rbrightness);
    analogWrite(greenPin, gbrightness);
    analogWrite(bluePin, bbrightness);
}

