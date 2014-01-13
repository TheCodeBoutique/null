//
//  Copyright (c) 2013 thecodeboutique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRMUtils : NSObject

+ (UIColor*)colorWithHexString:(NSString*)hex;
+ (NSString*) getRandomStringWithPrefix:(NSString*)prefix withNumberOfChar:(NSInteger)length;
+ (CGFloat)halfPixel;
+ (void)drawBorderForView:(UIView *)view isBottomBorder:(BOOL)bottomBorders;
+ (UIImage*) maskImage:(UIImage *) image withMask:(UIImage *) mask;
@end
