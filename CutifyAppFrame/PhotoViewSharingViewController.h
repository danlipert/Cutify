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

@interface PhotoViewSharingViewController : UITableViewController <MFMailComposeViewControllerDelegate> 
{

}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString *fileName;
@property (nonatomic, retain) UITextField *txtField;

@end
