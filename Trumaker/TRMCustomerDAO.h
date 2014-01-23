//
//  TRMCustomerDAO.h
//  Trumaker
//
//  Created by Marin Fischer on 1/7/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRMCustomerModel.h"

@interface TRMCustomerDAO : NSObject
-(void)fetchCustomersForOutfitter;
-(void)createNewCustomer:(TRMCustomerModel *)customer completionHandler:(void (^)(TRMCustomerModel *newCustomer, NSError *))handler;
-(void)updateCustomerInformation:(TRMCustomerModel *)customer withPhoneNumber:(TRMPhoneModel *)phone completionHandler:(void (^)(TRMCustomerModel *newCustomer, NSError *))handler;


+(void)createAddress:(TRMAddressModel *)address forCustomer:(TRMCustomerModel *)customer completionHandler:(void (^)(TRMCustomerModel *newCustomer, NSError *))handler;

+(void)updateAddress:(TRMAddressModel *)address forCustomer:(TRMCustomerModel *)customer completionHandler:(void (^)(TRMCustomerModel *newCustomer, NSError *))handler;

+(void)updateAddresses:(NSMutableArray *)addresses forCustomer:(TRMCustomerModel *)customer completionHandler:(void (^)(TRMCustomerModel *newCustomer, NSError *))handler;

+(void)updateDefaultBuildPreference:(NSMutableArray *)buildPreferences forCustomer:(TRMCustomerModel *)customer completionHandler:(void (^)(TRMCustomerModel *newCustomer, NSError *))handler;
@end
