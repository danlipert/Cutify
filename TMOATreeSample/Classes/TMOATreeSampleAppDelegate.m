//
//  TMOATreeSampleAppDelegate.m
//  TMOATreeSample
//
//  Created by Dan Lipert on 7/25/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import "TMOATreeSampleAppDelegate.h"
#import "TMOANode.h"
#import "TMOATree.h"
#import "PokemonTableViewController.h"

@implementation TMOATreeSampleAppDelegate

@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    
//	TMOANode *rootNode = [[TMOANode alloc] init];
//	[rootNode.dictionary setObject:@"Pokemon" forKey:@"name"];
//	
//	TMOATree *tree = [[TMOATree alloc] initWithRootNode:rootNode];
//	
//	TMOANode *childNode = [[TMOANode alloc] init];
//	[childNode.dictionary setObject:@"Magnemite" forKey:@"name"];
//	if([tree addChild:childNode toNode:rootNode] == FALSE)
//	{
//		NSLog(@"ERROR ADDING CHILD TO ROOT NODE");
//	}
//	
//	TMOANode *magnetonNode = [[TMOANode alloc] init];
//	[magnetonNode.dictionary setObject:@"Magneton" forKey:@"name"];
//	[tree addChild:magnetonNode toNode:childNode];
//	
//	TMOANode *magnezoneNode = [[TMOANode alloc] init];
//	[magnezoneNode.dictionary setObject:@"Magnezone" forKey:@"name"];
//	[tree addChild:magnezoneNode toNode:magnetonNode];
//	
//	TMOANode *eeveeNode = [[TMOANode alloc] init];
//	[eeveeNode.dictionary setObject:@"Eevee" forKey:@"name"];
//	[tree addChild:eeveeNode toNode:rootNode];
//	
//	TMOANode *vaporeonNode = [[TMOANode alloc] init];
//	[vaporeonNode.dictionary setObject:@"Vaporeon" forKey:@"name"];
//	[tree addChild:vaporeonNode toNode:eeveeNode];
//	
//	TMOANode *jolteonNode = [[TMOANode alloc] init];
//	[jolteonNode.dictionary setObject:@"Jolteon" forKey:@"name"];
//	[tree addChild:jolteonNode toNode:eeveeNode];
//	
//	TMOANode *flareonNode = [[TMOANode alloc] init];
//	[flareonNode.dictionary setObject:@"Flareon" forKey:@"name"];
//	[tree addChild:flareonNode toNode:eeveeNode];
//	
//	TMOANode *espeonNode = [[TMOANode alloc] init];
//	[espeonNode.dictionary setObject:@"Espeon" forKey:@"name"];
//	[tree addChild:espeonNode toNode:eeveeNode];
//	
//	[self traverseTree:tree];
	
	PokemonTableViewController *tvc = [[PokemonTableViewController alloc] init];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:tvc];
	[self.window addSubview:navController.view];
	
    [self.window makeKeyAndVisible];
    
    return YES;
}
	 
- (void)traverseTree:(TMOATree *)tree
{
	NSLog(@"traversing tree...");
	for(TMOANode *node in tree.rootNode.children)
	{
		[self spiderNode:node];
	}		
}
	
-(void)spiderNode:(TMOANode *)node
{
	NSLog(@"spidering node for children...");
	[self visitNode:node];
	for(TMOANode *eachNode in node.children)
	{
		[self spiderNode:eachNode];
	}
}
	
-(void)visitNode:(TMOANode *)node
{
	NSLog(@"------------------------");
	if(node.parent == nil)
	{
		NSLog(@"Root node: %@", [node.dictionary objectForKey:@"name"]);
	} else {
		NSLog(@"%@ - parent: %@", [node.dictionary objectForKey:@"name"], [node.parent.dictionary objectForKey:@"name"]);
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
