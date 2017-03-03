//
//  UsersViewController.m
//  VolunTree
//
//  Created by Pradyumn Nukala on 11/9/15.
//  Copyright © 2015 HelpOut. All rights reserved.
//

#import "UsersViewController.h"

@interface UserCell : UITableViewCell

@property (nonatomic) UIImageView * userImage;
@property (nonatomic) UILabel * userName;

@end

@implementation UserCell

@synthesize userImage = _userImage;
@synthesize userName  = _userName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self.contentView addSubview:self.userImage];
        [self.contentView addSubview:self.userName];
        
        [self.contentView addConstraints:[self layoutConstraints]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - Views

-(UIImageView *)userImage
{
    if (_userImage) return _userImage;
    _userImage = [UIImageView new];
    [_userImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    _userImage.layer.masksToBounds = YES;
    _userImage.layer.cornerRadius = 10.0f;
    return _userImage;
}

-(UILabel *)userName
{
    if (_userName) return _userName;
    _userName = [UILabel new];
    [_userName setTranslatesAutoresizingMaskIntoConstraints:NO];
    _userName.font = [UIFont fontWithName:@"HelveticaNeue" size:15.f];
    
    return _userName;
}

#pragma mark - Layout Constraints

-(NSArray *)layoutConstraints{
    
    NSMutableArray * result = [NSMutableArray array];
    
    NSDictionary * views = @{ @"image": self.userImage,
                              @"name": self.userName};
    
    
    NSDictionary *metrics = @{@"imgSize":@50.0,
                              @"margin" :@12.0};
    
    [result addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(margin)-[image(imgSize)]-[name]"
                                                                        options:NSLayoutFormatAlignAllTop
                                                                        metrics:metrics
                                                                          views:views]];
    
    [result addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(margin)-[image(imgSize)]"
                                                                        options:0
                                                                        metrics:metrics
                                                                          views:views]];
    
    return result;
}


@end


@interface UsersViewController () <UISearchControllerDelegate>

@property (nonatomic, readonly) UsersViewController * searchResultController;
@property (nonatomic, readonly) UISearchController * searchController;

@end

@implementation UsersViewController
@synthesize rowDescriptor = _rowDescriptor;
@synthesize popoverController = __popoverController;
@synthesize searchController = _searchController;
@synthesize searchResultController = _searchResultController;

static NSString *const kCellIdentifier = @"CellIdentifier";

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UserCell class] forCellReuseIdentifier:kCellIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:_searchController.searchBar.text];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            NSLog(@"%@",[objects description]);
        }];
    
    // Back Button
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [barButton setTitle:@"" forState:UIControlStateNormal];
    [barButton setBackgroundImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [barButton addTarget:self action:@selector(popBack:) forControlEvents:UIControlEventTouchUpInside];
    barButton.frame = CGRectMake(0.0f, 0.0f, 10.0f, 15.0f);
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    // Set Title
    self.navigationItem.title = @"FIND USER";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor],
                                                                     NSForegroundColorAttributeName,
                                                                     [UIFont fontWithName:@"Nova-Black" size:30.0], NSFontAttributeName, nil]];
    
    if (!self.isSearchResultsController){
        self.tableView.tableHeaderView = self.searchController.searchBar;
    }
    else{
        [self.tableView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
        [self.tableView setScrollIndicatorInsets:self.tableView.contentInset];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.searchController.searchBar sizeToFit];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserCell *cell = (UserCell *) [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];;
    
    
    //cell.userName.text = [dataItem valueForKeyPath:@"user.name"];
   // [cell.userImage setImageWithURL:[NSURL URLWithString:[dataItem valueForKeyPath:@"user.imageURL"]] placeholderImage:[UIImage imageNamed:@"default-avatar"]];
    
    //cell.accessoryType = [[self.rowDescriptor.value valueForKeyPath:@"user.id"] isEqual:[dataItem valueForKeyPath:@"user.id"]] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 73.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.popoverController){
        [self.popoverController dismissPopoverAnimated:YES];
        [self.popoverController.delegate popoverControllerDidDismissPopover:self.popoverController];
    }
    else if ([self.parentViewController isKindOfClass:[UINavigationController class]]){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UISearchController

-(UISearchController *)searchController
{
    if (_searchController) return _searchController;
    
    self.definesPresentationContext = YES;
    _searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultController];
    _searchController.delegate = self;
    _searchController.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_searchController.searchBar sizeToFit];
    return _searchController;
}

- (void)popBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(UsersViewController *)searchResultController
{
    if (_searchResultController) return _searchResultController;
    _searchResultController = [[UsersViewController alloc]init];
    _searchResultController.isSearchResultsController = YES;
    return _searchResultController;
}

@end