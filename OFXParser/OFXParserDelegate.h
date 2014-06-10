//
//  OFXParserDelegate.h
//  OFXParser
//
//  Created by Dmitriy Zakharkin on 5/9/14.
//  Copyright (c) 2014 Dmitriy Zakharkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OFXParserDelegate <NSObject>

-(id)root;
-(id)newTag:(NSString*)tag withAttributes:(NSArray*)attributes forObject:(id)obj;
-(id)endTag:(NSString*)tag forObject:(id)object;
-(void)dataString:(NSString*)dataString forObject:(id)object forTag:(NSString*)tag;

@end

