//
//  ImageRotateMergeAppDelegate.m
//  ImageRotateMerge
//
//  Created by Dan Lipert on 8/20/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import "ImageRotateMergeAppDelegate.h"
#import "DemoViewController.h"
#import "ApplyStickersViewController.h"

@implementation ImageRotateMergeAppDelegate

@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
//    DemoViewController *dvc = [[DemoViewController alloc] init];
	ApplyStickersViewController *vc = [[ApplyStickersViewController alloc] init];
	UIImage *demoImage = [UIImage imageNamed:@"background.jpg"];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
	vc.photoImage = [self cropImage:demoImage withRect:CGRectMake(6,120,306,306)];
	[self.window addSubview:navController.view];
    [self.window makeKeyAndVisible];
    
    return YES;
}

// get sub image http://stackoverflow.com/questions/2635371/how-to-crop-the-uiimage
- (UIImage*)cropImage: (UIImage*)img withRect:(CGRect)rect 
{
	//FUKKEN BUGS
	//this is effing up the right side
	//actually first we are going to resize the image
	
	if([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2)
	{
		//iPhone 4
		rect = CGRectMake(rect.origin.x * 2.0, rect.origin.y * 2.0, rect.size.width*2.0, rect.size.height*2.0);
	}
	
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    // translated rectangle for drawing sub image 
	CGRect drawRect;
	if([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2)
	{
		//		drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, img.size.width, img.size.height);
		drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, 624, 1110);
	} else {
		drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, img.size.width, img.size.height);
	}	
	
    // clip to the bounds of the image context
    // not strictly necessary as it will get clipped anyway?
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
	
    // draw image
	[img drawInRect:drawRect];
	//	[img drawAtPoint:CGPointMake(-rect.origin.x, -rect.origin.y)];
	
    // grab image
    UIImage* subImage = UIGraphicsGetImageFromCurrentImageContext();
	
    UIGraphicsEndImageContext();
	
    return subImage;
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
