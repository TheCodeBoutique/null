//
//  NSDictionary+dictionaryWithObject.m
//  Trumaker
//
//  Created on 9/14/13.
//  Copyright (c) 2013 The Code Boutique. All rights reserved.
//

#import "NSDictionary+dictionaryWithObject.h"

@implementation NSDictionary (dictionaryWithObject)

+(NSDictionary *) dictionaryWithPropertiesOfObject:(id)obj
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];

        if ([obj valueForKey:key] == nil) {
            NSLog(@"Cound not find value for Key %@",key);
            NSLog(@"removing key %@ and its value",key);
        } else {
            [dict setObject:[obj valueForKey:key] forKey:key];
        }
    }
    
    free(properties);
    
    return [NSDictionary dictionaryWithDictionary:dict];
}

@end
