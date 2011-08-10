//
//  PhotoCaptureViewController.h
//  LuchaLibreUSA
//
//  Created by Dave Sluder on 7/16/11.
//  Copyright 2011 Dave Sluder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaptureSessionManager.h"
#import "PhotoPreviewViewController.h"

@protocol PhotoCaptureViewControllerDelegate;

@interface PhotoCaptureViewController : UIViewController <PhotoPreviewViewControllerDelegate, UIGestureRecognizerDelegate> {

	id <PhotoCaptureViewControllerDelegate> delegate;
	
	PhotoPreviewViewController *ppVC;
	
}

@property (retain) CaptureSessionManager *captureManager;

@property (nonatomic, retain) PhotoPreviewViewController *ppVC;

@property (nonatomic, retain) id <PhotoCaptureViewControllerDelegate> delegate;

@property (nonatomic, retain) UIButton *flashButton;


@end

@protocol PhotoCaptureViewControllerDelegate
- (void)photoSelected:(UIImage *)selectedPhoto;
@end