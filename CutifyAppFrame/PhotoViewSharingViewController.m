    //
//  PhotoViewSharingViewController.m
//  CutifyAppFrame
//
//  Created by Dan Lipert on 7/12/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import "PhotoViewSharingViewController.h"
#import "PhotoGridViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "DSActivityView.h"
#import <AVFoundation/AVFoundation.h>
@implementation PhotoViewSharingViewController

@synthesize image, fileName, txtField;
@synthesize twitterVC, facebookVC, tumblrVC;
@synthesize facebookSwitch, twitterSwitch, tumblrSwitch;
@synthesize blocker, timer;

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
	
	NSLog(@"file name is: %@", self.fileName);
	
	TwitterViewController *twVC = [[TwitterViewController alloc] init];
	twVC.delegate = self;
	self.twitterVC = twVC;
	[twVC release];
	
	FacebookViewController *fbVC = [[FacebookViewController alloc] init];
	fbVC.delegate = self;
	self.facebookVC = fbVC;
	[fbVC release];
	
	TumblrViewController *tmbVC = [[TumblrViewController alloc] init];
	tmbVC.delegate = self;
	self.tumblrVC = tmbVC;
	[tmbVC release];
	
	//setup buttons
	UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
	UIImage *cancelButtonImage = [UIImage imageNamed:@"BackButton.png"];
	[cancelButton setFrame:CGRectMake(0,0,cancelButtonImage.size.width, cancelButtonImage.size.height)];
	[cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[cancelButton setImage:cancelButtonImage forState:UIControlStateNormal];
	UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
	
	self.navigationItem.leftBarButtonItem = cancelButtonItem;
	[cancelButtonItem release];
	
	UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
	UIImage *deleteButtonImage = [UIImage imageNamed:@"DeleteButton.png"];
	[deleteButton setFrame:CGRectMake(0,0,deleteButtonImage.size.width, deleteButtonImage.size.height)];
	[deleteButton addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[deleteButton setImage:deleteButtonImage forState:UIControlStateNormal];
	UIBarButtonItem *deleteButtonItem = [[UIBarButtonItem alloc] initWithCustomView:deleteButton];
	
	self.navigationItem.rightBarButtonItem = deleteButtonItem;
	[deleteButtonItem release];
	
	//	//setup background
	[self.tableView setBackgroundColor:[UIColor clearColor]];
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"TableviewBackground.png"]]];	
	
	self.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:self.fileName]];
	
	UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,320)];
	UIImageView *photoImageView = [[UIImageView alloc] initWithImage:self.image];
	[photoImageView setFrame:CGRectMake(7,5,306,306)];
	[containerView addSubview:photoImageView];
	self.tableView.tableHeaderView = containerView;
	[photoImageView release];
	[containerView release];
	
}

