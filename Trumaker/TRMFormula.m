//
//  TRMFormula.m
//  Trumaker
//
//  Created on 9/22/13.
//  Copyright (c) 2013 The Code Boutique. All rights reserved.
//

#import "TRMFormula.h"

#define NECK_T_DISTRIBUTION_YELLOW          1.03726344144764
#define NECK_T_DISTRIBUTION_RED             1.03726344144764

#define CHEST_T_DISTRIBUTION_YELLOW         1.03726344144764
#define CHEST_T_DISTRIBUTION_RED            1.03726344144764

#define WAIST_T_DISTRIBUTION_YELLOW         1.28286343724495
#define WAIST_T_DISTRIBUTION_RED            1.28286343724495

#define SEAT_T_DISTRIBUTION_YELLOW          1.28286343724495
#define SEAT_T_DISTRIBUTION_RED             1.28286343724495

#define SHOULDERS_T_DISTRIBUTION_YELLOW     0.674869128515829
#define SHOULDERS_T_DISTRIBUTION_RED        0.674869128515829

#define RIGHT_ARM_T_DISTRIBUTION_YELLOW     1.03726730527554
#define RIGHT_ARM_T_DISTRIBUTION_RED        1.03726730527554

#define LEFT_ARM_T_DISTRIBUTION_YELLOW      1.03726601334227
#define LEFT_ARM_T_DISTRIBUTION_RED         1.03726601334227

#define RIGHT_WRIST_T_DISTRIBUTION_YELLOW   1.03726730527554
#define RIGHT_WRIST_T_DISTRIBUTION_RED      1.03726730527554

#define LEFT_WRIST_T_DISTRIBUTION_YELLOW    1.03726601334227
#define LEFT_WRIST_T_DISTRIBUTION_RED       1.03726601334227

#define SHIRT_T_DISTRIBUTION_YELLOW         1.0372699012073
#define SHIRT_T_DISTRIBUTION_RED            1.0372699012073

#define BICEP_T_DISTRIBUTION_YELLOW         1.0372699012073
#define BICEP_T_DISTRIBUTION_RED            1.0372699012073

//1.0372699012073
@implementation TRMFormula

-(void)neckFormula:(TRMFormulaData *)data
{
    float estimate       = 11.00892 + 0.02815f * data.weight;
    float myWeight       = powf(data.weight - 179.9615,2) / 533074;
    float std_error_part = 0.5043404 * ( 1 + 1/649 + myWeight);
    float std_error      = powf(std_error_part, 0.5f);
    
    float up_bound       = estimate + NECK_T_DISTRIBUTION_RED * std_error;
    float low_bound      = estimate - NECK_T_DISTRIBUTION_YELLOW * std_error;
    
    float lowerBounds    = roundf(low_bound  * 10) / 10.0;
    float upperBounds    = roundf(up_bound   * 10) / 10.0;
    
    [[self delegate] lowerBounds:lowerBounds upperBounds:upperBounds forType:0 withEstimate:estimate withIncrement:0.25f];
}

-(void)chestFormula:(TRMFormulaData *)data
{
    float estimate       =  11.173341 + 0.081137 * data.weight + 0.946749 * data.neck;
    float neck           =  powf(data.neck - 16.07654,2) / 749.6297;
    float weight         =  powf(data.weight - 180,2) / 533700;
    float std_error_part =  3.038655 * ( 1 + 1/650 + weight + neck);
    float std_error      = powf(std_error_part, 0.5f);
    
    float up_bound       = estimate + CHEST_T_DISTRIBUTION_RED    * std_error;
    float low_bound      = estimate - CHEST_T_DISTRIBUTION_YELLOW * std_error;
    
    float lowerBounds    = roundf(low_bound  * 10) / 10.0;
    float upperBounds    = roundf(up_bound   * 10) / 10.0;
    
    [[self delegate] lowerBounds:lowerBounds upperBounds:upperBounds forType:1 withEstimate:estimate withIncrement:0.50f];
}

-(void)waistFormula:(TRMFormulaData *)data
{
 

    float estimate       =  -7.12001 + 0.026739 * data.weight + 0.411604 * data.neck + 0.793825 * data.chest;
    float neck           =  powf(data.neck - 16.07512,2) / 748.7756;
    float weight         =  powf(data.weight - 179.9615,2) / 533074;
    float chest          =  powf(data.chest - 40.99692,2) / 8459.494;
    float std_error_part =  4.03987 * ( 1 + 1/649 + weight + neck + chest);
    float std_error      = powf(std_error_part, 0.5f);
    
    
    float up_bound       = estimate + WAIST_T_DISTRIBUTION_RED    * std_error;
    float low_bound      = estimate - WAIST_T_DISTRIBUTION_YELLOW * std_error;
    
    float lowerBounds    = roundf(low_bound  * 10) / 10.0;
    float upperBounds    = roundf(up_bound   * 10) / 10.0;
    
    [[self delegate] lowerBounds:lowerBounds upperBounds:upperBounds forType:2 withEstimate:estimate withIncrement:0.50f];
}

