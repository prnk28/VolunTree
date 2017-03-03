//
//  LogViewController.m
//
//
//  Created by Pradyumn Nukala on 8/28/15.
//
//

#import "XLForm.h"
#import "DateAndTimeValueTrasformer.h"
#import "LogViewController.h"

@implementation LogViewController

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
    
    
    self.navigationItem.title = @"Log";
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
    PFUser *currentUser = [PFUser currentUser];
    PFACL *ACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [ACL setPublicReadAccess:YES];
    
    PFObject *volunteerSheet = [PFObject objectWithClassName:@"VolunteerSheet"];
    volunteerSheet[@"userLog"] = @YES;
    volunteerSheet[@"toUser"] = currentUser;
    volunteerSheet[@"volunteerTitle"] = [self.formValues objectForKey:@"Title"];
    volunteerSheet[@"location"] = [self.formValues objectForKey:@"Location"];
    volunteerSheet[@"volunteerHours"] = [self.formValues objectForKey:@"Hours"];
    volunteerSheet[@"volunteerDescription"] = [self.formValues objectForKey:@"Description"];
    volunteerSheet.ACL = ACL;
    [volunteerSheet saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            PFQuery *query = [PFQuery queryWithClassName:@"Hours"];
            [query whereKey:@"user" equalTo:currentUser];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    for (PFObject *object in objects) {
                        // change total hours
                        NSNumber *ogValue = object[@"totalHours"];
                        NSNumber *moreHours = [self.formValues objectForKey:@"hours"];
                        NSNumber *newValue = [NSNumber numberWithFloat:([ogValue floatValue] + [moreHours floatValue])];
                        NSLog(@"New Hours: %@",newValue);
                        object[@"totalHours"] = newValue;
                        
                        // change weekly hours
                        if ([object[@"weekDayDate"]  isEqual: @7]) {
                            object[@"lastWeek"] = object[@"thisWeek"];
                            object[@"thisWeek"] = @0;
                            NSLog(@"Refresh weekly boxes");
                        }else{
                            NSNumber *ogValue = object[@"thisWeek"];
                            NSNumber *moreHours = [self.formValues objectForKey:@"hours"];
                            NSNumber *newValue = [NSNumber numberWithFloat:([ogValue floatValue] + [moreHours floatValue])];
                            NSLog(@"New Hours Week: %@",newValue);
                            object[@"thisWeek"] = newValue;
                        }
                        
                        // change monthly hours
                        NSDate *currDate = [NSDate date];
                        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                        NSDateComponents *dateComponents = [gregorian components:(NSCalendarUnitYear  | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:currDate];
                        NSInteger m = [dateComponents month];
                        NSLog(@"Current month %ld", (long)m);
                        if (m == 1) {
                            NSNumber *ogValue = object[@"Jan"];
                            NSNumber *moreHours = [self.formValues objectForKey:@"hours"];
                            NSNumber *newValue = [NSNumber numberWithFloat:([ogValue floatValue] + [moreHours floatValue])];
                            NSLog(@"New Hours Mont: %@",newValue);
                            object[@"Jan"] = newValue;
                        }else if(m == 2) {
                            NSNumber *ogValue = object[@"Feb"];
                            NSNumber *moreHours = [self.formValues objectForKey:@"hours"];
                            NSNumber *newValue = [NSNumber numberWithFloat:([ogValue floatValue] + [moreHours floatValue])];
                            NSLog(@"New Hours Mont: %@",newValue);
                            object[@"Feb"] = newValue;
                        }else if(m == 3) {
                            NSNumber *ogValue = object[@"Mar"];
                            NSNumber *moreHours = [self.formValues objectForKey:@"hours"];
                            NSNumber *newValue = [NSNumber numberWithFloat:([ogValue floatValue] + [moreHours floatValue])];
                            NSLog(@"New Hours Mont: %@",newValue);
                            object[@"Mar"] = newValue;
                        }else if(m == 4) {
                            NSNumber *ogValue = object[@"Apr"];
                            NSNumber *moreHours = [self.formValues objectForKey:@"hours"];
                            NSNumber *newValue = [NSNumber numberWithFloat:([ogValue floatValue] + [moreHours floatValue])];
                            NSLog(@"New Hours Mont: %@",newValue);
                            object[@"Apr"] = newValue;
                        }else if(m == 5) {
                            NSNumber *ogValue = object[@"May"];
                            NSNumber *moreHours = [self.formValues objectForKey:@"hours"];
                            NSNumber *newValue = [NSNumber numberWithFloat:([ogValue floatValue] + [moreHours floatValue])];
                            NSLog(@"New Hours Mont: %@",newValue);
                            object[@"May"] = newValue;
                        }else if(m == 6) {
                            NSNumber *ogValue = object[@"Jun"];
                            NSNumber *moreHours = [self.formValues objectForKey:@"hours"];
                            NSNumber *newValue = [NSNumber numberWithFloat:([ogValue floatValue] + [moreHours floatValue])];
                            NSLog(@"New Hours Mont: %@",newValue);
                            object[@"Jun"] = newValue;
                        }else if(m == 7){
                            NSNumber *ogValue = object[@"Jul"];
                            NSNumber *moreHours = [self.formValues objectForKey:@"hours"];
                            NSNumber *newValue = [NSNumber numberWithFloat:([ogValue floatValue] + [moreHours floatValue])];
                            NSLog(@"New Hours Mont: %@",newValue);
                            object[@"Jul"] = newValue;
                        }else if(m == 8) {
                            NSNumber *ogValue = object[@"Aug"];
                            NSNumber *moreHours = [self.formValues objectForKey:@"hours"];
                            NSNumber *newValue = [NSNumber numberWithFloat:([ogValue floatValue] + [moreHours floatValue])];
                            NSLog(@"New Hours Mont: %@",newValue);
                            object[@"Aug"] = newValue;
                        }else if(m == 9) {
                            NSNumber *ogValue = object[@"Sep"];
                            NSNumber *moreHours = [self.formValues objectForKey:@"hours"];
                            NSNumber *newValue = [NSNumber numberWithFloat:([ogValue floatValue] + [moreHours floatValue])];
                            NSLog(@"New Hours Mont: %@",newValue);
                            object[@"Sep"] = newValue;
                        }else if(m == 10) {
                            NSNumber *ogValue = object[@"Oct"];
                            NSNumber *moreHours = [self.formValues objectForKey:@"hours"];
                            NSNumber *newValue = [NSNumber numberWithFloat:([ogValue floatValue] + [moreHours floatValue])];
                            NSLog(@"New Hours Mont: %@",newValue);
                            object[@"Nov"] = newValue;
                        }else if(m == 11) {
                            NSNumber *ogValue = object[@"Nov"];
                            NSNumber *moreHours = [self.formValues objectForKey:@"hours"];
                            NSNumber *newValue = [NSNumber numberWithFloat:([ogValue floatValue] + [moreHours floatValue])];
                            NSLog(@"New Hours Mont: %@",newValue);
                            object[@"totalHours"] = newValue;
                        }else if(m == 12) {
                            NSNumber *ogValue = object[@"Dec"];
                            NSNumber *moreHours = [self.formValues objectForKey:@"hours"];
                            NSNumber *newValue = [NSNumber numberWithFloat:([ogValue floatValue] + [moreHours floatValue])];
                            NSLog(@"New Hours Mont: %@",newValue);
                            object[@"Dec"] = newValue;
                        }
                        // Save Object
                        [object saveInBackground];
                    }
                } else {
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
            
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
            
        } else {
            // There was a problem, check error.description
            NSLog(@"Error: %@",error.description);
        }
    }];
}

-(void)hideNotif:(id)sender {
    [notif dismiss];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
