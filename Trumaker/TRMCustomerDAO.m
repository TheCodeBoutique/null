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
#import "NSObject+JTObjectMapping.h"
#import "TRMCoreApi.h"

#import "TRMAuthHolder.h"
#import "TRMEnviorment.h"
#import "TRMAddressModel.h"
#import "TRMPhoneModel.h"
#import "TRMOrderModel.h"
#import "TRMProductModel.h"

@implementation TRMCustomerDAO

-(void)fetchCustomersForOutfitter
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [[manager requestSerializer] setValue:[[TRMAuthHolder sharedInstance] authString] forHTTPHeaderField:@"HTTP_AUTHORIZATION"];
    NSString *url = [NSString stringWithFormat:@"%@",[[TRMEnviorment sharedInstance] urlForNewCustomers]];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSMutableArray *jsonArray = [responseObject objectForKey:@"array"];
        NSMutableArray *customers = [[NSMutableArray alloc] init];
        
        [jsonArray enumerateObjectsUsingBlock:^(NSDictionary *customerDictionary, NSUInteger idx, BOOL *stop) {
            //parse customer
            TRMCustomerModel *customer = [TRMCustomerModel objectFromJSONObject:customerDictionary mapping:nil];
            
            //array of addresses
            NSMutableArray *customerAddresses = [[NSMutableArray alloc] init];
            [[customer addresses] enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSDictionary *addressDictionary, NSUInteger idx, BOOL *stop) {
                TRMAddressModel *address = [TRMAddressModel objectFromJSONObject:addressDictionary mapping:nil];
                [customerAddresses addObject:address];
            }];
            
            //array of phone numbers
            NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
            [[customer phones] enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSDictionary *phoneDict, NSUInteger idx, BOOL *stop) {
                TRMPhoneModel *phone = [TRMPhoneModel objectFromJSONObject:phoneDict mapping:nil];
                [phoneNumbers addObject:phone];
            }];
            
            //need to map orders
            NSMutableArray *inProgressOrders = [[NSMutableArray alloc] init];
            [[customer in_progress_orders] enumerateObjectsUsingBlock:^(NSDictionary *orderDictionary, NSUInteger idx, BOOL *stop) {
                TRMOrderModel *order = [TRMOrderModel objectFromJSONObject:orderDictionary mapping:nil];
                
                //will need to process order items if they exsist
                NSMutableArray *orderItems = [[NSMutableArray alloc] init];
                [[order order_items] enumerateObjectsUsingBlock:^(NSDictionary *orderItemDictionary, NSUInteger idx, BOOL *stop) {
                    TRMProductModel *orderItem = [TRMProductModel objectFromJSONObject:orderDictionary mapping:nil];
                    [orderItem setOrder_item_id:[[orderItemDictionary valueForKey:@"id"] intValue]];
                    [orderItem setId:[[orderItemDictionary valueForKey:@"product_id"] intValue]];
                    [orderItems addObject:orderItem];
                    
                }];
                
                [order setOrder_items:orderItems];
                
                [inProgressOrders addObject:order];
            }];
            
            //update in progree orders
            [customer setIn_progress_orders:inProgressOrders];
            
            //update phone numbers for customer
            [customer setPhones:phoneNumbers];
            
            //update addresses for customer
            [customer setAddresses:customerAddresses];

            [customers addObject:customer];
        }];
        
        //add customers to core api
        [[TRMCoreApi sharedInstance] setOutfitterCustomers:customers];
        
        //send push notifcations for customer
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"clientsUpdateNotification"
         object:nil];        
        
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
    [customerDictionary setValue:[customer default_monogram] forKey:@"default_monogram"];
    
    NSDictionary *phonesDictionary = [NSDictionary dictionaryWithPropertiesOfObject:[[customer phones] objectAtIndex:0]];
    NSMutableDictionary *editedPhoneDictionary = [[NSMutableDictionary alloc] initWithDictionary:phonesDictionary];
    [editedPhoneDictionary removeObjectForKey:@"id"];
    
    [customerDictionary setObject:[[NSMutableArray alloc] initWithArray:@[phonesDictionary]] forKey:@"phones"];
    
    NSMutableDictionary *userDictionary = [[NSMutableDictionary alloc] init];
    [userDictionary setObject:customerDictionary forKey:@"user"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [[manager requestSerializer] setValue:[[TRMAuthHolder sharedInstance] authString] forHTTPHeaderField:@"HTTP_AUTHORIZATION"];
    [manager POST:addCustomerUrl parameters:userDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonDict = [responseObject objectForKey:@"user"];
        TRMCustomerModel *customer = [TRMCustomerModel objectFromJSONObject:jsonDict mapping:nil];
        
        //will need to parse the customer TODO
        
        handler(customer, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        handler(nil, error);
    }];
}

