//
//  ViewController.m
//  HelpOut
//
//  Created by Pradyumn Nukala on 8/28/15.
//  Copyright (c) 2015 HelpOut. All rights reserved.
//
#import <Parse/Parse.h>
#import "HomeViewController.h"
#import "Data.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchData];
    [self setUpUI];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    self.tableView.separatorStyle = nil;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationItem.rightBarButtonItem setAction:@selector(didTapBarButton:)];
}

- (void)viewDidAppear:(BOOL)animated {
    if (![PFUser currentUser]) {
        LoginViewController *login = [[LoginViewController alloc] init];
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:login];
        [self.navigationController presentViewController:loginNav animated:YES completion:NULL];
    }else{
        [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:@"user"];
        [[PFInstallation currentInstallation] saveInBackground];
    }
}

- (void)setUpUI{
    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [postButton setTitle:@"" forState:UIControlStateNormal];
    [postButton setBackgroundImage:[UIImage imageNamed:@"sidebarIcon"] forState:UIControlStateNormal];
    [postButton addTarget:self action:@selector(didTapBarButton:) forControlEvents:UIControlEventTouchUpInside];
    postButton.frame = CGRectMake(0.0f, 0.0f, 15.0f, 15.0f);
    UIBarButtonItem *postButtonItem = [[UIBarButtonItem alloc] initWithCustomView:postButton];
    self.navigationItem.rightBarButtonItem = postButtonItem;
    
    UIImage *image = [UIImage imageNamed:@"textLogo"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
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
    PFObject *data = self.objects[indexPath.row];
    NSLog(@"Data: %@", data);
    
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
    
    // Pull date from data
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    NSData *dat = data.createdAt;
    NSString *dateString = [dateFormatter stringFromDate:dat];
    NSDate *date = [dateFormatter dateFromString:dateString];
    
#pragma mark - Line
    UIImageView *profileCellLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profileCellLine"]];
    [profileCellLine setTranslatesAutoresizingMaskIntoConstraints:NO];
    [cell.contentView addSubview:profileCellLine];
    
    [profileCellLine autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [profileCellLine autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [profileCellLine autoPinEdgeToSuperviewEdge:ALEdgeRight];
    
#pragma mark - Vertical Line
    UIImageView *vertCellLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"verticalLine"]];
    [cell.contentView addSubview:vertCellLine];
    
    [vertCellLine autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [vertCellLine autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [vertCellLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:100];
    [vertCellLine autoSetDimension:ALDimensionWidth toSize:1];
    
    
    if (data[@"userLog"]) {
#pragma mark - Profile Pic
        PFUser *toUser = [data objectForKey:@"toUser"];
        [toUser fetchIfNeeded];
        PFFile *thumbnailTo = [toUser objectForKey:@"profilePicture"];
        NSData *imageDataTo = [thumbnailTo getData];
        UIImage *imageTo = [UIImage imageWithData:imageDataTo];
        UIImageView *toProfilePic = [[UIImageView alloc] init];
        if (imageDataTo == nil) {
            toProfilePic.image = [UIImage imageNamed:@"defaultProPic"];
            toProfilePic.layer.cornerRadius = 20;
            toProfilePic.clipsToBounds = YES;
        }else {
            toProfilePic.image = imageTo;
            toProfilePic.layer.cornerRadius = 20;
            toProfilePic.clipsToBounds = YES;
        }
        [toProfilePic setTranslatesAutoresizingMaskIntoConstraints:NO];
        [cell.contentView addSubview:toProfilePic];
        
        [toProfilePic autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:vertCellLine withOffset:5];
        [toProfilePic autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:6];
        [toProfilePic autoSetDimension:ALDimensionHeight toSize:40];
        [toProfilePic autoSetDimension:ALDimensionWidth toSize:40];
        
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
        
        [titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:toProfilePic withOffset:6];
        [titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:6];
        
#pragma mark - Location Icon
        UIImageView *locationIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"locationIcon"]];
        [locationIcon setTranslatesAutoresizingMaskIntoConstraints:NO];
        [cell.contentView addSubview:locationIcon];
        
        [locationIcon autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:toProfilePic withOffset:6];
        [locationIcon autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:titleLabel withOffset:3.5];
        
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
        
#pragma mark - Detail Label
        UILabel *detailLabel = [[UILabel alloc] init];
        [detailLabel setNeedsDisplay];
        [detailLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.textColor = [UIColor colorWithRed:0.620 green:0.639 blue:0.659 alpha:1];
        detailLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:12];
        detailLabel.textAlignment = NSTextAlignmentLeft;
        detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        detailLabel.numberOfLines = 4;
        detailLabel.adjustsFontSizeToFitWidth = NO;
        detailLabel.text = [data objectForKey:@"volunteerDescription"];
        [detailLabel setNeedsDisplay];
        [cell.contentView addSubview:detailLabel];
        
        [detailLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:vertCellLine withOffset:5];
        [detailLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:toProfilePic withOffset:4];
        [detailLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:3];
        
#pragma mark - Time Label
        
        // Extract Time from Date
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        timeFormatter.dateFormat = @"h:mm a";
        NSString *timeString = [timeFormatter stringFromDate:date];
        
        // UI
        UILabel *timeLabel = [[UILabel alloc] init];
        [timeLabel setNeedsDisplay];
        [timeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textColor = [UIColor darkGrayColor];
        timeLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:18];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.text = timeString;
        [timeLabel setNeedsDisplay];
        [cell.contentView addSubview:timeLabel];
        
        [timeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:toProfilePic];
        [timeLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:8];
        
#pragma mark - Date Label
        // Extract Time from Date
        NSDateFormatter *dateF = [[NSDateFormatter alloc] init];
        dateF.dateFormat = @"M/dd/yyyy";
        NSString *dateStr = [dateF stringFromDate:date];
        
        // UI
        UILabel *groupLabel = [[UILabel alloc] init];
        [groupLabel setNeedsDisplay];
        [groupLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        groupLabel.backgroundColor = [UIColor clearColor];
        groupLabel.textColor = [UIColor colorWithRed:0.620 green:0.639 blue:0.659 alpha:1];
        groupLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:8.881];
        groupLabel.textAlignment = NSTextAlignmentCenter;
        groupLabel.text = dateStr;
        [groupLabel setNeedsDisplay];
        [cell.contentView addSubview:groupLabel];
        
        [groupLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:timeLabel withOffset:-3];
        [groupLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:timeLabel];
        
#pragma mark - Clock Icon
        UIImageView *clockIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clockIcon"]];
        [clockIcon setTranslatesAutoresizingMaskIntoConstraints:NO];
        [cell.contentView addSubview:clockIcon];
        
        [clockIcon autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:groupLabel withOffset:5];
        [clockIcon autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:timeLabel];
        
        
#pragma mark - Hours Label
        UILabel *hoursLabel = [[UILabel alloc] init];
        [hoursLabel setNeedsDisplay];
        [hoursLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        hoursLabel.backgroundColor = [UIColor clearColor];
        hoursLabel.textColor = [UIColor colorWithRed:0.620 green:0.639 blue:0.659 alpha:1];
        hoursLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:8.881];
        hoursLabel.textAlignment = NSTextAlignmentCenter;
        hoursLabel.text = [NSString stringWithFormat:@"%@ Hrs",[[data objectForKey:@"volunteerHours"] stringValue]];
        [hoursLabel setNeedsDisplay];
        [cell.contentView addSubview:hoursLabel];
        
        [hoursLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:clockIcon withOffset:0];
        [hoursLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:clockIcon withOffset:3];
    } else {
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
            profilePic.layer.cornerRadius = 17.5;
            profilePic.clipsToBounds = YES;
        }
        [profilePic setTranslatesAutoresizingMaskIntoConstraints:NO];
        [cell.contentView addSubview:profilePic];
        
        [profilePic autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:vertCellLine withOffset:5];
        [profilePic autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:4.0];
        [profilePic autoSetDimension:ALDimensionHeight toSize:35];
        [profilePic autoSetDimension:ALDimensionWidth toSize:35];
        
#pragma mark - Profile Pic
        PFUser *toUser = [data objectForKey:@"toUser"];
        [toUser fetchIfNeeded];
        PFFile *thumbnailTo = [toUser objectForKey:@"profilePicture"];
        NSData *imageDataTo = [thumbnailTo getData];
        UIImage *imageTo = [UIImage imageWithData:imageDataTo];
        UIImageView *toProfilePic = [[UIImageView alloc] init];
        if (imageDataTo == nil) {
            toProfilePic.image = [UIImage imageNamed:@"defaultProPic"];
            toProfilePic.layer.cornerRadius = 12.5;
            toProfilePic.clipsToBounds = YES;
        }else {
            toProfilePic.image = imageTo;
            toProfilePic.layer.cornerRadius = 12.5;
            toProfilePic.clipsToBounds = YES;
        }
        [toProfilePic setTranslatesAutoresizingMaskIntoConstraints:NO];
        [cell.contentView addSubview:toProfilePic];
        
        [toProfilePic autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:vertCellLine withOffset:20];
        [toProfilePic autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:24];
        [toProfilePic autoSetDimension:ALDimensionHeight toSize:25];
        [toProfilePic autoSetDimension:ALDimensionWidth toSize:25];
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
        
        [titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:toProfilePic withOffset:6];
        [titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:6];
        
#pragma mark - Location Icon
        UIImageView *locationIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"locationIcon"]];
        [locationIcon setTranslatesAutoresizingMaskIntoConstraints:NO];
        [cell.contentView addSubview:locationIcon];
        
        [locationIcon autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:toProfilePic withOffset:6];
        [locationIcon autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:titleLabel withOffset:3.5];
        
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
        
