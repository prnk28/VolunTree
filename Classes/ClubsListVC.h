//
//  ClubsListVC.h
//  VolunTree
//
//  Created by Pradyumn Nukala on 6/21/16.
//  Copyright © 2016 HelpOut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ClubsListVC : UITableViewController

@property (strong,nonatomic) NSArray *objects;
@property (strong,nonatomic) PFUser *data;

@end
