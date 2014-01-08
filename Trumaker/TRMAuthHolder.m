//
//  TRMAuthHolder.m
//  Trumaker
//
//  Created on 9/14/13.
//  Copyright (c) 2013 The Code Boutique. All rights reserved.
//

#import "TRMAuthHolder.h"
#import "TRMAppDelegate.h"

@implementation TRMAuthHolder
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (id)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

-(void)logout
{
    [self setAuthString:nil];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"auto_login"];
//    TRMAppDelegate *appDel = (TRMAppDelegate *)[[UIApplication sharedApplication] delegate];
//    [appDel showLoginView];
}

@end
