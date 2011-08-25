    //
//  ApplyStickersViewController.m
//  CutifyAppFrame
//
//  Created by Dan Lipert on 7/12/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import "ApplyStickersViewController.h"
#import "OptionsAndSharingViewController.h"
#import "IAPViewController.h"
#import "CutifyStickerPicker.h"
#import "CutifyStickerMeta.h"
#import "CutifyStickerView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ApplyStickersViewController

@synthesize photoImageView, photoImage, photoScrollView, stickerForReset, stickersArray, stickerContainerView, masterContainerView;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	//lets test and save the image first
//	UIImageWriteToSavedPhotosAlbum(self.photoImage, nil,nil,nil);
	
	NSMutableArray *_stickersArray = [[NSMutableArray alloc] init];
	self.stickersArray = _stickersArray;
	[_stickersArray release];
	
	//setup buttons
	UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
	UIImage *cancelButtonImage = [UIImage imageNamed:@"BackButton.png"];
	[cancelButton setFrame:CGRectMake(0,0,cancelButtonImage.size.width, cancelButtonImage.size.height)];
	[cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[cancelButton setImage:cancelButtonImage forState:UIControlStateNormal];
	UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
	
	self.navigationItem.leftBarButtonItem = cancelButtonItem;
	[cancelButtonItem release];
	
	UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
	UIImage *doneButtonImage = [UIImage imageNamed:@"DoneButton.png"];
	[doneButton setFrame:CGRectMake(0,0,doneButtonImage.size.width, doneButtonImage.size.height)];
	[doneButton addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[doneButton setImage:doneButtonImage forState:UIControlStateNormal];
	UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
	
	self.navigationItem.rightBarButtonItem = doneButtonItem;
	[doneButtonItem release];	
	
	UIImageView *photoImageBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TableviewBackground.png"]];
	[photoImageBackgroundView setFrame:CGRectMake(0,0,320,480-44-20)];
	[self.view addSubview:photoImageBackgroundView];
	[photoImageBackgroundView release];
	
	CutifyStickerPicker *picker = [[CutifyStickerPicker alloc] initWithFrame:CGRectMake(0,480-20-44-100,320,100)];
	picker.delegate = self;
	[self.view addSubview:picker];
	[picker release];
	
	//setup sticker container view
	UIView *_stickerContainerView = [[UIView alloc] initWithFrame:CGRectMake(7, 5, 306, 306)];
	self.stickerContainerView = _stickerContainerView;
	[_stickerContainerView release];
	
	UIView *_masterContainerView = [[UIView alloc] initWithFrame:CGRectMake(7,5,306,306)];
	self.masterContainerView = _masterContainerView;
	[_masterContainerView release];
	
	//setup scrollview
	UIScrollView *_photoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(7,5,306,306)];
	self.photoScrollView = _photoScrollView;
	[_photoScrollView release];
	
	[self.photoScrollView setDelegate:self];
	[self.photoScrollView setMinimumZoomScale:1.0];
	[self.photoScrollView setMaximumZoomScale:2.0];
	
	UIImageView *_photoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ApplyStickerImage.png"]];
	self.photoImageView = _photoImageView;
	[_photoImageView release];
	
	//add shadow
	self.photoImageView.layer.masksToBounds = NO;
	//	self.photoImageView.layer.cornerRadius = 8; // if you like rounded corners
	self.photoImageView.layer.shadowOffset = CGSizeMake(2,2);
	self.photoImageView.layer.shadowRadius = 1;
	self.photoImageView.layer.shadowOpacity = 0.5;
	
	[self.photoImageView setFrame:CGRectMake(7,5,306,306)];
	self.photoImageView.image = self.photoImage;
	[self.photoImageView setContentMode:UIViewContentModeScaleAspectFit];
	
	//compose master container view
	[self.masterContainerView addSubview:self.photoImageView];
	[self.masterContainerView addSubview:self.stickerContainerView];
	
	[self.photoScrollView setContentSize:self.photoImageView.frame.size];
	[self.photoScrollView addSubview:self.masterContainerView];
	[self.photoScrollView setDelaysContentTouches:FALSE];
	[self.photoScrollView setCanCancelContentTouches:TRUE];
	
	CGFloat offsetX = (self.photoScrollView.bounds.size.width > self.photoScrollView.contentSize.width)? 
	(self.photoScrollView.bounds.size.width - self.photoScrollView.contentSize.width) * 0.5 : 0.0;
	CGFloat offsetY = (self.photoScrollView.bounds.size.height > self.photoScrollView.contentSize.height)? 
	(self.photoScrollView.bounds.size.height - self.photoScrollView.contentSize.height) * 0.5 : 0.0;
	
	self.photoImageView.center = CGPointMake(self.photoScrollView.contentSize.width * 0.5 + offsetX, 
								   self.photoScrollView.contentSize.height * 0.5 + offsetY);
	
	[self.photoScrollView setMaximumZoomScale:3.0];
	[self.photoScrollView setMinimumZoomScale:1.0];
	
	[self.view addSubview:self.photoScrollView];
	
//	UIButton *iapButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//	[iapButton setTitle:@"In-App Purchase" forState:UIControlStateNormal];
//	[iapButton setFrame:CGRectMake(10,480-20-44-100+30,44,44)];
//	[iapButton addTarget:self action:@selector(iapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//	[self.view addSubview:iapButton];
	

	
}

