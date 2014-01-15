//
//  TRMAddressModel.h
//  Trumaker
//
//  Created by Kyle Carriedo on 1/14/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRMAddressModel : NSObject

@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address1;
@property (strong, nonatomic) NSString *address2;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state_abbr_name;
@property (strong, nonatomic) NSString *zip_code;
@property (assign, nonatomic) BOOL billing_default;
@property (assign, nonatomic) BOOL shipping_default;

@property (assign, nonatomic) BOOL business;
@property (assign, nonatomic) BOOL active;
@end