-(void)updateCustomerInformation:(TRMCustomerModel *)customer withPhoneNumber:(TRMPhoneModel *)phone completionHandler:(void (^)(TRMCustomerModel *newCustomer, NSError *))handler
{
    NSString *addCustomerUrl = [[TRMEnviorment sharedInstance] urlForNewCustomers];
    addCustomerUrl = [addCustomerUrl stringByAppendingString:[NSString stringWithFormat:@"%@",[customer id]]];
    
    NSMutableDictionary *customerDictionary = [[NSMutableDictionary alloc] init];
    [customerDictionary setValue:[customer first_name] forKey:@"first_name"];
    [customerDictionary setValue:[customer last_name] forKey:@"last_name"];
    [customerDictionary setValue:[customer email] forKey:@"email"];
    [customerDictionary setValue:[customer default_monogram] forKey:@"default_monogram"];
    
    NSDictionary *phonesDictionary = [NSDictionary dictionaryWithPropertiesOfObject:phone];
    NSMutableDictionary *editedPhoneDictionary = [[NSMutableDictionary alloc] initWithDictionary:phonesDictionary];
//    [editedPhoneDictionary removeObjectForKey:@"id"];
    [editedPhoneDictionary removeObjectForKey:@"phone_type"];
    [editedPhoneDictionary setObject:[phone phoneTypeFromString:[phone phone_type]] forKey:@"phone_type_id"];
    
    [customerDictionary setObject:[[NSMutableArray alloc] initWithArray:@[editedPhoneDictionary]] forKey:@"phones"];
    
    NSMutableDictionary *userDictionary = [[NSMutableDictionary alloc] init];
    [userDictionary setObject:customerDictionary forKey:@"user"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [[manager requestSerializer] setValue:[[TRMAuthHolder sharedInstance] authString] forHTTPHeaderField:@"HTTP_AUTHORIZATION"];
    [manager PUT:addCustomerUrl parameters:userDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonDict = [responseObject objectForKey:@"user"];
        TRMCustomerModel *customer = [TRMCustomerModel objectFromJSONObject:jsonDict mapping:nil];
        
        
        //array of addresses
        NSMutableArray *customerAddresses = [[NSMutableArray alloc] init];
        [[customer addresses] enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSDictionary *addressDictionary, NSUInteger idx, BOOL *stop) {
            TRMAddressModel *address = [TRMAddressModel objectFromJSONObject:addressDictionary mapping:nil];
            [customerAddresses addObject:address];
        }];
        
        //array of phone numbers
        NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
        [[customer phones] enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSDictionary *phoneDict, NSUInteger idx, BOOL *stop) {
            TRMPhoneModel *phone = [TRMPhoneModel objectFromJSONObject:phoneDict mapping:nil];
            [phoneNumbers addObject:phone];
        }];
        
        //need to map orders
        NSMutableArray *inProgressOrders = [[NSMutableArray alloc] init];
        [[customer in_progress_orders] enumerateObjectsUsingBlock:^(NSDictionary *orderDictionary, NSUInteger idx, BOOL *stop) {
            TRMOrderModel *order = [TRMOrderModel objectFromJSONObject:orderDictionary mapping:nil];
            
            //will need to process order items if they exsist
            NSMutableArray *orderItems = [[NSMutableArray alloc] init];
            [[order order_items] enumerateObjectsUsingBlock:^(NSDictionary *orderItemDictionary, NSUInteger idx, BOOL *stop) {
                TRMProductModel *orderItem = [TRMProductModel objectFromJSONObject:orderDictionary mapping:nil];
                [orderItem setOrder_item_id:[[orderItemDictionary valueForKey:@"id"] intValue]];
                [orderItem setId:[[orderItemDictionary valueForKey:@"product_id"] intValue]];
                [orderItems addObject:orderItem];
                
            }];
            
            [order setOrder_items:orderItems];
            
            [inProgressOrders addObject:order];
        }];
        
        //update in progree orders
        [customer setIn_progress_orders:inProgressOrders];
        
        //update phone numbers for customer
        [customer setPhones:phoneNumbers];
        
        //update addresses for customer
        [customer setAddresses:customerAddresses];
        
        //add customer to core api
        [[TRMCoreApi sharedInstance] setCustomer:customer];

        
        handler(customer, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        handler(nil, error);
    }];
}

