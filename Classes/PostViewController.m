//
//  PostViewController.m
//  VolunTree
//
//  Created by Pradyumn Nukala on 1/3/16.
//  Copyright © 2016 HelpOut. All rights reserved.
//

#import "Data.h"
#import "PostViewController.h"

@interface PostViewController ()

@end

@implementation PostViewController
@synthesize textView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    
    // Text View
    textView = [[UITextView alloc] initWithFrame:CGRectMake(65, 5, 255, 320)];
    textView.placeholder = @"Write Something";
    textView.placeholderColor = [UIColor colorWithRed:0.467 green:0.475 blue:0.490 alpha:1];
    [self.view addSubview:textView];
    
    [textView becomeFirstResponder];
    
    // Profile Pic
    PFFile *thumbnail = [[PFUser currentUser] objectForKey:@"profilePicture"];
    NSData *imageData = [thumbnail getData];
    UIImage *image = [UIImage imageWithData:imageData];
    
    UIImageView *profilePic = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 40, 40)];
    if (imageData == nil) {
        profilePic.image = [UIImage imageNamed:@"profilePicture"];
    }else{
        profilePic.image = image;
    }
    profilePic.layer.cornerRadius=20;
    profilePic.clipsToBounds = YES;
    [self.view addSubview:profilePic];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpUI{
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton addTarget:self action:@selector(cancelPressed:) forControlEvents:UIControlEventTouchDown];
    [closeButton setTitle:@"" forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"closeIcon"] forState:UIControlStateNormal];
    closeButton.frame = CGRectMake(0.0f, 0.0f, 15.0f, 15.0f);
    UIBarButtonItem *closeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    
    self.navigationItem.leftBarButtonItem = closeButtonItem;
    
    UIButton *giveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [giveButton addTarget:self action:@selector(savePressed:) forControlEvents:UIControlEventTouchDown];
    [giveButton setTitle:@"" forState:UIControlStateNormal];
    [giveButton setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    giveButton.frame = CGRectMake(0.0f, 0.0f, 15.0f, 15.0f);
    UIBarButtonItem *giveButtonItem = [[UIBarButtonItem alloc] initWithCustomView:giveButton];
    
    self.navigationItem.rightBarButtonItem = giveButtonItem;
    
    self.navigationItem.title = @"Post";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"OpenSans-Semibold" size:18]}];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)cancelPressed:(UIBarButtonItem * __unused)button
{
    [textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)savePressed:(UIBarButtonItem * __unused)button
{
    [textView resignFirstResponder];
    PFObject *post = [PFObject objectWithClassName:@"OrganizationPost"];
    post[@"status"] = textView.text;
    post[@"author"] = [PFUser currentUser];
    post[@"organization"] = self.organization;
    post[@"likeCount"] = @0;
    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reload_data_org" object:self];
            [self dismissViewControllerAnimated:YES completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reload_data_org" object:self];
                NSLog(@"Posted");
            }];
        } else {
            NSLog(@"Error");
        }
    }];
}

@end
