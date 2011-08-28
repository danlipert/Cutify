    //
//  PokemonDetailViewController.m
//  TMOATreeSample
//
//  Created by Dan Lipert on 7/26/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import "PokemonDetailViewController.h"


@implementation PokemonDetailViewController

@synthesize name, image;

- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	self.title = self.name;
	UIImageView *pokemonImageView = [[UIImageView alloc] initWithImage:self.image];
	[pokemonImageView setFrame:CGRectMake(320/2.0-100,100,200,200)];
	[self.view addSubview:pokemonImageView];
	[pokemonImageView release];
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
