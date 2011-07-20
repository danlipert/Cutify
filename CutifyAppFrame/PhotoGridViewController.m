    //
//  PhotoGridViewController.m
//  CutifyAppFrame
//
//  Created by Dan Lipert on 7/13/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import "PhotoGridViewController.h"
#import "PhotoViewSharingViewController.h"

@implementation PhotoGridViewController




// Implement loadView to create a view hierarchy programmatically, without using a nib.
//- (void)loadView {
//	
//
//	
//}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//create images
	NSMutableArray *imagesArray = [[NSMutableArray alloc] init];
	
	UIImage *testImage = [UIImage imageNamed:@"ApplyStickerImage.png"]; 
	for(int j = 0; j< 20; j++)
	{
		[imagesArray addObject:testImage];
	}
	
	UIScrollView *s = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,320,480-20-44)];
	[s setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"TableviewBackground.png"]]];
	int numOfColumns = 3;
	int numOfRows = imagesArray.count/numOfColumns+1;
	int space = 10;
	int width = (s.frame.size.width-(numOfColumns+1)*space)/numOfColumns;
	int height = width;
	int x = space;
	int y = space;
	for (int i=1; i<=imagesArray.count; i++) {
		UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(x,y,width,height)];
		[imageButton setImage:[imagesArray objectAtIndex:i-1] forState:UIControlStateNormal];
		[imageButton addTarget:self action:@selector(imageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[imageButton setTag:i-1];
		[s addSubview:imageButton];
		[imageButton release];
		if (i%numOfColumns == 0) {
			y += space+height;
			x = space;
		} else {
			x+=space+width;
		}
	}
	int contentWidth = numOfColumns*(space+width)+space;
	int contentHeight = numOfRows*(space+height)+space;
	[s setContentSize:CGSizeMake(contentWidth, contentHeight)];
	[self.view addSubview:s];
	
	//setup buttons
	UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
	UIImage *cancelButtonImage = [UIImage imageNamed:@"BackButton.png"];
	[cancelButton setFrame:CGRectMake(0,0,cancelButtonImage.size.width, cancelButtonImage.size.height)];
	[cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[cancelButton setImage:cancelButtonImage forState:UIControlStateNormal];
	UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
	
	self.navigationItem.leftBarButtonItem = cancelButtonItem;
	[cancelButtonItem release];
}

-(void)imageButtonPressed:(id)sender
{
	PhotoViewSharingViewController *photoViewSharingViewController = [[PhotoViewSharingViewController alloc] initWithStyle:UITableViewStyleGrouped];
	[self.navigationController pushViewController:photoViewSharingViewController animated:YES];
	[photoViewSharingViewController release];
}

-(void)cancelButtonPressed:(id)sender
{
	[self.navigationController popToRootViewControllerAnimated:YES];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
