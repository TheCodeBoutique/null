//
//  TRMFormulaData.m
//  Trumaker
//
//  Created on 9/22/13.
//  Copyright (c) 2013 The Code Boutique. All rights reserved.
//

#import "TRMFormulaData.h"

@implementation TRMFormulaData
- (id)init
{
    self = [super init];
    if (self) {
        _weightIsRed = NO;
        _heightIsRed = NO;
        _neckIsRed = NO;
        _chestIsRed = NO;
        _waistIsRed = NO;
        _seatIsRed = NO;
        _shouldersIsRed = NO;
        _rightArmIsRed = NO;
        _leftArmIsRed = NO;
        _leftWristIsRed = NO;
        _rightWristIsRed = NO;
        _shirtLengthIsRed = NO;
        _bicepIsRed = NO;
    }
    return self;
}
@end
