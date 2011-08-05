//
//  PhotoGridViewController.h
//  CutifyAppFrame
//
//  Created by Dan Lipert on 7/13/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PhotoGridViewController : UIViewController {

}

@property (nonatomic, retain) NSMutableArray *imagesArray;
@property (nonatomic, retain) NSMutableArray *fileNamesArray;
@property (nonatomic, retain) UIScrollView *scrollView;


@end
