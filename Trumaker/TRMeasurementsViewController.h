//
//  TRMeasurementsViewController.h
//  Trumaker
//
//  Created by  7/18/13.
//  Copyright (c) 2013 The Code Boutique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRMMeasurementView.h"
#import "TRMFormulaData.h"
@interface TRMeasurementsViewController : UIViewController <UIScrollViewDelegate,TRMMeasurementViewDelegate>

@property (strong, nonatomic) TRMFormulaData *data;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end
