//
//  FindOrganizationViewController.m
//  VolunTree
//
//  Created by Pradyumn Nukala on 1/4/16.
//  Copyright © 2016 HelpOut. All rights reserved.
//

#import "FindOrganizationViewController.h"
#import "FoundUserCell.h"

static NSString *const NothingFoundCellIdentifier = @"NothingFoundCell";

@interface FindOrganizationViewController ()
@property (nonatomic, strong) UISearchBar *searchedBar;
@property (nonatomic, strong) NSString *mainTitle;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, assign) BOOL canSearch;
@end

@implementation FindOrganizationViewController
@synthesize rowDescriptor = _rowDescriptor;
@synthesize popoverController = __popoverController;
@synthesize searchedBar;
@synthesize mainTitle;
@synthesize subTitle;
@synthesize canSearch;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    
    self.parseClassName = @"Organizations";
    self.paginationEnabled = NO;
    self.objectsPerPage = 10;
    
    self.searchedBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, 320, 44)];
    searchedBar.delegate = self;
    
    self.tableView.tableHeaderView = searchedBar;
    [self.tableView registerNib:[UINib nibWithNibName:@"FoundUserCell" bundle:nil] forCellReuseIdentifier:@"FoundUserCell"];
    [self.searchedBar becomeFirstResponder];
}

-(void)cancelPressed:(UIBarButtonItem * __unused)button
{
    [self.searchedBar resignFirstResponder];
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Find Club";
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
    
    // This method is called before a PFQuery is fired to get more objects
}

#pragma mark - Query

- (PFQuery *)queryForTable {
    
    PFQuery *query;
    
    if (self.canSearch == 0) {
        query = [PFQuery queryWithClassName:self.parseClassName];
    } else {
        query = [PFQuery queryWithClassName:self.parseClassName];
        
        NSString *searchThis = searchedBar.text;
        [query whereKey:@"Name" containsString:searchThis];
    }
    
    return query;
}

- (void)configureSearchResult:(FoundUserCell *)cell atIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    mainTitle = [object objectForKey:@"Name"];
    cell.mainTitle.text = mainTitle;
    
    subTitle = [object objectForKey:@"description"];
    cell.detail.text = subTitle;
    
    
    // Implement this if you want to Show image
    cell.showImage.image = [UIImage imageNamed:@"profilePic"];
    
    PFFile *imageFile = [object objectForKey:@"image"];
    
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrganizationViewController *destViewController = [[OrganizationViewController alloc] init];
    destViewController.object = [self.objects objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:destViewController animated:YES];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchedBar resignFirstResponder];
}

- (void)didTapClose:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
