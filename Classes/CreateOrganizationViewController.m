//
//  CreateOrganizationViewController.m
//  VolunTree
//
//  Created by Pradyumn Nukala on 12/29/15.
//  Copyright © 2015 HelpOut. All rights reserved.
//

#import "CreateOrganizationViewController.h"

@interface CategoryTransformer : NSValueTransformer
@end

@implementation CategoryTransformer

+ (Class)transformedValueClass
{
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
{
    if (!value) return nil;
    OrganizationCategory *user = (OrganizationCategory *) value;
    return user.name;
}

@end


@interface CreateOrganizationViewController ()

@end

NSString *const khiderow = @"tag1";
NSString *const ktext = @"tag3";

@implementation CreateOrganizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self initializeForm];
}

- (void)didTapClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Create Organization";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"OpenSans-Semibold" size:18]}];
    
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    [close setTitle:@"" forState:UIControlStateNormal];
    [close setBackgroundImage:[UIImage imageNamed:@"closeIcon"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(didTapClose:) forControlEvents:UIControlEventTouchUpInside];
    close.frame = CGRectMake(0.0f, 0.0f, 15.0f, 15.0f);
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:close];
    
    self.navigationItem.leftBarButtonItem = closeButton;
    
    UIButton *check = [UIButton buttonWithType:UIButtonTypeCustom];
    [check setTitle:@"" forState:UIControlStateNormal];
    [check setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    [check addTarget:self action:@selector(savePressed:) forControlEvents:UIControlEventTouchUpInside];
    check.frame = CGRectMake(0.0f, 0.0f, 15.0f, 15.0f);
    UIBarButtonItem *checkButton = [[UIBarButtonItem alloc] initWithCustomView:check];
    
    self.navigationItem.rightBarButtonItem = checkButton;
}

- (void)initializeForm
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"Add Event"];
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Basics"];
    [form addFormSection:section];
    
    // Name
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"name" rowType:XLFormRowDescriptorTypeText];
    [row.cellConfigAtConfigure setObject:@"Name" forKey:@"textField.placeholder"];
    row.required = YES;
    [section addFormRow:row];
    
    // Motto
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"motto" rowType:XLFormRowDescriptorTypeText];
    [row.cellConfigAtConfigure setObject:@"Motto - A simple tagline" forKey:@"textField.placeholder"];
    row.required = YES;
    [section addFormRow:row];
    
    // Category
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"category" rowType:XLFormRowDescriptorTypeSelectorPush title:@"Category"];
    CategoryOrganizationVC *search = [[CategoryOrganizationVC alloc] init];
    row.valueTransformer = [CategoryTransformer class];
    row.action.viewControllerClass = [search class];
    row.required = YES;
    [section addFormRow:row];
    
    // Description
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"description" rowType:XLFormRowDescriptorTypeTextView];
    [row.cellConfigAtConfigure setObject:@"Description" forKey:@"textView.placeholder"];
    row.required = YES;
    [section addFormRow:row];
    
    // Others
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Other"];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:khiderow rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"Submit for Verification"];
    row.value = @0;
    [section addFormRow:row];
    
    // Reason
    row = [XLFormRowDescriptor formRowDescriptorWithTag:ktext rowType:XLFormRowDescriptorTypeTextView title:@""];
    row.hidden = [NSString stringWithFormat:@"$%@==0", khiderow];
    [row.cellConfigAtConfigure setObject:@"Provide reason for Verification. The more reasons the better." forKey:@"textView.placeholder"];
    [section addFormRow:row];
    
    self.form = form;
}

