//
//  TRMOutfitterModel.h
//  Trumaker
//
//  Created by Kyle Carriedo on 1/12/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface TRMOutfitterModel : NSObject
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *first_name;
@property (nonatomic, strong) NSString *last_name;
@property (nonatomic, strong) NSString *picture; //picture url
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) UIImage *outfitterImage;

-(NSString *)fullName;
@end
