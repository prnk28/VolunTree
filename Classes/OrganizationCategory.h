//
//  OrganizationCategory.h
//  VolunTree
//
//  Created by Pradyumn Nukala on 7/20/16.
//  Copyright © 2016 HelpOut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Data.h"
@interface OrganizationCategory : NSObject {
    NSString *name;
    NSString *descriptionS;
    UIImage *image;
}

@property(strong,nonatomic) NSString *name;
@property(strong,nonatomic) NSString *descriptionS;
@property(strong,nonatomic) UIImage *image;

@end
