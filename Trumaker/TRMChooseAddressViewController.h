//
//  TRMChooseAddressViewController.h
//  Trumaker
//
//  Created by Marin Fischer on 1/19/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIActionSheet+Blocks.h"
#import "RIButtonItem.h"
#import "TRMAddressModel.h"
@protocol TRMChooseAddressDelegate;

@interface TRMChooseAddressViewController : UIViewController
@property (weak, nonatomic) id <TRMChooseAddressDelegate> delegate;
@property (strong, nonatomic) NSString *controllerTitle;
@property (strong, nonatomic) IBOutlet UILabel *headerTitle;
@property (assign, nonatomic) BOOL isShipping;
- (IBAction)addAddressButton:(id)sender;
@end

@protocol TRMChooseAddressDelegate <NSObject>
-(void)didSelectAddress:(TRMAddressModel *)address state:(BOOL)isShipping;
@end