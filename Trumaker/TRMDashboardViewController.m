//
//  TRMDashboardViewController.m
//  Trumaker
//
//  Created by Marin Fischer on 1/7/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//
#import "TRMDashboardModel.h"
#import "TRMDashboardViewController.h"
#import "TRMDashboardTableViewCell.h"
#import "TRMOrderCustomerTypeViewController.h"
#import "TRMCustomersViewController.h"
#import "TRMComingSoonViewController.h"


#import "TRMOutfitterDAO.h"
#import "TRMOutfitterModel.h"
#import "TRMCoreApi.h"
#import "TRMUtils.h"
#import "UIActionSheet+Blocks.h"
#import "UIAlertView+Blocks.h"
#import "RIButtonItem.h"
#import "MBProgressHUD.h"
#import "TRMOutfitterModel.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"

@interface TRMDashboardViewController ()
@property (nonatomic, strong) NSMutableArray *dashboardData;
@property (nonatomic, strong) TRMOutfitterModel *outfitter;
@property (nonatomic, assign) BOOL customersUpdated;
@end

@implementation TRMDashboardViewController
@synthesize dashboardData;
@synthesize customersUpdated;
@synthesize picker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        customersUpdated = NO;
    }
    return self;
}

-(void)udpateImageView {
    [[self outfitterImageView] setImage:[_outfitter outfitterImage]];
    [[self outfitterImageView] setNeedsDisplay];
}

-(void)setupTableViewData
{
    dashboardData = [[NSMutableArray alloc] initWithCapacity:5];
    TRMDashboardModel *orderModel = [[TRMDashboardModel alloc] init];
    [orderModel setTitle:NSLocalizedString(@"Order", @"Order")];
    
    TRMDashboardModel *leadsModel = [[TRMDashboardModel alloc] init];
    [leadsModel setTitle:NSLocalizedString(@"Leads", @"Leads")];
    
    TRMDashboardModel *trumakerNewsModel = [[TRMDashboardModel alloc] init];
    [trumakerNewsModel setTitle:NSLocalizedString(@"Trumaker News", @"Trumaker News")];
    
    TRMDashboardModel *contactsModel = [[TRMDashboardModel alloc] init];
    [contactsModel setTitle:NSLocalizedString(@"Contacts", @"Contacts")];
    
    TRMDashboardModel *catalogueModel = [[TRMDashboardModel alloc] init];
    [catalogueModel setTitle:NSLocalizedString(@"Catalogue", @"Catalogue")];
    
    [dashboardData addObject:orderModel];
    [dashboardData addObject:leadsModel];
    [dashboardData addObject:trumakerNewsModel];
    [dashboardData addObject:contactsModel];
    [dashboardData addObject:catalogueModel];
    
    
    customersUpdated = [[TRMCoreApi sharedInstance] existingCustomersLoaded];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _outfitter = [[TRMCoreApi sharedInstance] outfitter];
    [_outfitterName setText:[_outfitter fullName]];
    [_outfitterLocation setText:[_outfitter city]];
    [self udpateImageView];
    [self setupTableViewData];
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dashboardData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DashboardTableCell";
    TRMDashboardTableViewCell *cell = (TRMDashboardTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TRMDashboardTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    TRMDashboardModel *model = [dashboardData objectAtIndex:[indexPath row]];
    [[cell cellTitle] setText:[model title]];
     ([indexPath row] == [dashboardData count] - 1) ? [cell setIsLastCell:YES] :[cell setIsLastCell:NO];
    
    //we need to make contacts cell deativated till notifcation registers and lets us know contacts have been updated
    if ([[model title] isEqualToString:@"Contacts"] && !customersUpdated) {
        [[cell cellTitle] setText:@"Loading Contacts..."];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setIsDisabled:YES];
    } else {
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        [cell setIsDisabled:NO];
    }
    
    return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //dont allow selection for contacts if its not updated
    if ([indexPath row] == 3 && !customersUpdated) {
        return;
    }
    
    if ([indexPath row] == 0) { 
        //order selected
        TRMOrderCustomerTypeViewController *orderCustomerTypeViewController = [[TRMOrderCustomerTypeViewController alloc] initWithNibName:@"TRMOrderCustomerTypeViewController" bundle:nil];
        [[orderCustomerTypeViewController navigationItem] setTitle:@"TRUMAKER"];
        [[[orderCustomerTypeViewController navigationItem] backBarButtonItem] setTitle:@"Back"];
        [orderCustomerTypeViewController setEdgesForExtendedLayout:UIRectEdgeNone];
        [[self navigationController] pushViewController:orderCustomerTypeViewController animated:YES];
    }
    
    if ([indexPath row] == 1) {
        TRMComingSoonViewController *comingSoonViewController = [[TRMComingSoonViewController alloc] initWithNibName:@"TRMComingSoonViewController" bundle:nil];
        [[comingSoonViewController navigationItem] setTitle:@"TRUMAKER"];
        [[[comingSoonViewController navigationItem] backBarButtonItem] setTitle:@"Back"];
        [comingSoonViewController setEdgesForExtendedLayout:UIRectEdgeNone];
        [[self navigationController] pushViewController:comingSoonViewController animated:YES];
    }
    
    if ([indexPath row] == 2) {
        TRMComingSoonViewController *comingSoonViewController = [[TRMComingSoonViewController alloc] initWithNibName:@"TRMComingSoonViewController" bundle:nil];
        [[comingSoonViewController navigationItem] setTitle:@"TRUMAKER"];
        [[[comingSoonViewController navigationItem] backBarButtonItem] setTitle:@"Back"];
        [comingSoonViewController setEdgesForExtendedLayout:UIRectEdgeNone];
        [[self navigationController] pushViewController:comingSoonViewController animated:YES];
    }
    
    if ([indexPath row] == 3) {
        TRMCustomersViewController *customersViewController = [[TRMCustomersViewController alloc] initWithNibName:@"TRMCustomersViewController" bundle:nil];
        [customersViewController setEdgesForExtendedLayout:UIRectEdgeNone];
        [[customersViewController navigationItem] setTitle:@"Customers"];
        [[self navigationController] pushViewController:customersViewController animated:YES];
    }
    
    if ([indexPath row] == 4) {
        TRMComingSoonViewController *comingSoonViewController = [[TRMComingSoonViewController alloc] initWithNibName:@"TRMComingSoonViewController" bundle:nil];
        [[comingSoonViewController navigationItem] setTitle:@"TRUMAKER"];
        [[[comingSoonViewController navigationItem] backBarButtonItem] setTitle:@"Back"];
        [comingSoonViewController setEdgesForExtendedLayout:UIRectEdgeNone];
        [[self navigationController] pushViewController:comingSoonViewController animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[self navigationItem] setTitle:@"Back"];

    //notification for clients update
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:@"clientsUpdateNotification"
     object:nil
     ];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self navigationItem] setTitle:@"TRUMAKER"];
    [[NSNotificationCenter defaultCenter]
     
     addObserver:self
     selector:@selector(updateClients:)
     name:@"clientsUpdateNotification"
     object:nil ];
}

