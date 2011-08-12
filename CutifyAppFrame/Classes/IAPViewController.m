    //
//  IAPViewController.m
//  CutifyAppFrame
//
//  Created by Dan Lipert on 7/13/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import "IAPViewController.h"


@implementation IAPViewController

-(void)viewDidLoad
{
	
	/*
	 UAStoreFrontUI *ui = [UAStoreFrontUI shared];
	 
	 ui.rootViewController.view.frame = CGRectMake(0, 10, ui.rootViewController.view.frame.size.width, ui.rootViewController.view.frame.size.height - 10);
	 [self.viewController.view addSubview:ui.rootViewController.view];
	*/
	
	
	//setup buttons
	UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
	UIImage *cancelButtonImage = [UIImage imageNamed:@"BackButton.png"];
	[cancelButton setFrame:CGRectMake(0,0,cancelButtonImage.size.width, cancelButtonImage.size.height)];
	[cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[cancelButton setImage:cancelButtonImage forState:UIControlStateNormal];
	UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];

	self.navigationItem.leftBarButtonItem = cancelButtonItem;
	[cancelButtonItem release];

	//	//setup background
	UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"InAppPurchaseBackground.png"]];
	[self.view addSubview:backgroundImageView];
	[backgroundImageView release];
	
	//setup iap image
	UIImageView *iapImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"InAppPurchaseKittyPack.png"]];
	[iapImageView setCenter:self.view.center];
	[iapImageView setFrame:CGRectMake(iapImageView.frame.origin.x, iapImageView.frame.origin.y-70, iapImageView.frame.size.width, iapImageView.frame.size.height)];
	[self.view addSubview:iapImageView];
	[iapImageView release];
	
	UIButton *buyButton = [[UIButton alloc] init];
	UIImage *buyButtonImage = [UIImage imageNamed:@"BuyPackButton.png"];
	[buyButton setFrame:CGRectMake(0,480-20-44-buyButtonImage.size.height-10,buyButtonImage.size.width, buyButtonImage.size.height)];
	[buyButton addTarget:self action:@selector(buyButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[buyButton setImage:buyButtonImage forState:UIControlStateNormal];
	[self.view addSubview:buyButton];
	[buyButton release];
}

-(void)cancelButtonPressed:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}
	
-(void)buyButtonPressed:(id)sender
{
	
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