#pragma mark - Detail Label
        UILabel *detailLabel = [[UILabel alloc] init];
        [detailLabel setNeedsDisplay];
        [detailLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.textColor = [UIColor colorWithRed:0.620 green:0.639 blue:0.659 alpha:1];
        detailLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:12];
        detailLabel.textAlignment = NSTextAlignmentLeft;
        detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        detailLabel.numberOfLines = 4;
        detailLabel.adjustsFontSizeToFitWidth = NO;
        detailLabel.text = [data objectForKey:@"volunteerDescription"];
        [detailLabel setNeedsDisplay];
        [cell.contentView addSubview:detailLabel];
        
        [detailLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:vertCellLine withOffset:5];
        [detailLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:toProfilePic withOffset:4];
        [detailLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:3];
        
#pragma mark - Time Label
        
        // Extract Time from Date
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        timeFormatter.dateFormat = @"h:mm a";
        NSString *timeString = [timeFormatter stringFromDate:date];
        
        // UI
        UILabel *timeLabel = [[UILabel alloc] init];
        [timeLabel setNeedsDisplay];
        [timeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textColor = [UIColor darkGrayColor];
        timeLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:18];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.text = timeString;
        [timeLabel setNeedsDisplay];
        [cell.contentView addSubview:timeLabel];
        
        [timeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:toProfilePic];
        [timeLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:8];
        
