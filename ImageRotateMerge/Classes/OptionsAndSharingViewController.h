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

@interface OptionsAndSharingViewController : UITableViewController <MFMailComposeViewControllerDelegate> {

}

@property (nonatomic, retain) UISwitch *facebookSwitch;
@property (nonatomic, retain) UISwitch *twitterSwitch;
@property (nonatomic, retain) UISwitch *tumblrSwitch;

@property (nonatomic, retain) UIImage *image;

@property (nonatomic, retain) NSString *fbToken;
@property (nonatomic, retain) UITextField *txtField;
@end
