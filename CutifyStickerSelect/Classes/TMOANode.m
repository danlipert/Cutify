//
//  TMOANode.m
//  TMOATreeSample
//
//  Created by Dan Lipert on 7/25/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import "TMOANode.h"


@implementation TMOANode

@synthesize parent, children, dictionary;

-(id)init
{
	if(self = [super init])
	{
		parent = nil;
		self.children = [[[NSMutableArray alloc] init] autorelease];
		self.dictionary = [[[NSMutableDictionary alloc] init] autorelease];
	}
	return self;
}

-(BOOL)isLeaf
{
	if([self.children count] == 0)
	{
		return TRUE;
	} else {
		return FALSE;
	}
}

@end
