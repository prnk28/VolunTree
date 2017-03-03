//
//  VolunteerSheetViewController.m
//  VolunTree
//
//  Created by Pradyumn Nukala on 12/5/15.
//  Copyright © 2015 HelpOut. All rights reserved.
//

#import "VolunteerSheetViewController.h"
#import "Data.h"

@interface VolunteerSheetViewController ()

@end

@implementation VolunteerSheetViewController
@synthesize scrollView;

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)seeIfAuthor{
    if (self.object[@"fromUser"] == [PFUser currentUser] || self.object[@"toUser"] == [PFUser currentUser]) {
        UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [barButton setTitle:@"" forState:UIControlStateNormal];
        [barButton setBackgroundImage:[UIImage imageNamed:@"trash"] forState:UIControlStateNormal];
        [barButton addTarget:self action:@selector(deletePost:) forControlEvents:UIControlEventTouchUpInside];
        barButton.frame = CGRectMake(0.0f, 0.0f, 10.0f, 15.0f);
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
        self.navigationItem.rightBarButtonItem = barButtonItem;
    }
}

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
    [self seeIfAuthor];
    [self setUpUI];
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    
    if(self.object[@"userLog"]){
        
        // To User
        UIButton *toUserButton = [[UIButton alloc] init];
        PFUser *toUser = [self.object objectForKey:@"toUser"];
        [toUser fetchIfNeeded];
        PFFile *thumbnailTo = [toUser objectForKey:@"profilePicture"];
        NSData *imageDataTo = [thumbnailTo getData];
        UIImage *imageTo = [UIImage imageWithData:imageDataTo];
        
        if (imageDataTo == nil) {
            [toUserButton setImage:[UIImage imageNamed:@"profilePic"]
                          forState:UIControlStateNormal];
        }else {
            [toUserButton setImage:imageTo forState:UIControlStateNormal];
            toUserButton.imageView.layer.cornerRadius = 35.0;
            toUserButton.imageView.clipsToBounds = YES;
        }
        [toUserButton addTarget:self action:@selector(popTo:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:toUserButton];
        [toUserButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [toUserButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30];
        [toUserButton autoSetDimension:ALDimensionHeight toSize:69];
        [toUserButton autoSetDimension:ALDimensionWidth toSize:70];
        
        // Give Arrow
        UIImageView *giveArrow = [[UIImageView alloc] init];
        giveArrow.image = [UIImage imageNamed:@"giveArrow"];
        [scrollView addSubview:giveArrow];
        [giveArrow autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:toUserButton withOffset:45];
        [giveArrow autoAlignAxis:ALAxisVertical toSameAxisOfView:toUserButton];
        [giveArrow autoSetDimension:ALDimensionWidth toSize:150];
        [giveArrow autoSetDimension:ALDimensionHeight toSize:100];
        
        // Hours Label
        UILabel *hoursLabel = [[UILabel alloc] init];
        hoursLabel.textColor = [UIColor whiteColor];
        hoursLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:30];
        hoursLabel.textAlignment = NSTextAlignmentCenter;
        hoursLabel.text = [NSString stringWithFormat:@"%@ Hours",[[self.object objectForKey:@"volunteerHours"] stringValue] ];
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
        
        [toNameLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:toUserButton withOffset:50];
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
        
        [locationIcon autoAlignAxis:ALAxisHorizontal toSameAxisOfView:giveArrow withOffset:60];
        [locationIcon autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
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
        description.text = [self.object objectForKey:@"volunteerDescription"];
        [scrollView addSubview:description];
        
        // Change ScrollView Height
        CGSize textHeight = [self calculateHeightForString:[self.object objectForKey:@"volunteerDescription"]];
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, textHeight.height+400);
        
        [description autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:descriptionIcon withOffset:7.5];
        [description autoAlignAxis:ALAxisFirstBaseline toSameAxisOfView:descriptionIcon withOffset:14];
        [description autoSetDimension:ALDimensionWidth toSize:265];
        
    }else{
        // From User
        PFUser *fromUser = [self.object objectForKey:@"fromUser"];
        [fromUser fetchIfNeeded];
        PFFile *thumbnail = [fromUser objectForKey:@"profilePicture"];
        NSData *imageData = [thumbnail getData];
        UIImage *image = [UIImage imageWithData:imageData];
        UIButton *fromUserImage = [[UIButton alloc] init];
        if (imageData == nil) {
            [fromUserImage setImage:[UIImage imageNamed:@"profilePic"]
                           forState:UIControlStateNormal];
        }else {
            [fromUserImage setImage:image forState:UIControlStateNormal];
            fromUserImage.layer.cornerRadius = 35.0;
            fromUserImage.clipsToBounds = YES;
        }
        [fromUserImage addTarget:self action:@selector(popFrom:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:fromUserImage];
        
        [fromUserImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:50];
        [fromUserImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30];
        [fromUserImage autoSetDimension:ALDimensionHeight toSize:69];
        [fromUserImage autoSetDimension:ALDimensionWidth toSize:70];
        
        // To User
        UIButton *toUserButton = [[UIButton alloc] init];
        PFUser *toUser = [self.object objectForKey:@"toUser"];
        [fromUser fetchIfNeeded];
        PFFile *thumbnailTo = [toUser objectForKey:@"profilePicture"];
        NSData *imageDataTo = [thumbnailTo getData];
        UIImage *imageTo = [UIImage imageWithData:imageDataTo];
        
        if (imageDataTo == nil) {
            [toUserButton setImage:[UIImage imageNamed:@"profilePic"]
                          forState:UIControlStateNormal];
        }else {
            [toUserButton setImage:imageTo forState:UIControlStateNormal];
            toUserButton.imageView.layer.cornerRadius = 35.0;
            toUserButton.imageView.clipsToBounds = YES;
        }
        [toUserButton addTarget:self action:@selector(popTo:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:toUserButton];
        
        [toUserButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-50];
        [toUserButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30];
        [toUserButton autoSetDimension:ALDimensionHeight toSize:69];
        [toUserButton autoSetDimension:ALDimensionWidth toSize:70];
        
        // From Name Label
        UILabel *fromNameLabel = [[UILabel alloc] init];
        fromNameLabel.textColor = [UIColor colorWithRed:0.620 green:0.639 blue:0.659 alpha:1];
        fromNameLabel.font = [UIFont fontWithName:@"OpenSans-Regular" size:15];
        fromNameLabel.textAlignment = NSTextAlignmentCenter;
        fromNameLabel.text = [fromUser objectForKey:@"fullName"];
        [scrollView addSubview:fromNameLabel];
        
        [fromNameLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:fromUserImage withOffset:50];
        [fromNameLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:fromUserImage withOffset:0];
        
        // From User Label
        UILabel *fromUserLabel = [[UILabel alloc] init];
        fromUserLabel.textColor = [UIColor colorWithRed:0.620 green:0.639 blue:0.659 alpha:1];
        fromUserLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:12];
        fromUserLabel.textAlignment = NSTextAlignmentCenter;
        fromUserLabel.text = [fromUser objectForKey:@"username"];
        [scrollView addSubview:fromUserLabel];
        
        [fromUserLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:fromNameLabel withOffset:16];
        [fromUserLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:fromNameLabel withOffset:0];
        
        // Give Arrow
        UIImageView *giveArrow = [[UIImageView alloc] init];
        giveArrow.image = [UIImage imageNamed:@"giveArrow"];
        [scrollView addSubview:giveArrow];
        [giveArrow autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:fromUserImage withOffset:45];
        [giveArrow autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:fromUserImage withOffset:30];
        [giveArrow autoSetDimension:ALDimensionWidth toSize:150];
        [giveArrow autoSetDimension:ALDimensionHeight toSize:100];
        
        // Hours Label
        UILabel *hoursLabel = [[UILabel alloc] init];
        hoursLabel.textColor = [UIColor whiteColor];
        hoursLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:30];
        hoursLabel.textAlignment = NSTextAlignmentCenter;
        hoursLabel.text = [NSString stringWithFormat:@"%@ Hours",[[self.object objectForKey:@"volunteerHours"] stringValue] ];
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
        
        [toNameLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:toUserButton withOffset:50];
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
        
        [locationIcon autoAlignAxis:ALAxisHorizontal toSameAxisOfView:fromUserLabel withOffset:135];
        [locationIcon autoAlignAxis:ALAxisVertical toSameAxisOfView:fromUserLabel withOffset:-18];
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
        description.text = [self.object objectForKey:@"volunteerDescription"];
        [scrollView addSubview:description];
        
        // Change ScrollView Height
        CGSize textHeight = [self calculateHeightForString:[self.object objectForKey:@"volunteerDescription"]];
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, textHeight.height+400);
        
        [description autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:descriptionIcon withOffset:7.5];
        [description autoAlignAxis:ALAxisFirstBaseline toSameAxisOfView:descriptionIcon withOffset:14];
        [description autoSetDimension:ALDimensionWidth toSize:265];
        
    }
    
}

- (void)setUpUI{
    NSString *volunteerTitle = [self.object objectForKey:@"volunteerTitle"];
    [self.navigationItem setTitle:volunteerTitle];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"OpenSans-Semibold" size:18]}];
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [back setTitle:@"" forState:UIControlStateNormal];
    [back setBackgroundImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(popBack:) forControlEvents:UIControlEventTouchUpInside];
    back.frame = CGRectMake(0.0f, 0.0f, 10.0f, 15.0f);
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    
    self.navigationItem.leftBarButtonItem = backButtonItem;
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
