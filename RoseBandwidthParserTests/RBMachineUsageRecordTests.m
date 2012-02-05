//
//  RBMachineUsageRecordTests.m
//  RoseBandwidthParser
//
//  Created by Tim Ekl on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RBMachineUsageRecordTests.h"

#import "RBMachineUsageRecord.h"
#import "RBUsagePolicy2012.h"

@implementation RBMachineUsageRecordTests

- (NSDictionary *)macAddressCases {
    NSDictionary * testCases = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"00:00:00:00:00:00", [NSNumber numberWithLongLong:0],
                                @"FF:00:FF:00:FF:00", [NSNumber numberWithLongLong:0x0000FF00FF00FF00],
                                @"01:23:45:67:89:AB", [NSNumber numberWithLongLong:0x00000123456789AB],
                                nil];
    return testCases;
}

// All code under test must be linked into the Unit Test bundle
- (void)testMath {
    STAssertTrue((1 + 1) == 2, @"Compiler isn't feeling well today :-(");
}

- (void)testInit {
    RBUsagePolicy * policy = [[RBUsagePolicy2012 alloc] init];
    RBMachineUsageRecord * record = [[RBMachineUsageRecord alloc] initWithPolicy:policy hostName:@"host" comment:@"comment"];
    
    STAssertTrue([record.hostName isEqualToString:@"host"], @"Machine usage record did not store host name properly.");
    STAssertTrue([record.comment isEqualToString:@"comment"], @"Machine usage record did not store comment properly.");
}

- (void)testMacAddressString {
    RBMachineUsageRecord * record = [[RBMachineUsageRecord alloc] init];
    
    for(NSNumber * key in self.macAddressCases) {
        record.macAddress = key.longLongValue;
        STAssertTrue([record.macAddressString isEqualToString:[self.macAddressCases objectForKey:key]], @"MAC address not converted properly.");
    }
}

- (void)testSetMacAddressFromString {
    RBMachineUsageRecord * record = [[RBMachineUsageRecord alloc] init];
    
    for(NSNumber * key in self.macAddressCases) {
        [record setMacAddressFromString:[self.macAddressCases objectForKey:key]];
        STAssertEquals(record.macAddress, (uint64_t)key.longLongValue, @"MAC address not converted properly.");
    }
    
    uint64_t macAddress = record.macAddress;
    [record setMacAddressFromString:@"abcd"];
    STAssertEquals(macAddress, record.macAddress, @"MAC address set from illegally formatted string");
}

@end
