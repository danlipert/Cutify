//
//  FacebookViewController.h
//  FacebookDemo
//
//  Created by Dan Lipert on 8/1/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FacebookViewController : UIViewController 
{
	
}

@property (nonatomic, retain) UIButton *facebookButton;
@property (nonatomic, retain) id delegate;
-(void)reloadFacebookWebview;

@end
