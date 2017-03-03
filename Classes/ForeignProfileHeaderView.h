//
//  ForeignProfileHeaderView.h
//  VolunTree
//
//  Created by Pradyumn Nukala on 6/20/16.
//  Copyright © 2016 HelpOut. All rights reserved.
//
#import "Data.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "YCameraViewController.h"
#import <Parse/Parse.h>

@interface ForeignProfileHeaderView : UIView 

-(id)baseInitWithDictionary:(NSDictionary *)dict;
- (id)initWithFrame:(CGRect)frame withDictionary:(PFUser *)dict;
@property (strong,nonatomic) NSString *email;
@property (strong,nonatomic) PFUser *user;

@end
