//
//  TRMFormula.h
//  Trumaker
//
//  Created on 9/22/13.
//  Copyright (c) 2013 The Code Boutique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRMFormulaData.h"
@protocol TRMFormulaDelegate;

@interface TRMFormula : NSObject
@property (weak, nonatomic) id <TRMFormulaDelegate> delegate;

-(void) neckFormula:(TRMFormulaData *)data;
-(void) chestFormula:(TRMFormulaData *)data;
-(void) waistFormula:(TRMFormulaData *)data;
-(void) seatFormula:(TRMFormulaData *)data;
-(void) shouldersFormula:(TRMFormulaData *)data;
-(void) rightArmFormula:(TRMFormulaData *)data;
-(void) leftArmFormula:(TRMFormulaData *)data;
-(void) rightWristFormula:(TRMFormulaData *)data;
-(void) leftWristFormula:(TRMFormulaData *)data;
-(void) shirtFormula:(TRMFormulaData *)data;
-(void) bicepFormula:(TRMFormulaData *)data;
@end

@protocol TRMFormulaDelegate <NSObject>
-(void)lowerBounds:(float)lower upperBounds:(float)upper forType:(int)type withEstimate:(float)estimate withIncrement:(float)increment;
@end
