//
//  CutifyStickerPicker.h
//  CutifyStickerSelect
//
//  Created by Dan Lipert on 7/14/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMOANode.h"
#import "TMOATree.h"

@interface CutifyStickerPicker : UIView 
{

}

@property (nonatomic, retain) UIScrollView *s;


//new tree based code

@property (nonatomic, retain) TMOATree *tree;
@property (nonatomic, retain) TMOANode *currentNode;
@property (nonatomic, retain) NSMutableArray *currentArray;

-(void)loadStickers:(NSArray *)stickerArray;
-(void)loadStickersFromPlist:(NSString *)plistName;

//tree code
-(TMOATree *)createTreeFromPlistNamed:(NSString *)plistName;
-(void)loadStickersFromCurrentNode;
-(void)loadTreeFromPlistNamed:(NSString *)plistName;

@end
