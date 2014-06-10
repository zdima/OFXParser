//
//  OFXTransaction.h
//  OFXParser
//
//  Created by Dmitriy Zakharkin on 5/9/14.
//  Copyright (c) 2014 Dmitriy Zakharkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OFXTransaction : NSObject

@property NSString* type;
@property NSDate* date;
@property NSNumber* amount;
@property NSString* fitid;
@property NSString* name;
@property NSString* memo;

@end
