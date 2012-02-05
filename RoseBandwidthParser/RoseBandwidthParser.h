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

@interface RoseBandwidthParser : NSObject <NSXMLParserDelegate>

@property (nonatomic, strong) NSURL * dataSourceURL;
@property (nonatomic, unsafe_unretained) id<RBParserDelegate> delegate;

+ (RoseBandwidthParser *)defaultParser;

- (id)initWithSourceURL:(NSURL *)sourceURL;

- (void)beginScrapingWithUsername:(NSString *)username password:(NSString *)password;
- (void)cancelScraping;

@end
