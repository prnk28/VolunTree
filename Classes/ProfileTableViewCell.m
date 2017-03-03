//
//  ProfileTableViewCell.m
//  HelpOut
//
//  Created by Pradyumn Nukala on 10/14/15.
//  Copyright © 2015 HelpOut. All rights reserved.
//

#import "ProfileTableViewCell.h"

@implementation ProfileTableViewCell

-(id)init {
    self =  [super init];
    if(self) {
        // UI Setup
        UIImageView *profileCellLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profileCellLine"]];
        [profileCellLine setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:profileCellLine];
        
        [profileCellLine autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:1.0];
        [profileCellLine autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [profileCellLine autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        
#pragma mark - Arrow Button
        UIButton *arrowRight = [UIButton buttonWithType:UIButtonTypeCustom];
        [arrowRight setTranslatesAutoresizingMaskIntoConstraints:NO];
        [arrowRight setBackgroundImage:[UIImage imageNamed:@"arrowRight"] forState:UIControlStateNormal];
        [self.contentView addSubview:arrowRight];
        
        // align arrowRight and superview to right
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:arrowRight attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
        
        // align arrowRight from the top
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-35-[arrowRight]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(arrowRight)]];
        
        // width constraint
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[arrowRight(==26)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(arrowRight)]];
        
        // height constraint
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[arrowRight(==26)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(arrowRight)]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
