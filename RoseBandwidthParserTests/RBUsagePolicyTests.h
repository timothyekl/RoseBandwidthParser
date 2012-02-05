//
//  RBUsagePolicyTests.h
//  RoseBandwidthParser
//
//  Created by Tim Ekl on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//  Logic unit tests contain unit test code that is designed to be linked into an independent test executable.

#import <SenTestingKit/SenTestingKit.h>

@class RBTotalUsageRecord;

@interface RBUsagePolicyTests : SenTestCase

- (void)performChecksForRecord:(RBTotalUsageRecord *)record withClass:(NSString *)bandwidthClass minUsage:(float)min maxUsage:(float)max;

@end
