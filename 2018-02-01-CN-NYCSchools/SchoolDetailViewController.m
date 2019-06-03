//
//  SchoolDetailViewController.m
//  2018-02-01-CN-NYCSchools
//
//  Created by Christopher Nelson on 1/31/18.
//  Copyright © 2018 Odeon Software Inc. All rights reserved.
//

#import "SchoolDetailViewController.h"
#import "ApplicationDataObject.h"
#import "SchoolScoresDataObject.h"
#import <MessageUI/MFMailComposeViewController.h>
@import SafariServices;
#import "MapViewController.h"

@interface SchoolDetailViewController () <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;
@property (weak, nonatomic) IBOutlet UILabel *numOfSATTestTakersLabel;
@property (weak, nonatomic) IBOutlet UILabel *satCriticalReadingAvgScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *satMathAvgScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *satWritingAvgScoreLabel;

@property (weak, nonatomic) IBOutlet UITextView *overViewParagrapgTextView;

@property (weak, nonatomic) IBOutlet UIButton *phoneNumberButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *websiteButton;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;

@end

@implementation SchoolDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Information";
    
    if(self.schoolData != nil)
    {
        self.schoolLabel.text = self.schoolData.schoolName;
        self.overViewParagrapgTextView.text = self.schoolData.overviewParagraph;
    
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dbn.lowercaseString contains[c] %@", self.schoolData.dbn.lowercaseString];
        NSArray *filtered = [[ApplicationDataObject sharedData].schoolScoresList filteredArrayUsingPredicate:predicate];
        
        // Should be found once and only once, considering all other counts including greater than 1 to be an error condition
        if(filtered.count == 1)
        {
            SchoolScoresDataObject* schoolScoresDataObject = filtered[0];
            self.numOfSATTestTakersLabel.text = schoolScoresDataObject.numOfSATTestTakers;
            self.satCriticalReadingAvgScoreLabel.text = schoolScoresDataObject.satCriticalReadingAvgScore;
            self.satMathAvgScoreLabel.text = schoolScoresDataObject.satMathAvgScore;
            self.satWritingAvgScoreLabel.text = schoolScoresDataObject.satWritingAvgScore;
        }
        else
        {
            self.numOfSATTestTakersLabel.text = @"N/A";
            self.satCriticalReadingAvgScoreLabel.text = @"N/A";
            self.satMathAvgScoreLabel.text = @"N/A";
            self.satWritingAvgScoreLabel.text = @"N/A";
        }
        
        if(self.schoolData.phoneNumber.length > 0)
        {
            [self.phoneNumberButton setTitle:[NSString stringWithFormat:@"Call: %@", self.schoolData.phoneNumber] forState:UIControlStateNormal];
        }
        else
        {
            self.phoneNumberButton.enabled = NO;
        }
        
        if(self.schoolData.email.length > 0)
        {
            [self.emailButton setTitle:[NSString stringWithFormat:@"Email: %@", self.schoolData.email] forState:UIControlStateNormal];
        }
        else
        {
            self.emailButton.enabled = NO;
        }
        
        if(self.schoolData.website.length > 0)
        {
            [self.websiteButton setTitle:[NSString stringWithFormat:@"Visit: %@", self.schoolData.website] forState:UIControlStateNormal];
        }
        else
        {
            self.websiteButton.enabled = NO;
        }
        
        if(self.schoolData.latitude.length > 0 && self.schoolData.longitude.length > 0)
        {
            self.mapButton.enabled = YES;
        }
        else
        {
            self.mapButton.enabled = NO;
        }
    }
}

- (IBAction)phoneNumberButtonPressed:(UIButton *)sender
{
    NSString* phoneNumber = [self.schoolData.phoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *phoneNumberURL = [@"tel://" stringByAppendingString:phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumberURL] options:@{} completionHandler:nil];
}

- (IBAction)emailButtonPressed:(UIButton *)sender
{
    UIViewController* rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    MFMailComposeViewController *composer = nil;
    
    if ([MFMailComposeViewController canSendMail])
    {
        composer = [[MFMailComposeViewController alloc] init];
        
        [composer setSubject:@""];
        [composer setMessageBody:@"" isHTML:NO];
        
        // Set up recipients
        [composer setToRecipients:@[self.schoolData.email]];
        composer.mailComposeDelegate = self;
        
        // Fill out the email body text
        composer.modalPresentationStyle = UIModalPresentationFormSheet;
        
        [rootViewController presentViewController:composer animated:YES completion:nil];
    }
    else
    {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Error Sending Mail" message:@"There appears to be a problem sending e-mail.  Please ensure there is an e-mail account configured on this device and try again." preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (IBAction)websiteButtonPressed:(UIButton *)sender
{
    NSString* urlString = self.schoolData.website;
    if(![urlString hasPrefix:@"http://"] && ![urlString hasPrefix:@"https://"])
    {
        urlString = [NSString stringWithFormat:@"http://%@", urlString];
    }

    SFSafariViewControllerConfiguration* configuration = [[SFSafariViewControllerConfiguration alloc] init];
    SFSafariViewController *safariVC = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:urlString] configuration:configuration];
    
    safariVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    safariVC.delegate = nil;

    safariVC.modalPresentationStyle = UIModalPresentationCustom;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:safariVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MFMailComposeViewControllerDelegate

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    //message.hidden = NO;
    // Notifies users about errors associated with the interface
    //    UIViewController* rootViewController = (UIViewController*)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    switch (result)
    {
        case MFMailComposeResultCancelled:
            if(error != nil)
            {
                UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Error Sending Mail" message:[NSString stringWithFormat:@"There appears to be a problem sending e-mail.  Please ensure there is an e-mail account configured on this device and try again.\n\n%@", error.localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            //message.text = @"Result: canceled";
            break;
        case MFMailComposeResultSaved:
            //message.text = @"Result: saved";
            break;
        case MFMailComposeResultSent:
            //message.text = @"Result: sent";
            break;
        case MFMailComposeResultFailed:
            //message.text = @"Result: failed";
            break;
        default:
            //message.text = @"Result: not sent";
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if([segue.identifier isEqualToString:@"mapSegue"])
    {
        UINavigationController* navCtrl = segue.destinationViewController;;
        MapViewController* mapVC = (MapViewController*)navCtrl.topViewController;
        mapVC.name = self.schoolData.schoolName;
        mapVC.longitude = self.schoolData.longitude;
        mapVC.lattitude = self.schoolData.latitude;
    }
}


@end
