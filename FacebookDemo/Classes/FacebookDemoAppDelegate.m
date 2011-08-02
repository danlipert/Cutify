//
//  FacebookDemoAppDelegate.m
//  FacebookDemo
//
//  Created by Dan Lipert on 8/1/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import "FacebookDemoAppDelegate.h"
#import "FBConnect.h"
#import "FacebookViewController.h"

@implementation FacebookDemoAppDelegate

@synthesize window, facebook, fbSender;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
	self.facebook = [[Facebook alloc] initWithAppId:@"167889749949567"];
	self.facebook.sessionDelegate = self;
	self.fbSender = nil;

	FacebookViewController *fbvc = [[FacebookViewController alloc] init];
	fbvc.delegate = self;
	
	[self.window addSubview:fbvc.view];
	
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(void)facebookLoginWithSender:(id)sender
{
	if([sender respondsToSelector:@selector(reloadFacebookWebview)])
	{
		self.fbSender = [sender retain];
	}
	
	if([self.facebook isSessionValid] == FALSE)
	{
		NSLog(@"Session is valid returned FALSE!");
		//try to load from user defaults
		if([[NSUserDefaults standardUserDefaults] objectForKey:@"fb_access_token"])
		{
			[self.facebook setAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"fb_access_token"]];
			[self.facebook setExpirationDate:[[NSUserDefaults standardUserDefaults] objectForKey:@"fb_exp_date"]];
		} 
		
		//maybe valid now...
		
		if([self.facebook isSessionValid] == FALSE)
		{
			NSArray* permissions =  [[NSArray arrayWithObjects:@"publish_stream", nil] retain];
			[self.facebook authorize:permissions delegate:self];
			[permissions release];
			//	[[NSUserDefaults standardUserDefaults] setObject:facebook.accessToken forKey:@"fb_access_token"];
			//			[[NSUserDefaults standardUserDefaults] setObject:facebook.expirationDate forKey:@"fb_exp_date"];
		} else {
			NSLog(@"Session was invalid but unpacked old accesstoken and exp date so now session is VALID!");
		}
	} else {
		NSLog(@"session is valid");
	}
}

-(void)fbDidLogin
{
	NSLog(@"fb logged in delegate called!");
	if(self.fbSender)
	{
		NSLog(@"fbSender found");
		
		[[NSUserDefaults standardUserDefaults] setObject:self.facebook.accessToken forKey:@"fb_access_token"];
		[[NSUserDefaults standardUserDefaults] setObject:self.facebook.expirationDate forKey:@"fb_exp_date"];
		
		[self.fbSender reloadFacebookWebview];
	}
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
