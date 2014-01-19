//
//  TRMProductsDAO.h
//  Trumaker
//
//  Created by Kyle Carriedo on 1/14/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRMProductModel.h"
@interface TRMProductsDAO : NSObject
- (void)fetchProducts;
- (void)fetchConfigurations;
- (void)saveSelectedProducts:(NSMutableArray *)selectedProducts withOrderId:(int)orderId completionHandler:(void (^)(TRMProductModel *order, NSError *))handler;
@end
