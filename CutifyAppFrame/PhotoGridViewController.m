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

@synthesize imagesArray, fileNamesArray, scrollView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//create images
	
	//UIImage *testImage = [UIImage imageNamed:@"ApplyStickerImage.png"]; 
//	for(int j = 0; j< 20; j++)
//	{
//		[imagesArray addObject:testImage];
//	}
	
	[self loadImagesFromDocumentsDirectory];
	
	UIScrollView *s = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,320,480-20-44)];
	[s setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"TableviewBackground.png"]]];
	int numOfColumns = 3;
	int numOfRows = self.imagesArray.count/numOfColumns+1;
	int space = 10;
	int width = (s.frame.size.width-(numOfColumns+1)*space)/numOfColumns;
	int height = width;
	int x = space;
	int y = space;
	for (int i=1; i<=self.imagesArray.count; i++) {
		UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(x,y,width,height)];
		[imageButton setImage:[self.imagesArray objectAtIndex:i-1] forState:UIControlStateNormal];
		[imageButton addTarget:self action:@selector(imageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[imageButton setTag:i-1];
		[imageButton setTitle:[self.fileNamesArray objectAtIndex:i-1] forState:UIControlStateReserved];
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
	self.scrollView = s;
	[s release];
	
	//setup buttons
	UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
	UIImage *photoButtonImage = [UIImage imageNamed:@"CameraBackButton.png"];
	[photoButton setFrame:CGRectMake(0,0,photoButtonImage.size.width, photoButtonImage.size.height)];
	[photoButton addTarget:self action:@selector(photoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[photoButton setImage:photoButtonImage forState:UIControlStateNormal];
	UIBarButtonItem *photoButtonItem = [[UIBarButtonItem alloc] initWithCustomView:photoButton];
	
	self.navigationItem.leftBarButtonItem = photoButtonItem;
	[photoButtonItem release];
}

-(void)viewWillAppear:(BOOL)animated
{
	//this will be triggered when a user deletes a photo
	[self loadImagesFromDocumentsDirectory];
	
	for(id eachView in [self.scrollView.subviews copy])
	{
		[eachView removeFromSuperview];
	}
	
	int numOfColumns = 3;
	int numOfRows = self.imagesArray.count/numOfColumns+1;
	int space = 10;
	int width = (self.scrollView.frame.size.width-(numOfColumns+1)*space)/numOfColumns;
	int height = width;
	int x = space;
	int y = space;
	for (int i=1; i<=self.imagesArray.count; i++) {
		UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(x,y,width,height)];
		[imageButton setImage:[self.imagesArray objectAtIndex:i-1] forState:UIControlStateNormal];
		[imageButton addTarget:self action:@selector(imageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[imageButton setTag:i-1];
		[imageButton setTitle:[self.fileNamesArray objectAtIndex:i-1] forState:UIControlStateReserved];
		[self.scrollView addSubview:imageButton];
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
	[self.scrollView setContentSize:CGSizeMake(contentWidth, contentHeight)];
}	
	

-(void)imageButtonPressed:(UIButton *)sender
{
	PhotoViewSharingViewController *photoViewSharingViewController = [[PhotoViewSharingViewController alloc] initWithStyle:UITableViewStyleGrouped];
	photoViewSharingViewController.image = sender.imageView.image;
	photoViewSharingViewController.fileName = [self.fileNamesArray objectAtIndex:sender.tag];
	[self.navigationController pushViewController:photoViewSharingViewController animated:YES];
	[photoViewSharingViewController release];
}

-(void)photoButtonPressed:(id)sender
{
	[self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)loadImagesFromDocumentsDirectory
{
	NSMutableArray *_imagesArray = [[NSMutableArray alloc] init];
	NSMutableArray *_fileNamesArray = [[NSMutableArray alloc] init];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; 
	
	for (NSString *fileName in [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL]) 
	{
		NSLog(@"Found file %@", fileName);
		if([fileName hasSuffix:@"jpg"])
		{
			NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
			[_imagesArray addObject:[UIImage imageWithContentsOfFile:filePath]];
			[_fileNamesArray addObject:fileName];
		}
	}
	self.imagesArray = _imagesArray;
	self.fileNamesArray = _fileNamesArray;
	[_imagesArray release];
	[_fileNamesArray release];
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
