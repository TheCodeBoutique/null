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
@property (nonatomic, strong) TRMOutfitterModel *outfitter;

+ (TRMCoreApi *)sharedInstance;
@end
