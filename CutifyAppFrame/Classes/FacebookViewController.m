    //
//  FacebookViewController.m
//  CutifyAppFrame
//
//  Created by Dave Sluder on 8/25/11.
//  Copyright 2011 Night & Day Studios. All rights reserved.
//

#import "FacebookViewController.h"


@implementation FacebookViewController


@synthesize loginWebview;

@synthesize access_token;

- (id)init
{
	if (self = [super init])
	{
		self.serviceName = @"facebook";
	}
	return self;
}

- (void)dealloc 
{
	if (self.loginWebview != nil) self.loginWebview = nil;
	if (self.delegate != nil) self.delegate = nil;
    [super dealloc];
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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

	[self showActivityBlocker];

	
	
    [super viewDidLoad];
	[self faceBookLogin];
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

/*
 Dictionary contains:
 
 access_token
 expires_in
 
 and more ..
 
 */

- (void)loadAuthDataFromUserDefaults
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	self.access_token = [defaults objectForKey:@"facebook_access_token"];
}

- (BOOL) isAuthorized 
{	

	[self loadAuthDataFromUserDefaults];
	return (self.access_token != nil);
}



- (void)faceBookLogin
{
	NSString *url_string = [NSString stringWithFormat:@"https://graph.facebook.com/oauth/authorize?client_id=%@&redirect_uri=%@&type=user_agent&display=touch&scope=publish_stream", kFacebookAppID, kFacebookRedirectURL];
	
	NSURL *url = [NSURL URLWithString:url_string];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
	//attempting visual bug fix
//	UIWebView *_loginWebview = [[UIWebView alloc] initWithFrame:self.view.frame];
	UIWebView *_loginWebview = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,320,480)];

	self.loginWebview = _loginWebview;
	[_loginWebview release];
	[self.loginWebview setDelegate:self];
	[self.loginWebview loadRequest:request];
	[self.view addSubview:self.loginWebview];	
}

- (void)webViewDidStartLoad:(UIWebView *)webView_ {
    [self showActivityBlocker];
}

- (void)webViewDidFinishLoad:(UIWebView *)_webView {
    [self hideActivityBlocker];
	
	
	/**
	 * Since there's some server side redirecting involved, this method/function will be called several times
	 * we're only interested when we see a url like:  http://www.facebook.com/connect/login_success.html#access_token=..........
	 */
	
	//get the url string
	NSString *url_string = [((_webView.request).URL) absoluteString];
	
	NSLog(@"response: %@", url_string);
	
	//adjust for visual glitch with facebook demanding full screen real estate
	NSRange permissionsRequestRange = [url_string rangeOfString:@"method=permissions.request"];
	if(permissionsRequestRange.length > 0)
	{
		[self.navigationController setNavigationBarHidden:YES animated:YES];
		[[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
	} else {
		[[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
		[self.navigationController setNavigationBarHidden:NO animated:YES];

	}
	
	//looking for "access_token="
	NSRange access_token_range = [url_string rangeOfString:@"access_token="];

	//coolio, we have a token, now let's parse it out....
	if (access_token_range.length > 0) 
	{

		NSString *parms = [[url_string componentsSeparatedByString:@"#"] objectAtIndex:1];
		NSString *token = [[[[parms componentsSeparatedByString:@"&"] objectAtIndex:0] componentsSeparatedByString:@"="] objectAtIndex:1];
		
		NSLog(@"Token: %@", token);
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setObject:token forKey:@"facebook_access_token"];	
		[defaults synchronize];

		[self.delegate authenticationSuccessForService:self.serviceName];
		[self hideActivityBlocker];
		[self.navigationController popViewControllerAnimated:YES];
	}
	
}

@end
