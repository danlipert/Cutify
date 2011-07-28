//
//  CutifyStickerView.m
//  CutifyApp
//
//  Created by Dan Lipert on 6/2/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import "CutifyStickerView.h"
#import "CutifyStickerMeta.h"


@implementation CutifyStickerView

@synthesize stickerImageView, rotationDegrees;

//- (id)initWithFrame:(CGRect)frame {
//    
//    self = [super initWithFrame:frame];
//    if (self) {
// 
//    }
//    return self;
//}

//-(id)init;
//{
//	if(self = [super init])
//	{
//		stickerImageView = [[UIImageView alloc] init];
//		self.stickerImageView = stickerImageView;
//		[self addSubview:stickerImageView];
//		self.frame = stickerImageView.frame;
//		[stickerImageView release];
//	}
//	return self;
//}

-(id)initWithStickerMeta:(CutifyStickerMeta *)stickerMeta
{
	if(self = [super init])
	{
		UIImageView *stickerImageView = [[UIImageView alloc] initWithImage:stickerMeta.stickerImage];
		self.stickerImageView = stickerImageView;
		[stickerImageView release];

		[self addSubview:self.stickerImageView];
		self.frame = stickerImageView.frame;
		
		self.rotationDegrees = [NSNumber numberWithFloat:0.0];
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
