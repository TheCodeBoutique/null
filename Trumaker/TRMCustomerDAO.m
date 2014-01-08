//
//  TRMCustomerDAO.m
//  Trumaker
//
//  Created by Marin Fischer on 1/7/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMCustomerDAO.h"
#import "AFHTTPRequestOperationManager.h"
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
@end
