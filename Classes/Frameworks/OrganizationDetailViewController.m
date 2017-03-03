//
//  OrganizationDetailViewController.m
//  VolunTree
//
//  Created by Pradyumn Nukala on 1/9/16.
//  Copyright © 2016 HelpOut. All rights reserved.
//

#import "OrganizationDetailViewController.h"
#import "OrganizationDetailHeaderView.h"
#import "MXParallaxHeader.h"
#import "Data.h"
#import "UIColor+TreeColor.h"

@interface OrganizationDetailViewController ()

@end

@implementation OrganizationDetailViewController {
    UIView *white;
}
@synthesize footer;
@synthesize field;

- (void)viewWillAppear:(BOOL)animated {
    [self seeIfAuthor];
    [self fetchComments];
    [self viewDidLoad];
    NSString *labelText = [self.object objectForKey:@"status"];
    UIFont *cellFont = [UIFont fontWithName:@"OpenSans-Light" size:12.0];
    CGSize size = [self findHeightForText:labelText havingWidth:240 andFont:cellFont];
    OrganizationDetailHeaderView *orgDet = [[OrganizationDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, size.height+65) withDictionary:self.object];
    self.tableView.parallaxHeader.view = orgDet;
    self.tableView.parallaxHeader.height = size.height + 65;
    self.tableView.parallaxHeader.minimumHeight = 5;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)seeIfAuthor{
    PFQuery *q = [PFQuery queryWithClassName:@"Admins"];
    [q whereKey:@"user" equalTo:[PFUser currentUser]];
    [q whereKey:@"organization" equalTo:self.object[@"organization"]];
    [q findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        NSLog(@"%lu",objects.count);
        if (self.object[@"author"] == [PFUser currentUser] || objects.count > 0) {
            UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [barButton setTitle:@"" forState:UIControlStateNormal];
            [barButton setBackgroundImage:[UIImage imageNamed:@"trash"] forState:UIControlStateNormal];
            [barButton addTarget:self action:@selector(deletePost:) forControlEvents:UIControlEventTouchUpInside];
            barButton.frame = CGRectMake(0.0f, 0.0f, 10.0f, 15.0f);
            UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
            self.navigationItem.rightBarButtonItem = barButtonItem;
        }
    }];
    
}

- (void)deletePost:(id)sender {
    NSArray *items = @[MMItemMake(@"Yes", MMItemTypeNormal, ^(NSInteger index) {
        [self.object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            NSLog(@"Deleted.");
        }];
        [self.navigationController popViewControllerAnimated:YES];
    }), MMItemMake(@"Cancel", MMItemTypeHighlight, ^(NSInteger index) {
        
    })];
    [[[MMAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Delete."]
                                 detail:@"Are you sure you want to delete this post?"
                                  items:items] show];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self seeIfAuthor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self fetchComments];
    [self setUpUI];
}
- (void)keyboardWillShow:(NSNotification *)sender {
    CGSize kbSize = [[[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGFloat height = UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation]) ? kbSize.height : kbSize.width;
    height = kbSize.height;
    
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = [[self tableView] contentInset];
        edgeInsets.bottom = height;
        [[self tableView] setContentInset:edgeInsets];
        edgeInsets = [[self tableView] scrollIndicatorInsets];
        edgeInsets.bottom = height;
        [[self tableView] setScrollIndicatorInsets:edgeInsets];
    }];
}

- (void)keyboardWillHide:(NSNotification *)sender {
    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = [[self tableView] contentInset];
        edgeInsets.bottom = 0;
        [[self tableView] setContentInset:edgeInsets];
        edgeInsets = [[self tableView] scrollIndicatorInsets];
        edgeInsets.bottom = 0;
        [[self tableView] setScrollIndicatorInsets:edgeInsets];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)fetchComments {
    PFQuery *query = [PFQuery queryWithClassName:@"OrganizationComment"];
    NSLog(@"Current Post: %@", self.object);
    [query whereKey:@"post" equalTo:self.object];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        NSLog(@"Comments: %@", objects);
        self.comments = objects;
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self.tableView reloadData];
        });
    }];
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Set Title
    self.navigationItem.title = [NSString stringWithFormat:@"%@'s Post", [self.object[@"author"] objectForKey:@"fullName"]];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"OpenSans-Semibold" size:18]}];
}

- (void)popBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.comments count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    footer.backgroundColor = [UIColor whiteColor];
    field = [[UITextField alloc] initWithFrame:CGRectMake(20, 5, 300, 35)];
    field.delegate = self;
    field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Write a comment..." attributes: @{NSForegroundColorAttributeName:[UIColor darkGrayColor],
                                                                                                                 NSFontAttributeName:[UIFont fontWithName:@"OpenSans-Light" size:18]}];
    [field setReturnKeyType:UIReturnKeySend];
    [footer addSubview:field];
