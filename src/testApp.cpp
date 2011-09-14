#include "testApp.h"

ofImage cameraImage;
void testApp::setup()
{
	//ofSetFrameRate(60);
	//wrapper.setup(PS3_VGA, 60);
	wrapper.setup(PS3_SIF, 180);
}

void testApp::update() {
	if(wrapper.isFrameNew())
	{
		timer.tick();
	}
	
	cameraImage.setFromPixels(wrapper.pixels, wrapper.cameraWidth, wrapper.cameraHeight, OF_IMAGE_COLOR);
}

void testApp::draw() {
	ofBackground(0);
	
	
	cameraImage.draw(0, 0);
	
	ofSetColor(255);
	ofDrawBitmapString(ofToString((int) timer.getFrameRate()), 0, wrapper.cameraHeight+20);
}