-(void)savePressed:(UIBarButtonItem * __unused)button
{
    [self.tableView endEditing:YES];
    NSArray * validationErrors = [self formValidationErrors];
    if (validationErrors.count > 0){
        [self showFormValidationError:[validationErrors firstObject]];
        return;
    }
    NSLog(@"FormValues: %@",self.formValues);
    PFACL *ACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [ACL setPublicReadAccess:YES];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Organizations"];
    [query whereKey:@"Name" hasPrefix:[self.formValues objectForKey:@"name"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects.count > 0) {
            NSLog(@"Club already exists");
            notif = [JFMinimalNotification notificationWithStyle:JFMinimalNotificationStyleError title:@"Error" subTitle:@"The club name already exists."];
            UIFont* titleFont = [UIFont fontWithName:@"OpenSans-Regular" size:22];
            [notif setTitleFont:titleFont];
            UIFont* subTitleFont = [UIFont fontWithName:@"OpenSans-Light" size:16];
            [notif setSubTitleFont:subTitleFont];
            [self.view addSubview:notif];
            [notif show];
            
            [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(hideNotifNoExit:)
                                           userInfo:nil
                                            repeats:NO];
        } else {
            PFObject *organization = [PFObject objectWithClassName:@"Organizations"];
            organization[@"Name"] = [self.formValues objectForKey:@"name"];
            if(self.formValues[@"motto"] == nil){
                organization[@"motto"] = @"";
            }else{
                organization[@"motto"] = [self.formValues objectForKey:@"motto"];
            }
            organization[@"description"] = [self.formValues objectForKey:@"description"];
            
            OrganizationCategory *oc = [self.formValues objectForKey:@"category"];
            organization[@"category"] = oc.name;
            
            UIImage *image = oc.image;
            NSData *imageData = UIImagePNGRepresentation(image);
            PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
            [imageFile saveInBackground];
            [organization setObject:imageFile forKey:@"image"];
            [organization saveInBackground];
            PFRelation *relation = [organization relationForKey:@"members"];
            [relation addObject:[PFUser currentUser]];
            
            bool askedVerification = [self.formValues objectForKey:@"tag1"];
            if (askedVerification) {
                NSLog(@"Not asking");
                [organization saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        NSLog(@"Saved");
                        notif = [JFMinimalNotification notificationWithStyle:JFMinimalNotificationStyleSuccess title:@"Success" subTitle:@"You have added a club!"];
                        UIFont* titleFont = [UIFont fontWithName:@"OpenSans-Regular" size:22];
                        [notif setTitleFont:titleFont];
                        UIFont* subTitleFont = [UIFont fontWithName:@"OpenSans-Light" size:16];
                        [notif setSubTitleFont:subTitleFont];
                        [self.view addSubview:notif];
                        [notif show];
                        
                        [NSTimer scheduledTimerWithTimeInterval:1.0
                                                         target:self
                                                       selector:@selector(hideNotif:)
                                                       userInfo:nil
                                                        repeats:NO];
                    } else {
                        // There was a problem, check error.description
                        NSLog(@"Error: %@",error.description);
                    }
                }];
                PFObject *obj = [PFObject objectWithClassName:@"Admins"];
                obj[@"user"] = [PFUser currentUser];
                obj[@"organization"] = organization;
                [obj saveInBackground];
            } else {
                organization[@"verificationReason"] = [self.formValues objectForKey:ktext];
                [organization saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        notif = [JFMinimalNotification notificationWithStyle:JFMinimalNotificationStyleSuccess title:@"Success" subTitle:@"You have added a club!"];
                        UIFont* titleFont = [UIFont fontWithName:@"OpenSans-Regular" size:22];
                        [notif setTitleFont:titleFont];
                        UIFont* subTitleFont = [UIFont fontWithName:@"OpenSans-Light" size:16];
                        [notif setSubTitleFont:subTitleFont];
                        [self.view addSubview:notif];
                        [notif show];
                        [NSTimer scheduledTimerWithTimeInterval:1.0
                                                         target:self
                                                       selector:@selector(hideNotif:)
                                                       userInfo:nil
                                                        repeats:NO];
                    } else {
                        // There was a problem, check error.description
                        NSLog(@"Error: %@",error.description);
                    }
                }];
                PFObject *obj = [PFObject objectWithClassName:@"Admins"];
                obj[@"user"] = [PFUser currentUser];
                obj[@"organization"] = organization;
                [obj saveInBackground];
            }
        }
    }];
}

-(void)hideNotif:(id)sender {
    [notif dismiss];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)hideNotifNoExit:(id)sender {
    [notif dismiss];
}

@end
