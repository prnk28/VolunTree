//
//  RequestViewController.m
//  VolunTree
//
//  Created by Pradyumn Nukala on 7/18/16.
//  Copyright © 2016 HelpOut. All rights reserved.
//

#import "RequestViewController.h"
#import "XLForm.h"
#import "DateAndTimeValueTrasformer.h"

@interface UserReqTransformer : NSValueTransformer
@end

@implementation UserReqTransformer

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
    NSDictionary *user = (NSDictionary *) value;
    NSLog(@"Changed %@",user);
    return [user valueForKeyPath:@"fullName"];
}

@end

@interface RequestViewController ()

@end

@implementation RequestViewController

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
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"Add Event"];
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Basics"];
    [form addFormSection:section];
    
    // Title
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Title" rowType:XLFormRowDescriptorTypeText];
    [row.cellConfigAtConfigure setObject:@"Title" forKey:@"textField.placeholder"];
    row.required = YES;
    [section addFormRow:row];
    
    // Location
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Location" rowType:XLFormRowDescriptorTypeText];
    [row.cellConfigAtConfigure setObject:@"Location" forKey:@"textField.placeholder"];
    row.required = YES;
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Details"];
    [form addFormSection:section];
    
    // To
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"User" rowType:XLFormRowDescriptorTypeSelectorPush title:@"User"];
    UsersFindViewController *search = [[UsersFindViewController alloc] init];
    row.valueTransformer = [UserReqTransformer class];
    row.action.viewControllerClass = [search class];
    row.required = YES;
    [section addFormRow:row];
    
    // Hour
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Hours" rowType:XLFormRowDescriptorTypeSelectorPickerViewInline title:@"Volunteer Hours: "];
    row.selectorOptions = @[@1, @2, @3, @4, @5, @6, @7, @8, @9, @10];
    row.required = YES;
    [section addFormRow:row];
    
    // Description
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Description" rowType:XLFormRowDescriptorTypeTextView];
    [row.cellConfigAtConfigure setObject:@"Description" forKey:@"textView.placeholder"];
    row.required = YES;
    [section addFormRow:row];
    
    self.form = form;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpUI];
}


#pragma mark - XLFormDescriptorDelegate

