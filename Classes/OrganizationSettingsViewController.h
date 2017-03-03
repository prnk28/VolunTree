//
//  OrganizationSettingsViewController.h
//  VolunTree
//
//  Created by Pradyumn Nukala on 1/18/16.
//  Copyright © 2016 HelpOut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMPopupItem.h"
#import <Parse/Parse.h>

@interface OrganizationSettingsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong,nonatomic)  PFObject *organization;
@property (strong, nonatomic) NSArray *members;

@end
