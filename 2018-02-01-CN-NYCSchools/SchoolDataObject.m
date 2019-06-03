//
//  SchoolDataObject.m
//  2018-02-01-CN-NYCSchools
//
//  Created by Christopher Nelson on 1/31/18.
//  Copyright © 2018 Odeon Software Inc. All rights reserved.
//

#import "SchoolDataObject.h"

@interface SchoolDataObject ()

@end

@implementation SchoolDataObject

- (instancetype) initWithSchoolDictionary:(NSDictionary*)schoolDict
{
    self = [super init];
    if (self) {
        
        _dbn = schoolDict[@"dbn"];
        _schoolName = schoolDict[@"school_name"];
        _overviewParagraph = schoolDict[@"overview_paragraph"];
        _phoneNumber = schoolDict[@"phone_number"];

        _email = schoolDict[@"school_email"];
        _website = schoolDict[@"website"];
        
        _address = schoolDict[@"primary_address_line_1"];
        _city = schoolDict[@"city"];
        _state = schoolDict[@"state_code"];
        _zip = schoolDict[@"zip"];
        
        _borough = schoolDict[@"borough"];        
        _borough = [_borough stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

        _latitude = schoolDict[@"latitude"];
        _longitude = schoolDict[@"longitude"];
    }
    return self;
}

- (BOOL) isValidSchool
{
    BOOL pass = NO;
    
    if(self.dbn.length > 0 && self.schoolName.length > 0)
    {
        pass = YES;
    }
    
    return pass;
}


@end
