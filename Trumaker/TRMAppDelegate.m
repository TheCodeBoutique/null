//
//  TRMAppDelegate.m
//  Trumaker
//
//  Created by Marin Fischer on 1/6/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMAppDelegate.h"
#import "TRMLoginDAO.h"
#import "TRMUtils.h"

#import "TRMLoginViewController.h"
#import "TRMLoadingViewController.h"
#import "TRMDashboardViewController.h"
#import "TRMTaskListViewController.h"

@implementation TRMAppDelegate
@synthesize rootViewController;
@synthesize menuBarButton;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[self window] makeKeyAndVisible];
    [self loadDeviceControllers];
    return YES;
}

-(void)loadDeviceControllers
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        //iphone
        BOOL autoLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"auto_login"];
        NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"user_name"];
        NSString *pasword = [[NSUserDefaults standardUserDefaults] stringForKey:@"user_password"];
        
        TRMLoginViewController *loginViewController = [[TRMLoginViewController alloc] initWithNibName:@"TRMLoginViewController" bundle:nil];
        
        TRMLoadingViewController *loadingViewController = [[TRMLoadingViewController alloc] initWithNibName:@"TRMLoadingViewController" bundle:nil];

        TRMDashboardViewController *dashboardViewController = [[TRMDashboardViewController alloc] initWithNibName:@"TRMDashboardViewController" bundle:nil];
        
        TRMTaskListViewController *taskListViewController = [[TRMTaskListViewController alloc] initWithNibName:@"TRMTaskListViewController" bundle:nil];
        
        if (autoLogin && username && pasword)
        {
            [[self window] setRootViewController:loadingViewController];
            
            TRMLoginDAO *loginDAO = [[TRMLoginDAO alloc] init];
            [loginDAO login:username withPassword:pasword completionHandler:^(BOOL successful, NSError *error) {
                if (!error) {
                    UINavigationController *mainNavigationController = [[UINavigationController alloc] initWithRootViewController:dashboardViewController];
                   
                    [dashboardViewController setEdgesForExtendedLayout:UIRectEdgeNone];
                    
                    [[dashboardViewController navigationItem] setLeftBarButtonItem :[self menuBarButton]];
                    
                    [[self rootViewController] setLeftDrawerViewController:taskListViewController];
                    [[self rootViewController] setCenterViewController:mainNavigationController];
                    [[self window] setRootViewController:[self rootViewController]];
                }
            }];
        } else {
            [[self window] setRootViewController:loginViewController];
        }
    }
    else {
        //ipad
//        self.viewController = [[TRMViewController alloc] initWithNibName:@"TRMViewController_iPad" bundle:nil];
    }
}



-(MMDrawerController *)rootViewController {
    if (!rootViewController) {
        rootViewController = [[MMDrawerController alloc] init];
        [rootViewController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        [rootViewController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
        return rootViewController;
    }
    return rootViewController;
}

-(UIBarButtonItem *)menuBarButton {
    if (!menuBarButton) {
        menuBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"hamburger"] style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonTapped:)];
        return menuBarButton;
    }
    return menuBarButton;
}

-(void)menuButtonTapped:(id)sender {
    [[self rootViewController] openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)hideMenuButton {
    
}

-(void)showMenuButton {
    
}
							
- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}
@end
