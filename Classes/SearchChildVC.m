//
//  SearchChildVC.m
//  VolunTree
//
//  Created by Pradyumn Nukala on 6/13/16.
//  Copyright © 2016 HelpOut. All rights reserved.
//

#import "SearchChildVC.h"
#import "UIColor+TreeColor.h"
@implementation SearchChildVC

- (void)viewDidLoad {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handle_data) name:@"reload_data" object:nil];
    ArrayManager *man = [[ArrayManager sharedInstance] init];
    self.results = [man getGlobalArray];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
}

-(void)handle_data {
    self.results = [ArrayManager sharedInstance].searchResults;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Object Entries: %lu", (unsigned long)[self.results count]);
    return [self.results count];
}

- (void)tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PFObject *data = self.results[indexPath.row];
    if (data[@"fullName"]) {
        // User Cell
        [self resignFirstResponder];
        ForeignProfileVC *fvc = [[ForeignProfileVC alloc] init];
        fvc.object = (PFUser *)data;
        UINavigationController *navFvc = [[UINavigationController alloc] initWithRootViewController:fvc];
        [self.navigationController presentViewController:navFvc animated:YES completion:nil];
    }else{
        // Organization Cell
        [self resignFirstResponder];
        OrganizationViewController *ovc = [[OrganizationViewController alloc] init];
        ovc.object = (PFObject *)data;
        UINavigationController *navOvc = [[UINavigationController alloc] initWithRootViewController:ovc];
        [self.navigationController presentViewController:navOvc animated:YES completion:nil];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *data = self.results[indexPath.row];
    if (data[@"fullName"]) {
        static NSString *MyIdentifier = @"MySIdentifier";
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
#pragma mark - Line
        UIImageView *profileCellLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profileCellLine"]];
        [profileCellLine setTranslatesAutoresizingMaskIntoConstraints:NO];
        [cell.contentView addSubview:profileCellLine];
        
        [profileCellLine autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [profileCellLine autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [profileCellLine autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
#pragma mark - Profile Pic
        PFFile *thumbnail = [data objectForKey:@"profilePicture"];
        NSData *imageData = [thumbnail getData];
        UIImage *image = [UIImage imageWithData:imageData];
        UIImageView *profilePic = [[UIImageView alloc] init];
        if (imageData == nil) {
            profilePic.image = [UIImage imageNamed:@"profilePic"];
        }else {
            profilePic.image = image;
            profilePic.layer.cornerRadius = 20;
            profilePic.clipsToBounds = YES;
        }
        [profilePic setTranslatesAutoresizingMaskIntoConstraints:NO];
        [cell.contentView addSubview:profilePic];
        
        [profilePic autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5.0];
        [profilePic autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:7.0];
        [profilePic autoSetDimension:ALDimensionHeight toSize:40];
        [profilePic autoSetDimension:ALDimensionWidth toSize:40];
        
#pragma mark - Title Label
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
        
        [titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:65];
        [titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:7.0];
        
#pragma mark - Username Label
        UILabel *hoursLabel = [[UILabel alloc] init];
        [hoursLabel setNeedsDisplay];
        [hoursLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        hoursLabel.backgroundColor = [UIColor clearColor];
        hoursLabel.textColor = [UIColor colorWithRed:0.620 green:0.639 blue:0.659 alpha:1];
        hoursLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:12.0];
        hoursLabel.textAlignment = NSTextAlignmentCenter;
        hoursLabel.text = [data objectForKey:@"username"];
        [hoursLabel setNeedsDisplay];
        [cell.contentView addSubview:hoursLabel];
        
        [hoursLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:titleLabel withOffset:0];
        [hoursLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:titleLabel withOffset:1];
        
        
        NSLog(@"objectId: %@",data.objectId);
        return cell;
    }else{
        static NSString *MyIdentifier = @"MySecondIdentifier";
        
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
#pragma mark - Line
        UIImageView *profileCellLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profileCellLine"]];
        [profileCellLine setTranslatesAutoresizingMaskIntoConstraints:NO];
        [cell.contentView addSubview:profileCellLine];
        
        [profileCellLine autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [profileCellLine autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [profileCellLine autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
#pragma mark - Profile Pic
        PFFile *thumbnail = [data objectForKey:@"image"];
        NSData *imageData = [thumbnail getData];
        UIImage *image = [UIImage imageWithData:imageData];
        UIImageView *profilePic = [[UIImageView alloc] init];
        if (imageData == nil) {
            profilePic.image = [UIImage imageNamed:@"profilePic"];
        }else {
            profilePic.image = image;
            profilePic.layer.cornerRadius = 18.0;
            profilePic.clipsToBounds = YES;
        }
        [profilePic setTranslatesAutoresizingMaskIntoConstraints:NO];
        [cell.contentView addSubview:profilePic];
        
        [profilePic autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5.0];
        [profilePic autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:7.0];
        [profilePic autoSetDimension:ALDimensionHeight toSize:40];
        [profilePic autoSetDimension:ALDimensionWidth toSize:40];
        
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
        
        [titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:65];
        [titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:7.0];
        
#pragma mark - Username Label
        UILabel *hoursLabel = [[UILabel alloc] init];
        [hoursLabel setNeedsDisplay];
        [hoursLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        hoursLabel.backgroundColor = [UIColor clearColor];
        hoursLabel.textColor = [UIColor colorWithRed:0.620 green:0.639 blue:0.659 alpha:1];
        hoursLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:12.0];
        hoursLabel.textAlignment = NSTextAlignmentCenter;
        hoursLabel.text = [data objectForKey:@"description"];
        [hoursLabel setNeedsDisplay];
        [cell.contentView addSubview:hoursLabel];
        
        [hoursLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:titleLabel withOffset:0];
        [hoursLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:titleLabel withOffset:1];
        
        NSLog(@"objectId: %@",data.objectId);
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52.5;
}

- (UIViewController *)currentTopViewController
{
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topVC.presentedViewController)
    {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

@end
