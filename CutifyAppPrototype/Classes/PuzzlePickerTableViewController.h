//
//  PuzzlePickerTableViewController.h
//  EdEmLevelEdit
//
//  Created by Daniel Lipert on 1/5/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PuzzlePickerTableViewController : UITableViewController 
{
	NSMutableArray *fileNames;
	id delegate;
}

@property (nonatomic, retain) id delegate;

@end
