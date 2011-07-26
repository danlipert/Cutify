//
//  PokemonTableViewController.h
//  TMOATreeSample
//
//  Created by Dan Lipert on 7/25/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMOANode.h"
#import "TMOATree.h"

@interface PokemonTableViewController : UITableViewController 
{

}

@property (nonatomic, retain) TMOATree *tree;
@property (nonatomic, retain) TMOANode *currentNode;

@end
