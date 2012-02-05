//
//  RBTotalUsageRecordTests.m
//  RoseBandwidthParser
//
//  Created by Tim Ekl on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RBTotalUsageRecordTests.h"
#import "RBTotalUsageRecord.h"
#import "RBUsagePolicy2012.h"

@implementation RBTotalUsageRecordTests

- (void)testInit {
    RBUsagePolicy * policy = [[RBUsagePolicy2012 alloc] init];
    RBTotalUsageRecord * record = [[RBTotalUsageRecord alloc] initWithPolicy:policy];
    
    STAssertNotNil(record.machineRecords, @"Total usage record had nil machine records array");
    STAssertEquals(record.machineRecords.count, (NSUInteger)0, @"Empty total usage record had machine usage record");
}

- (void)testGettersSetters {
    RBUsagePolicy * policy = [[RBUsagePolicy2012 alloc] init];
    RBTotalUsageRecord * record = [[RBTotalUsageRecord alloc] initWithPolicy:policy];
    
    for(float x = 0.0f; x < 5.0f; x += 0.1f) {
        record.policyDown = record.policyUp = record.actualDown = record.actualUp = x;
        STAssertEquals(record.policyDown, x, @"Policy down not saved accurately");
        STAssertEquals(record.policyUp, x, @"Policy up not saved accurately");
        STAssertEquals(record.actualDown, x, @"Actual down not saved accurately");
        STAssertEquals(record.actualUp, x, @"Actual up not saved accurately");
    }
    
}

@end
