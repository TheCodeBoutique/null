//
//  TRMFormulaData.h
//  Trumaker
//
//  Created on 9/22/13.
//  Copyright (c) 2013 The Code Boutique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRMFormulaData : NSObject
@property (assign, nonatomic) float weight;
@property (assign, nonatomic) float height;
@property (assign, nonatomic) float neck;
@property (assign, nonatomic) float chest;
@property (assign, nonatomic) float waist;
@property (assign, nonatomic) float seat;
@property (assign, nonatomic) float shoulders;
@property (assign, nonatomic) float rightArm;
@property (assign, nonatomic) float leftArm;
@property (assign, nonatomic) float rightWrist;
@property (assign, nonatomic) float leftWrist;
@property (assign, nonatomic) float shirtLength;
@property (assign, nonatomic) float bicep;


//private
@property (assign,nonatomic)BOOL weightIsRed;
@property (assign,nonatomic)BOOL heightIsRed;
@property (assign,nonatomic)BOOL neckIsRed;
@property (assign,nonatomic)BOOL chestIsRed;
@property (assign,nonatomic)BOOL waistIsRed;
@property (assign,nonatomic)BOOL seatIsRed;
@property (assign,nonatomic)BOOL shouldersIsRed;
@property (assign,nonatomic)BOOL rightArmIsRed;
@property (assign,nonatomic)BOOL leftArmIsRed;
@property (assign,nonatomic)BOOL leftWristIsRed;
@property (assign,nonatomic)BOOL rightWristIsRed;
@property (assign,nonatomic)BOOL shirtLengthIsRed;
@property (assign,nonatomic)BOOL bicepIsRed;
@end
