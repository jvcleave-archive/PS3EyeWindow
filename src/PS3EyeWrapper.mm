#include "PS3EyeWrapper.h"

#include <iostream>
#include <Cocoa/Cocoa.h>
#import "MyCameraCentral.h"

//#import "PS3EyeWindowAppDelegate.h"

MyCameraCentral* central;
MyCameraDriver* driver;

BOOL cameraGrabbing;
CameraResolution cameraResolution;

NSImage* image;
NSBitmapImageRep* imageRep;



PS3EyeWrapper::PS3EyeWrapper()
{
	cameraResolution = ResolutionSIF;
	//ResolutionSIF or ResolutionVGA
	frameNew = false;
	if (cameraResolution == ResolutionVGA) 
	{
		cameraWidth = 640;
		cameraHeight = 480;
		cameraFPS = 60;
	}else 
	{
		cameraWidth = 320;
		cameraHeight = 240;
		cameraFPS = 180;
	}
	pixels = new unsigned char [cameraWidth*cameraHeight*3];
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