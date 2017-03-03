//
//  OrganizationViewController.h
//  VolunTree
//
//  Created by Pradyumn Nukala on 12/30/15.
//  Copyright © 2015 HelpOut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Data.h"
#import <Parse/Parse.h>

@interface OrganizationViewController : UITableViewController

@property (nonatomic,strong) PFObject *object;
@property (nonatomic,strong) NSArray *posts;
@property (nonatomic,strong) OrganizationHeaderView *header;
@property (nonatomic,strong) UIButton *heartButton;

@end
