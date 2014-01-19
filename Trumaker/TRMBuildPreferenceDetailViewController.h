//
//  TRMBuildPreferenceDetailViewController.h
//  Trumaker
//
//  Created by Marin Fischer on 1/15/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TRMBuildPreferenceDetailDelegate;

@interface TRMBuildPreferenceDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *selectedConfigurationName; //use to pass cell title between viewcontrollers
@property (nonatomic, weak) id <TRMBuildPreferenceDetailDelegate> delgate;

//add index path to set
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@end

@protocol TRMBuildPreferenceDetailDelegate <NSObject>

- (void)didSelectConfiguration:(NSString *)selectedConfiguration withImage:(UIImage *)selectedImage;

@end