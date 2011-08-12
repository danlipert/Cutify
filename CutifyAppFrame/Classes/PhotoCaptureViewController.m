//
//  PhotoCaptureViewController.m
//  LuchaLibreUSA
//
//  Created by Dave Sluder on 7/16/11.
//  Copyright 2011 Dave Sluder. All rights reserved.
//

#import "PhotoCaptureViewController.h"
#import "ApplyStickersViewController.h"
#import "PhotoGridViewController.h"
#import "DSActivityView.h"

@interface PhotoCaptureViewController()


- (void)takePhoto;
- (void)toggleCamera;
@end



@implementation PhotoCaptureViewController

@synthesize captureManager;
@synthesize delegate;
@synthesize ppVC;

@synthesize flashButton;

- (void)dealloc 
{
	[captureManager release], captureManager = nil;	
	[super dealloc];
}

- (void)didReceiveMemoryWarning 
{
	[super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
	[self.navigationController setNavigationBarHidden:YES animated:YES
	 ];
	
	[DSBezelActivityView removeViewAnimated:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
	if([self.captureManager.captureSession isRunning] == FALSE)
	{
		[self turnOnCamera];
	}
}
- (void)viewDidLoad 
{	
	[self setCaptureManager:[[CaptureSessionManager alloc] init]];
	
	[[self captureManager] addVideoInput];
	[[self captureManager] addStillImageOutput];
	[[self captureManager] addVideoPreviewLayer];

	CGRect layerRect = [[[self view] layer] bounds];
	[[[self captureManager] previewLayer] setBounds:layerRect];
	[[[self captureManager] previewLayer] setPosition:CGPointMake(CGRectGetMidX(layerRect),
																  CGRectGetMidY(layerRect))];
	[[[self view] layer] addSublayer:[[self captureManager] previewLayer]];
	
	/* If you want an overlay */
	UIImageView *overlayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CameraScreenCrop.png"]];
	[overlayImageView setFrame:CGRectMake(0, 0, 320, 427)];
	[[self view] addSubview:overlayImageView];
	[overlayImageView release];
	
	UIImageView *toolBarView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CameraScreenBar.png"]];
	[toolBarView setFrame:CGRectMake(0,480-20-53, 320, 53)];
	[self.view addSubview:toolBarView];
	[toolBarView release];
	
	//
//	UIButton *toggleCameraButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//	[toggleCameraButton setTitle:@"Toggle Camera" forState:UIControlStateNormal];
//	[toggleCameraButton setFrame:CGRectMake(202, 8, 112, 30)];
//	[toggleCameraButton addTarget:self action:@selector(toggleCamera) forControlEvents:UIControlEventTouchUpInside];
//	[[self view] addSubview:toggleCameraButton];
	
	UIButton *takePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[takePhotoButton setImage:[UIImage imageNamed:@"CameraScreenButton.png"] forState:UIControlStateNormal];
	[takePhotoButton setFrame:CGRectMake((320-101)/2,480-20-53+4, 101, 43)];
	[takePhotoButton setTitle:@"Photo" forState:UIControlStateNormal];
	[takePhotoButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
	[[self view] addSubview:takePhotoButton];
	
//	UIButton *libraryButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//	[libraryButton setFrame:CGRectMake(10,480-20-44,100,43)];
//	[libraryButton setTitle:@"View Photos" forState:UIControlStateNormal];
//	[libraryButton addTarget:self action:@selector(libraryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//	[self.view addSubview:libraryButton];
//	
//	UIButton *iPhotoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//	[iPhotoButton setFrame:CGRectMake(210,480-20-44,100,43)];
//	[iPhotoButton setTitle:@"Load Photo" forState:UIControlStateNormal];
//	[iPhotoButton addTarget:self action:@selector(iPhotoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//	[self.view addSubview:iPhotoButton];
	
	UIButton *libraryButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[libraryButton setFrame:CGRectMake(320-6-45,480-20-53+4, 45, 45)];
	[libraryButton setImage:[UIImage imageNamed:@"CameraScreenCutifyLibraryIcon.png"] forState:UIControlStateNormal];
	[libraryButton addTarget:self action:@selector(libraryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:libraryButton];
	
	UIButton *iPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[iPhotoButton setFrame:CGRectMake(6,480-20-53+4, 45, 45)];
	[iPhotoButton setImage:[UIImage imageNamed:@"CameraScreenLibraryIcon.png"] forState:UIControlStateNormal];
	[iPhotoButton addTarget:self action:@selector(iPhotoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:iPhotoButton];
	
	UIButton *_flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[_flashButton setImage:[UIImage imageNamed:@"CameraScreenFlashOff.png"] forState:UIControlStateNormal];
	[_flashButton setFrame:CGRectMake(10, 10, _flashButton.imageView.image.size.width, _flashButton.imageView.image.size.height)];
	[_flashButton addTarget:self action:@selector(flashButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[_flashButton setTag:0];
	[self.captureManager setFlashMode:AVCaptureFlashModeOff];
	self.flashButton = _flashButton;
	[self.view addSubview:self.flashButton];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayImagePreview) name:kImageCapturedSuccessfully object:nil];
	[[captureManager captureSession] startRunning];
	
	//add focus gestures
	// Add a single tap gesture to focus on the point tapped, then lock focus
	UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToAutoFocus:)];
	[singleTap setDelegate:self];
	[singleTap setNumberOfTapsRequired:1];
	[self.view addGestureRecognizer:singleTap];
	
	// Add a double tap gesture to reset the focus mode to continuous auto focus
	UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToContinouslyAutoFocus:)];
	[doubleTap setDelegate:self];
	[doubleTap setNumberOfTapsRequired:2];
	[singleTap requireGestureRecognizerToFail:doubleTap];
	[self.view addGestureRecognizer:doubleTap];
	
	[doubleTap release];
	[singleTap release];
	
}
	
-(void)flashButtonPressed:(id)sender
{
	UIButton *_flashButton = self.flashButton;
	switch (_flashButton.tag) {
		case 0:
			[_flashButton setTag:1];
			[_flashButton setImage:[UIImage imageNamed:@"CameraScreenFlashOn.png"] forState:UIControlStateNormal];
			[_flashButton setFrame:CGRectMake(10, 10, _flashButton.imageView.image.size.width, _flashButton.imageView.image.size.height)];
			[self.captureManager setFlashMode:AVCaptureFlashModeOn];
			break;
		case 1:
			[_flashButton setTag:2];
			[_flashButton setImage:[UIImage imageNamed:@"CameraScreenFlashAuto.png"] forState:UIControlStateNormal];
			[_flashButton setFrame:CGRectMake(10, 10, _flashButton.imageView.image.size.width, _flashButton.imageView.image.size.height)];
			[self.captureManager setFlashMode:AVCaptureFlashModeAuto];
			break;

		case 2:
			[_flashButton setTag:0];
			[_flashButton setImage:[UIImage imageNamed:@"CameraScreenFlashOff.png"] forState:UIControlStateNormal];
			[_flashButton setFrame:CGRectMake(10, 10, _flashButton.imageView.image.size.width, _flashButton.imageView.image.size.height)];
			[self.captureManager setFlashMode:AVCaptureFlashModeOff];
			break;

		default:
			break;
	}
}

-(void)iPhotoButtonPressed:(id)sender
{
	[self turnOffCamera];
	
	UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	
	picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	picker.allowsImageEditing = YES;
	[picker.navigationBar setTag:1];
	
	[self presentModalViewController:picker animated:YES];
}	

-(void)libraryButtonPressed:(id)sender
{
	[self turnOffCamera];
	
	[self.navigationController setNavigationBarHidden:NO animated:NO];
	
	PhotoGridViewController *photoGridViewController = [[PhotoGridViewController alloc] init];
			
	[self.navigationController pushViewController:photoGridViewController animated:YES];
	[photoGridViewController release];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    [picker dismissModalViewControllerAnimated:YES];
		
//    imageView.image = image;
//    CGSize size = [imageView.image size];
//    CGRect cropRect = CGRectMake(0.0, 0.0, size.width, size.height);
//    NSLog(@"Original image size = (%f, %f)", size.width, size.height);
//	
//    NSValue *cropRectValue = [editingInfo objectForKey:@"UIImagePickerControllerCropRect"];
//    cropRect = [cropRectValue CGRectValue];
//    UIImageWriteToSavedPhotosAlbum(imageView.image, self, nil, nil);
	
	[self turnOffCamera];
	
	
	ApplyStickersViewController *applyStickersViewController = [[ApplyStickersViewController alloc] init];
	applyStickersViewController.photoImage = image;
	[self.navigationController setNavigationBarHidden:FALSE animated:NO];
	[self.navigationController pushViewController:applyStickersViewController animated:YES];
	[applyStickersViewController release];
} 

- (void)takePhoto 
{
	NSLog(@"taking photo");
	self.captureManager.delegate = self;
	[[self captureManager] captureStillImage];
    
	/* White flash for feedback */
	UIView *flashView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,480-47)];
    [flashView setBackgroundColor:[UIColor whiteColor]];
    [[[self view] window] addSubview:flashView];
    
    [UIView animateWithDuration:.3f
                     animations:^{
                         [flashView setAlpha:0.f];
                     }
                     completion:^(BOOL finished){
                         [flashView removeFromSuperview];
                         [flashView release];
                     }
     ];
	
}

