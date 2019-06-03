//
//  SchoolScoresDataObject.h
//  2018-02-01-CN-NYCSchools
//
//  Created by Christopher Nelson on 1/31/18.
//  Copyright © 2018 Odeon Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SchoolScoresDataObject : NSObject

@property (nonatomic, strong) NSString* dbn;
@property (nonatomic, strong) NSString* schoolName;
@property (nonatomic, strong) NSString* numOfSATTestTakers;
@property (nonatomic, strong) NSString* satCriticalReadingAvgScore;
@property (nonatomic, strong) NSString* satMathAvgScore;
@property (nonatomic, strong) NSString* satWritingAvgScore;

- (instancetype) initWithSchoolScoreDictionary:(NSDictionary*)schoolScoreDict;

- (BOOL) isValidSchoolScore;

@end
