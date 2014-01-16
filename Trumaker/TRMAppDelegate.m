//
//  TRMAppDelegate.m
//  Trumaker
//
//  Created by Marin Fischer on 1/6/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMAppDelegate.h"
#import "TRMLoginDAO.h"
#import "TRMProductsDAO.h"
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
    [[self window] setTintColor:[TRMUtils colorWithHexString:@"959fa5"]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:20.0f]}];
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
        
        TRMTaskListViewController *taskListViewController = [[TRMTaskListViewController alloc] initWithNibName:@"TRMTaskListViewController" bundle:nil];
        
        if (autoLogin && username && pasword)
        {
            [[self window] setRootViewController:loadingViewController];
            
            TRMLoginDAO *loginDAO = [[TRMLoginDAO alloc] init];
            [loginDAO login:username withPassword:pasword completionHandler:^(BOOL successful, NSError *error) {
                if (!error) {
                    [self fetchProducts];
                    [[self rootViewController] setLeftDrawerViewController:taskListViewController];
                    [self setDashboardViewContorllerToCenterViewController];
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

-(void)setDashboardViewContorllerToCenterViewController {
    TRMDashboardViewController *dashboardViewController = [[TRMDashboardViewController alloc] initWithNibName:@"TRMDashboardViewController" bundle:nil];
    UINavigationController *mainNavigationController = [self getNavigationController:dashboardViewController];
    [dashboardViewController setEdgesForExtendedLayout:UIRectEdgeNone];
    [[dashboardViewController navigationItem] setTitle:@"TRUMAKER"];
    [[self rootViewController] setCenterViewController:mainNavigationController];
}


-(void)setCenterViewController:(UIViewController *)viewController {
    [viewController setEdgesForExtendedLayout:UIRectEdgeNone];
    [viewController setTitle:@"TRUMAKER"];
    [[viewController navigationItem] setLeftBarButtonItem:[self menuBarButton]];
    [rootViewController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [rootViewController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [[self rootViewController] setCenterViewController:[self getNavigationController:viewController]];
}

-(UINavigationController *)getNavigationController:(UIViewController *)viewController {
    UINavigationController *mainNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    return mainNavigationController;
}

-(void)menuButtonTapped:(id)sender {
    [[self rootViewController] openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)hideMenuButton {
    
//    [[dashboardViewController navigationItem] setLeftBarButtonItem :[self menuBarButton]];
}

-(void)showMenuButton {
    
//    [[dashboardViewController navigationItem] setLeftBarButtonItem :[self menuBarButton]];
}

-(void)allowOpenDrawer {
    [rootViewController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
}


-(void)fetchProducts {
    //we should fetch products
    TRMProductsDAO *dao = [[TRMProductsDAO alloc] init];
    [dao fetchProducts];
    [dao fetchConfigurations];
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
