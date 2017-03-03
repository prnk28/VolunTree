//
//  SearchViewController.m
//  ParseSearchNoPagination
//
//  Created by Wazir on 7/5/13.
//  Copyright (c) 2013 Wazir. All rights reserved.
//

#import "UsersFindViewController.h"
#import "FoundUserCell.h"

static NSString *const NothingFoundCellIdentifier = @"NothingFoundCell";

@interface UsersFindViewController ()
@property (nonatomic, strong) UISearchBar *searchedBar;
@property (nonatomic, strong) NSString *mainTitle;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, assign) BOOL canSearch;

@end

@implementation UsersFindViewController
@synthesize rowDescriptor = _rowDescriptor;
@synthesize popoverController = __popoverController;
@synthesize searchedBar;
@synthesize mainTitle;
@synthesize subTitle;
@synthesize canSearch;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.parseClassName = @"_User";
    self.paginationEnabled = NO;
    self.objectsPerPage = 10;
    
    [self queryForTable];
    
    self.searchedBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, 320, 44)];
    searchedBar.delegate = self;
    
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [barButton setTitle:@"" forState:UIControlStateNormal];
    [barButton setBackgroundImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [barButton addTarget:self action:@selector(didTapClose:) forControlEvents:UIControlEventTouchUpInside];
    barButton.frame = CGRectMake(0.0f, 0.0f, 10.0f, 15.0f);
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    self.tableView.tableHeaderView = searchedBar;
    [self.tableView registerNib:[UINib nibWithNibName:@"FoundUserCell" bundle:nil] forCellReuseIdentifier:@"FoundUserCell"];
    [self.searchedBar becomeFirstResponder];
    
    self.navigationItem.title = @"Find User";
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"OpenSans-Semibold" size:18]}];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.canSearch = 0;
    [self queryForTable];
    [self loadObjects];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self clear];
    
    self.canSearch = 1;
    
    [self.searchedBar resignFirstResponder];
    
    [self queryForTable];
    [self loadObjects];
    
}

#pragma mark - PFQueryTableViewController

- (void)objectsWillLoad {
    [super objectsWillLoad];
    [self queryForTable];
    // This method is called before a PFQuery is fired to get more objects
}

#pragma mark - Query

- (PFQuery *)queryForTable {
    
    PFQuery *query;
    
    if (self.canSearch == 0) {
        query = [PFQuery queryWithClassName:self.parseClassName];
        [query whereKey:@"username" notEqualTo:[[PFUser currentUser] username]];
        [query whereKey:@"fullName" notEqualTo:[[PFUser currentUser]objectForKey:@"fullName"]];
    } else {
        query = [PFQuery queryWithClassName:self.parseClassName];
        
        NSString *searchThis = [searchedBar.text lowercaseString];
        [query whereKey:@"username" containsString:searchThis];
        [query whereKey:@"fullName" containsString:searchThis];
        [query whereKey:@"username" notEqualTo:[[PFUser currentUser] username]];
        [query whereKey:@"fullName" notEqualTo:[[PFUser currentUser]objectForKey:@"fullName"]];
    }
    
    return query;
}

- (void)configureSearchResult:(FoundUserCell *)cell atIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    mainTitle = [object objectForKey:@"fullName"];
    cell.mainTitle.text = mainTitle;
    
    subTitle = [object objectForKey:@"username"];
    cell.detail.text = subTitle;
    
    
    // Implement this if you want to Show image
    cell.showImage.image = [UIImage imageNamed:@"profilePic"];
    
    PFFile *imageFile = [object objectForKey:@"profilePicture"];
    
    if (imageFile) {
        cell.showImage.file = imageFile;
        cell.showImage.layer.cornerRadius = 35.0;
        cell.showImage.clipsToBounds = YES;
        [cell.showImage loadInBackground];
    }
    
}


// Set CellForRowAtIndexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *CellIdentifier = @"FoundUserCell";
    
    //Custom Cell
    FoundUserCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FoundUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    cell.accessoryType = [[self.rowDescriptor.value valueForKeyPath:@"user.id"] isEqual:[object objectForKey:@"objectId"]] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    [self configureSearchResult:cell atIndexPath:indexPath object:object];
    
    return cell;
}

// Set TableView Height for Load Next Page
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self.objects count] == indexPath.row) {
        // Load More Cell Height
        return 60.0;
    } else {
        return 80.0;
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PFObject *photo = [self.objects objectAtIndex:indexPath.row];
    NSLog(@"%@", photo);
    
    self.rowDescriptor.value = photo;
    [[self.rowDescriptor.value valueForKeyPath:@"user.name"] isEqual:[photo objectForKey:@"fullName"]];
    
    
    if (self.popoverController){
        [self.popoverController dismissPopoverAnimated:YES];
        [self.popoverController.delegate popoverControllerDidDismissPopover:self.popoverController];
    }
    else if ([self.parentViewController isKindOfClass:[UINavigationController class]]){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchedBar resignFirstResponder];
}

- (void)didTapClose:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end