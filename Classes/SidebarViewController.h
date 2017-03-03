//
//  SidebarViewController.h
//  VolunTree
//
//  Created by Pradyumn Nukala on 12/15/15.
//  Copyright © 2015 HelpOut. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SidebarViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSArray *organizations;

@end
