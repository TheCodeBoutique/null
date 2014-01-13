//
//  TRMCustomerCell.h
//  Trumaker
//
//  Created by Kyle Carriedo on 1/12/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRMIndentTextField.h"
#import "TRMCustomerTableViewModel.h"
@interface TRMCustomerCell : UITableViewCell
@property (strong, nonatomic) IBOutlet TRMIndentTextField *textField;
@property (strong, nonatomic) TRMCustomerTableViewModel *customerTableViewModel;
@end
