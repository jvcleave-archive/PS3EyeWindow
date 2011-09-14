#include "testApp.h"

ofImage cameraImage;
void testApp::setup() {
	//ofSetFrameRate(60);
	wrapper.ps3eyeInit();
}

void testApp::update() {
	if(wrapper.ps3eyeIsFrameNew()) {
		timer.tick();
	}
	
	cameraImage.setFromPixels(wrapper.pixels, wrapper.cameraWidth, wrapper.cameraHeight, OF_IMAGE_COLOR);
}

void testApp::draw() {
	ofBackground(0);
	
	
	cameraImage.draw(0, 0);
	
	ofSetColor(255);
	ofDrawBitmapString(ofToString((int) timer.getFrameRate()), 10, 20);
}

void testApp::doSomething()
{
	cout << "doSomething called" << endl;
}