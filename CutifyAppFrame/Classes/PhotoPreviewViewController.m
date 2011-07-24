//
//  PhotoPreviewViewController.m
//  LuchaLibreUSA
//
//  Created by Dave Sluder on 7/16/11.
//  Copyright 2011 Dave Sluder. All rights reserved.
//

#import "PhotoPreviewViewController.h"

@implementation PhotoPreviewViewController

@synthesize delegate;
@synthesize imageView;
@synthesize photo;

- (id)initWithPhoto:(UIImage *)thePhoto
{
    self = [super init];
    if (self) {
		self.photo = thePhoto;
    }
    return self;
}

- (void)dealloc 
{
	if (self.photo != nil) self.photo = nil;
	if (self.imageView != nil) self.imageView = nil;
	if (self.delegate != nil) self.delegate = nil;
    [super dealloc];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	self.imageView.image = self.photo;
}

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
							
#pragma mark -
#pragma mark Actions
										
- (IBAction)retakePhoto
{
	[self.view removeFromSuperview];
}

										
- (IBAction)usePhoto 
{
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle: @"Save Image"
						  message: @"Would you like to save this image to your camera role for future use?"
						  delegate: self 
						  cancelButtonTitle:@"Skip"
						  otherButtonTitles:@"Save",nil];
	[alert show];
	[alert release];
}

#pragma mark -
#pragma mark Save photo to camera roll

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{	
	if (buttonIndex == 1) {
		NSLog(@"Save to camera roll");
		UIImageWriteToSavedPhotosAlbum(self.photo, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
	}
	[self.delegate photoSelected:self.photo];
	[self.view removeFromSuperview];
}
										
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
	if (error != NULL) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Image couldn't be saved" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
	}
	else {
		
	}
}

@end
