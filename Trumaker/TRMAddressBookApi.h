//
//  TRMAddressBookApi.h
//  Trumaker
//
//  Created by Kyle Carriedo on 1/16/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRMAddressBookApi : NSObject
- (void)requestAccessForAddressBook;

+ (TRMAddressBookApi *)sharedInstance;
@end
