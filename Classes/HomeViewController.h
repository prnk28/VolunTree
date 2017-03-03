//
//  ViewController.h
//  HelpOut
//
//  Created by Pradyumn Nukala on 8/28/15.
//  Copyright (c) 2015 HelpOut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UITableViewController.h>
#import <MapKit/MapKit.h>

@interface HomeViewController : UITableViewController <NSURLConnectionDelegate> {
     NSMutableData *_responseData;
}

@property (strong, nonatomic) UILabel *titleString;
@property (strong) NSArray *objects;
@property (strong) NSArray *friendsList;
- (void)fetchData;

@end

