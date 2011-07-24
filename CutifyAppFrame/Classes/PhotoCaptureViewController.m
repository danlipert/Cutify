//
//  PhotoCaptureViewController.m
//  LuchaLibreUSA
//
//  Created by Dave Sluder on 7/16/11.
//  Copyright 2011 Dave Sluder. All rights reserved.
//

#import "PhotoCaptureViewController.h"
#import "ApplyStickersViewController.h"

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
	
	/* If you want an overlay * /
	UIImageView *overlayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay2.png"]];
	[overlayImageView setFrame:CGRectMake(0, 30, 320, 380)];
	[[self view] addSubview:overlayImageView];
	[overlayImageView release];
	*/
	
	UIButton *toggleCameraButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[toggleCameraButton setTitle:@"Toggle Camera" forState:UIControlStateNormal];
	[toggleCameraButton setFrame:CGRectMake(202, 8, 112, 30)];
	[toggleCameraButton addTarget:self action:@selector(toggleCamera) forControlEvents:UIControlEventTouchUpInside];
	[[self view] addSubview:toggleCameraButton];
	
	UIButton *takePhotoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[takePhotoButton setFrame:CGRectMake(130, 426-44, 60, 30)];
	[takePhotoButton setTitle:@"Photo" forState:UIControlStateNormal];
	[takePhotoButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
	[[self view] addSubview:takePhotoButton];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayImagePreview) name:kImageCapturedSuccessfully object:nil];
	[[captureManager captureSession] startRunning];
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
	ApplyStickersViewController *applyStickersViewController = [[ApplyStickersViewController alloc] init];
	applyStickersViewController.photoImage = capturedImage;
	[self.navigationController pushViewController:applyStickersViewController animated:YES];
	[applyStickersViewController release];
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
