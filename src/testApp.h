#pragma once

#include "ofMain.h"
#include "PS3EyeWrapper.h"

class RateTimer {
protected:
	float lastTick, averagePeriod, smoothing;
	bool secondTick;
public:
	RateTimer(float smoothing = .9) :
	smoothing(smoothing) {
		reset();
	}
	void reset() {
		lastTick = 0;
		averagePeriod = 0;
		secondTick = false;
	}
	float getFrameRate() {
		return averagePeriod == 0 ? 0 : 1 / averagePeriod;
	}
	void tick() {
		float curTick = ofGetElapsedTimef();
		if(lastTick == 0) {
			secondTick = true;
		} else {
			float curDiff = curTick - lastTick;;
			if(secondTick) {
				averagePeriod = curDiff;
				secondTick = false;
			} else {
				averagePeriod = ofLerp(curDiff, averagePeriod, smoothing);
			}
		}
		lastTick = curTick;
	}
};	

class testApp : public ofBaseApp {
public:
	void setup();
	void update();
	void draw();
	PS3EyeWrapper wrapper;
	void doSomething();
	RateTimer timer;
};

extern testApp* app;