//
//  OFXDocument.h
//  OFXParser
//
//  Created by Dmitriy Zakharkin on 5/9/14.
//  Copyright (c) 2014 Dmitriy Zakharkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OFXStatement;

@interface OFXDocument : NSObject

@property (nonatomic) NSArray* statements;

-(void)addStatement:(OFXStatement*)statement;

@end
