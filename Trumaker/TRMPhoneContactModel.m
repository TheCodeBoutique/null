//
//  TRMPhoneContactModel.m
//  Trumaker
//
//  Created by Kyle Carriedo on 1/16/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMPhoneContactModel.h"
@implementation TRMPhoneContactModel
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(NSString *)fullName {
    return [NSString stringWithFormat:@"%@ %@",self.first_name,self.last_name];
}
@end
