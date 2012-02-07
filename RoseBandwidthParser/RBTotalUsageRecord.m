//
//  RBTotalUsageRecord.m
//  RoseBandwidthParser
//
//  Created by Tim Ekl on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RBTotalUsageRecord.h"

#import "RBUsagePolicy.h"

@implementation RBTotalUsageRecord

@synthesize machineRecords = _machineRecords;

- (id)initWithPolicy:(RBUsagePolicy *)policy {
    if((self = [super initWithPolicy:policy])) {
        _machineRecords = [NSMutableArray array];
    }
    return self;
}

- (NSString *)bandwidthClass {
    return [self.policy bandwidthClassForUsage:self];
}

@end
