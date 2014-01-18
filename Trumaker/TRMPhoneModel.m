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
@end