-(void)seatFormula:(TRMFormulaData *)data
{
    

    float estimate       =  19.731198 + 0.056257 * data.weight + 0.311303 * data.waist;
//     (2.021411*(1+1/648+(Weight0-179.9614)^2/533074+(Waist0-36.8534)^2/12476.07))^.5
    float weight         =  powf(data.weight - 179.9614,2) / 533074;
    float waist          =  powf(data.waist - 36.8534,2) / 12476.07;
    
    float std_error_part =  2.021411 * ( 1 + 1/648 + weight + waist);
    float std_error      = powf(std_error_part, 0.5f);
    
    float up_bound       = estimate + SEAT_T_DISTRIBUTION_RED    * std_error;
    float low_bound      = estimate - SEAT_T_DISTRIBUTION_YELLOW * std_error;
    
    float lowerBounds    = roundf(low_bound  * 10) / 10.0;
    float upperBounds    = roundf(up_bound   * 10) / 10.0;
    
    [[self delegate] lowerBounds:lowerBounds upperBounds:upperBounds forType:3 withEstimate:estimate withIncrement:0.50f];
}

-(void)shouldersFormula:(TRMFormulaData *)data
{
    
    float estimate       =  9.410095 + 0.017101 * data.weight + 0.233361 * data.neck + 0.066891 * data.chest;
    
    float weight         =  powf(data.weight - 180,2) / 533700;
    float neck           =  powf(data.neck - 16.07654,2) / 749.6297;
    float chest          =  powf(data.chest - 40.99846,2) / 8460.498;
    
    float std_error_part =  1.009072 * ( 1 + 1/650 + weight + chest + neck);
    float std_error      = powf(std_error_part, 0.5f);
    
    float up_bound       = estimate + SHOULDERS_T_DISTRIBUTION_RED    * std_error;
    float low_bound      = estimate - SHOULDERS_T_DISTRIBUTION_YELLOW * std_error;
    
    float lowerBounds    = roundf(low_bound  * 10) / 10.0;
    float upperBounds    = roundf(up_bound   * 10) / 10.0;
    
    [[self delegate] lowerBounds:lowerBounds upperBounds:upperBounds forType:4 withEstimate:estimate withIncrement:0.25f];
}

-(void)rightArmFormula:(TRMFormulaData *)data
{
    
    float estimate       =  11.96447 + 0.21235 * data.height + 0.45141 * data.shoulders;
    
    float height         =  powf(data.height - 70.05641,2) / 11749.69;
    float shoulders      =  powf(data.shoulders - 18.97991,2) / 1193.114;
    
    float std_error_part =  1.431876 * ( 1 + 1/647 + height + shoulders);
    float std_error      = powf(std_error_part, 0.5f);
    
    float up_bound       = estimate + RIGHT_ARM_T_DISTRIBUTION_RED    * std_error;
    float low_bound      = estimate - RIGHT_ARM_T_DISTRIBUTION_YELLOW * std_error;
    
    float lowerBounds    = roundf(low_bound  * 10) / 10.0;
    float upperBounds    = roundf(up_bound   * 10) / 10.0;
    
    [[self delegate] lowerBounds:lowerBounds upperBounds:upperBounds forType:5 withEstimate:estimate withIncrement:0.50f];
}

-(void)leftArmFormula:(TRMFormulaData *)data
{
    
    float estimate       =  0.668177 + 0.979405 * data.rightArm;

    float rightArm         =  powf(data.rightArm - 35.40842,2) / 1878.137;
    
    float std_error_part =  0.1514215 * ( 1 + 1/647 + rightArm);
    float std_error      = powf(std_error_part, 0.5f);
    
    float up_bound       = estimate + LEFT_ARM_T_DISTRIBUTION_RED    * std_error;
    float low_bound      = estimate - LEFT_ARM_T_DISTRIBUTION_YELLOW * std_error;
    
    float lowerBounds    = roundf(low_bound  * 10) / 10.0;
    float upperBounds    = roundf(up_bound   * 10) / 10.0;
    
    [[self delegate] lowerBounds:lowerBounds upperBounds:upperBounds forType:6 withEstimate:estimate withIncrement:0.50f];
}

