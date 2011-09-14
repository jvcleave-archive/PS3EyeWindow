#pragma once


class PS3EyeWrapper
{
public:
	PS3EyeWrapper();
	void init();
	bool isFrameNew();
	void onImageReady(unsigned char * cameraPixels);
	unsigned char * pixels;
	
	int cameraWidth;
	int cameraHeight;
	int cameraFPS;
	bool frameNew;
};