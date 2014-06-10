//
//  OFXTransaction.m
//  OFXParser
//
//  Created by Dmitriy Zakharkin on 5/9/14.
//  Copyright (c) 2014 Dmitriy Zakharkin. All rights reserved.
//

#import "OFXTransaction.h"
#import "OFXDelegate.h"

@implementation OFXTransaction

-(void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"trntype"]) {
        _type = value;
    } else if([key isEqualToString:@"dtposted"]) {
        self.date = [OFXDelegate parseDateFromString:value];
    } else if([key isEqualToString:@"trnamt"]) {
        const char* cStr = [(NSString*)value cStringUsingEncoding:NSUTF8StringEncoding];
        double dval = strtod( cStr, NULL);
        _amount = [NSNumber numberWithDouble:dval];
    } else if([key isEqualToString:@"fitid"]) {
        _fitid = value;
    } else if([key isEqualToString:@"name"]) {
        _name = value;
    } else if([key isEqualToString:@"memo"]) {
        _memo = value;
    } else if([key isEqualToString:@"checknum"]) {
        // TODO: recognize CHECKNUM
    } else {
        [super setValue:value forKey:key];
    }
}
@end
