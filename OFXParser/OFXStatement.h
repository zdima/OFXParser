//
//  OFXStatement.h
//  OFXParser
//
//  Created by Dmitriy Zakharkin on 5/9/14.
//  Copyright (c) 2014 Dmitriy Zakharkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OFXTransaction;
@class OFXLadgerBalance;

@interface OFXStatement : NSObject

@property NSArray* transactions;
@property NSString* currency;
@property NSString* accountID;
@property NSDate* dateStart;
@property NSDate* dateEnd;
@property OFXLadgerBalance* balance;

-(void)addTransaction:(OFXTransaction*)transaction;

@end
