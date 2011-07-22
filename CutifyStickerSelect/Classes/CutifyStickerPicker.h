//
//  CutifyStickerPicker.h
//  CutifyStickerSelect
//
//  Created by Dan Lipert on 7/14/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CutifyStickerPicker : UIView 
{

}

@property (nonatomic, retain) UIScrollView *s;
@property (nonatomic, retain) NSArray *plistArray;

-(void)loadStickers:(NSArray *)stickerArray;
-(void)loadStickersFromPlist:(NSString *)plistName;

@end
