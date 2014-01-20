//
//  TRMCustomerDetailViewController.m
//  Trumaker
//
//  Created by Kyle Carriedo on 1/17/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMCustomerDetailViewController.h"
#import "TRMCustomerInformationViewController.h"
#import "TRMAppDelegate.h"
#import "TRMUtils.h"
#import "UIActionSheet+Blocks.h"
#import "RIButtonItem.h"
#import "UIAlertView+Blocks.h"

//tmp remove
#import "TRMComingSoonViewController.h"

@interface TRMCustomerDetailViewController ()
@property (nonatomic, strong) UIImagePickerController *picker;
@end
@implementation TRMCustomerDetailViewController
@synthesize customer;
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
    [self setupBorders];
    
    if (customer) {
        //we have trumaker custoner
        [_customerName setText:[customer fullName]];
        [_customerEmail setText:[customer email]];
        [_customerCity setText:[[customer primaryAddress] city]];
        [_customerType setText:@"Trumaker"];        
        NSString *confirmFit = ([[customer confirmed_fit] intValue] > 0) ? @"Yes" : @"No";
        [_confirmFit setText:confirmFit];
        
        [_totalFinishedOrders setText:[NSString stringWithFormat:@"%@",[customer finished_orders_count]]];
        [_customerCredit setText:[NSString stringWithFormat:@"$ %@",[customer store_credit]]];
    } else {        
        //we have local phone contacts
        [_customerName setText:[_phoneContact fullName]];
        [_customerType setText:@"Local"];
        [_confirmFit setText:@"No"];
        [_customerCredit setText:@"$ 0"];
    }
}

-(void)setupBorders {
    [[_imageViewWrapper layer] setBorderWidth:[TRMUtils halfPixel]];
    [[_imageViewWrapper layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    [TRMUtils drawBorderForView:_customerWrapper isBottomBorder:YES];
    
    [TRMUtils drawBorderForView:_createOrderButton isBottomBorder:YES];
    [TRMUtils drawBorderForView:_appointmentsButton isBottomBorder:YES];
    [TRMUtils drawBorderForView:_orderHistoryButton isBottomBorder:YES];
    
    [TRMUtils drawBorderForView:_callCustomerButton isBottomBorder:YES];
    [TRMUtils drawBorderForView:_measurementButton isBottomBorder:YES];
    [TRMUtils drawBorderForView:_buildPreferenceButton isBottomBorder:YES];
    
    [TRMUtils drawLeftBorder:_appointmentsButton];
    [TRMUtils drawLeftBorder:_measurementButton];
    [TRMUtils drawLeftBorder:_orderHistoryButton];
    [TRMUtils drawLeftBorder:_buildPreferenceButton];
}

- (IBAction)createOrderTapped:(id)sender {
    TRMCustomerInformationViewController *customerInformationViewController = [[TRMCustomerInformationViewController alloc] initWithNibName:@"TRMCustomerInformationViewController" bundle:nil];
    [[customerInformationViewController navigationItem] setTitle:@"TRUMAKER"];
    [customerInformationViewController setCustomer:customer];
    [customerInformationViewController setEdgesForExtendedLayout:UIRectEdgeNone];
    
    TRMAppDelegate *del = [[UIApplication sharedApplication] delegate];
    [del setCenterViewController:customerInformationViewController];
    [[del rootViewController] closeDrawerAnimated:YES completion:^(BOOL finished) {
        
    }];
}

-(IBAction)contactCustomerTapped:(id)sender {
    [RIButtonItem itemWithLabel:@"Delete" action:^{ }];
    [[[UIActionSheet alloc] initWithTitle:@"Contact Customer"
                        cancelButtonItem:[RIButtonItem itemWithLabel:@"Cancel" action:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }]
                   destructiveButtonItem:nil
                         otherButtonItems:[RIButtonItem itemWithLabel:@"Call" action:^{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",[[customer primaryPhone] number]]];
        [[UIApplication sharedApplication] openURL:url];
    }],
      [RIButtonItem itemWithLabel:@"Messsage" action:^{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",[[customer primaryPhone] number]]];
        [[UIApplication sharedApplication] openURL:url];
    }],[RIButtonItem itemWithLabel:@"Email" action:^{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@",[customer email]]];
        [[UIApplication sharedApplication] openURL:url];
    }],
      nil] showInView:self.view];
}

- (IBAction)bookAppointmentTapped:(id)sender {
    [self pushCommingSoonController];
}

- (IBAction)orderHistoryTapped:(id)sender {
    [self pushCommingSoonController];
}

- (IBAction)emailLabelTapped:(id)sender {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@",[customer email]]];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)measurementsButtonTapped:(id)sender {
    
}

- (IBAction)buildPreferenceTapped:(id)sender {
    
}

//TODO Remove
-(void)pushCommingSoonController {
    TRMComingSoonViewController *comingSoonViewController = [[TRMComingSoonViewController alloc] initWithNibName:@"TRMComingSoonViewController" bundle:nil];
    [[self navigationController] pushViewController:comingSoonViewController animated:YES];
}


#pragma mark photo
-(void)launchImagePicker {
    picker = [[UIImagePickerController alloc] init];
    
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
        [self presentViewController:picker animated:YES completion:nil];
    } else
    {
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

#pragma mark UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (editImage) {
        [_customerImageView setImage:editImage];
        [_customerImageView setClipsToBounds:YES];
        
    } else {
        [_customerImageView setImage:image];
        [_customerImageView setClipsToBounds:YES];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapCustomerImage:(id)sender {
    [self launchImagePicker];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
