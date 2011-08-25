//
//  CutifyStickerSelectButton.m
//  CutifyStickerSelect
//
//  Created by Dan Lipert on 7/18/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import "CutifyStickerSelectButton.h"


@implementation CutifyStickerSelectButton

@synthesize stickerMeta, imageView;

-(id)initWithFrame:(CGRect)frame
{
	if(self = [super initWithFrame:frame])
	{
		//create purple background
//		[self setBackgroundColor:[UIColor purpleColor]];
		
		self.imageView = nil;
		glossEffectImageView = nil;
		backgroundImageView = nil;
	}
	return self;
}

-(void)setImage:(UIImage *)_image
{
	UIImageView *_imageView = [[UIImageView alloc] initWithImage:_image];
	[_imageView setFrame:CGRectMake(0,0,58, 58)];
//	[_imageView setCenter:self.center];
	[_imageView setContentMode:UIViewContentModeScaleAspectFit];
	
	if(backgroundImageView == nil)
	{
		backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ScrollControlIconBackground.png"]];
		[self addSubview:backgroundImageView];
	}
	
	if(self.imageView == nil)
	{
		self.imageView = _imageView;
		[self addSubview:self.imageView];
	} else {
		self.imageView = _imageView;
	}
	
	if(glossEffectImageView == nil)
	{
		glossEffectImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ScrollControlIconGloss.png"]];
		[self addSubview:glossEffectImageView];
	}  else {
		[self bringSubviewToFront:glossEffectImageView];
	}
}

-(void)setBackButton
{
	UIImageView *_imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ScrollControlBackButton.png"]];
	[_imageView setFrame:CGRectMake(0,0,58, 58)];
	[_imageView setContentMode:UIViewContentModeScaleAspectFit];
	self.imageView = _imageView;
	[self addSubview:self.imageView];
}

-(void)setIAPButton
{
	UIImageView *_imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BuyMorePacksButton.png"]];
	[_imageView setFrame:CGRectMake(0,0,58, 58)];
	[_imageView setContentMode:UIViewContentModeScaleAspectFit];	
	
	self.imageView = _imageView;
	[self addSubview:self.imageView];
}

-(void)dealloc
{
	[super dealloc];
	
	self.stickerMeta = nil;
	self.imageView = nil;
	
	[glossEffectImageView release];
	[backgroundImageView release];
}
	
	

@end
