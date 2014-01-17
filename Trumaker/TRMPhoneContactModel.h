//
//  TRMPhoneContactModel.h
//  Trumaker
//
//  Created by Kyle Carriedo on 1/16/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRMPhoneContactModel : NSObject
@property (strong, nonatomic) NSString *first_name;
@property (strong, nonatomic) NSString *last_name;
@property (strong, nonatomic) NSMutableArray  *phone_numbers;
@property (strong, nonatomic) NSMutableArray  *addresses;
@property (strong, nonatomic) NSMutableArray  *emails;

-(NSString *)fullName;
@end
