//
//  TRMLoginDAO.m
//  Trumaker
//
//  Created by Marin Fischer on 1/6/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "UIImageView+WebCache.h"

#import "TRMLoginDAO.h"
#import "TRMCustomerDAO.h"
#import "TRMEnviorment.h"
#import "TRMAuthHolder.h"
#import "TRMOutfitterModel.h"
#import "TRMCoreApi.h"

#import "NSObject+JTObjectMapping.h"

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
        TRMOutfitterModel *outfitter = [TRMOutfitterModel objectFromJSONObject:outFitterDict mapping:nil];
        [[TRMCoreApi sharedInstance] setOutfitter:outfitter];
        [[TRMAuthHolder sharedInstance] setAuthString:[outFitterDict valueForKey:@"authentication_token"]];
        
        //if we have image url go download it
        if ([outfitter picture]) {
            [self downloadImageForOutFitter:outfitter completionHandler:^(UIImage *image, NSError *error) {
                if (image) {
                    [outfitter setOutfitterImage:image];
                    handler(YES, nil);
                } else {
                    handler(NO, error);
                }
                 [[[TRMCustomerDAO alloc] init] fetchCustomersForOutfitter];
            }];
        } else {
            [[[TRMCustomerDAO alloc] init] fetchCustomersForOutfitter];
            handler(YES, nil);
        }
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        handler(NO, error);
    }];
}

//This operation will download a new image for the outfitter
-(void)downloadImageForOutFitter:(TRMOutfitterModel *)outfitter completionHandler:(void(^)( UIImage *image, NSError *error))handler {
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadWithURL:[NSURL URLWithString:[outfitter picture]]
                     options:0
                    progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        NSLog(@"receivedSize : %d expectedSize : %d",receivedSize,expectedSize);
                    }
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                       if (image) {
                           handler(image, nil);
                       } else {
                           handler(nil, error);
                       }
                   }];
}
@end
