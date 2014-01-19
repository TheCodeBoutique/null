//
//  TRMProductModel.h
//  Trumaker
//
//  Created by Kyle Carriedo on 1/14/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRMProductModel : NSObject
@property (assign,nonatomic) int id;

@property (strong,nonatomic) NSString *description;
@property (strong,nonatomic) NSString *description_markup;
@property (strong,nonatomic) NSString *default_monogram;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *price;
@property (strong,nonatomic) NSString *created_at;
@property (strong,nonatomic) NSString *tagline;

@property (strong,nonatomic) NSArray *default_customization_ids;
@property (strong,nonatomic) NSArray *image_ids;
@property (strong,nonatomic) NSArray *tag_list;

@property (assign,nonatomic) BOOL featured;
@property (assign,nonatomic) BOOL low_stock;
@property (assign,nonatomic) BOOL sold_out;

//combine order items with product selection since all we care about is customizations and order_item id
@property (strong, nonatomic) NSString *build_name;
@property (strong, nonatomic) NSMutableArray *customizations;
@property (strong, nonatomic) NSString *item_total;
@property (assign, nonatomic) int order_item_id;

//helpers
-(NSString *)parseTitle;

//add helper to say if its order item

//private
@property (strong, nonatomic) NSNumber *selectedCount;
@property (assign, nonatomic) BOOL isSelected;
-(void)incrementSelectedCount;
-(void)decrementSelectedCount;
@end