#pragma once

#define PS3_VGA 1
#define PS3_SIF 2

class PS3EyeWrapper
{
public:
	PS3EyeWrapper();
	void setup(int cameraRes, int framesPerSecond);
	void init();
	
	bool isFrameNew();
	void onImageReady(unsigned char * cameraPixels);
	unsigned char * pixels;
	
	int cameraWidth;
	int cameraHeight;
	int cameraFPS;
	bool frameNew;
};