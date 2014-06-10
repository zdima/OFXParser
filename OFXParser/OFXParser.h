//
//  OFXParser.h
//  OFXParser
//
//  Created by Dmitriy Zakharkin on 5/9/14.
//  Copyright (c) 2014 Dmitriy Zakharkin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OFXDocument.h"
#import "OFXStatement.h"
#import "OFXTransaction.h"
#import "OFXLadgerBalance.h"

@interface OFXParser : NSObject

+(OFXDocument*)documentFromOFXFile:(NSURL*)filepath error:(NSError**)error;

@end
