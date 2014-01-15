//
//  TRMCustomerModel.m
//  Trumaker
//
//  Created by Kyle Carriedo on 1/12/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMCustomerModel.h"

@implementation TRMCustomerModel
-(NSString *)fullName {
    return  [NSString stringWithFormat:@"%@ %@",[self first_name], [self last_name]];
}
@end
