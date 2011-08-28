    //
//  TumblrViewController.m
//  CutifyAppFrame
//
//  Created by Dave Sluder on 8/25/11.
//  Copyright 2011 Night & Day Studios. All rights reserved.
//

#import "TumblrViewController.h"


@implementation TumblrViewController

- (id)init
{
	self.serviceName = @"tumblr";
	
	self.requestTokenURL = @"http://www.tumblr.com/oauth/request_token";
	self.accessTokenURL = @"http://www.tumblr.com/oauth/access_token";
	self.authorizeURL = @"http://www.tumblr.com/oauth/authorize";
	self.callbackURL = @"http://cutifyapp.com/derpa/";
	
	self.consumerKey = @"d3ZRH6gNJM7xyB9Z1rFdLokWqPYUsRFF3cjvWB1RI5l617NAKa";
	self.consumerSecret = @"JGyEmR4G6jiUtbI3s2O8wCwIDIdIQWFlTctJrHIbIPtOfXctS6";
	
    self = [super init];
    if (self) 
	{
    }
    return self;
}

- (void)serviceUnavailable
{

	[self.navigationController popViewControllerAnimated:YES];
    UIAlertView *alert =
	[[UIAlertView alloc] initWithTitle: @"Service Unavailable"
							   message: [NSString stringWithFormat:@" unavailable. Please try again later.", self.serviceName]
							  delegate: self
					 cancelButtonTitle: @"OK"
					 otherButtonTitles: nil];
    [alert show];
    [alert release];
}
/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */



/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

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
