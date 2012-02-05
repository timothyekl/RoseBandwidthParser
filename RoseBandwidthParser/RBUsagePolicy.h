//
//  RBUsagePolicy.h
//  RoseBandwidthParser
//
//  Created by Tim Ekl on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RBTotalUsageRecord;

@interface RBUsagePolicy : NSObject

/**
 * Takes a dictionary mapping NSNumbers (lower boundaries in GB) to NSStrings
 * (bandwidth class names). Must include a value for kDefaultBandwidthPolicyKey.
 */
- (id)initWithBandwidthBoundaries:(NSDictionary *)boundaries;
+ (NSNumber *)defaultBandwidthPolicyKey;
+ (RBUsagePolicy *)currentPolicy;
- (NSString *)defaultBandwidthClass;
- (NSString *)bandwidthClassForUsage:(RBTotalUsageRecord *)totalUsage;

@end
