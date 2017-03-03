//
//  NotificationViewController.m
//
//
//  Created by Pradyumn Nukala on 8/28/15.
//
//

#import "NotificationViewController.h"
#import "RequestViewController.h"

// Numerics
CGFloat const kJBBarChartViewControllerChartHeight = 250.0f;
CGFloat const kJBBarChartViewControllerChartPadding = 10.0f;
CGFloat const kJBBarChartViewControllerChartHeaderHeight = 80.0f;
CGFloat const kJBBarChartViewControllerChartHeaderPadding = 20.0f;
CGFloat const kJBBarChartViewControllerChartFooterHeight = 25.0f;
CGFloat const kJBBarChartViewControllerChartFooterPadding = 5.0f;
CGFloat const kJBBarChartViewControllerBarPadding = 1.0f;
NSInteger const kJBBarChartViewControllerNumBars = 12;
NSInteger const kJBBarChartViewControllerMaxBarHeight = 10;
NSInteger const kJBBarChartViewControllerMinBarHeight = 5;

// Strings
NSString * const kJBBarChartViewControllerNavButtonViewKey = @"view";

@interface NotificationViewController () <JBBarChartViewDelegate, JBBarChartViewDataSource>

@property (nonatomic, strong) JBChartInformationView *informationView;
@property (nonatomic, strong) NSArray *chartData;
@property (nonatomic)JZMultiChoicesCircleButton *NewBTN ;
@property (nonatomic, strong) JBBarChartView *barChartView;
@property (nonatomic, strong) NSArray *monthlySymbols;
// Data
- (void)initFakeData;
@end

@implementation NotificationViewController
@synthesize NewBTN;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    _monthlySymbols = [[[NSDateFormatter alloc] init] shortMonthSymbols];
    [self initFakeData];
    [self setupGraph];
    