#pragma mark - Date Label
        // Extract Time from Date
        NSDateFormatter *dateF = [[NSDateFormatter alloc] init];
        dateF.dateFormat = @"M/dd/yyyy";
        NSString *dateStr = [dateF stringFromDate:date];
        
        // UI
        UILabel *groupLabel = [[UILabel alloc] init];
        [groupLabel setNeedsDisplay];
        [groupLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        groupLabel.backgroundColor = [UIColor clearColor];
        groupLabel.textColor = [UIColor colorWithRed:0.620 green:0.639 blue:0.659 alpha:1];
        groupLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:8.881];
        groupLabel.textAlignment = NSTextAlignmentCenter;
        groupLabel.text = dateStr;
        [groupLabel setNeedsDisplay];
        [cell.contentView addSubview:groupLabel];
        
        [groupLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:timeLabel withOffset:-3];
        [groupLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:timeLabel];
        
#pragma mark - Clock Icon
        UIImageView *clockIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clockIcon"]];
        [clockIcon setTranslatesAutoresizingMaskIntoConstraints:NO];
        [cell.contentView addSubview:clockIcon];
        
        [clockIcon autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:groupLabel withOffset:5];
        [clockIcon autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:timeLabel];
        
        
#pragma mark - Hours Label
        UILabel *hoursLabel = [[UILabel alloc] init];
        [hoursLabel setNeedsDisplay];
        [hoursLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        hoursLabel.backgroundColor = [UIColor clearColor];
        hoursLabel.textColor = [UIColor colorWithRed:0.620 green:0.639 blue:0.659 alpha:1];
        hoursLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:8.881];
        hoursLabel.textAlignment = NSTextAlignmentCenter;
        hoursLabel.text = [NSString stringWithFormat:@"%@ Hrs",[[data objectForKey:@"volunteerHours"] stringValue]];
        [hoursLabel setNeedsDisplay];
        [cell.contentView addSubview:hoursLabel];
        
        [hoursLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:clockIcon withOffset:0];
        [hoursLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:clockIcon withOffset:3];
    }
    
    
    
    return cell;
}

- (void)fetchData {/*
                    if([PFUser currentUser]){
                    dispatch_async(dispatch_get_main_queue(), ^{
                    PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
                    [query whereKey:@"from" equalTo:[PFUser currentUser]];
                    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    for(PFObject *o in objects) {
                    PFUser *otherUser = [o objectForKey:@"to"];
                    
                    PFQuery *query = [PFQuery queryWithClassName:@"VolunteerSheet"];
                    [query whereKey:@"toUser" equalTo:otherUser];
                    
                    PFQuery *current = [PFQuery queryWithClassName:@"VolunteerSheet"];
                    [current whereKey:@"toUser" equalTo:[PFUser currentUser]];
                    
                    PFQuery *completeQuery = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:query, current, nil]];
                    [completeQuery orderByDescending:@"createdAt"];
                    
                    [completeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    NSLog(@"Successfully retrieved %lu logs.", (unsigned long)objects.count);
                    if (!error) {
                    NSMutableArray *objectsMut = [objects mutableCopy];
                    self.objects = objectsMut;
                    } else {
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                    }];
                    }
                    }];
                    [self.tableView reloadData];
                    });
                    }
                    */
    PFQuery *current = [PFQuery queryWithClassName:@"VolunteerSheet"];
    [current orderByDescending:@"createdAt"];
    [current findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"Successfully retrieved %lu logs.", (unsigned long)objects.count);
        if (!error) {
            UIImageView *begin = [[UIImageView alloc] initWithFrame:CGRectMake(0, -40, 320, 540)];
            if (objects.count == 0) {
                begin.image = [UIImage imageNamed:@"begin"];
                [self.tableView addSubview:begin];
            }else{
                [self.tableView sendSubviewToBack:begin];
                [begin removeFromSuperview];
            }
            
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VolunteerSheetViewController *destViewController = [[VolunteerSheetViewController alloc] init];
    destViewController.object = [self.objects objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:destViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}

- (void)didTapBarButton:(id)sender
{
    [self.sidePanelController showRightPanelAnimated:YES];
}

@end
