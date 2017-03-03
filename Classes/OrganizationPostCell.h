//
//  OrganizationPostCell.h
//  VolunTree
//
//  Created by Pradyumn Nukala on 6/24/16.
//  Copyright © 2016 HelpOut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Data.h"

@interface OrganizationPostCell : UITableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withObject:(PFObject *)data;
@property (nonatomic,strong) UIButton *heartButton;
@property (nonatomic,strong) PFObject *data;
@end
