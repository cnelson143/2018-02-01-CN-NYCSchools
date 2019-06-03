//
//  ApplicationDataObject.h
//  2018-02-01-CN-NYCSchools
//
//  Created by Christopher Nelson on 1/31/18.
//  Copyright © 2018 Odeon Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SchoolDataObject.h"

@interface ApplicationDataObject : NSObject

+ (instancetype)sharedData;

@property (nonatomic, strong, readonly) NSArray* schoolList; //SchoolDataObject
@property (nonatomic, strong, readonly) NSArray* schoolScoresList; //SchoolScoresDataObject
@property (nonatomic, strong, readonly) NSArray* borooghList; //NSString

- (void) loadShchoolDataForURL:(NSString*)stringURL withScoresURL:(NSString*)scoresURL boroughs:(NSArray*)boroughs completionHandler:(void (^)(BOOL success, NSError *error))completionHandler;
- (void) resetSchoolData;

@end
