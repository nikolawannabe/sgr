const int BRIGHTNESSCAP = 75;
const int redPin =  9;
const int greenPin =  10;
const int bluePin =  4;
int alertPin = 5;
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
int target = 0;
int waitTime = 0;
int rTarget;
int gTarget;
int bTarget;
int rT2;
int gT2;
int bT2;

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
  pinMode(alertPin, OUTPUT);

}

void loop() {
  if (Serial.available() > 0) {
    incomingByte = Serial.read();
    switch (incomingByte)
    {
      case 'A':
        digitalWrite(alertPin,HIGH);
        break;
      case 'C':
        digitalWrite(alertPin,LOW);
        break;
      case 'H':
        lightOn = 1;
        target = 1;
        break;
      case 'L':
        lightOn = 0;
        target = 1;
        digitalWrite(redPin, LOW);
        digitalWrite(greenPin,LOW);
        digitalWrite(bluePin, LOW);
        break;
      case 'R':
        target = 1;
        lightOn = 1;
        resetIncrements();
        rTarget = BRIGHTNESSCAP;
        gTarget = 0;
        bTarget = 0;
        break;
      case 'G':
        target = 1;
        lightOn = 1;
        resetIncrements();
        rTarget = 0;
        gTarget = BRIGHTNESSCAP;
        bTarget = 0;
        break;
      case 'B':
        target = 1;
        lightOn = 1;
        resetIncrements();
        rTarget = 0;
        gTarget = 0;
        bTarget = BRIGHTNESSCAP;
        break;
      case 'M':
        digitalWrite(motorPin,HIGH);
        break;
      case 'O':
        digitalWrite(motorPin,LOW);
        break;
      case 'S':
        Smile();
        break;
      case 'F':
        Frown();
        break;
      case 'N':
        NoExpression();
        break;
      case 'D':
        lightOn = 1;
        rTarget = 0;
        gTarget = 0;
        bTarget = BRIGHTNESSCAP;
        rT2 = BRIGHTNESSCAP;
        gT2 = BRIGHTNESSCAP;
        bT2 = BRIGHTNESSCAP;
        // multiple targets
        target = 2;
        break;
    }
  }

  if (lightOn == 1)
  {
    if (target)
    {
      if (target == 1)
        shiftTo(rTarget, gTarget, bTarget);
      else
        shiftBetween(rTarget, gTarget, bTarget, rT2, gT2, bT2);
    } 
    else
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

void NoExpression()
{
  for (int i = 0; i <= 10; i++)
  {
    digitalWrite(i,LOW);
  }
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

void shiftBetween(int rMax, int gMax, int bMax, int r2Max, int g2Max, int b2Max)
{
  rbrightness = rbrightness + rshiftIncrement;  // increment brightness for next loop iteration
  gbrightness = gbrightness + gshiftIncrement;  // increment brightness for next loop iteration
  bbrightness = bbrightness + bshiftIncrement;  // increment brightness for next loop iteration

  if (rbrightness < 0 || rbrightness > BRIGHTNESSCAP) 
  {  
    rshiftIncrement = -rshiftIncrement;
  }
  if (gbrightness < 0 || gbrightness > BRIGHTNESSCAP) 
  {  
    gshiftIncrement = -gshiftIncrement;
  }  
  if (bbrightness < 0 || bbrightness > BRIGHTNESSCAP) 
  {  
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
  
  if ((bshiftIncrement == 0) && (gshiftIncrement == 0) && (rshiftIncrement == 0))
  {
    if (waitTime == 200)
    {
      if (r2Max > rMax) rshiftIncrement = 1; else rshiftIncrement = -1;
      if (g2Max > gMax) gshiftIncrement = 1; else gshiftIncrement = -1;
      if (b2Max > bMax) bshiftIncrement = 1; else bshiftIncrement = -1;
      if (r2Max == rMax) rshiftIncrement = 0;
      if (g2Max == gMax) gshiftIncrement = 0;
      if (b2Max == bMax) bshiftIncrement = 0;
      int temp;
      temp = rTarget;
      rTarget = rT2;
      rT2 = temp;
      temp = gTarget;
      gTarget = gT2;
      gT2 = temp;
      temp = bTarget;
      bTarget = bT2;
      bT2 = temp;
      waitTime = 0;
    } else
    {
      waitTime++;
    }
  } else
  {  
    analogWrite(redPin, rbrightness);
    analogWrite(greenPin, gbrightness);
    analogWrite(bluePin, bbrightness);
  }
}


