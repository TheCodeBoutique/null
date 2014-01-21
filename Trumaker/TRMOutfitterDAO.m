//
//  TRMOutfitterDAO.m
//  Trumaker
//
//  Created by Kyle Carriedo on 1/20/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//
#import "AFHTTPRequestOperationManager.h"
#import "TRMEnviorment.h"
#import "TRMAuthHolder.h"
#import "TRMOutfitterDAO.h"
#import "TRMCustomerModel.h"
#import "TRMCoreApi.h"
#import "TRMAddressModel.h"
#import "TRMProductModel.h"
#import "TRMOrderModel.h"
#import "NSObject+JTObjectMapping.h"

@implementation TRMOutfitterDAO

+(void)uploadPhotoForOutfitter:(TRMOutfitterModel*)outfitter withPhoto:(UIImage *)photo completionHandler:(void (^)(TRMOutfitterModel *outfitter, NSError *))handler
 {
    NSString *updateOrderUrl = [[TRMEnviorment sharedInstance] urlForOutfitterImageUpload];
//    updateOrderUrl = [updateOrderUrl stringByAppendingString:[NSString stringWithFormat:@"%@/profile_picture",[outfitter id]]];
//    4567/profile_picture
//    NSData *imageData = UIImagePNGRepresentation(photo);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [[manager requestSerializer] setValue:[[TRMAuthHolder sharedInstance] authString] forHTTPHeaderField:@"HTTP_AUTHORIZATION"];
    
    [manager POST:updateOrderUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFormData:imageData name:@"file"];
        [formData appendPartWithFileData:UIImageJPEGRepresentation(photo, 0.5) name:@"file" fileName:@"file" mimeType:@"image/jpeg"];
     
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonDict = [responseObject objectForKey:@"user"];
       TRMOutfitterModel *outfit = [TRMOutfitterModel objectFromJSONObject:jsonDict mapping:nil];       
        
        //add customer to core api
        [[TRMCoreApi sharedInstance] setOutfitter:outfit];
        
        handler(outfit, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
    }];
}
@end
