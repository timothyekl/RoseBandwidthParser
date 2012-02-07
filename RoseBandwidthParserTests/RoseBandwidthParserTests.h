//
//  RoseBandwidthParserTests.h
//  RoseBandwidthParserTests
//
//  Created by Tim Ekl on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@interface RoseBandwidthParserTests : SenTestCase

- (void)tryVerifyingMock:(id)mockObject forTimeInterval:(NSTimeInterval)interval inIncrementsOf:(NSTimeInterval)increment;

@end