+ (void)updateAddress:(TRMAddressModel *)address forCustomer:(TRMCustomerModel *)customer completionHandler:(void (^)(TRMCustomerModel *newCustomer, NSError *))handler {

    NSString *addCustomerUrl = [[TRMEnviorment sharedInstance] urlForNewCustomers];
    addCustomerUrl = [addCustomerUrl stringByAppendingString:[NSString stringWithFormat:@"%@",[customer id]]];
    
    NSMutableArray *addressArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *individualAddressDictionary = [[NSMutableDictionary alloc] init];
    [individualAddressDictionary setValue:[NSNumber numberWithInt:[address id]] forKey:@"id"];
    [individualAddressDictionary setValue:[address state_abbr_name] forKey:@"state_abbr_name"];
    [individualAddressDictionary setValue:[address name] forKey:@"name"];
    [individualAddressDictionary setValue:[address city] forKey:@"city"];
    [individualAddressDictionary setValue:[NSNumber numberWithBool:[address business]] forKey:@"business"];
    [individualAddressDictionary setValue:[NSNumber numberWithBool:[address shipping_default]] forKey:@"shipping_default"];
    [individualAddressDictionary setValue:[NSNumber numberWithBool:[address billing_default]] forKey:@"billing_default"];

    if ([[address address2] length]) {
        [individualAddressDictionary setValue:[address address2] forKey:@"address2"];
    }
    
    [individualAddressDictionary setValue:[NSNumber numberWithBool:[address active]] forKey:@"active"];
    [individualAddressDictionary setValue:[address zip_code] forKey:@"zip_code"];
    [individualAddressDictionary setValue:[address address1] forKey:@"address1"];
    [addressArray addObject:individualAddressDictionary];
    
    NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
    [addressDictionary setObject:addressArray forKey:@"addresses"];
    
    NSMutableDictionary *userDictionary = [[NSMutableDictionary alloc] init];
    [userDictionary setObject:addressDictionary forKey:@"user"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [[manager requestSerializer] setValue:[[TRMAuthHolder sharedInstance] authString] forHTTPHeaderField:@"HTTP_AUTHORIZATION"];
    [manager PUT:addCustomerUrl parameters:userDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonDict = [responseObject objectForKey:@"user"];
        TRMCustomerModel *customer = [TRMCustomerModel objectFromJSONObject:jsonDict mapping:nil];
        
        
        //array of addresses
        NSMutableArray *customerAddresses = [[NSMutableArray alloc] init];
        [[customer addresses] enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSDictionary *addressDictionary, NSUInteger idx, BOOL *stop) {
            TRMAddressModel *address = [TRMAddressModel objectFromJSONObject:addressDictionary mapping:nil];
            [customerAddresses addObject:address];
        }];
        
        //array of phone numbers
        NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
        [[customer phones] enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSDictionary *phoneDict, NSUInteger idx, BOOL *stop) {
            TRMPhoneModel *phone = [TRMPhoneModel objectFromJSONObject:phoneDict mapping:nil];
            [phoneNumbers addObject:phone];
        }];
        
        //need to map orders
        NSMutableArray *inProgressOrders = [[NSMutableArray alloc] init];
        [[customer in_progress_orders] enumerateObjectsUsingBlock:^(NSDictionary *orderDictionary, NSUInteger idx, BOOL *stop) {
            TRMOrderModel *order = [TRMOrderModel objectFromJSONObject:orderDictionary mapping:nil];
            
            //will need to process order items if they exsist
            NSMutableArray *orderItems = [[NSMutableArray alloc] init];
            [[order order_items] enumerateObjectsUsingBlock:^(NSDictionary *orderItemDictionary, NSUInteger idx, BOOL *stop) {
                TRMProductModel *orderItem = [TRMProductModel objectFromJSONObject:orderDictionary mapping:nil];
                [orderItem setOrder_item_id:[[orderItemDictionary valueForKey:@"id"] intValue]];
                [orderItem setId:[[orderItemDictionary valueForKey:@"product_id"] intValue]];
                [orderItems addObject:orderItem];
                
            }];
            
            [order setOrder_items:orderItems];
            
            [inProgressOrders addObject:order];
        }];
        
        //update in progree orders
        [customer setIn_progress_orders:inProgressOrders];
        
        //update phone numbers for customer
        [customer setPhones:phoneNumbers];
        
        //update addresses for customer
        [customer setAddresses:customerAddresses];
        
        //add customer to core api
        [[TRMCoreApi sharedInstance] setCustomer:customer];
        handler(customer, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        handler(nil, error);
    }];
}

