//
//  SFParser.m
//  Example
//
//  Created by Sergio Fernández Durán on 10/6/15.
//  Copyright © 2015 Sergio Fernández. All rights reserved.
//

#import "SFParser.h"

#import "SFResource.h"

@implementation SFParser

+ (SFResource *)parseResourceFromDictionary:(NSDictionary *)dictionary
{
    SFResource *resource = [[SFResource alloc] init];
    resource.title = dictionary[@"title"];
    resource.backgroundImage = [UIImage imageNamed:dictionary[@"background"]];

    return resource;
}

@end
