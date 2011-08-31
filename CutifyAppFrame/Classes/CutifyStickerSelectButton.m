//
//  CutifyStickerSelectButton.m
//  CutifyStickerSelect
//
//  Created by Dan Lipert on 7/18/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import "CutifyStickerSelectButton.h"


@implementation CutifyStickerSelectButton

@synthesize stickerMeta, imageView, selectedImageView, backgroundImageView;

-(id)initWithFrame:(CGRect)frame
{
	if(self = [super initWithFrame:frame])
	{
		//create purple background
//		[self setBackgroundColor:[UIColor purpleColor]];
		
		self.imageView = nil;
		glossEffectImageView = nil;
		self.backgroundImageView = nil;
		self.selectedImageView = nil;
	}
	return self;
}

-(void)setImage:(UIImage *)_image
{
	float padding = 5;
	UIImageView *_imageView = [[UIImageView alloc] initWithImage:_image];
	[_imageView setFrame:CGRectMake(padding,padding,58-2*padding, 58-2*padding)];
//	[_imageView setCenter:self.center];
	[_imageView setContentMode:UIViewContentModeScaleAspectFit];
	
	if(self.backgroundImageView == nil)
	{
		self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ScrollControlIconBackground.png"]];
		[self addSubview:self.backgroundImageView];
	}
	
	if(self.imageView == nil)
	{
		self.imageView = _imageView;
		[self addSubview:self.imageView];
	} else {
		self.imageView = _imageView;
	}
	
	if(selectedImageView == nil)
	{
		selectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ScrollControlIconBackgroundSelected.png"]];
		[selectedImageView setAlpha:0.0f];
		[self addSubview:selectedImageView];
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
	self.backgroundImageView = nil;
}
	
	

@end
