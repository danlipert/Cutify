    //
//  TakePhotoViewController.m
//  CutifyAppFrame
//
//  Created by Dan Lipert on 7/11/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import "TakePhotoViewController.h"
#import "ApplyStickersViewController.h"
#import "PhotoGridViewController.h"

@implementation TakePhotoViewController

@synthesize takePhotoButton, flashButton, photoLibraryButton, maskImageView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//setup buttons
	UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
	UIImage *cancelButtonImage = [UIImage imageNamed:@"BackButton.png"];
	[cancelButton setFrame:CGRectMake(0,0,cancelButtonImage.size.width, cancelButtonImage.size.height)];
	[cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[cancelButton setImage:cancelButtonImage forState:UIControlStateNormal];
	UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
	
	self.navigationItem.leftBarButtonItem = cancelButtonItem;
	[cancelButtonItem release];

	UIButton *_takePhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,100,44)];
	self.takePhotoButton = _takePhotoButton;
	[_takePhotoButton release];
	[self.takePhotoButton setTitle:@"Take Photo" forState:UIControlStateNormal];
	[self.takePhotoButton addTarget:self action:@selector(takePhotoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	UIButton *_photoLibraryButton = [[UIButton alloc] initWithFrame:CGRectMake(200,0,100,44)];
	self.photoLibraryButton = _photoLibraryButton;
	[_photoLibraryButton release];
	[self.photoLibraryButton setTitle:@"Library" forState:UIControlStateNormal];
	[self.photoLibraryButton addTarget:self action:@selector(photoLibraryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	UIView *customToolbarView = [[UIView alloc] initWithFrame:CGRectMake(0,372,320,44)];
	[customToolbarView setBackgroundColor:[UIColor purpleColor]];
	
	[customToolbarView addSubview:self.photoLibraryButton];
	[customToolbarView addSubview:self.takePhotoButton];
	
	[self.view addSubview:customToolbarView];
	[customToolbarView release];
}

-(void)takePhotoButtonPressed:(id)sender
{
	ApplyStickersViewController *applyStickersViewController = [[ApplyStickersViewController alloc] init];
	[self.navigationController pushViewController:applyStickersViewController animated:YES];
	[self.navigationController setToolbarHidden:TRUE animated:YES];
	[applyStickersViewController release];
	
}

-(void)cancelButtonPressed:(id)sender
{
	PhotoGridViewController *photoGridViewController = [[PhotoGridViewController alloc] init];
	[self.navigationController pushViewController:photoGridViewController animated:YES];
	[self.navigationController setToolbarHidden:TRUE animated:YES];
	[photoGridViewController release];
}

-(void)photoLibraryButtonPressed:(id)sender
{
	PhotoGridViewController *photoGridViewController = [[PhotoGridViewController alloc] init];
	[self.navigationController pushViewController:photoGridViewController animated:YES];
	[photoGridViewController release];
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
}


- (void)dealloc {
    [super dealloc];
}


@end
