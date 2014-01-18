//
//  TRMCustomersViewController.h
//  Trumaker
//
//  Created by Kyle Carriedo on 1/16/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRMCustomersViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *customersDataSource;
@end
