//
//  CutifyStickerSelectButton.h
//  CutifyStickerSelect
//
//  Created by Dan Lipert on 7/18/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CutifyStickerMeta.h"

@interface CutifyStickerSelectButton :UIButton 
{
	UIImageView *glossEffectImageView;
}

@property (nonatomic, retain) CutifyStickerMeta *stickerMeta;

@property (nonatomic, retain) UIImageView *imageView;
@end
