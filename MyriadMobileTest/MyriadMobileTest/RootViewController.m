//
//  RootViewController.m
//  MyriadMobileTest
//
//  Created by MaJixian on 3/16/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

//  Set this view as the initial viewController for the sake of checking the users' login status, if the user has already logged in, the kindomListTableView will show up. If this is the first time that a user open my app, the login view will appear.
//  The way to judge whether user has already loggin or not is to check the number of objects stored in the local database.

#import "RootViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "KingdomListTableViewController.h"

@interface RootViewController ()


@end

@implementation RootViewController

// Program lifecycle, viewDidLoad will only excute once after the app has launched, viewDidAppear excutes every time after the RootViewController shown. Check the login status in this method, so that the RootViewController will decide which view to show, LoginView or KingdomListTableView
- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewDidAppear:animated];
    [self checkLoginStatus];
}

// I use CoreData to store user information into local database, in order to check the number of objects that stored in local database, "countForFetchRequest: error:" method is used. Of course, I have to declare the request, the entity that I need to access local database first
// Here this app does not have user information check function. In real app, we need to check user login information from database first, then decide whether user has to re-login or not.
- (void)checkLoginStatus
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:app.managedObjectContext];
    [request setEntity:entity];
    NSError *error = nil;
    NSUInteger count = [app.managedObjectContext countForFetchRequest:request error:&error];
// According to the number of objects stored in local database, we can decide which view to show. If no record, which means this might be the first time that user open the app, user needs to login. If there're some records in base, this may not be the first time user open this app, so directly show the list view
    if (count == NSNotFound) {
        NSLog(@"Error: %@", error);
    }
    else if (count == 0)
    {
        [self performSegueWithIdentifier:@"loginSegue" sender:nil];
    }
    else if (count != 0)
    {
        [self performSegueWithIdentifier:@"tableListSegue" sender:nil];
    }
}

@end
