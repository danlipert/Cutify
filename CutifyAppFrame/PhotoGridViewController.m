    //
//  PhotoGridViewController.m
//  CutifyAppFrame
//
//  Created by Dan Lipert on 7/13/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import "PhotoGridViewController.h"
#import "PhotoViewSharingViewController.h"
#import "DSActivityView.h"

@implementation PhotoGridViewController

@synthesize imagesArray, fileNamesArray, scrollView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
		
    [super viewDidLoad];
	
	UIScrollView *s = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,320,480-20-44)];
	self.scrollView = s;
	[s release];
	
	[self.scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"TableviewBackground.png"]]];
	[self.view addSubview:self.scrollView];
	
	[self setupButtons];
	
//	[self layoutScrollview];
	
}

-(void)viewDidAppear:(BOOL)animated
{
	[DSBezelActivityView newActivityViewForView:self.view];

	[self performSelectorInBackground:@selector(layoutScrollview) withObject:nil];
}

-(void)setupButtons
{
	//setup buttons
	UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
	UIImage *cancelButtonImage = [UIImage imageNamed:@"CameraBackButton.png"];
	[cancelButton setFrame:CGRectMake(0,0,cancelButtonImage.size.width, cancelButtonImage.size.height)];
	[cancelButton addTarget:self action:@selector(photoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[cancelButton setImage:cancelButtonImage forState:UIControlStateNormal];
	UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
	
	//	UIButton *flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
	//	UIImage *flashImage = [UIImage imageNamed:
	
	self.navigationItem.leftBarButtonItem = cancelButtonItem;
	[cancelButtonItem release];
}

-(void)layoutScrollview
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
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
	NSLog(@"images in image array... %i", [self.imagesArray count]);
	for (int i=1; i<=self.imagesArray.count; i++) {
		
		//		[imageButton setImage:[self.imagesArray objectAtIndex:i-1] forState:UIControlStateNormal];
		
		UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(x,y,width,height)];
		NSString *imagePath = [fileNamesArray objectAtIndex:i-1];
		NSData *imageData = [[NSData alloc] initWithContentsOfFile:imagePath];
		UIImage *buttonImage = [[UIImage alloc] initWithData:imageData];
		NSLog(@"button image size: %f, %f", buttonImage.size.width, buttonImage.size.height);
		UIImage *resizedButtonImage = [buttonImage resizedImage:CGSizeMake(93, 93) interpolationQuality:kCGInterpolationMedium];
		
		[imageButton setImage:resizedButtonImage forState:UIControlStateNormal];
		[imageButton addTarget:self action:@selector(imageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[imageButton setTag:i-1];
		[imageButton setTitle:[self.fileNamesArray objectAtIndex:i-1] forState:UIControlStateReserved];
		[self.scrollView addSubview:imageButton];
		if (i%numOfColumns == 0) {
			y += space+height;
			x = space;
		} else {
			x+=space+width;
		}
		
		[imageButton release];
		[imageData release];
		[buttonImage release];
	}
	
	//release extra image data
	self.imagesArray = nil;
	int contentWidth = numOfColumns*(space+width)+space;
	int contentHeight = numOfRows*(space+height)+space;
	[self.scrollView setContentSize:CGSizeMake(contentWidth, contentHeight)];
	
	[self performSelectorOnMainThread:@selector(scrollViewFinished) withObject:nil waitUntilDone:FALSE];
	[pool drain];
}

-(void)scrollViewFinished
{
	[DSBezelActivityView removeViewAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
	//if scrollview was already created...
	//reload UI elements since deletion may have occurred
	
	if([self.fileNamesArray  count] != 0)
	{
		NSLog(@"laying out scrollview via viewWillAppear");	
		[self loadImagesFromDocumentsDirectory];
		[self layoutScrollview];
	}
	
//	//this will be triggered when a user deletes a photo
//	[self loadImagesFromDocumentsDirectory];
//	
//	for(id eachView in [self.scrollView.subviews copy])
//	{
//		[eachView removeFromSuperview];
//	}
//	
//	int numOfColumns = 3;
//	int numOfRows = self.imagesArray.count/numOfColumns+1;
//	int space = 10;
//	int width = (self.scrollView.frame.size.width-(numOfColumns+1)*space)/numOfColumns;
//	int height = width;
//	int x = space;
//	int y = space;
//	for (int i=1; i<=self.imagesArray.count; i++) {
//		UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(x,y,width,height)];
////		[imageButton setImage:[self.imagesArray objectAtIndex:i-1] forState:UIControlStateNormal];
//		NSString *imagePath = [[NSBundle mainBundle] pathForResource:[self.fileNamesArray objectAtIndex:i-1] ofType:@"jpg"];
//		NSLog(imagePath);
//		NSData *imageData = [[NSData alloc] initWithContentsOfFile:imagePath];
//		UIImage *buttonImage = [[UIImage alloc] initWithData:imageData];
//
////		UIImage *resizedButtonImage = [buttonImage resizedImage:CGSizeMake(93, 93) interpolationQuality:kCGInterpolationHigh];
//		
//		[imageData release];
//		[buttonImage release];
//		[imageButton setImage:buttonImage forState:UIControlStateNormal];
////		[resizedButtonImage release];
//		[imageButton addTarget:self action:@selector(imageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//		[imageButton setTag:i-1];
//		[imageButton setTitle:[self.fileNamesArray objectAtIndex:i-1] forState:UIControlStateReserved];
//		[self.scrollView addSubview:imageButton];
//		[imageButton release];
//		if (i%numOfColumns == 0) {
//			y += space+height;
//			x = space;
//		} else {
//			x+=space+width;
//		}
//	}
//	int contentWidth = numOfColumns*(space+width)+space;
//	int contentHeight = numOfRows*(space+height)+space;
//	[self.scrollView setContentSize:CGSizeMake(contentWidth, contentHeight)];
}	
	

-(void)imageButtonPressed:(UIButton *)sender
{
	PhotoViewSharingViewController *photoViewSharingViewController = [[PhotoViewSharingViewController alloc] initWithStyle:UITableViewStyleGrouped];
//	photoViewSharingViewController.image = sender.imageView.image;
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
//		NSLog(@"Found file %@", fileName);
		if([fileName hasSuffix:@"jpg"])
		{
			NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
			NSLog(filePath);
			[_imagesArray addObject:[UIImage imageWithContentsOfFile:filePath]];
			[_fileNamesArray addObject:filePath];
		}
	}
	self.imagesArray = _imagesArray;
	self.fileNamesArray = _fileNamesArray;
	[_imagesArray release];
	[_fileNamesArray release];
}	

//-(UIImage *)resizeImage:(UIImage *)image {
//	
//	CGImageRef imageRef = [image CGImage];
//	CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
//	CGColorSpaceRef colorSpaceInfo = CGColorSpaceCreateDeviceRGB();
//	
//	if (alphaInfo == kCGImageAlphaNone)
//		alphaInfo = kCGImageAlphaNoneSkipLast;
//	
//	int width, height;
//	
//	width = 93;
//	height = 93;
//	
//	CGContextRef bitmap;
//	
//	if (image.imageOrientation == UIImageOrientationUp | image.imageOrientation == UIImageOrientationDown) {
//		bitmap = CGBitmapContextCreate(NULL, width, height, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, alphaInfo);
//		
//	} else {
//		bitmap = CGBitmapContextCreate(NULL, height, width, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, alphaInfo);
//		
//	}
//	
//	if (image.imageOrientation == UIImageOrientationLeft) {
//		NSLog(@"image orientation left");
//		CGContextRotateCTM (bitmap, M_PI/360.0);
//		CGContextTranslateCTM (bitmap, 0, -height);
//		
//	} else if (image.imageOrientation == UIImageOrientationRight) {
//		NSLog(@"image orientation right");
//		CGContextRotateCTM (bitmap, -M_PI/360.0);
//		CGContextTranslateCTM (bitmap, -width, 0);
//		
//	} else if (image.imageOrientation == UIImageOrientationUp) {
//		NSLog(@"image orientation up");	
//		
//	} else if (image.imageOrientation == UIImageOrientationDown) {
//		NSLog(@"image orientation down");	
//		CGContextTranslateCTM (bitmap, width,height);
//		CGContextRotateCTM (bitmap, -M_PI/180.0);
//		
//	}
//	
//	CGContextDrawImage(bitmap, CGRectMake(0, 0, width, height), imageRef);
//	CGImageRef ref = CGBitmapContextCreateImage(bitmap);
//	UIImage *result = [UIImage imageWithCGImage:ref];
//	
//	CGContextRelease(bitmap);
//	CGImageRelease(ref);
//	
//	return result;	
//}

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
