//
//  TRMProductsDAO.m
//  Trumaker
//
//  Created by Kyle Carriedo on 1/14/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//
#import "AFHTTPRequestOperationManager.h"
#import "NSObject+JTObjectMapping.h"
#import "TRMProductsDAO.h"
#import "TRMCoreApi.h"


#import "TRMEnviorment.h"
#import "TRMAuthHolder.h"
#import "TRMProductModel.h"
#import "TRMConfigurationModel.h"

@implementation TRMProductsDAO
- (void)fetchProducts {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [[manager requestSerializer] setValue:[[TRMAuthHolder sharedInstance] authString] forHTTPHeaderField:@"HTTP_AUTHORIZATION"];
    
    NSString *url = [NSString stringWithFormat:@"%@",[[TRMEnviorment sharedInstance] urlForProducts]];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *mainDictionary = responseObject;
        NSMutableArray *imagesArray = [[NSMutableArray alloc] init];
        imagesArray = [mainDictionary objectForKey:@"images"];
        
        NSMutableArray *productDetailsArray = [[NSMutableArray alloc] init];
        productDetailsArray = [mainDictionary objectForKey:@"products"];
        
        NSMutableDictionary *hashMapDictionary = [[NSMutableDictionary alloc] init];
        [imagesArray enumerateObjectsUsingBlock:^(NSDictionary *imageDict, NSUInteger idx, BOOL *stop) {
        NSNumber *objectId = (NSNumber *)[imageDict objectForKey:@"id"];
            [hashMapDictionary setValue:[imageDict valueForKey:@"image_url"] forKey:[objectId stringValue]];
        }];
        
        NSMutableArray *productModelArray = [[NSMutableArray alloc] init];
        [productDetailsArray enumerateObjectsUsingBlock:^(NSDictionary *productsDict, NSUInteger idx, BOOL *stop) {
             NSMutableArray *imageUrlsArray = [[NSMutableArray alloc] init];
            TRMProductModel *product = [TRMProductModel objectFromJSONObject:productsDict mapping:nil];
            //iterate through image url ids
            [[product image_ids] enumerateObjectsUsingBlock:^(NSNumber *objId, NSUInteger idx, BOOL *stop) {
                //extracts image url for id found in hash map
                NSString *imageUrl = [hashMapDictionary valueForKey:[objId stringValue]];
                //add to image url array
                [imageUrlsArray addObject:imageUrl];
            }];
            //replace image ids with image urls
            [product setImage_ids:imageUrlsArray];
            [productModelArray addObject:product];
        }];
        
        //Update the singleton with the new products
        [[TRMCoreApi sharedInstance] setProducts:productModelArray];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
    }];
    
}

- (void)fetchConfigurations {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [[manager requestSerializer] setValue:[[TRMAuthHolder sharedInstance] authString] forHTTPHeaderField:@"HTTP_AUTHORIZATION"];
    
    NSString *url = [NSString stringWithFormat:@"%@",[[TRMEnviorment sharedInstance] urlForConfigurations]];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array = [responseObject objectForKey:@"customizations"];
        NSMutableArray *configurationsArray = [[NSMutableArray alloc] init];
        [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            TRMConfigurationModel *configuration = [TRMConfigurationModel objectFromJSONObject:obj mapping:nil];
            [configurationsArray addObject:configuration];
        }];
        
        //Update the singleton with the new products
        [[TRMCoreApi sharedInstance] setConfigurations:configurationsArray];
     
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
    }];
}


- (void)saveSelectedProducts:(NSMutableArray *)selectedProducts {
    
}



//-(void)updateProductSelectionForOrder:(NSMutableArray *)products withOrderId:(NSInteger )orderId completionHandler:(void (^)(TRMOrder *order, NSError *))handler
//{
//    NSString *updateOrderUrl = [[TRMEnviorment sharedInstance] urlForUpdatingOrder];
//    NSString *orderStringId   = [NSString stringWithFormat:@"%d",orderId];
//    NSString *orderUrl = [NSString stringWithFormat:@"%@%@",updateOrderUrl,orderStringId];
//    NSURL *baseURL = [NSURL URLWithString:[[TRMEnviorment sharedInstance] baseURL]];
//    
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
//    [client setParameterEncoding:AFJSONParameterEncoding];
//    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
//    [client setDefaultHeader:@"HTTP_AUTHORIZATION" value:[[TRMAuthHolder sharedInstance] authString]];
//    NSLog(@"HTTP_AUTHORIZATION  %@",[[TRMAuthHolder sharedInstance] authString]);
//    NSMutableArray *productsArray = [[NSMutableArray alloc] init];
//    
//    
//    
//#pragma mark finished orders check
//    BOOL isFirstShirtState = [[TRMCoreApi sharedInstance] isFirstShirtSelection];
//    
//    //parse products then add first shirt
//    for (int i = 0; i < [products count]; i++) {
//        TRMProduct *product = [products objectAtIndex:i];
//        NSLog(@"Poduct ID %d",[product id]);
//        NSMutableDictionary *orderDict = [[NSMutableDictionary alloc] init];
//        [orderDict setValue:[NSNumber numberWithInt:[product id]] forKey:@"product_id"];
//        
//        if (isFirstShirtState) {
//            [orderDict setValue:@"remaining" forKey:@"item_type"];
//        }
//        
//        NSMutableArray *configurationsForProducts = [[TRMParser sharedInstance] JSONForConfigurationsCheckout:[product configurations]];
//        //        [orderDict setObject:configurationsForProducts forKey:@"customizations"];
//        
//        [productsArray addObject:orderDict];
//    }
//    
//    
//    //finished orders check
//    if (isFirstShirtState) {
//        TRMProduct *firstShirt = [[[TRMCoreApi sharedInstance] firstShirtSelection] objectAtIndex:0];
//        if (firstShirt) {
//            NSLog(@"We found first Shirt %@",firstShirt.name);
//            NSMutableDictionary *orderDict = [[NSMutableDictionary alloc] init];
//            NSLog(@"FirstShirt Poduct ID %d",[firstShirt id]);
//            [orderDict setValue:[NSNumber numberWithInt:[firstShirt id]] forKey:@"product_id"];
//            [orderDict setValue:@"first" forKey:@"item_type"];
//            
//            NSMutableArray *configurationsForProducts = [[TRMParser sharedInstance] JSONForConfigurationsCheckout:[firstShirt configurations]];
//            //            [orderDict setObject:configurationsForProducts forKey:@"customizations"];
//            [productsArray addObject:orderDict];
//        }
//    }
//    
//    NSMutableDictionary *productsDict = [[NSMutableDictionary alloc] init];
//    [productsDict setObject:productsArray forKey:@"order_items"];
//    
//    
//    
//    //update missing user key for json
//    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
//    [dataDict setObject:productsDict forKey:@"order"];
//    
//    [self sampleJSON:dataDict];
//    
//    [client putPath:orderUrl parameters:dataDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        if (responseObject)
//        {
//            NSDictionary *json =  [NSJSONSerialization
//                                   JSONObjectWithData:responseObject
//                                   options:NSJSONReadingAllowFragments
//                                   error:nil];
//            
//            NSLog(@"resonse JSON = %@",json);
//            TRMOrder *orderUpdate =[[TRMParser sharedInstance] parseOrderFromJSON:json];
//            handler(orderUpdate, nil);
//        }
//        else
//        {
//            NSLog(@"JSON error");
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [[TRMErrorState sharedInstance] HandleStateWithError:error withOperation:operation];
//    }];
//    
//}
@end