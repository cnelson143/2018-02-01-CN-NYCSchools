//
//  SchoolScoresDataObject.m
//  2018-02-01-CN-NYCSchools
//
//  Created by Christopher Nelson on 1/31/18.
//  Copyright © 2018 Odeon Software Inc. All rights reserved.
//

#import "SchoolScoresDataObject.h"

@implementation SchoolScoresDataObject

- (instancetype) initWithSchoolScoreDictionary:(NSDictionary*)schoolScoreDict;
{
    self = [super init];
    if (self) {
        
        _dbn = schoolScoreDict[@"dbn"];
        _schoolName = schoolScoreDict[@"school_name"];
        
        _numOfSATTestTakers = schoolScoreDict[@"num_of_sat_test_takers"];
        _satCriticalReadingAvgScore = schoolScoreDict[@"sat_critical_reading_avg_score"];
        _satMathAvgScore = schoolScoreDict[@"sat_math_avg_score"];
        _satWritingAvgScore = schoolScoreDict[@"sat_writing_avg_score"];
    }
    return self;
}

- (BOOL) isValidSchoolScore
{
    BOOL pass = NO;
    
    if(self.dbn.length > 0 && self.schoolName.length > 0)
    {
        pass = YES;
    }
    
    return pass;
}

@end
