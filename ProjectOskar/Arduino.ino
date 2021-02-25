#include <Wire.h>
#include <Adafruit_MotorShield.h>
#include "utility/Adafruit_PWMServoDriver.h"

// constants
int MOTOR_SPEED;

// objects and varialbes
Adafruit_MotorShield AFMS = Adafruit_MotorShield();
char data;
char direction;
int position;

Adafruit_StepperMotor *motorX1 = AFMS.getStepper(200, 2);
Adafruit_StepperMotor *motorX2 = AFMS.getStepper(200, 1); 

void setup() {
	Serial.begin(9600);
	establishConnection();
	AFMS.begin();
	motorX1->setSpeed(MOTOR_SPEED);
	motorX2->setSpeed(MOTOR_SPEED);
	position = 0;
}

void loop() {
	if(Serial.available() > 0) {
		data = Serial.read();
		if(data == "F" || data == "B") {
			rotateMotor(10, data); // first argument sets for-loop steps - try out different values
		}
		// delay(100);
	} else {
		Serial.println(position);
		delay(50);
	}
}

void establishConnection() {
	while(Serial.available() <= 0) {
		Serial.println("connect");
		delay(300);
	}
}

void rotateMotor(int steps, char direction) {
	if(direction == "F") {
		// rotate forwards
		for(int i = 0; i < steps; i++) {
			motorX1->step(1, FORWARD, DOUBLE);
			motorX2->step(1, BACKWARD, DOUBLE);
			position++;
		}
	} else if(direction == "B") {
		// rotate backwards
		for(int i = 0; i < steps; i++) {
			motorX1->step(1, BACKWARD, DOUBLE);
			motorX2->step(1, FORWARD, DOUBLE);
			position--;
		}
	}
}