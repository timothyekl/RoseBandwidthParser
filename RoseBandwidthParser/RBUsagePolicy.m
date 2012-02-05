//
//  RBUsagePolicy.m
//  RoseBandwidthParser
//
//  Created by Tim Ekl on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RBUsagePolicy.h"

#import "RBUsagePolicy2012.h"
#import "RBTotalUsageRecord.h"

@interface RBUsagePolicy()

@property (nonatomic, strong) NSDictionary * boundaries;

@end

@implementation RBUsagePolicy

@synthesize boundaries = _boundaries;

- (id)initWithBandwidthBoundaries:(NSDictionary *)boundaries {
    if((self = [super init])) {
        self.boundaries = boundaries;
    }
    return self;
}

- (NSString *)bandwidthClassForUsage:(RBTotalUsageRecord *)totalUsage {
    float relevantUsage = MAX(totalUsage.policyUp, totalUsage.policyDown);
    NSNumber * closestBoundary = [NSNumber numberWithFloat:-1.0];
    NSString * relevantPolicy = [self defaultBandwidthClass];
    for(NSNumber * lowerBoundary in self.boundaries) {
        if([lowerBoundary isGreaterThan:closestBoundary] && lowerBoundary.floatValue <= relevantUsage) {
            closestBoundary = lowerBoundary;
            relevantPolicy = [self.boundaries objectForKey:lowerBoundary];
        }
    }
    return relevantPolicy;
}

- (NSString *)defaultBandwidthClass {
    return [self.boundaries objectForKey:[RBUsagePolicy defaultBandwidthPolicyKey]];
}

+ (NSNumber *)defaultBandwidthPolicyKey {
    return [NSNumber numberWithFloat:0.0];
}

+ (RBUsagePolicy *)currentPolicy {
    return [[RBUsagePolicy2012 alloc] init];
}

@end