#pragma mark - Exact Label
    UILabel *exactlLabel = [[UILabel alloc] init];
    [exactlLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    exactlLabel.backgroundColor = [UIColor clearColor];
    exactlLabel.textColor = [UIColor colorWithRed:0.392 green:0.412 blue:0.424 alpha:1];
    exactlLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:14.715];
    exactlLabel.text = NSLocalizedString(@"Exact statistics:", nil);
    
    [self.view addSubview:exactlLabel];
    
    // align exactlLabel from the top
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-271.5-[exactlLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(exactlLabel)]];
    
    // align exactlLabel from the left
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17.5-[exactlLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(exactlLabel)]];
    
    // width constraint
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[exactlLabel(==120)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(exactlLabel)]];
    
    // height constraint
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[exactlLabel(==10.5)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(exactlLabel)]];


    
#pragma mark - Last Month Box
    UIImageView *lastMonthBox = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lastMonthBox"]];
    [lastMonthBox setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:lastMonthBox];
    
    if (self.view.frame.size.width >350) {
        [lastMonthBox autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:exactlLabel withOffset:50];
        [lastMonthBox autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
        [lastMonthBox autoSetDimension:ALDimensionHeight toSize:67];
        [lastMonthBox autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:(self.view.frame.size.width)/2+5];
    } else {
        [lastMonthBox autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:exactlLabel withOffset:10];
        [lastMonthBox autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
        [lastMonthBox autoSetDimension:ALDimensionHeight toSize:67];
        [lastMonthBox autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:(self.view.frame.size.width)/2+5];
    }
    

    
#pragma mark - Last Week Box
    UIImageView *lastWeekBox = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lastWeekBox"]];
    [lastWeekBox setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:lastWeekBox];
    
    [lastWeekBox autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:lastMonthBox];
    [lastWeekBox autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [lastWeekBox autoSetDimension:ALDimensionHeight toSize:67];
    [lastWeekBox autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:lastMonthBox withOffset:5];
    
#pragma mark - This Month Box
    UIImageView *thisMonthBox = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"thisMonthBox"]];
    [thisMonthBox setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:thisMonthBox];
    
    [thisMonthBox autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lastMonthBox withOffset:5];
    [thisMonthBox autoSetDimension:ALDimensionHeight toSize:67];
    [thisMonthBox autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    [thisMonthBox autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:(self.view.frame.size.width)/2+5];
    
#pragma mark - This Week Box
    UIImageView *thisWeekBox = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"thisWeekBox"]];
    [thisWeekBox setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:thisWeekBox];
    
    [thisWeekBox autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lastWeekBox withOffset:5];
    [thisWeekBox autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [thisWeekBox autoSetDimension:ALDimensionHeight toSize:67];
    [thisWeekBox autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:lastMonthBox withOffset:5];
    
    //
    // Setup Boxes
    //
    
    PFQuery *query = [PFQuery queryWithClassName:@"Hours"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *object in objects) {
            
#pragma mark - Last Month Label
            UILabel *lastMonthLabel = [[UILabel alloc] init];
            [lastMonthLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            lastMonthLabel.backgroundColor = [UIColor clearColor];
            if([object[@"lastMonth"]  isEqual: @0]){
                lastMonthLabel.textColor = [UIColor redColor];
            }else{
                lastMonthLabel.textColor = [UIColor treeColor];
            }
            lastMonthLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:16.588];
            NSString *lastMonthString = [NSString stringWithFormat:@"%@ Hours", object[@"lastMonth"]];
            lastMonthLabel.text = lastMonthString;
            
            [self.view addSubview:lastMonthLabel];
            
            [lastMonthLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:lastMonthBox withOffset:-8];
            [lastMonthLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:lastMonthBox withOffset:0];
            
#pragma mark - Last Week Label
            UILabel *lastWeekLabel = [[UILabel alloc] init];
            [lastWeekLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            lastWeekLabel.backgroundColor = [UIColor clearColor];
            if([object[@"lastWeek"]  isEqual: @0]){
                lastWeekLabel.textColor = [UIColor redColor];
            }else{
                lastWeekLabel.textColor = [UIColor treeColor];
            }
            lastWeekLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:16.588];
            NSString *lastWeekString = [NSString stringWithFormat:@"%@ Hours", object[@"lastWeek"]];
            lastWeekLabel.text = lastWeekString;
            
            [self.view addSubview:lastWeekLabel];
            
            [lastWeekLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:lastWeekBox withOffset:-8];
            [lastWeekLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:lastWeekBox withOffset:0];
            
#pragma mark - Create Current Month Label Value
            
            
#pragma mark - This Month Label
            UILabel *thisMonthLabel = [[UILabel alloc] init];
            [thisMonthLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            thisMonthLabel.backgroundColor = [UIColor clearColor];
            if([object[@"thisMonth"]  isEqual: @0]){
                thisMonthLabel.textColor = [UIColor redColor];
            }else{
                thisMonthLabel.textColor = [UIColor treeColor];
            }
            thisMonthLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:16.588];
            NSString *thisMonthString = [NSString stringWithFormat:@"%@ Hours", object[@"thisMonth"]];
            thisMonthLabel.text = thisMonthString;
            
            [self.view addSubview:thisMonthLabel];
            
            [thisMonthLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:thisMonthBox withOffset:-8];
            [thisMonthLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:thisMonthBox withOffset:0];
            
#pragma mark - This Week Label
            UILabel *thisWeekLabel = [[UILabel alloc] init];
            [thisWeekLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            thisWeekLabel.backgroundColor = [UIColor clearColor];
            if([object[@"thisWeek"]  isEqual: @0]){
                thisWeekLabel.textColor = [UIColor redColor];
            }else{
                thisWeekLabel.textColor = [UIColor treeColor];
            }
            thisWeekLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:16.588];
            NSString *thisWeekString = [NSString stringWithFormat:@"%@ Hours", object[@"thisWeek"]];
            thisWeekLabel.text = thisWeekString;
            
            [self.view addSubview:thisWeekLabel];
            
            [thisWeekLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:thisWeekBox withOffset:-8];
            [thisWeekLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:thisWeekBox withOffset:0];
            
#pragma mark - Give Button
            
            NSArray *IconArray = [NSArray arrayWithObjects: [UIImage imageNamed:@"up"],[UIImage imageNamed:@"down"],[UIImage imageNamed:@"post"],[UIImage imageNamed:@"paperPlane"],nil];
            NSArray *TextArray = [NSArray arrayWithObjects: [NSString stringWithFormat:@"Give"],[NSString stringWithFormat:@"Request"],[NSString stringWithFormat:@"Log"],[NSString stringWithFormat:@"Export"], nil];
            NSArray *TargetArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"ButtonOne"],[NSString stringWithFormat:@"ButtonTwo"],[NSString stringWithFormat:@"ButtonThree"], [NSString stringWithFormat:@"ButtonFour"],nil];
            
            NewBTN = [[JZMultiChoicesCircleButton alloc] initWithCenterPoint:CGPointMake(self.view.frame.size.width / 2 , self.view.frame.size.height / 2 +50 )
                                                                  ButtonIcon:[UIImage imageNamed:@"plusCirc"]
                                                                 SmallRadius:30.0f
                                                                   BigRadius:120.0f
                                                                ButtonNumber:3
                                                                  ButtonIcon:IconArray
                                                                  ButtonText:TextArray
                                                                ButtonTarget:TargetArray
                                                                 UseParallex:YES
                                                           ParallaxParameter:100
                                                       RespondViewController:self];
            [self.view addSubview:NewBTN];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
        [self initFakeData];
    if (![PFUser currentUser]) {
        LoginViewController *login = [[LoginViewController alloc] init];
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:login];
        [self.navigationController presentViewController:loginNav animated:YES completion:NULL];
    }
}

