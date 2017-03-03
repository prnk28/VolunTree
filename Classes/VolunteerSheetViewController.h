//
//  VolunteerSheetViewController.h
//  VolunTree
//
//  Created by Pradyumn Nukala on 12/5/15.
//  Copyright © 2015 HelpOut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface VolunteerSheetViewController : UIViewController

@property (strong) PFObject *object;
@property (strong, nonatomic) UIScrollView *scrollView;

@end
