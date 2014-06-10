//
//  OFXDocument.m
//  OFXParser
//
//  Created by Dmitriy Zakharkin on 5/9/14.
//  Copyright (c) 2014 Dmitriy Zakharkin. All rights reserved.
//

#import "OFXDocument.h"

@interface OFXDocument ()
{
    NSMutableArray* _statements;
}

@end

@implementation OFXDocument

-(void)addStatement:(OFXStatement*)statement
{
    if(!_statements)
        _statements = [NSMutableArray new];
    [_statements addObject:statement];
}

-(void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"trnuid"])
        return;
    if([key isEqualToString:@"code"])
        return;
    if([key isEqualToString:@"severity"])
        return;
    if([key isEqualToString:@"message"])
        return;
}
@end
