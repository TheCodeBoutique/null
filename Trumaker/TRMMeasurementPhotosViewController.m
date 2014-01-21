//
//  TRMMeasurementPhotosViewController.m
//  Trumaker
//
//  Created by Kyle Carriedo on 1/18/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMMeasurementPhotosViewController.h"
#import "TRMeasurementsViewController.h"

#import "TRMPhotoSelectionView.h"
#import "UIAlertView+Blocks.h"
#import "RIButtonItem.h"
#import "TRMUtils.h"
#import "TRMAppDelegate.h"

@interface TRMMeasurementPhotosViewController ()
{
    UIActivityIndicatorView *spinner;
    UIImageView *overlayImageView;
    NSMutableArray *imagesArray; //photos taken
    TRMPhotoSelectionView *selectedPhoto;
}

@property (nonatomic, strong) UIImage *defaultPhoto;

@end

@implementation TRMMeasurementPhotosViewController
@synthesize picker;
@synthesize defaultPhoto;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [[self navigationItem] setTitle:@"Order"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[self navigationItem] setTitle:@""];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    defaultPhoto = [UIImage imageNamed:@"default_placeholder_photo_icon"];
    
    [_mainImage setImage:[UIImage imageNamed:@"default_photo_viewer_icon"]];
    [_mainImage setContentMode:UIViewContentModeScaleToFill];
    [_mainImage setClipsToBounds:YES];

    
    [_cameraButton setBackgroundColor:[UIColor clearColor]];
    [[_cameraButton layer] setOpacity:0.7];
    [[_cameraButton layer] setCornerRadius:20.0f];
    
    [_deleteButton setBackgroundColor:[UIColor clearColor]];
    [[_deleteButton layer] setOpacity:0.7];
    [[_deleteButton layer] setCornerRadius:20.0f];
    
    [[_greyBarView layer] setCornerRadius:5.0f];
    
    CGRect mainImageFrame = [_mainImage frame];
    CGRect greyImageFrame = [_greyBarView frame];
    
    greyImageFrame.size.width = CGRectGetWidth(mainImageFrame);
    
    [_greyBarView setFrame:greyImageFrame];
    
    NSArray *typesArray = @[@"Front", @"Side",@"Back"];
    imagesArray = [[NSMutableArray alloc] initWithObjects:defaultPhoto, defaultPhoto,defaultPhoto, nil];
    
    
    for (int i = 0; i < 3; i++) {
        TRMPhotoSelectionView *photoSelectionView = [[TRMPhotoSelectionView alloc] initWithFrame:CGRectMake(i * 110.0f, 5.0f, 160.0f, 109.0f)];
        [photoSelectionView setUserInteractionEnabled:YES];
        [[photoSelectionView photoType] setText:[typesArray objectAtIndex:i]];
        [[photoSelectionView photoImage] setImage:[imagesArray objectAtIndex:i]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapImage:)];
        [photoSelectionView addGestureRecognizer:tap];
        [_imagesScrollView addSubview:photoSelectionView];
    }
    [_imagesScrollView setContentSize:CGSizeMake(120.0f * 3, 109)];
}


-(void)didTapImage:(id)sender
{
    TRMPhotoSelectionView *viewTapped = (TRMPhotoSelectionView *)[sender view];

    if ([[viewTapped photoImage] image] == defaultPhoto)
    {
        [_PhotoLabel setText:[[viewTapped photoType] text]];
        [_mainImage setImage:[UIImage imageNamed:@"default_photo_viewer_icon"]];
        selectedPhoto = viewTapped;

    } else {
        [_PhotoLabel setText:[[viewTapped photoType] text]];
        [_mainImage setImage:[[viewTapped photoImage] image]];
        selectedPhoto = viewTapped;

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)reatakeTapped:(id)sender
{
    [self launchImagePicker];
}

- (IBAction)deleteTapped:(id)sender
{
    [[[UIAlertView alloc] initWithTitle:@"Delete Photo" message:@"This will permanently remove the photo are you sure you want to delete." cancelButtonItem:[RIButtonItem itemWithLabel:@"No" action:^{
        
    }] otherButtonItems:[RIButtonItem itemWithLabel:@"Delete" action:^{
        //remove photo from server
        [[selectedPhoto photoImage] setImage:[UIImage imageNamed:@"default_placeholder_photo_icon"]];
        [[self mainImage] setImage:[UIImage imageNamed:@"default_placeholder_photo_icon"]];
        
    }], nil] show];
}

#pragma mark photo
-(void)launchImagePicker
{
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
        [picker setDelegate:self];
        
        
        overlayImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 55.0f, CGRectGetWidth(app), CGRectGetHeight(app) - 130.0f)];
        [overlayImageView setContentMode:UIViewContentModeScaleAspectFit];
        [overlayImageView setImage:[UIImage imageNamed:@"front_facing"]];
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
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
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

- (IBAction)previousButtonTapped:(id)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)nextTapped:(id)sender
{
    //go on to next module 
}
@end