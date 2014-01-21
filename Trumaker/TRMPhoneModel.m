//
//  TRMPhoneModel.m
//  Trumaker
//
//  Created by Kyle Carriedo on 1/14/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMPhoneModel.h"

@implementation TRMPhoneModel

-(NSString *)formattedNumber {
    return [self formatNumber:_number];
 }

-(NSString*)formatNumber:(NSString*)mobileNumber
{
    NSMutableString *formattedNumber = [NSMutableString stringWithString:mobileNumber];
    [formattedNumber insertString:@"(" atIndex:0];
    [formattedNumber insertString:@")" atIndex:4];
    [formattedNumber insertString:@" " atIndex:5];
    [formattedNumber insertString:@"-" atIndex:9];
    mobileNumber = formattedNumber;
    return mobileNumber;
}


-(NSNumber *)phoneTypeFromString:(NSString *)phoneType {
    NSNumber *phoneId;
    if ([phoneType isEqualToString:@"Cell"]) {
        phoneId = [NSNumber numberWithInt:1];
    } else if ([phoneType isEqualToString:@"Home"]) {
        phoneId = [NSNumber numberWithInt:2];
    } else if ([phoneType isEqualToString:@"Work"]) {
        phoneId = [NSNumber numberWithInt:3];
    } else if ([phoneType isEqualToString:@"Other"]) {
        phoneId = [NSNumber numberWithInt:4];
    }
    return phoneId;
}
@end
