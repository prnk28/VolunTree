//
//  LoginViewController.m
//  
//
//  Created by Pradyumn Nukala on 8/28/15.
//
//

#import "LoginViewController.h"
#import "ForgetPassVC.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.kenView = [[JBKenBurnsView alloc] initWithFrame:self.view.frame];
    self.kenView.delegate = self;
    [self.view addSubview:self.kenView];
    
    NSArray *myImages = @[[UIImage imageNamed:@"A1"],
                          [UIImage imageNamed:@"A2"],
                          [UIImage imageNamed:@"A3"],
                          [UIImage imageNamed:@"A4"],
                          [UIImage imageNamed:@"A5"],
                          [UIImage imageNamed:@"A6"],
                          [UIImage imageNamed:@"A7"]];
    
    [self.kenView animateWithImages:myImages
                 transitionDuration:15
                       initialDelay:0
                               loop:YES
                        isLandscape:YES];
    
    UIView *filter = [[UIView alloc] initWithFrame:self.view.frame];
    filter.backgroundColor = [UIColor blackColor];
    filter.alpha = 0.05;
    [self.view addSubview:filter];
    
    UIButton *facebookLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    [facebookLogin setTranslatesAutoresizingMaskIntoConstraints:NO];
    [facebookLogin setBackgroundImage:[UIImage imageNamed:@"facebook"] forState:UIControlStateNormal];
    [facebookLogin addTarget:self action:@selector(facebookTapped:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:facebookLogin];
    [facebookLogin autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-115];
    [facebookLogin autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:65];
    [facebookLogin autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:65];
    [facebookLogin autoSetDimension:ALDimensionHeight toSize:52.5];
    [facebookLogin autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    
    UIButton *loginEmail = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginEmail setTranslatesAutoresizingMaskIntoConstraints:NO];
    [loginEmail setBackgroundImage:[UIImage imageNamed:@"LoginBut"] forState:UIControlStateNormal];
    [loginEmail addTarget:self action:@selector(emailTapped:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:loginEmail];
    
    [loginEmail autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-50];
    [loginEmail autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:65];
    [loginEmail autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:65];
    [loginEmail autoSetDimension:ALDimensionHeight toSize:52.5];
    [loginEmail autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];

    UILabel *accountLabel = [[UILabel alloc] init];
    accountLabel.userInteractionEnabled = YES;
    [accountLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    accountLabel.backgroundColor = [UIColor clearColor];
    accountLabel.textColor = [UIColor whiteColor];
    accountLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:14];
    accountLabel.text = NSLocalizedString(@"Sign up with email instead.", nil);
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(accountLabelTapped:)];
    [accountLabel addGestureRecognizer:singleTap];
    [self.view addSubview:accountLabel];
    [accountLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view withOffset:10];
    [accountLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-7.5];
    
    UIImageView *email = [[UIImageView alloc] init];
    email.image = [UIImage imageNamed:@"emailIcon"];
    [self.view addSubview:email];
    [email autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:accountLabel withOffset:-5];
    [email autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:accountLabel withOffset:2.5];
    [email autoSetDimension:ALDimensionHeight toSize:15];
    [email autoSetDimension:ALDimensionWidth toSize:15];
    
    UIImageView *profileCellLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profileCellLine"]];
    [profileCellLine setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:profileCellLine];
    
    [profileCellLine autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:accountLabel withOffset:-4];
    [profileCellLine autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:10];
    [profileCellLine autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-10];
    
    UIImageView *LoginIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginIcon"]];
    [LoginIcon setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:LoginIcon];
    [LoginIcon autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:35];
    [LoginIcon autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
}


- (void)touchDown:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)accountLabelTapped:(id)sender {
    SignupViewController *svc = [[SignupViewController alloc] init];
    [self.navigationController pushViewController:svc animated:YES];
    
}

- (void)facebookTapped:(id)sender {
    [PFFacebookUtils logInInBackgroundWithReadPermissions:@[@"public_profile", @"email"] block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User :%@",user);
            FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
            [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    // result is a dictionary with the user's Facebook data
                    
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
                    
                    [[PFUser currentUser] setObject:result[@"name"] forKey:@"fullName"];
                    NSString *facebookID = result[@"id"];
                    
                    NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
                    
                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:pictureURL]];
                    NSData *imageData = UIImagePNGRepresentation(image);
                    PFFile *imageFile = [PFFile fileWithName:@"pfpimage.png" data:imageData];
                    [imageFile saveInBackground];
                    [user setObject:imageFile forKey:@"profilePicture"];
                    [user saveInBackground];

                    
                    //Create the popin view controller
                    FacebookViewController *popin = [[FacebookViewController alloc] init];
                    //Customize transition if needed
                    [popin setPopinTransitionStyle:BKTPopinTransitionStyleSlide];
                    
                    //Add options
                    [popin setPopinOptions:BKTPopinDisableAutoDismiss];
                    [popin setPopinAlignment:BKTPopinAlignementOptionUp];
                    
                    
                    //Customize transition direction if needed
                    [popin setPopinTransitionDirection:BKTPopinTransitionDirectionTop];
                    [self presentPopinController:popin animated:YES completion:^{
                        NSLog(@"Popin presented !");
                    }];
                    
                }
            }];
            NSLog(@"User signed up and logged in through Facebook!");
        } else {
            if (user.username == nil) {
                //Create the popin view controller
                FacebookViewController *popin = [[FacebookViewController alloc] init];
                //Customize transition if needed
                [popin setPopinTransitionStyle:BKTPopinTransitionStyleSlide];
                
                //Add options
                [popin setPopinOptions:BKTPopinDisableAutoDismiss];
                [popin setPopinAlignment:BKTPopinAlignementOptionUp];
                
                
                //Customize transition direction if needed
                [popin setPopinTransitionDirection:BKTPopinTransitionDirectionTop];
                [self presentPopinController:popin animated:YES completion:^{
                    NSLog(@"Popin presented !");
                }];
            } else {
                
                NSLog(@"User :%@",user);
                FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
                [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                    if (!error) {
                        // result is a dictionary with the user's Facebook data
                        NSDictionary *userData = (NSDictionary *)result;
                        NSLog(@"User: %@", userData);
                        NSLog(@"Email %@",[userData objectForKey:@"email"]);
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                }];
                NSLog(@"User logged in through Facebook!");
            }
        }
    }];
}

- (void)emailTapped:(id)sender {
    //Create the popin view controller
    BKTPopinControllerViewController *popin = [[BKTPopinControllerViewController alloc] init];
    //Customize transition if needed
    [popin setPopinTransitionStyle:BKTPopinTransitionStyleSlide];
    
    //Add options
    [popin setPopinOptions:BKTPopinDisableAutoDismiss];
    [popin setPopinAlignment:BKTPopinAlignementOptionUp];
    
    
    //Customize transition direction if needed
    [popin setPopinTransitionDirection:BKTPopinTransitionDirectionTop];
    
    //Present popin on the desired controller
    //Note that if you are using a UINavigationController, the navigation bar will be active if you present
    // the popin on the visible controller instead of presenting it on the navigation controller
    [self presentPopinController:popin animated:YES completion:^{
        NSLog(@"Popin presented !");
    }];
}

- (void)dismissKeyboard {
    [passwordField resignFirstResponder];
    [UserNameTextFieldBG resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)sender {
    sender.delegate = self;
}

@end
