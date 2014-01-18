//
//  TRMPhoneModel.h
//  Trumaker
//
//  Created by Kyle Carriedo on 1/14/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface TRMPhoneModel : NSObject
@property (assign,nonatomic) int id;
@property (strong, nonatomic) NSString *number;
@property (strong, nonatomic) NSString *phone_type;

-(NSString *)formattedNumber;
@end
