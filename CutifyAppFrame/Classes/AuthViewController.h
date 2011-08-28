//
//  AuthViewController.h
//  CutifyAppFrame
//
//  Created by Dave Sluder on 8/26/11.
//  Copyright 2011 Night & Day Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AuthViewControllerDelegate;

@interface AuthViewController : UIViewController {

}

@property (nonatomic, readwrite, retain) id<AuthViewControllerDelegate> delegate;

@property (nonatomic, readwrite, retain) NSString *serviceName;

@property (nonatomic, retain) UIView *blocker;

@property (nonatomic, retain) NSTimer *timer;

@end

@protocol AuthViewControllerDelegate
-(void)authenticationSuccessForService:(NSString *)name;
-(void)authenticationFailedForService:(NSString *)name;
-(void)serviceUnavailable:(NSString *)name;
-(void)resetAuthViewControllerForService:(NSString *)name;
@end
