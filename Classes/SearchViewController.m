//
//  SearchViewController.m
//
//
//  Created by Pradyumn Nukala on 8/28/15.
//
//

#import "SearchViewController.h"
#import "SearchChildVC.h"

@interface SearchViewController () <CarbonTabSwipeNavigationDelegate> {
    NSArray *items;
    
    CarbonTabSwipeNavigation *carbonTabSwipeNavigation;
}

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 5, (self.navigationController.navigationBar.frame.size.width - 20), 34)];
    self.searchBar.translucent = NO;
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Search";
    for(UIView *subView in self.searchBar.subviews) {
        if ([subView isKindOfClass:[UITextField class]]) {
            UITextField *searchField = (UITextField *)subView;
            searchField.font = [UIFont fontWithName:@"OpenSans-Light" size:11];
        }
    }
    [self.searchBar setTintColor:[UIColor treeColor]];
    [self.navigationController.navigationBar addSubview:self.searchBar];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    [self setUpUI];
    
    items = @[
              @"Top",
              @"People",
              @"Organizations"
              ];
    
    carbonTabSwipeNavigation = [[CarbonTabSwipeNavigation alloc] initWithItems:items delegate:self];
    [carbonTabSwipeNavigation insertIntoRootViewController:self];
    [self style];
}

- (void)style {
    
    UIColor *color = [UIColor treeColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = color;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    carbonTabSwipeNavigation.toolbar.translucent = NO;
    [carbonTabSwipeNavigation setTabBarHeight:35];
    [carbonTabSwipeNavigation setIndicatorColor:color];
    [carbonTabSwipeNavigation setTabExtraWidth:35];
    [carbonTabSwipeNavigation.carbonSegmentedControl setWidth:80 forSegmentAtIndex:0];
    [carbonTabSwipeNavigation.carbonSegmentedControl setWidth:80 forSegmentAtIndex:1];
    [carbonTabSwipeNavigation.carbonSegmentedControl setWidth:80 forSegmentAtIndex:2];
    
    // Custimize segmented control
    [carbonTabSwipeNavigation setNormalColor:[color colorWithAlphaComponent:0.8]
                                        font:[UIFont fontWithName:@"OpenSans-Light" size:11.0]];
    [carbonTabSwipeNavigation setSelectedColor:color font:[UIFont fontWithName:@"OpenSans-Semibold" size:11.0]];
}


- (void)setUpUI{
    [super loadView];
    
    // Cancel Button in Search
    UIBarButtonItem *searchBarButton = [UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil];
    NSDictionary *normalAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont fontWithName:@"OpenSans-Light" size:15], NSFontAttributeName,
                                      nil];
    
    [searchBarButton setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
    [searchBarButton setTitleTextAttributes:normalAttributes forState:UIControlStateHighlighted];
    
    // Placeholder Font
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{
                                                                                                 NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:15]}];
}

// delegate
- (UIViewController *)carbonTabSwipeNavigation:(CarbonTabSwipeNavigation *)carbonTabSwipeNavigation
                         viewControllerAtIndex:(NSUInteger)index {
    if(index == 0){
        SearchChildVC *svc = [[SearchChildVC alloc] init];
        svc.results = nil;
        [self searchTop:_searchBar.text];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reload_data" object:self];
        return svc;
    }else if(index == 1){
        SearchChildVC *svc = [[SearchChildVC alloc] init];
        svc.results = nil;
        [self searchPeople:_searchBar.text];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reload_data" object:self];
        return svc;
    }else if(index == 2){
        SearchChildVC *svc = [[SearchChildVC alloc] init];
        svc.results = nil;
        [self searchOrganizations:_searchBar.text];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reload_data" object:self];
        return svc;
    }
    return [[SearchChildVC alloc] init];
}

- (void)carbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation
                  didMoveAtIndex:(NSUInteger)index {
    if(index == 0){
        [ArrayManager sharedInstance].searchResults = nil;
        [self searchTop:_searchBar.text];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reload_data" object:self];
    }else if(index == 1){
        [ArrayManager sharedInstance].searchResults = nil;
        [self searchPeople:_searchBar.text];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reload_data" object:self];
    }else if(index == 2){
        [ArrayManager sharedInstance].searchResults = nil;
        [self searchOrganizations:_searchBar.text];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reload_data" object:self];
    }
}

- (void)didTapPostButton:(id)sender {
    [self.searchBar resignFirstResponder];
    [self.sidePanelController showRightPanelAnimated:YES];
}