-(void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)rowDescriptor oldValue:(id)oldValue newValue:(id)newValue
{
    [super formRowDescriptorValueHasChanged:rowDescriptor oldValue:oldValue newValue:newValue];
    if ([rowDescriptor.tag isEqualToString:@"alert"]){
        if ([[rowDescriptor.value valueData] isEqualToNumber:@(0)] == NO && [[oldValue valueData] isEqualToNumber:@(0)]){
            
            XLFormRowDescriptor * newRow = [rowDescriptor copy];
            newRow.tag = @"secondAlert";
            newRow.title = @"Second Alert";
            [self.form addFormRow:newRow afterRow:rowDescriptor];
        }
        else if ([[oldValue valueData] isEqualToNumber:@(0)] == NO && [[newValue valueData] isEqualToNumber:@(0)]){
            [self.form removeFormRowWithTag:@"secondAlert"];
        }
    }
    else if ([rowDescriptor.tag isEqualToString:@"all-day"]){
        XLFormRowDescriptor * startDateDescriptor = [self.form formRowWithTag:@"starts"];
        XLFormRowDescriptor * endDateDescriptor = [self.form formRowWithTag:@"ends"];
        XLFormDateCell * dateStartCell = (XLFormDateCell *)[[self.form formRowWithTag:@"starts"] cellForFormController:self];
        XLFormDateCell * dateEndCell = (XLFormDateCell *)[[self.form formRowWithTag:@"ends"] cellForFormController:self];
        if ([[rowDescriptor.value valueData] boolValue] == YES){
            startDateDescriptor.valueTransformer = [DateValueTrasformer class];
            endDateDescriptor.valueTransformer = [DateValueTrasformer class];
            [dateStartCell setFormDatePickerMode:XLFormDateDatePickerModeDate];
            [dateEndCell setFormDatePickerMode:XLFormDateDatePickerModeDate];
        }
        else{
            startDateDescriptor.valueTransformer = [DateTimeValueTrasformer class];
            endDateDescriptor.valueTransformer = [DateTimeValueTrasformer class];
            [dateStartCell setFormDatePickerMode:XLFormDateDatePickerModeDateTime];
            [dateEndCell setFormDatePickerMode:XLFormDateDatePickerModeDateTime];
        }
        [self updateFormRow:startDateDescriptor];
        [self updateFormRow:endDateDescriptor];
    }
    else if ([rowDescriptor.tag isEqualToString:@"starts"]){
        XLFormRowDescriptor * startDateDescriptor = [self.form formRowWithTag:@"starts"];
        XLFormRowDescriptor * endDateDescriptor = [self.form formRowWithTag:@"ends"];
        if ([startDateDescriptor.value compare:endDateDescriptor.value] == NSOrderedDescending) {
            // startDateDescriptor is later than endDateDescriptor
            endDateDescriptor.value =  [[NSDate alloc] initWithTimeInterval:(60*60*24) sinceDate:startDateDescriptor.value];
            [endDateDescriptor.cellConfig removeObjectForKey:@"detailTextLabel.attributedText"];
            [self updateFormRow:endDateDescriptor];
        }
    }
    else if ([rowDescriptor.tag isEqualToString:@"ends"]){
        XLFormRowDescriptor * startDateDescriptor = [self.form formRowWithTag:@"starts"];
        XLFormRowDescriptor * endDateDescriptor = [self.form formRowWithTag:@"ends"];
        XLFormDateCell * dateEndCell = (XLFormDateCell *)[endDateDescriptor cellForFormController:self];
        if ([startDateDescriptor.value compare:endDateDescriptor.value] == NSOrderedDescending) {
            // startDateDescriptor is later than endDateDescriptor
            [dateEndCell update]; // force detailTextLabel update
            NSDictionary *strikeThroughAttribute = [NSDictionary dictionaryWithObject:@1
                                                                               forKey:NSStrikethroughStyleAttributeName];
            NSAttributedString* strikeThroughText = [[NSAttributedString alloc] initWithString:dateEndCell.detailTextLabel.text attributes:strikeThroughAttribute];
            [endDateDescriptor.cellConfig setObject:strikeThroughText forKey:@"detailTextLabel.attributedText"];
            [self updateFormRow:endDateDescriptor];
        }
        else{
            [endDateDescriptor.cellConfig removeObjectForKey:@"detailTextLabel.attributedText"];
            [self updateFormRow:endDateDescriptor];
        }
    }
}

-(void)cancelPressed:(UIBarButtonItem * __unused)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    self.navigationItem.title = @"Request";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"OpenSans-Semibold" size:18]}];
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
    PFObject *object = [PFObject objectWithClassName:@"RequestHours"];
    object[@"fromUser"] = [PFUser currentUser];
    object[@"toUser"] = [self.formValues objectForKey:@"User"];
    object[@"title"] = [self.formValues objectForKey:@"Title"];
    object[@"location"] = [self.formValues objectForKey:@"Location"];
    object[@"description"] = [self.formValues objectForKey:@"Description"];
    object[@"hours"] = [self.formValues objectForKey:@"Hours"];
    
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        // Create our installation query
        PFUser *selectedUser = [self.formValues objectForKey:@"User"];
        PFQuery *pushQuery = [PFInstallation query];
        [pushQuery whereKey:@"user" equalTo:selectedUser];
        
        // Send push notification to query
        PFPush *push = [[PFPush alloc] init];
        [push setQuery:pushQuery]; // Set our installation query
        NSString *message = [NSString stringWithFormat:@"Someone has requested you for %@ hours", [self.formValues objectForKey:@"Hours"]];
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              message, @"alert",
                              @"Increment", @"badge",
                              nil];
        [push setData:data];
        [push sendPushInBackground];
        
        notif = [JFMinimalNotification notificationWithStyle:JFMinimalNotificationStyleSuccess title:@"Success" subTitle:@"The Hours have been sent!"];
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
    }];
}

-(void)hideNotif:(id)sender {
    [notif dismiss];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
