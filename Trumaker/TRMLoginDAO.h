//
//  TRMLoginDAO.h
//  Trumaker
//
//  Created by Marin Fischer on 1/6/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRMLoginDAO : NSObject
- (void)login:(NSString *)username withPassword:(NSString *)password completionHandler:(void(^)(BOOL successful, NSError *))handler;

@end
