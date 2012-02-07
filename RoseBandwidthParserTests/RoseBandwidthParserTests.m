//
//  RoseBandwidthParserTests.m
//  RoseBandwidthParserTests
//
//  Created by Tim Ekl on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <OCMock/OCMock.h>

#import "RoseBandwidthParserTests.h"
#import "RoseBandwidthParser.h"
#import "RBParserDelegate.h"
#import "RBTotalUsageRecord.h"

static NSString * kTestingDataSource = @"http://lithium3141.com/rosebandwidth/networkUsage.php?policyDown=1500&policyUp=1500";

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

- (void)testScraping {
    RoseBandwidthParser * parser = [[RoseBandwidthParser alloc] initWithSourceURL:[NSURL URLWithString:kTestingDataSource]];
    id mockDelegate = [OCMockObject mockForProtocol:@protocol(RBParserDelegate)];
    parser.delegate = mockDelegate;
    
    [[mockDelegate expect] parser:parser didDispatchPageRequest:[OCMArg checkWithBlock:^(id val) {
        if(![val isKindOfClass:[NSURLRequest class]]) return NO;
        return [[[(NSURLRequest *)val URL] absoluteString] isEqualToString:kTestingDataSource];
    }]];
    [[mockDelegate expect] parser:parser didFinishLoadingConnection:[OCMArg checkWithBlock:^(id val) {
        return [val isKindOfClass:[NSURLConnection class]];
    }]];
    [[mockDelegate expect] parser:parser didBeginParsingData:[OCMArg checkWithBlock:^(id val) {
        if(![val isKindOfClass:[NSData class]]) return NO;
        return [(NSData *)val length] > 0;
    }]];
    [[mockDelegate expect] parser:parser didFinishParsingData:[OCMArg checkWithBlock:^(id val) {
        if(![val isKindOfClass:[NSData class]]) return NO;
        return [(NSData *)val length] > 0;
    }]];
    [[mockDelegate expect] parser:parser parsedTotalUsageRecord:[OCMArg checkWithBlock:^(id val) {
        if(![val isKindOfClass:[RBTotalUsageRecord class]]) return NO;
        if(![[(RBTotalUsageRecord *)val bandwidthClass] isEqualToString:@"Unrestricted"]) return NO;
        if(![(RBTotalUsageRecord *)val policyDown] - 1500.0f > 1.0f) return NO;
        if(![(RBTotalUsageRecord *)val policyUp] - 1500.0f > 1.0f) return NO;
        return YES;
    }]];
    
    [parser beginScrapingWithUsername:@"foo" password:@"bar"];
    
    [self tryVerifyingMock:mockDelegate forTimeInterval:10.0 inIncrementsOf:0.5];
}

- (void)testCanceledScraping {
    RoseBandwidthParser * parser = [[RoseBandwidthParser alloc] initWithSourceURL:[NSURL URLWithString:kTestingDataSource]];
    id mockDelegate = [OCMockObject niceMockForProtocol:@protocol(RBParserDelegate)];
    parser.delegate = mockDelegate;
    
    [[mockDelegate expect] parser:parser encounteredError:[OCMArg checkWithBlock:^(id val) {
        if(![val isKindOfClass:[NSError class]]) return NO;
        if(![[(NSError *)val domain] isEqualToString:@"canceled"]) return NO;
        return YES;
    }]];
    
    [parser beginScrapingWithUsername:@"foo" password:@"bar"];
    [parser cancelScraping];
    
    [mockDelegate verify];
}

- (void)testErroredScraping {
    RoseBandwidthParser * parser = [[RoseBandwidthParser alloc] initWithSourceURL:[NSURL URLWithString:@"foo"]];
    id mockDelegate = [OCMockObject niceMockForProtocol:@protocol(RBParserDelegate)];
    parser.delegate = mockDelegate;
    
    [[mockDelegate expect] parser:parser encounteredError:[OCMArg checkWithBlock:^(id val) {
        if(![val isKindOfClass:[NSError class]]) return NO;
        return YES;
    }]];
    
    [parser beginScrapingWithUsername:@"foo" password:@"bar"];
    
    [self tryVerifyingMock:mockDelegate forTimeInterval:1.0 inIncrementsOf:0.5];
}

#pragma mark -
#pragma mark Helper methods

- (void)tryVerifyingMock:(id)mockObject forTimeInterval:(NSTimeInterval)interval inIncrementsOf:(NSTimeInterval)increment {
    NSTimeInterval passed = 0;
    while(passed < interval) {
        @try {
            [mockObject verify];
            break;
        }
        @catch (NSException * e) {}
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:increment]];
        passed += increment;
    }
    
    [mockObject verify];
}

@end
