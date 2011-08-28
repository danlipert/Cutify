    //
//  OAuthViewController.m
//  CutifyAppFrame
//
//  Created by Dave Sluder on 8/25/11.
//  Copyright 2011 Night & Day Studios. All rights reserved.
//

#import "OAuthViewController.h"
#import "ASIFormDataRequest.h"

@implementation OAuthViewController

@synthesize oauth, webView, verifier;
@synthesize requestTokenURL, accessTokenURL, authorizeURL, callbackURL, consumerKey, consumerSecret;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)init
{
    self = [super init];
    if (self) 
	{
		OAuth *oauth_ = [[OAuth alloc] initWithConsumerKey:self.consumerKey andConsumerSecret:self.consumerSecret];
		oauth_.delegate = self;
		oauth_.serviceName = self.serviceName;
		self.oauth = oauth_;
		[oauth_ release];
    }
    return self;
}


#pragma mark -
#pragma mark OAuthTwitterCallbacks protocol

// For all of these methods, we invoked oAuth in a background thread, so these are also called
// in background thread. So we first transfer the control back to main thread before doing
// anything else.

- (void) requestTwitterTokenDidSucceed:(OAuth *)_oAuth {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(requestTwitterTokenDidSucceed:)
							   withObject:_oAuth
							waitUntilDone:NO];
		return;
	}
    
	
	NSURL *authorizeURLRequest = [NSURL URLWithString:[NSString stringWithFormat:@"%@?oauth_token=%@",
													   self.authorizeURL, _oAuth.oauth_token]];
	
	UIWebView *_loginWebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
	self.webView = _loginWebview;
	[_loginWebview release];
	[self.webView setDelegate:self];
	self.webView.scalesPageToFit = YES; 
	self.webView .autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.webView loadRequest:[NSURLRequest requestWithURL:authorizeURLRequest]];
	[self.view addSubview:self.webView];		
	
}

- (void) authorizeTwitterTokenDidSucceed:(OAuth *)_oAuth {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(authorizeTwitterTokenDidSucceed:)
							   withObject:_oAuth
							waitUntilDone:NO];
		return;
	}
	NSLog(@"Authorization succeeded: %@", _oAuth);
	[self.oauth saveOAuthContextToUserDefaults];
	
	if ([self.serviceName isEqualToString:@"tumblr"])
	{
		
		/*
		// We assume that the user is authenticated by this point and we have a valid OAuth context,
		// thus no need to do context checking.
		
		NSString *postUrl = @"http://api.tumblr.com/v2/user/info";
		
		ASIFormDataRequest *request = [[ASIFormDataRequest alloc]
									   initWithURL:[NSURL URLWithString:postUrl]];
		
		[request addRequestHeader:@"Authorization"
							value:[_oAuth oAuthHeaderForMethod:@"POST"
													   andUrl:postUrl
													andParams:nil]];
		
		[request startSynchronous];
		
		NSLog(@"Status posted. HTTP result code: %d", [request responseString]);
		

		
		[request release];
		

	*/
	
	}
	
	
	
	
	[self.delegate authenticationSuccessForService:self.serviceName];
	[self hideActivityBlocker];
	[self.navigationController popViewControllerAnimated:YES];
	
}

-(BOOL)isAuthorized
{
	[self.oauth loadOAuthContextFromUserDefaults];
	return [self.oauth oauth_token_authorized];
}


- (void) authorizeTwitterTokenDidFail:(OAuth *)_oAuth {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(authorizeTwitterTokenDidFail:)
							   withObject:_oAuth
							waitUntilDone:NO];
		return;
	}
	NSLog(@"Auth step fail");
}



#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView_ {
    [self showActivityBlocker];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView_ {
    [self hideActivityBlocker];
	
	NSString *url_string = [((webView_.request).URL) absoluteString];
	
	//looking for "access_token="
	NSLog(@"responsez: %@", url_string);
	
	NSRange oauth_verifier_range = [url_string rangeOfString:@"oauth_verifier="];
	
	//coolio, we have a token, now let's parse it out....
	if (oauth_verifier_range.length > 0) 
	{
		
		
		NSString *parms = [[url_string componentsSeparatedByString:@"?"] objectAtIndex:1]; 
		NSArray *comps = [parms componentsSeparatedByString:@"&"];
		
		self.verifier = [[[comps objectAtIndex:1] componentsSeparatedByString:@"="] objectAtIndex:1];
		
		
		NSLog(@"verifier: %@", self.verifier);
		
		[self.oauth synchronousAuthorizeToken:self.accessTokenURL WithVerifier:self.verifier];
		
	}
	
	
	
}


- (void) requestTwitterTokenDidFail:(OAuth *)_oAuth {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(requestTwitterTokenDidFail:)
							   withObject:_oAuth
							waitUntilDone:NO];
		return;
	}
	NSLog(@"Request token failed");
	
}


/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self showActivityBlocker];
	[self.oauth synchronousRequestToken:self.requestTokenURL WithCallbackUrl:self.callbackURL];
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
