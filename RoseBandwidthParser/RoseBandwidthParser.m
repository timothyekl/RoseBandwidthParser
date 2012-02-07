//
//  RoseBandwidthParser.m
//  RoseBandwidthParser
//
//  Created by Tim Ekl on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RoseBandwidthParser.h"

#import "RBTotalUsageRecord.h"
#import "RBMachineUsageRecord.h"
#import "RBUsagePolicy.h"
#import "XPathQuery.h"

#define FETCH_TIMEOUT 10.0

@interface RoseBandwidthParser()

- (NSNumber *)numberFromMBUsageString:(NSString *)str;

@end

@implementation RoseBandwidthParser

@synthesize dataSourceURL = _dataSourceURL;
@synthesize delegate = _delegate;
@synthesize username = _username;
@synthesize password = _password;

NSMutableData * _data;
NSURLConnection * _conn;

static RoseBandwidthParser * _defaultParser = NULL;

- (id)init {
    return [self initWithSourceURL:[NSURL URLWithString:kBandwidthParserDefaultSource]];
}

- (id)initWithSourceURL:(NSURL *)sourceURL {
    self = [super init];
    if (self) {
        // Initialization code here.
        self.dataSourceURL = sourceURL;
        _data = [[NSMutableData alloc] init];
    }
    
    return self;
}

+ (RoseBandwidthParser *)defaultParser {
    @synchronized(self) {
        if(_defaultParser == NULL) {
            _defaultParser = [[RoseBandwidthParser alloc] init];
        }
    }
    
    return _defaultParser;
}

#pragma mark -
#pragma mark Actions

- (void)beginScraping {
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:self.dataSourceURL
                                                                 cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData 
                                                             timeoutInterval:FETCH_TIMEOUT];
    _conn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    if([self.delegate respondsToSelector:@selector(parser:didDispatchPageRequest:)]) {
        [self.delegate parser:self didDispatchPageRequest:request];
    }
}

- (void)beginScrapingWithUsername:(NSString *)username password:(NSString *)password {
    self.username = username;
    self.password = password;
    
    [self beginScraping];
}

- (void)cancelScraping {
    [_conn cancel];
    if([self.delegate respondsToSelector:@selector(parser:encounteredError:)]) {
        NSError * err = [[NSError alloc] initWithDomain:@"canceled" code:-1 userInfo:nil];
        [self.delegate parser:self encounteredError:err];
    }
}

#pragma mark -
#pragma mark NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if([challenge previousFailureCount] == 0) {
        NSURLCredential * cred = [[NSURLCredential alloc] initWithUser:_username password:_password persistence:NSURLCredentialPersistenceNone];
        [[challenge sender] useCredential:cred forAuthenticationChallenge:challenge];
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    // Nothing to see here, move along...
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // Delegate notifications
    if([self.delegate respondsToSelector:@selector(parser:didFinishLoadingConnection:)]) {
        [self.delegate parser:self didFinishLoadingConnection:connection];
    }
    
    if([self.delegate respondsToSelector:@selector(parser:didBeginParsingData:)]) {
        [self.delegate parser:self didBeginParsingData:_data];
    }
    
    // Grab total data
    NSArray * results = PerformHTMLXPathQuery([_data copy], @"//div[@class='mainContainer']/table[@class='ms-rteTable-1'][1]/tr[@class='ms-rteTableOddRow-1']/td");

    RBUsagePolicy * policy = [RBUsagePolicy currentPolicy];
    RBTotalUsageRecord * record = [[RBTotalUsageRecord alloc] initWithPolicy:policy];
    record.username = _username;
    record.timestamp = [NSDate date];
    record.policyDown = [self numberFromMBUsageString:[[results objectAtIndex:1] objectForKey:@"nodeContent"]].floatValue;
    record.policyUp = [self numberFromMBUsageString:[[results objectAtIndex:2] objectForKey:@"nodeContent"]].floatValue;
    record.actualDown = [self numberFromMBUsageString:[[results objectAtIndex:3] objectForKey:@"nodeContent"]].floatValue;
    record.actualUp = [self numberFromMBUsageString:[[results objectAtIndex:4] objectForKey:@"nodeContent"]].floatValue;
    
    // Now go for machine-specific data
    results = PerformHTMLXPathQuery([_data copy], @"//div[@class='mainContainer']/table[@class='ms-rteTable-1'][2]/tr");
    
    for(id row in [results subarrayWithRange:NSMakeRange(1, results.count - 1)]) {
        id result = [row objectForKey:@"nodeChildArray"];
        
        NSString * macAddressString = [[result objectAtIndex:0] objectForKey:@"nodeContent"];
        NSString * hostname = [[result objectAtIndex:1] objectForKey:@"nodeContent"];
        NSString * comment = [[result objectAtIndex:2] objectForKey:@"nodeContent"];
        RBMachineUsageRecord * machineRecord = [[RBMachineUsageRecord alloc] initWithPolicy:policy hostName:hostname comment:comment];
        
        machineRecord.timestamp = record.timestamp;
        machineRecord.username = record.username;
        [machineRecord setMacAddressFromString:macAddressString];
        machineRecord.policyDown = [self numberFromMBUsageString:[[result objectAtIndex:3] objectForKey:@"nodeContent"]].floatValue;
        machineRecord.policyUp = [self numberFromMBUsageString:[[result objectAtIndex:4] objectForKey:@"nodeContent"]].floatValue;
        machineRecord.actualDown = [self numberFromMBUsageString:[[result objectAtIndex:5] objectForKey:@"nodeContent"]].floatValue;
        machineRecord.actualUp = [self numberFromMBUsageString:[[result objectAtIndex:6] objectForKey:@"nodeContent"]].floatValue;
        
        [record.machineRecords addObject:machineRecord];
    }
    
    // More delegate notifications
    if([self.delegate respondsToSelector:@selector(parser:didFinishParsingData:)]) {
        [self.delegate parser:self didFinishParsingData:_data];
    }
    
    if([self.delegate respondsToSelector:@selector(parser:parsedTotalUsageRecord:)]) {
        [self.delegate parser:self parsedTotalUsageRecord:record];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if([self.delegate respondsToSelector:@selector(parser:encounteredError:)]) {
        [self.delegate parser:self encounteredError:error];
    }
}

#pragma mark -
#pragma mark Helper methods

- (NSNumber *)numberFromMBUsageString:(NSString *)str {
    NSString * stripped = [[str stringByReplacingOccurrencesOfString:@" MB" withString:@""] stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSNumber * number = [NSDecimalNumber decimalNumberWithString:stripped];
    return number;
}

@end