-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (carbonTabSwipeNavigation.currentTabIndex == 0) {
        [self searchTop:searchText];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reload_data" object:self];
    } else if (carbonTabSwipeNavigation.currentTabIndex == 1){
        [self searchPeople:searchText];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reload_data" object:self];
    }else {
        [self searchOrganizations:searchText];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reload_data" object:self];
    }
}

- (void)searchPeople:(NSString*)text {
    if(![text isEqualToString:@""]){
        PFQuery *userWithName = [PFQuery queryWithClassName:@"_User"];
        [userWithName whereKey:@"fullName" containsString:text];
        
        PFQuery *userWithHandle = [PFQuery queryWithClassName:@"_User"];
        [userWithHandle whereKey:@"username" containsString:text];
        
        PFQuery *userQuery = [PFQuery orQueryWithSubqueries:@[userWithHandle,userWithName]];
        [userQuery findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
            NSLog(@"USERS: %@",results);
            self.userResults = nil;
            self.userResults = results;
            NSMutableArray *mutUser = [self.userResults mutableCopy];
            [ArrayManager sharedInstance].searchResults = mutUser;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reload_data" object:self];
        }];
    } else {
        [ArrayManager sharedInstance].searchResults = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reload_data" object:self];
    }
}

- (void)searchOrganizations:(NSString*)text {
    if(![text isEqualToString:@""]){
        PFQuery *organizationWithName = [PFQuery queryWithClassName:@"Organizations"];
        [organizationWithName whereKey:@"Name" containsString:text];
        
        PFQuery *organizationWithMotto = [PFQuery queryWithClassName:@"Organizations"];
        [organizationWithMotto whereKey:@"motto" containsString:text];
        
        PFQuery *organizationQuery = [PFQuery orQueryWithSubqueries:@[organizationWithName,organizationWithMotto]];
        [organizationQuery findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
            NSLog(@"ORGANIZATIONS: %@",results);
            self.organizationsResults = nil;
            self.organizationsResults = results;
            NSMutableArray *mutOrg = [self.organizationsResults mutableCopy];
            [ArrayManager sharedInstance].searchResults = mutOrg;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reload_data" object:self];

        }];
    } else {
        [ArrayManager sharedInstance].searchResults = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reload_data" object:self];
    }
}

- (void)searchTop:(NSString*)text {
    if(![text isEqualToString:@""]){
        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
            // Fetch Users
            PFQuery *userWithName = [PFQuery queryWithClassName:@"_User"];
            [userWithName whereKey:@"fullName" containsString:text];
            PFQuery *userWithHandle = [PFQuery queryWithClassName:@"_User"];
            [userWithHandle whereKey:@"username" containsString:text];
            PFQuery *userQuery = [PFQuery orQueryWithSubqueries:@[userWithHandle,userWithName]];
            [userQuery findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
                NSLog(@"USERS: %@",results);
                self.userResults = nil;
                self.userResults = results;
                NSMutableArray *mutUsr = [self.userResults mutableCopy];
                [ArrayManager sharedInstance].searchResults = mutUsr;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reload_data" object:self];
            }];
            
            // Fetch Clubs
            PFQuery *organizationWithName = [PFQuery queryWithClassName:@"Organizations"];
            [organizationWithName whereKey:@"Name" containsString:text];
            PFQuery *organizationWithMotto = [PFQuery queryWithClassName:@"Organizations"];
            [organizationWithMotto whereKey:@"motto" containsString:text];
            PFQuery *organizationQuery = [PFQuery orQueryWithSubqueries:@[organizationWithName,organizationWithMotto]];
            [organizationQuery findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
                NSLog(@"ORGANIZATIONS: %@",results);
                self.organizationsResults = nil;
                self.organizationsResults = results;
                NSMutableArray *mutOrg = [self.organizationsResults mutableCopy];
                [[ArrayManager sharedInstance].searchResults addObjectsFromArray:mutOrg];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reload_data" object:self];
            }];
        }];
    } else {
        // If nothing is found
        [ArrayManager sharedInstance].searchResults = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reload_data" object:self];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (carbonTabSwipeNavigation.currentTabIndex == 0) {
        [self searchTop:searchBar.text];
        [searchBar resignFirstResponder];
    } else if(carbonTabSwipeNavigation.currentTabIndex == 1){
        [self searchPeople:searchBar.text];
        [searchBar resignFirstResponder];
    }else {
        [self searchOrganizations:searchBar.text];
        [searchBar resignFirstResponder];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:NO animated:YES];
}

-(void)dismissKeyboard {
    [self.searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    if (![PFUser currentUser]) {
        LoginViewController *login = [[LoginViewController alloc] init];
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:login];
        [self.navigationController presentViewController:loginNav animated:YES completion:NULL];
    }
}

@end
