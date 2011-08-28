//
//  ApplyStickersViewController.h
//  CutifyAppFrame
//
//  Created by Dan Lipert on 7/12/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CutifyStickerView.h"

@interface ApplyStickersViewController : UIViewController <UIScrollViewDelegate, UIAlertViewDelegate>
{

}

@property (nonatomic, retain) UIImageView *photoImageView;
@property (nonatomic, retain) UIView *stickerContainerView;
@property (nonatomic, retain) UIView *masterContainerView;
@property (nonatomic, retain) UIImage *photoImage;
@property (nonatomic, retain) UIScrollView *photoScrollView;
@property (nonatomic, retain) CutifyStickerView *stickerForReset;
@property (nonatomic, retain) NSMutableArray *stickersArray;

@end
