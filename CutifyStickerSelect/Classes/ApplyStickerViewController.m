    //
//  ApplyStickerViewController.m
//  CutifyStickerSelect
//
//  Created by Dan Lipert on 7/14/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import "ApplyStickerViewController.h"
#import "CutifyStickerPicker.h"

@implementation ApplyStickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	CutifyStickerPicker *picker = [[CutifyStickerPicker alloc] initWithFrame:CGRectMake(0,480-20-100,320,100)];
	[self.view addSubview:picker];
	[picker release];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