- (void)ButtonOne
{
    GiveViewController *gvc = [[GiveViewController alloc] init];
    UINavigationController *navGvc = [[UINavigationController alloc] initWithRootViewController:gvc];
    [self presentViewController:navGvc animated:YES completion:^{
            [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(SuccessLoadData) userInfo:nil repeats:NO];
    }];
}
- (void)ButtonTwo
{
    RequestViewController *gvc = [[RequestViewController alloc] init];
    UINavigationController *navGvc = [[UINavigationController alloc] initWithRootViewController:gvc];
    [self presentViewController:navGvc animated:YES completion:^{
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(SuccessLoadData) userInfo:nil repeats:NO];
    }];
}

- (void)ButtonThree
{
    LogViewController *gvc = [[LogViewController alloc] init];
    UINavigationController *navGvc = [[UINavigationController alloc] initWithRootViewController:gvc];
    [self presentViewController:navGvc animated:YES completion:^{
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(SuccessLoadData) userInfo:nil repeats:NO];
    }];
}

- (void)ButtonFour
{
    LogViewController *gvc = [[LogViewController alloc] init];
    UINavigationController *navGvc = [[UINavigationController alloc] initWithRootViewController:gvc];
    [self presentViewController:navGvc animated:YES completion:^{
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(SuccessLoadData) userInfo:nil repeats:NO];
    }];
}

- (void)SuccessLoadData
{
    [NewBTN SuccessCallBackWithMessage:@""];
}



