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
}

- (void)tearDown {
    [super tearDown];
}

- (void)testMath {
    STAssertEquals(1 + 1, 2, @"Compiler isn't feeling well today");
}

- (void)testInit {
    RoseBandwidthParser * parser = [[RoseBandwidthParser alloc] initWithSourceURL:[NSURL URLWithString:@"test"]];
    
    STAssertNotNil(parser, @"Parser was nil");
    STAssertTrue([[parser.dataSourceURL absoluteString] isEqualToString:@"test"], @"Parser did not have expected default source.");
    STAssertNil(parser.delegate, @"Parser had non-nil default delegate");
}

- (void)testDefaultParser {
    RoseBandwidthParser * parser = [RoseBandwidthParser defaultParser];
    
    STAssertNotNil(parser, @"Default parser was nil.");
    STAssertTrue([[parser.dataSourceURL absoluteString] isEqualToString:kBandwidthParserDefaultSource], @"Parser did not have expected default source.");
    STAssertNil(parser.delegate, @"Parser had non-nil default delegate");
}

@end
