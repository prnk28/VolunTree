//
//  SignupViewController.h
//  
//
//  Created by Pradyumn Nukala on 8/29/15.
//
//

#import <UIKit/UIKit.h>
#import "Data.h"

@interface SignupViewController : UIViewController <UITextFieldDelegate> {
    PNTextField *fullNameBox;
    PNTextField *usernameBox;
    PNTextField *emailBox;
    PNTextField *passwordBox;
    UIImageView *strengthOne;
    UIImageView *strengthTwo;
    UIImageView *strengthThree;
    UIImageView *strengthFour;
    PNTextField *confirmPasswordBox;
    UIButton *submitButton;
}

@property (strong, nonatomic) NSDictionary *facebookData;
@property (strong, nonatomic) PFUser *user;

@end
