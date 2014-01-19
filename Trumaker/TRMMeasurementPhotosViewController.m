//
//  TRMMeasurementPhotosViewController.m
//  Trumaker
//
//  Created by Kyle Carriedo on 1/18/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMMeasurementPhotosViewController.h"
#import "TRMPhotoSelectionView.h"
#import "UIAlertView+Blocks.h"
#import "RIButtonItem.h"
@interface TRMMeasurementPhotosViewController () {
    UIActivityIndicatorView *spinner;
    UIImageView *overlayImageView;
    NSMutableArray *imagesArray; //photos taken
    TRMPhotoSelectionView *selectedPhoto;
}
@end

@implementation TRMMeasurementPhotosViewController
@synthesize picker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_mainImage setImage:[UIImage imageNamed:@"photo_placeholder"]];
    
    [_cameraButton setBackgroundColor:[UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.3]];
    [[_cameraButton layer] setOpacity:0.7];
    [[_cameraButton layer] setCornerRadius:20.0f];
    
    [_deleteButton setBackgroundColor:[UIColor colorWithRed:219.0f/255.0f green:51.0f/255.0f blue:0.0f alpha:0.5]];
    [[_deleteButton layer] setOpacity:0.7];
    [[_deleteButton layer] setCornerRadius:20.0f];
    
    
    NSArray *typesArray = @[@"Front", @"Side",@"Back"];
    imagesArray = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"photo_placeholder"],[UIImage imageNamed:@"photo_placeholder"],[UIImage imageNamed:@"photo_placeholder"], nil];
    
    
    for (int i = 0; i < 3; i++) {
        TRMPhotoSelectionView *photoSelectionView = [[TRMPhotoSelectionView alloc] initWithFrame:CGRectMake(i * 170.0f, 0.0f, 115.0f, 106.0f)];
        [photoSelectionView setUserInteractionEnabled:YES];
        [[photoSelectionView photoType] setText:[typesArray objectAtIndex:i]];
        [[photoSelectionView photoImage] setImage:[imagesArray objectAtIndex:i]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapImage:)];
        [photoSelectionView addGestureRecognizer:tap];
        [_imagesScrollView addSubview:photoSelectionView];
    }
    [_imagesScrollView setContentSize:CGSizeMake(170.0f * 3, 106.0f)];
}


-(void)didTapImage:(id)sender {
    TRMPhotoSelectionView *viewTapped = (TRMPhotoSelectionView *)[sender view];
    [_PhotoLabel setText:[[viewTapped photoType] text]];
    [_mainImage setImage:[[viewTapped photoImage] image]];
    selectedPhoto = viewTapped;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)reatakeTapped:(id)sender {
    [self launchImagePicker];
}

- (IBAction)deleteTapped:(id)sender {
    [[[UIAlertView alloc] initWithTitle:@"Delete Photo" message:@"This will permanently remove the photo are you sure you want to delete." cancelButtonItem:[RIButtonItem itemWithLabel:@"No" action:^{
        
    }] otherButtonItems:[RIButtonItem itemWithLabel:@"Delete" action:^{
        //remove photo from server
        [[selectedPhoto photoImage] setImage:[UIImage imageNamed:@"photo_placeholder"]];
        [[self mainImage] setImage:[UIImage imageNamed:@"photo_placeholder"]];
        
    }], nil] show];
}

#pragma mark photo
-(void)launchImagePicker{
    CGRect app = [[[UIApplication sharedApplication] keyWindow] frame];
    
    picker = [[UIImagePickerController alloc] init];
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setFrame:CGRectMake(CGRectGetMidX(app), CGRectGetMidY(app), spinner.frame.size.width, spinner.frame.size.height)];
    [spinner setHidesWhenStopped:YES];
    [spinner stopAnimating];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        picker.showsCameraControls = YES;
        picker.navigationBarHidden = YES;
        picker.toolbarHidden = YES;
        picker.wantsFullScreenLayout = YES;
        picker.allowsEditing = YES;
        [picker setDelegate:self];
        
        
        overlayImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 55.0f, CGRectGetWidth(app), CGRectGetHeight(app) - 130.0f)];
        [overlayImageView setContentMode:UIViewContentModeScaleAspectFit];
        [overlayImageView setImage:[UIImage imageNamed:@"front_facing.png"]];
        [[picker view] addSubview:overlayImageView];
        [[picker view] addSubview:spinner];
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

#pragma mark UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (editImage) {
        [[selectedPhoto photoImage] setImage:editImage];
        [[self mainImage] setImage:editImage];
    } else
    {
        [[selectedPhoto photoImage] setImage:image];
        [[self mainImage] setImage:image];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end