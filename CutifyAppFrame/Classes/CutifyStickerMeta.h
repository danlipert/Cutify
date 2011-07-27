//
//  CutifyStickerMeta.h
//  CutifyStickerSelect
//
//  Created by Dan Lipert on 7/18/11.
//  Copyright 2011 independent developer. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CutifyStickerMeta : NSObject {

}

@property (nonatomic, retain) UIImage *stickerImage;
@property (nonatomic, retain) NSString *stickerLabelString;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) id parent;
@property (nonatomic, retain) id child;



@end
