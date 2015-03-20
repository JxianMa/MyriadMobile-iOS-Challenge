//
//  KingdomListTableViewController.m
//  MyriadMobileTest
//
//  Created by MaJixian on 3/16/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import "KingdomListTableViewController.h"
#import "KingdomListTableViewCell.h"
#import "KingdomDetailViewController.h"
#import "KingdomInfo.h"
#import "AppDelegate.h"
#import "UserInfo.h"

@interface KingdomListTableViewController ()<UIAlertViewDelegate>
@property (nonatomic,strong) NSArray *kingdomInfos;
@property (nonatomic,strong) KingdomDetailViewController *segueDestVC;
@end

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
@implementation KingdomListTableViewController



#pragma mark load view
// Load the main UI, basically the navigation bar and contents on the bar, tableviewcell has already be custmized in KingdomListTableCell, when handling the UITableviewDelegate, just need to create a instance of KingdomListTableCell
- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationbarLoad];
    [self refreshControllerLoad];
    self.tableView.rowHeight = 70.0f;
    [self reloadKingdomData];
}

// Data fetch, call the method of data construction from KingdomInfo model, private array self.kingdomInfos actually stores a set of instances of KingdomInfo model, all the data manipulation was finished in KingdomInfo model
- (void)reloadKingdomData
{
    [KingdomInfo getKingdomInfoWithBlock:^(NSArray *responseArray, NSError *error) {
        if (!error) {
            self.kingdomInfos = responseArray;
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
            // NSLog(@"kingdomInfo:%@",self.kingdomInfos);
        }
        else
        {
            UIAlertView *checkConnectionAlertView = [[UIAlertView alloc]initWithTitle:@"Connection problem" message:@"Something wrong with the connection, please retry later" delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil, nil];
            [checkConnectionAlertView show];
            [self.refreshControl endRefreshing];
        }
    }];
}

// Add the function of draging to refresh, improve user experience
- (void)refreshControllerLoad
{
    self.refreshControl = [[UIRefreshControl alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 100.0f)];
    [self.refreshControl addTarget:self action:@selector(reloadKingdomData) forControlEvents:UIControlEventValueChanged];
    [self.tableView.tableHeaderView addSubview:self.refreshControl];
}

// Setup the navigation bar style, including the log out button and action when log out button is touched
- (void)navigationbarLoad
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self.navigationController.navigationBar setBarTintColor:Rgb2UIColor(26, 179, 189)];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIBarButtonItem *logoutBtn = [[UIBarButtonItem alloc] initWithTitle:@"Log Out" style:UIBarButtonItemStylePlain target:self action:@selector(logOut)];
    self.navigationItem.rightBarButtonItem = logoutBtn;
}

// Action when log out button touched. Besides push back the login view, what I have done is deleting all the user information from local database. So if the user quit the app right after logging out and reopen it, the user will still login first
- (void)logOut
{
    UIAlertView *logoutAlertView = [[UIAlertView alloc] initWithTitle:@"Log out Alert" message:@"Are you sure you want to log out?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [logoutAlertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
    }
    if (buttonIndex == 1)
    {
        [self deleteUserInfoFromLocalDB];
        [self performSegueWithIdentifier:@"backToLoginSegue" sender:nil];
    }
}

- (void)deleteUserInfoFromLocalDB
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:app.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedItems = [app.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *managedObject in fetchedItems)
    {
        [app.managedObjectContext deleteObject:managedObject];
    }
    if (![app.managedObjectContext save:&error])
    {
        UIAlertView *logOutAlert = [[UIAlertView alloc] initWithTitle:@"Logout Error" message:@"Something wrong...Please retry later" delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil, nil];
        [logOutAlert show];
    }
}


#pragma mark - Table view data source
//Tableview datasource set. Reuse instance of KingdomListTableViewCell to fill the table, slightly modify the style of tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (NSUInteger)[self.kingdomInfos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    KingdomListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[KingdomListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:cellIdentifier];
    cell.kingdomInfo = [self.kingdomInfos objectAtIndex:(NSUInteger)indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
    {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - Navigation
// Respond to cell clicked action, navigate to the detail view
// Kingdom id is required to be passed to KingdomDetail model to complete the URL for fetching kingdom detail
// Kingdom name is required to be passed to KingdomDetailViewController to establish the navigation bar
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDetailSegue"])
    {
        KingdomDetailViewController *dest = [segue destinationViewController];
        self.segueDestVC = dest;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cellSelected = [self.tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"cellSelected:%@",cellSelected.textLabel.text);
    if (indexPath) {
        [self performSegueWithIdentifier:@"showDetailSegue" sender:nil];
        self.segueDestVC.passedKingdomId = [cellSelected.detailTextLabel.text integerValue];
        self.segueDestVC.kingdomDetailViewTitle = cellSelected.textLabel.text;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
