//
//  TRMOrderModel.h
//  Trumaker
//  Created by Kyle Carriedo on 1/18/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRMOrderModel : NSObject
@property (assign, nonatomic) NSInteger id;
@property (strong, nonatomic) NSString *number;
@property (strong, nonatomic) NSString *state; //order progress
@property (strong, nonatomic) NSString *bill_address_id;
@property (strong, nonatomic) NSString *ship_address_id;
@property (strong, nonatomic) NSNumber *shipping_charges;
@property (assign, nonatomic) CGFloat deal_amount;
@property (assign, nonatomic) CGFloat coupon_amount;
@property (assign, nonatomic) CGFloat sub_total;
@property (assign, nonatomic) CGFloat taxed_total;
@property (assign, nonatomic) CGFloat credited_total;
@property (assign, nonatomic) CGFloat tax;
@property (assign, nonatomic) CGFloat discount;
@property (strong, nonatomic) NSString *coupon_code;
@property (strong, nonatomic) NSString *payment_type;
@property (strong, nonatomic) NSString *charged_now; //amount that is getting charged (50% deposit)
@property (assign, nonatomic) CGFloat credit_applied;
@property (assign, nonatomic) CGFloat store_credit_amount;
@property (strong, nonatomic) NSString *calculated_at;
@property (strong, nonatomic) NSString *completed_at;
@property (assign, nonatomic) BOOL active;
@property (strong, nonatomic) NSString *payment_method_id;

//checklist
@property (assign, nonatomic) BOOL billing_information_finished;
@property (assign, nonatomic) BOOL customer_information_finished;
@property (assign, nonatomic) BOOL configurations_finished;
@property (assign, nonatomic) BOOL credit_card_information_finished;
@property (assign, nonatomic) BOOL measurements_finished;
@property (assign, nonatomic) BOOL product_selection_finished;
@property (assign, nonatomic) BOOL questions_finished;
@property (assign, nonatomic) BOOL shipping_information_finished;

//array of checkout items
@property (strong, nonatomic) NSMutableArray *order_items;
@end
