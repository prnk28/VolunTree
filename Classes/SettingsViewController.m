//
//  SelectorsFormViewController.m
//  XLForm ( https://github.com/xmartlabs/XLForm )
//
//  Copyright (c) 2015 Xmartlabs ( http://xmartlabs.com )
//
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

#import <MapKit/MapKit.h>
#import "SettingsViewController.h"

NSString *const kSelectorPush = @"selectorPush";
NSString *const kSelectorPopover = @"selectorPopover";
NSString *const kSelectorActionSheet = @"selectorActionSheet";
NSString *const kSelectorAlertView = @"selectorAlertView";
NSString *const kSelectorLeftRight = @"selectorLeftRight";
NSString *const kSelectorPushDisabled = @"selectorPushDisabled";
NSString *const kSelectorActionSheetDisabled = @"selectorActionSheetDisabled";
NSString *const kSelectorLeftRightDisabled = @"selectorLeftRightDisabled";
NSString *const kSelectorPickerView = @"selectorPickerView";
NSString *const kSelectorPickerViewInline = @"selectorPickerViewInline";
NSString *const kMultipleSelector = @"multipleSelector";
NSString *const kMultipleSelectorPopover = @"multipleSelectorPopover";
NSString *const kDynamicSelectors = @"dynamicSelectors";
NSString *const kCustomSelectors = @"customSelectors";
NSString *const kPickerView = @"pickerView";
NSString *const kSelectorWithSegueId = @"selectorWithSegueId";
NSString *const kSelectorWithSegueClass = @"selectorWithSegueClass";
NSString *const kSelectorWithNibName = @"selectorWithNibName";
NSString *const kSelectorWithStoryboardId = @"selectorWithStoryboardId";

#pragma mark - NSValueTransformer

@interface NSArrayValueTrasformer : NSValueTransformer
@end


#pragma mark - SettingsViewController

@implementation SettingsViewController{
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    XLFormDescriptor * form;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initializeForm];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeForm];
    }
    return self;
}

- (void)initializeForm
{
    PFUser *user = [PFUser currentUser];
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"Account Information"];
    
    // Basic Information
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Account Information"];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"name" rowType:XLFormRowDescriptorTypeText title:@"Name"];
    row.value = [XLFormOptionsObject formOptionsObjectWithValue:nil displayText:user[@"fullName"]];
    [row.cellConfig setObject:[UIFont fontWithName:@"Helvetica-Bold" size:14] forKey:@"textLabel.font"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"email" rowType:XLFormRowDescriptorTypeText title:@"Email"];
    row.value = [XLFormOptionsObject formOptionsObjectWithValue:nil displayText:user[@"email"]];
    [row.cellConfig setObject:[UIFont fontWithName:@"Helvetica-Bold" size:14] forKey:@"textLabel.font"];
    [row addValidator:[XLFormValidator emailValidator]];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"user" rowType:XLFormRowDescriptorTypeText title:@"Username"];
    row.value = [XLFormOptionsObject formOptionsObjectWithValue:nil displayText:user[@"username"]];
    [row.cellConfig setObject:[UIFont fontWithName:@"Helvetica-Bold" size:14] forKey:@"textLabel.font"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"phone" rowType:XLFormRowDescriptorTypeText title:@"Phone"];
    row.value = [XLFormOptionsObject formOptionsObjectWithValue:nil displayText:user[@"phone"]];
    [row.cellConfig setObject:[UIFont fontWithName:@"Helvetica-Bold" size:14] forKey:@"textLabel.font"];
    [row addValidator:[XLFormRegexValidator formRegexValidatorWithMsg:@"valid phone" regex:@"^[1-9][0-9]*$"]];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Button" rowType:XLFormRowDescriptorTypeButton title:@"Save"];
    row.action.formSelector = @selector(didTapSave:);
    [section addFormRow:row];
    
    // --------- Inline Selectors
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@""];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Button" rowType:XLFormRowDescriptorTypeButton title:@"Logout Account"];
    row.action.formSelector = @selector(didTapLogout:);
    row.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"Confirm Logout."]];
    [section addFormRow:row];
    [form addFormSection:section];
    section.footerTitle = @"                         A Project by Pradyumn Nukala";
    self.form = form;
}

-(void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Settings";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"OpenSans-Semibold" size:18]}];
    
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [barButton setTitle:@"" forState:UIControlStateNormal];
    [barButton setBackgroundImage:[UIImage imageNamed:@"closeIcon"] forState:UIControlStateNormal];
    [barButton addTarget:self action:@selector(didTapClose:) forControlEvents:UIControlEventTouchUpInside];
    barButton.frame = CGRectMake(0.0f, 0.0f, 15.0f, 15.0f);
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeForm];
    [self setupUI];
}

-(void)viewDidDisappear:(BOOL)animated{
    [self initializeForm];
}

- (void)didTapLogout:(id)sender {
    [self deselectFormRow:sender];
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Logout?"
                                                     message:@"Are you sure you want to Logout?"
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles: nil];
    [alert addButtonWithTitle:@"Continue"];
    [alert show];
}

