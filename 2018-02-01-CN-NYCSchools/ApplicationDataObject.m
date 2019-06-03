//
//  ApplicationDataObject.m
//  2018-02-01-CN-NYCSchools
//
//  Created by Christopher Nelson on 1/31/18.
//  Copyright © 2018 Odeon Software Inc. All rights reserved.
//

#import "ApplicationDataObject.h"
#import "CLNetworkStatusCheck.h"
#import "SchoolDataObject.h"
#import "SchoolScoresDataObject.h"

@interface ApplicationDataObject()

@property (nonatomic, strong, readwrite) NSArray* schoolList; //SchoolDataObject
@property (nonatomic, strong, readwrite) NSArray* schoolScoresList; //SchoolDataObject

@property (nonatomic, strong, readwrite) NSArray* borooghList; //SchoolDataObject

@end

@implementation ApplicationDataObject

+ (instancetype)sharedData
{
    static ApplicationDataObject* _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        
        _sharedInstance = [[self alloc] init];
        
    });
    
    return _sharedInstance;
}

- (instancetype) init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void) resetSchoolData
{
    self.schoolList = nil;
}

- (void) loadShchoolDataForURL:(NSString*)schoolURL withScoresURL:(NSString*)scoresURL boroughs:(NSArray*)boroughs completionHandler:(void (^)(BOOL success, NSError *error))completionHandler;
{
    [ self resetSchoolData];
    
    [CLNetworkStatusCheck networkStatusCheckWithCompletionhandler:^(BOOL available) {
        
        NSError* error = nil;
        
        if(available)
        {
            self.borooghList = nil;
            NSMutableSet* boroughSet = [[NSMutableSet alloc]init];
            
            NSMutableArray* schoolRawData = [[NSMutableArray alloc] init];
            NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:schoolURL]];
            NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            for(NSDictionary* schoolDict in jsonArray)
            {
                SchoolDataObject* schoolData = [[SchoolDataObject alloc] initWithSchoolDictionary:schoolDict];
                BOOL include = YES;
                if(schoolData.borough.length > 0)
                {
                    [boroughSet addObject:schoolData.borough];
                    if(boroughs.count > 0)
                    {
                        NSUInteger index = [boroughs indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            BOOL pass = NO;
                            NSString* boroughTest = obj;
                            
                            if(boroughTest.length == 0 || [boroughTest isEqualToString:schoolData.borough])
                            {
                                pass = YES;
                                *stop = YES;
                            }
                            
                            return pass;
                        }];
                        
                        if(index == NSNotFound)
                        {
                            include = NO;
                        }
                    }
                }
                
                if([schoolData isValidSchool] && include)
                {
                    [schoolRawData addObject:schoolData];
                }
            }
            
            self.borooghList = [boroughSet.allObjects sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            
//            NSLog(@"json: %@", jsonArray);
//            NSLog(@"Boroughs: %@", boroughSet);
//            NSLog(@"Boroughs: %@", self.borooghList);

            [schoolRawData sortUsingComparator:^NSComparisonResult(SchoolDataObject*  _Nonnull obj1, SchoolDataObject*  _Nonnull obj2) {
                
                NSString* name1 = obj1.schoolName;
                NSString* name2 = obj2.schoolName;
                
                return [name1 localizedCaseInsensitiveCompare:name2];
            }];
            
            
            self.schoolList = [NSArray arrayWithArray:schoolRawData];
            
            
            [schoolRawData removeAllObjects];
            data = [NSData dataWithContentsOfURL: [NSURL URLWithString:scoresURL]];
            jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            for(NSDictionary* schoolDict in jsonArray)
            {
                SchoolScoresDataObject* schoolScoreData = [[SchoolScoresDataObject alloc] initWithSchoolScoreDictionary:schoolDict];
                if([schoolScoreData isValidSchoolScore])
                {
                    [schoolRawData addObject:schoolScoreData];
                }
            }

            [schoolRawData sortUsingComparator:^NSComparisonResult(SchoolDataObject*  _Nonnull obj1, SchoolDataObject*  _Nonnull obj2) {
                
                NSString* name1 = obj1.dbn;
                NSString* name2 = obj2.dbn;
                
                return [name1 localizedCaseInsensitiveCompare:name2];
            }];

            
            self.schoolScoresList = [NSArray arrayWithArray:schoolRawData];
            
            completionHandler(YES, error);
        }
        else
        {
            error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:99 userInfo:@{NSLocalizedDescriptionKey: @"Network not available."}];
            completionHandler(NO, error);
        }
    }];
}

@end
