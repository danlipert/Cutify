//
//  OptionsAndSharingViewController.m
//  CutifyAppFrame
//
//  Created by Dan Lipert on 7/11/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import "OptionsAndSharingViewController.h"
#import "PhotoGridViewController.h"
#import <AVFoundation/AVFoundation.h>
@implementation OptionsAndSharingViewController

@synthesize image;

-(id)initWithStyle:(UITableViewStyle)style
{
	if(self = [super initWithStyle:style])
	{
	}
	return self;
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	//setup buttons
	UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
	UIImage *cancelButtonImage = [UIImage imageNamed:@"BackButton.png"];
	[cancelButton setFrame:CGRectMake(0,0,cancelButtonImage.size.width, cancelButtonImage.size.height)];
	[cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[cancelButton setImage:cancelButtonImage forState:UIControlStateNormal];
	UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];

	self.navigationItem.leftBarButtonItem = cancelButtonItem;
	[cancelButtonItem release];
	
	UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
	UIImage *doneButtonImage = [UIImage imageNamed:@"DoneButton.png"];
	[doneButton setFrame:CGRectMake(0,0,doneButtonImage.size.width, doneButtonImage.size.height)];
	[doneButton addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[doneButton setImage:doneButtonImage forState:UIControlStateNormal];
	UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
	
	self.navigationItem.rightBarButtonItem = doneButtonItem;
	[doneButtonItem release];
	
//	//setup background
	[self.tableView setBackgroundColor:[UIColor clearColor]];
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"TableviewBackground.png"]]];	
}

-(void)cancelButtonPressed:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)doneButtonPressed:(id)sender
{
	//save file
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSDate *now = [NSDate date];
	NSString *fileName = [NSString stringWithFormat:@"Cutify %@.jpg", now];
	NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:fileName];
	NSData *imageData = UIImageJPEGRepresentation(self.image, 10);
	[imageData writeToFile:imagePath atomically:YES];
	
	//save file in iphoto
	UIImageWriteToSavedPhotosAlbum(self.image, nil,nil,nil);

	PhotoGridViewController *photoGridViewController = [[PhotoGridViewController alloc] init];
	[self.navigationController pushViewController:photoGridViewController animated:YES];
	[photoGridViewController release];
}

#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(section == 0)
	{
		return 1;
	} else if(section == 1) {
		return 3;
	} else if(section == 2) {
		return 1;
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,320,44)] autorelease];
	[tableHeaderView setBackgroundColor:[UIColor clearColor]];
	
	UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10,0,320,44)] autorelease];
	[headerLabel setBackgroundColor:[UIColor clearColor]];
	[headerLabel setTextColor:[UIColor colorWithRed:184.0/255.0 green:246.0/255.0 blue:229.0/255.0 alpha:1.0]];
	[headerLabel setShadowColor:[UIColor colorWithRed:96.0/255.0 green:72.0/255.0 blue:113/255.0 alpha:1.0]];
	[headerLabel setShadowOffset:CGSizeMake(1,1)];
	[headerLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0]];
	if(section == 0)
	{
		[headerLabel setText:@"Caption"];
	} else if(section == 1) {
		[headerLabel setText:@"Sharing"];
	} else if(section == 2) {
		[headerLabel setText:@"Email"];
	}
	
	[tableHeaderView addSubview:headerLabel];
	
	return tableHeaderView;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...

	if(indexPath.section == 0)
	{
		[[cell textLabel] setText:@"Enter your caption here..."];
		[[cell textLabel] setTextColor:[UIColor colorWithRed:137.0/255.0 green:137.0/255.0 blue:137.0/255.0 alpha:1.0]];
	} else if (indexPath.section == 1) {
		UISwitch *sharingSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(200,8,100,44)];
		[cell addSubview:sharingSwitch];
		[sharingSwitch release];
		if(indexPath.row == 0) {
			[[cell textLabel] setText:@"Twitter"];
		} else if(indexPath.row == 1) {
			[[cell textLabel] setText:@"Facebook"];
		} else if(indexPath.row == 2) {
			[[cell textLabel] setText:@"Tumblr"];
		}
	} else if (indexPath.section == 2) {
		[[cell textLabel] setText:@"Send as Email"];
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	}
	
    return cell;
}




#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

