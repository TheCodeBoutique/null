//
//  TRMEnviorment.m
//  Trumaker
//
//  Created on 9/13/13.
//  Copyright (c) 2013 The Code Boutique. All rights reserved.
//

#import "TRMEnviorment.h"

@implementation TRMEnviorment
- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

+ (TRMEnviorment *)sharedInstance
{
    static TRMEnviorment *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TRMEnviorment alloc] init];
    });
    return sharedInstance;
}


+ (NSString *) appVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
}

+ (NSString *) build
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
}

+ (NSString *) versionBuild
{
    NSString * version = [self appVersion];
    NSString * build = [self build];
    
    NSString * versionBuild = [NSString stringWithFormat: @"v%@", version];
    
    if (![version isEqualToString: build]) {
        versionBuild = [NSString stringWithFormat: @"%@(%@)", versionBuild, build];
    }
    
    return versionBuild;
}


-(NSString *)urlForPaymentMethod
{
    return [NSString stringWithFormat:@"%@/%@",[self currentServer],@"api/payment_methods_ios/"];
}

-(NSString *)baseURL
{
    return [NSString stringWithFormat:@"%@",[self currentServer]];
}

-(NSString *)urlForUpdatingOrder
{
    return [NSString stringWithFormat:@"%@/%@",[self currentServer],@"api/orders_ios/"];
}
-(NSString *)urlForOutfitterImageUpload
{
    return [NSString stringWithFormat:@"%@/%@",[self currentServer],@"api/me/profile_picture"];
}

-(NSString *)urlForBatchDelete
{
    return [NSString stringWithFormat:@"%@/%@",[self currentServer],@"api/order_items_ios/destroy_batch"];
}

-(NSString *)urlForNewCustomers
{
    return [NSString stringWithFormat:@"%@/%@",[self currentServer],@"api/users_ios/"];
}

-(NSString *)urlForUpdatingCustomer
{
    return [NSString stringWithFormat:@"%@/%@",[self currentServer],@"api/users_ios/"];
}

-(NSString *)urlForLogin
{
    return @"/api/me";
}

-(NSString *)urlForProducts
{
    return [NSString stringWithFormat:@"%@/%@",[self currentServer],@"api/products.json"];
}
-(NSString *)urlForConfigurations
{
   return [NSString stringWithFormat:@"%@/%@",[self currentServer],@"api/customizations.json"]; 
}


-(BOOL)isProduction
{
    BOOL prod = [[NSUserDefaults standardUserDefaults] boolForKey:@"production_enviorment"];
    return (prod) ? YES : NO;
}
-(BOOL)isStaging
{
    BOOL staging = [[NSUserDefaults standardUserDefaults] boolForKey:@"staging_enviorment"];
    return (staging) ? YES : NO;
}

-(NSString *)currentServer
{
    BOOL staging = [[NSUserDefaults standardUserDefaults] boolForKey:@"staging_enviorment"];
    BOOL prod = [[NSUserDefaults standardUserDefaults] boolForKey:@"production_enviorment"];
    BOOL dev = [[NSUserDefaults standardUserDefaults] boolForKey:@"dev_enviorment"];    
    
    if (staging)
    {
        return @"https://client.trumaker.net";
    }
    else if (prod)
    {
        return @"https://client.trumaker.com";
    }
    else if (dev)
    {
        return @"https://client.trumaker.info";
    }
    
    return @"https://client.trumaker.com";
}
@end
