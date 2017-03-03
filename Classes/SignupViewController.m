//
//  SignupViewController.m
//
//
//  Created by Pradyumn Nukala on 8/29/15.
//
//

#import "SignupViewController.h"

@interface SignupViewController ()

@end

@implementation SignupViewController
@synthesize user;

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
    
#pragma mark - Submit Button
    submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    submitButton.enabled = NO;
    [submitButton setBackgroundImage:[UIImage imageNamed:@"submitButton"] forState:UIControlStateNormal];
    
    [submitButton addTarget:self action:@selector(submitButtonTapped:) forControlEvents:UIControlEventTouchDown];
    
#pragma mark - Create Label
    UILabel *createLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    [createLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    createLabel.backgroundColor = [UIColor clearColor];
    createLabel.textColor = [UIColor colorWithRed:0.392 green:0.412 blue:0.424 alpha:1];
    createLabel.font = [UIFont fontWithName:@"OpenSans" size:22];
    createLabel.text = NSLocalizedString(@"Create your account", nil);
    
    [self.view addSubview:createLabel];
    
    [createLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:50];
    [createLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:25];
    
#pragma mark - Description Label
    UILabel *descriptionLabel = [[UILabel alloc] init];
    [descriptionLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    descriptionLabel.backgroundColor = [UIColor clearColor];
    descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.adjustsFontSizeToFitWidth = NO;
    descriptionLabel.textColor = [UIColor colorWithRed:0.643 green:0.655 blue:0.667 alpha:1];
    descriptionLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
    descriptionLabel.text = NSLocalizedString(@"Input all your information to complete the VolunTree signup. You will be up and running in no time!", nil);
    
    [self.view addSubview:descriptionLabel];
    
    [descriptionLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:createLabel withOffset:10];
    [descriptionLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:25];
    [descriptionLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:25];
    
#pragma mark - Full Name Text Box
    fullNameBox = [[PNTextField alloc] init];
    [fullNameBox setTranslatesAutoresizingMaskIntoConstraints:NO];
    [fullNameBox setPlaceholder:@"  Full Name"];
    fullNameBox.inputAccessoryView = submitButton;
    fullNameBox.returnKeyType = UIReturnKeyNext;
    fullNameBox.type = TYPE_TEXT;
    [fullNameBox config];
    [fullNameBox setFont:[UIFont fontWithName:@"OpenSans-Light" size:16.5]];
    fullNameBox.autocorrectionType = UITextAutocorrectionTypeNo;
    
    if (self.facebookData[@"name"]) {
        fullNameBox.text = self.facebookData[@"name"];
    }
    
    [self.view addSubview:fullNameBox];
    
    [fullNameBox autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:descriptionLabel withOffset:5];
    [fullNameBox autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:25];
    [fullNameBox autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:25];
    [fullNameBox autoSetDimension:ALDimensionHeight toSize:50];
    
#pragma mark - Username Text Box
    usernameBox = [[PNTextField alloc] init];
    [usernameBox setTranslatesAutoresizingMaskIntoConstraints:NO];
    usernameBox.type = TYPE_USER;
    [usernameBox config];
    [usernameBox setPlaceholder:@"  Username"];
    usernameBox.inputAccessoryView = submitButton;
    [usernameBox setFont:[UIFont fontWithName:@"OpenSans-Light" size:16.5]];
    usernameBox.autocorrectionType = UITextAutocorrectionTypeNo;
    usernameBox.returnKeyType = UIReturnKeyNext;
    usernameBox.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.view addSubview:usernameBox];
    
    [usernameBox autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:fullNameBox withOffset:5];
    [usernameBox autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:25];
    [usernameBox autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:25];
    [usernameBox autoSetDimension:ALDimensionHeight toSize:50];
    
#pragma mark - Email Box
    emailBox = [[PNTextField alloc] init];
    [emailBox setTranslatesAutoresizingMaskIntoConstraints:NO];
    emailBox.type = TYPE_EMAIL;
    [emailBox config];
    [emailBox setPlaceholder:@"  Email"];
    emailBox.inputAccessoryView = submitButton;
    emailBox.returnKeyType = UIReturnKeyNext;
    [emailBox setFont:[UIFont fontWithName:@"OpenSans-Light" size:16.5]];
    emailBox.autocorrectionType = UITextAutocorrectionTypeNo;
    emailBox.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    if (self.facebookData[@"email"]) {
        fullNameBox.text = self.facebookData[@"email"];
    }
    
    [self.view addSubview:emailBox];
    
    [emailBox autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:usernameBox withOffset:5];
    [emailBox autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:25];
    [emailBox autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:25];
    [emailBox autoSetDimension:ALDimensionHeight toSize:50];
    
#pragma mark - Password Box
    passwordBox = [[PNTextField alloc] init];
    [passwordBox setTranslatesAutoresizingMaskIntoConstraints:NO];
    passwordBox.type = TYPE_PASSWORD;
    [passwordBox config];
    [passwordBox setPlaceholder:@"  Password"];
    passwordBox.inputAccessoryView = submitButton;
    [passwordBox setFont:[UIFont fontWithName:@"OpenSans-Light" size:16.5]];
    passwordBox.autocorrectionType = UITextAutocorrectionTypeNo;
    passwordBox.returnKeyType = UIReturnKeyNext;
    passwordBox.secureTextEntry = YES;
    passwordBox.delegate = self;
    [self.view addSubview:passwordBox];
    
    [passwordBox autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:emailBox withOffset:5];
    [passwordBox autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:25];
    [passwordBox autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:25];
    [passwordBox autoSetDimension:ALDimensionHeight toSize:50];
    
#pragma mark - Strength One
    strengthOne = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"passwordStrength"]];
    [strengthOne setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:strengthOne];
    
    [strengthOne autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:passwordBox withOffset:5];
    [strengthOne autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:passwordBox withOffset:0];
    [strengthOne autoSetDimension:ALDimensionHeight toSize:6.5];
    [strengthOne autoSetDimension:ALDimensionWidth toSize:75];
    
