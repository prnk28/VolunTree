//
//  ForeignProfileHeaderView.m
//  VolunTree
//
//  Created by Pradyumn Nukala on 6/20/16.
//  Copyright © 2016 HelpOut. All rights reserved.
//

#import "ForeignProfileHeaderView.h"

@implementation ForeignProfileHeaderView
-(id)baseInitWithDictionary:(PFUser *)user {
    self.email = user[@"email"];
    self.user = user;
#pragma mark - Profile Header
    UIImageView *profileHeader = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 800, 200)];
    profileHeader.image = [UIImage imageNamed:@"profileHeader"];
    profileHeader.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:profileHeader];
    
#pragma mark - Profile Image
    PFFile *thumbnail = [user objectForKey:@"profilePicture"];
    NSData *imageData = [thumbnail getData];
    UIImage *image = [UIImage imageWithData:imageData];
    
    UIButton *profileImage = [[UIButton alloc] init];
    if (imageData == nil) {
        [profileImage setImage:[UIImage imageNamed:@"profilePicture"] forState:UIControlStateNormal];
    }else{
        [profileImage setImage:image forState:UIControlStateNormal];
    }
    
    profileImage.layer.cornerRadius=50.0;
    profileImage.clipsToBounds = YES;
    [profileImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    profileImage.userInteractionEnabled = YES;
    [self addSubview:profileImage];
    
    [profileImage autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [profileImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:13];
    [profileImage autoSetDimension:ALDimensionWidth toSize:104];
    [profileImage autoSetDimension:ALDimensionHeight toSize:104];
    
#pragma mark - Shadow
    UIImageView *shadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow"]];
    [shadow setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:shadow];
    
    [shadow autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:127.5];
    [shadow autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [shadow autoPinEdgeToSuperviewEdge:ALEdgeRight];
    
#pragma mark - Username
    UILabel *username = [[UILabel alloc] init];
    [username setTranslatesAutoresizingMaskIntoConstraints:NO];
    username.backgroundColor = [UIColor clearColor];
    username.textColor = [UIColor colorWithRed:0.984 green:0.987 blue:0.992 alpha:1];
    username.font = [UIFont fontWithName:@"OpenSans" size:18.111];
    username.textAlignment = NSTextAlignmentCenter;
    username.text = user[@"username"];
    
    [self addSubview:username];
    [username autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:profileImage withOffset:20];
    [username autoAlignAxis:ALAxisVertical toSameAxisOfView:profileImage];
    
    
#pragma mark - Full Name
    UILabel *fullName = [[UILabel alloc] init];
    [fullName setTranslatesAutoresizingMaskIntoConstraints:NO];
    fullName.backgroundColor = [UIColor clearColor];
    fullName.textColor = [UIColor colorWithRed:0.984 green:0.987 blue:0.992 alpha:1];
    fullName.font = [UIFont fontWithName:@"OpenSans-Light" size:12.451];
    fullName.textAlignment = NSTextAlignmentCenter;
    fullName.text = [user objectForKey:@"fullName"];
    
    [self addSubview:fullName];
    
    [fullName autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:username withOffset:-1];
    [fullName autoAlignAxis:ALAxisVertical toSameAxisOfView:username];
    
    
#pragma mark - Hours Label
    // Get Current Hours
    if([PFUser currentUser]){
        PFQuery *query = [PFQuery queryWithClassName:@"Hours"];
        [query whereKey:@"user" equalTo:user];
        [query findObjectsInBackgroundWithTarget:self selector:@selector(callbackLoadObjectsFromParse:)];
    }
    
#pragma mark - Tabs
    UIImageView *profileTabs = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profileTabs"]];
    [profileTabs setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:profileTabs];
    
    [profileTabs autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:177.5];
    [profileTabs autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [profileTabs autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [profileTabs autoSetDimension:ALDimensionHeight toSize:45];
    
#pragma mark - Clubs Label
    if([PFUser currentUser]){
        PFQuery *query = [PFQuery queryWithClassName:@"Organizations"];
        [query whereKey:@"members" equalTo:user];
        [query findObjectsInBackgroundWithTarget:self selector:@selector(callbackLoadOrgFromParse:)];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame withDictionary:(NSDictionary *)dict
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInitWithDictionary:dict];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder withDictionary:(NSDictionary *)dict {
    if ((self = [super initWithCoder:aDecoder])) {
        [self baseInitWithDictionary:dict];
    }
    return self;
}
- (void)callbackLoadObjectsFromParse:(NSArray *)result {
    if (result) {
        [self setNeedsDisplay];
        for (PFObject *object in result) {
            NSNumber *ogValue = object[@"totalHours"];
            NSLog(@"Val %@",ogValue);
            NSString *hoursString = [NSString stringWithFormat:@"%@ Hours", ogValue];
            UILabel *hoursLabel = [[UILabel alloc] init];
            [hoursLabel setNeedsDisplay];
            [hoursLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            hoursLabel.backgroundColor = [UIColor clearColor];
            hoursLabel.textColor = [UIColor colorWithRed:0.647 green:0.655 blue:0.667 alpha:1];
            hoursLabel.font = [UIFont fontWithName:@"OpenSans" size:10.640];
            hoursLabel.textAlignment = NSTextAlignmentCenter;
            hoursLabel.text = hoursString;
            [hoursLabel setNeedsDisplay];
            [self addSubview:hoursLabel];
            
            // align hoursLabel from the top
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-193.5-[hoursLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(hoursLabel)]];
            
            // width constraint
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[hoursLabel(==70)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(hoursLabel)]];
            
            // height constrain
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[hoursLabel(==10.5)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(hoursLabel)]];
            
            // align hoursLabel from the left
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-58.5-[hoursLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(hoursLabel)]];
        }
    }
}

- (void)callbackLoadOrgFromParse:(NSArray *)result {
    if (result) {
        [self setNeedsDisplay];
        NSString *clubString = [NSString stringWithFormat:@"%d Clubs", result.count];
        UILabel *clubsLabel = [[UILabel alloc] init];
        [clubsLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        clubsLabel.backgroundColor = [UIColor clearColor];
        clubsLabel.textColor = [UIColor colorWithRed:0.647 green:0.655 blue:0.667 alpha:1];
        clubsLabel.font = [UIFont fontWithName:@"OpenSans" size:10.640];
        clubsLabel.textAlignment = NSTextAlignmentCenter;
        clubsLabel.text = NSLocalizedString(clubString, nil);
        UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clubLink:)];
        [clubsLabel setUserInteractionEnabled:YES];
        [clubsLabel addGestureRecognizer:gesture];
        
        [self addSubview:clubsLabel];
        
        // align clubsLabel from the top
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-193.5-[clubsLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(clubsLabel)]];
        
        // align clubsLabel from the left
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-250-[clubsLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(clubsLabel)]];
        
        // width constraint
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[clubsLabel(==60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(clubsLabel)]];
        
        // height constraint
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[clubsLabel(==9)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(clubsLabel)]];
    }
}

