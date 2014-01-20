//
//  TRMAddressModel.m
//  Trumaker
//
//  Created by Kyle Carriedo on 1/14/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMAddressModel.h"

@implementation TRMAddressModel

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(NSString *)cityState {
    return [NSString stringWithFormat:@"%@ %@",[self city],[self state_abbr_name]];
}

-(BOOL)isBothShippingAndBilling {
    return ([self billing_default] && [self shipping_default]) ? YES : NO;
}
@end