#pragma mark - Strength Two
    strengthTwo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"passwordStrength"]];
    [strengthTwo setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:strengthTwo];
    
    [strengthTwo autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:passwordBox withOffset:5];
    [strengthTwo autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:strengthOne withOffset:7.5];
    [strengthTwo autoSetDimension:ALDimensionHeight toSize:6.5];
    [strengthTwo autoSetDimension:ALDimensionWidth toSize:75];
    
#pragma mark - Strength Three
    strengthThree = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"passwordStrength"]];
    [strengthThree setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:strengthThree];
    
    [strengthThree autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:passwordBox withOffset:5];
    [strengthThree autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:strengthTwo withOffset:7.5];
    [strengthThree autoSetDimension:ALDimensionHeight toSize:6.5];
    [strengthThree autoSetDimension:ALDimensionWidth toSize:75];
    
#pragma mark - Strength Four
    strengthFour = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"passwordStrength"]];
    [strengthFour setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:strengthFour];
    
    [strengthFour autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:passwordBox withOffset:5];
    [strengthFour autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:strengthThree withOffset:7.5];
    [strengthFour autoSetDimension:ALDimensionHeight toSize:6.5];
    [strengthFour autoSetDimension:ALDimensionWidth toSize:75];
    
#pragma mark - Confirm Password Box
    confirmPasswordBox = [[PNTextField alloc] init];
    [confirmPasswordBox setTranslatesAutoresizingMaskIntoConstraints:NO];
    confirmPasswordBox.type = TYPE_PASSWORD;
    [confirmPasswordBox config];
    [confirmPasswordBox setPlaceholder:@"  Confirm Password"];
    [confirmPasswordBox setFont:[UIFont fontWithName:@"OpenSans-Light" size:16.5]];
    confirmPasswordBox.autocorrectionType = UITextAutocorrectionTypeNo;
    confirmPasswordBox.inputAccessoryView = submitButton;
    confirmPasswordBox.returnKeyType = UIReturnKeyJoin;
    confirmPasswordBox.secureTextEntry = YES;
    confirmPasswordBox.delegate = self;
    [self.view addSubview:confirmPasswordBox];
    
    [confirmPasswordBox autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:strengthOne withOffset:5];
    [confirmPasswordBox autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:25];
    [confirmPasswordBox autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:25];
    [confirmPasswordBox autoSetDimension:ALDimensionHeight toSize:50];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == passwordBox) {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        int psswdStrength = [Data checkPasswordStrength:newString];
        NSLog(@"Password Strength: %d",psswdStrength);
        
        if (psswdStrength == 1) {
            [strengthOne setImage:[UIImage imageNamed:@"passwordStrengthEnabled"]];
            [strengthTwo setImage:[UIImage imageNamed:@"passwordStrength"]];
            [strengthThree setImage:[UIImage imageNamed:@"passwordStrength"]];
            [strengthFour setImage:[UIImage imageNamed:@"passwordStrength"]];
        } else if (psswdStrength == 2){
            [strengthOne setImage:[UIImage imageNamed:@"passwordStrengthEnabled"]];
            [strengthTwo setImage:[UIImage imageNamed:@"passwordStrengthEnabled"]];
            [strengthThree setImage:[UIImage imageNamed:@"passwordStrength"]];
            [strengthFour setImage:[UIImage imageNamed:@"passwordStrength"]];
        } else if (psswdStrength == 3){
            [strengthOne setImage:[UIImage imageNamed:@"passwordStrengthEnabled"]];
            [strengthTwo setImage:[UIImage imageNamed:@"passwordStrengthEnabled"]];
            [strengthThree setImage:[UIImage imageNamed:@"passwordStrengthEnabled"]];
            [strengthFour setImage:[UIImage imageNamed:@"passwordStrength"]];
        } else if (psswdStrength == 4){
            [strengthOne setImage:[UIImage imageNamed:@"passwordStrengthEnabled"]];
            [strengthTwo setImage:[UIImage imageNamed:@"passwordStrengthEnabled"]];
            [strengthThree setImage:[UIImage imageNamed:@"passwordStrengthEnabled"]];
            [strengthFour setImage:[UIImage imageNamed:@"passwordStrengthEnabled"]];
        } else {
            [strengthOne setImage:[UIImage imageNamed:@"passwordStrength"]];
            [strengthTwo setImage:[UIImage imageNamed:@"passwordStrength"]];
            [strengthThree setImage:[UIImage imageNamed:@"passwordStrength"]];
            [strengthFour setImage:[UIImage imageNamed:@"passwordStrength"]];
        }
    } else if(textField == confirmPasswordBox){
        if ([confirmPasswordBox.text isEqualToString:passwordBox.text]) {
            submitButton.enabled = YES;
        }
    }
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)theTextField {
    if (theTextField == usernameBox && ![theTextField.text  isEqual: @""]) {
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:usernameBox.text];
        [query findObjectsInBackgroundWithBlock:^(NSArray *username, NSError *error) {
            // do something with results
            if (username.count == 0) {
                [usernameBox setBackground:[UIImage imageNamed:@"registerTextFieldGreen"]];
            } else {
                [emailBox setErrorInvalid];
            }
        }];
    } else if (theTextField == emailBox && ![theTextField.text  isEqual: @""]) {
        [emailBox.text stringByCorrectingEmailTypos];
        PFQuery *query = [PFUser query];
        [query whereKey:@"email" equalTo:emailBox.text];
        [query findObjectsInBackgroundWithBlock:^(NSArray *username, NSError *error) {
            // do something with results
            if (username.count == 0) {
                [emailBox setBackground:[UIImage imageNamed:@"registerTextFieldGreen"]];
            } else {
                [emailBox setErrorInvalid];
            }
        }];
    }
    if ([fullNameBox.text length]>0 && [usernameBox.text length]>0 && [emailBox.text length]>0 && [passwordBox.text length]>0 && [confirmPasswordBox.text length]>0)   // check if all the textfields are filled
    {
        submitButton.enabled = YES;   // enable button here
    }else{
        submitButton.enabled = NO;
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == confirmPasswordBox) {
        [theTextField resignFirstResponder];
        [self submitButtonTapped:nil];
    } else if (theTextField == fullNameBox) {
        [usernameBox becomeFirstResponder];
    } else if (theTextField == usernameBox) {
        [emailBox becomeFirstResponder];
    } else if (theTextField == emailBox) {
        [emailBox.text stringByCorrectingEmailTypos];
        [passwordBox becomeFirstResponder];
    } else if (theTextField == passwordBox) {
        [confirmPasswordBox becomeFirstResponder];
    }
    return YES;
}

