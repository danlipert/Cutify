//
//  TMOATree.m
//  TMOATreeSample
//
//  Created by Dan Lipert on 7/25/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import "TMOATree.h"


@implementation TMOATree

@synthesize rootNode, nodes;

-(id)initWithRootNode:(TMOANode *)rootNode
{
	if(self = [super init])
	{
		self.rootNode = rootNode;
		self.nodes = [[[NSMutableArray alloc] init] autorelease];
		[self.nodes addObject:rootNode];
	}
	return self;
}

-(int)count
{
	return [nodes count];
}


-(BOOL)addChild:(TMOANode *)childNode toNode:(TMOANode *)parentNode
{
	if(self.rootNode == nil)
	{
		//empty tree
		return FALSE;
	} else if ([self.nodes containsObject:parentNode] == FALSE) {
		//parent node not found
		return FALSE;
	} else {
		[parentNode.children addObject:childNode];
		childNode.parent = parentNode;
		[self.nodes addObject:childNode];
		return TRUE;
	}
}
	
-(BOOL)removeChild:(TMOANode *)childNode fromNode:(TMOANode *)parentNode
{
	if(self.rootNode == nil)
	{
		//empty tree
		return FALSE;
	} else if ([self.nodes containsObject:parentNode] == FALSE) {
		//parent node not found
		return FALSE;
	} else if([parentNode.children containsObject:childNode] == FALSE) {
		//parent does not have childNode as child
		return FALSE;
	} else {
		[parentNode.children removeObject:childNode];
		[self.nodes removeObject:childNode];
		return TRUE;
	}	
}

-(TMOANode *)parentOfNode:(TMOANode *)node
{
	if ([self.nodes containsObject:node] == FALSE) {
		//parent node not found
		return nil;
	} else if(node == self.rootNode) {
		//root node has no parents
		return nil;
	} else {
		return node.parent;
	}
}

-(NSArray *)childrenOfNode:(TMOANode *)node
{
	if ([self.nodes containsObject:node] == FALSE) {
		//parent node not found
		return nil;
	} else {
		return node.children;
	}
}

@end
