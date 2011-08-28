//
//  OAuthViewController.h
//  CutifyAppFrame
//
//  Created by Dave Sluder on 8/25/11.
//  Copyright 2011 Night & Day Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AuthViewController.h"
#import "OAuth.h"
#import "OAuthTwitterCallbacks.h"

@interface OAuthViewController : AuthViewController <UIWebViewDelegate, OAuthTwitterCallbacks> {	
	
}



@property (nonatomic, readwrite, retain) OAuth *oauth;
@property (nonatomic, readwrite, retain) NSString *verifier;
@property (nonatomic, readwrite, retain) UIWebView *webView;


@property (nonatomic, readwrite, retain) NSString *requestTokenURL;
@property (nonatomic, readwrite, retain) NSString *accessTokenURL;
@property (nonatomic, readwrite, retain) NSString *authorizeURL;
@property (nonatomic, readwrite, retain) NSString *callbackURL;

@property (nonatomic, readwrite, retain) NSString *consumerKey;
@property (nonatomic, readwrite, retain) NSString *consumerSecret;

-(BOOL)isAuthorized;

@end


