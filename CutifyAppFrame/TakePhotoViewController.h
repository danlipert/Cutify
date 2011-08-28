//
//  TakePhotoViewController.h
//  CutifyAppFrame
//
//  Created by Dan Lipert on 7/11/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TakePhotoViewController : UIViewController 
{

}

@property (nonatomic, retain) UIButton *takePhotoButton;
@property (nonatomic, retain) UIButton *flashButton;
@property (nonatomic, retain) UIButton *photoLibraryButton;
@property (nonatomic, retain) UIImageView *maskImageView;

-(void)takePhotoButtonPressed:(id)sender;
-(void)photoLibraryButtonPressed:(id)sender;
-(void)flashButtonPressed:(id)sender;

@end
