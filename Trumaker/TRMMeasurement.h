//
//  TRMMeasurement.h
//  Trumaker
//
//  Copyright (c) 2013 The Code Boutique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRMMeasurement : NSObject
//dont think are being used
@property (assign,nonatomic) NSInteger id;
@property (strong,nonatomic) NSString *measurement_section_id;
@property (assign,nonatomic) CGFloat value; //14.5" - measurement value

@end
