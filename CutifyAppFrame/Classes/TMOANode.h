//
//  TMOANode.h
//  TMOATreeSample
//
//  Created by Dan Lipert on 7/25/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TMOANode : NSObject 
{

}

@property (nonatomic, retain) TMOANode *parent;
@property (nonatomic, retain) NSMutableArray *children;
@property (nonatomic, retain) NSMutableDictionary *dictionary;

-(BOOL)isLeaf;
-(BOOL)isRoot;

@end
