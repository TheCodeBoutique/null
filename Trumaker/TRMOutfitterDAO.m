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

@implementation TRMOutfitterDAO

+(void)uploadPhotoForOutfitter:(TRMOutfitterModel*)outfitter withPhoto:(UIImage *)photo {
    NSString *updateOrderUrl = [[TRMEnviorment sharedInstance] urlForOutfitterImageUpload];
    updateOrderUrl = [updateOrderUrl stringByAppendingString:[NSString stringWithFormat:@"%@/profile_picture",[outfitter id]]];
//    4567/profile_picture
    NSData *imageData = UIImagePNGRepresentation(photo);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [[manager requestSerializer] setValue:[[TRMAuthHolder sharedInstance] authString] forHTTPHeaderField:@"HTTP_AUTHORIZATION"];
    
    [manager POST:updateOrderUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFormData:imageData name:@"image"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
    }];
}
@end
