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
- (void)scraper:(RoseBandwidthParser *)parser didDispatchPageRequest:(NSURLRequest *)request;
- (void)scraper:(RoseBandwidthParser *)parser didFinishLoadingConnection:(NSURLConnection *)connection;
- (void)scraper:(RoseBandwidthParser *)parser didBeginParsingData:(NSData *)data;
- (void)scraper:(RoseBandwidthParser *)parser didFinishParsingData:(NSData *)data;
- (void)scraper:(RoseBandwidthParser *)parser foundBandwidthUsageAmounts:(RBTotalUsageRecord *)usage;
- (void)scraper:(RoseBandwidthParser *)parser encounteredError:(NSError *)error;

@end
