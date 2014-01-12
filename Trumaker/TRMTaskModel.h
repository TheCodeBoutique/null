//
//  TRMTaskModel.h
//  Trumaker
//
//  Created by Kyle Carriedo on 1/11/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRMTaskModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL isFinished;
@property (nonatomic, assign) BOOL isDisabled;
@end
