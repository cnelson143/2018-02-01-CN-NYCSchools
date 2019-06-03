//
//  SchoolTableViewCell.h
//  2018-02-01-CN-NYCSchools
//
//  Created by Christopher Nelson on 1/31/18.
//  Copyright © 2018 Odeon Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchoolTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityStZipLabel;
@property (weak, nonatomic) IBOutlet UILabel *boroughLabel;

@end
