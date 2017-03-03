//
//  FacebookViewController.m
//  VolunTree
//
//  Created by Pradyumn Nukala on 7/12/16.
//  Copyright © 2016 HelpOut. All rights reserved.
//

#import "FacebookViewController.h"
#import "UIViewController+MaryPopin.h"

@interface FacebookViewController ()

@end

@implementation FacebookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UserNameTextFieldBG = [[UITextField alloc] init];
    [UserNameTextFieldBG setTranslatesAutoresizingMaskIntoConstraints:NO];
    [UserNameTextFieldBG setBackground:[UIImage imageNamed:@"UserNameTextFieldBG"]];
    [UserNameTextFieldBG setPlaceholder:@"  Select a username to continue."];
    [UserNameTextFieldBG setFont:[UIFont fontWithName:@"OpenSans-Regular" size:5.5]];
    UserNameTextFieldBG.autocorrectionType = UITextAutocorrectionTypeNo;
    UserNameTextFieldBG.returnKeyType = UIReturnKeyGo;
    UserNameTextFieldBG.autocapitalizationType = UITextAutocapitalizationTypeNone;
    UserNameTextFieldBG.delegate = self;
    [self.view addSubview:UserNameTextFieldBG];
    
    [UserNameTextFieldBG autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    [UserNameTextFieldBG autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [UserNameTextFieldBG autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    [UserNameTextFieldBG autoSetDimension:ALDimensionHeight toSize:50];

}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == UserNameTextFieldBG) {
        [self setNewUserName];
        [UserNameTextFieldBG resignFirstResponder];
    }
    return YES;
}

- (void)setNewUserName {
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:UserNameTextFieldBG.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects.count>0) {
            notif = [JFMinimalNotification notificationWithStyle:JFMinimalNotificationStyleError title:@"Error" subTitle:@"That username is taken"];
            UIFont* titleFont = [UIFont fontWithName:@"OpenSans-Regular" size:22];
            [notif setTitleFont:titleFont];
            UIFont* subTitleFont = [UIFont fontWithName:@"OpenSans-Light" size:16];
            [notif setSubTitleFont:subTitleFont];
            [self.parentViewController.view addSubview:notif];
            [notif show];
            [NSTimer scheduledTimerWithTimeInterval:2.5
                                             target:self
                                           selector:@selector(hideNotif:)
                                           userInfo:nil
                                            repeats:NO];

        }else{
            [[PFUser currentUser] setObject:UserNameTextFieldBG.text forKey:@"username"];
            
            [[PFUser currentUser]saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }
    }];
}

-(void)hideNotif:(id)sender {
    [notif dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
