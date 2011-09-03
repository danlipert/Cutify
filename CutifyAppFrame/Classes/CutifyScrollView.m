//
//  CutifyScrollView.m
//  CutifyAppFrame
//
//  Created by Dan Lipert on 8/29/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import "CutifyScrollView.h"
#import "CutifyStickerView.h"

@implementation CutifyScrollView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

//this prevents the scrollview from scrolling if the tap is inside a sticker view!
- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{	
	if ([view isKindOfClass:[CutifyStickerView class]])
		return NO;
	else 
		return YES;
}


- (void)dealloc {
    [super dealloc];
}


@end
