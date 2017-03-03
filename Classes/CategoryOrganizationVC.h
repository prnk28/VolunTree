//
//  SearchViewController.h
//  ParseSearchNoPagination
//
//  Created by Wazir on 7/16/13.
//  Copyright (c) 2013 Wazir. All rights reserved.
//

#import "Data.h"
#import <QuartzCore/QuartzCore.h>
#import <ParseUI/ParseUI.h>
#import "XLFormRowDescriptor.h"

@interface CategoryOrganizationVC : UITableViewController <XLFormRowDescriptorViewController, XLFormRowDescriptorPopoverViewController>

@property(nonatomic,strong) NSArray *objects;

@end