//
//  ProvideViewController.h
//  VolunTree
//
//  Created by Pradyumn Nukala on 7/25/16.
//  Copyright © 2016 HelpOut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFMinimalNotification.h"
#import <Parse/Parse.h>

@interface ProvideViewController : UIViewController {
        JFMinimalNotification *notif;
    
    UIScrollView *scrollView;
}

@property (strong, nonatomic) PFObject *object;

@end
