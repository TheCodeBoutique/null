//
//  TRMCoreApi.m
//  Trumaker
//
//  Created by Kyle Carriedo on 1/12/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMCoreApi.h"

@implementation TRMCoreApi

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(BOOL)isFirstTimeCustomer {
    return ([[self customer] finished_orders_count] == 0) ? YES : NO;
}

-(BOOL)hasCustomerModel {
    return ([self customer]) ? YES : NO;
}


-(BOOL)existingCustomersLoaded {
    return ([[self outfitterCustomers] count] > 0 || [[self localContacts] count] > 0) ? YES : NO;
}

+ (TRMCoreApi *)sharedInstance
{
    static TRMCoreApi *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TRMCoreApi alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}
@end
