//
//  NSDictionary+dictionaryWithObject.h
//  Trumaker
//
//  Created on 9/14/13.
//  Copyright (c) 2013 The Code Boutique. All rights reserved.
//
#import <objc/runtime.h>
#import <Foundation/Foundation.h>

@interface NSDictionary (dictionaryWithObject)
+(NSDictionary *) dictionaryWithPropertiesOfObject:(id)obj;
@end
