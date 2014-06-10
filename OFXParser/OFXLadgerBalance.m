//
//  OFXLadgerBalance.m
//  OFXParser
//
//  Created by Dmitriy Zakharkin on 5/11/14.
//  Copyright (c) 2014 Dmitriy Zakharkin. All rights reserved.
//

#import "OFXLadgerBalance.h"
#import "OFXDelegate.h"

@implementation OFXLadgerBalance

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.balance = nil;
        self.balanceDate = nil;
    }
    return self;
}
-(void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"dtasof"]) {
        self.balanceDate = [OFXDelegate parseDateFromString:value];
    } else if([key isEqualToString:@"balamt"]) {
        const char* cStr = [(NSString*)value cStringUsingEncoding:NSUTF8StringEncoding];
        double dval = strtod( cStr, NULL);
        self.balance = [NSNumber numberWithDouble:dval];
    }
    
}
@end
