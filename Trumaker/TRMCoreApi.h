//
//  TRMCoreApi.h
//  Trumaker
//
//  Created by Kyle Carriedo on 1/12/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRMOutfitterModel.h"

@interface TRMCoreApi : NSObject
@property (nonatomic, strong) TRMOutfitterModel *outfitter; //person currently logged in
@property (nonatomic, strong) NSMutableArray *products; //this is the list of trumaker products (shirts)
@property (nonatomic, strong) NSMutableArray *configurations; //shirt configurations

+ (TRMCoreApi *)sharedInstance;
@end