- (void)setupGraph {
    [self setUpUI];
    self.view.backgroundColor = kJBColorBarChartControllerBackground;
    
    self.barChartView = [[JBBarChartView alloc] init];
    self.barChartView.frame = CGRectMake(kJBBarChartViewControllerChartPadding, kJBBarChartViewControllerChartPadding, self.view.bounds.size.width - (kJBBarChartViewControllerChartPadding * 2), kJBBarChartViewControllerChartHeight);
    self.barChartView.delegate = self;
    self.barChartView.dataSource = self;
    self.barChartView.headerPadding = kJBBarChartViewControllerChartHeaderPadding;
    self.barChartView.minimumValue = 0.0f;
    self.barChartView.inverted = NO;
    self.barChartView.backgroundColor = kJBColorBarChartBackground;
    
    JBChartHeaderView *headerView = [[JBChartHeaderView alloc] initWithFrame:CGRectMake(kJBBarChartViewControllerChartPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(kJBBarChartViewControllerChartHeaderHeight * 0.5), self.view.bounds.size.width - (kJBBarChartViewControllerChartPadding * 2), kJBBarChartViewControllerChartHeaderHeight)];
    headerView.titleLabel.text = [@"Monthly Hours" uppercaseString];
    headerView.subtitleLabel.text = @"2016";
    headerView.separatorColor = kJBColorBarChartHeaderSeparatorColor;
    self.barChartView.headerView = headerView;
    
    JBBarChartFooterView *footerView = [[JBBarChartFooterView alloc] initWithFrame:CGRectMake(kJBBarChartViewControllerChartPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(kJBBarChartViewControllerChartFooterHeight * 0.5), self.view.bounds.size.width - (kJBBarChartViewControllerChartPadding * 2), kJBBarChartViewControllerChartFooterHeight)];
    footerView.padding = kJBBarChartViewControllerChartFooterPadding;
    footerView.leftLabel.text = [[self.monthlySymbols firstObject] uppercaseString];
    footerView.leftLabel.textColor = [UIColor whiteColor];
    footerView.rightLabel.text = [[self.monthlySymbols lastObject] uppercaseString];
    footerView.rightLabel.textColor = [UIColor whiteColor];
    self.barChartView.footerView = footerView;
    
    self.informationView = [[JBChartInformationView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, CGRectGetMaxY(_barChartView.frame), self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(_barChartView.frame) - CGRectGetMaxY(self.navigationController.navigationBar.frame))];
    [self.informationView setValueAndUnitTextColor:[UIColor treeColor]];
    [self.informationView setTitleTextColor:[UIColor treeColor]];
    [self.informationView setTextShadowColor:nil];
    [self.informationView setBackgroundColor:[UIColor whiteColor]];
    [self.informationView setSeparatorColor:[UIColor colorWithRed:0.741 green:0.745 blue:0.745 alpha:1.000]];
    [self.view addSubview:self.informationView];
    
    [self.view addSubview:self.barChartView];
    [self.barChartView reloadData];
}

#pragma mark - JBChartViewDataSource
- (BOOL)shouldExtendSelectionViewIntoHeaderPaddingForChartView:(JBChartView *)chartView
{
    return YES;
}

- (BOOL)shouldExtendSelectionViewIntoFooterPaddingForChartView:(JBChartView *)chartView
{
    return NO;
}


#pragma mark - JBBarChartViewDataSource

