//
//  OptionsAndSharingViewController.m
//  CutifyAppFrame
//
//  Created by Dan Lipert on 7/11/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import "OptionsAndSharingViewController.h"
#import "PhotoGridViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "DSActivityView.h"
#import <AVFoundation/AVFoundation.h>


@implementation OptionsAndSharingViewController

@synthesize image, txtField;
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
	
	//setup preview
	//preview
	UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,320)];
	UIImageView *photoImageView = [[UIImageView alloc] initWithImage:self.image];
	[photoImageView setFrame:CGRectMake(7,5,306,306)];
	[containerView addSubview:photoImageView];
	self.tableView.tableHeaderView = containerView;
	[photoImageView release];
	[containerView release];
	
	NSLog(@"Image loaded (%f x %f)", self.image.size.width, self.image.size.height);
}

-(void)cancelButtonPressed:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)doneButtonPressed:(id)sender
{
	NSLog(@"Saving image...");
	//save file
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSDate *now = [NSDate date];
	NSString *fileName = [NSString stringWithFormat:@"Cutify%@.jpg", now];
	NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:fileName];
	NSData *imageData = UIImageJPEGRepresentation(self.image, 1.0);
	[imageData writeToFile:imagePath atomically:YES];
	
	//save file in iphoto
	UIImageWriteToSavedPhotosAlbum(self.image, nil,nil,nil);

	
	[self makeRequestToServer];

	
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
	return 0;
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

- (UISwitch *)getSharingSwitchWithTag:(int)tag
{
	UISwitch *sharingSwitch = [[[UISwitch alloc] initWithFrame:CGRectMake(200,8,100,44)] autorelease];
	[sharingSwitch setTag:tag];
	return sharingSwitch;
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
			if(self.txtField == nil)
			{
				UITextField *txtField_ =[[UITextField alloc]initWithFrame:CGRectMake(20, 10, 320, 30)];
				[txtField_ setBorderStyle:UITextBorderStyleNone];
				[txtField_ setPlaceholder:@"Enter your caption here..."];
				[txtField_ setTextColor:[UIColor colorWithRed:137.0/255.0 green:137.0/255.0 blue:137.0/255.0 alpha:1.0]];
				[txtField_ setDelegate:self];
				self.txtField = txtField_;
				[txtField_ release];
				
				[cell addSubview:self.txtField];
				[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
				
			} else {
				[cell addSubview:self.txtField];
			}
		}
	} 
	else if (indexPath.section == 1) 
	{
		
		if(indexPath.row == 0) 
		{
			[[cell textLabel] setText:@"Twitter"];
			
			if ([self.twitterVC isAuthorized]) {
				self.twitterSwitch = [self getSharingSwitchWithTag:0];
				[cell addSubview:self.twitterSwitch];
				cell.accessoryType = UITableViewCellAccessoryNone;
				if (shareOnTwitter_)
					[self.twitterSwitch setOn:YES animated:NO];
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
				[cell addSubview:self.facebookSwitch];
				cell.accessoryType = UITableViewCellAccessoryNone;
				if (shareOnFacebook_)
					[self.facebookSwitch setOn:YES animated:NO];
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
				[cell addSubview:self.tumblrSwitch];
				cell.accessoryType = UITableViewCellAccessoryNone;
				if (shareOnTumblr_)
					[self.tumblrSwitch setOn:YES animated:NO];
			}
			else 
			{
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
		}

	} else if (indexPath.section == 2) {
		[[cell textLabel] setText:@"Send as Email"];
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	}
	
    return cell;
}

//dismisses keyboard when user hits enter while writing caption
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return NO;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
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
	else if(indexPath.section == 2)
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
#pragma mark asihttprequest delegate

-(void)makeRequestToServer
{
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
		
		// Share if selected
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
		[DSBezelActivityView newActivityViewForView:self.view];
	}
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
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

