//
//  CutifyStickerPicker.m
//  CutifyStickerSelect
//
//  Created by Dan Lipert on 7/14/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import "CutifyStickerPicker.h"
#import "CutifyStickerMeta.h"
#import "CutifyStickerButton.h"

@implementation CutifyStickerPicker

@synthesize s;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
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
	if([sender isKindOfClass:[CutifyStickerButton class]])
	{
		CutifyStickerSelectButton *button = (CutifyStickerSelectButton *)sender;
		[self loadStickersFromMetadata:button.stickerMeta];
	}
//	NSMutableArray *imagesArray = [[NSMutableArray alloc] init];
//	
//	UIImage *testImage = [UIImage imageNamed:@"InAppPurchaseKittyPack.png"]; 
//	for(int j = 0; j< 3; j++)
//	{
//		[imagesArray addObject:testImage];
//	}
//	
//	[self loadStickers:imagesArray];
//	[imagesArray release];
}

-(void)loadStickersFromMetadata:(CutifyStickerMeta *)metadata
{
	if([metadata.type isEqualToString:@"Pack"])
	{
		
}

-(void)loadStickersFromPlist:(NSString *)plistName
{
	//find plist file

	
	// If it's not there, copy it from the bundle 
	NSFileManager *fileManager = [NSFileManager defaultManager]; 

	NSString *pathToSettingsInBundle = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"]; 
	
	
	//load file
	NSMutableArray *plistArray = [[NSMutableArray alloc] initWithContentsOfFile:pathToSettingsInBundle];
	
	NSMutableArray *stickerArray = [[NSMutableArray alloc] init];
	
	for(NSDictionary *setDictionary in plistArray)
	{
		CutifyStickerMeta *stickerMeta = [[CutifyStickerMeta alloc] init];
		stickerMeta.stickerLabelString = [NSString stringWithString:[setDictionary objectForKey:@"Name"]];
		stickerMeta.stickerImage = [UIImage imageNamed:[setDictionary objectForKey:@"Image"]];
		stickerMeta.parent = plistArray;
		stickerMeta.child = [setDictionary objectForKey:@"Categories"];
		stickerMeta.type = [setDictionary objectForKey:@"Type"];
		[stickerArray addObject:stickerMeta];
	}
	
	[plistArray release];
	
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
		CutifyStickerButton *imageButton = [[CutifyStickerButton alloc] initWithFrame:CGRectMake(x,y,width,height)];
		[imageButton setImage:[[stickerArray objectAtIndex:i-1] stickerImage] forState:UIControlStateNormal];
		[imageButton addTarget:self action:@selector(imageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[imageButton setTag:i-1];
		[imageButton setStickerMeta:[stickerArray objectAtIndex:i-1]];
		imageButton.type = [[stickerArray objectAtIndex:i-1] type];
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
