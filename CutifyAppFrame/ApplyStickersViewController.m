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

@implementation ApplyStickersViewController

@synthesize photoImageView, photoImage;

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
	
	UIImageView *interfaceDemoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BreadcrumbSample.png"]];
	[interfaceDemoImageView setFrame:CGRectMake(0,480-20-44-100,320,100)];
	[self.view addSubview:interfaceDemoImageView];
	[interfaceDemoImageView release];
	
	UIImageView *_photoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ApplyStickerImage.png"]];
	self.photoImageView = _photoImageView;
	[_photoImageView release];
	
	[self.photoImageView setFrame:CGRectMake(0,0,320,314)];
	self.photoImageView.image = self.photoImage;
	[self.view addSubview:self.photoImageView];
	
	UIButton *iapButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[iapButton setTitle:@"In-App Purchase" forState:UIControlStateNormal];
	[iapButton setFrame:CGRectMake(10,480-20-44-100+30,44,44)];
	[iapButton addTarget:self action:@selector(iapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:iapButton];
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
	[self.navigationController pushViewController:optionsAndSharingViewController animated:YES]; 
	[optionsAndSharingViewController release];
}

-(void)iapButtonPressed:(id)sender
{
	IAPViewController *iapViewController = [[IAPViewController alloc] init];
	[self.navigationController pushViewController:iapViewController animated:YES];
	[iapViewController release];
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
