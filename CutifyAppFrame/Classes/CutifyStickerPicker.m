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
#import "TMOANode.h"
#import "TMOATree.h"

@implementation CutifyStickerPicker

@synthesize s, currentArray, tree, currentNode, delegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {				
		UIScrollView *_s = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,320,100)];
		self.s = _s;
		[self.s setBackgroundColor:[UIColor clearColor]];

		//setup background
		UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,100)];
		[backgroundImage setImage:[UIImage imageNamed:@"ScrollControlBackground.png"]];
		[self addSubview:backgroundImage];
		
//		[self loadStickersFromPlist:@"StickerDemoPack"];
		[self loadTreeFromPlistNamed:@"test82911"];
		
		[self loadStickersFromCurrentNode];
		
		[self loadStickers:self.currentArray];
		
		[self addSubview:self.s];
    }
    return self;
}

//new code

-(void)loadStickersFromCurrentNode
{
	NSMutableArray *stickerArray = [[NSMutableArray alloc] init];
	
	//load backButton if required
	if(self.currentNode != self.tree.rootNode)
	{
		CutifyStickerMeta *backButtonMeta = [[CutifyStickerMeta alloc] init];
		backButtonMeta.stickerLabelString = [NSString stringWithString:@"Back"];
//		backButtonMeta.stickerImage = [UIImage imageNamed:@"ScrollControlBackButton.png"];
		backButtonMeta.type = [NSString stringWithString:@"BackButton"];
		
		[stickerArray addObject:backButtonMeta];
		[backButtonMeta release];
	} 
	
	
	for(TMOANode *childNode in [self.tree childrenOfNode:self.currentNode])
	{
		NSDictionary *childDictionary = childNode.dictionary;
		CutifyStickerMeta *stickerMeta = [[CutifyStickerMeta alloc] init];

		stickerMeta.stickerImage = [UIImage imageNamed:[childDictionary objectForKey:@"Image"]];
		NSLog(@"Loading sticker: %@", [childDictionary objectForKey:@"Image"]);
		stickerMeta.stickerLabelString = [childDictionary objectForKey:@"Name"];
		stickerMeta.type = [childDictionary objectForKey:@"Type"];
		
		[stickerArray addObject:stickerMeta];
		[stickerMeta release];
	}
	
	//IAP BUTTON
	if([self.currentNode isRoot])
	{
		CutifyStickerMeta *IAPButtonMeta = [[CutifyStickerMeta alloc] init];
		IAPButtonMeta.stickerLabelString = [NSString stringWithString:@"Buy Packs"];
		//		backButtonMeta.stickerImage = [UIImage imageNamed:@"ScrollControlBackButton.png"];
		IAPButtonMeta.type = [NSString stringWithString:@"IAP"];
		
		[stickerArray addObject:IAPButtonMeta];
		[IAPButtonMeta release];
		NSLog(@"added IAPButton");
	}
	
	self.currentArray = stickerArray;
	[stickerArray release];
}

