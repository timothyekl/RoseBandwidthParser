//
//  BandwidthScraperDelegate.h
//  RoseBandwidth
//
//  Created by Tim Ekl on 9/26/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RoseBandwidthParser;
@class RBTotalUsageRecord;

@protocol RBParserDelegate <NSObject>

@optional
- (void)parser:(RoseBandwidthParser *)parser didDispatchPageRequest:(NSURLRequest *)request;
- (void)parser:(RoseBandwidthParser *)parser didFinishLoadingConnection:(NSURLConnection *)connection;
- (void)parser:(RoseBandwidthParser *)parser didBeginParsingData:(NSData *)data;
- (void)parser:(RoseBandwidthParser *)parser didFinishParsingData:(NSData *)data;
- (void)parser:(RoseBandwidthParser *)parser parsedTotalUsageRecord:(RBTotalUsageRecord *)usage;
- (void)parser:(RoseBandwidthParser *)parser encounteredError:(NSError *)error;

@end