#pragma mark -
#pragma mark scrollview

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{	
	[self resetCenter];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	if(self.masterContainerView)
	{
		return self.masterContainerView;
	} else {
		return nil;
	}
}

-(void)resetCenter
{
	//added offset for frame being inset 7 pixels
	CGFloat offsetX = (self.photoScrollView.bounds.size.width > self.photoScrollView.contentSize.width)? 
	(self.photoScrollView.bounds.size.width - self.photoScrollView.contentSize.width + 7) * 0.5 : 0.0;
    CGFloat offsetY = (self.photoScrollView.bounds.size.height > self.photoScrollView.contentSize.height)? 
	(self.photoScrollView.bounds.size.height - self.photoScrollView.contentSize.height) * 0.5 : 0.0;
	
	self.masterContainerView.center = CGPointMake(self.photoScrollView.contentSize.width * 0.5 + offsetX, 
                                   self.photoScrollView.contentSize.height * 0.5 + offsetY);
	
}


-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self.navigationController setToolbarHidden:YES animated:YES];
}

-(void)cancelButtonPressed:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)doneButtonPressed:(id)sender
{
	OptionsAndSharingViewController *optionsAndSharingViewController = [[OptionsAndSharingViewController alloc] initWithStyle:UITableViewStyleGrouped];
	
	UIGraphicsBeginImageContext(self.photoImage.size);
	NSLog(@"created ctx with size: %f, %f", self.photoImage.size.width, self.photoImage.size.height);
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	[self.photoImage drawInRect:CGRectMake(0, 0, self.photoImage.size.width, self.photoImage.size.height)];  

	for(CutifyStickerView *eachStickerView in self.stickersArray)
	{
<<<<<<< HEAD
		//new code using createImageFromBackgroundImageView
		float scale = eachStickerView.scale;
		float rotationDegrees = eachStickerView.rotationDegrees;
		
		//create fake imageview for method
		UIImageView *mergedImageView = [[UIImageView alloc] initWithImage:mergedImage];
		
		mergedImage = [self createImageFromBackgroundImageView:mergedImageView andOverlayImageView:eachStickerView withRotationDegrees:&rotationDegrees andScale:&scale];
		[mergedImageView setImage:mergedImage];

		[mergedImageView release];
=======
		CGContextSaveGState(ctx);

//		eachStickerView.layer.anchorPoint = CGPointMake(0.5, 0.5);
		
		if([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2)
		{
			NSLog(@"rendering sticker %fx%f at (%f, %f)", eachStickerView.frame.size.width * 2.0, eachStickerView.frame.size.height * 2.0, eachStickerView.frame.origin.y*2.0, eachStickerView.frame.origin.y*2.0);

			CGContextTranslateCTM (ctx, eachStickerView.centerPoint.x * 2.0, eachStickerView.centerPoint.y * 2.0);		
//			CGContextTranslateCTM (ctx, eachStickerView.center.x * 2.0, eachStickerView.center.y * 2.0);			
			CGContextRotateCTM(ctx, eachStickerView.rotationDegrees* M_PI/180.0);
//			[eachStickerView.stickerImageView.image drawInRect:CGRectMake(eachStickerView.frame.origin.x * 2.0, eachStickerView.frame.origin.y * 2.0, eachStickerView.stickerImageView.image.size.width * eachStickerView.scale * 2.0, eachStickerView.stickerImageView.image.size.height * eachStickerView.scale * 2.0)];
			[eachStickerView.stickerImageView.image drawInRect:CGRectMake(sqrtf(eachStickerView.frame.origin.x * eachStickerView.frame.origin.x + eachStickerView.frame.origin.y * eachStickerView.frame.origin.y), eachStickerView.frame.origin.y * 1/(cosf(eachStickerView.rotationDegrees * M_PI/180.0)), eachStickerView.stickerImageView.image.size.width * eachStickerView.scale * 2.0, eachStickerView.stickerImageView.image.size.height * eachStickerView.scale * 2.0)];
//			[eachStickerView.stickerImageView.image drawInRect:CGRectMake(eachStickerView.frame.origin.x, eachStickerView.frame.origin.y, eachStickerView.stickerImageView.image.size.width * eachStickerView.scale * 2.0, eachStickerView.stickerImageView.image.size.height * eachStickerView.scale * 2.0)];
			CGContextTranslateCTM (ctx, -eachStickerView.centerPoint.x * 2.0, -eachStickerView.centerPoint.y * 2.0);
			
			//iPhone 4
			//changed draw in rect to draw imageview frame instead of parent frame
//			[eachStickerView.stickerImageView.image drawInRect:CGRectMake(eachStickerView.frame.origin.x * 2.0, eachStickerView.frame.origin.y * 2.0, eachStickerView.stickerImageView.image.size.width * eachStickerView.scale * 2.0, eachStickerView.stickerImageView.image.size.height * eachStickerView.scale * 2.0)];
//			[eachStickerView.stickerImageView.image drawInRect:CGRectMake(eachStickerView.frame.origin.x * 2.0, eachStickerView.frame.origin.y * 2.0, eachStickerView.stickerImageView.frame.size.width * 2.0, eachStickerView.stickerImageView.frame.size.height * 2.0)];
			NSLog(@"rendered sticker %fx%f at (%f, %f)", eachStickerView.frame.size.width * 2.0, eachStickerView.frame.size.height * 2.0, eachStickerView.frame.origin.y*2.0, eachStickerView.frame.origin.y*2.0);
		} else {
			//BUG - this part is untested
//			CGContextTranslateCTM (ctx, eachStickerView.center.x, eachStickerView.center.y);			
	//		CGContextRotateCTM(ctx, eachStickerView.rotationDegrees * M_PI/180.0);
//			CGContextTranslateCTM (ctx, -eachStickerView.center.x, -eachStickerView.center.y);
//			
//			[eachStickerView.stickerImageView.image drawInRect:CGRectMake(eachStickerView.frame.origin.x, eachStickerView.frame.origin.y, eachStickerView.frame.size.width, eachStickerView.frame.size.height)];
		}
		
		CGContextRestoreGState(ctx);
>>>>>>> 46f514e2ac9de3f3ea3cbb3239e4ecfd0aca0578
	}
		
	UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();  
	
<<<<<<< HEAD
	optionsAndSharingViewController.image = mergedImage;
=======
	optionsAndSharingViewController.image = resultingImage;
>>>>>>> 46f514e2ac9de3f3ea3cbb3239e4ecfd0aca0578
	[self.navigationController pushViewController:optionsAndSharingViewController animated:YES]; 
	[optionsAndSharingViewController release];
}

<<<<<<< HEAD

//THIS CODE SHOULD WORK
-(UIImage *)createImageFromBackgroundImageView:(UIImageView *)backgroundImageView andOverlayImageView:(UIImageView *)overlayImageView withRotationDegrees:(CGFloat *)rotationDegrees andScale:(CGFloat *)scalePointer
{		
	CGFloat scale = *scalePointer;
	
	UIGraphicsBeginImageContext(backgroundImageView.image.size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	//corrected for explicit drawrect
	CGContextTranslateCTM(ctx, overlayImageView.center.x * 2.0, overlayImageView.center.y * 2.0); 
	//	CGContextTranslateCTM(ctx, drawRect.origin.x * 2.0 + overlayImageView.image.size.width / 2.0 * scale, drawRect.origin.y * 2.0 + overlayImageView.image.size.height / 2.0 * scale); 
	
	CGFloat angle = *rotationDegrees * M_PI/180.0f;    
	CGContextRotateCTM(ctx, angle);  
	
	[overlayImageView.image drawInRect:CGRectMake(0 - overlayImageView.image.size.width * scale / 2.0, 0 - overlayImageView.image.size.height * scale / 2.0, overlayImageView.image.size.width * scale, overlayImageView.image.size.height * scale)];
	
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	UIGraphicsBeginImageContext(backgroundImageView.image.size);
	[backgroundImageView.image drawInRect:CGRectMake(0, 0, backgroundImageView.image.size.width, backgroundImageView.image.size.height)];    
	[newImage drawInRect:CGRectMake(0, 0, newImage.size.width, newImage.size.height)];
	
	UIImage *newImage2 = UIGraphicsGetImageFromCurrentImageContext();    
	UIGraphicsEndImageContext();    
	
	return newImage2;
}


//THIS CODE SHOULD NOT WORK
-(UIImage *)createImageFromBackgroundImageView:(UIImageView *)backgroundImageView andOverlayImageView:(UIImageView *)overlayImageView withRotationDegrees:(CGFloat *)rotationDegrees andScale:(CGFloat *)scalePointer atRect:(CGRect)drawRect
{		
	CGFloat scale = *scalePointer;
	
	UIGraphicsBeginImageContext(backgroundImageView.image.size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();

	//corrected for explicit drawrect
//	CGContextTranslateCTM(ctx, overlayImageView.frame.origin.x * 2.0 + overlayImageView.image.size.width / 2.0 * scale, overlayImageView.frame.origin.y * 2.0 + overlayImageView.image.size.height / 2.0 * scale); 
	CGContextTranslateCTM(ctx, drawRect.origin.x * 2.0 + overlayImageView.image.size.width / 2.0 * scale, drawRect.origin.y * 2.0 + overlayImageView.image.size.height / 2.0 * scale); 
	
	CGFloat angle = *rotationDegrees * M_PI/180.0f;    
	CGContextRotateCTM(ctx, angle);  
	
	[overlayImageView.image drawInRect:CGRectMake(0 - overlayImageView.image.size.width * scale / 2.0, 0 - overlayImageView.image.size.height * scale / 2.0, overlayImageView.image.size.width * scale, overlayImageView.image.size.height * scale)];
	
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	UIGraphicsBeginImageContext(backgroundImageView.image.size);
	[backgroundImageView.image drawInRect:CGRectMake(0, 0, backgroundImageView.image.size.width, backgroundImageView.image.size.height)];    
	[newImage drawInRect:CGRectMake(0, 0, newImage.size.width, newImage.size.height)];
	
	UIImage *newImage2 = UIGraphicsGetImageFromCurrentImageContext();    
	UIGraphicsEndImageContext();    
	
	return newImage2;
}

- (UIImage *)mergeImage:(UIImage *)bottomImg withSticker:(CutifyStickerView *)stickerView {
//	
////	UIImage *scaledTopImg = [stickerView.stickerImageView.image resizedImage:photoImage.size interpolationQuality:kCGInterpolationHigh];
//	
//	//first figure correct rect size to draw for rotated image	
////	float width = scaledTopImg.size.width;
////	float height = scaledTopImg.size.height;
////	CGFloat angleRads = stickerView.rotationDegrees * M_PI/180.0f;
////	CGSize stickerContextSize = CGSizeMake( width * cosf(angleRads) + height * cosf(M_PI/2.0 - angleRads), width * sinf(angleRads) + height * sinf(M_PI/2.0 - angleRads));
//		
//	//create large context
//	
//	UIGraphicsBeginImageContext(bottomImg.size);
//	CGContextRef ctx = UIGraphicsGetCurrentContext();
//
//	//THIS WORKS! rotation still 'broken'
//	CGContextTranslateCTM(ctx, stickerView.frame.origin.x * 2.0 + stickerView.stickerImageView.image.size.width / 2.0 * stickerView.scale, stickerView.frame.origin.y * 2.0  + stickerView.stickerImageView.image.size.height / 2.0 * stickerView.scale); 
//
////	[stickerView.stickerImageView.image drawInRect:CGRectMake(0, 0, stickerView.stickerImageView.image.size.width * stickerView.scale, stickerView.stickerImageView.image.size.height * stickerView.scale)];
////	[stickerView.stickerImageView.image drawInRect:CGRectMake(-stickerView.stickerImageView.image.size.width * stickerView.scale / 2.0, -stickerView.stickerImageView.image.size.height * stickerView.scale / 2.0, stickerView.stickerImageView.image.size.width * stickerView.scale, stickerView.stickerImageView.image.size.height * stickerView.scale)];
//
//	CGFloat angle = stickerView.rotationDegrees * M_PI/180.0f;    
//	CGContextRotateCTM(ctx, angle);  
////	[stickerView.stickerImageView.image drawInRect:CGRectMake(-stickerView.stickerImageView.image.size.width * stickerView.scale / 2.0, -stickerView.stickerImageView.image.size.height * stickerView.scale / 2.0, stickerView.stickerImageView.image.size.width * stickerView.scale, stickerView.stickerImageView.image.size.height * stickerView.scale)];
//	[stickerView.stickerImageView.image drawInRect:CGRectMake(0 -stickerView.stickerImageView.image.size.width * stickerView.scale / 2.0, 0 -stickerView.stickerImageView.image.size.height * stickerView.scale / 2.0, stickerView.stickerImageView.image.size.width * stickerView.scale, stickerView.stickerImageView.image.size.height * stickerView.scale)];
//
//	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//	UIGraphicsEndImageContext();
//	
//	UIGraphicsBeginImageContext(bottomImg.size);
//	[bottomImg drawInRect:CGRectMake(0, 0, bottomImg.size.width, bottomImg.size.height)];    
//	[newImage drawInRect:CGRectMake(0, 0, newImage.size.width, newImage.size.height)];
////	[stickerView.layer renderInContext:UIGraphicsGetCurrentContext()];
//	UIImage *newImage2 = UIGraphicsGetImageFromCurrentImageContext();    
//	UIGraphicsEndImageContext();    
//	
//	return newImage2;
}
	

//-(UIImage *)createImageFromBackgroundImageView:(UIImageView *)backgroundImageView andOverlayImageView:(UIImageView *)overlayImageView withRotationDegrees:(CGFloat *)rotationDegrees andScale:(CGFloat *)scalePointer
//{		
//	CGFloat scale = *scalePointer;
//	
//	UIGraphicsBeginImageContext(backgroundImageView.image.size);
//	CGContextRef ctx = UIGraphicsGetCurrentContext();
//	
//	CGContextTranslateCTM(ctx, overlayImageView.frame.origin.x * 2.0 + overlayImageView.image.size.width / 2.0 * scale, overlayImageView.frame.origin.y * 2.0 + overlayImageView.image.size.height / 2.0 * scale); 
//	
//	CGFloat angle = *rotationDegrees * M_PI/180.0f;    
//	CGContextRotateCTM(ctx, angle);  
//	
//	[overlayImageView.image drawInRect:CGRectMake(0 - overlayImageView.image.size.width * scale / 2.0, 0 - overlayImageView.image.size.height * scale / 2.0, overlayImageView.image.size.width * scale, overlayImageView.image.size.height * scale)];
//	
//	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//	UIGraphicsEndImageContext();
//	
//	UIGraphicsBeginImageContext(backgroundImageView.image.size);
//	[backgroundImageView.image drawInRect:CGRectMake(0, 0, backgroundImageView.image.size.width, backgroundImageView.image.size.height)];    
//	[newImage drawInRect:CGRectMake(0, 0, newImage.size.width, newImage.size.height)];
//	
//	UIImage *newImage2 = UIGraphicsGetImageFromCurrentImageContext();    
//	UIGraphicsEndImageContext();    
//	
//	return newImage2;
//}\

//-(void)doneButtonPressed:(id)sender
//{
//	OptionsAndSharingViewController *optionsAndSharingViewController = [[OptionsAndSharingViewController alloc] initWithStyle:UITableViewStyleGrouped];
//	
//	UIGraphicsBeginImageContext(self.photoImage.size);
//	NSLog(@"created ctx with size: %f, %f", self.photoImage.size.width, self.photoImage.size.height);
//	
//	CGContextRef ctx = UIGraphicsGetCurrentContext();
//	
//	[self.photoImage drawInRect:CGRectMake(0, 0, self.photoImage.size.width, self.photoImage.size.height)];  
//
//	for(CutifyStickerView *eachStickerView in self.stickersArray)
//	{
//		CGContextSaveGState(ctx);
//
//		
//		if([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2)
//		{
//			CGContextTranslateCTM (ctx, eachStickerView.centerPoint.x * 2.0, eachStickerView.centerPoint.y * 2.0);		
//			CGContextRotateCTM(ctx, eachStickerView.rotationDegrees* M_PI/180.0);
//			CGContextTranslateCTM (ctx, -eachStickerView.centerPoint.x * 2.0, -eachStickerView.centerPoint.y * 2.0);
//						
//			CGRect drawRect = CGRectMake((eachStickerView.centerPoint.x - eachStickerView.stickerImageView.image.size.width * 0.5 * eachStickerView.scale) * 2.0, (eachStickerView.centerPoint.y - eachStickerView.stickerImageView.image.size.height * 0.5 * eachStickerView.scale) * 2.0, eachStickerView.stickerImageView.image.size.width * eachStickerView.scale, eachStickerView.stickerImageView.image.size.height * eachStickerView.scale);
//			
//			NSLog(@"Drawing at (%f, %f) c:(%f, %f)", drawRect.origin.x, drawRect.origin.y, eachStickerView.center.x, eachStickerView.center.y);
//			
//			[eachStickerView.stickerImageView.image drawInRect:drawRect];
//
//		} else {
//			//BUG - this part needs to be coded
//		}
//		
//		CGContextRestoreGState(ctx);
//	}
//		
//	UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();  
//	
//	optionsAndSharingViewController.image = resultingImage;
//	[self.navigationController pushViewController:optionsAndSharingViewController animated:YES]; 
//	[optionsAndSharingViewController release];
//}

=======
>>>>>>> 46f514e2ac9de3f3ea3cbb3239e4ecfd0aca0578
-(void)iapButtonPressed:(id)sender
{
//	IAPViewController *iapViewController = [[IAPViewController alloc] init];
//	[self.navigationController pushViewController:iapViewController animated:YES];
//	[iapViewController release];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PRERELEASE" message:@"In-app purchase is not yet implemented." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

-(void)stickerPickerDidPickSticker:(CutifyStickerMeta *)stickerMeta
{
	NSLog(@"delegate called");
	
	CutifyStickerView *stickerView = [[CutifyStickerView alloc] initWithStickerMeta:stickerMeta];
	[self addGestureRecognizersToSticker:stickerView];
	[stickerView setFrame:CGRectMake(0,0,stickerView.frame.size.width/2.0, stickerView.frame.size.height/2.0)];
	[stickerView setCenter:self.view.center];
	[stickerView setUserInteractionEnabled:YES];
	[self.masterContainerView addSubview:stickerView];
	[self.stickersArray addObject:stickerView];
	[stickerView release];
}

#pragma mark -
#pragma mark interaction

- (void)addGestureRecognizersToSticker:(CutifyStickerView *)sticker
{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panSticker:)];
    [panGesture setMaximumNumberOfTouches:2];
    [panGesture setDelegate:self];
    [sticker addGestureRecognizer:panGesture];
    [panGesture release];
	
	UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaleSticker:)];
	[pinchGesture setDelegate:self];
	[sticker addGestureRecognizer:pinchGesture];
	[pinchGesture release];
	
	UIRotationGestureRecognizer *rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateSticker:)];
	[rotateGesture setDelegate:self];
	[sticker addGestureRecognizer:rotateGesture];
	[rotateGesture release];
	
	UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showResetMenu:)];
    [longPressGesture setDelegate:self];
	[sticker addGestureRecognizer:longPressGesture];
    [longPressGesture release];
}

