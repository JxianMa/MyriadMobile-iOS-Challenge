//
//  LoginViewController.m
//  MyriadMobileTest
//
//  Created by MaJixian on 3/16/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//


// Login view will show at the first time that user open this app, after the user post valid information, the user will not need to re-login next time he/she open this app. However, if the user has deleted the app and re-install it, he/she may re-login because all data stored in local database will be deleted if the app is deleted
// After the user typed in valid information and touch 'submit' button, information will be stored into local database through coredata, be posted to the URL through AFNetworking framework and finally the list view will be presented
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "UserInfo.h"
#import "AFNetworking.h"
#import "KingdomListTableViewController.h"

// URL for posting user info
static NSString * const POSTURL = @"https://challenge2015.myriadapps.com/api/v1/subscribe";

@interface LoginViewController ()

// User name and email information should be private

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@end

@implementation LoginViewController


#pragma mark View life cycle
// Add a gesture recognizer into view, in order to dismiss keyboard when user touch blank area, hide navigation bar
- (void)viewDidLoad
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

// Method to dismiss keyboard
-(void)dismissKeyboard
{
    [self.nameTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
}

# pragma mark UI element creating
// Submit button listener
- (IBAction)submitBtn:(UIButton *)sender
{
    // Check the information user typed in is valid or not
    // If info is valid, post to the URL, store to local DB, segue to list view through the postHTTPRequest method.
    // If information is not valid, show alertview
    if (self.nameTextField.text.length > 0  && [self NSStringIsValidEmail:self.emailTextField.text])
    {
        [self postHTTPRequest];
    }
    else
    {
        UIAlertView *infoCheckView = [[UIAlertView alloc] initWithTitle:@"Whoops, something is wrong..." message:@"Please type in valid email and name" delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil, nil];
        [infoCheckView show];
    }
}

#pragma mark Functional methods
// This is an open source email address validation method from stackoverflow:http://stackoverflow.com/questions/3139619/check-that-an-email-address-is-valid-on-ios
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

// Post a request to the target URL
// If success, save the valid user info to local database and show list view
// If internet connection problem happens, show alert view
- (void)postHTTPRequest
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *userInfoDic = @{@"name":self.nameTextField.text,@"email":self.emailTextField.text};
    [manager POST:POSTURL parameters:userInfoDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self showLoginSuccessMessage:responseObject];
        [self saveToLocalDB];
        [self performSegueWithIdentifier:@"showListSegue" sender:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *connectionCheckView = [[UIAlertView alloc] initWithTitle:@"Whoops, something is wrong..." message:@"Connection issues happened, please retry later" delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil, nil];
        [connectionCheckView show];
    }];
}

// If success, convert the info that server returns and present to user
- (void)showLoginSuccessMessage:(id)responseObject
{
    NSDictionary *responseDict = [responseObject objectForKey:@"message"];
    NSString *responseString = [NSString stringWithFormat:@"%@",responseDict];
    UIAlertView *connectionCheckView = [[UIAlertView alloc] initWithTitle:@"Login Success!" message:responseString delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil, nil];
    [connectionCheckView show];
}

// Store user info to local database
- (void)saveToLocalDB
{
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    UserInfo *userInfo = [NSEntityDescription insertNewObjectForEntityForName:@"UserInfo" inManagedObjectContext:app.managedObjectContext];
    userInfo.name = self.nameTextField.text;
    userInfo.email = self.emailTextField.text;
    [app saveContext];
}



@end
