//
//  PokemonTableViewController.m
//  TMOATreeSample
//
//  Created by Dan Lipert on 7/25/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import "PokemonTableViewController.h"
#import "PokemonDetailViewController.h"
#import "TMOANode.h"
#import "TMOATree.h"

@implementation PokemonTableViewController

@synthesize tree, currentNode;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	//load back button
	UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
	UIImage *cancelButtonImage = [UIImage imageNamed:@"BackButton.png"];
	[cancelButton setFrame:CGRectMake(0,0,cancelButtonImage.size.width, cancelButtonImage.size.height)];
	[cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[cancelButton setImage:cancelButtonImage forState:UIControlStateNormal];
	UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
	
	self.navigationItem.leftBarButtonItem = cancelButtonItem;
	[cancelButtonItem release];
	
	TMOANode *rootNode = [[TMOANode alloc] init];
	[rootNode.dictionary setObject:@"Pokemon" forKey:@"name"];
	
	TMOATree *_tree = [[TMOATree alloc] initWithRootNode:rootNode];
	
	TMOANode *childNode = [[TMOANode alloc] init];
	[childNode.dictionary setObject:@"Magnemite" forKey:@"name"];
	[childNode.dictionary setObject:[UIImage imageNamed:@"081MS.png"] forKey:@"image"];
	if([_tree addChild:childNode toNode:rootNode] == FALSE)
	{
		NSLog(@"ERROR ADDING CHILD TO ROOT NODE");
	}
	
	TMOANode *magnetonNode = [[TMOANode alloc] init];
	[magnetonNode.dictionary setObject:@"Magneton" forKey:@"name"];
	[magnetonNode.dictionary setObject:[UIImage imageNamed:@"082MS.png"] forKey:@"image"];
	[_tree addChild:magnetonNode toNode:childNode];
	
	TMOANode *magnezoneNode = [[TMOANode alloc] init];
	[magnezoneNode.dictionary setObject:@"Magnezone" forKey:@"name"];
	[magnezoneNode.dictionary setObject:[UIImage imageNamed:@"462MS.png"] forKey:@"image"];
	[_tree addChild:magnezoneNode toNode:magnetonNode];
	
	TMOANode *eeveeNode = [[TMOANode alloc] init];
	[eeveeNode.dictionary setObject:@"Eevee" forKey:@"name"];
	[eeveeNode.dictionary setObject:[UIImage imageNamed:@"133MS.png"] forKey:@"image"];
	[_tree addChild:eeveeNode toNode:rootNode];
	
	TMOANode *vaporeonNode = [[TMOANode alloc] init];
	[vaporeonNode.dictionary setObject:@"Vaporeon" forKey:@"name"];
	[vaporeonNode.dictionary setObject:[UIImage imageNamed:@"134MS.png"] forKey:@"image"];

	[_tree addChild:vaporeonNode toNode:eeveeNode];
	
	TMOANode *jolteonNode = [[TMOANode alloc] init];
	[jolteonNode.dictionary setObject:@"Jolteon" forKey:@"name"];
	[jolteonNode.dictionary setObject:[UIImage imageNamed:@"135MS.png"] forKey:@"image"];

	[_tree addChild:jolteonNode toNode:eeveeNode];
	
	TMOANode *flareonNode = [[TMOANode alloc] init];
	[flareonNode.dictionary setObject:@"Flareon" forKey:@"name"];
	[flareonNode.dictionary setObject:[UIImage imageNamed:@"136MS.png"] forKey:@"image"];

	[_tree addChild:flareonNode toNode:eeveeNode];
	
	TMOANode *espeonNode = [[TMOANode alloc] init];
	[espeonNode.dictionary setObject:@"Espeon" forKey:@"name"];
	[espeonNode.dictionary setObject:[UIImage imageNamed:@"196MS.png"] forKey:@"image"];
	[_tree addChild:espeonNode toNode:eeveeNode];
	
	self.tree = _tree;
	self.currentNode = rootNode;
}

-(void)cancelButtonPressed:(id)sender
{
	if(self.currentNode != self.tree.rootNode)
	{
		self.currentNode = self.currentNode.parent;
	}
	
	[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
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
    return [self.currentNode.children count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	[cell setText:[[[self.currentNode.children objectAtIndex:indexPath.row] dictionary] objectForKey:@"name"]];
	[cell setImage:[[[self.currentNode.children objectAtIndex:indexPath.row] dictionary] objectForKey:@"image"]];
    return cell;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if([[self.currentNode.children objectAtIndex:indexPath.row] isLeaf] == FALSE)
	{
		self.currentNode = [self.currentNode.children objectAtIndex:indexPath.row];
		NSLog(@"loading %i children", [self.currentNode.children count]);
		[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];		
	} else {
		PokemonDetailViewController *detailViewController = [[PokemonDetailViewController alloc] init];
		detailViewController.name = [[[self.currentNode.children objectAtIndex:indexPath.row] dictionary] objectForKey:@"name"];
		detailViewController.image = [[[self.currentNode.children objectAtIndex:indexPath.row] dictionary] objectForKey:@"image"];
		[self.navigationController pushViewController:detailViewController animated:YES];
		[detailViewController release];
	}
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

