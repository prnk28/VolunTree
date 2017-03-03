//
//  OrganizationHeaderView.m
//  VolunTree
//
//  Created by Pradyumn Nukala on 12/30/15.
//  Copyright © 2015 HelpOut. All rights reserved.
//

#import "OrganizationHeaderView.h"
#import "Data.h"

@implementation OrganizationHeaderView

-(id)baseInitWithDictionary:(PFObject *)dict {
    self.name = dict[@"Name"];
    self.obj = dict;
#pragma mark - Profile Header
    UIImageView *profileHeader = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 800, 200)];
    profileHeader.image = [UIImage imageNamed:@"organizationHeader"];
    profileHeader.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:profileHeader];
    
#pragma mark - Profile Image
    PFFile *thumbnail = [dict objectForKey:@"image"];
    NSData *imageData = [thumbnail getData];
    UIImage *image = [UIImage imageWithData:imageData];
    
    UIButton *profileImage = [[UIButton alloc] init];
    
    if (imageData == nil) {
        [profileImage setImage:[UIImage imageNamed:@"profilePicture"] forState:UIControlStateNormal];
    }else{
        [profileImage setImage:image forState:UIControlStateNormal];
    }
    
    profileImage.layer.cornerRadius= 50.0;
    profileImage.clipsToBounds = YES;
    [profileImage addTarget:self action:@selector(openCamera) forControlEvents:UIControlEventTouchDown];
    [profileImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    profileImage.userInteractionEnabled = YES;
    [self addSubview:profileImage];
    
    [profileImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:13];
    [profileImage autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [profileImage autoSetDimension:ALDimensionWidth toSize:104.5];
    [profileImage autoSetDimension:ALDimensionHeight toSize:100];
    
#pragma mark - Shadow
    UIImageView *shadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow"]];
    [shadow setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:shadow];
    
    [shadow autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:127.5];
    [shadow autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [shadow autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    
#pragma mark - Join Button
    self.JoinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.JoinButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.JoinButton setImage:[UIImage imageNamed:@"JoinButton"] forState:UIControlStateNormal];
    [self.JoinButton setImage:[UIImage imageNamed:@"joinedButton"] forState:UIControlStateSelected];
    PFQuery *query = [PFQuery queryWithClassName:@"Organizations"];
    [query whereKey:@"objectId" equalTo:self.obj.objectId];
    [query whereKey:@"members" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects.count == 0) {
            self.JoinButton.selected = NO;
        }else{
            self.JoinButton.selected = YES;
        }
    }];
    [self.JoinButton addTarget:self action:@selector(didTapJoin:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self.JoinButton];
    
    [self.JoinButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15];
    [self.JoinButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
    
#pragma mark - Motto
    UILabel *username = [[UILabel alloc] init];
    [username setTranslatesAutoresizingMaskIntoConstraints:NO];
    username.backgroundColor = [UIColor clearColor];
    username.textColor = [UIColor colorWithRed:0.984 green:0.987 blue:0.992 alpha:1];
    username.font = [UIFont fontWithName:@"OpenSans" size:18.111];
    username.textAlignment = NSTextAlignmentCenter;
    NSString *mottoString = [dict objectForKey:@"motto"];
    if ([mottoString isEqual:nil]) {
        NSString *motto = @"";
        username.text = motto;
    }else{
        NSString *motto = [NSString stringWithFormat:@"\"%@\"\n\r",[dict objectForKey:@"motto"]];
        NSLog(@"Motto: %@",motto);
        NSLog(@"Dictionary: %@",dict);
        username.text = motto;
    }
    
    [self addSubview:username];
    
    [username autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:profileImage withOffset:20];
    [username autoAlignAxis:ALAxisVertical toSameAxisOfView:profileImage];
    
#pragma mark - Members
    PFRelation *relation = [self.obj relationForKey:@"members"];
    [[relation query] countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        NSLog(@"int %d", number);
        NSString *inStr = [NSString stringWithFormat: @"%d", number];
        UILabel *fullName = [[UILabel alloc] init];
        [fullName setTranslatesAutoresizingMaskIntoConstraints:NO];
        fullName.backgroundColor = [UIColor clearColor];
        fullName.textColor = [UIColor colorWithRed:0.984 green:0.987 blue:0.992 alpha:1];
        fullName.font = [UIFont fontWithName:@"OpenSans-Light" size:12.451];
        fullName.textAlignment = NSTextAlignmentCenter;
        fullName.text = [NSString stringWithFormat:@"%@ Member(s)",inStr];
        
        [self addSubview:fullName];
        
        [fullName autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:username withOffset:-2];
        [fullName autoAlignAxis:ALAxisVertical toSameAxisOfView:username];
    }];
    
    
    return self;
}

- (id)initWithFrame:(CGRect)frame withDictionary:(PFObject *)dict
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInitWithDictionary:dict];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder withDictionary:(PFObject *)dict {
    if ((self = [super initWithCoder:aDecoder])) {
        [self baseInitWithDictionary:dict];
    }
    return self;
}

- (void)openCamera {
    PFQuery *adminQuery = [PFQuery queryWithClassName:@"Admins"];
    [adminQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    [adminQuery whereKey:@"organization" equalTo:self.obj];
    [adminQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects.count>0) {
            YCameraViewController *camController = [[YCameraViewController alloc] initWithNibName:@"YCameraViewController" bundle:nil];
            camController.delegate=self;
            UIViewController *pvc = [self currentTopViewController];
            [pvc presentViewController:camController animated:YES completion:^{
                // completion code
            }];
        }else{

        }
    }];

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

- (void)didTapJoin:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Organizations"];
    [query whereKey:@"objectId" equalTo:self.obj.objectId];
    [query whereKey:@"members" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects.count == 0) {
            PFRelation *relation = [self.obj relationForKey:@"members"];
            [relation addObject:[PFUser currentUser]];
            [self.obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"User Has Joined");
                    [self addFriends];
                    self.JoinButton.selected = YES;
                } else {
                    NSLog(@"Error: %@",error.description);
                }
            }];
        } else {
            PFRelation *relation = [self.obj relationForKey:@"members"];
            [relation removeObject:[PFUser currentUser]];
            [self.obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"User Has Left");
                    self.JoinButton.selected = NO;
                } else {
                    NSLog(@"Error: %@",error.description);
                }
            }];
        }
    }];
}

- (void)addFriends {
    PFRelation *members = [self.obj relationForKey:@"members"];
    PFQuery *query = [members query];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        for (PFUser *user in objects) {
            PFObject *follow = [PFObject objectWithClassName:@"Follow"];
            [follow setObject:[PFUser currentUser]  forKey:@"from"];
            [follow setObject:user forKey:@"to"];
            [follow saveInBackground];
        }
    }];
}

- (void)didFinishPickingImage:(UIImage *)image{
    // Use image as per your need
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Organizations"];
    [query whereKey:@"Name" equalTo:self.name];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                NSData *imageData = UIImagePNGRepresentation(image);
                PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
                [imageFile saveInBackground];
                
                [object setObject:imageFile forKey:@"image"];
                [object saveInBackground];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void)yCameraControllerdidSkipped{
    // Called when user clicks on Skip button on YCameraViewController view
}
-(void)yCameraControllerDidCancel{
    // Called when user clicks on "X" button to close YCameraViewController
}

@end
