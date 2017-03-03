//
//  SearchViewController.h
//  
//
//  Created by Pradyumn Nukala on 8/28/15.
//
//

#import <UIKit/UIKit.h>


@interface SearchViewController : UIViewController <UISearchBarDelegate>

@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *organizationsResults;
@property (nonatomic, strong) NSArray *userResults;

@end
