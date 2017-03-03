//
//  ArrayManager.h
//  VolunTree
//
//  Created by Pradyumn Nukala on 6/16/16.
//  Copyright © 2016 HelpOut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArrayManager : NSObject {
    NSMutableArray *searchResults;
}

@property (nonatomic, retain) NSMutableArray *searchResults;

+(ArrayManager *)sharedInstance;
-(NSMutableArray *) getGlobalArray;
-(void) setGlobalArray:(NSMutableArray *)array;

@end
