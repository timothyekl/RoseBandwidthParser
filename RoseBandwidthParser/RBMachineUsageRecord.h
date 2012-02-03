//
//  RBMachineUsageRecord.h
//  RoseBandwidthParser
//
//  Created by Tim Ekl on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RBUsageRecord.h"

@interface RBMachineUsageRecord : RBUsageRecord

@property (nonatomic, assign) uint64_t macAddress;
@property (nonatomic, strong) NSString * hostName;
@property (nonatomic, strong) NSString * comment;

- (NSString *)macAddressString;

@end