- (void)didTapSave:(id)sender {
    [self deselectFormRow:sender];
    NSDictionary *values = [self formValues];
    NSLog(@"%@",values);
    NSString *name = values[@"name"];
    NSLog(@"%@",name);
    NSString *email = values[@"email"];
    NSString *phone = values[@"phone"];
    NSString *user = values[@"user"];
    
    PFQuery *queryEmail = [PFUser query];
    [queryEmail whereKey:@"email" equalTo:[NSString stringWithFormat:@"%@",email]];
    PFQuery *queryUser = [PFUser query];
    [queryUser whereKey:@"username" equalTo:[NSString stringWithFormat:@"%@",user]];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[queryUser,queryEmail]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (object == nil) {
            if (![name isKindOfClass:[XLFormOptionsObject class]]) {
                [[PFUser currentUser] setObject:name forKey:@"fullName"];
            }
            
            if (![email isKindOfClass:[XLFormOptionsObject class]]) {
                [[PFUser currentUser] setObject:email forKey:@"email"];
            }
            
            if (![phone isKindOfClass:[XLFormOptionsObject class]]) {
                [[PFUser currentUser] setObject:phone forKey:@"phone"];
            }
            
            if (![user isKindOfClass:[XLFormOptionsObject class]]) {
                [[PFUser currentUser] setObject:user forKey:@"username"];
            }
            
            [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    notif = [JFMinimalNotification notificationWithStyle:JFMinimalNotificationStyleDefault title:@"Successfully Updated." subTitle:@"Leave this page to continue."];
                    UIFont* titleFont = [UIFont fontWithName:@"OpenSans-Regular" size:22];
                    [notif setTitleFont:titleFont];
                    UIFont* subTitleFont = [UIFont fontWithName:@"OpenSans-Light" size:16];
                    [notif setSubTitleFont:subTitleFont];
                    [self.view addSubview:notif];
                    [notif show];
                    [NSTimer scheduledTimerWithTimeInterval:2.5
                                                     target:self
                                                   selector:@selector(hideNotif:)
                                                   userInfo:nil
                                                    repeats:NO];
                    [self initializeForm];
                    [self.tableView reloadData];
                }
            }];
        }else{
            if ([object[@"username"] isEqualToString:user]) {
                notif = [JFMinimalNotification notificationWithStyle:JFMinimalNotificationStyleError title:@"Error" subTitle:@"This username is already in use."];
                UIFont* titleFont = [UIFont fontWithName:@"OpenSans-Regular" size:22];
                [notif setTitleFont:titleFont];
                UIFont* subTitleFont = [UIFont fontWithName:@"OpenSans-Light" size:16];
                [notif setSubTitleFont:subTitleFont];
                [self.view addSubview:notif];
                [notif show];
                [NSTimer scheduledTimerWithTimeInterval:2.5
                                                 target:self
                                               selector:@selector(hideNotif:)
                                               userInfo:nil
                                                repeats:NO];
            } else {
                notif = [JFMinimalNotification notificationWithStyle:JFMinimalNotificationStyleError title:@"Error" subTitle:@"This email is already in use."];
                UIFont* titleFont = [UIFont fontWithName:@"OpenSans-Regular" size:22];
                [notif setTitleFont:titleFont];
                UIFont* subTitleFont = [UIFont fontWithName:@"OpenSans-Light" size:16];
                [notif setSubTitleFont:subTitleFont];
                [self.view addSubview:notif];
                [notif show];
                [NSTimer scheduledTimerWithTimeInterval:2.5
                                                 target:self
                                               selector:@selector(hideNotif:)
                                               userInfo:nil
                                                repeats:NO];
            }
        }
     }];
    
    [self.tableView endEditing:YES];
    
}

-(void)animateCell:(UITableViewCell *)cell
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position.x";
    animation.values =  @[ @0, @20, @-20, @10, @0];
    animation.keyTimes = @[@0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1];
    animation.duration = 0.3;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.additive = YES;
    
    [cell.layer addAnimation:animation forKey:@"shake"];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button Index =%ld",(long)buttonIndex);
    if (buttonIndex == 0)
    {
        NSLog(@"You have clicked Cancel");
    }
    else if(buttonIndex == 1)
    {
        NSLog(@"You have clicked Continue");
        [PFUser logOut];
        notif = [JFMinimalNotification notificationWithStyle:JFMinimalNotificationStyleDefault title:@"Logged Out" subTitle:@"Leave this page to continue."];
        UIFont* titleFont = [UIFont fontWithName:@"OpenSans-Regular" size:22];
        [notif setTitleFont:titleFont];
        UIFont* subTitleFont = [UIFont fontWithName:@"OpenSans-Light" size:16];
        [notif setSubTitleFont:subTitleFont];
        [self.view addSubview:notif];
        [notif show];
        [NSTimer scheduledTimerWithTimeInterval:2.5
                                         target:self
                                       selector:@selector(hideNotif:)
                                       userInfo:nil
                                        repeats:NO];
    }
}

-(void)hideNotif:(id)sender {
    [notif dismiss];
}

- (void)viewWillAppear:(BOOL)animated {
    [self initializeForm];
}

-(BOOL)NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (void)didTapClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
