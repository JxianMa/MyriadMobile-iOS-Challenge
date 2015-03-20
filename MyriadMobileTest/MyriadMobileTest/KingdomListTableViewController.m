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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationbarLoad];
    [self refreshControllerLoad];
    self.tableView.rowHeight = 70.0f;
    [self reloadKingdomData];
}

- (void)refreshControllerLoad
{
    self.refreshControl = [[UIRefreshControl alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 100.0f)];
    [self.refreshControl addTarget:self action:@selector(reloadKingdomData) forControlEvents:UIControlEventValueChanged];
    [self.tableView.tableHeaderView addSubview:self.refreshControl];
}

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

- (void)logOut
{
    UIAlertView *logoutAlertView = [[UIAlertView alloc] initWithTitle:@"Log out Alert" message:@"Are you sure you want log out?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
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
    for (NSManagedObject *managedObject in fetchedItems) {
        [app.managedObjectContext deleteObject:managedObject];
    }
    if (![app.managedObjectContext save:&error]) {
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return (NSUInteger)[self.kingdomInfos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"Cell";
    KingdomListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[KingdomListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:cellIdentifier];
    cell.kingdomInfo = [self.kingdomInfos objectAtIndex:(NSUInteger)indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - Navigation
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
