//
//  OrganizationDetailHeaderView.h
//  VolunTree
//
//  Created by Pradyumn Nukala on 1/9/16.
//  Copyright © 2016 HelpOut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface OrganizationDetailHeaderView : UIView

@property (nonatomic,strong) UIButton *heartButton;
- (id)initWithFrame:(CGRect)frame withDictionary:(PFObject *)data;
@property (nonatomic,strong) PFObject *obj;

@end
