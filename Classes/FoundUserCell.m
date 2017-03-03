//
//  FoundUserCell.m
//  ParseSearchNoPagination
//
//  Created by Pradyumn Nukala on 12/3/15.
//  Copyright © 2015 Wazir. All rights reserved.
//

#import "FoundUserCell.h"

@implementation FoundUserCell

@synthesize mainTitle = _mainTitle;
@synthesize detail = _detail;
@synthesize showImage = _showImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
