    //
//  FacebookViewController.m
//  FacebookDemo
//
//  Created by Dan Lipert on 8/1/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import "FacebookViewController.h"


@implementation FacebookViewController

@synthesize facebookButton, delegate;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
	    }
    return self;
}

-(void)viewDidLoad
{
	UIButton *_facebookButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	self.facebookButton = _facebookButton;
	
	[self.facebookButton addTarget:self action:@selector(facebookButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.facebookButton setFrame:CGRectMake(10,10,100,44)];
	[self.facebookButton setTitle:@"Login" forState:UIControlStateNormal];
	[self.view addSubview:self.facebookButton];
}


-(void)facebookButtonPressed:(id)sender
{
	//first check internet status...
	NSString *connectionTestString = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]];
	
	if([connectionTestString length] == 0)
	{
		//no connection!
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection Detected" message:@"Please connect your device to the internet to use Facebook" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	} else if([[self.delegate facebook] isSessionValid] == TRUE) {
		NSLog(@"detected valid facebook session");
		//forward touch
	} else {
		NSLog(@"session not valid");
		//		[[[[UIApplication sharedApplication] delegate] facebook] dialog:@"feed" andDelegate:self];
		[self.delegate facebookLoginWithSender:self];
	}
	
	[connectionTestString release];
}

-(void)reloadFacebookWebview
{
	NSLog(@"Logged into facebook");
	[self.delegate setFbSender:self];
	[self.delegate fbDidLogin];
}

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
