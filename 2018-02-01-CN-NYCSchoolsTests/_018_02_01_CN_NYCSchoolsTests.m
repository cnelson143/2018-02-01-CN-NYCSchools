//
//  _018_02_01_CN_NYCSchoolsTests.m
//  2018-02-01-CN-NYCSchoolsTests
//
//  Created by Christopher Nelson on 1/31/18.
//  Copyright © 2018 Odeon Software Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ApplicationDataObject.h"
#import "SchoolDataObject.h"
#import "SchoolScoresDataObject.h"

NSString* const nycSchoolURLString = @"https://data.cityofnewyork.us/resource/97mf-9njv.json";
NSString* const nycSchoolScoreURLString = @"https://data.cityofnewyork.us/resource/734v-jeq5.json";

@interface _018_02_01_CN_NYCSchoolsTests : XCTestCase

@end

@implementation _018_02_01_CN_NYCSchoolsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)fulfillExpectation:(XCTestExpectation *)expectation
{
    [expectation fulfill];
}

- (void)testDataAccess {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    // All Boroughs
    [self loadDataForBoroughs:@[@""] completionHandler:^(BOOL success, NSString *errorMessage) {
        
        if(success)
        {
            NSUInteger bororoghTotal = [ApplicationDataObject sharedData].borooghList.count;
            NSUInteger schoolsTotal = [ApplicationDataObject sharedData].schoolList.count;
            NSUInteger schoolsScoresTotal = [ApplicationDataObject sharedData].schoolScoresList.count;
            
            NSLog(@"Number of Boroughs - %zd", bororoghTotal);
            NSLog(@"Number of Schools - %zd", schoolsTotal);
            NSLog(@"Number of Scores Total - %zd", schoolsScoresTotal);
        }
        else
        {
            XCTAssert(NO, @"Failed - Unable to load data - %@", errorMessage);
        }
        
    }];
}

- (void) loadDataForBoroughs:(NSArray*)boroughsArray completionHandler:(void (^)(BOOL success, NSString *errorMessage))completionHandler;
{
    [[ApplicationDataObject sharedData] resetSchoolData];
    [[ApplicationDataObject sharedData] loadShchoolDataForURL:nycSchoolURLString withScoresURL:nycSchoolScoreURLString boroughs:boroughsArray completionHandler:^(BOOL success, NSError *error) {
        
        NSString* errorMessage = @"";
        if(!success)
        {
            if(error == nil)
            {
                errorMessage = @"An unknown error occurred.  Please pull to refresh.";
            }
            else
            {
                errorMessage = [NSString stringWithFormat:@"%@  Please pull to refresh.", error.localizedDescription];
            }
            
        }
        
        completionHandler(success, errorMessage);
    }];

    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
