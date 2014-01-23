//
//  TRMProfileImageView.m
//  Trumaker
//
//  Created by Kyle Carriedo on 1/22/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMProfileImageView.h"

@implementation TRMProfileImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* color = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0];
    
    //// Frames
    CGRect frame = CGRectMake(1, 1, 78, 93);
    
    
    //// Image Declarations
    UIImage* walter = [self scaleToSize:frame.size];
    
    
    //// Rounded Rectangle Drawing
    CGRect roundedRectangleRect = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), 79, 93);
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: roundedRectangleRect byRoundingCorners: UIRectCornerTopRight | UIRectCornerBottomLeft cornerRadii: CGSizeMake(22, 22)];
    [roundedRectanglePath closePath];
    CGContextSaveGState(context);
    [roundedRectanglePath addClip];
    [walter drawInRect: CGRectMake(floor(CGRectGetMinX(roundedRectangleRect) + 0.5), floor(CGRectGetMinY(roundedRectangleRect) + 0.5), walter.size.width, walter.size.height)];
    CGContextRestoreGState(context);
    [color setStroke];
    roundedRectanglePath.lineWidth = 3;
    [roundedRectanglePath stroke];
    
}

- (UIImage*)scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), [self image].CGImage);
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

@end
