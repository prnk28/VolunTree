//
//  UsersViewController.h
//  VolunTree
//
//  Created by Pradyumn Nukala on 11/9/15.
//  Copyright © 2015 HelpOut. All rights reserved.
//



@interface UsersViewController : UITableViewController <XLFormRowDescriptorViewController, XLFormRowDescriptorPopoverViewController>

@property BOOL isSearchResultsController;
@property NSLayoutConstraint *topConstraint;

@end