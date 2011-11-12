const int BRIGHTNESSCAP = 150;
const int redPin =  12;
const int greenPin =  14;
const int bluePin =  15;
const int motorPin = 16;
const int anA = 4;
const int anB = 5;
const int anC = 6;
const int anD = 7;
const int anE = 8;
const int anF = 9;
const int anG = 10;
int smileNum = 4;
int smileWait = 200;
int rbrightness = 0; 
int gbrightness = 0;
int bbrightness = 0;
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
boolean smiling = false;

void setup() {
  // initialize serial communication:
  Serial.begin(9600);
  pinMode(redPin, OUTPUT);
  pinMode(greenPin, OUTPUT);
  pinMode(bluePin, OUTPUT);
  pinMode(motorPin,OUTPUT);
  pinMode(anA, OUTPUT);
  pinMode(anB, OUTPUT);
  pinMode(anC, OUTPUT);
  pinMode(anD, OUTPUT);
  pinMode(anE, OUTPUT);
  pinMode(anF, OUTPUT);
  pinMode(anG, OUTPUT);

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
      lightOn = 1;
      resetIncrements();
      rTarget = BRIGHTNESSCAP;
      gTarget = 0;
      bTarget = 0;
    }
     if (incomingByte == 'G') {
      target = true;
      lightOn = 1;
      resetIncrements();
      rTarget = 0;
      gTarget = BRIGHTNESSCAP;
      bTarget = 0;
    }
     if (incomingByte == 'B') {
      target = true;
      lightOn = 1;
      resetIncrements();
      rTarget = 0;
      gTarget = 0;
      bTarget = BRIGHTNESSCAP;
    }
    if (incomingByte == 'M')
    {
      digitalWrite(motorPin,HIGH);
    }
    if (incomingByte == 'O')
    {
      digitalWrite(motorPin,LOW);
    }
    if (incomingByte == 'S')
    {
       Smile();
    }
    if (incomingByte == 'F')
    {
      Frown();
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

void Run()
{
     if (smileWait >= 200)
     {
       digitalWrite(smileNum,LOW);
       smileNum++;
       if (smileNum > 10)
       {
         smileNum = 4;
       }  
       digitalWrite(smileNum,HIGH);
       smileWait = 0;
     }
   smileWait++;
}

void Smile()
{
  digitalWrite(anB,LOW);
  digitalWrite(anF,LOW);
  digitalWrite(anE,LOW);
  digitalWrite(anC,HIGH);
  digitalWrite(anD,HIGH);
  digitalWrite(anG,HIGH);
  digitalWrite(anA,HIGH);
}

void Frown()
{
  digitalWrite(anB,LOW);
  digitalWrite(anF,HIGH);
  digitalWrite(anE,HIGH);
  digitalWrite(anC,LOW);
  digitalWrite(anD,HIGH);
  digitalWrite(anG,HIGH);
  digitalWrite(anA,LOW);
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
  
    if (rbrightness < 0 || rbrightness > BRIGHTNESSCAP) {  
      rshiftIncrement = -rshiftIncrement;
    }
    if (gbrightness < 0 || gbrightness > BRIGHTNESSCAP) {  
        gshiftIncrement = -gshiftIncrement;
      }  
    if (bbrightness < 0 || bbrightness > BRIGHTNESSCAP) {  
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
    analogWrite(redPin, rbrightness);
    analogWrite(greenPin, gbrightness);
    analogWrite(bluePin, bbrightness);
}

