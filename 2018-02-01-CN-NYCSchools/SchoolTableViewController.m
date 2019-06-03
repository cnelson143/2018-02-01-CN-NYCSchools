//
//  SchoolTableViewController.m
//  2018-02-01-CN-NYCSchools
//
//  Created by Christopher Nelson on 1/31/18.
//  Copyright © 2018 Odeon Software Inc. All rights reserved.
//

#import "SchoolTableViewController.h"
#import "ApplicationDataObject.h"
#import "SchoolTableViewCell.h"
#import "SchoolDataObject.h"
#import "SchoolDetailViewController.h"
#import "SelectionViewController.h"

// Central location for URLs
NSString* const nycSchoolURLString = @"https://data.cityofnewyork.us/resource/97mf-9njv.json";
NSString* const nycSchoolScoreURLString = @"https://data.cityofnewyork.us/resource/734v-jeq5.json";

@interface SchoolTableViewController () <UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchResultsUpdating,  UISearchBarDelegate, SelectDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UITableViewController* searchResultsTableViewController;

@property (nonatomic, strong) NSArray *searchFilteredItems;

@property (nonatomic, strong) NSString* selectedBorough;

@end

@implementation SchoolTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Load the previous boroug if available, initializing to an empty string otherwise would later be creating an array with a nil entry
    self.selectedBorough = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedBorough"];
    
    // Empty string is the 'ALL' filter
    if(self.selectedBorough == nil)
        self.selectedBorough = @"";

    // Register Cell for the main tableview
    [self.tableView registerNib:[UINib nibWithNibName:@"SchoolTableViewCell" bundle:nil] forCellReuseIdentifier:@"schoolCell"];

    // Allow the user to refresh by dragging, useful if the network was not available when they launched the App,
    // Otherwise they you have to restart the App to get the initial Data
    UIRefreshControl* refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshControl) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = refreshControl;
    
    // Initialize Search
    self.searchResultsTableViewController = [[UITableViewController alloc] init];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultsTableViewController];
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    // we want to be the delegate for our filtered table so didSelectRowAtIndexPath is called for both tables
    self.searchResultsTableViewController.tableView.delegate = self;
    self.searchResultsTableViewController.tableView.dataSource = self;
    
    self.searchController.delegate = self;
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    self.searchController.dimsBackgroundDuringPresentation = YES;
    self.searchController.searchBar.delegate = self; // so we can monitor text changes + others
    
    self.definesPresentationContext = YES;  // know where you want UISearchController to be displayed

    // Register Cell for the search tableview
    [self.searchResultsTableViewController.tableView registerNib:[UINib nibWithNibName:@"SchoolTableViewCell" bundle:nil] forCellReuseIdentifier:@"schoolCell"];

    [self.tableView.refreshControl beginRefreshing];
    [self refreshControl];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(self.selectedBorough.length == 0)
        self.title = @"NYC Schools (All)";
    else
        self.title = [NSString stringWithFormat:@"NYC Schools (%@)", self.selectedBorough];
}

- (void) refreshControl
{
    [[ApplicationDataObject sharedData] resetSchoolData];
    [self.tableView reloadData];
    
    // The user interface only support selecting a single borough, the objects support multiple boroughs
    [[ApplicationDataObject sharedData] loadShchoolDataForURL:nycSchoolURLString withScoresURL:nycSchoolScoreURLString boroughs:@[self.selectedBorough] completionHandler:^(BOOL success, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
            
            [self.tableView.refreshControl endRefreshing];
            
            if(!success)
            {
                NSString* errorMessage = @"";
                if(error == nil)
                {
                    errorMessage = @"An unknown error occurred.  Please pull to refresh.";
                }
                else
                {
                    errorMessage = [NSString stringWithFormat:@"%@  Please pull to refresh.", error.localizedDescription];
                }
                
                [self performSelector:@selector(displayErrorMessage:) withObject:errorMessage afterDelay:1.0];
            }
            
        });

    }];
}

