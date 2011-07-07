//
//  CutifyStickerView.m
//  CutifyApp
//
//  Created by Dan Lipert on 6/2/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import "CutifyStickerView.h"


@implementation CutifyStickerView

@synthesize stickerImageView;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
 
    }
    return self;
}

-(id)init;
{
	if(self = [super init])
	{
		stickerImageView = [[UIImageView alloc] init];
		self.stickerImageView = stickerImageView;
		[self addSubview:stickerImageView];
		self.frame = stickerImageView.frame;
		[stickerImageView release];
	}
	return self;
}

-(void)setImage:(UIImage *)image
{
	[stickerImageView setImage:image];
	[stickerImageView setFrame:CGRectMake(stickerImageView.frame.origin.x, stickerImageView.frame.origin.y, stickerImageView.image.size.width, stickerImageView.image.size.height)];
	self.frame = stickerImageView.frame;
}

- (void)setFrame:(CGRect)frameRect
{
	[super setFrame:frameRect];
	[stickerImageView setFrame:frameRect];
}

-(void)viewDidUnload
{
	self.stickerImageView = nil;
}

- (void)dealloc {
    [super dealloc];
}


@end
