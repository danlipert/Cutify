//
//  TwitterAuthViewController.h
//  CutifyAppFrame
//
//  Created by Dave Sluder on 8/9/11.
//  Copyright 2011 Night & Day Studios. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"

@interface TwitterAuthViewController : UIViewController {
	
	IBOutlet UITableView *tableView;
	IBOutlet UITextField *textfield;
	
	SA_OAuthTwitterEngine *_engine;
	NSMutableArray *tweets;
}

@property (nonatomic, readwrite, retain) id delegate;

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UITextField *textfield;



@end
