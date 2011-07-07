    //
//  ComposingViewController.m
//  CutifyAppPrototype
//
//  Created by Dan Lipert on 6/23/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import "ComposingViewController.h"
#import "CutifyStickerView.h"
#import <QuartzCore/QuartzCore.h>
#import "PuzzlePickerTableViewController.h"

@implementation ComposingViewController

@synthesize photoImageView;
@synthesize addStickerButton, saveButton, takePhotoButton, loadPhotoButton;
@synthesize stickerForReset;
@synthesize stickersArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

	    }
    return self;
}

-(void)viewDidLoad
{
	
	//create background image
	UIImageView * photoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
	self.photoImageView = photoImageView;
	[photoImageView release];
	
	[self.photoImageView setFrame:CGRectMake(0,0,320,480)];
	[self.view addSubview:self.photoImageView];
	
	
	//add sticker button
	UIButton *_addStickerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	self.addStickerButton = _addStickerButton;
	[self.addStickerButton setTitle:@"Sticker" forState:UIControlStateNormal];
	[self.addStickerButton setFrame:CGRectMake(0,480-44,80,44)];
	[self.addStickerButton addTarget:self action:@selector(addStickerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.addStickerButton];
	
	UIButton *_takePhotoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	self.takePhotoButton = _takePhotoButton;
	[self.takePhotoButton setTitle:@"Snapshot" forState:UIControlStateNormal];
	[self.takePhotoButton setFrame:CGRectMake(80,480-44, 80, 44)];
	[self.takePhotoButton addTarget:self action:@selector(takePhotoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.takePhotoButton];
	
	UIButton *_loadPhotoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	self.loadPhotoButton = _loadPhotoButton;
	[self.loadPhotoButton setTitle:@"Load" forState:UIControlStateNormal];
	[self.loadPhotoButton setFrame:CGRectMake(160, 480-44, 80, 44)];
	[self.loadPhotoButton addTarget:self action:@selector(loadPhotoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.loadPhotoButton];
	
	UIButton *_saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	self.saveButton = _saveButton;
	[self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
	[self.saveButton setFrame:CGRectMake(240,480-44,80,44)];
	[self.saveButton addTarget:self action:@selector(saveButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.saveButton];
	
	NSMutableArray *_stickersArray = [[NSMutableArray alloc] init];
	self.stickersArray = _stickersArray;
	
//	//add sticker
//	CutifyStickerView *stickerView = [[CutifyStickerView alloc] init];
//	[self addGestureRecognizersToSticker:stickerView];
//	[self.view addSubview:stickerView];
//	[stickerView release];
}	

#pragma mark -
#pragma mark buttons

- (void)addStickerButtonPressed:(id)sender
{
	PuzzlePickerTableViewController *picker = [[PuzzlePickerTableViewController alloc] init];
	[picker setDelegate:self];
	[self presentModalViewController:picker animated:YES];
}

-(void)puzzlePickerDidPickPuzzleWithFilename:(NSString *)fileName
{

	
	[self dismissModalViewControllerAnimated:YES];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; 
	
	CutifyStickerView *stickerView = [[CutifyStickerView alloc] init];
	[self addGestureRecognizersToSticker:stickerView];
	[stickerView setImage:[UIImage imageWithContentsOfFile:[documentsDirectory stringByAppendingPathComponent:fileName]]];
	[stickerView setFrame:CGRectMake(0,0,stickerView.frame.size.width/2.0, stickerView.frame.size.height/2.0)];
	[stickerView setCenter:self.view.center];
	[self.view addSubview:stickerView];
	[self.stickersArray addObject:stickerView];
	[stickerView release];
}

- (void)takePhotoButtonPressed:(id)sender
{
	UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
	imagePickerController.delegate = self;
	imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
	[self presentModalViewController:imagePickerController animated:YES];	
}

- (void)saveButtonPressed:(id)sender
{
	UIImageWriteToSavedPhotosAlbum([self getImageFromScreen], self, nil, nil);
	
	UIAlertView *charAlert = [[UIAlertView alloc]
							  initWithTitle:@"Image Saved"
							  message:@"Image has been saved to Photo Library"
							  delegate:nil
							  cancelButtonTitle:@"OK"
							  otherButtonTitles:nil];
	
	[charAlert show];
	[charAlert autorelease];
	
}

-(void)loadPhotoButtonPressed:(id)sender
{
	UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
	imagePickerController.delegate = self;
	imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	[self presentModalViewController:imagePickerController animated:YES];	
	
}

- (UIImage *)getImageFromScreen
{
	CGRect contextRect  = CGRectMake(0, 0, 320, 480);// whatever you need
	UIGraphicsBeginImageContext(contextRect.size);	
	
	[self.addStickerButton setAlpha:0.0];
	[self.saveButton setAlpha:0.0];
	[self.takePhotoButton setAlpha:0.0];
	[self.loadPhotoButton setAlpha:0.0];
	
	[self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	[self.addStickerButton setAlpha:1.0];
	[self.saveButton setAlpha:1.0];
	[self.takePhotoButton setAlpha:1.0];
	[self.loadPhotoButton setAlpha:1.0];
	
	return viewImage;
}

#pragma mark -
#pragma mark imagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{	
	for(CutifyStickerView *stickerView in [self.stickersArray copy])
	{
		[stickerView removeFromSuperview];
	}
	
	[self.stickersArray removeAllObjects];
	
	[picker dismissModalViewControllerAnimated:YES];
	
    self.photoImageView.image = image;
	
	if(picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
	{
		[photoImageView setContentMode:UIViewContentModeScaleAspectFit];
	}
	
	[picker release];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[picker dismissModalViewControllerAnimated:YES];	
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
        [gestureRecognizer setRotation:0];
    }
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidUnload {
	
    [super viewDidUnload];
	
	self.photoImageView = nil;
	self.addStickerButton = nil;
	
	self.stickersArray = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
