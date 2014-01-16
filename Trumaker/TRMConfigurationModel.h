//
//  TRMConfiguration.h
//  Trumaker
//
//  Created by Kyle Carriedo on 1/15/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRMConfigurationModel : NSObject
@property (assign,nonatomic) int id;
@property (strong,nonatomic) NSNumber *custom_type_id;
@property (strong,nonatomic) NSNumber *position;

@property (strong,nonatomic) NSString *blurb;
@property (strong,nonatomic) NSString *custom_type_name;
@property (strong,nonatomic) NSString *icon_url;
@property (strong,nonatomic) NSString *identifing_name;
@property (strong,nonatomic) NSString *image_url;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *outfit_url;
@property (strong,nonatomic) NSString *description;
@property (strong,nonatomic) NSArray *hero_urls;
@end