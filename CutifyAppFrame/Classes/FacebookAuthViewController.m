    //
//  FacebookAuthViewController.m
//  CutifyAppFrame
//
//  Created by Dave Sluder on 8/9/11.
//  Copyright 2011 Night & Day Studios. All rights reserved.
//

#import "FacebookAuthViewController.h"


@implementation FacebookAuthViewController

@synthesize delegate;
@synthesize loginWebview;

- (void)faceBookLogin
{
	NSLog(@"Show facebook login");
	/*Facebook Application ID*/
	NSString *client_id = @"167889749949567";
	
	/*Dummy page hosted by the nice folks at Facebook*/
	NSString *redirect_uri = @"http://www.facebook.com/connect/login_success.html";
	
	NSString *url_string = [NSString stringWithFormat:@"https://graph.facebook.com/oauth/authorize?client_id=%@&redirect_uri=%@&type=user_agent&display=touch&scope=publish_stream", client_id, redirect_uri];
	
	NSURL *url = [NSURL URLWithString:url_string];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
	UIWebView *_loginWebview = [[UIWebView alloc] initWithFrame:self.view.frame];
	self.loginWebview = _loginWebview;
	[_loginWebview release];
	[self.loginWebview setDelegate:self];
	[self.loginWebview loadRequest:request];
	[self.view addSubview:self.loginWebview];	
}


- (void)webViewDidFinishLoad:(UIWebView *)_webView {
	
	/**
	 * Since there's some server side redirecting involved, this method/function will be called several times
	 * we're only interested when we see a url like:  http://www.facebook.com/connect/login_success.html#access_token=..........
	 */
	
	//get the url string
	NSString *url_string = [((_webView.request).URL) absoluteString];
	
	NSLog(url_string);
	
	//looking for "access_token="
	NSRange access_token_range = [url_string rangeOfString:@"access_token="];
	NSRange expires_range = [url_string rangeOfString:@"&expires_in="];
	
	//coolio, we have a token, now let's parse it out....
	if (access_token_range.length > 0) {
		
		//we want everything after the 'access_token=' thus the position where it starts + it's length
		int from_index = access_token_range.location + access_token_range.length;
		int to_index = expires_range.location;
		
		NSRange range = NSMakeRange (from_index, to_index - from_index);
		
		NSString *access_token = [url_string substringWithRange:range];
		
		NSLog(@"access_token:  %@", access_token);

		[self.loginWebview removeFromSuperview];
		
		//a token was just recieved
		[self.delegate authenticationDidFinishWithToken:access_token forService:@"facebook"];
		
		[self.navigationController popViewControllerAnimated:YES];
		
	}
	
	
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
	[self faceBookLogin];
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
