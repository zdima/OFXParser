//
//  OFXDelegate.m
//  OFXParser
//
//  Created by Dmitriy Zakharkin on 5/9/14.
//  Copyright (c) 2014 Dmitriy Zakharkin. All rights reserved.
//

#import "OFXDelegate.h"

#import "OFXDocument.h"
#import "OFXIgnoreSection.h"
#import "OFXStatement.h"
#import "OFXTransaction.h"
#import "OFXLadgerBalance.h"

@interface OFXDelegate ()
{
    OFXDocument* _root;
}

@end

@implementation OFXDelegate

- (instancetype)init
{
    self = [super init];
    if (self) {
        _root = [OFXDocument new];
    }
    return self;
}

-(id)root
{
    return _root;
}

-(id)newTag:(NSString*)tag withAttributes:(NSArray*)attributes forObject:(id)obj
{
    if([tag isEqualToString:@"OFX"]) {
        return _root;
    }
    
    if(obj && [obj isKindOfClass:[OFXIgnoreSection class]])
        return obj;
    
    if([tag isEqualToString:@"CCSTMTRS"] || [tag isEqualToString:@"STMTRS"])
    {
        OFXStatement* stmt = [OFXStatement new];
        [_root addStatement:stmt];
        return stmt;
    }
    
    if([tag isEqualToString:@"STMTTRN"])
    {
        OFXTransaction* trn = [OFXTransaction new];
        [obj addTransaction:trn];
        return trn;
    }
    
    if([tag isEqualToString:@"LEDGERBAL"])
    {
        if(![obj balance])
           [obj setBalance:[OFXLadgerBalance new]];
        return [obj balance];
    }
    
    // ignore these tags
    if([tag isEqualToString:@"SIGNONMSGSRSV1"] || [tag isEqualToString:@"AVAILBAL"])
        return [OFXIgnoreSection new];
    
    return obj;
}

-(id)endTag:(NSString*)tag forObject:(id)object
{
    return nil;
}

-(void)dataString:(NSString*)dataString forObject:(id)obj forTag:(NSString*)tag
{
    if(obj && [obj isKindOfClass:[OFXIgnoreSection class]])
        return;
    NSString* propertyName = [tag lowercaseString];

    @try {
        [obj setValue:dataString forKey:propertyName];
    }
    @catch (NSException *exception) {
        if(exception)
            NSLog(@"Object [%@] does not support property [%@]", obj, tag );
    }
    @finally {
    }
}

+(NSDate *)parseDateFromString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSArray* dateFormatStrings = [NSArray arrayWithObjects:
                                  @"yyyyMMddHHmmss.SSS[Z:z]",
                                  @"yyyyMMddHHmmss[Z:z]",
                                  @"yyyyMMddHHmmss[0:z]",
                                  @"yyyyMMddHHmmss.SSS [Z:z]",
                                  @"yyyyMMddHHmmss.SSS",
                                  @"yyyyMMdd",
                                  @"yyyyMMddHHmmss",
                                  @"yyyyMMddHHmm", nil];
    for (NSString* dateFormat in dateFormatStrings) {
        [dateFormatter setDateFormat:dateFormat];
        NSDate* result = [dateFormatter dateFromString:dateString];
        if (result != nil) return result;
    }
    
    return nil;
}

@end
