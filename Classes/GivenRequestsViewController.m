//
//  GivenRequestsViewController.m
//  VolunTree
//
//  Created by Pradyumn Nukala on 7/25/16.
//  Copyright © 2016 HelpOut. All rights reserved.
//
#import "Data.h"
#import "GivenRequestsViewController.h"

@interface GivenRequestsViewController ()

@end

@implementation GivenRequestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveInBackground];
    }
    [self fetchData];
    [self setUpUI];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setUpUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationItem setTitle:@"Hour(s) Requests"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"OpenSans-Semibold" size:18]}];
    
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [barButton setTitle:@"" forState:UIControlStateNormal];
    [barButton setBackgroundImage:[UIImage imageNamed:@"closeIcon"] forState:UIControlStateNormal];
    [barButton addTarget:self action:@selector(didTapClose:) forControlEvents:UIControlEventTouchUpInside];
    barButton.frame = CGRectMake(0.0f, 0.0f, 15.0f, 15.0f);
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)didTapClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
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
    PFObject *data = self.objects[indexPath.row];
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
    PFUser *from = [data objectForKey:@"fromUser"];
    [from fetchIfNeeded];
    PFFile *thumbnail = [from objectForKey:@"profilePicture"];
    NSData *imageData = [thumbnail getData];
    UIImage *image = [UIImage imageWithData:imageData];
    
    UIImageView *profilePic = [[UIImageView alloc] init];
    if (imageData == nil) {
        profilePic.image = [UIImage imageNamed:@"profilePicture"];
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
    titleLabel.text = [data objectForKey:@"title"];
    [titleLabel setNeedsDisplay];
    [cell.contentView addSubview:titleLabel];
    
    [titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:70.0];
    [titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:13.0];
    
    return cell;
}

-(void)fetchData{
    PFQuery *query = [PFQuery queryWithClassName:@"RequestHours"];
    [query whereKey:@"toUser" equalTo:[PFUser currentUser]];
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

- (void)refresh:(UIRefreshControl*)sender{
    [self fetchData];
    [sender endRefreshing];
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    PFObject *data = self.objects[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProvideViewController *pvc = [[ProvideViewController alloc] init];
    pvc.object = data;
    UINavigationController *navOvc = [[UINavigationController alloc] initWithRootViewController:pvc];
    [self.navigationController presentViewController:navOvc animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58.5;
}

@end
