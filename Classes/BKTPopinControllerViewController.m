//
// The MIT License (MIT)
//
// Copyright (c) 2013 Backelite
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "BKTPopinControllerViewController.h"
#import "Data.h"
#import "UIViewController+MaryPopin.h"

@interface BKTPopinControllerViewController ()

- (IBAction)closeButtonPressed:(id)sender;

@end

@implementation BKTPopinControllerViewController

- (IBAction)closeButtonPressed:(id)sender {
    [self.presentingPopinViewController dismissCurrentPopinControllerAnimated:YES completion:^{
        NSLog(@"Popin dismissed !");
    }];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    UserNameTextFieldBG = [[UITextField alloc] init];
    [UserNameTextFieldBG setTranslatesAutoresizingMaskIntoConstraints:NO];
    [UserNameTextFieldBG setBackground:[UIImage imageNamed:@"UserNameTextFieldBG"]];
    [UserNameTextFieldBG setPlaceholder:@"  Username"];
    [UserNameTextFieldBG setFont:[UIFont fontWithName:@"OpenSans-Regular" size:5.5]];
    UserNameTextFieldBG.autocorrectionType = UITextAutocorrectionTypeNo;
    UserNameTextFieldBG.returnKeyType = UIReturnKeyNext;
    UserNameTextFieldBG.autocapitalizationType = UITextAutocapitalizationTypeNone;
    UserNameTextFieldBG.delegate = self;
    [self.view addSubview:UserNameTextFieldBG];
    
    passwordField = [[UITextField alloc] init];
    [passwordField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [passwordField setBackground:[UIImage imageNamed:@"UserNameTextFieldBG"]];
    [passwordField setPlaceholder:@"  Password"];
    [passwordField setFont:[UIFont fontWithName:@"OpenSans-Regular" size:5.5]];
    passwordField.secureTextEntry = YES;
    passwordField.returnKeyType = UIReturnKeyDone;
    passwordField.delegate = self;
    [self.view addSubview:passwordField];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"loginButton"] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonTapped:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:loginButton];
    
    UILabel *forgotLabel = [[UILabel alloc] init];
    forgotLabel.userInteractionEnabled = YES;
    [forgotLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    forgotLabel.backgroundColor = [UIColor clearColor];
    forgotLabel.textColor = [UIColor redColor];
    forgotLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
    forgotLabel.text = NSLocalizedString(@"Forgot Password", nil);
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgotPassTapped:)];
    [forgotLabel addGestureRecognizer:singleTap];
    [self.view addSubview:forgotLabel];
    
    [forgotLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [forgotLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:loginButton withOffset:10];
    
    // Constrain Password
    
    // center passwordField horizontally in superview
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:passwordField attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
    // align passwordField from the top
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-162.5-[passwordField]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(passwordField)]];
    
    // align passwordField from the left and right
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-28.5-[passwordField]-28.5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(passwordField)]];
    
    // width constraint
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[passwordField(==263)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(passwordField)]];
    
    // height constraint
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[passwordField(==41.5)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(passwordField)]];
    
    // Constrain Username
    
    // center UserNameTextFieldBG horizontally in superview
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:UserNameTextFieldBG attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
    // align UserNameTextFieldBG from the top
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-115.5-[UserNameTextFieldBG]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(UserNameTextFieldBG)]];
    
    // align UserNameTextFieldBG from the left and right
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-28.5-[UserNameTextFieldBG]-28.5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(UserNameTextFieldBG)]];
    
    // width constraint
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[UserNameTextFieldBG(==263)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(UserNameTextFieldBG)]];
    
    // height constraint
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[UserNameTextFieldBG(==41.5)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(UserNameTextFieldBG)]];
    
    // Constrain Login Button
    
    // center loginButton horizontally in superview
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:loginButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
    // align loginButton from the top
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-209.5-[loginButton]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(loginButton)]];
    
    // align loginButton from the left and right
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-28.5-[loginButton]-28.5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(loginButton)]];
    
    // width constraint
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[loginButton(==263)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(loginButton)]];
    
    // height constraint
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[loginButton(==43)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(loginButton)]];
}

- (void)loginButtonTapped:(id)sender {
    NSLog(@"Username - %@",UserNameTextFieldBG.text);
    NSLog(@"Password - %@",passwordField.text);
    
    [PFUser logInWithUsernameInBackground:[UserNameTextFieldBG.text lowercaseString] password:passwordField.text
                                    block:^(PFUser *user, NSError *error) {
                                        if ([PFUser currentUser]) {
                                            NSLog(@"%@", [PFUser currentUser]);
                                            [self dismissViewControllerAnimated:YES completion:nil];
                                        } else {
                                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error" message:@"Credentials provided were incorrect. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                            [alert show];
                                        }
                                    }];
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == passwordField) {
        [self loginButtonTapped:nil];
        [passwordField resignFirstResponder];
    } else if (theTextField == UserNameTextFieldBG) {
        [passwordField becomeFirstResponder];
    }
    return YES;
}


- (void)forgotPassTapped:(id)sender {
        ForgetPassVC *fpvc = [[ForgetPassVC alloc] init];
        [self.navigationController pushViewController:fpvc animated:YES];
}

@end
