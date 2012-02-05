//
//  RBUsagePolicy2012.m
//  RoseBandwidthParser
//
//  Created by Tim Ekl on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RBUsagePolicy2012.h"

@implementation RBUsagePolicy2012

- (id)init {
    NSDictionary * boundaries = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"Unlimited", [RBUsagePolicy defaultBandwidthPolicyKey],
                                 @"1024k", [NSNumber numberWithFloat:4.0],
                                 @"160k", [NSNumber numberWithFloat:4.5],
                                 nil];
    if((self = [super initWithBandwidthBoundaries:boundaries])) {
        
    }
    return self;
}

@end
