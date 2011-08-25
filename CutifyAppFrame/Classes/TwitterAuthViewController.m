    //
//  TwitterAuthViewController.m
//  CutifyAppFrame
//
//  Created by Dave Sluder on 8/9/11.
//  Copyright 2011 Night & Day Studios. All rights reserved.
//

#import "TwitterAuthViewController.h"


@implementation TwitterAuthViewController

@synthesize delegate;

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


- (void)viewDidAppear:(BOOL)animated {
	
	if(_engine) return;
	
	_engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
	_engine.consumerKey = @"fA287REcKRordUPbqUcxA";
	_engine.consumerSecret = @"TEjsunwlAvjwBEMqNqHuSjCINx7kIntSL0LD70dm8";
	
	UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
	
	if (controller)
		[self presentModalViewController: controller animated: YES];
	else {
		tweets = [[NSMutableArray alloc] init];
		[self updateStream:nil];
	}
}

#pragma mark SA_OAuthTwitterEngineDelegate

- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	
	//looking for "access_token="
	NSRange oauth_token_range = [data rangeOfString:@"oauth_token="];
	NSRange oauth_token_secret_range = [data rangeOfString:@"&oauth_token_secret="];
	NSRange user_id_range = [data rangeOfString:@"&user_id="];
	NSRange screen_name_range = [data rangeOfString:@"&screen_name="];	
	
	
	//coolio, we have a token, now let's parse it out....
	if (oauth_token_range.length > 0) {
		
		//we want everything after the 'access_token=' thus the position where it starts + it's length
		int oauth_token_from_index = oauth_token_range.location + oauth_token_range.length;
		int oauth_token_to_index = oauth_token_secret_range.location;
		
		NSRange range = NSMakeRange (oauth_token_from_index, oauth_token_to_index - oauth_token_from_index);
		
		NSString *oauth_token = [data substringWithRange:range];
		NSString *oauth_token_secret = @"";
		NSLog(@"oauth_token:  %@", oauth_token);

		if (oauth_token_secret_range.length > 0)
		{
			int oauth_token_secret_from_index = oauth_token_secret_range.location + oauth_token_secret_range.length;
			int oauth_token_secret_to_index = user_id_range.location;
			
			NSRange range_secret = NSMakeRange (oauth_token_secret_from_index, oauth_token_secret_to_index - oauth_token_secret_from_index);
			
			oauth_token_secret = [data substringWithRange:range_secret];
			
			NSLog(@"oauth_token_secret:  %@", oauth_token_secret);
			
		}
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setObject:oauth_token forKey:@"twitter_token"];
		[defaults setObject:oauth_token_secret forKey:@"twitter_token_secret"];
		[defaults synchronize];
		NSLog(@"Token: %@ saved for service: twitter", oauth_token);
		
	}
	

	
	
	//[self.delegate authenticationDidFinishWithToken:twitter_token_secret forService:@"twitter"];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"twitter_token"];
}

#pragma mark SA_OAuthTwitterController Delegate

- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
	
	NSLog(@"Authenticated with user %@", username);
	
	[self.navigationController popViewControllerAnimated:YES];
	//tweets = [[NSMutableArray alloc] init];
	//[self updateStream:nil];
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
	
	NSLog(@"Authentication Failure");
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	
	NSLog(@"Authentication Canceled");
}

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
