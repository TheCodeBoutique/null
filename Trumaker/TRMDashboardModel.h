//
//  TRMDashboardModel.h
//  Trumaker
//
//  Created by Marin Fischer on 1/7/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRMDashboardModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSNumber *unreadCount;
@end
