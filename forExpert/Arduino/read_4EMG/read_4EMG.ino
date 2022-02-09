// CONSTANTS
const int analogInPin0 = A0;
const int analogInPin1 = A1;
const int analogInPin2 = A2;
const int analogInPin3 = A3;

int v0_raw = 0;
int v1_raw = 0;
int v2_raw = 0;
int v3_raw = 0;

int v0 = 0;
int v1 = 0;
int v2 = 0;
int v3 = 0;

// definition of the frequency
double frequency = 200; // Hz
double sampleTime = 1 / frequency;
// modification 1/4
int sampleTime_us = sampleTime * 1000 * 1000; // we are working with microseconds -> overflows in 70 minutes more or less
// int sampleTime_ms = sampleTime*1000; // we are working with milliseconds -> overflows in 50 days more or less

unsigned long previousTime = 0;

void setup() {
  // initialize serial communications:
  Serial.begin(115200);
}

void loop() {
  // modification 2/4
  unsigned long currentTime = micros(); // working with microseconds
  // unsigned long currentTime = millis(); // working with milliseconds

  // modification 3/4
  if ((currentTime - previousTime) >= sampleTime_us)
    //if ((currentTime - previousTime) >= sampleTime_ms)

  {
    // read the analog in value:
    v0_raw = analogRead(analogInPin0);
    v1_raw = analogRead(analogInPin1);
    v2_raw = analogRead(analogInPin2);
    v3_raw = analogRead(analogInPin3);

    // map it to the range of the analog out:
    v0 = map(v0_raw, 0, 1023, 0, 1000);
    v1 = map(v1_raw, 0, 1023, 0, 1000);
    v2 = map(v2_raw, 0, 1023, 0, 1000);
    v3 = map(v3_raw, 0, 1023, 0, 1000);

    // print the results to the Serial Monitor:
    Serial.print(currentTime);
    Serial.print("\t");
    Serial.print(v0);
    Serial.print("\t");
    Serial.print(v1);
    Serial.print("\t");
    Serial.print(v2);
    Serial.print("\t");
    Serial.print(v3);
    Serial.print("\n");

    previousTime = currentTime;
  }
  //  // Only for [DEBUG], comment once understood how does it work
  //  Serial.print(currentTime);
  //  Serial.print("\t");
  //  Serial.print((currentTime - previousTime));
  //  Serial.print("\t");
  //  // modification 4/4
  //  Serial.print(sampleTime_us);
  //  // Serial.print(sampleTime_ms);
  //  Serial.print("\n");
}