- (void) displayErrorMessage:(NSString*) errorMessage
{
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Error l" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
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
    if (tableView == self.searchResultsTableViewController.tableView)
    {
        return self.searchFilteredItems.count;
    }

    return [ApplicationDataObject sharedData].schoolList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SchoolTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"schoolCell" forIndexPath:indexPath];
    
    SchoolDataObject* schoolData = nil;
    
    // Data source is based on the main or search table views
    if(tableView == self.searchResultsTableViewController.tableView)
    {
        schoolData = self.searchFilteredItems[indexPath.row];
    }
    else
    {
        schoolData = [ApplicationDataObject sharedData].schoolList[indexPath.row];
    }

    // Configure Cell
    cell.schoolLabel.text = schoolData.schoolName;
    cell.addressLabel.text = schoolData.address;
    cell.cityStZipLabel.text = [NSString stringWithFormat:@"%@, %@ %@", schoolData.city, schoolData.state, schoolData.zip];
    cell.boroughLabel.text = schoolData.borough;

    if(indexPath.row % 2 == 0)
        cell.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1.0];
    else
        cell.backgroundColor = [UIColor whiteColor];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableViewDelegate Delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SchoolDataObject* schoolData = nil;
    
    // Data source is based on the main or search table views
    if(tableView == self.searchResultsTableViewController.tableView)
    {
        schoolData = self.searchFilteredItems[indexPath.row];
    }
    else
    {
        schoolData = [ApplicationDataObject sharedData].schoolList[indexPath.row];
    }

    [self performSegueWithIdentifier:@"schoolDetailSegue" sender:schoolData];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// Same height for either tableview
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}

#pragma - SelectDelegate

- (void) didPerformSelect:(NSString*)selection
{
    self.selectedBorough = selection;
    
    [[NSUserDefaults standardUserDefaults] setObject:self.selectedBorough forKey:@"selectedBorough"];
    
    // Refresh
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView.refreshControl beginRefreshing];
        [[ApplicationDataObject sharedData] resetSchoolData];
        [self.tableView reloadData];
        
        [self dismissViewControllerAnimated:YES completion:^{
            
            [self refreshControl];
            
        }];
    });
    
}

- (void) didCancelSelection
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UISearchControllerDelegate Delegate

- (void)willPresentSearchController:(UISearchController *)searchController
{
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    self.searchFilteredItems = nil;
    
    [self.tableView reloadData];
}

#pragma mark - UISearchResultsUpdating Delegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    
    self.searchFilteredItems = nil;
    
    // Search based on predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"schoolName.lowercaseString contains[c] %@", searchString.lowercaseString];
    NSArray *filtered = [[ApplicationDataObject sharedData].schoolList filteredArrayUsingPredicate:predicate];
    
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"schoolName" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    self.searchFilteredItems = [filtered sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    [self.searchResultsTableViewController.tableView reloadData];
}

#pragma mark - Navigation

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    BOOL pass = YES;
    
    // Cancel Segue if there is no data in the list
    if([identifier isEqualToString:@"selectBoroughSegue"])
    {
        if([ApplicationDataObject sharedData].schoolList.count > 0)
            pass = YES;
        else
            pass = NO;
    }
    
    return pass;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if([segue.identifier isEqualToString:@"schoolDetailSegue"])
    {
        SchoolDataObject* schoolData = sender;
        SchoolDetailViewController* schoolVC = segue.destinationViewController;
        schoolVC.schoolData = schoolData;
    }
    else if([segue.identifier isEqualToString:@"selectBoroughSegue"])
    {
        UINavigationController* navCtrl = segue.destinationViewController;
        SelectionViewController* selectionVC = (SelectionViewController*)navCtrl.topViewController;
        selectionVC.delegate = self;
        selectionVC.selectedText = self.selectedBorough;
        selectionVC.includeAll = YES;
        selectionVC.selectionArray = [ApplicationDataObject sharedData].borooghList;
    }
    
}

@end
