//
//  RoseBandwidthParserTests.m
//  RoseBandwidthParserTests
//
//  Created by Tim Ekl on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RoseBandwidthParserTests.h"

#import "RoseBandwidthParser.h"

@implementation RoseBandwidthParserTests

- (void)setUp {
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown {
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testMath {
    STAssertEquals(1 + 1, 2, @"Compiler isn't feeling well today");
}

- (void)testInit {
    
}

- (void)testDefaultParser {
    RoseBandwidthParser * parser = [RoseBandwidthParser defaultParser];
    
    STAssertNotNil(parser, @"Default parser was nil.");
    STAssertTrue([[parser.dataSourceURL absoluteString] isEqualToString:kBandwidthParserDefaultSource], @"Parser did not have expected default source.");
}

@end
