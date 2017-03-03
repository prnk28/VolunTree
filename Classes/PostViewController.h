//
//  PostViewController.h
//  VolunTree
//
//  Created by Pradyumn Nukala on 1/3/16.
//  Copyright © 2016 HelpOut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface PostViewController : UIViewController

@property (strong,nonatomic) PFObject *organization;
@property (strong,nonatomic) UITextView *textView;

@end