- (void)panSticker:(UIPanGestureRecognizer *)gestureRecognizer
{
	NSLog(@"Panning sticker...");
    CutifyStickerView *sticker = (CutifyStickerView *)[gestureRecognizer view];
	
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) 
	{
        CGPoint translation = [gestureRecognizer translationInView:[sticker superview]];
		
		if([self.view pointInside:CGPointMake([sticker center].x + translation.x, [sticker center].y + translation.y) withEvent:nil])
		{
			[CATransaction begin]; 
			[CATransaction setValue: (id) kCFBooleanTrue forKey: kCATransactionDisableActions];
			[sticker setCenter:CGPointMake([sticker center].x + translation.x, [sticker center].y + translation.y)];
			[CATransaction commit];
			
			[sticker setCenterPoint:sticker.center];
			
			[gestureRecognizer setTranslation:CGPointZero inView:[sticker superview]];
		} else {
			//do not move past borders
		}
    } else if([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
		
	}
	
	[self.photoScrollView reloadInputViews];
}

- (void)scaleSticker:(UIPinchGestureRecognizer *)gestureRecognizer
{
	//    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    if(gestureRecognizer.scale != 0)
	{
		if((gestureRecognizer.view.frame.size.width > 40) && (gestureRecognizer.view.frame.size.height > 40))
		{
			if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
				CutifyStickerView *sticker = (CutifyStickerView *)[gestureRecognizer view];
				sticker.transform = CGAffineTransformScale([[gestureRecognizer view] transform], [gestureRecognizer scale], [gestureRecognizer scale]);
				sticker.scale = gestureRecognizer.scale;
				[gestureRecognizer setScale:1];
			}
		}
	}
	
	[self.photoScrollView reloadInputViews];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	//	if (gestureRecognizer.view != firstPieceView && gestureRecognizer.view != secondPieceView && gestureRecognizer.view != thirdPieceView)
	//			return NO;
    
    // if the gesture recognizers are on different views, don't allow simultaneous recognition
    if (gestureRecognizer.view != otherGestureRecognizer.view)
        return NO;
    
    // if either of the gesture recognizers is the long press, don't allow simultaneous recognition
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] || [otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
        return NO;
    
    return YES;
}

