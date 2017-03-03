//
//  OrganizationPostCell.m
//  VolunTree
//
//  Created by Pradyumn Nukala on 6/24/16.
//  Copyright © 2016 HelpOut. All rights reserved.
//

#import "OrganizationPostCell.h"
#import "UIColor+TreeColor.h"

@implementation OrganizationPostCell
@synthesize heartButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withObject:(PFObject *)data
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.data = data;
#pragma mark - Line
        UIImageView *profileCellLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profileCellLine"]];
        [profileCellLine setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:profileCellLine];
        
        [profileCellLine autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [profileCellLine autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [profileCellLine autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
#pragma mark - Profile Pic
        UIButton *profilePic = [[UIButton alloc] init];
        PFUser *user = data[@"author"];
        [user fetchIfNeeded];
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
        [self.contentView addSubview:profilePic];
        
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
        [self.contentView addSubview:titleLabel];
        
        [titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:70.0];
        [titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:13.0];
        
#pragma mark - Details Label
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
        [self.contentView addSubview:hoursLabel];
        
        [hoursLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:70.0];
        [hoursLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:titleLabel withOffset:1];
        [hoursLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        
#pragma mark - Heart Button
        heartButton = [[UIButton alloc] init];
        [heartButton setImage:[UIImage imageNamed:@"heartButton"]
                     forState:UIControlStateNormal];
        [heartButton setImage:[UIImage imageNamed:@"heartButtonSelected"]
                     forState:UIControlStateSelected];
        dispatch_async(dispatch_get_main_queue(), ^ {
            PFQuery *query = [PFQuery queryWithClassName:@"OrganizationLike"];
            [query whereKey:@"Post" equalTo:data];
            [query whereKey:@"liker" equalTo:[PFUser currentUser]];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                if (object) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [heartButton setSelected:YES];
                        [self setNeedsDisplay];
                    });
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [heartButton setSelected:NO];
                        [self setNeedsDisplay];
                    });
                    
                }
            }];
        });
        [heartButton addTarget:self action:@selector(heartButton:) forControlEvents:UIControlEventTouchDown];
        [heartButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:heartButton];
        
        
        [heartButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:80];
        [heartButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:7.0];
        [heartButton autoSetDimension:ALDimensionHeight toSize:15];
        [heartButton autoSetDimension:ALDimensionWidth toSize:16];
        
#pragma mark - Comment Button
        UIButton *commentButton = [[UIButton alloc] init];
        [commentButton setImage:[UIImage imageNamed:@"comment"]
                       forState:UIControlStateNormal];
        
        [commentButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:commentButton];
        
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
                [self.contentView addSubview:commentLabel];
                
                [commentLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:commentButton withOffset:0];
                [commentLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:commentButton withOffset:3];
            }
        }];
        
        PFQuery *lquery = [PFQuery queryWithClassName:@"OrganizationLike"];
        [lquery whereKey:@"Post" equalTo:data];
        [lquery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if (objects.count>0) {
                UILabel *likeLabel = [[UILabel alloc] init];
                [likeLabel setNeedsDisplay];
                [likeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
                likeLabel.backgroundColor = [UIColor clearColor];
                likeLabel.textColor = [UIColor colorWithRed:0.643 green:0.655 blue:0.667 alpha:1];
                likeLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:8.881];
                likeLabel.textAlignment = NSTextAlignmentCenter;
                likeLabel.text = [NSString stringWithFormat:@"%lu", objects.count];
                [likeLabel setNeedsDisplay];
                [self.contentView addSubview:likeLabel];
                
                [likeLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:heartButton withOffset:0];
                [likeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:heartButton withOffset:3];
            }
        }];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [heartButton setSelected:NO];
}

- (void)heartButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        PFQuery *query = [PFQuery queryWithClassName:@"OrganizationLike"];
        [query whereKey:@"Post" equalTo:self.data];
        [query whereKey:@"liker" equalTo:[PFUser currentUser]];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if (!object) {
                PFObject *like = [PFObject objectWithClassName:@"OrganizationLike"];
                like[@"liker"] = [PFUser currentUser];
                like[@"Post"] = self.data;
                [like saveInBackground];
                [self setNeedsDisplay];
            }
        }];
    } else {
        PFQuery *query = [PFQuery queryWithClassName:@"OrganizationLike"];
        [query whereKey:@"Post" equalTo:self.data];
        [query whereKey:@"liker" equalTo:[PFUser currentUser]];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            [object deleteInBackground];
            [self setNeedsDisplay];
        }];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
