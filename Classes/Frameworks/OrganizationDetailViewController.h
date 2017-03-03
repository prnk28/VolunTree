//
//  OrganizationDetailViewController.h
//  VolunTree
//
//  Created by Pradyumn Nukala on 1/9/16.
//  Copyright © 2016 HelpOut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface OrganizationDetailViewController : UITableViewController <UITextFieldDelegate>

@property  (strong,nonatomic) PFObject *object;
@property  (strong,nonatomic) NSArray *comments;
@property  (strong,nonatomic) UITextField *field;
@property  (strong,nonatomic) UIView *footer;

@end
