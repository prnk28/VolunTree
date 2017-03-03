//
//  GivenRequestsViewController.h
//  VolunTree
//
//  Created by Pradyumn Nukala on 7/25/16.
//  Copyright © 2016 HelpOut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface GivenRequestsViewController : UITableViewController

@property (strong,nonatomic) NSArray *objects;
@property (strong,nonatomic) PFObject *data;

@end
