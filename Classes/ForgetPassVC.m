//
//  ForgetPassVC.m
//  VolunTree
//
//  Created by Pradyumn Nukala on 6/20/16.
//  Copyright © 2016 HelpOut. All rights reserved.
//

#import "ForgetPassVC.h"

@implementation ForgetPassVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [self setUpUI];
    
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    [scrollView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [scrollView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [scrollView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [scrollView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    
#pragma mark - Create Label
    UILabel *createLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    [createLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    createLabel.backgroundColor = [UIColor clearColor];
    createLabel.textColor = [UIColor colorWithRed:0.392 green:0.412 blue:0.424 alpha:1];
    createLabel.font = [UIFont fontWithName:@"OpenSans" size:20.375];
    createLabel.text = NSLocalizedString(@"Find your account", nil);
    
    [scrollView addSubview:createLabel];
    
    // align createLabel from the top and bottom
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-93-[createLabel]-455.5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(createLabel)]];
    
    // align createLabel from the left and right
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-28-[createLabel]-110.5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(createLabel)]];
    
    // width constraint
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[createLabel(==200.5)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(createLabel)]];
    
    // height constraint
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[createLabel(==22.5)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(createLabel)]];
    
#pragma mark - Description Label
    UILabel *descriptionLabel = [[UILabel alloc] init];
    [descriptionLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    descriptionLabel.backgroundColor = [UIColor clearColor];
    descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.adjustsFontSizeToFitWidth = NO;
    descriptionLabel.textColor = [UIColor colorWithRed:0.643 green:0.655 blue:0.667 alpha:1];
    descriptionLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:10.188];
    descriptionLabel.text = NSLocalizedString(@"Please insert your email address. You will be sent an email to reset your password.", nil);
    
    [scrollView addSubview:descriptionLabel];
    
    [descriptionLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:createLabel withOffset:8];
    [descriptionLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:28.5];
    [descriptionLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:39];
    
#pragma mark - Full Name Text Box
    fullNameBox = [[UITextField alloc] init];
    [fullNameBox setTranslatesAutoresizingMaskIntoConstraints:NO];
    [fullNameBox setBackground:[UIImage imageNamed:@"registerTextField"]];
    [fullNameBox setPlaceholder:@"  Email Address"];
    [fullNameBox setFont:[UIFont fontWithName:@"OpenSans-Light" size:16.5]];
    fullNameBox.autocorrectionType = UITextAutocorrectionTypeNo;
    fullNameBox.delegate = self;
    fullNameBox.returnKeyType = UIReturnKeySend;
    fullNameBox.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [scrollView addSubview:fullNameBox];
    
    // center fullNameBox horizontally in superview
    [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:fullNameBox attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
    // align fullNameBox from the top and bottom
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-155.5-[fullNameBox]-356.5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(fullNameBox)]];
    
    // align fullNameBox from the left and right
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-25-[fullNameBox]-25.5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(fullNameBox)]];
    
    // width constraint
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[fullNameBox(==269.5)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(fullNameBox)]];
    
    // height constraint
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[fullNameBox(==50)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(fullNameBox)]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [self popForward];
    [theTextField resignFirstResponder];
    return YES;
}

- (void)submitButtonTapped:(id)sender {
    [self popForward];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setUpUI{
    // Back Button
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [barButton setTitle:@"" forState:UIControlStateNormal];
    [barButton setBackgroundImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [barButton addTarget:self action:@selector(popBack:) forControlEvents:UIControlEventTouchUpInside];
    barButton.frame = CGRectMake(0.0f, 0.0f, 10.0f, 15.0f);
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    // Set Title
    self.navigationItem.title = @"Oops..";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"OpenSans-Semibold" size:18]}];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [scrollView endEditing:YES];
}

- (void)popForward {
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"email" equalTo:fullNameBox.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count == 0) {
                notif = [JFMinimalNotification notificationWithStyle:JFMinimalNotificationStyleError title:@"Error" subTitle:@"The given email was not found."];
                UIFont* titleFont = [UIFont fontWithName:@"OpenSans-Regular" size:22];
                [notif setTitleFont:titleFont];
                UIFont* subTitleFont = [UIFont fontWithName:@"OpenSans-Light" size:16];
                [notif setSubTitleFont:subTitleFont];
                [scrollView addSubview:notif];
                [notif show];
                [NSTimer scheduledTimerWithTimeInterval:2.5
                                                 target:self
                                               selector:@selector(hideNotif:)
                                               userInfo:nil
                                                repeats:NO];

            } else {
                [PFUser requestPasswordResetForEmailInBackground:fullNameBox.text target:self selector:@selector(forgotPassMethod)];
                [scrollView endEditing:YES];
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    

}

-(void)forgotPassMethod {
    notif = [JFMinimalNotification notificationWithStyle:JFMinimalNotificationStyleSuccess title:@"Success" subTitle:@"Check your inbox for further details."];
    UIFont* titleFont = [UIFont fontWithName:@"OpenSans-Regular" size:22];
    [notif setTitleFont:titleFont];
    UIFont* subTitleFont = [UIFont fontWithName:@"OpenSans-Light" size:16];
    [notif setSubTitleFont:subTitleFont];
    [scrollView addSubview:notif];
    [notif show];
    [NSTimer scheduledTimerWithTimeInterval:2.5
                                     target:self
                                   selector:@selector(hideNotif:)
                                   userInfo:nil
                                    repeats:NO];

}

-(void)hideNotif:(id)sender {
    [notif dismiss];
}

- (void)popBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