+ (void)updateAddresses:(NSMutableArray *)addresses forCustomer:(TRMCustomerModel *)customer completionHandler:(void (^)(TRMCustomerModel *newCustomer, NSError *))handler {
    
    NSString *addCustomerUrl = [[TRMEnviorment sharedInstance] urlForNewCustomers];
    addCustomerUrl = [addCustomerUrl stringByAppendingString:[NSString stringWithFormat:@"%@",[customer id]]];
    
    NSMutableArray *addressArray = [[NSMutableArray alloc] init];
   //beganing
    for (TRMAddressModel *address in addresses)
    {
        NSMutableDictionary *individualAddressDictionary = [[NSMutableDictionary alloc] init];
        [individualAddressDictionary setValue:[NSNumber numberWithInt:[address id]] forKey:@"id"];
        [individualAddressDictionary setValue:[address state_abbr_name] forKey:@"state_abbr_name"];
        [individualAddressDictionary setValue:[address name] forKey:@"name"];
        [individualAddressDictionary setValue:[address city] forKey:@"city"];
        [individualAddressDictionary setValue:[NSNumber numberWithBool:[address business]] forKey:@"business"];
        [individualAddressDictionary setValue:[NSNumber numberWithBool:[address shipping_default]] forKey:@"shipping_default"];
        [individualAddressDictionary setValue:[NSNumber numberWithBool:[address billing_default]] forKey:@"billing_default"];
        
        if ([[address address2] length]) {
            [individualAddressDictionary setValue:[address address2] forKey:@"address2"];
        }
        
        [individualAddressDictionary setValue:[NSNumber numberWithBool:[address active]] forKey:@"active"];
        [individualAddressDictionary setValue:[address zip_code] forKey:@"zip_code"];
        [individualAddressDictionary setValue:[address address1] forKey:@"address1"];
        [addressArray addObject:individualAddressDictionary];
    }
    
    NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
    [addressDictionary setObject:addressArray forKey:@"addresses"];
    
    NSMutableDictionary *userDictionary = [[NSMutableDictionary alloc] init];
    [userDictionary setObject:addressDictionary forKey:@"user"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [[manager requestSerializer] setValue:[[TRMAuthHolder sharedInstance] authString] forHTTPHeaderField:@"HTTP_AUTHORIZATION"];
    [manager PUT:addCustomerUrl parameters:userDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonDict = [responseObject objectForKey:@"user"];
        TRMCustomerModel *customer = [TRMCustomerModel objectFromJSONObject:jsonDict mapping:nil];
        
        
        //array of addresses
        NSMutableArray *customerAddresses = [[NSMutableArray alloc] init];
        [[customer addresses] enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSDictionary *addressDictionary, NSUInteger idx, BOOL *stop) {
            TRMAddressModel *address = [TRMAddressModel objectFromJSONObject:addressDictionary mapping:nil];
            [customerAddresses addObject:address];
        }];
        
        //array of phone numbers
        NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
        [[customer phones] enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSDictionary *phoneDict, NSUInteger idx, BOOL *stop) {
            TRMPhoneModel *phone = [TRMPhoneModel objectFromJSONObject:phoneDict mapping:nil];
            [phoneNumbers addObject:phone];
        }];
        
        //need to map orders
        NSMutableArray *inProgressOrders = [[NSMutableArray alloc] init];
        [[customer in_progress_orders] enumerateObjectsUsingBlock:^(NSDictionary *orderDictionary, NSUInteger idx, BOOL *stop) {
            TRMOrderModel *order = [TRMOrderModel objectFromJSONObject:orderDictionary mapping:nil];
            
            //will need to process order items if they exsist
            NSMutableArray *orderItems = [[NSMutableArray alloc] init];
            [[order order_items] enumerateObjectsUsingBlock:^(NSDictionary *orderItemDictionary, NSUInteger idx, BOOL *stop) {
                TRMProductModel *orderItem = [TRMProductModel objectFromJSONObject:orderDictionary mapping:nil];
                [orderItem setOrder_item_id:[[orderItemDictionary valueForKey:@"id"] intValue]];
                [orderItem setId:[[orderItemDictionary valueForKey:@"product_id"] intValue]];
                [orderItems addObject:orderItem];
                
            }];
            
            [order setOrder_items:orderItems];
            
            [inProgressOrders addObject:order];
        }];
        
        //update in progree orders
        [customer setIn_progress_orders:inProgressOrders];
        
        //update phone numbers for customer
        [customer setPhones:phoneNumbers];
        
        //update addresses for customer
        [customer setAddresses:customerAddresses];
        
        //add customer to core api
        [[TRMCoreApi sharedInstance] setCustomer:customer];
        handler(customer, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        handler(nil, error);
    }];
}

