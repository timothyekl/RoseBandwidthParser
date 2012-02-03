//
//  RBMachineUsageRecordTests.m
//  RoseBandwidthParser
//
//  Created by Tim Ekl on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RBMachineUsageRecordTests.h"

#import "RBMachineUsageRecord.h"

@implementation RBMachineUsageRecordTests

// All code under test must be linked into the Unit Test bundle
- (void)testMath {
    STAssertTrue((1 + 1) == 2, @"Compiler isn't feeling well today :-(");
}

- (void)testMacAddressString {
    RBMachineUsageRecord * record = [[RBMachineUsageRecord alloc] init];
    
    NSDictionary * testCases = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"00:00:00:00:00:00", [NSNumber numberWithLongLong:0],
                                @"FF:00:FF:00:FF:00", [NSNumber numberWithLongLong:0x0000FF00FF00FF00],
                                @"01:23:45:67:89:AB", [NSNumber numberWithLongLong:0x00000123456789AB],
                                nil];
    
    for(NSNumber * key in testCases) {
        record.macAddress = key.longLongValue;
        STAssertTrue([record.macAddressString isEqualToString:[testCases objectForKey:key]], @"MAC address not converted properly.");
    }
}

@end
