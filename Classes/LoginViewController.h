//
//  LoginViewController.h
//  
//
//  Created by Pradyumn Nukala on 8/28/15.
//
//


#import <UIKit/UIKit.h>
#import "SignupViewController.h"
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "JBKenBurnsView.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate, KenBurnsViewDelegate> {
    UITextField *passwordField;
    UITextField *UserNameTextFieldBG;
}

@property (nonatomic, strong) JBKenBurnsView *kenView;

@end