#pragma mark - Line
    UIImageView *profileCellLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profileCellLine"]];
    [profileCellLine setTranslatesAutoresizingMaskIntoConstraints:NO];
    [footer addSubview:profileCellLine];
    
    [profileCellLine autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [profileCellLine autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [profileCellLine autoPinEdgeToSuperviewEdge:ALEdgeRight];
    
    return footer;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.tableView scrollToView:footer];
    [field becomeFirstResponder];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.tableView scrollToY:0];
    [field resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == field) {
        PFObject *obj = [PFObject objectWithClassName:@"OrganizationComment"];
        obj[@"commentAuthor"] = [PFUser currentUser];
        obj[@"post"] = self.object;
        obj[@"commentString"] = theTextField.text;
        if (![theTextField.text  isEqual: @""]) {
            [obj saveInBackground];
        }
        theTextField.text = @"";
        [theTextField resignFirstResponder];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fetchComments];
        [self.tableView reloadData];
    });
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *data = self.comments[indexPath.row];
    NSString *labelText = [data objectForKey:@"status"];
    UIFont *cellFont = [UIFont fontWithName:@"OpenSans-Light" size:12.0];
    CGSize size = [self findHeightForText:labelText havingWidth:70 andFont:cellFont];
    return size.height + 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *data = self.comments[indexPath.row];
    static NSString *MyIdentifier = @"ProfileCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:MyIdentifier];
    }
    
    for(UIView *view in cell.contentView.subviews){
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
        }
    }
    
#pragma mark - Profile Pic
    UIButton *profilePic = [[UIButton alloc] init];
    PFUser *user = data[@"commentAuthor"];
    PFFile *thumbnail = [user objectForKey:@"profilePicture"];
    NSData *imageData = [thumbnail getData];
    UIImage *image = [UIImage imageWithData:imageData];
    
    if (imageData == nil) {
        [profilePic setImage:[UIImage imageNamed:@"profilePic"]
                    forState:UIControlStateNormal];
    }else{
        [profilePic setImage:image forState:UIControlStateNormal];
        profilePic.layer.cornerRadius = 23.0;
        profilePic.clipsToBounds = YES;
    }
    
    [profilePic setTranslatesAutoresizingMaskIntoConstraints:NO];
    [cell.contentView addSubview:profilePic];
    
    [profilePic autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:8.0];
    [profilePic autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:7.0];
    [profilePic autoSetDimension:ALDimensionHeight toSize:48];
    [profilePic autoSetDimension:ALDimensionWidth toSize:47];
    
#pragma mark - Title Label
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setNeedsDisplay];
    [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor treeColor];
    titleLabel.font = [UIFont fontWithName:@"OpenSans" size:14.185];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = [user objectForKey:@"fullName"];
    [titleLabel setNeedsDisplay];
    [cell.contentView addSubview:titleLabel];
    
    [titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:profilePic withOffset:6];
    [titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:6];
    
#pragma mark - Detail Label
    UILabel *detailLabel = [[UILabel alloc] init];
    [detailLabel setNeedsDisplay];
    [detailLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.textColor = [UIColor colorWithRed:0.620 green:0.639 blue:0.659 alpha:1];
    detailLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:12];
    detailLabel.textAlignment = NSTextAlignmentLeft;
    detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
    detailLabel.numberOfLines = 0;
    detailLabel.adjustsFontSizeToFitWidth = NO;
    detailLabel.text = [data objectForKey:@"commentString"];
    [detailLabel setNeedsDisplay];
    [cell.contentView addSubview:detailLabel];
    
    [detailLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:titleLabel withOffset:4];
    [detailLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:titleLabel];
    
    return cell;
}

- (void)tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // User Cell
    [self resignFirstResponder];
    PFObject *data = self.comments[indexPath.row];
    PFUser *user = data[@"commentAuthor"];
    ForeignProfileVC *fvc = [[ForeignProfileVC alloc] init];
    fvc.object = user;
    UINavigationController *navFvc = [[UINavigationController alloc] initWithRootViewController:fvc];
    [self.navigationController presentViewController:navFvc animated:YES completion:nil];
}

- (CGSize)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font {
    CGSize size = CGSizeZero;
    if (text) {
        //iOS 7
        CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:font } context:nil];
        size = CGSizeMake(frame.size.width, frame.size.height + 1);
    }
    return size;
}

@end
