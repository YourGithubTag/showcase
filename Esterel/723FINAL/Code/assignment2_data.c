#include<stdio.h>
#include<stdlib.h>
#include <stdbool.h>

#include "assignment2.h"

// All Constants are kept in this C file so that they are centralized

float SpeedMin = 30.0; // km/h
float SpeedMax = 150.0; // km/h
float SpeedInc = 2.5; // km/h
float KP = 8.113;
float KI = 0.5;
float ThrottleSatMax = 45.0; // percent
float PedalsMin = 3.0; // percent

// Decrement CruiseSpeed, set to SpeedMin if below
void DecrementCruiseSpeed(float* CruiseSpeed) {
	if ((*CruiseSpeed - SpeedInc) < SpeedMin) {
		*CruiseSpeed = SpeedMin;
	}
	else if ((*CruiseSpeed - SpeedInc) > SpeedMax) {
		*CruiseSpeed = SpeedMax;
	}
	else {
		*CruiseSpeed = *CruiseSpeed - SpeedInc;
	}
}

// Increment CruiseSpeed, set to SpeedMax if above
void IncrementCruiseSpeed(float* CruiseSpeed) {
	if ((*CruiseSpeed + SpeedInc) > SpeedMax) {
		*CruiseSpeed = SpeedMax;
	}
	else if ((*CruiseSpeed + SpeedInc) < SpeedMin) {
		*CruiseSpeed = SpeedMin;
	}
	else {
		*CruiseSpeed = *CruiseSpeed + SpeedInc;
	}
}

// Set CruiseSpeed within SpeedMin or SpeedMax if outside range
void SetCruiseSpeedWithinBounds(float* CruiseSpeed) {
	if ((*CruiseSpeed) > SpeedMax) {
		*CruiseSpeed = SpeedMax;
	}
	else if ((*CruiseSpeed) < SpeedMin) {
		*CruiseSpeed = SpeedMin;
	}
}

// Check if Speed is within range SpeedMin to SpeedMax
bool CheckSpeedValid(float currentSpeed) {
	return ((currentSpeed > SpeedMin) && (currentSpeed < SpeedMax)) ? true : false;
}

// Check if pedals are over PedalsMin
bool isPressed(float pedalVal) {
	if (pedalVal > PedalsMin) {
		return true;
	}
	else {
		return false;
	}
	// For some reason, the ? operator doesn't return properly unless the && comparison is kept.
	//return ((pedalVal > PedalsMin) && (PedalsMin == PedalsMin)) ? true : false;
}

/*
DESCRIPTION: Saturate the throttle command to limit the acceleration.
PARAMETERS: throttleIn - throttle input
            saturate - true if saturated, false otherwise
RETURNS: throttle output (ThrottleCmd)
*/
float saturateThrottle(float throttleIn, bool* saturate)
{
	if (throttleIn > ThrottleSatMax) {
		*saturate = true;
		return ThrottleSatMax;
	}
	else if (throttleIn < 0) {
		*saturate = true;
		return 0;
	}
	else {
		*saturate = false;
		return throttleIn;
	}
}

/*
DESCRIPTION: Saturate the throttle command to limit the acceleration.
PARAMETERS: isGoingOn - true if the cruise control has just gone into the ON state 
                        from another state; false otherwise
            saturate - true if saturated, false otherwise
RETURNS: throttle output (ThrottleCmd)
*/
float regulateThrottle(bool isGoingOn, float cruiseSpeed, float vehicleSpeed)
{
	static bool saturate = true;
	static float iterm = 0;
	
	if (isGoingOn) {
		iterm = 0;	// reset the integral action
		saturate = true;	
	}
	float error = cruiseSpeed - vehicleSpeed;
	float proportionalAction = error * KP;
	if (saturate)
		error = 0;	// integral action is hold when command is saturated
	iterm = iterm + error;
	float integralAction = KI * iterm;
	return saturateThrottle(proportionalAction + integralAction, &saturate);
}
