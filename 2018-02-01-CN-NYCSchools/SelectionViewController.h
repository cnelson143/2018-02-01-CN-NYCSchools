//
//  SelectionViewController.h
//  2018-02-01-CN-NYCSchools
//
//  Created by Christopher Nelson on 2/1/18.
//  Copyright © 2018 Odeon Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectDelegate

- (void) didPerformSelect:(NSString*)selection;
- (void) didCancelSelection;

@end

@interface SelectionViewController : UIViewController

@property (nonatomic, strong) NSString* selectedText;
@property (nonatomic, weak) id<SelectDelegate> delegate;
@property (nonatomic, assign) BOOL includeAll;

// Making strong to allow the class to have greater flexibility for the createion of the selectionArray;
@property (nonatomic, strong) NSArray* selectionArray;

@end
