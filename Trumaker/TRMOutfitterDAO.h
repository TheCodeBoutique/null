//
//  TRMOutfitterDAO.h
//  Trumaker
//
//  Created by Kyle Carriedo on 1/20/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRMOutfitterModel.h"
@interface TRMOutfitterDAO : NSObject
+(void)uploadPhotoForOutfitter:(TRMOutfitterModel*)outfitter withPhoto:(UIImage *)photo;
@end
