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

#import <AVFoundation/AVFoundation.h>


#import "FacebookAuthViewController.h"
#import "TwitterAuthViewController.h"

@implementation OptionsAndSharingViewController

@synthesize image, fbToken, txtField;

@synthesize facebookSwitch;
@synthesize twitterSwitch;
@synthesize tumblrSwitch;

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
		} else {
			[cell addSubview:self.txtField];
		}
	} else if (indexPath.section == 1) {
		
		//[sharingSwitch addTarget:self action:@selector(sharingSwitchSwitched:) forControlEvents:UIControlEventValueChanged];
		
		if(indexPath.row == 0) 
		{
			[[cell textLabel] setText:@"Twitter"];

			if([self tokenCachedForService:@"twitter"])
			{
				self.twitterSwitch = [self getSharingSwitchWithTag:0];
				[cell addSubview:self.twitterSwitch];
				//cell.accessoryType = nil;
			}
			else 
			{
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
		} 
		else if (indexPath.row == 1) 
		{
			[[cell textLabel] setText:@"Facebook"];
			
			if([self tokenCachedForService:@"facebook"])
			{
				self.facebookSwitch = [self getSharingSwitchWithTag:1];
				[cell addSubview:self.facebookSwitch];
				//cell.accessoryType = nil;
			}
			else 
			{
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
		} 
		else if (indexPath.row == 2) 
		{
			[[cell textLabel] setText:@"Tumblr"];
			
			if([self tokenCachedForService:@"tumblr"])
			{
				self.tumblrSwitch = [self getSharingSwitchWithTag:2];
				[cell addSubview:self.tumblrSwitch];
				//cell.accessoryType = nil;
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

-(void)sharingSwitchSwitched:(id)sender
{
	UISwitch *sharingSwitch = (UISwitch *)sender;
	
	if(sharingSwitch.tag == 0)
	{
		//twitter
	} else if(sharingSwitch.tag == 1) {
		//facebook
		
	} else if(sharingSwitch.tag == 2) {
		//tumblr
	}
}

- (void)authenticationDidFinishWithToken:(NSString *)token forService:(NSString *)service
{
	[self cacheToken:token forService:service];
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section == 1)
	{
		if (indexPath.row == 0)
		{
			TwitterAuthViewController *authVC = [[TwitterAuthViewController alloc] init];
			authVC.delegate = self;
			[self.navigationController pushViewController:authVC animated:YES];
			[authVC release];
		}
		if (indexPath.row == 1)
		{
			FacebookAuthViewController *authVC = [[FacebookAuthViewController alloc] init];
			authVC.delegate = self;
			[self.navigationController pushViewController:authVC animated:YES];
			[authVC release];
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
	NSURL *url = [NSURL URLWithString:@"http://cutify.tmoa.webfactional.com/uploads/"];
	ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:url] autorelease];
//	ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:url] autorelease];
	[request setDelegate:self];
		
	[request setPostValue:@"This caption is here" forKey:@"caption"];
	NSMutableData *imageData = [[NSMutableData alloc] init];
	[imageData setData:UIImageJPEGRepresentation(self.image, 1.0)];
	[request setPostBody:imageData];
	[imageData release];

	// Share if selected
	if (self.facebookSwitch.on == YES)
	{
		[request setPostValue:[self cachedTokenForService:@"facebook"] forKey:@"facebook_token"];
	}
	if (self.tumblrSwitch.on == YES)
	{
		[request setPostValue:[self cachedTokenForService:@"tumblr"] forKey:@"tumblr_token"];
	}
	if (self.twitterSwitch.on == YES)
	{
		[request setPostValue:[self cachedTokenForService:@"twitter"] forKey:@"twitter_token"];
	}	
	
	[request setDidFinishSelector:@selector(requestFinished:)];
	[request setDidFailSelector:@selector(requestFailed:)];
	
	[request startSynchronous];	
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	NSLog([request responseString]);
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Sent to server!"
						  message:@"Great job!."
						  delegate:self
						  cancelButtonTitle:@"OK"
						  otherButtonTitles:nil];
	[alert setTag:10];
	[alert show];
	[alert autorelease];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
//	NSLog([request error]);
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"Upload failed!"
						  message:@"you have no dignity"
						  delegate:self
						  cancelButtonTitle:@"OK"
						  otherButtonTitles:nil];
	
	[alert show];
	[alert autorelease];
}


#pragma mark -
#pragma mark Token Management

- (void)cacheToken:(NSString *)aToken forService:(NSString *)serviceName 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:aToken forKey:[NSString stringWithFormat:@"%@_token", serviceName]];	
    [defaults synchronize];
    NSLog(@"Token: %@ saved for service: %@", aToken, serviceName);
}

- (NSString *)cachedTokenForService:(NSString *)serviceName 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:[NSString stringWithFormat:@"%@_token",serviceName]];
}

- (BOOL)tokenCachedForService:(NSString *)serviceName
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if ([defaults objectForKey:[NSString stringWithFormat:@"%@_token",serviceName]])
	{
		return YES; 
	}
	return NO;
	
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

