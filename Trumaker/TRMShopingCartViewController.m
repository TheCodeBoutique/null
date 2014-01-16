//
//  TRMShopingCartViewController.m
//  Trumaker
//
//  Created by Kyle Carriedo on 1/14/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMShopingCartViewController.h"
#import "TRMShoppingCartCell.h"
#import "TRMProductModel.h"
#import "UIImageView+WebCache.h"

@interface TRMShopingCartViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UIBarButtonItem *editButton;
@property (nonatomic, strong) UIBarButtonItem *doneButton;
@end

@implementation TRMShopingCartViewController
@synthesize selectedProducts;
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
    
    [[self navigationItem] setTitle:@"Orders"];
    _editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(didTapEdit:)];
    _doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didTapEdit:)];
    [[self navigationItem] setRightBarButtonItem:_editButton];
    [[self navigationItem] setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(didTapClose:)]];
    
}

-(IBAction)didTapEdit:(id)sender {
    if ([[self tableView] isEditing]) {
        [[self tableView] setEditing:NO animated:YES];
        [[self navigationItem] setRightBarButtonItem:_editButton];
    } else {
        [[self navigationItem] setRightBarButtonItem:_doneButton];
        [[self tableView] setEditing:YES animated:YES];
    }
    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [[self tableView] reloadData];
    });
}


-(IBAction)didTapClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{        
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [selectedProducts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"shoppingCell";
    TRMShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TRMShoppingCartCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    TRMProductModel *selectedProduct = [selectedProducts objectAtIndex:indexPath.row];
    [[cell productTitle] setText:selectedProduct.name];
    [[cell selectionCount] setText:[NSString stringWithFormat:@"%@",[selectedProduct selectedCount]]];
    [[cell selectQuanity] setText:[NSString stringWithFormat:@"%@",[selectedProduct selectedCount]]];
    [[cell productImage] setImageWithURL:[NSURL URLWithString:[[selectedProduct image_ids] objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [cell setProduct:selectedProduct];
    
    //handle edit state for cell
    if ([[self tableView] isEditing]) {
        [[cell badgeView] setHidden:YES];
        [[cell selectQuanity] setHidden:NO];
    } else {
        [[cell badgeView] setHidden:NO];
        [[cell selectQuanity] setHidden:YES];
    }
    
    //add toolbar for text fields
    [self addAccessoryViewForTextField:[cell selectQuanity]];
    
    [[cell selectQuanity] setDelegate:self];
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark UITextFieldDelegate 

- (void)textFieldDidEndEditing:(UITextField *)textField {
    TRMShoppingCartCell *cell = (TRMShoppingCartCell *)[[[textField superview] superview] superview];
    [[cell selectionCount] setText:textField.text];
    [[cell selectQuanity] setText:textField.text];
    [[cell product] setSelectedCount:[NSNumber numberWithInt:[[textField text] intValue]]];    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

#pragma mark TextField Accessory Bar
-(void)addAccessoryViewForTextField:(UITextField *)textField
{
    UIToolbar *toolbar = [[UIToolbar alloc] init] ;
    [toolbar setBarStyle:UIBarStyleDefault];
    [toolbar sizeToFit];
    
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignKeyboard:)];
    [doneButton setTintColor:[UIColor grayColor]];
    
    NSArray *itemsArray = [NSArray arrayWithObjects:flexButton, doneButton, nil];
    [toolbar setItems:itemsArray];
    [textField setInputAccessoryView:toolbar];
}

-(void)resignKeyboard:(id)sender {
    [[self view] endEditing:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
