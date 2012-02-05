//
//  RoseBandwidthParser.h
//  RoseBandwidthParser
//
//  Created by Tim Ekl on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RBParserDelegate.h"

static NSString * kBandwidthParserDefaultSource = @"https://netreg.rose-hulman.edu/tools/networkUsage.pl";

@interface RoseBandwidthParser : NSObject <NSURLConnectionDelegate, NSXMLParserDelegate>

@property (nonatomic, strong) NSURL * dataSourceURL;
@property (nonatomic, unsafe_unretained) id<RBParserDelegate> delegate;
@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSString * password;

+ (RoseBandwidthParser *)defaultParser;

- (id)initWithSourceURL:(NSURL *)sourceURL;

- (void)beginScraping;
- (void)beginScrapingWithUsername:(NSString *)username password:(NSString *)password;
- (void)cancelScraping;

@end