- (void)showResetMenu:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        UIMenuItem *resetMenuItem = [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(deleteSticker:)];
		//		UIMenuItem *sendToBackItem = [[UIMenuItem alloc] initWithTitle:@"Send To Back" action:@selector(sendToBackPiece:)];
		//		UIMenuItem *bringToFrontItem = [[UIMenuItem alloc] initWithTitle:@"Bring To Front" action:@selector(bringToFrontPiece:)];
        CGPoint location = [gestureRecognizer locationInView:[gestureRecognizer view]];
        
        [self becomeFirstResponder];
		//        [menuController setMenuItems:[NSArray arrayWithObjects:resetMenuItem, sendToBackItem, bringToFrontItem, nil]];
		[menuController setMenuItems:[NSArray arrayWithObject:resetMenuItem]];
        [menuController setTargetRect:CGRectMake(location.x, location.y, 0, 0) inView:[gestureRecognizer view]];
        [menuController setMenuVisible:YES animated:YES];
        
        self.stickerForReset = (CutifyStickerView *)[gestureRecognizer view];
        
        [resetMenuItem release];
		//		[sendToBackItem release];
		//		[bringToFrontItem release];
    }
}

- (void)deleteSticker:(id)sender
{
	[self.stickerForReset removeFromSuperview];
	[stickersArray removeObject:self.stickerForReset];
}

