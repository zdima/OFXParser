//
//  OFXParserTests.m
//  OFXParserTests
//
//  Created by Dmitriy Zakharkin on 5/9/14.
//  Copyright (c) 2014 Dmitriy Zakharkin. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "OFXParser.h"
#import "OFXDocument.h"
#import "OFXStatement.h"
#import "OFXTransaction.h"

@interface OFXParserTests : XCTestCase

@end

@implementation OFXParserTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    NSError* error = nil;
    
    NSString* path = [[NSBundle bundleForClass:[self class]] pathForResource:@"test" ofType:@"ofx"];
    NSURL* url = [[NSURL alloc] initFileURLWithPath:path];
    OFXDocument* document = [OFXParser documentFromOFXFile:url error:&error];
    if(error) {
        XCTFail(@"Error while parsing:%@", [error description]);
        return;
    }
    if(document==nil) {
        XCTFail(@"Document is not created" );
        return;
    }
    if(![document isKindOfClass:[OFXDocument class]])
    {
        XCTFail(@"Document is not created" );
        return;
    }
    // test statement
    if(document.statements.count!=1)
    {
        XCTFail(@"Document expoeced to have 1 statement not %ld", document.statements.count );
        return;
    }
    // test records
    OFXStatement* statement = document.statements[0];
    if(statement.transactions.count!=6)
    {
        XCTFail(@"Statement expoeced to have 6 statement not %ld", statement.transactions.count );
        return;
    }
    OFXTransaction* t;
    t = statement.transactions[0];
    if(![t.amount isEqualToNumber:[NSNumber numberWithDouble:-160.0]])
    {
        XCTFail(@"Transaction expoeced to be -160.00 have %@", t.amount );
        return;
    }
    t = statement.transactions[1];
    if(![t.amount isEqualToNumber:[NSNumber numberWithDouble:-53.14]])
    {
        XCTFail(@"Transaction expoeced to be -160.00 have %@", t.amount );
        return;
    }
    t = statement.transactions[2];
    if(![t.amount isEqualToNumber:[NSNumber numberWithDouble:-20.87]])
    {
        XCTFail(@"Transaction expoeced to be -160.00 have %@", t.amount );
        return;
    }
    t = statement.transactions[3];
    if(![t.amount isEqualToNumber:[NSNumber numberWithDouble:-105.62]])
    {
        XCTFail(@"Transaction expoeced to be -160.00 have %@", t.amount );
        return;
    }
    t = statement.transactions[4];
    if(![t.amount isEqualToNumber:[NSNumber numberWithDouble:-71.00]])
    {
        XCTFail(@"Transaction expoeced to be -160.00 have %@", t.amount );
        return;
    }
    t = statement.transactions[5];
    if(![t.amount isEqualToNumber:[NSNumber numberWithDouble:-100.00]])
    {
        XCTFail(@"Transaction expoeced to be -160.00 have %@", t.amount );
        return;
    }
}

@end
