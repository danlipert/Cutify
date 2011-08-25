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

@synthesize rotationDegrees, centerPoint, scale, originPoint;

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
	//	UIImageView *stickerImageView = [[UIImageView alloc] initWithImage:stickerMeta.stickerImage];
//		[stickerImageView setContentMode:UIViewContentModeScaleAspectFit];
//		self.stickerImageView = stickerImageView;
//		[stickerImageView release];
//
//		[self addSubview:self.stickerImageView];
//		self.frame = stickerImageView.frame;
		
		[self setImage:stickerMeta.stickerImage];
		[self setContentMode:UIViewContentModeScaleAspectFit];
//		self.stickerImageView = stickerImageView;
//		[stickerImageView release];
		
//		[self addSubview:self.stickerImageView];
		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, stickerMeta.stickerImage.size.width, stickerMeta.stickerImage.size.height);
		
		
		self.rotationDegrees = 0.0f;
		//bug, scale not set correctly
		self.scale = 1.0f;
		
//		self.scale = self.stickerImageView.frame.size.width / self.stickerImageView.image.size.width;
		
		self.clipsToBounds = YES;
		//debug
//		[self setBackgroundColor:[UIColor purpleColor]];
	}
	return self;
}

//-(void)setImage:(UIImage *)image
//{
//	[stickerImageView setImage:image];
//	[stickerImageView setFrame:CGRectMake(stickerImageView.frame.origin.x, stickerImageView.frame.origin.y, stickerImageView.image.size.width, stickerImageView.image.size.height)];
//	self.frame = stickerImageView.frame;
//}

//- (void)setFrame:(CGRect)frameRect
//{
//	NSLog(@"Sticker setframe called");
//	[super setFrame:frameRect];
//	[stickerImageView setFrame:frameRect];
//}

-(void)viewDidUnload
{
}

- (void)dealloc {
    [super dealloc];
}


@end
