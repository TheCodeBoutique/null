
//  Copyright (c) 2013 thecodeboutique. All rights reserved.
//

#import "TRMUtils.h"

@implementation TRMUtils

+ (UIColor*)colorWithHexString:(NSString*)hex
{
    //added in removal of # if passed into the string
    hex = [hex stringByReplacingOccurrencesOfString:@"#" withString:@"" options:0 range:NSMakeRange(0, [hex length])];
    
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
+ (NSString*) getRandomStringWithPrefix:(NSString*)prefix withNumberOfChar:(NSInteger)length {
    NSString *alphabet  = @"1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    NSMutableString *s = [NSMutableString stringWithCapacity:length];
    for (NSUInteger i = 0U; i < length; i++) {
        u_int32_t r = arc4random() % [alphabet length];
        unichar c = [alphabet characterAtIndex:r];
        [s appendFormat:@"%@%C",prefix, c];
    }
    return s;
}

+ (CGFloat)halfPixel
{
    return 1/[[UIScreen mainScreen] scale];
}

+ (void)drawBorderForView:(UIView *)view isBottomBorder:(BOOL)bottomBorder {
    CALayer *border = [CALayer layer];
    CGFloat borderPosition;
    CGFloat pixelHeight = [TRMUtils halfPixel];
    if (bottomBorder) {
        borderPosition = CGRectGetHeight([view frame]) - pixelHeight;
    } else {
        borderPosition = pixelHeight;
    }
    
    border.frame = CGRectMake(0,CGRectGetHeight([view frame]) - pixelHeight,
                              CGRectGetWidth([view frame]),
                              pixelHeight);
    
    border.backgroundColor = [UIColor lightGrayColor].CGColor;
    [view.layer addSublayer: border];
}


+ (UIImage*) maskImage:(UIImage *) image withMask:(UIImage *) mask
{
    CGImageRef imageReference = image.CGImage;
    CGImageRef maskReference = mask.CGImage;
    
    CGImageRef imageMask = CGImageMaskCreate(CGImageGetWidth(maskReference),
                                             CGImageGetHeight(maskReference),
                                             CGImageGetBitsPerComponent(maskReference),
                                             CGImageGetBitsPerPixel(maskReference),
                                             CGImageGetBytesPerRow(maskReference),
                                             CGImageGetDataProvider(maskReference),
                                             NULL, // Decode is null
                                             YES // Should interpolate
                                             );
    
    
    
    CGImageRef maskedReference = CGImageCreateWithMask(imageReference, imageMask);
    CGImageRelease(imageMask);
    
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedReference];
    CGImageRelease(maskedReference);
    
    
    return maskedImage;
}
@end