-(void)photoCaptureSessionDidCaptureImage:(UIImage *)capturedImage
{
	[self turnOffCamera];
	
//	[DSBezelActivityView newActivityViewForView:self.view];
	
	[self.navigationController setNavigationBarHidden:NO animated:YES];

	ApplyStickersViewController *applyStickersViewController = [[ApplyStickersViewController alloc] init];
	
	applyStickersViewController.photoImage = [self cropImage:capturedImage withRect:CGRectMake(6,120,306,306)];
	[self.navigationController pushViewController:applyStickersViewController animated:YES];
	[applyStickersViewController release];
}

// get sub image http://stackoverflow.com/questions/2635371/how-to-crop-the-uiimage
- (UIImage*)cropImage: (UIImage*)img withRect:(CGRect)rect 
{
	//FUKKEN BUGS
	//this is effing up the right side
	//actually first we are going to resize the image
	
	if([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2)
	{
		//iPhone 4
		rect = CGRectMake(rect.origin.x * 2.0, rect.origin.y * 2.0, rect.size.width*2.0, rect.size.height*2.0);
	}
	   
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    // translated rectangle for drawing sub image 
	CGRect drawRect;
	if([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2)
	{
//		drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, img.size.width, img.size.height);
		drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, 624, 1110);
	} else {
		drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, img.size.width, img.size.height);
	}	
	
    // clip to the bounds of the image context
    // not strictly necessary as it will get clipped anyway?
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
	
    // draw image
	[img drawInRect:drawRect];
	//	[img drawAtPoint:CGPointMake(-rect.origin.x, -rect.origin.y)];
	
    // grab image
    UIImage* subImage = UIGraphicsGetImageFromCurrentImageContext();
	
    UIGraphicsEndImageContext();
	
    return subImage;
}

