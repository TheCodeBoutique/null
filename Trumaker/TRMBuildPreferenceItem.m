//
//  TRMBuildPreferenceItem.m
//  Trumaker
//
//  Created by Marin Fischer on 1/16/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMBuildPreferenceItem.h"

@implementation TRMBuildPreferenceItem

- (id)init
{
    self = [super init];
    if (self) {
        self.image_url = [[NSMutableArray alloc] init];
        self.configurations = [[NSMutableArray alloc] init];
        self.name = @"trumaker";
    }
    return self;
}


@end
