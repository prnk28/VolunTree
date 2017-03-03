//
//  OrganizationDetailHeaderView.m
//  VolunTree
//
//  Created by Pradyumn Nukala on 1/9/16.
//  Copyright © 2016 HelpOut. All rights reserved.
//

#import "OrganizationDetailHeaderView.h"
#import "Data.h"

@implementation OrganizationDetailHeaderView {
    UILabel *likeLabel;
}
@synthesize heartButton;

-(id)baseInitWithDictionary:(PFObject *)data {
    self.obj = data;
    NSLog(@"Header Data: %@", data);
#pragma mark - Line
    UIImageView *profileCellLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profileCellLine"]];
    [profileCellLine setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:profileCellLine];
    
    [profileCellLine autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [profileCellLine autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [profileCellLine autoPinEdgeToSuperviewEdge:ALEdgeRight];
    
#pragma mark - Profile Pic
    UIButton *profilePic = [[UIButton alloc] init];
    PFUser *user = data[@"author"];
    PFFile *thumbnail = [user objectForKey:@"profilePicture"];
    NSData *imageData = [thumbnail getData];
    UIImage *image = [UIImage imageWithData:imageData];
    
    if (imageData == nil) {
        [profilePic setImage:[UIImage imageNamed:@"profilePic"]
                    forState:UIControlStateNormal];
    }else{
        [profilePic setImage:image forState:UIControlStateNormal];
        profilePic.layer.cornerRadius = 23.0;
        profilePic.clipsToBounds = YES;
    }
    
    [profilePic setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:profilePic];
    
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
    titleLabel.text = [user objectForKey:@"fullName"];
    [titleLabel setNeedsDisplay];
    [self addSubview:titleLabel];
    
    [titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:70.0];
    [titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:13.0];
    
#pragma mark - Hours Label
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
    hoursLabel.text = [data objectForKey:@"status"];
    [hoursLabel setNeedsDisplay];
    [self addSubview:hoursLabel];
    
    [hoursLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:70.0];
    [hoursLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:titleLabel withOffset:1];
    [hoursLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    
#pragma mark - Heart Button
    heartButton = [[UIButton alloc] init];
    [heartButton setImage:[UIImage imageNamed:@"heartButton"]
                 forState:UIControlStateNormal];
    [heartButton setImage:[UIImage imageNamed:@"heartButtonSelected"]
                 forState:UIControlStateSelected];
    [heartButton addTarget:self action:@selector(heartButton:) forControlEvents:UIControlEventTouchDown];
    [heartButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:heartButton];
    
    PFQuery *query = [PFQuery queryWithClassName:@"OrganizationLike"];
    [query whereKey:@"Post" equalTo:data];
    [query whereKey:@"liker" equalTo:[PFUser currentUser]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (!object) {
            heartButton.selected = NO;
        }else{
            heartButton.selected = YES;
        }
    }];
    
    [heartButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:80];
    [heartButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:7.0];
    [heartButton autoSetDimension:ALDimensionHeight toSize:15];
    [heartButton autoSetDimension:ALDimensionWidth toSize:16];
    
#pragma mark - Comment Button
    UIButton *commentButton = [[UIButton alloc] init];
    [commentButton setImage:[UIImage imageNamed:@"comment"]
                   forState:UIControlStateNormal];
    
    [commentButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:commentButton];
    
    [commentButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:80];
    [commentButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:7.0];
    [commentButton autoSetDimension:ALDimensionHeight toSize:15];
    [commentButton autoSetDimension:ALDimensionWidth toSize:16];
    
    PFQuery *cquery = [PFQuery queryWithClassName:@"OrganizationComment"];
    [cquery whereKey:@"post" equalTo:data];
    [cquery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects.count>0) {
            UILabel *commentLabel = [[UILabel alloc] init];
            [commentLabel setNeedsDisplay];
            [commentLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            commentLabel.backgroundColor = [UIColor clearColor];
            commentLabel.textColor = [UIColor colorWithRed:0.643 green:0.655 blue:0.667 alpha:1];
            commentLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:8.881];
            commentLabel.textAlignment = NSTextAlignmentCenter;
            commentLabel.text = [NSString stringWithFormat:@"%lu", objects.count];
            [commentLabel setNeedsDisplay];
            [self addSubview:commentLabel];
            
            [commentLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:commentButton withOffset:0];
            [commentLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:commentButton withOffset:3];
        }
    }];
    
#pragma mark - Line
    UIImageView *CellLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profileCellLine"]];
    [CellLine setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:CellLine];
    
    [CellLine autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [CellLine autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [CellLine autoPinEdgeToSuperviewEdge:ALEdgeRight];

    return self;
}

- (void)heartButton:(UIButton*)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        PFQuery *query = [PFQuery queryWithClassName:@"OrganizationLike"];
        [query whereKey:@"Post" equalTo:self.obj];
        [query whereKey:@"liker" equalTo:[PFUser currentUser]];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if (!object) {
                PFObject *like = [PFObject objectWithClassName:@"OrganizationLike"];
                like[@"liker"] = [PFUser currentUser];
                like[@"Post"] = self.obj;
                [like saveInBackground];
            }
        }];
    } else {
        PFQuery *query = [PFQuery queryWithClassName:@"OrganizationLike"];
        [query whereKey:@"Post" equalTo:self.obj];
        [query whereKey:@"liker" equalTo:[PFUser currentUser]];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            [object deleteInBackground];
        }];
    }
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

@end
