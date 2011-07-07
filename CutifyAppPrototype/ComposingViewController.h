//
//  ComposingViewController.h
//  CutifyAppPrototype
//
//  Created by Dan Lipert on 6/23/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ComposingViewController : UIViewController <UIGestureRecognizerDelegate>
{
}

@property (nonatomic, retain) UIImageView *photoImageView;
@property (nonatomic, retain) UIButton *addStickerButton;
@property (nonatomic, retain) UIButton *saveButton;
@property (nonatomic, retain) UIButton *takePhotoButton;
@property (nonatomic, retain) UIButton *loadPhotoButton;
@property (nonatomic, retain) CutifyStickerView *stickerForReset;
@property (nonatomic, retain) NSMutableArray *stickersArray;

- (void)addGestureRecognizersToSticker:(CutifyStickerView *)sticker;
- (void)addStickerButtonPressed:(id)sender;
- (void)saveButtonPressed:(id)sender;
- (void)takePhotoButtonPressed:(id)sender;

@end
