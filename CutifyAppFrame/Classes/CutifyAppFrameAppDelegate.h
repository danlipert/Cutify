//
//  CutifyAppFrameAppDelegate.h
//  CutifyAppFrame
//
//  Created by Dan Lipert on 7/11/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CutifyAppFrameAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