//- (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect
//{
//	//create a context to do our clipping in
//	UIGraphicsBeginImageContext(rect.size);
//	CGContextRef currentContext = UIGraphicsGetCurrentContext();
//	
//	//create a rect with the size we want to crop the image to
//	//the X and Y here are zero so we start at the beginning of our
//	//newly created context
//	CGRect clippedRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
//	CGContextClipToRect( currentContext, clippedRect);
//	
//	//create a rect equivalent to the full size of the image
//	//offset the rect by the X and Y we want to start the crop
//	//from in order to cut off anything before them
//	CGRect drawRect = CGRectMake(rect.origin.x * -1,
//								 rect.origin.y * -1,
//								 imageToCrop.size.width,
//								 imageToCrop.size.height);
//	
//	//draw the image to our clipped context using our offset rect
//	CGContextDrawImage(currentContext, drawRect, imageToCrop.CGImage);
//	
//	//pull the image from our cropped context
//	UIImage *cropped = UIGraphicsGetImageFromCurrentImageContext();
//	
//	//pop the context to get back to the default
//	UIGraphicsEndImageContext();
//	
//	//Note: this is autoreleased
//	return cropped;
//}

- (void)toggleCamera
{
	[[self captureManager] toggleCamera];
}

-(void)turnOffCamera
{
	[self.captureManager.captureSession stopRunning];
}

-(void)turnOnCamera
{
	[self.captureManager.captureSession startRunning];
}

#pragma mark -
#pragma mark AVCam sample code

