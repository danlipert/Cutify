//
//  CutifyStickerPicker.m
//  CutifyStickerSelect
//
//  Created by Dan Lipert on 7/14/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import "CutifyStickerPicker.h"
#import "CutifyStickerMeta.h"
#import "CutifyStickerSelectButton.h"

@implementation CutifyStickerPicker

@synthesize s, plistArray;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		self.plistArray = nil;
		
		NSMutableArray *stickerArray = [[NSMutableArray alloc] init];
		
		UIScrollView *_s = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,320,100)];
		self.s = _s;
		[self.s setBackgroundColor:[UIColor grayColor]];

		[self loadStickersFromPlist:@"StickerDemoPack"];
		
		[self addSubview:self.s];
    }
    return self;
}

-(void)imageButtonPressed:(id)sender
{
	if([sender isKindOfClass:[CutifyStickerSelectButton class]])
	{
		CutifyStickerSelectButton *button = (CutifyStickerSelectButton *)sender;
		if([button.stickerMeta.type isEqualToString:@"BackButton"])
		{
			//do back button stuff
			
		}
		[self loadStickersFromMetadata:button.stickerMeta];
	}
}

-(void)loadStickersFromMetadata:(CutifyStickerMeta *)metadata
{
	NSMutableArray *stickerArray = [[NSMutableArray alloc] init];
	
	if(self.plistArray == nil)
	{
		[self loadStickersFromPlist:@"StickerDemoPack.plist"];
	}
	
	if([metadata.type isEqualToString:@"Pack"])
	{
		CutifyStickerMeta *backButtonMeta = [[CutifyStickerMeta alloc] init];
		backButtonMeta.stickerLabelString = [NSString stringWithString:@"Back"];
		backButtonMeta.stickerImage = [UIImage imageNamed:@"ScrollControlBackButton.png"];
		backButtonMeta.type = [NSString stringWithString:@"BackButton"];
		
		[stickerArray addObject:backButtonMeta];
		[backButtonMeta release];
		
		for(NSDictionary *categoryDictionary in metadata.child)
		{
			CutifyStickerMeta *stickerMeta = [[CutifyStickerMeta alloc] init];
			stickerMeta.stickerLabelString = [NSString stringWithString:[categoryDictionary objectForKey:@"Name"]];
			stickerMeta.stickerImage = [UIImage imageNamed:[categoryDictionary objectForKey:@"Image"]];
			stickerMeta.parent = self.plistArray;
			stickerMeta.child = [categoryDictionary objectForKey:@"Stickers"];
			stickerMeta.type = [categoryDictionary objectForKey:@"Category"];
			[stickerArray addObject:stickerMeta];
		}
		
	} else if([metadata.type isEqualToString:@"Category"]) {
		
	} else if([metadata.type isEqualToString:@"Sticker"]) {
		
	}
	
	[self loadStickers:stickerArray];
	[stickerArray release];
}

-(void)loadStickersFromPlist:(NSString *)plistName
{
	NSString *pathToPlistInBundle = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"]; 
	
	//load file
	NSMutableArray *_plistArray = [[NSMutableArray alloc] initWithContentsOfFile:pathToPlistInBundle];
	self.plistArray = _plistArray;
	[_plistArray release];
	
	NSMutableArray *stickerArray = [[NSMutableArray alloc] init];
	
		
	for(NSDictionary *setDictionary in self.plistArray)
	{
		CutifyStickerMeta *stickerMeta = [[CutifyStickerMeta alloc] init];
		stickerMeta.stickerLabelString = [NSString stringWithString:[setDictionary objectForKey:@"Name"]];
		stickerMeta.stickerImage = [UIImage imageNamed:[setDictionary objectForKey:@"Image"]];
		stickerMeta.parent = self.plistArray;
		stickerMeta.child = [setDictionary objectForKey:@"Categories"];
		stickerMeta.type = [setDictionary objectForKey:@"Type"];
		[stickerArray addObject:stickerMeta];
		
		[stickerMeta release];
	}
		
	[self loadStickers:stickerArray];
	[stickerArray release];
}

-(void)loadStickers:(NSArray *)stickerArray
{
	for(UIButton *button in [self.s.subviews copy])
	{
		[button removeFromSuperview];
	}
	
	int numOfColumns = 4;
	int numOfRows = 1;
	int space = 12;
	int width = (self.s.frame.size.width-(numOfColumns+1)*space)/numOfColumns;
	int height = width;
	int x = space;
	int y = 10;
	for (int i=1; i<=stickerArray.count; i++) {
		CutifyStickerSelectButton *imageButton = [[CutifyStickerSelectButton alloc] initWithFrame:CGRectMake(x,y,width,height)];
		[imageButton setImage:[[stickerArray objectAtIndex:i-1] stickerImage] forState:UIControlStateNormal];
		[imageButton addTarget:self action:@selector(imageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[imageButton setTag:i-1];
		[imageButton setStickerMeta:[stickerArray objectAtIndex:i-1]];
		[self.s addSubview:imageButton];
		[imageButton release];
		
		UILabel *stickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(x,y+60,width,30)];
		[stickerLabel setText:[[stickerArray objectAtIndex:i-1] stickerLabelString]];
		[stickerLabel setBackgroundColor:[UIColor clearColor]];
		[stickerLabel setTextColor:[UIColor whiteColor]];
		[stickerLabel setFont:[UIFont systemFontOfSize:10]];
		[stickerLabel setShadowColor:[UIColor darkGrayColor]];
		[stickerLabel setShadowOffset:CGSizeMake(1, 1)];
		[stickerLabel setTextAlignment:UITextAlignmentCenter];
		[self.s addSubview:stickerLabel];
		[stickerLabel release];
		
		x+=space+width;
	}

	int contentWidth = (space+width)*[stickerArray count]+space;
	int contentHeight = 70;
	
	[self.s setContentSize:CGSizeMake(contentWidth, contentHeight)];
}

- (void)dealloc {
    [super dealloc];
}


@end
