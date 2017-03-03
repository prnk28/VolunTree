//
//  OrganizationSettingsViewController.m
//  VolunTree
//
//  Created by Pradyumn Nukala on 1/18/16.
//  Copyright © 2016 HelpOut. All rights reserved.
//

#import "OrganizationSettingsViewController.h"
#import "Data.h"

@implementation OrganizationSettingsViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self fetchData];
    self.view.backgroundColor = [UIColor colorWithRed:0.086 green:0.098 blue:0.118 alpha:1];
    
    // Setup table
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(90, 64, 285, 553.5)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:64];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:(self.view.frame.size.width)/4];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    [self setupUI];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.members.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"ProfileCell";
    PFUser *data = self.members[indexPath.row];
    AFMSlidingCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil)
    {
        cell = [[AFMSlidingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor treeColor]];
        [button setImage:[UIImage imageNamed:@"role"] forState:UIControlStateNormal];
        button.imageView.frame = CGRectMake(0, 0, 15, 15);
        PFQuery *q = [PFQuery queryWithClassName:@"Admins"];
        [q whereKey:@"user" equalTo:[PFUser currentUser]];
        [q whereKey:@"organization" equalTo:self.organization];
        [q getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if (object) {
                [cell addFirstButton:button withWidth:42.0 withTappedBlock:^(AFMSlidingCell *cell) {
                    NSArray *items = @[MMItemMake(@"Make Admin", MMItemTypeNormal, ^(NSInteger index) {
                        PFObject *obj = [PFObject objectWithClassName:@"Admins"];
                        obj[@"user"] = data;
                        NSLog(@"organization %@",self.organization.objectId);
                        obj[@"organization"] = self.organization;
                        [obj saveInBackground];
                    }), MMItemMake(@"Close", MMItemTypeHighlight, ^(NSInteger index) {
                        
                    })];
                    [[[MMAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@", data[@"fullName"]]
                                                 detail:@"What do you want to do?"
                                                  items:items] show];
                }];
                
                UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
                [button2 setBackgroundColor:[UIColor redColor]];
                [button2 setImage:[UIImage imageNamed:@"remove"] forState:UIControlStateNormal];
                button2.imageView.frame = CGRectMake(0, 0, 15, 15);
                [cell addSecondButton:button2 withWidth:42.0 withTappedBlock:^(AFMSlidingCell *cell) {
                    NSArray *items = @[MMItemMake(@"Yes", MMItemTypeNormal, ^(NSInteger index) {
                        PFRelation *relation = [self.organization relationForKey:@"members"];
                        [relation removeObject:[PFUser currentUser]];

                    }), MMItemMake(@"Cancel", MMItemTypeHighlight, ^(NSInteger index) {
                        
                    })];
                    [[[MMAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@", self.organization[@"Name"]]
                                                 detail:@"Are you sure you want to leave this group?"
                                                  items:items] show];
                    
                }];
            }else{
                UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
                [button2 setBackgroundColor:[UIColor redColor]];
                [button2 setImage:[UIImage imageNamed:@"remove"] forState:UIControlStateNormal];
                button2.imageView.frame = CGRectMake(0, 0, 15, 15);
                [cell addFirstButton:button2 withWidth:42.0 withTappedBlock:^(AFMSlidingCell *cell) {
                    NSArray *items = @[MMItemMake(@"Yes", MMItemTypeNormal, ^(NSInteger index) {
                        // Leave Org
                        PFRelation *relation = [self.organization relationForKey:@"members"];
                        [relation removeObject:[PFUser currentUser]];
                        [self.tableView reloadData];
                    }), MMItemMake(@"Cancel", MMItemTypeHighlight, ^(NSInteger index) {
                        
                    })];
                    [[[MMAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@", self.organization[@"Name"]]
                                                 detail:@"Are you sure you want to leave this group?"
                                                  items:items] show];
                    
                }];
            }
        }];
        [cell addFirstButton:button withWidth:42.0 withTappedBlock:^(AFMSlidingCell *cell) {
            NSArray *items = @[MMItemMake(@"Make Admin", MMItemTypeNormal, ^(NSInteger index) {
                
                PFObject *obj = [PFObject objectWithClassName:@"Admins"];
                obj[@"user"] = data;
                NSLog(@"organization %@",self.organization.objectId);
                obj[@"organization"] = self.organization;
                [obj saveInBackground];
            }), MMItemMake(@"Close", MMItemTypeHighlight, ^(NSInteger index) {
                
            })];
            [[[MMAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@", data[@"fullName"]]
                                         detail:@"What do you want to do?"
                                          items:items] show];
        }];
        
        [cell hideButtonViewAnimated:YES];
        
#pragma mark - Line
        UIImageView *profileCellLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profileCellLine"]];
        [profileCellLine setTranslatesAutoresizingMaskIntoConstraints:NO];
        [cell.contentView addSubview:profileCellLine];
        
        [profileCellLine autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [profileCellLine autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [profileCellLine autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
#pragma mark - Profile Pic
        UIButton *profilePic = [[UIButton alloc] init];
        PFFile *thumbnail = [data objectForKey:@"profilePicture"];
        NSData *imageData = [thumbnail getData];
        UIImage *image = [UIImage imageWithData:imageData];
        
        if (imageData == nil) {
            [profilePic setImage:[UIImage imageNamed:@"profilePic"]
                        forState:UIControlStateNormal];
        }else{
            [profilePic setImage:image forState:UIControlStateNormal];
            profilePic.layer.cornerRadius = 15;
            profilePic.clipsToBounds = YES;
        }
        
        [profilePic setTranslatesAutoresizingMaskIntoConstraints:NO];
        [cell.contentView addSubview:profilePic];
        
        [profilePic autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:12.0];
        [profilePic autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:7.0];
        [profilePic autoSetDimension:ALDimensionHeight toSize:31];
        [profilePic autoSetDimension:ALDimensionWidth toSize:30];
        
#pragma mark - Name Label
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setNeedsDisplay];
        [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor treeColor];
        titleLabel.font = [UIFont fontWithName:@"OpenSans" size:14.185];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = [data objectForKey:@"fullName"];
        [titleLabel setNeedsDisplay];
        [cell.contentView addSubview:titleLabel];
        
        [titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:6.5];
        [titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:profilePic withOffset:8];
        
#pragma mark - Username Label
        UILabel *hoursLabel = [[UILabel alloc] init];
        [hoursLabel setNeedsDisplay];
        [hoursLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        hoursLabel.backgroundColor = [UIColor clearColor];
        hoursLabel.textColor = [UIColor colorWithRed:0.620 green:0.639 blue:0.659 alpha:1];
        hoursLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:12];
        hoursLabel.textAlignment = NSTextAlignmentLeft;
        hoursLabel.lineBreakMode = NSLineBreakByWordWrapping;
        hoursLabel.numberOfLines = 0;
        hoursLabel.adjustsFontSizeToFitWidth = NO;
        PFQuery *qe = [PFQuery queryWithClassName:@"Admins"];
        [qe whereKey:@"user" equalTo:data];
        [qe whereKey:@"organization" equalTo:self.organization];
        [qe getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if (object) {
        hoursLabel.text = [NSString stringWithFormat:@"%@ • Admin",[data objectForKey:@"username"]];
            } else {
        hoursLabel.text = [NSString stringWithFormat:@"%@",[data objectForKey:@"username"]];        
            }
        }];
                [hoursLabel setNeedsDisplay];
        [cell.contentView addSubview:hoursLabel];
        
        [hoursLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:titleLabel withOffset:0];
        [hoursLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:titleLabel withOffset:0.5];
        [hoursLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    }
    return cell;
}

- (void)refresh:(UIRefreshControl*)sender{
    [sender endRefreshing];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ForeignProfileVC *fvc = [[ForeignProfileVC alloc] init];
    fvc.object = (PFUser *)self.organization;
    UINavigationController *navFvc = [[UINavigationController alloc] initWithRootViewController:fvc];
    [self.navigationController presentViewController:navFvc animated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)fetchData {
    PFQuery *query = [PFQuery queryWithClassName:@"Organizations"];
    [query whereKey:@"Name" equalTo:self.organization[@"Name"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                PFRelation *relation = [object relationForKey:@"members"];
                PFQuery *quer = [relation query];
                [quer findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    self.members = objects;
                    [self.tableView reloadData];
                }];
                
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void)setupUI {
    
}

@end
