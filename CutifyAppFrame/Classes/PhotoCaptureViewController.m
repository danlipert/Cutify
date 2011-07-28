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

@interface PhotoCaptureViewController()


- (void)takePhoto;
- (void)toggleCamera;
@end



@implementation PhotoCaptureViewController

@synthesize captureManager;
@synthesize delegate;
@synthesize ppVC;

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
	[self.navigationController setNavigationBarHidden:YES animated:NO];
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
	[toolBarView setFrame:CGRectMake(0,480-20-44, 320, 53)];
	[self.view addSubview:toolBarView];
	[toolBarView release];
	
	
	UIButton *toggleCameraButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[toggleCameraButton setTitle:@"Toggle Camera" forState:UIControlStateNormal];
	[toggleCameraButton setFrame:CGRectMake(202, 8, 112, 30)];
	[toggleCameraButton addTarget:self action:@selector(toggleCamera) forControlEvents:UIControlEventTouchUpInside];
	[[self view] addSubview:toggleCameraButton];
	
	UIButton *takePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[takePhotoButton setImage:[UIImage imageNamed:@"CameraScreenButton.png"] forState:UIControlStateNormal];
	[takePhotoButton setFrame:CGRectMake((320-101)/2,480-20-44, 101, 43)];
	[takePhotoButton setTitle:@"Photo" forState:UIControlStateNormal];
	[takePhotoButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
	[[self view] addSubview:takePhotoButton];
	
	UIButton *libraryButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[libraryButton setFrame:CGRectMake(10,480-20-44,100,43)];
	[libraryButton setTitle:@"Library" forState:UIControlStateNormal];
	[libraryButton addTarget:self action:@selector(libraryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:libraryButton];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayImagePreview) name:kImageCapturedSuccessfully object:nil];
	[[captureManager captureSession] startRunning];
}

-(void)libraryButtonPressed:(id)sender
{
	[self.navigationController setNavigationBarHidden:NO animated:NO];

	PhotoGridViewController *photoGridViewController = [[PhotoGridViewController alloc] init];
	[self.navigationController pushViewController:photoGridViewController animated:YES];
	[photoGridViewController release];
}

- (void)takePhoto 
{
	NSLog(@"taking photo");
	self.captureManager.delegate = self;
	[[self captureManager] captureStillImage];
    
	/* White flash for feedback */
	UIView *flashView = [[UIView alloc] initWithFrame:self.view.frame];
    [flashView setBackgroundColor:[UIColor whiteColor]];
    [[[self view] window] addSubview:flashView];
    
    [UIView animateWithDuration:.4f
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
	[self.navigationController setNavigationBarHidden:NO animated:NO];

	ApplyStickersViewController *applyStickersViewController = [[ApplyStickersViewController alloc] init];
	applyStickersViewController.photoImage = [self cropImage:capturedImage withRect:CGRectMake(8,63,306,306)];
	[self.navigationController pushViewController:applyStickersViewController animated:YES];
	[applyStickersViewController release];
}

// get sub image http://stackoverflow.com/questions/2635371/how-to-crop-the-uiimage
- (UIImage*)cropImage: (UIImage*)img withRect:(CGRect)rect 
{
	if([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2)
	{
		//iPhone 4
		rect = CGRectMake(rect.origin.x * 2.0, rect.origin.y * 2.0, rect.size.width*2.0, rect.size.height*2.0);
	}
	   
	
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    // translated rectangle for drawing sub image 
    CGRect drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, img.size.width, img.size.height);
	
    // clip to the bounds of the image context
    // not strictly necessary as it will get clipped anyway?
//    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
	
    // draw image
//    [img drawInRect:drawRect];
	[img drawAtPoint:CGPointMake(-rect.origin.x, -rect.origin.y)];
	
	
    // grab image
    UIImage* subImage = UIGraphicsGetImageFromCurrentImageContext();
	
    UIGraphicsEndImageContext();
	
    return subImage;
}


- (void)toggleCamera
{
	[[self captureManager] toggleCamera];
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
