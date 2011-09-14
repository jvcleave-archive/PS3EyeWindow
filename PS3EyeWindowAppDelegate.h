//
//  PS3EyeWindowAppDelegate.h
//  PS3EyeWindow
//
//  Created by Van Cleave, Jason on 9/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#define VERBOSE 1

#import <Cocoa/Cocoa.h>
#import "MyCameraCentral.h"

@interface PS3EyeWindowAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	NSImage* image;
	NSBitmapImageRep* imageRep;
	NSImageView* imageView;
	MyCameraCentral* central;
	MyCameraDriver* driver;
	
	
	BOOL cameraGrabbing;
}
//delegate calls from camera central
- (void)cameraDetected:(unsigned long)uid;

//delegate calls from camera driver
- (void)imageReady:(id)cam;
//- (void)cameraHasShutDown:(id)cam;
//- (void) cameraEventHappened:(id)sender event:(CameraEvent)evt;
- (void) updateStatus:(NSString *)status fpsDisplay:(float)fpsDisplay fpsReceived:(float)fpsReceived;

@property (assign) IBOutlet NSWindow *window;

@end
