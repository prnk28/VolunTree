//
//  SearchViewController.m
//  ParseSearchNoPagination
//
//  Created by Wazir on 7/5/13.
//  Copyright (c) 2013 Wazir. All rights reserved.
//

#import "CategoryOrganizationVC.h"
#import "FoundUserCell.h"

static NSString *const NothingFoundCellIdentifier = @"NothingFoundCell";

@interface CategoryOrganizationVC ()
@property (nonatomic, strong) NSString *mainTitle;
@property (nonatomic, strong) NSString *subTitle;

@end

@implementation CategoryOrganizationVC
@synthesize rowDescriptor = _rowDescriptor;
@synthesize popoverController = __popoverController;
@synthesize mainTitle;
@synthesize subTitle;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - UIViewController

-(void)setupData{
    OrganizationCategory *cat1 = [[OrganizationCategory alloc] init];
    cat1.name = @"School";
    cat1.descriptionS = @"A school related club or organization";
    cat1.image = [UIImage imageNamed:@"apple"];
    
    OrganizationCategory *cat2 = [[OrganizationCategory alloc] init];
    cat2.name = @"Religous";
    cat2.descriptionS = @"A religiously affiliated organization.";
    cat2.image = [UIImage imageNamed:@"chapel"];
    
    OrganizationCategory *cat3 = [[OrganizationCategory alloc] init];
    cat3.name = @"Sports";
    cat3.descriptionS = @"A sports related club or organization";
    cat3.image = [UIImage imageNamed:@"basketball"];
    
    OrganizationCategory *cat4 = [[OrganizationCategory alloc] init];
    cat4.name = @"Other";
    cat4.descriptionS = @"Anything that does not fit these three organizations";
    cat4.image = [UIImage imageNamed:@"brain"];
    
    self.objects = [NSArray arrayWithObjects:cat1,cat2,cat3,cat4, nil];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [barButton setTitle:@"" forState:UIControlStateNormal];
    [barButton setBackgroundImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [barButton addTarget:self action:@selector(didTapClose:) forControlEvents:UIControlEventTouchUpInside];
    barButton.frame = CGRectMake(0.0f, 0.0f, 10.0f, 15.0f);
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    
    self.navigationItem.leftBarButtonItem = barButtonItem;
    [self.tableView registerNib:[UINib nibWithNibName:@"FoundUserCell" bundle:nil] forCellReuseIdentifier:@"FoundUserCell"];
    
    self.navigationItem.title = @"Category";
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"OpenSans-Semibold" size:18]}];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"FoundUserCell";
    
    OrganizationCategory *data = self.objects[indexPath.row];
    
    //Custom Cell
    FoundUserCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FoundUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    mainTitle = data.name;
    cell.mainTitle.text = mainTitle;
    
    subTitle = data.descriptionS;
    cell.detail.text = subTitle;
    
    cell.showImage.image = data.image;
    [cell.showImage autoSetDimension:ALDimensionHeight toSize:45];
    [cell.showImage autoSetDimension:ALDimensionWidth toSize:45];
    [cell.showImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
    [cell.showImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    
    return cell;
}

// Set TableView Height for Load Next Page
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        // Load More Cell Height
        return 60.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.objects count];    //count number of row from counting array hear
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OrganizationCategory *photo = self.objects[indexPath.row];
    
    self.rowDescriptor.value = photo;
    
    if (self.popoverController){
        [self.popoverController dismissPopoverAnimated:YES];
        [self.popoverController.delegate popoverControllerDidDismissPopover:self.popoverController];
    }
    else if ([self.parentViewController isKindOfClass:[UINavigationController class]]){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)didTapClose:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end