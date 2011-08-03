//
//  CutifyStickerView.h
//  CutifyApp
//
//  Created by Dan Lipert on 6/2/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CutifyStickerMeta.h"

@interface CutifyStickerView : UIView 
{

}

@property (nonatomic, retain) UIImageView *stickerImageView;
@property (nonatomic) float rotationDegrees;
@property (nonatomic) float scale;
@property (nonatomic) CGPoint centerPoint;

-(id)initWithStickerMeta:(CutifyStickerMeta *)stickerMeta;

@end
