//
//  PhotoViewSharingViewController.h
//  CutifyAppFrame
//
//  Created by Dan Lipert on 7/12/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#import "AuthViewController.h"

#import "TwitterViewController.h"
#import "FacebookViewController.h"
#import "TumblrViewController.h"

@interface PhotoViewSharingViewController : UITableViewController <MFMailComposeViewControllerDelegate, AuthViewControllerDelegate>
{
	BOOL shareOnTwitter_;
	BOOL shareOnFacebook_;
	BOOL shareOnTumblr_;
	
	NSAutoreleasePool *serverRequestPool;
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
@property (nonatomic, retain) NSString *fileName;
@property (nonatomic, retain) UITextField *txtField;

@property (nonatomic, retain) NSAutoreleasePool *serverRequestPool;

@end
