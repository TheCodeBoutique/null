//
//  TRMCustomerInformationViewController.m
//  Trumaker
//
//  Created by Kyle Carriedo on 1/11/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMCustomerInformationViewController.h"
#import "NSObject+JTObjectMapping.h"

#import "TRMCustomerCell.h"
#import "TRMCustomerDAO.h"
#import "MBProgressHUD.h"
#import "TRMUtils.h"


#import "TRMCustomerTableViewModel.h"
#import "TRMAddressModel.h"
#import "TRMPhoneModel.h"

@interface TRMCustomerInformationViewController () <UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray *tableDataSource;
@property (nonatomic, weak) TRMCustomerCell *selectedCell;
@property (nonatomic, strong) UIBarButtonItem *nextButton;
@property (nonatomic, strong) UIBarButtonItem *previousButton;
@property (nonatomic, strong) TRMIndentTextField *indentTextField;

@end

@implementation TRMCustomerInformationViewController
@synthesize tableDataSource;
@synthesize selectedCell;
@synthesize nextButton;
@synthesize previousButton;
@synthesize indentTextField;

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

-(void)viewWillDisappear:(BOOL)animated {
    [self unregisterKeyboardNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableViewData];
    [self registerTapGesture];
    
    UIBarButtonItem *saveButon = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveTapped:)];
    [[self navigationItem] setRightBarButtonItem:saveButon];
}

-(void)saveTapped:(id)sender {
    //we should check if its an exisisting customer
    
    [self saveNewCustomer];
}

-(void)saveNewCustomer {
    TRMCustomerModel *customer = [[TRMCustomerModel alloc] init];
    TRMAddressModel *address = [[TRMAddressModel alloc] init];
    TRMPhoneModel *phone = [[TRMPhoneModel alloc] init];
    
    for (int i = 0 ; i < [tableDataSource count]; i++) {
        NSIndexPath *cellPath = [NSIndexPath indexPathForRow:i inSection:0];
        TRMCustomerCell *cell = (TRMCustomerCell *)[_tableView cellForRowAtIndexPath:cellPath];
        TRMIndentTextField *textField = [cell textField];
        NSString *placeHolder = [textField placeholder];
        
        if ([placeHolder isEqualToString:@"First Name"]) {
            [customer setFirst_name:textField.text];
        } else if ([placeHolder isEqualToString:@"Last Name"]) {
            [customer setLast_name:textField.text];
        } else if ([placeHolder isEqualToString:@"Address"]) {
            [address setAddress1:textField.text];
        } else if ([placeHolder isEqualToString:@"City"]) {
            [address setCity:textField.text];
        } else if ([placeHolder isEqualToString:@"State"]) {
            [address setState_abbr_name:textField.text];
        } else if ([placeHolder isEqualToString:@"Zip"]) {
            [address setZip_code:textField.text];
        } else if ([placeHolder isEqualToString:@"Phone"]) {
            [phone setNumber:textField.text];
        } else if ([placeHolder isEqualToString:@"Email"]) {
            [customer setEmail:textField.text];
        }
    }
    
    //default monogram will be TRU
    [customer setDefault_monogram:@"TRM"];
    
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
    TRMCustomerDAO *dao = [[TRMCustomerDAO alloc] init];
    [dao createNewCustomer:customer completionHandler:^(TRMCustomerModel *newCustomer, NSError *error) {
        if (!error) {
            
        }
    }];
}

-(void)unregisterKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)registerKeyboardNotifications {
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillShow:)
     name:UIKeyboardWillShowNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardDidShow:)
     name:UIKeyboardDidShowNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillHide:)
     name:UIKeyboardWillHideNotification
     object:nil];
}

