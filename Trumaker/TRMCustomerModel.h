//
//  TRMCustomerModel.h
//  Trumaker
//
//  Created by Kyle Carriedo on 1/12/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRMAddressModel.h"
#import "TRMPhoneModel.h"
@interface TRMCustomerModel : NSObject
@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *first_name;
@property (strong, nonatomic) NSString *last_name;
@property (strong, nonatomic) NSString *default_monogram; //tcb example
@property (strong, nonatomic) NSNumber *finished_orders_count; //number of finished orders
@property (strong, nonatomic) NSNumber *confirmed_fit;
@property (strong, nonatomic) NSNumber *store_credit;


@property (strong, nonatomic) NSMutableArray *addresses; //TRMAddress
@property (strong, nonatomic) NSMutableArray *phones; //TRMPhone

@property (strong, nonatomic) NSMutableArray *in_progress_orders;

-(NSString *)fullName;
-(NSNumber *)idForOrder;
-(BOOL)isExisitingCustomer;

-(TRMAddressModel *)primaryAddress;
-(TRMPhoneModel *)primaryPhone;
@end