-(void)loadTreeFromPlistNamed:(NSString *)plistName
{
	//VERIFIED WORKING
	//create root & tree
	TMOANode *rootNode = [[TMOANode alloc] init];
	TMOATree *_tree = [[TMOATree alloc] initWithRootNode:rootNode];
	self.currentNode = rootNode;
	self.tree = _tree;
	[_tree release];
	
	NSString *pathToPlistInBundle = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"]; 
	
	//load file
	NSMutableArray *plistArray = [[NSMutableArray alloc] initWithContentsOfFile:pathToPlistInBundle];

	for(NSMutableDictionary *setDictionary in plistArray)
	{
		TMOANode *setNode = [[TMOANode alloc] init];
		setNode.dictionary = setDictionary;
		if([self.tree addChild:setNode toNode:rootNode] == FALSE)
		{
			NSLog(@"ADDING NODE TO ROOT FAILED");
		}
		
		for(NSMutableDictionary *categoryDictionary in [setNode.dictionary objectForKey:@"Categories"])
		{
			TMOANode *categoryNode = [[TMOANode alloc] init];
			categoryNode.dictionary = categoryDictionary;
			if([self.tree addChild:categoryNode toNode:setNode] == FALSE)
			{
				NSLog(@"ADDING NODE TO SET FAILED");
			}
			
			for(NSMutableDictionary *stickerDictionary in [categoryNode.dictionary objectForKey:@"Stickers"])
			{
				TMOANode *stickerNode = [[TMOANode alloc] init];
				stickerNode.dictionary = stickerDictionary;
				if([self.tree addChild:stickerNode toNode:categoryNode] == FALSE)
				{
					NSLog(@"ADDING NODE TO CATEGORY FAILED");
				}
				
				[stickerNode release];
			}
			
			[categoryNode release];
		}
		
		[setNode release];
	}
	
	[rootNode release];
	[plistArray release];
}
				
	
-(void)imageButtonPressed:(id)sender
{
	if([sender isKindOfClass:[CutifyStickerSelectButton class]])
	{
		CutifyStickerSelectButton *button = (CutifyStickerSelectButton *)sender;

		//detect back button
		if([button.stickerMeta.type isEqualToString:@"BackButton"])
		{
			self.currentNode = [self.tree parentOfNode:self.currentNode];
			[self loadStickersFromCurrentNode];
			[self loadStickers:self.currentArray];
			return;
		} else if([button.stickerMeta.type isEqualToString:@"IAP"]) {
			//detect IAP button
			[delegate iapButtonPressed:button];
			return;
		}
		

		//find child node 
		for(TMOANode *eachChildNode in [self.tree childrenOfNode:self.currentNode])
		{
			if([[eachChildNode.dictionary objectForKey:@"Name"] isEqualToString:button.stickerMeta.stickerLabelString])
			{
				self.currentNode = eachChildNode;
				//detect leaf
				if([self.currentNode isLeaf])
				{
					self.currentNode = self.currentNode.parent;

					//call method on delegate applyStickersViewController
					[delegate stickerPickerDidPickSticker:button.stickerMeta];
					
					[UIView animateWithDuration:0.3f animations:
						^{
							[button.selectedImageView setAlpha:1.0f];
							[button.backgroundImageView setAlpha:0.0f];
						}
						completion:^(BOOL finished){
							[button.selectedImageView setAlpha:0.0f];
							[button.backgroundImageView setAlpha:1.0f];
						}
					 ];
					
					return;
				} 
				
				[self loadStickersFromCurrentNode];
				[self loadStickers:self.currentArray];
				return;
			}
		}
	}
}
//
//-(void)loadStickersFromMetadata:(CutifyStickerMeta *)metadata
//{
//	
//	NSMutableArray *stickerArray = [[NSMutableArray alloc] init];
//	
//	if(self.plistArray == nil)
//	{
//		[self loadStickersFromPlist:@"StickerDemoPack.plist"];
//	}
//	
//	if([metadata.type isEqualToString:@"BackButton"])
//	{
//		[stickerArray addObjectsFromArray:oldArray];
//	} else if([metadata.type isEqualToString:@"Pack"]) {
//		CutifyStickerMeta *backButtonMeta = [[CutifyStickerMeta alloc] init];
//		backButtonMeta.stickerLabelString = [NSString stringWithString:@"Back"];
//		backButtonMeta.stickerImage = [UIImage imageNamed:@"ScrollControlBackButton.png"];
//		backButtonMeta.type = [NSString stringWithString:@"BackButton"];
//		backButtonMeta.parent = self.plistArray;
//		
//		[stickerArray addObject:backButtonMeta];
//		[backButtonMeta release];
//				
//		for(NSDictionary *categoryDictionary in metadata.child)
//		{
//			CutifyStickerMeta *stickerMeta = [[CutifyStickerMeta alloc] init];
//			stickerMeta.stickerLabelString = [NSString stringWithString:[categoryDictionary objectForKey:@"Name"]];
//			stickerMeta.stickerImage = [UIImage imageNamed:[categoryDictionary objectForKey:@"Image"]];
//			stickerMeta.parent = self.plistArray;
//			stickerMeta.child = [categoryDictionary objectForKey:@"Stickers"];
//			stickerMeta.type = [NSString stringWithString:@"Category"];
//			[stickerArray addObject:stickerMeta];
//		}
//		
//	} else if([metadata.type isEqualToString:@"Category"]) {
//		CutifyStickerMeta *backButtonMeta = [[CutifyStickerMeta alloc] init];
//		backButtonMeta.stickerLabelString = [NSString stringWithString:@"Back"];
//		backButtonMeta.stickerImage = [UIImage imageNamed:@"ScrollControlBackButton.png"];
//		backButtonMeta.type = [NSString stringWithString:@"BackButton"];
//		backButtonMeta.parent = self.plistArray;
//		
//		[stickerArray addObject:backButtonMeta];
//		[backButtonMeta release];
//		
//		for(NSDictionary *stickerDictionary in metadata.child)
//		{
//			CutifyStickerMeta *stickerMeta = [[CutifyStickerMeta alloc] init];
//			stickerMeta.stickerLabelString = [NSString stringWithString:[stickerDictionary objectForKey:@"Name"]];
//			stickerMeta.stickerImage = [UIImage imageNamed:[stickerDictionary objectForKey:@"Image"]];
//			stickerMeta.parent = self.currentArray;
//			stickerMeta.child = nil;
//			stickerMeta.type = @"Sticker";
//			[stickerArray addObject:stickerMeta];
//		}
//		
//		self.oldestArray = self.oldArray;
//		
//	} else if([metadata.type isEqualToString:@"Sticker"]) {
//		NSLog(@"Placing sticker %@", metadata.stickerLabelString);
//		[stickerArray addObjectsFromArray:self.currentArray];
//	} else {
//		NSLog(@"Unexpected flow");
//	}
//	
//	[self loadStickers:stickerArray];
//	
//	//no more drilling down after sticker
//	if ([metadata.type isEqualToString:@"BackButton"] && metadata.child == nil)
//	{
//		self.oldArray = self.oldestArray;
//	} else if([metadata.type isEqualToString:@"Sticker"] == FALSE) {
//		self.oldArray = self.currentArray;
//		self.currentArray = stickerArray;
//	} 
//		
//	[stickerArray release];
//}

