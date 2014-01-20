//
//  TRMAddressDetailViewController.m
//  Trumaker
//
//  Created by Marin Fischer on 1/19/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMAddressDetailViewController.h"
#import "TRMUtils.h"

@interface TRMAddressDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UIBarButtonItem *nextButton;
@property (nonatomic, strong) UIBarButtonItem *previousButton;
@property (nonatomic, assign) CGSize scrollViewContentSize;
@property (nonatomic, strong) UITextField *selectedTextField;



@end

@implementation TRMAddressDetailViewController
@synthesize nextButton;
@synthesize previousButton;
@synthesize scrollViewContentSize;
@synthesize selectedTextField;



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
    [self updateFieldBorders];
    [TRMUtils drawLeftBorder:_zipTextField];
    
    //set content size of scroll view so the view is scrollable on the 4s
    CGFloat textViewWidth = self.view.frame.size.width;
    [[self scrollView] setContentSize:CGSizeMake(textViewWidth, _scrollView.frame.size.height)];

}

-(void)viewWillAppear:(BOOL)animated
{
    [self registerKeyboardNotifications];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self setSelectedTextField:textField];
    [self addAccessoryViewForTextField:textField];
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


-(void)keyboardWillHide:(NSNotification *)aNotification
{
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


-(void)viewWillDisappear:(BOOL)animated
{
    [self unregisterKeyboardNotifications];
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
    int currentTag = [selectedTextField tag];
    if (currentTag == 5)
    {
        [self resignKeyboard];
    }
    UITextField *nextTextField = (UITextField *)[[self view] viewWithTag:currentTag + 1];
    [[self scrollView] scrollRectToVisible:[nextTextField frame] animated:YES];
    [nextTextField becomeFirstResponder];
}

-(void)previousTapped:(id)sender
{
    int currentTag = [selectedTextField tag];
    if (currentTag == 1)
    {
        [self resignKeyboard];
    }
    UITextField *nextTextField = (UITextField *)[[self view] viewWithTag:currentTag - 1];
    [[self scrollView] scrollRectToVisible:[nextTextField frame] animated:YES];
    [nextTextField becomeFirstResponder];
}


-(void)resignKeyboard
{
    [_streetTextField resignFirstResponder];
    [_streetContTextField resignFirstResponder];
    [_cityTextField resignFirstResponder];
    [_stateTextField resignFirstResponder];
    [_zipTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)useAsShippingButton:(id)sender
{
    UIImage *onState = [UIImage imageNamed:@"check_radio_on_small"];
    UIImage *offState = [UIImage imageNamed:@"check_radio_off_small"];
    
    if ([sender isSelected])
    {
        [sender setSelected:NO];
        [_shippingImageView setImage:offState];

    } else{
        [sender setSelected:YES];
        [_shippingImageView setImage:onState];
        

    }
}

- (IBAction)useAsBilling:(id)sender
{
    UIImage *onState = [UIImage imageNamed:@"check_radio_on_small"];
    UIImage *offState = [UIImage imageNamed:@"check_radio_off_small"];
    
    if ([sender isSelected])
    {
        [sender setSelected:NO];
        [_billingImageView setImage:offState];

        
    } else{
        [sender setSelected:YES];
        [_billingImageView setImage:onState];

        
    }
}

//- (IBAction)useAsBoth:(id)sender
//{
//    UIImage *onState = [UIImage imageNamed:@"check_radio_on_small"];
//    UIImage *offState = [UIImage imageNamed:@"check_radio_off_small"];
//    
//    if ([sender isSelected])
//    {
//        [sender setSelected:NO];
//        [_bothImageView setImage:offState];
//
//        
//    } else{
//        [sender setSelected:YES];
//        [_bothImageView setImage:onState];
//
//        
//    }
//}


@end
