//
//  OFXDelegate.h
//  OFXParser
//
//  Created by Dmitriy Zakharkin on 5/9/14.
//  Copyright (c) 2014 Dmitriy Zakharkin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OFXParserDelegate.h"

@interface OFXDelegate : NSObject <OFXParserDelegate>

+(NSDate *)parseDateFromString:(NSString *)dateString;

@end
