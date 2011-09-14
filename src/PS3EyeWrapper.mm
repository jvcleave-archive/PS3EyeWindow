#include "PS3EyeWrapper.h"

#include <iostream>
#include <Cocoa/Cocoa.h>
#import "MyCameraCentral.h"


MyCameraCentral* central;
MyCameraDriver* driver;

BOOL cameraGrabbing;
CameraResolution cameraResolution;

NSImage* image;
NSBitmapImageRep* imageRep;



PS3EyeWrapper::PS3EyeWrapper()
{
	frameNew = false;
	
}
void PS3EyeWrapper::setup(int cameraRes, int framesPerSecond)
{
	if (cameraRes == PS3_VGA) 
	{
		cameraResolution = ResolutionVGA;
		cameraWidth = 640;
		cameraHeight = 480;
	}else {
		cameraResolution = ResolutionSIF;
		cameraWidth = 320;
		cameraHeight = 240;
	}

	cameraFPS = framesPerSecond;
	pixels = new unsigned char [cameraWidth*cameraHeight*3];
	init();
}
void PS3EyeWrapper::init() {

	central = [MyCameraCentral sharedCameraCentral];
	central.cameraResolution = cameraResolution;
	central.cameraWidth = cameraWidth;
	central.cameraHeight = cameraHeight;
	central.cameraFPS = cameraFPS;

	[central registerWrapper:this];
	[central startupWithNotificationsOnMainThread:YES recognizeLaterPlugins:YES];

	
}
void PS3EyeWrapper::onImageReady (unsigned char * cameraPixels ) 
{
	pixels = cameraPixels;
	frameNew = true;
	//NSLog(@"PS3EyeWrapper::onImageReady");
}


bool PS3EyeWrapper::isFrameNew()
{
	
		if (frameNew) 
		{
			frameNew = false;
			return true;
		}
		return false;

}