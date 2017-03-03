//
//  ForgetPassVC.h
//  VolunTree
//
//  Created by Pradyumn Nukala on 6/20/16.
//  Copyright © 2016 HelpOut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Data.h"

@interface ForgetPassVC : UIViewController <UITextFieldDelegate> {
    UITextField *fullNameBox;
    UIScrollView *scrollView;
    JFMinimalNotification *notif;
}


@end
