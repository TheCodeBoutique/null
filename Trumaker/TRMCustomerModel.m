//
//  TRMCustomerModel.m
//  Trumaker
//
//  Created by Kyle Carriedo on 1/12/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMCustomerModel.h"
#import "TRMOrderModel.h"
#import "TRMAddressModel.h"
#import "TRMCoreApi.h"
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
            if ([address shipping_default]) {
                mainAddress = address;
            *stop = YES;
        }
    }];
    return mainAddress;
}

-(TRMAddressModel *)primaryBillingAddress {
    NSMutableArray *allAddresses = [self addresses];
    __block TRMAddressModel *mainAddress;
    [allAddresses enumerateObjectsUsingBlock:^(TRMAddressModel *address, NSUInteger idx, BOOL *stop) {
        if ([address billing_default]) {
                mainAddress = address;
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

-(NSMutableArray *)primaryAndBillingAddresses {
    NSMutableArray *addresses = [[NSMutableArray alloc] init];
    [[self addresses] enumerateObjectsUsingBlock:^(TRMAddressModel *address, NSUInteger idx, BOOL *stop) {
        if ([address shipping_default]) {
            [addresses addObject:address];
        }
        if ([address billing_default]) {
            [addresses addObject:address];
        }
    }];
    NSLog(@"Total primaryAndBillingAddresses count %d",[addresses count]);
    return addresses;
}

-(NSMutableArray *)configurationsFromIds {
    NSMutableArray *configurations = [[NSMutableArray alloc] init];
    [[self default_customization_ids] enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        int ids = [obj intValue];
        
//        NSPredicate *standardPredicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"id = '%@'",[NSNumber numberWithInt:ids]]];
//        NSArray *standard = [[[TRMCoreApi sharedInstance] configurations] filteredArrayUsingPredicate:standardPredicate];
//        if ([standard count]) {
//            TRMConfigurationModel *model = [standard objectAtIndex:0];
//            [configurations addObject:model];
//        }
        
        [[[TRMCoreApi sharedInstance] configurations] enumerateObjectsUsingBlock:^(TRMConfigurationModel *configModel, NSUInteger idx, BOOL *stop) {
            int configModelId = [[configModel id] intValue];
            if (configModelId == ids) {
                [configurations addObject:configModel];
            }
        }];
    }];
    
    
    return configurations;
}
@end
