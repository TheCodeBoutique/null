//
//  TRMCustomerInformationViewController.m
//  Trumaker
//
//  Created by Kyle Carriedo on 1/11/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMCustomerInformationViewController.h"
#import "TRMProductSelectionViewController.h"

#import "NSObject+JTObjectMapping.h"

#import "TRMCustomerCell.h"
#import "TRMCustomerDAO.h"
#import "MBProgressHUD.h"
#import "TRMUtils.h"

#import "TRMCustomerTableViewModel.h"
#import "TRMAddressModel.h"
#import "TRMPhoneModel.h"

@interface TRMCustomerInformationViewController ()
@property (nonatomic, assign) CGSize scrollViewContentSize;
@property (nonatomic, strong) TRMIndentTextField *indentTextField;
@property (nonatomic, strong) UIBarButtonItem *nextButton;
@property (nonatomic, strong) UIBarButtonItem *previousButton;
@property (nonatomic, strong) UIBarButtonItem *nextBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *backBarButton;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation TRMCustomerInformationViewController
@synthesize nextBarButtonItem;
@synthesize scrollView;
@synthesize hud;
@synthesize indentTextField;
@synthesize nextButton;
@synthesize previousButton;
@synthesize scrollViewContentSize;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [self registerKeyboardNotifications];
}

-(void)unregisterKeyboardNotifications {
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardDidShowNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardDidHideNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillHideNotification
     object:nil];
}

-(void)registerKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasHidden:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


-(void)keyboardWillHide:(NSNotification *)aNotification {
    [[self scrollView] setContentSize:CGSizeMake(scrollViewContentSize.width, scrollViewContentSize.height - 700)];
}

- (void)keyboardWasShown:(NSNotification *)aNotification
{
    [[self scrollView] setContentSize:CGSizeMake(scrollViewContentSize.width, scrollViewContentSize.height + 700)];
}

- (void)keyboardWasHidden:(NSNotification *)aNotification
{
    [[self scrollView] setContentSize:CGSizeMake(scrollViewContentSize.width, scrollViewContentSize.height - 700)];
}


-(void)viewWillDisappear:(BOOL)animated {
    [self unregisterKeyboardNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboardTap:)];
    [[self view] addGestureRecognizer:tap];
    
    
    UIBarButtonItem *saveButon = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveTapped:)];
    [[self navigationItem] setRightBarButtonItem:saveButon];
    
    
    //set content size of scroll view so the view is scrollable on the 4s
    CGFloat textViewWidth = self.view.frame.size.width;
    [[self scrollView] setContentSize:CGSizeMake(textViewWidth, scrollView.frame.size.height)];
    
    [self updateFieldBorders];
    
    //update customer fields with customer data
    if (_customer) {
        [self updateFieldsWithCustomerData];
    }
}

-(void)updateFieldsWithCustomerData {
    [_firstName setText:[_customer first_name]];
    [_lastName setText:[_customer last_name]];
    [_addressField setText:[[_customer primaryAddress] address1]];
    [_cityField setText:[[_customer primaryAddress] city]];
    [_stateField setText:[[_customer primaryAddress] state_abbr_name]];
    [_zipField setText:[[_customer primaryAddress] zip_code]];
    [_emailField setText:[_customer email]];
    [_phoneNumber setText:[[_customer primaryPhone] formattedNumber]];
}

//draw custom bottom border on each textfield
-(void)updateFieldBorders
{
    for (id view in [[self scrollView] subviews])
    {
        if ([view isKindOfClass:[UITextField class]]) {
            [TRMUtils drawBorderForView:view isBottomBorder:YES];
            [self addAccessoryViewForTextField:view];
        }
    }
}

#pragma mark UITextFieldDelegate
-(void)registerTextFieldEvents
{
    [_firstName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_lastName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_addressField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_stateField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_cityField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_phoneNumber addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_emailField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_zipField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)textFieldDidChange:(id)sender
{
    [[self nextBarButtonItem] setEnabled:YES];
}

-(IBAction)dismissKeyboardTap:(id)sender
{
    [self.view endEditing:YES];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    indentTextField = (TRMIndentTextField *)textField;
    [self scrollViewToCenterOfScreen:textField];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [scrollView scrollRectToVisible:[textField frame] animated:YES];
}

-(void)addAccessoryViewForTextField:(UITextField *)textField
{
    UIToolbar *toolbar = [[UIToolbar alloc] init] ;
    [toolbar setBarStyle:UIBarStyleDefault];
    [toolbar sizeToFit];
    
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignKeyboard)];
    
    nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextTapped:)];
    
    previousButton = [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStylePlain target:self action:@selector(previousTapped:)];
    
    [nextButton setTintColor:[TRMUtils colorWithHexString:@"959fa5"]];
    [previousButton setTintColor:[TRMUtils colorWithHexString:@"959fa5"]];
    [doneButton setTintColor:[TRMUtils colorWithHexString:@"959fa5"]];
    
    NSArray *itemsArray = [NSArray arrayWithObjects:previousButton,nextButton,flexButton, doneButton, nil];
    
    [toolbar setItems:itemsArray];
    
    [textField setInputAccessoryView:toolbar];
}

-(void)nextTapped:(id)sender
{
    int currentTag = [indentTextField tag];
    if (currentTag == 8)
    {
        [self resignKeyboard];
    }
    UITextField *nextTextField = (UITextField *)[[self view] viewWithTag:currentTag + 1];
    [[self scrollView] scrollRectToVisible:[nextTextField frame] animated:YES];
    [nextTextField becomeFirstResponder];
}

