//
//  ArrayManager.m
//  VolunTree
//
//  Created by Pradyumn Nukala on 6/16/16.
//  Copyright © 2016 HelpOut. All rights reserved.
//

#import "ArrayManager.h"

@implementation ArrayManager

@synthesize searchResults;

+ (ArrayManager *)sharedInstance {
    static dispatch_once_t once;
    static ArrayManager *arrayManager;
    dispatch_once(&once, ^{
        arrayManager = [[ArrayManager alloc] init];
        arrayManager.searchResults = [[NSMutableArray alloc] init];
    });
    return arrayManager;
}

- (id)init {
    if ( (self = [super init]) ) {
        // your custom initialization
        searchResults = [[NSMutableArray alloc] init];
    }
    return self;
}

-(NSMutableArray *)getGlobalArray{
    return searchResults;
}
-(void)setGlobalArray:(NSMutableArray *)array{
    searchResults = array;
}



@end
