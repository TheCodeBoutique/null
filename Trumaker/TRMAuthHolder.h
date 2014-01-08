//
//  TRMAuthHolder.h
//  Trumaker
//
//  Created on 9/14/13.
//  Copyright (c) 2013 The Code Boutique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRMAuthHolder : NSObject
@property (nonatomic, strong) NSString *authString;
+ (id)sharedInstance;

-(void)logout;
@end
