//
//  FacebookViewController.h
//  CutifyAppFrame
//
//  Created by Dave Sluder on 8/25/11.
//  Copyright 2011 Night & Day Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kFacebookAppID @"167889749949567"
#define kFacebookRedirectURL @"http://www.facebook.com/connect/login_success.html"

#import "AuthViewController.h"


@interface FacebookViewController : AuthViewController <UIWebViewDelegate> {

}

@property (nonatomic, readwrite, retain) NSString *access_token;


@property (nonatomic, retain) UIWebView *loginWebview;

-(BOOL)isAuthorized;

@end

