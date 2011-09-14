#pragma once


class PS3EyeWrapper
{
public:
	PS3EyeWrapper();
	void ps3eyeInit();
	bool ps3eyeIsFrameNew();
	void onImageReady(unsigned char * cameraPixels);
	unsigned char * pixels;
	
	int cameraWidth;
	int cameraHeight;
	int cameraFPS;
};