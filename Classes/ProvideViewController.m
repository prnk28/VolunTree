//
//  ProvideViewController.m
//  VolunTree
//
//  Created by Pradyumn Nukala on 7/25/16.
//  Copyright © 2016 HelpOut. All rights reserved.
//

#import "ProvideViewController.h"
#import "PJRSignatureView.h"
#import "Data.h"

@interface ProvideViewController (){
    PJRSignatureView *signatureView;
}

@end

@implementation ProvideViewController

- (void)deletePost:(id)sender {
    NSArray *items = @[MMItemMake(@"Yes", MMItemTypeNormal, ^(NSInteger index) {
        [self.object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            NSLog(@"Deleted.");
        }];
        [self.navigationController popViewControllerAnimated:YES];
    }), MMItemMake(@"Cancel", MMItemTypeHighlight, ^(NSInteger index) {
        
    })];
    [[[MMAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Delete."]
                                 detail:@"Are you sure you want to delete this post?"
                                  items:items] show];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    
    
    // To User
    UIButton *toUserButton = [[UIButton alloc] init];
    PFUser *toUser = [self.object objectForKey:@"fromUser"];
    [toUser fetchIfNeeded];
    PFFile *thumbnailTo = [toUser objectForKey:@"profilePicture"];
    NSData *imageDataTo = [thumbnailTo getData];
    UIImage *imageTo = [UIImage imageWithData:imageDataTo];
    
    if (imageDataTo == nil) {
        [toUserButton setImage:[UIImage imageNamed:@"profilePic"]
                      forState:UIControlStateNormal];
    }else {
        [toUserButton setImage:imageTo forState:UIControlStateNormal];
        toUserButton.imageView.layer.cornerRadius = 50;
        toUserButton.imageView.clipsToBounds = YES;
    }
    [toUserButton addTarget:self action:@selector(popTo:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:toUserButton];
    
    [toUserButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [toUserButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30];
    [toUserButton autoSetDimension:ALDimensionHeight toSize:100];
    [toUserButton autoSetDimension:ALDimensionWidth toSize:100];
    
    // Give Arrow
    UIImageView *giveArrow = [[UIImageView alloc] init];
    giveArrow.image = [UIImage imageNamed:@"giveArrow"];
    [scrollView addSubview:giveArrow];
    [giveArrow autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:toUserButton withOffset:45];
    [giveArrow autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:toUserButton withOffset:-25];
    [giveArrow autoSetDimension:ALDimensionWidth toSize:150];
    [giveArrow autoSetDimension:ALDimensionHeight toSize:100];
    
    // Hours Label
    UILabel *hoursLabel = [[UILabel alloc] init];
    hoursLabel.textColor = [UIColor whiteColor];
    hoursLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:30];
    hoursLabel.textAlignment = NSTextAlignmentCenter;
    hoursLabel.text = [NSString stringWithFormat:@"%@ Hours",[[self.object objectForKey:@"hours"] stringValue]];
    [scrollView addSubview:hoursLabel];
    
    [hoursLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:giveArrow withOffset:0];
    [hoursLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:giveArrow withOffset:-2];
    
    // To Name Label
    UILabel *toNameLabel = [[UILabel alloc] init];
    toNameLabel.textColor = [UIColor colorWithRed:0.620 green:0.639 blue:0.659 alpha:1];
    toNameLabel.font = [UIFont fontWithName:@"OpenSans-Regular" size:15];
    toNameLabel.textAlignment = NSTextAlignmentCenter;
    toNameLabel.text = [toUser objectForKey:@"fullName"];
    [scrollView addSubview:toNameLabel];
    
    [toNameLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:toUserButton withOffset:65];
    [toNameLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:toUserButton withOffset:0];
    
    // From User Label
    UILabel *toUserLabel = [[UILabel alloc] init];
    toUserLabel.textColor = [UIColor colorWithRed:0.620 green:0.639 blue:0.659 alpha:1];
    toUserLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:12];
    toUserLabel.textAlignment = NSTextAlignmentCenter;
    toUserLabel.text = [toUser objectForKey:@"username"];
    [scrollView addSubview:toUserLabel];
    
    [toUserLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:toNameLabel withOffset:16];
    [toUserLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:toNameLabel withOffset:0];
    
    // Location Icon
    UIImageView *locationIcon = [[UIImageView alloc] init];
    locationIcon.image = [UIImage imageNamed:@"locationBig"];
    [scrollView addSubview:locationIcon];
    
    [locationIcon autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:25];
    [locationIcon autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:giveArrow withOffset:30];
    [locationIcon autoSetDimension:ALDimensionWidth toSize:15];
    [locationIcon autoSetDimension:ALDimensionHeight toSize:18];
    
    // Location Label
    UILabel *locationLabel = [[UILabel alloc] init];
    locationLabel.textColor = [UIColor colorWithRed:0.620 green:0.639 blue:0.659 alpha:1];
    locationLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:16];
    locationLabel.textAlignment = NSTextAlignmentCenter;
    locationLabel.text = [self.object objectForKey:@"location"];
    [scrollView addSubview:locationLabel];
    
    [locationLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:locationIcon withOffset:7.5];
    [locationLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:locationIcon withOffset:0];
    
    // Description Icon
    UIImageView *descriptionIcon = [[UIImageView alloc] init];
    descriptionIcon.image = [UIImage imageNamed:@"description"];
    [scrollView addSubview:descriptionIcon];
    
    [descriptionIcon autoAlignAxis:ALAxisVertical toSameAxisOfView:locationIcon withOffset:0];
    [descriptionIcon autoAlignAxis:ALAxisHorizontal toSameAxisOfView:locationIcon withOffset:30];
    [descriptionIcon autoSetDimension:ALDimensionWidth toSize:18];
    [descriptionIcon autoSetDimension:ALDimensionHeight toSize:18];
    
    // Description TextView
    UILabel *description = [[UILabel alloc] init];
    description.textColor = [UIColor colorWithRed:0.620 green:0.639 blue:0.659 alpha:1];
    description.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
    description.textAlignment = NSTextAlignmentLeft;
    description.lineBreakMode = NSLineBreakByWordWrapping;
    description.numberOfLines = 0;
    description.adjustsFontSizeToFitWidth = NO;
    description.text = [self.object objectForKey:@"description"];
    [scrollView addSubview:description];
    
    signatureView = [[PJRSignatureView alloc] init];
    signatureView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    signatureView.layer.borderWidth = 1.0f;
    [self.view addSubview:signatureView];
    
    [signatureView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:60];
    [signatureView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [signatureView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
    [signatureView autoSetDimension:ALDimensionHeight toSize:125];
    
    // Approve
    UIButton *approve = [[UIButton alloc] init];
    [approve setImage:[UIImage imageNamed:@"approve"] forState:UIControlStateNormal];
    [approve addTarget:self action:@selector(approveTouch) forControlEvents:UIControlEventTouchDown];
    [scrollView addSubview:approve];
    [scrollView bringSubviewToFront:approve];
    
    [approve autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-10];
    [approve autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-10];
    [approve autoSetDimension:ALDimensionWidth toSize:36];
    [approve autoSetDimension:ALDimensionHeight toSize:36];
    
    // Clear
    UIButton *clear = [[UIButton alloc] init];
    [clear setImage:[UIImage imageNamed:@"clear"] forState:UIControlStateNormal];
    [clear addTarget:self action:@selector(clearTouch) forControlEvents:UIControlEventTouchDown];
    [scrollView addSubview:clear];
    [scrollView bringSubviewToFront:clear];
    
    [clear autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:10];
    [clear autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-10];
    [clear autoSetDimension:ALDimensionWidth toSize:36];
    [clear autoSetDimension:ALDimensionHeight toSize:36];
    
    // Change ScrollView Height
    CGSize textHeight = [self calculateHeightForString:[self.object objectForKey:@"description"]];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, textHeight.height+400);
    
    [description autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:descriptionIcon withOffset:7.5];
    [description autoAlignAxis:ALAxisFirstBaseline toSameAxisOfView:descriptionIcon withOffset:14];
    [description autoSetDimension:ALDimensionWidth toSize:265];
}

