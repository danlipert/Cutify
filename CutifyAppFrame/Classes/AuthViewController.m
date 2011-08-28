    //
//  AuthViewController.m
//  CutifyAppFrame
//
//  Created by Dave Sluder on 8/26/11.
//  Copyright 2011 Night & Day Studios. All rights reserved.
//

#import "AuthViewController.h"


@implementation AuthViewController

@synthesize blocker;
@synthesize serviceName;
@synthesize delegate;
@synthesize timer;

- (void)showActivityBlocker 
{
	if (self.blocker == nil) 
	{
		UIView *blocker_ = [[UIView alloc] initWithFrame:self.view.bounds];
		blocker_.backgroundColor = [UIColor blackColor];
		blocker_.alpha = 0.7;
		UIActivityIndicatorView *activityInd_ = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		activityInd_.center = CGPointMake((blocker_.bounds.size.width / 2.0), (blocker_.bounds.size.height / 2.0));
		[blocker_ addSubview:activityInd_];
		[activityInd_ startAnimating];
		self.blocker = blocker_;
		[blocker_ release];
		[self.view addSubview:self.blocker];
		self.view.userInteractionEnabled = NO;
		

	}
	
	if (self.timer)
		[self.timer invalidate]; 
	self.timer = nil;
	self.timer = [NSTimer scheduledTimerWithTimeInterval:30.0
												  target:self
												selector:@selector(serviceUnavailable)
												userInfo:nil
												 repeats:NO];
}

- (void)hideActivityBlocker
{
	if (self.blocker != nil) 
	{
		[self.blocker removeFromSuperview];
		self.blocker = nil;
		self.view.userInteractionEnabled = YES;
		
	}
	if (self.timer)
		[self.timer invalidate]; 
	self.timer = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
	if (![self isAuthorized])
		[self.delegate resetAuthViewControllerForService:self.serviceName];
}

- (void)serviceUnavailable
{
	[self.delegate serviceUnavailable:self.serviceName];
}



// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	

	
    [super viewDidLoad];
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