- (void)keyboardWillShow:(NSNotification *)aNotification {
    CGSize keyboardSize = [[[aNotification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [[self tableView] setContentSize:CGSizeMake(CGRectGetWidth([_tableView frame]), CGRectGetHeight([_tableView frame]) + keyboardSize.height)];
}

-(void)keyboardDidShow:(NSNotification *)aNotification {
    //delgates are firing before the notification so we need to manual scroll to the seleced cell
    [self scrollToSelectedCell];
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    CGSize keyboardSize = [[[aNotification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [[self tableView] setContentSize:CGSizeMake(CGRectGetWidth([_tableView frame]), CGRectGetHeight([_tableView frame]) - keyboardSize.height)];
}



-(void)registerTapGesture {
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                initWithTarget:self
                                action:@selector(dismissKeyboardTap:)];
    
    [[self view] addGestureRecognizer:tap];
}

-(IBAction)dismissKeyboardTap:(id)sender {
    [self.view endEditing:YES];
}


-(void)setupTableViewData
{
    tableDataSource = [[NSMutableArray alloc] init];
    
    TRMCustomerTableViewModel *firstName = [[TRMCustomerTableViewModel  alloc] init];
    [firstName setPlacholderText:NSLocalizedString(@"First Name", @"First Name")];
    
    TRMCustomerTableViewModel *lastName = [[TRMCustomerTableViewModel  alloc] init];
    [lastName setPlacholderText:NSLocalizedString(@"Last Name", @"Last Name")];
    
    TRMCustomerTableViewModel *address = [[TRMCustomerTableViewModel  alloc] init];
    [address setPlacholderText:NSLocalizedString(@"Address", @"Address")];
    
    TRMCustomerTableViewModel *city = [[TRMCustomerTableViewModel  alloc] init];
    [city setPlacholderText:NSLocalizedString(@"City", @"City")];
    
    TRMCustomerTableViewModel *state = [[TRMCustomerTableViewModel  alloc] init];
    [state setPlacholderText:NSLocalizedString(@"State", @"State")];
    
    TRMCustomerTableViewModel *zip = [[TRMCustomerTableViewModel  alloc] init];
    [zip setPlacholderText:NSLocalizedString(@"Zip", @"Zip")];
    
    TRMCustomerTableViewModel *phone = [[TRMCustomerTableViewModel  alloc] init];
    [phone setPlacholderText:NSLocalizedString(@"Phone", @"Phone")];
    
    TRMCustomerTableViewModel *email = [[TRMCustomerTableViewModel  alloc] init];
    [email setPlacholderText:NSLocalizedString(@"Email", @"Email")];
    
    [tableDataSource addObject:firstName];
    [tableDataSource addObject:lastName];
    [tableDataSource addObject:address];
    [tableDataSource addObject:city];
    [tableDataSource addObject:state];
    [tableDataSource addObject:zip];
    [tableDataSource addObject:phone];
    [tableDataSource addObject:email];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self tableDataSource] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"customerCell";
    TRMCustomerCell *cell = (TRMCustomerCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TRMCustomerCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    TRMCustomerTableViewModel *model = [tableDataSource objectAtIndex:[indexPath row]];
    [[cell textField] setTag:[indexPath row] + 1]; // we need to start at 1
    [[cell textField] setDelegate:self];
    [self addAccessoryViewForTextField:[cell textField]];
    [cell setCustomerTableViewModel:model];
    [[cell textField] setPlaceholder:[model placholderText]];
    return cell;
}

#pragma UITextFieldDelegate
- (void) textFieldDidBeginEditing:(UITextField *)textField {
    TRMCustomerCell *cell = (TRMCustomerCell*) [[[textField superview] superview] superview];
    indentTextField = [cell textField];
    selectedCell = cell;
}

-(void)scrollToSelectedCell {
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}



-(void)addAccessoryViewForTextField:(UITextField *)textField
{
    UIToolbar *toolbar = [[UIToolbar alloc] init] ;
    [toolbar setBarStyle:UIBarStyleDefault];
    [toolbar sizeToFit];
    
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignKeyboard:)];
    
    nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextTapped:)];
    
    previousButton = [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStylePlain target:self action:@selector(previousTapped:)];
    [nextButton setTintColor:[UIColor grayColor]];
    [previousButton setTintColor:[UIColor grayColor]];
    [doneButton setTintColor:[UIColor grayColor]];
    
    NSArray *itemsArray = [NSArray arrayWithObjects:previousButton,nextButton,flexButton, doneButton, nil];
    [toolbar setItems:itemsArray];
    [textField setInputAccessoryView:toolbar];
}

-(void)resignKeyboard:(id)sender {
    [indentTextField resignFirstResponder];
}

-(void)nextTapped:(id)sender
{
    int currentTag = (int)[indentTextField tag];
    if (currentTag == 8)
    {
        [self resignKeyboard:nil];
    }
    TRMIndentTextField *nextTextField = (TRMIndentTextField *)[[self view] viewWithTag:currentTag + 1];

    [_tableView scrollRectToVisible:[nextTextField frame] animated:YES];
    [nextTextField becomeFirstResponder];
}

-(void)previousTapped:(id)sender
{
    int currentTag = (int)[indentTextField tag];
    if (currentTag == 1) {
        [self resignKeyboard:nil];
    }
    
    UITextField *nextTextField = (UITextField *)[[self view] viewWithTag:currentTag - 1];
    [_tableView scrollRectToVisible:[nextTextField frame] animated:YES];
    [nextTextField becomeFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([[textField placeholder] isEqualToString:@"Phone"])
    {
        int length = [self getLength:textField.text];
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
    
    int length = (int)[mobileNumber length];
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
    
    int length = (int)[mobileNumber length];
    
    return length;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