-(void)previousTapped:(id)sender
{
    int currentTag = [indentTextField tag];
    if (currentTag == 1)
    {
        [self resignKeyboard];
    }
    UITextField *nextTextField = (UITextField *)[[self view] viewWithTag:currentTag - 1];
    [[self scrollView] scrollRectToVisible:[nextTextField frame] animated:YES];
    [nextTextField becomeFirstResponder];
}


-(void)resignKeyboard {
    [_firstName resignFirstResponder];
    [_firstName resignFirstResponder];
    [_lastName resignFirstResponder];
    [_addressField resignFirstResponder];
    [_cityField resignFirstResponder];
    [_phoneNumber resignFirstResponder];
    [_emailField resignFirstResponder];
}


-(void)scrollViewToCenterOfScreen:(UIView *)theView
{
    CGFloat viewCenterY = theView.center.y;
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    CGFloat availableHeight = applicationFrame.size.height - 200; // Remove area covered by keyboard
    
    CGFloat y = viewCenterY - availableHeight / 2.0;
    if (y < 0) {
        y = 0;
    }
    [self.scrollView setContentOffset:CGPointMake(0, y) animated:YES];
}


#pragma mark Save Customer
-(void)saveTapped:(id)sender {
    //we should check if its an exisisting customer
    if ([_customer isExisitingCustomer]) {
        
    } else {
        [self saveNewCustomer];
    }
}

-(void)saveNewCustomer {
    TRMCustomerModel *customer = [[TRMCustomerModel alloc] init];
    TRMAddressModel *address = [[TRMAddressModel alloc] init];
    TRMPhoneModel *phone = [[TRMPhoneModel alloc] init];
    
    [customer setEmail:[_emailField text]];
    [customer setFirst_name:[_firstName text]];
    [customer setLast_name:[_lastName text]];
    [address setZip_code:[_zipField text]];
    [address setAddress1:[_addressField text]];
    [address setCity:[_cityField text]];
    [address setState_abbr_name:[_stateField text]];
    [phone setNumber:[_phoneNumber text]];
    
    //default monogram will be TRU
    [customer setDefault_monogram:@""];
    
    //we need to make these the primary when creating new users
    [address setActive:YES];
    [address setName:[customer fullName]];
    [address setBilling_default:YES];
    [address setShipping_default:YES];
    [address setBusiness:NO];
    
    //we need to make these the primary when creating new users
//    [phone setPhone_type:@"mobile"];
    
    NSMutableArray *addresses = [[NSMutableArray alloc] initWithArray:@[address]];
    NSMutableArray *phones = [[NSMutableArray alloc] initWithArray:@[phone]];
    [customer setAddresses:addresses];
    [customer setPhones:phones];
    [self sendCustomerToServer:customer];
}

-(void)sendCustomerToServer:(TRMCustomerModel *)customer {
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:YES];
    
    TRMCustomerDAO *dao = [[TRMCustomerDAO alloc] init];
    [dao createNewCustomer:customer completionHandler:^(TRMCustomerModel *newCustomer, NSError *error) {
        if (!error) {
            [self pushProductSelection];
        }
        [hud hide:YES];
    }];
}
- (IBAction)didTapNextArrow:(id)sender {
    [self pushProductSelection];
}

-(void)pushProductSelection {
    TRMProductSelectionViewController *productSelectionViewController = [[TRMProductSelectionViewController alloc] initWithNibName:@"TRMProductSelectionViewController" bundle:nil];
    [[productSelectionViewController navigationItem] setTitle:@"TRUMAKER"];
    [[productSelectionViewController navigationItem] setHidesBackButton:YES];
    [productSelectionViewController setEdgesForExtendedLayout:UIRectEdgeNone];
    
    [[self navigationController] pushViewController:productSelectionViewController animated:YES];
}

#pragma mark Phone Formtatter
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([[textField placeholder] isEqualToString:@"Phone"])
    {
        int length = [self getLength:textField.text];
        //NSLog(@"Length  =  %d ",length);
        
        if(length == 10)
        {
            if(range.length == 0)
                return NO;
        }
        
        if(length == 3)
        {
            NSString *num = [self formatNumber:textField.text];
            textField.text = [NSString stringWithFormat:@"(%@) ",num];
            if(range.length > 0)
                textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
        }
        else if(length == 6)
        {
            NSString *num = [self formatNumber:textField.text];
            //NSLog(@"%@",[num  substringToIndex:3]);
            //NSLog(@"%@",[num substringFromIndex:3]);
            textField.text = [NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:3],[num substringFromIndex:3]];
            if(range.length > 0)
                textField.text = [NSString stringWithFormat:@"(%@) %@",[num substringToIndex:3],[num substringFromIndex:3]];
        }
    } else if ([[textField placeholder] isEqualToString:@"State"])
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 2) ? NO : YES;
    } else if ([[textField placeholder] isEqualToString:@"Zip"])
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 5) ? NO : YES;
    }
    
    return YES;
}

-(NSString*)formatNumber:(NSString*)mobileNumber
{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    NSLog(@"%@", mobileNumber);
    
    int length = [mobileNumber length];
    if(length > 10)
    {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
        NSLog(@"%@", mobileNumber);
        
    }
    return mobileNumber;
}

-(int)getLength:(NSString*)mobileNumber
{
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    int length = [mobileNumber length];
    
    return length;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
