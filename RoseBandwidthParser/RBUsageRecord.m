//
//  RBUsageRecord.m
//  RoseBandwidthParser
//
//  Created by Tim Ekl on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RBUsageRecord.h"
#import "RBUsagePolicy.h"

@implementation RBUsageRecord

@synthesize policyUp = _policyUp;
@synthesize policyDown = _policyDown;
@synthesize actualUp = _actualUp;
@synthesize actualDown = _actualDown;
@synthesize policy = _policy;

- (id)initWithPolicy:(RBUsagePolicy *)policy {
    if((self = [super init])) {
        _policy = policy;
    }
    return self;
}

@end
