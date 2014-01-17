//
//  TRMBuildPreferenceItem.h
//  Trumaker
//
//  Created by Marin Fischer on 1/16/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRMBuildPreferenceItem : NSObject
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSMutableArray *image_url;
@property (strong,nonatomic) NSMutableArray *configurations;
@property (assign,nonatomic) int custom_type_id;
@property (strong,nonatomic) NSString *blurb;
@property (strong,nonatomic) NSString *description;






@end