+ (void)createAddress:(TRMAddressModel *)address forCustomer:(TRMCustomerModel *)customer completionHandler:(void (^)(TRMCustomerModel *newCustomer, NSError *))handler {
    
    NSString *addCustomerUrl = [[TRMEnviorment sharedInstance] urlForNewCustomers];
    addCustomerUrl = [addCustomerUrl stringByAppendingString:[NSString stringWithFormat:@"%@",[customer id]]];
    
    NSMutableArray *addressArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *individualAddressDictionary = [[NSMutableDictionary alloc] init];
    [individualAddressDictionary setValue:[address state_abbr_name] forKey:@"state_abbr_name"];
    [individualAddressDictionary setValue:[customer fullName] forKey:@"name"]; //name needs to be associated with a user when creating
    [individualAddressDictionary setValue:[address city] forKey:@"city"];
    [individualAddressDictionary setValue:[NSNumber numberWithBool:[address business]] forKey:@"business"];
    [individualAddressDictionary setValue:[NSNumber numberWithBool:[address shipping_default]] forKey:@"shipping_default"];
    [individualAddressDictionary setValue:[NSNumber numberWithBool:[address billing_default]] forKey:@"billing_default"];
    
    if ([[address address2] length]) {
        [individualAddressDictionary setValue:[address address2] forKey:@"address2"];
    }
    
    [individualAddressDictionary setValue:[NSNumber numberWithBool:[address active]] forKey:@"active"];
    [individualAddressDictionary setValue:[address zip_code] forKey:@"zip_code"];
    [individualAddressDictionary setValue:[address address1] forKey:@"address1"];
    [addressArray addObject:individualAddressDictionary];
    
    NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
    [addressDictionary setObject:addressArray forKey:@"addresses"];
    
    NSMutableDictionary *userDictionary = [[NSMutableDictionary alloc] init];
    [userDictionary setObject:addressDictionary forKey:@"user"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [[manager requestSerializer] setValue:[[TRMAuthHolder sharedInstance] authString] forHTTPHeaderField:@"HTTP_AUTHORIZATION"];
    [manager PUT:addCustomerUrl parameters:userDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonDict = [responseObject objectForKey:@"user"];
        TRMCustomerModel *customer = [TRMCustomerModel objectFromJSONObject:jsonDict mapping:nil];
        
        //array of addresses
        NSMutableArray *customerAddresses = [[NSMutableArray alloc] init];
        [[customer addresses] enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSDictionary *addressDictionary, NSUInteger idx, BOOL *stop) {
            TRMAddressModel *address = [TRMAddressModel objectFromJSONObject:addressDictionary mapping:nil];
            [customerAddresses addObject:address];
        }];
        
        //array of phone numbers
        NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
        [[customer phones] enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSDictionary *phoneDict, NSUInteger idx, BOOL *stop) {
            TRMPhoneModel *phone = [TRMPhoneModel objectFromJSONObject:phoneDict mapping:nil];
            [phoneNumbers addObject:phone];
        }];
        
        //need to map orders
        NSMutableArray *inProgressOrders = [[NSMutableArray alloc] init];
        [[customer in_progress_orders] enumerateObjectsUsingBlock:^(NSDictionary *orderDictionary, NSUInteger idx, BOOL *stop) {
            TRMOrderModel *order = [TRMOrderModel objectFromJSONObject:orderDictionary mapping:nil];
            
            //will need to process order items if they exsist
            NSMutableArray *orderItems = [[NSMutableArray alloc] init];
            [[order order_items] enumerateObjectsUsingBlock:^(NSDictionary *orderItemDictionary, NSUInteger idx, BOOL *stop) {
                TRMProductModel *orderItem = [TRMProductModel objectFromJSONObject:orderDictionary mapping:nil];
                [orderItem setOrder_item_id:[[orderItemDictionary valueForKey:@"id"] intValue]];
                [orderItem setId:[[orderItemDictionary valueForKey:@"product_id"] intValue]];
                [orderItems addObject:orderItem];
                
            }];
            
            [order setOrder_items:orderItems];
            
            [inProgressOrders addObject:order];
        }];
        
        //update in progree orders
        [customer setIn_progress_orders:inProgressOrders];
        
        //update phone numbers for customer
        [customer setPhones:phoneNumbers];
        
        //update addresses for customer
        [customer setAddresses:customerAddresses];
        
        //add customer to core api
        [[TRMCoreApi sharedInstance] setCustomer:customer];
        
        handler(customer, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        handler(nil, error);
    }];

}
@end