- (void)setUpUI{
    NSString *volunteerTitle = [self.object objectForKey:@"title"];
    [self.navigationItem setTitle:volunteerTitle];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"OpenSans-Semibold" size:18]}];
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setTitle:@"" forState:UIControlStateNormal];
    [back setBackgroundImage:[UIImage imageNamed:@"closeIcon"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(popBack:) forControlEvents:UIControlEventTouchUpInside];
    back.frame = CGRectMake(0.0f, 0.0f, 15, 15);
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [barButton setTitle:@"" forState:UIControlStateNormal];
    [barButton setBackgroundImage:[UIImage imageNamed:@"trash"] forState:UIControlStateNormal];
    [barButton addTarget:self action:@selector(deletePost:) forControlEvents:UIControlEventTouchUpInside];
    barButton.frame = CGRectMake(0.0f, 0.0f, 15, 18);
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)popFrom:(id)sender {
    PFUser *fromUser = [self.object objectForKey:@"fromUser"];
    ForeignProfileVC *fvc = [[ForeignProfileVC alloc] init];
    fvc.object = fromUser;
    [self.navigationController pushViewController:fvc animated:YES];
}

- (void)popTo:(id)sender {
    PFUser *toUser = [self.object objectForKey:@"toUser"];
    ForeignProfileVC *fvc = [[ForeignProfileVC alloc] init];
    fvc.object = toUser;
    [self.navigationController pushViewController:fvc animated:YES];
}