//-(void)loadStickersFromPlist:(NSString *)plistName
//{
//	NSString *pathToPlistInBundle = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"]; 
//	
//	//load file
//	NSMutableArray *_plistArray = [[NSMutableArray alloc] initWithContentsOfFile:pathToPlistInBundle];
//	self.plistArray = _plistArray;
//	[_plistArray release];
//	
//	self.oldArray = nil;
//	
//	NSMutableArray *stickerArray = [[NSMutableArray alloc] init];
//		
//	for(NSDictrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrionary *setDictionary in self.plistArray)
//	{
//		CutifyStickerMeta *stickerMeta = [[CutifyStickerMeta alloc] init];
//		stickerMeta.stickerLabelString = [NSString stringWithString:[setDictionary objectForKey:@"Name"]];
//		stickerMeta.stickerImage = [UIImage imageNamed:[setDictionary objectForKey:@"Image"]];
//		stickerMeta.parent = self.plistArray;
//		stickerMeta.child = [setDictionary objectForKey:@"Categories"];
//		stickerMeta.type = [setDictionary objectForKey:@"Type"];
//		[stickerArray addObject:stickerMeta];
//		
//		[stickerMeta release];
//	}
//		
//	[self loadStickers:stickerArray];
//	self.currentArray = stickerArray;
//	[stickerArray release];
//}

-(void)loadStickers:(NSArray *)stickerArray
{
	for(UIButton *button in [self.s.subviews copy])
	{
//		[button removeFromSuperview];
		[UIView animateWithDuration:0.15f animations:^{
			if(button.frame.origin.x > 320)
			{
				[button setAlpha:0.0];
			}
		}
						 completion:^(BOOL finished){
							 [button removeFromSuperview];
						 }];
		
	}
	
	int numOfColumns = 4;
//	int numOfRows = 1;
	int space = 17;
	int width = (self.s.frame.size.width-(numOfColumns+1)*space)/numOfColumns;
	int height = width;
	int x = space;
	int y = 10;
	for (int i=1; i<=stickerArray.count; i++) {
		CutifyStickerSelectButton *imageButton = [[CutifyStickerSelectButton alloc] initWithFrame:CGRectMake(x,y,width,height)];
//		[imageButton setImage:[[stickerArray objectAtIndex:i-1] stickerImage] forState:UIControlStateNormal];
		
		if([[[stickerArray objectAtIndex:i-1] type] isEqualToString:@"BackButton"])
		{
			[imageButton setBackButton];
		} else if ([[[stickerArray objectAtIndex:i-1] type] isEqualToString:@"IAP"]) {
			[imageButton setIAPButton];
			NSLog(@"created iapButton");
		} else {
			[imageButton setImage:[[stickerArray objectAtIndex:i-1] stickerImage]];
		}
		
		[imageButton addTarget:self action:@selector(imageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[imageButton setTag:i-1];
//		[imageButton setContentMode:UIViewContentModeScaleAspectFill];
		[imageButton setStickerMeta:[stickerArray objectAtIndex:i-1]];
		[imageButton setAlpha:0.0];
		[self.s addSubview:imageButton];
		
		UILabel *stickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(x,y+60,width,30)];
		[stickerLabel setText:[[stickerArray objectAtIndex:i-1] stickerLabelString]];
		[stickerLabel setBackgroundColor:[UIColor clearColor]];
		[stickerLabel setTextColor:[UIColor whiteColor]];
		[stickerLabel setFont:[UIFont systemFontOfSize:10]];
		[stickerLabel setShadowColor:[UIColor darkGrayColor]];
		[stickerLabel setShadowOffset:CGSizeMake(1, 1)];
		[stickerLabel setTextAlignment:UITextAlignmentCenter];
		[stickerLabel setAlpha:0.0];
		[self.s addSubview:stickerLabel];
		
		x+=space+width;
		
		if(imageButton.frame.origin.x > 320)
		{
			[imageButton setAlpha:1.0];
			[stickerLabel setAlpha:1.0];
		} else {
			[UIView animateWithDuration:0.15f delay:0.15f options:nil animations:^{
				[stickerLabel setAlpha:1.0];
				[imageButton setAlpha:1.0];
			}
			completion:nil];
			 
//			[UIView animateWithDuration:0.3f animations:^{
//				[stickerLabel setAlpha:1.0];
//				[imageButton setAlpha:1.0];
//			}];
		}
		
		[stickerLabel release];
		[imageButton release];
	}

	int contentWidth = (space+width)*[stickerArray count]+space;
	int contentHeight = 70;
	
	[self.s setContentSize:CGSizeMake(contentWidth, contentHeight)];
	[self.s setContentOffset:CGPointMake(0,0) animated:YES];
}


- (void)dealloc {
    [super dealloc];
}


@end
