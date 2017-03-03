//
//  FoundUserCell.h
//  ParseSearchNoPagination
//
//  Created by Pradyumn Nukala on 12/3/15.
//  Copyright © 2015 Wazir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface FoundUserCell : PFTableViewCell

@property (nonatomic, weak) IBOutlet UILabel *mainTitle;
@property (nonatomic, weak) IBOutlet UILabel *detail;
@property (nonatomic, weak) IBOutlet PFImageView *showImage;

@end