- (NSUInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView
{
    return [self.chartData count];
}

- (void)barChartView:(JBBarChartView *)barChartView didSelectBarAtIndex:(NSUInteger)index touchPoint:(CGPoint)touchPoint
{
    NSNumber *valueNumber = [self.chartData objectAtIndex:index];
    [self.informationView setValueText:[NSString stringWithFormat:@"%@", valueNumber] unitText:@" Hrs"];
    [self.informationView setTitleText:@"Volunteer Hours Per Month"];
    [self.view bringSubviewToFront:self.informationView];
    [self.informationView setHidden:NO animated:YES];
    [self.informationView setBackgroundColor:[UIColor whiteColor]];
    [self setTooltipVisible:YES animated:YES atTouchPoint:touchPoint];
    [self.view bringSubviewToFront:self.tooltipView];
    [self.tooltipView setText:[[self.monthlySymbols objectAtIndex:index] uppercaseString]];
}

- (void)didDeselectBarChartView:(JBBarChartView *)barChartView
{
    [self.view sendSubviewToBack:self.informationView];
    [self.informationView setHidden:YES animated:YES];
    [self.view sendSubviewToBack:self.tooltipView];
    [self setTooltipVisible:NO animated:YES];
}

#pragma mark - JBBarChartViewDelegate

- (CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtIndex:(NSUInteger)index
{
    return [[self.chartData objectAtIndex:index] floatValue];
}

- (UIColor *)barChartView:(JBBarChartView *)barChartView colorForBarViewAtIndex:(NSUInteger)index
{
    return (index % 2 == 0) ? kJBColorBarChartBarBlue : kJBColorBarChartBarGreen;
}

- (UIColor *)barSelectionColorForBarChartView:(JBBarChartView *)barChartView
{
    return [UIColor whiteColor];
}

- (CGFloat)barPaddingForBarChartView:(JBBarChartView *)barChartView
{
    return kJBBarChartViewControllerBarPadding;
}

#pragma mark - Misc
- (void)setUpUI{
    [self initFakeData];
    self.navigationItem.title = @"Hours";
    
    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [postButton setTitle:@"" forState:UIControlStateNormal];
    [postButton setBackgroundImage:[UIImage imageNamed:@"sidebarIcon"] forState:UIControlStateNormal];
    [postButton addTarget:self action:@selector(didTapBarButton:) forControlEvents:UIControlEventTouchUpInside];
    postButton.frame = CGRectMake(0.0f, 0.0f, 15.0f, 15.0f);
    UIBarButtonItem *postButtonItem = [[UIBarButtonItem alloc] initWithCustomView:postButton];
    self.navigationItem.rightBarButtonItem = postButtonItem;
    
    UIButton *refresh = [UIButton buttonWithType:UIButtonTypeCustom];
    [refresh setTitle:@"" forState:UIControlStateNormal];
    [refresh setBackgroundImage:[UIImage imageNamed:@"bell"] forState:UIControlStateNormal];
    [refresh addTarget:self action:@selector(didTapGivenButton:) forControlEvents:UIControlEventTouchUpInside];
    refresh.frame = CGRectMake(0.0f, 0.0f, 20.0f, 20.0f);
    UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithCustomView:refresh];
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    refreshItem.badgeValue = [NSString stringWithFormat:@"%ld",(long)currentInstallation.badge];
    self.navigationItem.leftBarButtonItem = refreshItem;
}

#pragma mark - Date

- (void)initFakeData {
    NSMutableArray *mutableChartData = [NSMutableArray array];
    if([PFUser currentUser]){
        PFQuery *query = [PFQuery queryWithClassName:@"Hours"];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            for (PFObject *object in objects) {
                [mutableChartData addObject:object[@"Jan"]];
                [mutableChartData addObject:object[@"Feb"]];
                [mutableChartData addObject:object[@"Mar"]];
                [mutableChartData addObject:object[@"Apr"]];
                [mutableChartData addObject:object[@"May"]];
                [mutableChartData addObject:object[@"Jun"]];
                [mutableChartData addObject:object[@"Jul"]];
                [mutableChartData addObject:object[@"Aug"]];
                [mutableChartData addObject:object[@"Sep"]];
                [mutableChartData addObject:object[@"Oct"]];
                [mutableChartData addObject:object[@"Nov"]];
                [mutableChartData addObject:object[@"Dec"]];
            }
            _chartData = [NSArray arrayWithArray:mutableChartData];
            [self.barChartView reloadData];
        }];
    }
}

- (void)dealloc
{
    _barChartView.delegate = nil;
    _barChartView.dataSource = nil;
}

- (void)didTapGivenButton:(id)sender {
    GivenRequestsViewController *grvc = [[GivenRequestsViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:grvc];
    grvc.data = [PFUser currentUser];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didTapBarButton:(id)sender
{
    [self.sidePanelController showRightPanelAnimated:YES];
}

- (JBChartView *)chartView
{
    return self.barChartView;
}

@end
