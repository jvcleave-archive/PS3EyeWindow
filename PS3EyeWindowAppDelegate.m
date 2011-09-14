//
//  PS3EyeWindowAppDelegate.m
//  PS3EyeWindow
//
//  Created by Van Cleave, Jason on 9/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PS3EyeWindowAppDelegate.h"

@implementation PS3EyeWindowAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification 
{
	// Insert code here to initialize your application 
	image=[[NSImage alloc] init];
    [image setCacheDepthMatchesImageDepth:YES];			//We have to set this to work with thousands of colors
    imageRep=[[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL	//Set up just to avoid a NIL imageRep
                                                     pixelsWide:320
                                                     pixelsHigh:240
                                                  bitsPerSample:8	
                                                samplesPerPixel:3
                                                       hasAlpha:NO
                                                       isPlanar:NO
                                                 colorSpaceName:NSDeviceRGBColorSpace
                                                    bytesPerRow:0
                                                   bitsPerPixel:0];
	assert (imageRep);
    memset([imageRep bitmapData],0,[imageRep bytesPerRow]*[imageRep pixelsHigh]);
    [image addRepresentation:imageRep]; 
	

	imageView = [[[NSImageView alloc] initWithFrame:NSMakeRect(0, 240, 320, 240)] autorelease];
	imageView.image = image;
	
	[window setContentView:imageView];
	
	[window makeKeyAndOrderFront:self];
	[window display];
	
	central = [MyCameraCentral sharedCameraCentral];
	[central setDelegate:self];
	[central startupWithNotificationsOnMainThread:YES recognizeLaterPlugins:YES];
	
	
	cameraGrabbing=[driver startGrabbing];
	if (cameraGrabbing) 
	{
		NSLog(@"PS3EyeWindowAppDelegate camera is grabbing");
		/*[self setImageOfToolbarItem:PlayToolbarItemIdentifier to:@"PauseToolbarItem"];
		NSLog(@"Status: Playing")];
		[fpsPopup setEnabled:NO];
		[sizePopup setEnabled:NO];
		[compressionSlider setEnabled:NO];
		[reduceBandwidthCheckbox setEnabled:NO];*/
		[driver setImageBuffer:[imageRep bitmapData] bpp:3 rowBytes:[driver width]*3];
	}else 
	{
		NSLog(@"PS3EyeWindowAppDelegate camera not grabbing");
	}

	
}
- (void) cameraDetected:(unsigned long) cid
{
    CameraError err;
    if (!driver) 
	{
        err=[central useCameraWithID:cid to:&driver acceptDummy:NO];
        if (err) 
		{
			driver=NULL;
			switch (err) 
			{
                case CameraErrorBusy:NSLog(@"Status: Camera used by another app"); break;
                case CameraErrorNoPower:NSLog(@"Status: Not enough USB bus power"); break;
                case CameraErrorNoCam:NSLog(@"Status: Camera not found (this shouldn't happen)"); break;
                case CameraErrorNoMem:NSLog(@"Status: Out of memory"); break;
                case CameraErrorUSBProblem:NSLog(@"Status: USB communication problem"); break;
                case CameraErrorInternal:NSLog(@"Status: Internal error (this shouldn't happen)"); break;
                case CameraErrorUnimplemented:NSLog(@"Status: Unsupported"); break;
                default:NSLog(@"Status: Unknown error (this shouldn't happen)"); break;
            }
		}
        if (driver!=NULL) 
		{
            if ([driver hasSpecificName])
			{
				NSLog(@"Status: Connected to %@", [driver getSpecificName]);
			}else 
			{
				NSLog(@"Status: Connected to %@", [central nameForID:cid]);
			}
			[driver setDelegate:self];
            [driver retain];			//We keep our own reference
            /*[contrastSlider setEnabled:[driver canSetContrast]];
            [brightnessSlider setEnabled:[driver canSetBrightness]];
            [gammaSlider setEnabled:[driver canSetGamma]];
            [sharpnessSlider setEnabled:[driver canSetSharpness]];
            [saturationSlider setEnabled:[driver canSetSaturation]];
            [hueSlider setEnabled:[driver canSetHue]];
            [manGainCheckbox setEnabled:[driver canSetAutoGain]];
            [sizePopup setEnabled:YES];
            [fpsPopup setEnabled:YES];
            [flickerPopup setEnabled:[driver canSetFlicker]];
            [whiteBalancePopup setEnabled:[driver canSetWhiteBalanceMode]];
            [orientationPopup setEnabled:YES];
            [blackwhiteCheckbox setEnabled:[driver canBlackWhiteMode]];
            [ledCheckbox setEnabled:[driver canSetLed]];
            [cameraDisableCheckbox setEnabled:[driver canSetDisabled]];
            [reduceBandwidthCheckbox setEnabled:[driver canSetUSBReducedBandwidth]];
			
            [whiteBalancePopup selectItemAtIndex:[driver whiteBalanceMode]-1];
            [gainSlider setEnabled:[driver canSetGain] && (![driver isAutoGain] || ![driver agcDisablesGain])];
            [shutterSlider setEnabled:[driver canSetShutter] && (![driver isAutoGain] || ![driver agcDisablesShutter])];
            if ([driver maxCompression]>0) {
                [compressionSlider setNumberOfTickMarks:[driver maxCompression]+1];
                [compressionSlider setEnabled:YES];
            } else {
                [compressionSlider setNumberOfTickMarks:2];
                [compressionSlider setEnabled:NO];
            }
            [brightnessSlider setFloatValue:[driver brightness]];
            [contrastSlider setFloatValue:[driver contrast]];
            [saturationSlider setFloatValue:[driver saturation]];
            [hueSlider setFloatValue:[driver hue]];
            [gammaSlider setFloatValue:[driver gamma]];
            [sharpnessSlider setFloatValue:[driver sharpness]];
            [gainSlider setFloatValue:[driver gain]];
            [shutterSlider setFloatValue:[driver shutter]];
            [manGainCheckbox setIntValue:([driver isAutoGain]==NO)?1:0];
            [sizePopup selectItemAtIndex:[driver resolution]-1];
            [fpsPopup selectItemAtIndex:FPS2MenuItem([driver fps])];
            [flickerPopup selectItemAtIndex:[driver flicker]];
            [compressionSlider setFloatValue:((float)[driver compression])
			 /((float)(([driver maxCompression]>0)?[driver maxCompression]:1))];
            [orientationPopup selectItemAtIndex:[driver orientation] - 1];
            [cameraDisableCheckbox setIntValue:([driver disabled] == YES) ? 1 : 0];
            [reduceBandwidthCheckbox setIntValue:([driver usbReducedBandwidth] == YES) ? 1 : 0];
            [self formatChanged:self];*/
            cameraGrabbing=NO;
            if ([driver supportsCameraFeature:CameraFeatureInspectorClassName]) 
			{
                NSString* inspectorName=[driver valueOfCameraFeature:CameraFeatureInspectorClassName];
                if (inspectorName)
				{
                    if (![@"MyCameraInspector" isEqualToString:inspectorName]) 
					{
                        /*Class c=NSClassFromString(inspectorName);
                        inspector=[(MyCameraInspector*)[c alloc] initWithCamera:driver];
                        if (inspector) 
						{
                            NSDrawerState state;
                            [inspectorDrawer setContentView:[inspector contentView]];
                            state=[settingsDrawer state];
                            if ((state==NSDrawerOpeningState)||(state==NSDrawerOpenState)) 
							{
                                [inspectorDrawer openOnEdge:NSMinXEdge];
                            }
                        }*/
                    }
                }
            }
        }
    }
}
- (void) imageReady:(id)cam 
{
    if (cam!=driver) return;	//probably an old one
	[imageView display];
    [driver setImageBuffer:[driver imageBuffer] bpp:[driver imageBufferBPP] rowBytes:[driver imageBufferRowBytes]];
}
- (void) updateStatus:(NSString *)status fpsDisplay:(float)fpsDisplay fpsReceived:(float)fpsReceived
{
    NSString * append;
    NSString * newStatus;
    
    if (fpsReceived == 0.0) 
	{
	  append = [NSString stringWithFormat:LStr(@" (%3.1f fps)"), fpsDisplay];	
	}else 
	{
		append = [NSString stringWithFormat:LStr(@" (%3.1f fps, receiving %3.1f fps)"), fpsDisplay, fpsReceived];
	}
    
    if (status == NULL)
	{
		newStatus = [[NSString stringWithString:LStr(@"Status: Playing")] stringByAppendingString:append];
	}else 
	{
		newStatus = [status stringByAppendingString:append];
	}

	NSLog(@"updateStatus %@", newStatus);
    //[statusText setStringValue:newStatus];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
	NSLog(@"PS3EyeWindowAppDelegate applicationWillTerminate");
    [central shutdown];
    [imageView setImage:NULL];
    [image release];
}
- (void) dealloc 
{

    [super dealloc];
}
@end
