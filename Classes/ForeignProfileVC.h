//
//  ForeignProfileVC.h
//  VolunTree
//
//  Created by Pradyumn Nukala on 6/20/16.
//  Copyright © 2016 HelpOut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForeignProfileHeaderView.h"

@interface ForeignProfileVC : UITableViewController
@property (strong) NSArray *objects;
@property (strong) PFUser *object;
@end