- (void)approveTouch {
    UIImage *signature = [signatureView getSignatureImage];
    
    if (signature == nil) {
        notif = [JFMinimalNotification notificationWithStyle:JFMinimalNotificationStyleError title:@"Error" subTitle:@"Please sign the signature pad."];
        UIFont* titleFont = [UIFont fontWithName:@"OpenSans-Regular" size:22];
        [notif setTitleFont:titleFont];
        UIFont* subTitleFont = [UIFont fontWithName:@"OpenSans-Light" size:16];
        [notif setSubTitleFont:subTitleFont];
        [self.view addSubview:notif];
        [notif show];
        [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(hideNotifNoClose:)
                                       userInfo:nil
                                        repeats:NO];
    } else {
        NSData *imageData = UIImagePNGRepresentation(signature);
        PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
        
        PFUser *selectedUser = [self.object objectForKey:@"fromUser"];
        PFObject *volunteerSheet = [PFObject objectWithClassName:@"VolunteerSheet"];
        volunteerSheet[@"toUser"] = selectedUser;
        volunteerSheet[@"signature"] = imageFile;
        volunteerSheet[@"fromUser"] = [PFUser currentUser];
        volunteerSheet[@"volunteerTitle"] = [self.object objectForKey:@"title"];
        volunteerSheet[@"location"] = [self.object objectForKey:@"location"];
        volunteerSheet[@"volunteerHours"] = [self.object objectForKey:@"hours"];
        volunteerSheet[@"volunteerDescription"] = [self.object objectForKey:@"description"];
        [volunteerSheet saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                PFQuery *query = [PFQuery queryWithClassName:@"Hours"];
                [query whereKey:@"user" equalTo:selectedUser];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        for (PFObject *object in objects) {
                            // change total hours
                            NSNumber *ogValue = object[@"totalHours"];
                            NSNumber *moreHours = [self.object objectForKey:@"hours"];
                            NSNumber *newValue = [NSNumber numberWithFloat:([ogValue floatValue] + [moreHours floatValue])];
                            NSLog(@"New Hours: %@",newValue);
                            object[@"totalHours"] = newValue;
                            
                            // change weekly hours
                            if ([object[@"weekDayDate"]  isEqual: @7]) {
                                object[@"lastWeek"] = object[@"thisWeek"];
                                object[@"thisWeek"] = @0;
                                NSLog(@"Refresh weekly boxes");
                            }else{
                                NSNumber *ogValue = object[@"thisWeek"];
                                NSNumber *moreHours = [self.object objectForKey:@"hours"];
                                NSNumber *newValue = [NSNumber numberWithFloat:([ogValue floatValue] + [moreHours floatValue])];
                                NSLog(@"New Hours Week: %@",newValue);
                                object[@"thisWeek"] = newValue;
                            }
                            
                            // change monthly hours
                            NSDate *currDate = [NSDate date];
                            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                            NSDateComponents *dateComponents = [gregorian components:(NSCalendarUnitYear  | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:currDate];
                            NSInteger m = [dateComponents month];
                            NSLog(@"Current month %ld", (long)m);
                            if (m == 1) {
                                NSNumber *ogValue = object[@"Jan"];
                                NSNumber *moreHours = [self.object objectForKey:@"hours"];
                                NSNumber *newValue = [NSNumber numberWithFloat:([ogValue floatValue] + [moreHours floatValue])];
                                NSLog(@"New Hours Mont: %@",newValue);
                                object[@"Jan"] = newValue;
                            }else if(m == 2) {
                                NSNumber *ogValue = object[@"Feb"];
                                NSNumber *moreHours = [self.object objectForKey:@"hours"];
                                NSNumber *newValue = [NSNumber numberWithFloat:([ogValue floatValue] + [moreHours floatValue])];
                                NSLog(@"New Hours Mont: %@",newValue);
                                object[@"Feb"] = newValue;
                            }else if(m == 3) {
                                NSNumber *ogValue = object[@"Mar"];
                                NSNumber *moreHours = [self.object objectForKey:@"hours"];
                                NSNumber *newValue = [NSNumber numberWithFloat:([ogValue floatValue] + [moreHours floatValue])];
                                NSLog(@"New Hours Mont: %@",newValue);
                                object[@"Mar"] = newValue;
                            }else if(m == 4) {
                                NSNumber *ogValue = object[@"Apr"];
                                NSNumber *moreHours = [self.object objectForKey:@"hours"];
                                NSNumber *newValue = [NSNumber numberWithFloat:([ogValue floatValue] + [moreHours floatValue])];
                                NSLog(@"New Hours Mont: %@",newValue);
                                object[@"Apr"] = newValue;
                            }else if(m == 5) {
                                NSNumber *ogValue = object[@"May"];
                                NSNumber *moreHours = [self.object objectForKey:@"hours"];
                                NSNumber *newValue = [NSNumber numberWithFloat:([ogValue floatValue] + [moreHours floatValue])];
                                NSLog(@"New Hours Mont: %@",newValue);
                                object[@"May"] = newValue;
                            }else if(m == 6) {
                                NSNumber *ogValue = object[@"Jun"];
                                NSNumber *moreHours = [self.object objectForKey:@"hours"];
                                NSNumber *newValue = [NSNumber numberWithFloat:([ogValue floatValue] + [moreHours floatValue])];
                                NSLog(@"New Hours Mont: %@",newValue);
                                object[@"Jun"] = newValue;
                            }else if(m == 7){
                                NSNumber *ogValue = object[@"Jul"];
                                NSNumber *moreHours = [self.object objectForKey:@"hours"];
                                NSNumber *newValue = [NSNumber numberWithFloat:([ogValue floatValue] + [moreHours floatValue])];
                                NSLog(@"New Hours Mont: %@",newValue);
                                object[@"Jul"] = newValue;
                            }else if(m == 8) {
                                NSNumber *ogValue = object[@"Aug"];
                                NSNumber *moreHours = [self.object objectForKey:@"hours"];
                                NSNumber *newValue = [NSNumber numberWithFloat:([ogValue floatValue] + [moreHours floatValue])];
                                NSLog(@"New Hours Mont: %@",newValue);
                                object[@"Aug"] = newValue;
                            }else if(m == 9) {
                                NSNumber *ogValue = object[@"Sep"];
                                NSNumber *moreHours = [self.object objectForKey:@"hours"];
                                NSNumber *newValue = [NSNumber numberWithFloat:([ogValue floatValue] + [moreHours floatValue])];
                                NSLog(@"New Hours Mont: %@",newValue);
                                object[@"Sep"] = newValue;
                            }else if(m == 10) {
                                NSNumber *ogValue = object[@"Oct"];
                                NSNumber *moreHours = [self.object objectForKey:@"hours"];
                                NSNumber *newValue = [NSNumber numberWithFloat:([ogValue floatValue] + [moreHours floatValue])];
                                NSLog(@"New Hours Mont: %@",newValue);
                                object[@"Nov"] = newValue;
                            }else if(m == 11) {
                                NSNumber *ogValue = object[@"Nov"];
                                NSNumber *moreHours = [self.object objectForKey:@"hours"];
                                NSNumber *newValue = [NSNumber numberWithFloat:([ogValue floatValue] + [moreHours floatValue])];
                                NSLog(@"New Hours Mont: %@",newValue);
                                object[@"totalHours"] = newValue;
                            }else if(m == 12) {
                                NSNumber *ogValue = object[@"Dec"];
                                NSNumber *moreHours = [self.object objectForKey:@"hours"];
                                NSNumber *newValue = [NSNumber numberWithFloat:([ogValue floatValue] + [moreHours floatValue])];
                                NSLog(@"New Hours Mont: %@",newValue);
                                object[@"Dec"] = newValue;
                            }
                            // Save Object
                            [object saveInBackground];
                            [self.object deleteInBackground];
                        }
                    } else {
                        // Log details of the failure
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                }];
                
                // Create our installation query
                PFQuery *pushQuery = [PFInstallation query];
                [pushQuery whereKey:@"user" equalTo:selectedUser];
                
                // Send push notification to query
                PFPush *push = [[PFPush alloc] init];
                [push setQuery:pushQuery]; // Set our installation query
                NSString *message = [NSString stringWithFormat:@"You have recieved %@ hours", [self.object objectForKey:@"hours"]];
                [push setMessage:message];
                [push sendPushInBackground];
                
                notif = [JFMinimalNotification notificationWithStyle:JFMinimalNotificationStyleSuccess title:@"Success" subTitle:@"The Hours have been sent!"];
                UIFont* titleFont = [UIFont fontWithName:@"OpenSans-Regular" size:22];
                [notif setTitleFont:titleFont];
                UIFont* subTitleFont = [UIFont fontWithName:@"OpenSans-Light" size:16];
                [notif setSubTitleFont:subTitleFont];
                [self.view addSubview:notif];
                [notif show];
                [NSTimer scheduledTimerWithTimeInterval:1.0
                                                 target:self
                                               selector:@selector(hideNotif:)
                                               userInfo:nil
                                                repeats:NO];
            }
        }];

    }
    
}

- (void)clearTouch {
    [signatureView clearSignature];
}

//our helper method
- (CGSize)calculateHeightForString:(NSString *)str
{
    CGSize size = CGSizeZero;
    
    UIFont *labelFont = [UIFont systemFontOfSize:17.0f];
    NSDictionary *systemFontAttrDict = [NSDictionary dictionaryWithObject:labelFont forKey:NSFontAttributeName];
    
    NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:str attributes:systemFontAttrDict];
    CGRect rect = [message boundingRectWithSize:(CGSize){320, MAXFLOAT}
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                        context:nil];//you need to specify the some width, height will be calculated
    size = CGSizeMake(rect.size.width, rect.size.height + 5); //padding
    
    return size;
}

- (void)popBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)hideNotifNoClose:(id)sender {
    [notif dismiss];
}

-(void)hideNotif:(id)sender {
    [notif dismiss];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
