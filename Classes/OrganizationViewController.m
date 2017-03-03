//
//  OrganizationViewController.m
//  VolunTree
//
//  Created by Pradyumn Nukala on 12/30/15.
//  Copyright © 2015 HelpOut. All rights reserved.
//

#import "OrganizationViewController.h"

@interface OrganizationViewController ()

@property (strong, nonatomic) LGPlusButtonsView *plusButtonsViewMain;

@end

@implementation OrganizationViewController{
    NSMutableArray * rowIdArray;
}
@synthesize heartButton;

- (void)viewWillAppear:(BOOL)animated {
    [self viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    OrganizationHeaderView *header = [[OrganizationHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 177)withDictionary:self.object];
    self.tableView.parallaxHeader.view = header;
    self.tableView.parallaxHeader.height = 177;
    self.tableView.parallaxHeader.minimumHeight = 5;
    //[self.tableView registerClass:[OrganizationPostCell class] forCellReuseIdentifier:@"orgPostCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)viewDidAppear:(BOOL)animated{
    [self fetchData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    rowIdArray=[[NSMutableArray alloc]init];
    [self setupUI];
    [self fetchData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:@"reload_data_org" object:nil];
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Organizations"];
    [query whereKey:@"objectId" equalTo:self.object.objectId];
    [query whereKey:@"members" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects.count == 0) {
            
        }else{
            _plusButtonsViewMain = [LGPlusButtonsView plusButtonsViewWithNumberOfButtons:1
                                                                 firstButtonIsPlusButton:YES
                                                                           showAfterInit:YES
                                                                           actionHandler:^(LGPlusButtonsView *plusButtonView, NSString *title, NSString *description, NSUInteger index)
                                    {
                                        if (index == 0)
                                            [self didTapPost:self];
                                        
                                    }];
            
            _plusButtonsViewMain.observedScrollView = self.tableView;
            _plusButtonsViewMain.position = LGPlusButtonsViewPositionBottomRight;
            _plusButtonsViewMain.plusButtonAnimationType = LGPlusButtonAnimationTypeRotate;
            
            [_plusButtonsViewMain setButtonsTitles:@[@"+"] forState:UIControlStateNormal];
            [_plusButtonsViewMain setButtonsImages:@[[NSNull new]]
                                          forState:UIControlStateNormal
                                    forOrientation:LGPlusButtonsViewOrientationAll];
            
            [_plusButtonsViewMain setButtonsAdjustsImageWhenHighlighted:NO];
            [_plusButtonsViewMain setButtonsBackgroundColor:[UIColor colorWithRed:0.906 green:0.122 blue:0.388 alpha:1] forState:UIControlStateNormal];
            [_plusButtonsViewMain setButtonsSize:CGSizeMake(44.f, 44.f) forOrientation:LGPlusButtonsViewOrientationAll];
            [_plusButtonsViewMain setButtonsLayerCornerRadius:44.f/2.f forOrientation:LGPlusButtonsViewOrientationAll];
            [_plusButtonsViewMain setButtonsTitleFont:[UIFont boldSystemFontOfSize:24.f] forOrientation:LGPlusButtonsViewOrientationAll];
            [_plusButtonsViewMain setButtonAtIndex:0 size:CGSizeMake(56.f, 56.f)
                                    forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
            [_plusButtonsViewMain setButtonAtIndex:0 layerCornerRadius:56.f/2.f
                                    forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
            [_plusButtonsViewMain setButtonAtIndex:0 titleFont:[UIFont systemFontOfSize:40.f]
                                    forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
            [_plusButtonsViewMain setButtonAtIndex:0 titleOffset:CGPointMake(0.f, -3.f) forOrientation:LGPlusButtonsViewOrientationAll];
            
            [_plusButtonsViewMain setDescriptionsBackgroundColor:[UIColor whiteColor]];
            [_plusButtonsViewMain setDescriptionsTextColor:[UIColor blackColor]];
            [_plusButtonsViewMain setDescriptionsLayerShadowColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.f]];
            [_plusButtonsViewMain setDescriptionsLayerShadowOpacity:0.25];
            [_plusButtonsViewMain setDescriptionsLayerShadowRadius:1.f];
            [_plusButtonsViewMain setDescriptionsLayerShadowOffset:CGSizeMake(0.f, 1.f)];
            [_plusButtonsViewMain setDescriptionsLayerCornerRadius:6.f forOrientation:LGPlusButtonsViewOrientationAll];
            [_plusButtonsViewMain setDescriptionsContentEdgeInsets:UIEdgeInsetsMake(4.f, 8.f, 4.f, 8.f) forOrientation:LGPlusButtonsViewOrientationAll];
            [self.view addSubview:_plusButtonsViewMain];
        }
    }];
    

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

-(void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *organizationTitle = [self.object objectForKey:@"Name"];
    [self.navigationItem setTitle:organizationTitle];
    self.view.backgroundColor = [UIColor whiteColor];
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
    
    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [postButton setTitle:@"" forState:UIControlStateNormal];
    [postButton setBackgroundImage:[UIImage imageNamed:@"gearIcon"] forState:UIControlStateNormal];
    [postButton addTarget:self action:@selector(didTapGear:) forControlEvents:UIControlEventTouchUpInside];
    postButton.frame = CGRectMake(0.0f, 0.0f, 18.0f, 18.0f);
    UIBarButtonItem *postButtonItem = [[UIBarButtonItem alloc] initWithCustomView:postButton];
    self.navigationItem.rightBarButtonItem = postButtonItem;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *data = self.posts[indexPath.row];
    
    OrganizationPostCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"orgPostCell"];
    if (cell == nil)
    {
        cell = [[OrganizationPostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orgPostCell" withObject:data];
    }
    
     return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *data = self.posts[indexPath.row];
    NSString *labelText = [data objectForKey:@"status"];
    UIFont *cellFont = [UIFont fontWithName:@"OpenSans-Light" size:12.0];
    CGSize size = [self findHeightForText:labelText havingWidth:240 andFont:cellFont];
    return size.height + 65;
}

- (void)fetchData {
    if([PFUser currentUser]){
        PFQuery *query = [PFQuery queryWithClassName:@"OrganizationPost"];
        [query whereKey:@"organization" equalTo:self.object];
        [query orderByDescending:@"updatedAt"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            NSLog(@"Successfully retrieved %lu logs.", (unsigned long)objects.count);
            if (!error) {
                self.posts = objects;
                [self.tableView reloadData];
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
}


- (void)didTapClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didTapPost:(id)sender {
    PostViewController *pvc = [[PostViewController alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Organizations"];
    [query whereKey:@"Name" equalTo:self.object[@"Name"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                pvc.organization = object;
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    UINavigationController *navsvc = [[UINavigationController alloc] initWithRootViewController:pvc];
    
    [self presentViewController:navsvc animated:YES completion:nil];
}

- (void)didTapGear:(id)sender {
    [self.sidePanelController showRightPanelAnimated:YES];
}

-(void)reload {
    [self.tableView beginUpdates];
    [self fetchData];
    [self.tableView reloadInputViews];
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self.tableView reloadData];
    });
    [self.tableView endUpdates];
}


- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PFObject *post = self.posts[indexPath.row];
    OrganizationDetailViewController *destViewController = [[OrganizationDetailViewController alloc] init];
    destViewController.object = post;
    [self.navigationController pushViewController:destViewController animated:YES];
}

- (NSIndexPath *)indexPathForCellContainingView:(UIView *)view {
    while (view != nil) {
        if ([view isKindOfClass:[ProfileTableViewCell class]]) {
            return [self.tableView indexPathForCell:(ProfileTableViewCell *)view];
        } else {
            view = [view superview];
        }
    }
    return nil;
}

@end
