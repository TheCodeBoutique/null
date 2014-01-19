//
//  TRMMeasurementPhotosViewController.h
//  Trumaker
//
//  Created by Kyle Carriedo on 1/18/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRMMeasurementPhotosViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *mainImage;
@property (strong, nonatomic) IBOutlet UIScrollView *imagesScrollView;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIButton *cameraButton;
@property (strong, nonatomic) IBOutlet UILabel *PhotoLabel;
@property (strong, nonatomic) UIImagePickerController *picker;

- (IBAction)reatakeTapped:(id)sender;
- (IBAction)deleteTapped:(id)sender;
@end