-(void)updateClients:(NSNotification *)notification {
    customersUpdated = [[TRMCoreApi sharedInstance] existingCustomersLoaded];
    [[self tableView] reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)didTapOnProfileImage:(id)sender {
    RIButtonItem *cancelButton =  [RIButtonItem itemWithLabel:@"Cancel" action:^{
            [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    RIButtonItem *libraryButton = [RIButtonItem itemWithLabel:@"Photo Library" action:^{
        [self pickPhotoFromLibrary];
    }];
    
    RIButtonItem *cameraButton = [RIButtonItem itemWithLabel:@"Camera" action:^{
        [self takePhoto];
    }];
    
    [[[UIActionSheet alloc] initWithTitle:@"Photo Options" cancelButtonItem:cancelButton destructiveButtonItem:nil otherButtonItems:libraryButton,cameraButton, nil] showInView:self.view];
}
#pragma mark photo
-(void)pickPhotoFromLibrary {
    picker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        picker.allowsEditing = YES;
        [picker setDelegate:self];
        [self presentViewController:picker animated:YES completion:nil];
    }
}
-(void)takePhoto{
    picker = [[UIImagePickerController alloc] init];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        picker.showsCameraControls = YES;
        picker.navigationBarHidden = YES;
        picker.toolbarHidden = YES;
        picker.wantsFullScreenLayout = YES;
        picker.allowsEditing = YES;
        [picker setDelegate:self];
        [self presentViewController:picker animated:YES completion:nil];
        
    }
}

#pragma mark UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (editImage) {
        [self uploadImageForOutfitter:editImage];
    } else {
        [self uploadImageForOutfitter:image];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)uploadImageForOutfitter:(UIImage *)photo {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[[[UIApplication sharedApplication] keyWindow] rootViewController] view] animated:YES];
    [hud setMode:MBProgressHUDModeIndeterminate];
    [hud setLabelText:NSLocalizedString(@"Processing...", @"Processing...")];
    [TRMOutfitterDAO uploadPhotoForOutfitter:[[TRMCoreApi sharedInstance] outfitter] withPhoto:photo completionHandler:^(TRMOutfitterModel *outfitter, NSError *error) {
        if (!error) {
            [hud setMode:MBProgressHUDModeDeterminate];
            [hud setLabelText:NSLocalizedString(@"Uploading photo...", @"Uploading photo...")];
            [[SDWebImageDownloader  sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[outfitter picture]] options:SDWebImageDownloaderProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                float percentage = (float) receivedSize /  (float)expectedSize;
                 hud.progress = percentage;
            } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                if (!error) {
                    [outfitter setOutfitterImage:image];
                    [self setOutfitter:outfitter];
                    [self udpateImageView];
                    [hud hide:YES];
                }
            }];
        } else {
            [hud hide:YES];
            [[[UIAlertView alloc] initWithTitle:@"Upload Error" message:@"There was an error while trying to upload your image." cancelButtonItem:[RIButtonItem itemWithLabel:@"Ok"] otherButtonItems:nil, nil] show];
        }
    }];
}

@end
