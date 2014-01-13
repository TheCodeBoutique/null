//
//  TRMCustomerModel.h
//  Trumaker
//
//  Created by Kyle Carriedo on 1/12/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRMCustomerModel : NSObject
@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *first_name;
@property (strong, nonatomic) NSString *last_name;
@property (strong, nonatomic) NSString *default_monogram; //tcb example
@property (strong, nonatomic) NSNumber *finished_orders_count; //number of finished orders
@property (assign, nonatomic) CGFloat  store_credit;


//private used for mapping
+(void)mapKey:(NSDictionary *)mapping;
@end
