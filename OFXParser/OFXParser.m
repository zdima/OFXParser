//
//  OFXParser.m
//  OFXParser
//
//  Created by Dmitriy Zakharkin on 5/9/14.
//  Copyright (c) 2014 Dmitriy Zakharkin. All rights reserved.
//

#import "OFXParser.h"
#import "OFXDelegate.h"
#import "OFXParserDelegate.h"

@interface OFXParser ()
{
    
}
@property id<OFXParserDelegate> delegate;

@end

@implementation OFXParser

+(id)documentFromOFXFile:(NSURL*)filepath error:(NSError**)error
{
    OFXDelegate* delegate = [OFXDelegate new];
    OFXParser* parser = [[OFXParser alloc] initWithDelegate:delegate];

    [parser parseFileURL:filepath error:error];
    
    if(*error)
    {
        return nil;
    }
    
    id root = [delegate root];
    return root;
}

-(instancetype)initWithDelegate:(id<OFXParserDelegate>)delegate
{
    self = [super init];
    if(self)
    {
        self.delegate = delegate;
    }
    return self;
}

-(BOOL)parseFileURL:(NSURL*)filepath error:(NSError**)error
{
    NSString* ofxStream = [NSString stringWithContentsOfURL:filepath encoding:NSUTF8StringEncoding error:error];
    if(*error)
    {
        return TRUE;
    }
    [self parseOfxString:ofxStream error:(NSError**)error];
    return FALSE;
}

-(BOOL)parseOfxString:(NSString*)ofxStream error:(NSError**)error
{
    NSUInteger idx = 0, idxEnd = ofxStream.length;
    NSUInteger line = 1, possition = 0;
    BOOL tag=FALSE, closeTag=FALSE, data=TRUE, attribute=FALSE;
    NSMutableArray* attributes = [NSMutableArray new];
    NSMutableArray* tags = [NSMutableArray new];
    NSMutableArray* objects = [NSMutableArray new];
    NSMutableString* dataString = [NSMutableString new];
    NSMutableString* tagString = [NSMutableString new];
    NSMutableString* attributeString = [NSMutableString new];
    NSCharacterSet *spaces = [NSCharacterSet characterSetWithCharactersInString:@" \t\r\n"];
    
    while( idx<idxEnd )
    {
        unichar ch = [ofxStream characterAtIndex:idx];
        possition++;
        
        if(ch == L'\r')
        {
            idx++;
            continue;
        }

        if(ch == L'\n' || ch == L'\r')
        {
            possition = 0;
            line++;
            idx++;
            continue;
        }
        
        if(data) {
            if(ch == L'<') {
                data = FALSE;
                dataString = [[dataString stringByTrimmingCharactersInSet:spaces] mutableCopy];
                if(dataString.length>0)
                {
                    if(tags.count>0)
                        [_delegate dataString:dataString forObject:[objects lastObject] forTag:[tags lastObject]];
                }
                dataString = [NSMutableString new];
                idx++;
                continue;
            }
            
            [dataString appendFormat:@"%C", ch];
            idx++;
            continue;
        }
        
        if(attribute)
        {
            if(ch==L' ')
            {
                [attributes addObject:attributeString];
                attributeString = [NSMutableString new];
                
                attribute=TRUE;
                idx++;
                continue;
            }
            
            if(ch==L'>')
            {
                [attributes addObject:attributeString];
                attributeString = [NSMutableString new];
                attribute=FALSE;
                
                // closeTag
                if(closeTag)
                {
                    // pop all until we have this tag
                    while(![[tags lastObject] isEqualToString:tagString])
                    {
                        // close this tag
                        [_delegate endTag:[tags lastObject] forObject:[objects lastObject]];
                        
                        [tags removeLastObject];
                        [objects removeLastObject];
                    }
                    // close this tag
                    [_delegate endTag:[tags lastObject] forObject:[objects lastObject]];
                    
                    [tags removeLastObject];
                    [objects removeLastObject];
                    
                    tagString = [NSMutableString new];
                    data = TRUE;
                    tag = FALSE;
                    closeTag = FALSE;
                    attribute = FALSE;
                    idx++;
                    continue;
                }
                
                [tags addObject:tagString];
                
                id prevObj = nil;
                if(objects.count>0)
                    prevObj = [objects lastObject];
                id obj = [_delegate newTag:tagString withAttributes:attributes forObject:prevObj];
                [objects addObject:obj];

                tagString = [NSMutableString new];
                idx++;
                data = TRUE;
                tag = FALSE;
                closeTag = FALSE;
                attribute = FALSE;
                continue;
            }
            
            [attributeString appendFormat:@"%C", ch];
            idx++;
            continue;
        }

        if(!tag && !closeTag) {
            if(ch == L'/') {
                // close tag
                closeTag = TRUE;
                idx++;
                continue;
            }
            tag = TRUE;
        }

        if(ch == L'>')
        {
            // closeTag
            if(closeTag)
            {
                // pop all until we have this tag
                while(![[tags lastObject] isEqualToString:tagString])
                {
                    // close this tag
                    [_delegate endTag:[tags lastObject] forObject:[objects lastObject]];
                    
                    [tags removeLastObject];
                    [objects removeLastObject];
                }
                // close this tag
                [_delegate endTag:[tags lastObject] forObject:[objects lastObject]];
                
                [tags removeLastObject];
                [objects removeLastObject];
                
                tagString = [NSMutableString new];
                data = TRUE;
                tag = FALSE;
                closeTag = FALSE;
                attribute = FALSE;
                idx++;
                continue;
            }

            [tags addObject:tagString];

            id prevObj = nil;
            if(objects.count>0)
                prevObj = [objects lastObject];
            id obj = [_delegate newTag:tagString withAttributes:attributes forObject:prevObj];
            if(!obj) {
                if(error)
                    *error = [NSError errorWithDomain:@"net.zdima." code:1 userInfo:@{ @"tag": tagString, @"filePossition":@(idx), @"line" : @(line), @"possition":@(possition)}];
                return TRUE;
            }
            [objects addObject:obj];
            
            tagString = [NSMutableString new];
            idx++;
            data = TRUE;
            tag = FALSE;
            closeTag = FALSE;
            attribute = FALSE;
            continue;
        }
        
        if(ch==L' ')
        {
            attribute=TRUE;
            idx++;
            continue;
        }
        
        [tagString appendFormat:@"%C", ch];
        idx++;
        continue;
        
    }
    attributeString = nil;
    attribute = NO;
    return FALSE;
}

@end
