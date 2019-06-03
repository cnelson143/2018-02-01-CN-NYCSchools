//
//  SelectionViewController.m
//  2018-02-01-CN-NYCSchools
//
//  Created by Christopher Nelson on 2/1/18.
//  Copyright © 2018 Odeon Software Inc. All rights reserved.
//

#import "SelectionViewController.h"
#import "ApplicationDataObject.h"

@interface SelectionViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray* selectionsArrayLocal;

@end

@implementation SelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.selectionsArrayLocal = [[NSMutableArray alloc] initWithArray:self.selectionArray];
    if(self.includeAll)
    {
        [self.selectionsArrayLocal insertObject:@"ALL" atIndex:0];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.selectionsArrayLocal.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"selectionCell" forIndexPath:indexPath];

    NSString* text = self.selectionsArrayLocal[indexPath.row];
    
    cell.textLabel.text = text;
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    if([text isEqualToString:self.selectedText])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else if(self.includeAll && indexPath.row == 0 && [text isEqualToString:@"ALL"] && self.selectedText.length == 0)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* text = self.selectionsArrayLocal[indexPath.row];
    
    if(self.includeAll && indexPath.row == 0)
        text = @"";
    
    [self.delegate didPerformSelect:text];
}

- (IBAction)closeButtonPressed:(UIBarButtonItem *)sender
{
    [self.delegate didCancelSelection];
}

@end
