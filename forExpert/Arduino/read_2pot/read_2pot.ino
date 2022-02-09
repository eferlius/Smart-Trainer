// CONSTANTS
const int analogInPin0 = A0;
const int analogInPin1 = A1;

int v0_raw = 0;
int v1_raw = 0;

int v0 = 0;
int v1 = 0;

// definition of the frequency
double frequency = 200; // Hz
double sampleTime = 1 / frequency;
int sampleTime_us = sampleTime * 1000 * 1000; // we are working with microseconds -> overflows in 70 minutes more or less

unsigned long previousTime = 0;

void setup() {
  // initialize serial communications:
  Serial.begin(115200);
}

void loop() {
  unsigned long currentTime = micros(); // working with microseconds

  if ((currentTime - previousTime) >= sampleTime_us)

  {
    // read the analog in value:
    v0_raw = analogRead(analogInPin0);
    v1_raw = analogRead(analogInPin1);

    // map it to the range of the analog out:
    v0 = map(v0_raw, 0, 1023, 0, 1000);
    v1 = map(v1_raw, 0, 1023, 0, 1000);

    // print the results to the Serial Monitor:
    Serial.print(currentTime);
    Serial.print("\t");
    Serial.print(v0);
    Serial.print("\t");
    Serial.print(v1);
    Serial.print("\n");

    previousTime = currentTime;
  }
}
