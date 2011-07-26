//
//  PokemonTableViewController.m
//  TMOATreeSample
//
//  Created by Dan Lipert on 7/25/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import "PokemonTableViewController.h"
#import "TMOANode.h"
#import "TMOATree.h"

@implementation PokemonTableViewController

@synthesize tree;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	TMOANode *rootNode = [[TMOANode alloc] init];
	[rootNode.dictionary setObject:@"Pokemon" forKey:@"name"];
	
	TMOATree *tree = [[TMOATree alloc] initWithRootNode:rootNode];
	
	TMOANode *childNode = [[TMOANode alloc] init];
	[childNode.dictionary setObject:@"Magnemite" forKey:@"name"];
	if([tree addChild:childNode toNode:rootNode] == FALSE)
	{
		NSLog(@"ERROR ADDING CHILD TO ROOT NODE");
	}
	
	TMOANode *magnetonNode = [[TMOANode alloc] init];
	[magnetonNode.dictionary setObject:@"Magneton" forKey:@"name"];
	[tree addChild:magnetonNode toNode:childNode];
	
	TMOANode *magnezoneNode = [[TMOANode alloc] init];
	[magnezoneNode.dictionary setObject:@"Magnezone" forKey:@"name"];
	[tree addChild:magnezoneNode toNode:magnetonNode];
	
	TMOANode *eeveeNode = [[TMOANode alloc] init];
	[eeveeNode.dictionary setObject:@"Eevee" forKey:@"name"];
	[tree addChild:eeveeNode toNode:rootNode];
	
	TMOANode *vaporeonNode = [[TMOANode alloc] init];
	[vaporeonNode.dictionary setObject:@"Vaporeon" forKey:@"name"];
	[tree addChild:vaporeonNode toNode:eeveeNode];
	
	TMOANode *jolteonNode = [[TMOANode alloc] init];
	[jolteonNode.dictionary setObject:@"Jolteon" forKey:@"name"];
	[tree addChild:jolteonNode toNode:eeveeNode];
	
	TMOANode *flareonNode = [[TMOANode alloc] init];
	[flareonNode.dictionary setObject:@"Flareon" forKey:@"name"];
	[tree addChild:flareonNode toNode:eeveeNode];
	
	TMOANode *espeonNode = [[TMOANode alloc] init];
	[espeonNode.dictionary setObject:@"Espeon" forKey:@"name"];
	[tree addChild:espeonNode toNode:eeveeNode];
	
	self.tree = tree;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.tree count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
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

