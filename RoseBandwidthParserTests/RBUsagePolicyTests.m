//
//  RBUsagePolicyTests.m
//  RoseBandwidthParser
//
//  Created by Tim Ekl on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RBUsagePolicyTests.h"
#import "RBUsagePolicy.h"
#import "RBUsagePolicy2012.h"
#import "RBTotalUsageRecord.h"

@implementation RBUsagePolicyTests

- (void)testInit {
    NSDictionary * boundaries = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"value0", [RBUsagePolicy defaultBandwidthPolicyKey],
                                 @"value1", [NSNumber numberWithFloat:1.0],
                                 @"value2", [NSNumber numberWithFloat:2.0],
                                 @"value3", [NSNumber numberWithFloat:3.0],
                                 @"value4", [NSNumber numberWithFloat:4.0],
                                 nil];
    RBUsagePolicy * policy = [[RBUsagePolicy alloc] initWithBandwidthBoundaries:boundaries];
    
    STAssertTrue([policy.defaultBandwidthClass isEqualToString:@"value0"], @"Incorrect default bandwidth class.");
    
    for(int gb = 0; gb < 5; gb++) {
        for(int hmb = 0; hmb < 10; hmb++) {
            NSString * expectedValue = [NSString stringWithFormat:@"value%d", gb];
            RBTotalUsageRecord * record = [[RBTotalUsageRecord alloc] initWithPolicy:policy];
            record.policyDown = gb + hmb / 10.0;
            STAssertTrue([expectedValue isEqualToString:[policy bandwidthClassForUsage:record]], @"Class mismatch for usage: %f", record.policyDown);

            record.policyUp = record.policyDown;
            record.policyDown = 0.0;
            STAssertTrue([expectedValue isEqualToString:[policy bandwidthClassForUsage:record]], @"Class mismatch for usage: %f", record.policyDown);
        }
    }
}

- (void)test2012Policy {
    RBUsagePolicy * policy = [[RBUsagePolicy2012 alloc] init];
    RBTotalUsageRecord * record = [[RBTotalUsageRecord alloc] initWithPolicy:policy];
    
    [self performChecksForRecord:record withClass:@"Unrestricted" minUsage:0.0f maxUsage:4000.0f];
    [self performChecksForRecord:record withClass:@"1024k" minUsage:4000.0f maxUsage:4500.0f];
    [self performChecksForRecord:record withClass:@"160k" minUsage:4500.0f maxUsage:6000.0f];
}

- (void)performChecksForRecord:(RBTotalUsageRecord *)record withClass:(NSString *)bandwidthClass minUsage:(float)min maxUsage:(float)max {
    for(float usage = min; usage < max; usage += 100.0f) {
        record.policyDown = usage;
        STAssertTrue([[record bandwidthClass] isEqualToString:bandwidthClass], @"Class mismatch for usage: %f", usage);
        
        record.policyUp = record.policyDown;
        record.policyDown = 0.0f;
        STAssertTrue([[record bandwidthClass] isEqualToString:bandwidthClass], @"Class mismatch for usage: %f", usage);
    }
}

- (void)testCurrentPolicy {
    RBUsagePolicy * policy = [RBUsagePolicy currentPolicy];
    STAssertNotNil(policy, @"Default policy should not be nil.");
    STAssertTrue([policy isKindOfClass:[RBUsagePolicy2012 class]], @"Default policy is the wrong year.");
}

@end
