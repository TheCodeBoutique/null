//
//  TRMEnviorment.h
//  Trumaker
//
//  Created on 9/13/13.
//  Copyright (c) 2013 The Code Boutique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRMEnviorment : NSObject
-(NSString *)urlForLogin;
-(NSString *)urlForProducts;
-(NSString *)urlForConfigurations;
-(NSString *)urlForNewCustomers;
-(NSString *)urlForUpdatingCustomer;
-(NSString *)urlForUpdatingOrder;
-(NSString *)urlForPaymentMethod;
-(NSString *)urlForBatchDelete;

-(NSString *)baseURL;
-(BOOL)isProduction;
-(BOOL)isStaging;
+ (TRMEnviorment *)sharedInstance;


//application helpers
+ (NSString *) appVersion;
+ (NSString *) build;
+ (NSString *) versionBuild;
@end