// Convert from view coordinates to camera coordinates, where {0,0} represents the top left of the picture area, and {1,1} represents
// the bottom right in landscape mode with the home button on the right.
- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates 
{
    CGPoint pointOfInterest = CGPointMake(.5f, .5f);
    CGSize frameSize = self.captureManager.previewLayer.frame.size;
    
    if ([self.captureManager.previewLayer isMirrored]) {
        viewCoordinates.x = frameSize.width - viewCoordinates.x;
    }    
	
    if ( [[self.captureManager.previewLayer videoGravity] isEqualToString:AVLayerVideoGravityResize] ) {
		// Scale, switch x and y, and reverse x
        pointOfInterest = CGPointMake(viewCoordinates.y / frameSize.height, 1.f - (viewCoordinates.x / frameSize.width));
    } else {
        CGRect cleanAperture;
        for (AVCaptureInputPort *port in [[[self captureManager] videoInput] ports]) {
            if ([port mediaType] == AVMediaTypeVideo) {
                cleanAperture = CMVideoFormatDescriptionGetCleanAperture([port formatDescription], YES);
                CGSize apertureSize = cleanAperture.size;
                CGPoint point = viewCoordinates;
				
                CGFloat apertureRatio = apertureSize.height / apertureSize.width;
                CGFloat viewRatio = frameSize.width / frameSize.height;
                CGFloat xc = .5f;
                CGFloat yc = .5f;
                
                if ( [[self.captureManager.previewLayer videoGravity] isEqualToString:AVLayerVideoGravityResizeAspect] ) {
                    if (viewRatio > apertureRatio) {
                        CGFloat y2 = frameSize.height;
                        CGFloat x2 = frameSize.height * apertureRatio;
                        CGFloat x1 = frameSize.width;
                        CGFloat blackBar = (x1 - x2) / 2;
						// If point is inside letterboxed area, do coordinate conversion; otherwise, don't change the default value returned (.5,.5)
                        if (point.x >= blackBar && point.x <= blackBar + x2) {
							// Scale (accounting for the letterboxing on the left and right of the video preview), switch x and y, and reverse x
                            xc = point.y / y2;
                            yc = 1.f - ((point.x - blackBar) / x2);
                        }
                    } else {
                        CGFloat y2 = frameSize.width / apertureRatio;
                        CGFloat y1 = frameSize.height;
                        CGFloat x2 = frameSize.width;
                        CGFloat blackBar = (y1 - y2) / 2;
						// If point is inside letterboxed area, do coordinate conversion. Otherwise, don't change the default value returned (.5,.5)
                        if (point.y >= blackBar && point.y <= blackBar + y2) {
							// Scale (accounting for the letterboxing on the top and bottom of the video preview), switch x and y, and reverse x
                            xc = ((point.y - blackBar) / y2);
                            yc = 1.f - (point.x / x2);
                        }
                    }
                } else if ([[self.captureManager.previewLayer videoGravity] isEqualToString:AVLayerVideoGravityResizeAspectFill]) {
					// Scale, switch x and y, and reverse x
                    if (viewRatio > apertureRatio) {
                        CGFloat y2 = apertureSize.width * (frameSize.width / apertureSize.height);
                        xc = (point.y + ((y2 - frameSize.height) / 2.f)) / y2; // Account for cropped height
                        yc = (frameSize.width - point.x) / frameSize.width;
                    } else {
                        CGFloat x2 = apertureSize.height * (frameSize.height / apertureSize.width);
                        yc = 1.f - ((point.x + ((x2 - frameSize.width) / 2)) / x2); // Account for cropped width
                        xc = point.y / frameSize.height;
                    }
                }
                
                pointOfInterest = CGPointMake(xc, yc);
//				NSLog(@"point of interest: (%f, %f)", xc, yc);
                break;
            }
        }
    }
    
    return pointOfInterest;
}

// Auto focus at a particular point. The focus mode will change to locked once the auto focus happens.
- (void)tapToAutoFocus:(UIGestureRecognizer *)gestureRecognizer
{
    if ([[[self.captureManager videoInput] device] isFocusPointOfInterestSupported]) {
        CGPoint tapPoint = [gestureRecognizer locationInView:self.view];
//		NSLog(@"Tap Point: (%f, %f)", tapPoint.x, tapPoint.y);
        CGPoint convertedFocusPoint = [self convertToPointOfInterestFromViewCoordinates:tapPoint];
        [self.captureManager autoFocusAtPoint:convertedFocusPoint];
    }
}

// Change to continuous auto focus. The camera will constantly focus at the point choosen.
- (void)tapToContinouslyAutoFocus:(UIGestureRecognizer *)gestureRecognizer
{
    if ([[[self.captureManager videoInput] device] isFocusPointOfInterestSupported])
        [self.captureManager continuousFocusAtPoint:CGPointMake(.5f, .5f)];
}

#pragma mark -
#pragma mark Photo Preview

- (void)displayImagePreview 
{
	self.ppVC = [[PhotoPreviewViewController alloc] initWithPhoto:[[self captureManager] stillImage]];
	self.ppVC.delegate = self;
	[self.view addSubview:self.ppVC.view];
	
}

- (void)photoSelected:(UIImage *)selectedPhoto
{
	NSLog(@"photo selected");
	[self.delegate photoSelected:selectedPhoto];
	[self.view removeFromSuperview];
}

@end
