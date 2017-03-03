//
//  OrganizationHeaderView.h
//  VolunTree
//
//  Created by Pradyumn Nukala on 12/30/15.
//  Copyright © 2015 HelpOut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>

@interface OrganizationHeaderView : UIView

- (id)initWithFrame:(CGRect)frame withDictionary:(PFObject *)dict;
@property (strong,nonatomic) UIButton *profileImage;
@property (strong,nonatomic) NSString *name;
@property (strong, nonatomic) PFObject *obj;
@property (strong, nonatomic) UIButton *JoinButton;

@end
