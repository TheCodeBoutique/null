//
//  TRMLoginDAO.m
//  Trumaker
//
//  Created by Marin Fischer on 1/6/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMLoginDAO.h"
#import "TRMCustomerDAO.h"
#import "AFHTTPRequestOperationManager.h"
#import "TRMEnviorment.h"
#import "TRMAuthHolder.h"

@implementation TRMLoginDAO
//send username and password to server for validation
- (void)login:(NSString *)username withPassword:(NSString *)password completionHandler:(void(^)(BOOL successful, NSError *))handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [[manager requestSerializer] setValue:username forHTTPHeaderField:@"X_EMAIL"];
    [[manager requestSerializer] setValue:password forHTTPHeaderField:@"X_PASSWORD"];
    [[manager requestSerializer] setValue:[TRMEnviorment appVersion] forHTTPHeaderField:@"HTTP_X_VERSION"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",[[TRMEnviorment sharedInstance] baseURL],[[TRMEnviorment sharedInstance] urlForLogin]];

    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *outFitterDict = [responseObject valueForKey:@"me"];
        [[TRMAuthHolder sharedInstance] setAuthString:[outFitterDict valueForKey:@"authentication_token"]];
        [[[TRMCustomerDAO alloc] init] fetchCustomersForOutfitter];
        handler(YES, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        handler(NO, error);
    }];
}

@end
