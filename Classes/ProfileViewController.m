//
//  ProfileViewController.m
//  VolunTree
//
//  Created by Pradyumn Nukala on 12/4/15.
//  Copyright © 2015 HelpOut. All rights reserved.
//

#import "ProfileViewController.h"
#import "Data.h"

@interface ProfileViewController ()
@end

@implementation ProfileViewController
- (void)viewWillAppear:(BOOL)animated {
    [self viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.tableView reloadData];
    if (![PFUser currentUser]) {
        LoginViewController *login = [[LoginViewController alloc] init];
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:login];
        [self.navigationController presentViewController:loginNav animated:YES completion:NULL];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView reloadData];
    [self setUpUI];
    [self getData];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    ProfileHeaderView *header = [[ProfileHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 222)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.parallaxHeader.view = header;
    self.tableView.parallaxHeader.height = 222;
    self.tableView.parallaxHeader.minimumHeight = 5;
}

- (void)setUpUI{
    [self.navigationItem setTitle:@"Profile"];
    
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [barButton setTitle:@"" forState:UIControlStateNormal];
    [barButton setBackgroundImage:[UIImage imageNamed:@"gearIcon"] forState:UIControlStateNormal];
    [barButton addTarget:self action:@selector(didTapGearButton:) forControlEvents:UIControlEventTouchUpInside];
    barButton.frame = CGRectMake(0.0f, 0.0f, 15.0f, 15.0f);
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [postButton setTitle:@"" forState:UIControlStateNormal];
    [postButton setBackgroundImage:[UIImage imageNamed:@"sidebarIcon"] forState:UIControlStateNormal];
    [postButton addTarget:self action:@selector(didTapPostButton:) forControlEvents:UIControlEventTouchUpInside];
    postButton.frame = CGRectMake(0.0f, 0.0f, 15.0f, 15.0f);
    UIBarButtonItem *postButtonItem = [[UIBarButtonItem alloc] initWithCustomView:postButton];
    
    self.navigationItem.rightBarButtonItem = postButtonItem;
}

- (void)didTapGearButton:(id)sender {
    SettingsViewController *set = [[SettingsViewController alloc] init];
    UINavigationController *navSet = [[UINavigationController alloc] initWithRootViewController:set];
    [self presentViewController:navSet animated:YES completion:nil];
}

- (void)didTapPostButton:(id)sender {
    [self.sidePanelController showRightPanelAnimated:YES];
}

- (void)getData {
    if([PFUser currentUser]){
        PFQuery *query = [PFQuery queryWithClassName:@"VolunteerSheet"];
        [query whereKey:@"toUser" equalTo:[PFUser currentUser]];
        [query orderByDescending:@"updatedAt"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            NSLog(@"Successfully retrieved %lu logs.", (unsigned long)objects.count);
            if (!error) {
                self.objects = objects;
                [self.tableView reloadData];
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.objects count];
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
    NSDictionary *data = self.objects[indexPath.row];
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
    PFUser *fromUser = [data objectForKey:@"fromUser"];
    [fromUser fetchIfNeeded];
    PFFile *thumbnail = [fromUser objectForKey:@"profilePicture"];
    NSData *imageData = [thumbnail getData];
    UIImage *image = [UIImage imageWithData:imageData];
    UIImageView *profilePic = [[UIImageView alloc] init];
    if (imageData == nil) {
        profilePic.image = [UIImage imageNamed:@"profilePic"];
    }else {
        profilePic.image = image;
        profilePic.layer.cornerRadius = 23.0;
        profilePic.clipsToBounds = YES;
    }
    [profilePic setTranslatesAutoresizingMaskIntoConstraints:NO];
    [cell.contentView addSubview:profilePic];
    
    [profilePic autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5.0];
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
    titleLabel.text = [data objectForKey:@"volunteerTitle"];
    [titleLabel setNeedsDisplay];
    [cell.contentView addSubview:titleLabel];
    
    [titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:70.0];
    [titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:13.0];
    
#pragma mark - Clock Icon
    UIImageView *clockIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clockIcon"]];
    [clockIcon setTranslatesAutoresizingMaskIntoConstraints:NO];
    [cell.contentView addSubview:clockIcon];
    
    [clockIcon autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:70.0];
    [clockIcon autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:titleLabel withOffset:2];
    
#pragma mark - Hours Label
    UILabel *hoursLabel = [[UILabel alloc] init];
    [hoursLabel setNeedsDisplay];
    [hoursLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    hoursLabel.backgroundColor = [UIColor clearColor];
    hoursLabel.textColor = [UIColor colorWithRed:0.620 green:0.639 blue:0.659 alpha:1];
    hoursLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:8.881];
    hoursLabel.textAlignment = NSTextAlignmentCenter;
    hoursLabel.text = [[data objectForKey:@"volunteerHours"] stringValue];
    [hoursLabel setNeedsDisplay];
    [cell.contentView addSubview:hoursLabel];
    
    [hoursLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:clockIcon withOffset:0];
    [hoursLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:clockIcon withOffset:3];
    
#pragma mark - Location Icon
    UIImageView *locationIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"locationIcon"]];
    [locationIcon setTranslatesAutoresizingMaskIntoConstraints:NO];
    [cell.contentView addSubview:locationIcon];
    
    [locationIcon autoAlignAxis:ALAxisHorizontal toSameAxisOfView:hoursLabel withOffset:0];
    [locationIcon autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:hoursLabel withOffset:20];
    
#pragma mark - Location Label
    UILabel *locationLabel = [[UILabel alloc] init];
    [locationLabel setNeedsDisplay];
    [locationLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    locationLabel.backgroundColor = [UIColor clearColor];
    locationLabel.textColor = [UIColor colorWithRed:0.643 green:0.655 blue:0.667 alpha:1];
    locationLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:8.881];
    locationLabel.textAlignment = NSTextAlignmentCenter;
    locationLabel.text = [data objectForKey:@"location"];
    [locationLabel setNeedsDisplay];
    [cell.contentView addSubview:locationLabel];
    
    [locationLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:locationIcon withOffset:0];
    [locationLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:locationIcon withOffset:3];
    
    return cell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VolunteerSheetViewController *destViewController = [[VolunteerSheetViewController alloc] init];
    destViewController.object = [self.objects objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:destViewController animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58.5;
}

- (void)refresh:(UIRefreshControl*)sender{
    [self getData];
    [sender endRefreshing];
}
@end
