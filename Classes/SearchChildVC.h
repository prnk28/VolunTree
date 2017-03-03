//
//  SearchChildVC.h
//  VolunTree
//
//  Created by Pradyumn Nukala on 6/13/16.
//  Copyright © 2016 HelpOut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Data.h"

@interface SearchChildVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *results;

@end
