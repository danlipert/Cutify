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

@synthesize photoImageView, photoImage, stickerForReset, stickersArray;

- (void)viewDidLoad {
    [super viewDidLoad];
	
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
	[self.view addSubview:self.photoImageView];
	
//	UIButton *iapButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//	[iapButton setTitle:@"In-App Purchase" forState:UIControlStateNormal];
//	[iapButton setFrame:CGRectMake(10,480-20-44-100+30,44,44)];
//	[iapButton addTarget:self action:@selector(iapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//	[self.view addSubview:iapButton];
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
	
//	//attach image
//	UIGraphicsBeginImageContext(self.photoImage.size);  
//		
//	// Draw photo  
//	[self.photoImage drawInRect:CGRectMake(0, 0, self.photoImage.size.width, self.photoImage.size.height)];  
//	
//	for(CutifyStickerView *eachStickerView in self.stickersArray)
//	{
//		[eachStickerView.stickerImageView.image drawInRect:CGRectMake(eachStickerView.frame.origin.x, eachStickerView.frame.origin.y, eachStickerView.frame.size.width, eachStickerView.frame.size.height)];
//	}
//	
//	UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();  
//	
//	UIGraphicsEndImageContext();  
		
	UIGraphicsBeginImageContext(self.photoImage.size);
	NSLog(@"created ctx with size: %f, %f", self.photoImage.size.width, self.photoImage.size.height);
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	[self.photoImage drawInRect:CGRectMake(0, 0, self.photoImage.size.width, self.photoImage.size.height)];  


	for(CutifyStickerView *eachStickerView in self.stickersArray)
	{
		CGContextSaveGState(ctx);

		eachStickerView.layer.anchorPoint = CGPointMake(0.5, 0.5);
		
		if([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2)
		{
			
			CGContextTranslateCTM (ctx, eachStickerView.center.x * 2.0, eachStickerView.center.y * 2.0);			
			CGContextRotateCTM(ctx, [eachStickerView.rotationDegrees floatValue] * M_PI/180.0);
			CGContextTranslateCTM (ctx, -eachStickerView.center.x * 2.0, -eachStickerView.center.y * 2.0);
			
			//iPhone 4
			[eachStickerView.stickerImageView.image drawInRect:CGRectMake(eachStickerView.frame.origin.x * 2.0, eachStickerView.frame.origin.y * 2.0, eachStickerView.frame.size.width * 2.0, eachStickerView.frame.size.height * 2.0)];
		} else {
			CGContextTranslateCTM (ctx, eachStickerView.center.x, eachStickerView.center.y);			
			CGContextRotateCTM(ctx, [eachStickerView.rotationDegrees floatValue] * M_PI/180.0);
			CGContextTranslateCTM (ctx, -eachStickerView.center.x, -eachStickerView.center.y);
			
			[eachStickerView.stickerImageView.image drawInRect:CGRectMake(eachStickerView.frame.origin.x, eachStickerView.frame.origin.y, eachStickerView.frame.size.width, eachStickerView.frame.size.height)];
		}
		
		CGContextRestoreGState(ctx);
	}
		
	UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();  
	
	optionsAndSharingViewController.image = resultingImage;
	[self.navigationController pushViewController:optionsAndSharingViewController animated:YES]; 
	[optionsAndSharingViewController release];
}

-(void)iapButtonPressed:(id)sender
{
	IAPViewController *iapViewController = [[IAPViewController alloc] init];
	[self.navigationController pushViewController:iapViewController animated:YES];
	[iapViewController release];
}

-(void)stickerPickerDidPickSticker:(CutifyStickerMeta *)stickerMeta
{
	NSLog(@"delegate called");
	
	CutifyStickerView *stickerView = [[CutifyStickerView alloc] initWithStickerMeta:stickerMeta];
	[self addGestureRecognizersToSticker:stickerView];
	[stickerView setFrame:CGRectMake(0,0,stickerView.frame.size.width/2.0, stickerView.frame.size.height/2.0)];
	[stickerView setCenter:self.view.center];
	[self.view addSubview:stickerView];
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
			
			[gestureRecognizer setTranslation:CGPointZero inView:[sticker superview]];
		} else {
			//do not move past borders
		}
    } else if([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
		
	}
}

- (void)scaleSticker:(UIPinchGestureRecognizer *)gestureRecognizer
{
	//    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    if(gestureRecognizer.scale != 0)
	{
		if((gestureRecognizer.view.frame.size.width > 40) && (gestureRecognizer.view.frame.size.height > 40))
		{
			if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
				[gestureRecognizer view].transform = CGAffineTransformScale([[gestureRecognizer view] transform], [gestureRecognizer scale], [gestureRecognizer scale]);
				[gestureRecognizer setScale:1];
			}
		}
	}
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
		sticker.rotationDegrees = [NSNumber numberWithFloat:[sticker.rotationDegrees floatValue] + [gestureRecognizer rotation] * 180.0/M_PI];
        [gestureRecognizer setRotation:0];
    }
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
