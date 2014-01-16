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
@end