-(void)cancelButtonPressed:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)deleteButtonPressed:(id)sender
{
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	NSString *documentsDirectory = [paths objectAtIndex:0];
//	NSFileManager *fileManager = [NSFileManager defaultManager];
//	NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:self.fileName];
//	NSLog(@"Trying to delete: %@", imagePath);

	//self.fileName contains image path
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager removeItemAtPath:self.fileName error:nil];
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if(section == 2)
	{
		return 37;
	} else {
		return 44;
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(section == 0)
	{
		return 1;
	} else if(section == 1) {
		return 3;
	} else if(section == 2) {
		return 0;
	} else if(section == 3) {
		return 1;
	} else {
		return 99;
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
	} else if(section == 3) {
		[headerLabel setText:@"Email"];
	}
	
	if(section == 2)
	{
		UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[shareButton setFrame:CGRectMake(0,0,320,37)];
		[shareButton addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[shareButton setImage:[UIImage imageNamed:@"SharePhotoButton.png"] forState:UIControlStateNormal];
		[tableHeaderView setFrame:shareButton.frame];
		[tableHeaderView addSubview:shareButton];
	} else {
		[tableHeaderView addSubview:headerLabel];
	}
		
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
		if(self.txtField == nil)
		{
			UITextField *txtField=[[UITextField alloc]initWithFrame:CGRectMake(20, 10, 320, 30)];
			//			txtField.autoresizingMask=UIViewAutoresizingFlexibleHeight;
			//			txtField.autoresizesSubviews=YES;
			[txtField setBorderStyle:UITextBorderStyleNone];
			[txtField setPlaceholder:@"Enter your caption here..."];
			[txtField setTextColor:[UIColor colorWithRed:137.0/255.0 green:137.0/255.0 blue:137.0/255.0 alpha:1.0]];
			[txtField setDelegate:self];
			self.txtField = txtField;
			[cell addSubview:txtField];
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			[txtField release];
			
			[[cell textLabel] setText:@""];
		} else {
			[cell addSubview:self.txtField];
			[[cell textLabel] setText:@""];
		}
	} else if (indexPath.section == 1) {
		if(indexPath.row == 0) 
		{
			[[cell textLabel] setText:@"Twitter"];
			
			if ([self.twitterVC isAuthorized]) {
				self.twitterSwitch = [self getSharingSwitchWithTag:0];
				[self.twitterSwitch addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
				[cell addSubview:self.twitterSwitch];
				cell.accessoryType = UITableViewCellAccessoryNone;
				[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
				if (shareOnTwitter_)
				{
					[self.twitterSwitch setOn:YES animated:NO];
				}
			}
			else {
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
		} 
		else if (indexPath.row == 1) 
		{
			[[cell textLabel] setText:@"Facebook"];
			
			if ([self.facebookVC isAuthorized])
			{
				self.facebookSwitch = [self getSharingSwitchWithTag:1];
				[self.facebookSwitch addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
				[cell addSubview:self.facebookSwitch];
				cell.accessoryType = UITableViewCellAccessoryNone;
				[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
				if (shareOnFacebook_)
				{
					[self.facebookSwitch setOn:YES animated:NO];
				}
			}
			else 
			{
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
		} 
		else if (indexPath.row == 2) 
		{
			[[cell textLabel] setText:@"Tumblr"];
			
			if ([self.tumblrVC isAuthorized])
			{
				self.tumblrSwitch = [self getSharingSwitchWithTag:2];
				[self.tumblrSwitch addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
				[cell addSubview:self.tumblrSwitch];
				cell.accessoryType = UITableViewCellAccessoryNone;
				[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
				if (shareOnTumblr_)
				{
					[self.tumblrSwitch setOn:YES animated:NO];
				}
			}
			else 
			{
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
		}
	} else if (indexPath.section == 3) {
		[[cell textLabel] setText:@"Send as Email"];
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	}
	
    return cell;
}

#pragma mark -
#pragma mark sharingSwitch

-(void)switchToggled:(id)sender
{
	if (sender == self.twitterSwitch) {
		shareOnTwitter_ = self.twitterSwitch.on;
	} else if(sender == self.facebookSwitch) {
		shareOnFacebook_ = self.facebookSwitch.on;
	} else if(sender == self.tumblrSwitch) {
		shareOnTumblr_ = self.tumblrSwitch.on;
	}
}

-(void)shareButtonPressed:(id)sender
{
	if(self.twitterSwitch.on == YES || self.tumblrSwitch.on == YES || self.facebookSwitch.on == YES)
	{
		[DSBezelActivityView newActivityViewForView:self.view];

		[self performSelectorInBackground:@selector(makeRequestToServer) withObject:nil];
	}
}

- (UISwitch *)getSharingSwitchWithTag:(int)tag
{
	UISwitch *sharingSwitch = [[[UISwitch alloc] initWithFrame:CGRectMake(200,8,100,44)] autorelease];
	[sharingSwitch setTag:tag];
	return sharingSwitch;
}

#pragma mark -
#pragma mark mail

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{
	[self dismissModalViewControllerAnimated:YES];
	[self becomeFirstResponder];
	
	//BUGFIX
	//seems like old code
	//    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
	
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Sent" message:@"Your image was sent successfully!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];
			[alert release];
			break;
		}
		case MFMailComposeResultFailed:
			break;
		default:
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}	



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if (indexPath.section == 1)
	{
		if (indexPath.row == 0 && self.twitterSwitch == nil)
		{
			[self.navigationController pushViewController:self.twitterVC animated:YES];
		}
		if (indexPath.row == 1 && self.facebookSwitch == nil)
		{
			[self.navigationController pushViewController:self.facebookVC animated:YES];
		}
		if (indexPath.row == 2 && self.tumblrSwitch == nil)
		{
			[self.navigationController pushViewController:self.tumblrVC animated:YES];
		}
		
	}
	
	else if(indexPath.section == 3)
	{	
		
		//email
		//BUG - needs normal title bar
		MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
		mailController.mailComposeDelegate = self;
		//fix navbar
		[mailController.navigationBar setTag:1];
		[mailController addAttachmentData:UIImageJPEGRepresentation(self.image, 1.0) mimeType:@"image/jpeg" fileName:[NSString stringWithString:@"Cutify.jpg"]];
		[mailController setSubject:[NSString stringWithString:@"Another Cutify Creation!"]];
		if(self.txtField)
		{
			[mailController setMessageBody:self.txtField.text isHTML:NO];
		}
		[self presentModalViewController:mailController animated:NO];
		[mailController release];
	}	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return NO;
}

#pragma mark -
#pragma mark asihttprequest delegate

-(void)makeRequestToServer
{
	serverRequestPool = [[NSAutoreleasePool alloc] init];
	if(self.twitterSwitch.on == YES || self.tumblrSwitch.on == YES || self.facebookSwitch.on == YES)
	{
		
		NSLog(@"Making request to server");
		NSURL *url = [NSURL URLWithString:@"http://cutifyapp.com/uploads/"];
		ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:url] autorelease];
		//	ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:url] autorelease];
		[request setDelegate:self];
		
		NSMutableData *imageData = [[NSMutableData alloc] init];
		[imageData setData:UIImageJPEGRepresentation(self.image, 1.0)];
		[request setPostBody:imageData];
		[imageData release];
		
		[request setPostValue:@"Why is this necessary?" forKey:@"dummy_key"];
		[request setPostValue:self.txtField.text forKey:@"photo_caption"];
		
		// Share if selectedyout
		if (self.facebookSwitch.on)
		{
			NSLog(@"Adding facebook");
			[request setPostValue:self.facebookVC.access_token forKey:@"facebook_access_token"];
		}
		if (self.tumblrSwitch.on)
		{
			NSLog(@"Adding tumblr");
			[request setPostValue:self.tumblrVC.oauth.oauth_token forKey:@"tumblr_oauth_token"];
			[request setPostValue:self.tumblrVC.oauth.oauth_token_secret forKey:@"tumblr_oauth_token_secret"];
		}
		if (self.twitterSwitch.on)
		{
			NSLog(@"Adding twitter");
			
			[request setPostValue:self.twitterVC.oauth.oauth_token forKey:@"twitter_oauth_token"];
			[request setPostValue:self.twitterVC.oauth.oauth_token_secret forKey:@"twitter_oauth_token_secret"];
		}	
		
		[request setDidFinishSelector:@selector(requestFinished:)];
		[request setDidFailSelector:@selector(requestFailed:)];
		
		[request startSynchronous];	
		//		[DSBezelActivityView newActivityViewForView:self.view];
	}
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
	[serverRequestPool release];
	
	[DSBezelActivityView removeViewAnimated:YES];
	
	NSLog(@"%@", [request responseString]);
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Success!"
						  message:@"Photo shared! That one's going to be popular."
						  delegate:self
						  cancelButtonTitle:@"OK"
						  otherButtonTitles:nil];
	[alert setTag:10];
	[alert show];
	[alert autorelease];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	
	
	NSLog(@"Failed with response: %@", [request responseString]);
	[self uploadFailed];
}

- (void)uploadFailed
{
	[serverRequestPool release];

	[DSBezelActivityView removeViewAnimated:YES];
	
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Oops!"
						  message:@"Photo sharing failed. But it failed cute-ly, so we're not worried. Please try again later."
						  delegate:self
						  cancelButtonTitle:@"OK"
						  otherButtonTitles:nil];
	
	[alert show];
	[alert autorelease];
}


#pragma mark -
#pragma mark OAuth delegate

-(void)authenticationSuccessForService:(NSString *)name
{
	[self.tableView reloadData];
	
	if ([name isEqualToString:@"facebook"])
		shareOnFacebook_ = YES;
	else if ([name isEqualToString:@"tumblr"])
		shareOnTumblr_ = YES;
	else if ([name isEqualToString:@"twitter"])
		shareOnTwitter_ = YES;
}

-(void)resetAuthViewControllerForService:(NSString *)name
{
	
	if ([name isEqualToString:@"facebook"])
	{
		self.facebookVC = nil;
		FacebookViewController *fbVC = [[FacebookViewController alloc] init];
		fbVC.delegate = self;
		self.facebookVC = fbVC;
		[fbVC release];
	}
	else if ([name isEqualToString:@"tumblr"])
	{
		self.tumblrVC = nil;
		
		TumblrViewController *tmbVC = [[TumblrViewController alloc] init];
		tmbVC.delegate = self;
		self.tumblrVC = tmbVC;
		[tmbVC release];
	}
	else if ([name isEqualToString:@"twitter"])
	{
		self.twitterVC = nil;
		TwitterViewController *twVC = [[TwitterViewController alloc] init];
		twVC.delegate = self;
		self.twitterVC = twVC;
		[twVC release];
	}
}

-(void)debugAlert
{
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"PRERELEASE SOFTWARE"
						  message:@"Function not implemented"
						  delegate:self
						  cancelButtonTitle:@"OK"
						  otherButtonTitles:nil];
	
	[alert show];
	[alert autorelease];
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
