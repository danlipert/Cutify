//
//  FacebookAuthViewController.h
//  CutifyAppFrame
//
//  Created by Dave Sluder on 8/9/11.
//  Copyright 2011 Night & Day Studios. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FacebookAuthViewController : UIViewController {

}

@property (nonatomic, readwrite, retain) id delegate;

@property (nonatomic, retain) UIWebView *loginWebview;

@end
