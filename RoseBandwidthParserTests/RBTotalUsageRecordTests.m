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

@end