-(BOOL)canBecomeFirstResponder
{
	return YES;
}

- (BOOL) canPerformAction:(SEL)selector withSender:(id) sender 
{
	if(selector == @selector(deleteSticker:))
	{
		return YES;
	} else {
		return NO;
	}
}

- (void)rotateSticker:(UIRotationGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        [gestureRecognizer view].transform = CGAffineTransformRotate([[gestureRecognizer view] transform], [gestureRecognizer rotation]);
		CutifyStickerView *sticker = (CutifyStickerView *)[gestureRecognizer view];
		//		piece.pieceInfo.rotationDegrees = piece.pieceInfo.rotationDegrees + ([gestureRecognizer rotation] * 57.2958);
		//		piece.pieceInfo.rotationDegrees = fmodf(piece.pieceInfo.rotationDegrees, 360.0f);
		//		NSLog(@"piece rotated %f degrees", piece.pieceInfo.rotationDegrees);
		
		CGAffineTransform t = CGAffineTransformRotate(sticker.transform, [gestureRecognizer rotation]);
		sticker.transform = t;
		sticker.rotationDegrees = fmodf([gestureRecognizer rotation] * 360.0/M_PI + sticker.rotationDegrees, 360.0f);
		NSLog(@"Rotation of sticker: %f",sticker.rotationDegrees);
        [gestureRecognizer setRotation:0];
	}
	
	[self.photoScrollView reloadInputViews];

   // } else if([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
//		[gestureRecognizer view].transform = CGAffineTransformRotate([[gestureRecognizer view] transform], [gestureRecognizer rotation]);
//		CutifyStickerView *sticker = (CutifyStickerView *)[gestureRecognizer view];
//		CGAffineTransform t = CGAffineTransformRotate(sticker.transform, [gestureRecognizer rotation]);
//		sticker.transform = t;
//		sticker.rotationDegrees = [NSNumber numberWithFloat:[gestureRecognizer rotation] * 180.0/M_PI];
//		NSLog(@"Rotation of sticker: %f", [sticker.rotationDegrees floatValue]);
//        [gestureRecognizer setRotation:0];
//	}
		
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.photoImageView = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
