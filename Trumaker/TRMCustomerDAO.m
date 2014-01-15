//
//  TRMCustomerDAO.m
//  Trumaker
//
//  Created by Marin Fischer on 1/7/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMCustomerDAO.h"
#import "AFHTTPRequestOperationManager.h"
#import "NSDictionary+dictionaryWithObject.h"

#import "TRMAuthHolder.h"
#import "TRMEnviorment.h"

@implementation TRMCustomerDAO

-(void)fetchCustomersForOutfitter
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [[manager requestSerializer] setValue:[[TRMAuthHolder sharedInstance] authString] forHTTPHeaderField:@"HTTP_AUTHORIZATION"];
    NSString *url = [NSString stringWithFormat:@"%@",[[TRMEnviorment sharedInstance] urlForNewCustomers]];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

-(void)createNewCustomer:(TRMCustomerModel *)customer completionHandler:(void (^)(TRMCustomerModel *newCustomer, NSError *))handler {
    NSString *addCustomerUrl = [[TRMEnviorment sharedInstance] urlForNewCustomers];
    
    NSMutableDictionary *customerDictionary = [[NSMutableDictionary alloc] init];
    [customerDictionary setValue:[customer first_name] forKey:@"first_name"];
    [customerDictionary setValue:[customer last_name] forKey:@"last_name"];
    [customerDictionary setValue:[customer email] forKey:@"email"];
    [customerDictionary setValue:[customer default_monogram] forKey:@"@default_monogram"];
    
    NSDictionary *addressDictionary = [NSDictionary dictionaryWithPropertiesOfObject:[[customer addresses] objectAtIndex:0]];
    NSDictionary *phonesDictionary = [NSDictionary dictionaryWithPropertiesOfObject:[[customer phones] objectAtIndex:0]];
    
    [customerDictionary setObject:[[NSMutableArray alloc] initWithArray:@[addressDictionary]] forKey:@"addresses"];
    [customerDictionary setObject:[[NSMutableArray alloc] initWithArray:@[phonesDictionary]] forKey:@"phones"];
    
    NSMutableDictionary *userDictionary = [[NSMutableDictionary alloc] init];
    [userDictionary setObject:customerDictionary forKey:@"user"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [[manager requestSerializer] setValue:[[TRMAuthHolder sharedInstance] authString] forHTTPHeaderField:@"HTTP_AUTHORIZATION"];
    [manager POST:addCustomerUrl parameters:userDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
    
}
@end
