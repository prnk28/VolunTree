//
//  NSArray+StaticArray.m
//  VolunTree
//
//  Created by Pradyumn Nukala on 6/18/16.
//  Copyright © 2016 HelpOut. All rights reserved.
//

#import "NSArray+StaticArray.h"

@implementation NSArray (StaticArray)
+(NSMutableArray *)searchInstance{
    static dispatch_once_t pred;
    static NSMutableArray *sharedArray = nil;
    dispatch_once(&pred, ^{ sharedArray = [[NSMutableArray alloc] init]; });
    return sharedArray;
}
@end
