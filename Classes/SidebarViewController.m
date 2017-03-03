//
//  SidebarViewController.m
//  VolunTree
//
//  Created by Pradyumn Nukala on 12/15/15.
//  Copyright © 2015 HelpOut. All rights reserved.
//

#import "SidebarViewController.h"
#import <Parse/Parse.h>
#import "Data.h"

@interface SidebarViewController ()

@end

@implementation SidebarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchData];
    self.view.backgroundColor = [UIColor colorWithRed:0.086 green:0.098 blue:0.118 alpha:1];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    // Setup image
    PFFile *thumbnail = [[PFUser currentUser] objectForKey:@"profilePicture"];
    NSData *imageData = [thumbnail getData];
    UIImage *image = [UIImage imageWithData:imageData];
    
    UIImageView *profilePic = [[UIImageView alloc] initWithFrame:CGRectMake(95, 20, 35, 35)];
    if (imageData == nil) {
        profilePic.image = [UIImage imageNamed:@"profilePicture"];
    }else{
        profilePic.image = image;
    }
    profilePic.layer.cornerRadius=18;
    profilePic.clipsToBounds = YES;
    [self.view addSubview:profilePic];
    
    // Setup name label
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 10, 300, 40)];
    nameLabel.text = [[PFUser currentUser] objectForKey:@"fullName"];
    nameLabel.textColor = [UIColor colorWithRed:0.984 green:0.987 blue:0.992 alpha:1];
    nameLabel.font = [UIFont fontWithName:@"OpenSans" size:18.111];
    [self.view addSubview:nameLabel];
    
    // Setup username label
    UILabel *username = [[UILabel alloc] initWithFrame:CGRectMake(140, 28, 300, 40)];
    username.textColor = [UIColor colorWithRed:0.984 green:0.987 blue:0.992 alpha:1];
    username.font = [UIFont fontWithName:@"OpenSans-Light" size:12.451];
    username.text = [[PFUser currentUser] username];
    [self.view addSubview:username];
    
    // Setup search button
    UIButton *searchButton = [[UIButton alloc] init];
    [searchButton setTitle:@"" forState:UIControlStateNormal];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"searchTabIcon"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(didTapSearchButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchButton];
    
    [searchButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:15];
    [searchButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:((self.view.frame.size.width)/4)+15];
    [searchButton autoSetDimension:ALDimensionWidth toSize:20];
    [searchButton autoSetDimension:ALDimensionHeight toSize:20];
    
    // Setup plus label
    UIButton *plusButton = [[UIButton alloc] init];
    [plusButton setTitle:@"" forState:UIControlStateNormal];
    [plusButton setBackgroundImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    [plusButton addTarget:self action:@selector(didTapPlusButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:plusButton];
    
    [plusButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:15];
    [plusButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
    [plusButton autoSetDimension:ALDimensionWidth toSize:20];
    [plusButton autoSetDimension:ALDimensionHeight toSize:20];
    
    // Setup table
    self.tableView = [[UITableView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:64];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.tableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:searchButton withOffset:-15];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:(self.view.frame.size.width)/4];
}

- (void)didTapSearchButton:(id)sender {
    //[self sendEmail];
    FindOrganizationViewController *set = [[FindOrganizationViewController alloc] init];
    UINavigationController *navSet = [[UINavigationController alloc] initWithRootViewController:set];
    [self presentViewController:navSet animated:YES completion:nil];
}

- (void)didTapPlusButton:(id)sender {
    CreateOrganizationViewController *org = [[CreateOrganizationViewController alloc] init];
    UINavigationController *navOrg = [[UINavigationController alloc] initWithRootViewController:org];
    [self presentViewController:navOrg animated:YES completion:nil];
}

-(void)fetchData{
    PFQuery *query = [PFQuery queryWithClassName:@"Organizations"];
    [query whereKey:@"members" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"Successfully retrieved %lu logs.", (unsigned long)objects.count);
        if (!error) {
            self.organizations = objects;
            [self.tableView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58.5;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.organizations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"ProfileCell";
    ProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil)
    {
        cell = [[ProfileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:MyIdentifier];
        
    }
    for(UIView *view in cell.contentView.subviews){
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
        }
    }
    PFObject *data = self.organizations[indexPath.row];
#pragma mark - Line
    UIImageView *profileCellLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profileCellLine"]];
    [profileCellLine setTranslatesAutoresizingMaskIntoConstraints:NO];
    [cell.contentView addSubview:profileCellLine];
    
    [profileCellLine autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [profileCellLine autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [profileCellLine autoPinEdgeToSuperviewEdge:ALEdgeRight];
    
#pragma mark - Arrow Button
    UIButton *arrowRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [arrowRight setTranslatesAutoresizingMaskIntoConstraints:NO];
    [arrowRight setBackgroundImage:[UIImage imageNamed:@"arrowRight"] forState:UIControlStateNormal];
    [cell.contentView addSubview:arrowRight];
    
    [arrowRight autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0];
    [arrowRight autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:21.25];
    
#pragma mark - Profile Pic
    PFFile *thumbnail = [data objectForKey:@"image"];
    NSData *imageData = [thumbnail getData];
    UIImage *image = [UIImage imageWithData:imageData];
    
    UIImageView *profilePic = [[UIImageView alloc] init];
    if (imageData == nil) {
        profilePic.image = [UIImage imageNamed:@"profilePic"];
    }else{
        profilePic.image = image;
        profilePic.layer.cornerRadius = 23.0;
        profilePic.clipsToBounds = YES;
    }
    
    [profilePic setTranslatesAutoresizingMaskIntoConstraints:NO];
    [cell.contentView addSubview:profilePic];
    
    [profilePic autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:8.0];
    [profilePic autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:7.0];
    [profilePic autoSetDimension:ALDimensionHeight toSize:48];
    [profilePic autoSetDimension:ALDimensionWidth toSize:47];
    
#pragma mark - Title Label
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setNeedsDisplay];
    [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor treeColor];
    titleLabel.font = [UIFont fontWithName:@"OpenSans" size:14.185];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = [data objectForKey:@"Name"];
    [titleLabel setNeedsDisplay];
    [cell.contentView addSubview:titleLabel];
    
    [titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:70.0];
    [titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:13.0];
    
    
#pragma mark - Members Icon
    UIImageView *locationIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"members"]];
    [locationIcon setTranslatesAutoresizingMaskIntoConstraints:NO];
    [cell.contentView addSubview:locationIcon];
    
    [locationIcon autoSetDimension:ALDimensionWidth toSize:14];
    [locationIcon autoSetDimension:ALDimensionHeight toSize:10];
    [locationIcon autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:70.0];
    [locationIcon autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:titleLabel withOffset:2];
    
#pragma mark - Members Label
    PFRelation *relation = [data relationForKey:@"members"];
    [[relation query] countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        NSLog(@"int %d", number);
        NSString *inStr = [NSString stringWithFormat: @"%d", number];
        UILabel *locationLabel = [[UILabel alloc] init];
        [locationLabel setNeedsDisplay];
        [locationLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        locationLabel.backgroundColor = [UIColor clearColor];
        locationLabel.textColor = [UIColor colorWithRed:0.643 green:0.655 blue:0.667 alpha:1];
        locationLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:8.881];
        locationLabel.textAlignment = NSTextAlignmentCenter;
        locationLabel.text = [NSString stringWithFormat:@"%@ Member(s)", inStr];
        [locationLabel setNeedsDisplay];
        [cell.contentView addSubview:locationLabel];
        
        [locationLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:locationIcon withOffset:0];
        [locationLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:locationIcon withOffset:3];

    }];
    
    return cell;
}

- (void)refresh:(UIRefreshControl*)sender{
    [self fetchData];
    [sender endRefreshing];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OrganizationSettingsViewController *set = [[OrganizationSettingsViewController alloc] init];
    set.organization = (PFObject*)[self.organizations objectAtIndex:indexPath.row];
    OrganizationViewController *destViewController = [[OrganizationViewController alloc] init];
    destViewController.object = (PFObject*)[self.organizations objectAtIndex:indexPath.row];
    UINavigationController *navOrg = [[UINavigationController alloc] initWithRootViewController:destViewController];
    JASidePanelController *masterController = [[JASidePanelController alloc] init];
    masterController.centerPanel = navOrg;
    masterController.rightPanel = set;
    [self presentViewController:masterController animated:YES completion:nil];
}

@end
