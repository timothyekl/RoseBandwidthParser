//
//  RBTotalUsageRecord.h
//  RoseBandwidthParser
//
//  Created by Tim Ekl on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RBUsageRecord.h"

@interface RBTotalUsageRecord : RBUsageRecord

@property (nonatomic, strong) NSMutableArray * machineRecords;

- (NSString *)bandwidthClass;

@end
