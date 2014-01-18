//
//  TRMProductsDAO.h
//  Trumaker
//
//  Created by Kyle Carriedo on 1/14/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRMOrderModel.h"
@interface TRMProductsDAO : NSObject
- (void)fetchProducts;
- (void)fetchConfigurations;
- (void)saveSelectedProducts:(NSMutableArray *)selectedProducts withOrderId:(int)orderId completionHandler:(void (^)(TRMOrderModel *order, NSError *))handler;
@end