-(void)rightWristFormula:(TRMFormulaData *)data
{
    
    float estimate       =  4.1263277 + 0.0091675 * data.weight + 0.0758440 * data.neck;
    
    float weight         =  powf(data.weight - 179.9691,2) / 533049.4;
    float neck           =  powf(data.neck - 16.07457,2) / 748.5893;
    
    float std_error_part =  0.0898871*(1+1/647 + weight + neck);
    float std_error      = powf(std_error_part, 0.5f);
    
    float up_bound       = estimate + RIGHT_WRIST_T_DISTRIBUTION_RED    * std_error;
    float low_bound      = estimate - RIGHT_WRIST_T_DISTRIBUTION_YELLOW * std_error;
    
    float lowerBounds    = roundf(low_bound  * 10) / 10.0;
    float upperBounds    = roundf(up_bound   * 10) / 10.0;
    
    [[self delegate] lowerBounds:lowerBounds upperBounds:upperBounds forType:7 withEstimate:estimate withIncrement:0.25];
}

-(void)leftWristFormula:(TRMFormulaData *)data
{
    
    float estimate       =   0.57961 + 0.91510 * data.rightWrist;
    
    float rightWrist     =  powf(data.rightWrist - 6.995363,2) / 127.8611;
    
    float std_error_part =  0.01784284 * (1 + 1/647 + rightWrist);
    
    float std_error      = powf(std_error_part, 0.5f);
    
    float up_bound       = estimate + LEFT_WRIST_T_DISTRIBUTION_RED    * std_error;
    float low_bound      = estimate - LEFT_WRIST_T_DISTRIBUTION_YELLOW * std_error;
    
    float lowerBounds    = roundf(low_bound  * 10) / 10.0;
    float upperBounds    = roundf(up_bound   * 10) / 10.0;
    
    [[self delegate] lowerBounds:lowerBounds upperBounds:upperBounds forType:8 withEstimate:estimate withIncrement:0.25f];
}

-(void)shirtFormula:(TRMFormulaData *)data
{
    
    float estimate       =   7.90294 + 0.05407 * data.height + 0.02436 * data.weight + 0.14752 *data.shoulders + 0.31163 * data.rightArm;
    
    float height     =  powf(data.height - 70.05641,2) / 11749.69;
    float weight     =  powf(data.weight - 179.9691,2) / 533049.4;
    float shoulder   =  powf(data.shoulders - 18.97991,2) / 1193.114;
    float rightArm   =  powf(data.rightArm - 35.40842,2) / 1878.137;
    
    float std_error_part =  1.465041 * (1 + 1/647 + height + weight + shoulder + rightArm);
    
    float std_error      = powf(std_error_part, 0.5f);
    
    float up_bound       = estimate + SHIRT_T_DISTRIBUTION_RED    * std_error;
    float low_bound      = estimate - SHIRT_T_DISTRIBUTION_YELLOW * std_error;
    
    float lowerBounds    = roundf(low_bound  * 10) / 10.0;
    float upperBounds    = roundf(up_bound   * 10) / 10.0;
    
    [[self delegate] lowerBounds:lowerBounds upperBounds:upperBounds forType:9 withEstimate:estimate withIncrement:0.50f];
}

-(void)bicepFormula:(TRMFormulaData *)data
{
    
    float estimate       =   -2.38670 + 0.21307 * data.neck + 0.14605 * data.chest + 0.10042 * data.shirtLength + 0.34909 * data.leftWrist;    
    
    float neck       =  powf(data.neck - 16.07457,2) / 748.5893;
    float chest      =  powf(data.chest - 40.99923,2) / 8457.25;
    float seat       =  powf(data.seat - 41.33308,2) / 6503.472;
    float leftWrist  =  powf(data.leftWrist - 6.981066,2) / 118.5806;
    
    float std_error_part =  0.7652354 * ( 1 + 1/647 + neck + chest + seat + leftWrist);
    
    float std_error      = powf(std_error_part, 0.5f);
    
    float up_bound       = estimate + BICEP_T_DISTRIBUTION_RED    * std_error;
    float low_bound      = estimate - BICEP_T_DISTRIBUTION_YELLOW    * std_error;
    
    float lowerBounds    = roundf(low_bound  * 10) / 10.0;
    float upperBounds    = roundf(up_bound   * 10) / 10.0;
    
    [[self delegate] lowerBounds:lowerBounds upperBounds:upperBounds forType:10 withEstimate:estimate withIncrement:0.25f];
}
@end