- (void)submitButtonTapped:(id)sender {
    user = [PFUser user];
    user.username = [usernameBox.text lowercaseString];
    user.password = passwordBox.text;
    user.email = emailBox.text;
    user[@"fullName"] = fullNameBox.text;
    UIImage *image = [UIImage imageNamed:@"profilePicture.png"];
    NSData *imageData = UIImagePNGRepresentation(image);
    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
    [imageFile saveInBackground];
    [user setObject:imageFile forKey:@"profilePicture"];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            PFObject *hours = [PFObject objectWithClassName:@"Hours"];
            hours[@"user"] = user;
            hours[@"totalHours"] = @0;
            hours[@"Jan"] = @0;
            hours[@"Feb"] = @0;
            hours[@"Mar"] = @0;
            hours[@"Apr"] = @0;
            hours[@"May"] = @0;
            hours[@"Jun"] = @0;
            hours[@"Jul"] = @0;
            hours[@"Aug"] = @0;
            hours[@"Sep"] = @0;
            hours[@"Oct"] = @0;
            hours[@"Nov"] = @0;
            hours[@"Dec"] = @0;
            hours[@"lastMonth"] = @0;
            hours[@"lastWeek"] = @0;
            hours[@"thisMonth"] = @0;
            hours[@"thisWeek"] = @0;
            [hours saveInBackground];
            [self popForward];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"%@",errorString);
        }
    }];
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
    self.navigationItem.title = @"Sign Up";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"OpenSans-Semibold" size:18]}];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)popForward {
    [PFUser logInWithUsernameInBackground:usernameBox.text password:passwordBox.text
                                    block:^(PFUser *user, NSError *error) {
                                        if ([PFUser currentUser]) {
                                            NSLog(@"%@", [PFUser currentUser]);
                                            [self dismissViewControllerAnimated:YES completion:nil];
                                        } else {
                                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error" message:@"Credentials provided were incorrect. Please  try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                            [alert show];
                                        }
                                    }];
    [self.view endEditing:YES];
}

- (void)popBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
