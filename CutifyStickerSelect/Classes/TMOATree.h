//
//  TMOATree.h
//  TMOATreeSample
//
//  Created by Dan Lipert on 7/25/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMOANode.h"

@interface TMOATree : NSObject {

}

-(id)initWithRootNode:(TMOANode *)rootNode;

//container methods
//-(NSNumber)size;
//-(BOOL)isEmpty;
//-(NSArray *)elements;
-(int)count;

//accessors
-(TMOANode *)parentOfNode:(TMOANode *)node;
-(NSArray *)childrenOfNode:(TMOANode *)node;

//setters
-(BOOL)addChild:(TMOANode *)childNode toNode:(TMOANode *)parentNode;
-(BOOL)removeChild:(TMOANode *)childNode fromNode:(TMOANode *)parentNode;

//querying nodes
-(BOOL)isInternal;
-(BOOL)isRoot;
-(BOOL)isExternal;

@property (nonatomic, retain) TMOANode* rootNode;
@property (nonatomic, retain) NSMutableArray *nodes;

@end
