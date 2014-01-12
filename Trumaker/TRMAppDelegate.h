//
//  TRMAppDelegate.h
//  Trumaker
//
//  Created by Marin Fischer on 1/6/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDrawerController.h"
@interface TRMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MMDrawerController *rootViewController;
@property (strong, nonatomic) UIBarButtonItem *menuBarButton;

-(void)hideMenuButton;
-(void)showMenuButton;
@end
