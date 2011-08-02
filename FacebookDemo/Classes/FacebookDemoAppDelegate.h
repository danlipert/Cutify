//
//  FacebookDemoAppDelegate.h
//  FacebookDemo
//
//  Created by Dan Lipert on 8/1/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@interface FacebookDemoAppDelegate : NSObject <UIApplicationDelegate, FBSessionDelegate> {
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) id fbSender;

@end

