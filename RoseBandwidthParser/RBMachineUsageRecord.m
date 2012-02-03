//
//  RBMachineUsageRecord.m
//  RoseBandwidthParser
//
//  Created by Tim Ekl on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RBMachineUsageRecord.h"

@implementation RBMachineUsageRecord

@synthesize macAddress = _macAddress;
@synthesize hostName = _hostName;
@synthesize comment = _comment;

- (NSString *)macAddressString {
    char macChars[16] = "0123456789ABCDEF";
    char macAddressCStr[18] = "00:00:00:00:00:00";
    uint64_t macAddress = self.macAddress;
    
    for(int i = 0; i < 6; i++) {
        uint8_t byte = macAddress & 0xFF;
        macAddressCStr[(5 - i) * 3 + 1] = macChars[byte & 0xF];
        macAddressCStr[(5 - i) * 3] = macChars[(byte >> 4) & 0xF];
        macAddress = macAddress >> 8;
    }
    
    return [NSString stringWithCString:macAddressCStr encoding:NSASCIIStringEncoding];
}

@end
