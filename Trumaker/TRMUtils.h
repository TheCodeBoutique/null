//
//  Copyright (c) 2013 thecodeboutique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRMUtils : NSObject

+ (UIColor*)colorWithHexString:(NSString*)hex;
+ (NSString*) getRandomStringWithPrefix:(NSString*)prefix withNumberOfChar:(NSInteger)length;
@end
