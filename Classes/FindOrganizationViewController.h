//
//  FindOrganizationViewController.h
//  VolunTree
//
//  Created by Pradyumn Nukala on 1/4/16.
//  Copyright © 2016 HelpOut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <ParseUI/ParseUI.h>
#import "Data.h"

@interface FindOrganizationViewController : PFQueryTableViewController <UISearchBarDelegate, XLFormRowDescriptorViewController, XLFormRowDescriptorPopoverViewController>

@end
