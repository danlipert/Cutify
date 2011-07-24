//
//  CutifyAppFrameAppDelegate.m
//  CutifyAppFrame
//
//  Created by Dan Lipert on 7/11/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import "CutifyAppFrameAppDelegate.h"
#import "OptionsAndSharingViewController.h"
#import "TakePhotoViewController.h"
#import "PhotoViewSharingViewController.h"
#import "PhotoGridViewController.h"
#import "ApplyStickersViewController.h"
#import "PhotoCaptureViewController.h"

@implementation CutifyAppFrameAppDelegate

@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    
//	OptionsAndSharingViewController *optionsAndSharingViewController = [[OptionsAndSharingViewController alloc] initWithStyle:UITableViewStyleGrouped];
//	TakePhotoViewController *takePhotoViewController = [[TakePhotoViewController alloc] init];
//	PhotoViewSharingViewController *photoViewSharingViewController = [[PhotoViewSharingViewController alloc] initWithStyle:UITableViewStyleGrouped];
//	ApplyStickersViewController *applyStickersViewController = [[ApplyStickersViewController alloc] init];
//	PhotoGridViewController *photoGridViewController = [[PhotoGridViewController alloc] init];
	PhotoCaptureViewController *photoCaptureViewController = [[PhotoCaptureViewController alloc] initWithNibName:@"PhotoCaptureViewController" bundle:nil];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:photoCaptureViewController];
	
	[self.window addSubview:navigationController.view];
	
    [self.window makeKeyAndVisible];
    
    return YES;
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

@interface UINavigationBar (MyCustomNavBar)
@end

@implementation UINavigationBar (MyCustomNavBar)
- (void) drawRect:(CGRect)rect {
    UIImage *barImage = [UIImage imageNamed:@"NavigationBar.png"];
    [barImage drawInRect:rect];
}
@end