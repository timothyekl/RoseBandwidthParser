//
//  RoseBandwidthParser.m
//  RoseBandwidthParser
//
//  Created by Tim Ekl on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RoseBandwidthParser.h"

@implementation RoseBandwidthParser

@synthesize dataSourceURL = _dataSourceURL;
@synthesize delegate = _delegate;

static RoseBandwidthParser * _defaultParser = NULL;

- (id)init {
    return [self initWithSourceURL:[NSURL URLWithString:kBandwidthParserDefaultSource]];
}

- (id)initWithSourceURL:(NSURL *)sourceURL {
    self = [super init];
    if (self) {
        // Initialization code here.
        self.dataSourceURL = sourceURL;
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

@end
