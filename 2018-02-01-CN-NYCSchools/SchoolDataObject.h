//
//  SchoolDataObject.h
//  2018-02-01-CN-NYCSchools
//
//  Created by Christopher Nelson on 1/31/18.
//  Copyright © 2018 Odeon Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SchoolDataObject : NSObject

@property (nonatomic, strong) NSString* dbn;
@property (nonatomic, strong) NSString* schoolName;
@property (nonatomic, strong) NSString* overviewParagraph;
@property (nonatomic, strong) NSString* phoneNumber;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* website;

@property (nonatomic, strong) NSString* address;
@property (nonatomic, strong) NSString* city;
@property (nonatomic, strong) NSString* state;
@property (nonatomic, strong) NSString* zip;

@property (nonatomic, strong) NSString* borough;

@property (nonatomic, strong) NSString* latitude;
@property (nonatomic, strong) NSString* longitude;

- (instancetype) initWithSchoolDictionary:(NSDictionary*)schoolDict;

- (BOOL) isValidSchool;

@end
