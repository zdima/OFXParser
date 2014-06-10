//
//  OFXStatement.m
//  OFXParser
//
//  Created by Dmitriy Zakharkin on 5/9/14.
//  Copyright (c) 2014 Dmitriy Zakharkin. All rights reserved.
//

#import "OFXStatement.h"
#import "OFXDelegate.h"

@interface OFXStatement ()
{
    NSMutableArray* _transactions;
}

@end

@implementation OFXStatement

-(void)addTransaction:(OFXTransaction*)transaction
{
    if(!_transactions)
        _transactions = [NSMutableArray new];
    [_transactions addObject:transaction];
}

-(void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"trnuid"])
        return;
    
    if([key isEqualToString:@"curdef"]) {
        self.currency = value;
    } else if([key isEqualToString:@"acctid"]) {
        self.accountID = value;
    } else if([key isEqualToString:@"dtstart"]) {
        self.dateStart = [OFXDelegate parseDateFromString:value];
    } else if([key isEqualToString:@"dtend"]) {
        self.dateEnd = [OFXDelegate parseDateFromString:value];
    } else {
        [super setValue:value forKey:key];
    }
}

@end
