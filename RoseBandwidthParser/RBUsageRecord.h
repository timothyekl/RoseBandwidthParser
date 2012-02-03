//
//  RBUsageRecord.h
//  RoseBandwidthParser
//
//  Created by Tim Ekl on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Abstract. Don't instantiate.
 */
@interface RBUsageRecord : NSObject

@property (nonatomic, assign) float policyUp;
@property (nonatomic, assign) float policyDown;
@property (nonatomic, assign) float actualUp;
@property (nonatomic, assign) float actualDown;

@end
