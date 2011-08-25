    //
//  DemoViewController.m
//  ImageRotateMerge
//
//  Created by Dan Lipert on 8/20/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import "DemoViewController.h"


@implementation DemoViewController


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIImage *backgroundImage = [UIImage imageNamed:@"background.jpg"];
	UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
	[backgroundImageView setFrame:CGRectMake(0,0,backgroundImage.size.width, backgroundImage.size.height)];	
	
	UIImage *stickerImage= [UIImage imageNamed:@"sticker.png"];
	UIImageView *stickerImageView = [[UIImageView alloc] initWithImage:stickerImage];
	[stickerImageView setFrame:CGRectMake(25,50,50,50)];
//	[stickerImageView setCenter:backgroundImageView.center];
	
	
	CGFloat rotationDegrees = 0.0;
	CGFloat scale = 0.25;
	UIImage *mergedImage = [self createImageFromBackgroundImageView:backgroundImageView andOverlayImageView:stickerImageView withRotationDegrees:&rotationDegrees andScale:&scale];

	for(int i = 0; i< 18; i++)
	{
		rotationDegrees= rotationDegrees+20;
		[backgroundImageView setImage:mergedImage];
		mergedImage = [self createImageFromBackgroundImageView:backgroundImageView andOverlayImageView:stickerImageView withRotationDegrees:&rotationDegrees andScale:&scale];
	}
							
	UIImageView *imageView = [[UIImageView alloc] initWithImage:mergedImage];
	[imageView setFrame:CGRectMake(0,0,mergedImage.size.width, mergedImage.size.height)];
	[self.view addSubview:imageView];
	
	[imageView release];
}

-(UIImage *)createImageFromBackgroundImageView:(UIImageView *)backgroundImageView andOverlayImageView:(UIImageView *)overlayImageView withRotationDegrees:(CGFloat *)rotationDegrees andScale:(CGFloat *)scalePointer
{		
	CGFloat scale = *scalePointer;
	
	UIGraphicsBeginImageContext(backgroundImageView.image.size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	CGContextTranslateCTM(ctx, overlayImageView.frame.origin.x * 2.0 + overlayImageView.image.size.width / 2.0 * scale, overlayImageView.frame.origin.y * 2.0 + overlayImageView.image.size.height / 2.0 * scale); 

	CGFloat angle = *rotationDegrees * M_PI/180.0f;    
	CGContextRotateCTM(ctx, angle);  
	
	[overlayImageView.image drawInRect:CGRectMake(0 - overlayImageView.image.size.width * scale / 2.0, 0 - overlayImageView.image.size.height * scale / 2.0, overlayImageView.image.size.width * scale, overlayImageView.image.size.height * scale)];
		
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	UIGraphicsBeginImageContext(backgroundImageView.image.size);
	[backgroundImageView.image drawInRect:CGRectMake(0, 0, backgroundImageView.image.size.width, backgroundImageView.image.size.height)];    
	[newImage drawInRect:CGRectMake(0, 0, newImage.size.width, newImage.size.height)];

	UIImage *newImage2 = UIGraphicsGetImageFromCurrentImageContext();    
	UIGraphicsEndImageContext();    
	
	return newImage2;
}

- (UIImage *)mergeImage:(UIImage *)bottomImg withImage:(UIImage *)overlayImage atRect:(CGRect)rectToDraw withRotationDegrees:(float)rotationDegrees andScale:(float)scale
{
	
	UIGraphicsBeginImageContext(bottomImg.size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	//THIS WORKS! rotation still 'broken'
	CGContextTranslateCTM(ctx, rectToDraw.origin.x * 2.0 + overlayImage.size.width / 2.0 * scale, rectToDraw.origin.y * 2.0  + overlayImage.size.height / 2.0 * scale); 
	
//	CGFloat angle = rotationDegrees * M_PI/180.0f;    
//	CGContextRotateCTM(ctx, angle);  
	[overlayImage drawInRect:CGRectMake(0 -overlayImage.size.width * scale / 2.0, 0-overlayImage.size.height * scale / 2.0, overlayImage.size.width * scale, overlayImage.size.height * scale)];
//	[overlayImage drawInRect:rectToDraw];
	
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	UIGraphicsBeginImageContext(bottomImg.size);
	[bottomImg drawInRect:CGRectMake(0, 0, bottomImg.size.width, bottomImg.size.height)];    
	[newImage drawInRect:CGRectMake(0, 0, newImage.size.width, newImage.size.height)];
	UIImage *newImage2 = UIGraphicsGetImageFromCurrentImageContext();    
	UIGraphicsEndImageContext();    
	
	return newImage2;
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
