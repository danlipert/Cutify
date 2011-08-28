//
//  PhotoPreviewViewController.h
//  LuchaLibreUSA
//
//  Created by Dave Sluder on 7/16/11.
//  Copyright 2011 Dave Sluder. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoPreviewViewControllerDelegate;

@interface PhotoPreviewViewController : UIViewController <UIAlertViewDelegate> {
	
	id <PhotoPreviewViewControllerDelegate> delegate;
	
	IBOutlet UIImageView *imageView;
	
	UIImage *photo;
}

@property (nonatomic, retain) id <PhotoPreviewViewControllerDelegate> delegate;

@property (nonatomic, retain) UIImageView *imageView;

@property (nonatomic, retain) UIImage *photo;


- (id)initWithPhoto:(UIImage *)thePhoto;

- (IBAction)retakePhoto;
- (IBAction)usePhoto;


@end

@protocol PhotoPreviewViewControllerDelegate
- (void)photoSelected:(UIImage *)selectedPhoto;

@end