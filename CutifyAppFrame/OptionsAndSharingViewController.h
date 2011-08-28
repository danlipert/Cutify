//
//  OptionsAndSharingViewController.h
//  CutifyAppFrame
//
//  Created by Dan Lipert on 7/11/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#import "AuthViewController.h"

#import "TwitterViewController.h"
#import "FacebookViewController.h"
#import "TumblrViewController.h"

@interface OptionsAndSharingViewController : UITableViewController <MFMailComposeViewControllerDelegate, AuthViewControllerDelegate> {
	
	BOOL shareOnTwitter_;
	BOOL shareOnFacebook_;
	BOOL shareOnTumblr_;
	
}

@property (nonatomic, retain) UIView *blocker;

@property (nonatomic, retain) NSTimer *timer;

@property (nonatomic, retain) TwitterViewController *twitterVC;
@property (nonatomic, retain) FacebookViewController *facebookVC;
@property (nonatomic, retain) TumblrViewController *tumblrVC;

@property (nonatomic, retain) UISwitch *facebookSwitch;
@property (nonatomic, retain) UISwitch *twitterSwitch;
@property (nonatomic, retain) UISwitch *tumblrSwitch;

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) UITextField *txtField;

@end
