    //
//  ApplyStickersViewController.m
//  CutifyAppFrame
//
//  Created by Dan Lipert on 7/12/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import "ApplyStickersViewController.h"
#import "OptionsAndSharingViewController.h"
#import "CutifyStickerMeta.h"
#import "CutifyStickerView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ApplyStickersViewController

@synthesize photoImageView, photoImage, photoScrollView, stickerForReset, stickersArray, stickerContainerView, masterContainerView;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSMutableArray *_stickersArray = [[NSMutableArray alloc] init];
	self.stickersArray = _stickersArray;
	[_stickersArray release];
		
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
	
	//setup sticker container view
	UIView *_stickerContainerView = [[UIView alloc] initWithFrame:CGRectMake(7, 5, 306, 306)];
	self.stickerContainerView = _stickerContainerView;
	[_stickerContainerView release];
	
	UIView *_masterContainerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,320)];
	self.masterContainerView = _masterContainerView;
	[_masterContainerView release];
	
	//setup scrollview
	UIScrollView *_photoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(7,5,306,306)];
	self.photoScrollView = _photoScrollView;
	[_photoScrollView release];
	
	[self.photoScrollView setDelegate:self];
	[self.photoScrollView setMinimumZoomScale:1.0];
	[self.photoScrollView setMaximumZoomScale:2.0];
	
	UIImageView *_photoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]];
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
	
	[self.view addSubview:self.photoScrollView];
	
	CutifyStickerMeta *stickerMeta = [[CutifyStickerMeta alloc] init];
	[stickerMeta setStickerImage:[UIImage imageNamed:@"EmoticonDisappointed2.png"]];
	[self stickerPickerDidPickSticker:stickerMeta];
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
	CGFloat offsetX = (self.photoScrollView.bounds.size.width > self.photoScrollView.contentSize.width)? 
	(self.photoScrollView.bounds.size.width - self.photoScrollView.contentSize.width) * 0.5 : 0.0;
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
	
	UIImage *mergedImage = [UIImage imageWithCGImage:[self.photoImage CGImage]];
	
	for(CutifyStickerView *eachStickerView in self.stickersArray)
	{
		//new code using createImageFromBackgroundImageView
		float scale = eachStickerView.scale;
		float rotationDegrees = eachStickerView.rotationDegrees;
		
		//create fake imageview for method
		UIImageView *mergedImageView = [[UIImageView alloc] initWithImage:mergedImage];
		
		CGRect drawRect = [eachStickerView frame]; 
//		for(int i = 0; i < 8; i++)
//		{
//			rotationDegrees = i*360/8;
			mergedImage = [self createImageFromBackgroundImageView:mergedImageView andOverlayImageView:eachStickerView withRotationDegrees:&rotationDegrees andScale:&scale atOriginPoint:eachStickerView.originPoint];
			[mergedImageView setImage:mergedImage];
//		}
		[mergedImageView release];
	}
	optionsAndSharingViewController.image = mergedImage;
	[self.navigationController pushViewController:optionsAndSharingViewController animated:YES]; 
	[optionsAndSharingViewController release];
}

//THIS CODE SHOULD WORK
-(UIImage *)createImageFromBackgroundImageView:(UIImageView *)backgroundImageView andOverlayImageView:(UIImageView *)overlayImageView withRotationDegrees:(CGFloat *)rotationDegrees andScale:(CGFloat *)scalePointer atOriginPoint:(CGPoint)originPoint
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
						
//			[sticker setCenterPoint:sticker.center];
//			[sticker.stickerImageView setFrame:sticker.frame];
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
				sticker.scale = gestureRecognizer.scale * sticker.scale;
				sticker.transform = CGAffineTransformScale([[gestureRecognizer view] transform], [gestureRecognizer scale], [gestureRecognizer scale]);
				NSLog(@"grs: %f", gestureRecognizer.scale);
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
		
		//save origin for applying in the correct spot
		NSLog(@"Checking rect before rotation: @(%f, %f) - (%f, x %f)", sticker.frame.origin.x, sticker.frame.origin.y, sticker.frame.size.width, sticker.frame.size.height);
		
		//this code changes the frame's origin and size!  not good :/
		CGAffineTransform t = CGAffineTransformRotate(sticker.transform, [gestureRecognizer rotation]);
		sticker.transform = t;
		
	
		sticker.rotationDegrees = fmodf([gestureRecognizer rotation] * 360.0/M_PI + sticker.rotationDegrees, 360.0f);
//		NSLog(@"Rotation of sticker: %f",sticker.rotationDegrees);
		NSLog(@"Checking rect after rotation: @(%f, %f) - (%f, x %f)", sticker.frame.origin.x, sticker.frame.origin.y, sticker.frame.size.width, sticker.frame.size.height);

        [gestureRecognizer setRotation:0];
	}
	
	[self.photoScrollView reloadInputViews];
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
