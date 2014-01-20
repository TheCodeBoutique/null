//
//  TRMCustomerModel.m
//  Trumaker
//
//  Created by Kyle Carriedo on 1/12/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMCustomerModel.h"
#import "TRMOrderModel.h"
@implementation TRMCustomerModel

-(BOOL)isExisitingCustomer {
    return ([self id]) ? YES : NO;
}

-(NSString *)fullName {
    return  [NSString stringWithFormat:@"%@ %@",[self first_name], [self last_name]];
}

-(NSNumber *)idForOrder {
    TRMAddressModel *order = [[self in_progress_orders] objectAtIndex:0];
    return [NSNumber numberWithInt:[order id]];
}

-(TRMAddressModel *)primaryAddress {
    NSMutableArray *allAddresses = [self addresses];
   __block TRMAddressModel *mainAddress;
    [allAddresses enumerateObjectsUsingBlock:^(TRMAddressModel *address, NSUInteger idx, BOOL *stop) {
        if ([address active]) {
            mainAddress = address;
            *stop = YES;
        }
    }];
    return mainAddress;
}

-(TRMAddressModel *)primaryShippingAddress {
    NSMutableArray *allAddresses = [self addresses];
    __block TRMAddressModel *mainAddress;
    [allAddresses enumerateObjectsUsingBlock:^(TRMAddressModel *address, NSUInteger idx, BOOL *stop) {
        if ([address active]) {
            if ([address shipping_default]) {
                mainAddress = address;
            }
            *stop = YES;
        }
    }];
    return mainAddress;
}

-(TRMAddressModel *)primaryBillingAddress {
    NSMutableArray *allAddresses = [self addresses];
    __block TRMAddressModel *mainAddress;
    [allAddresses enumerateObjectsUsingBlock:^(TRMAddressModel *address, NSUInteger idx, BOOL *stop) {
        if ([address active]) {
            if ([address billing_default]) {
                mainAddress = address;
            }
            *stop = YES;
        }
    }];
    return mainAddress;
}

-(TRMPhoneModel *)primaryPhone {
    NSMutableArray *allPhones = [self phones];
    __block TRMPhoneModel *mainPhone;
    [allPhones enumerateObjectsUsingBlock:^(TRMPhoneModel *phone, NSUInteger idx, BOOL *stop) {
        //lets first lookup mobile
        if ([[phone phone_type] isEqualToString:@"Cell"]) {
            mainPhone = phone;
            *stop = YES;
        } else if (([[phone phone_type] isEqualToString:@"Home"])) {
            mainPhone = phone;
            *stop = YES;
        } else if (([[phone phone_type] isEqualToString:@"Work"])) {
            mainPhone = phone;
            *stop = YES;
        } else if (([[phone phone_type] isEqualToString:@"Other"])) {
            mainPhone = phone;
            *stop = YES;
        }
    }];    
    return mainPhone;
}
@end