- (void)callbackLoadOProfilePicFromParse:(NSArray *)result {
    if (result) {
        [self setNeedsDisplay];
        for (PFObject *object in result) {
            NSNumber *ogValue = object[@"totalHours"];
            NSLog(@"Val %@",ogValue);
            NSString *hoursString = [NSString stringWithFormat:@"%@ Hours", ogValue];
            UILabel *hoursLabel = [[UILabel alloc] init];
            [hoursLabel setNeedsDisplay];
            [hoursLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            hoursLabel.backgroundColor = [UIColor clearColor];
            hoursLabel.textColor = [UIColor colorWithRed:0.647 green:0.655 blue:0.667 alpha:1];
            hoursLabel.font = [UIFont fontWithName:@"OpenSans" size:10.640];
            hoursLabel.textAlignment = NSTextAlignmentCenter;
            hoursLabel.text = hoursString;
            [hoursLabel setNeedsDisplay];
            [self addSubview:hoursLabel];
            
            // align hoursLabel from the top
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-193.5-[hoursLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(hoursLabel)]];
            
            // width constraint
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[hoursLabel(==70)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(hoursLabel)]];
            
            // height constrain
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[hoursLabel(==10.5)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(hoursLabel)]];
            
            // align hoursLabel from the left
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-58.5-[hoursLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(hoursLabel)]];
        }
    }
}

-(void)clubLink:(id)sender {
    ClubsListVC *lvc = [[ClubsListVC alloc] init];
    lvc.data = self.user;
    UINavigationController *navl = [[UINavigationController alloc] initWithRootViewController:lvc];
    [[self currentTopViewController] presentViewController:navl animated:YES completion:nil];
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
