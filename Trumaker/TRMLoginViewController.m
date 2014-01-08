//
//  TRMLoginViewController.m
//  Trumaker
//
//  Created by Marin Fischer on 1/6/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMLoginViewController.h"
#import "TRMLoginDAO.h"
#import "MBProgressHUD.h"

@interface TRMLoginViewController ()
@property (nonatomic) CALayer *loginFormDivider;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation TRMLoginViewController
@synthesize loginFormDivider;
@synthesize hud;

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
    [self registerForKeyboardNotifications];
    [self loginFormDivider];
    [self formBaseView];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud hide:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self
   name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil]; 
}

-(UIView *)formBaseView
{
    _loginFormBaseView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _loginFormBaseView.layer.borderWidth = 0.5f;
    _loginFormBaseView.layer.cornerRadius = 6;
    
    return _loginFormBaseView;
}

-(CALayer *)loginFormDivider
{
    if (!loginFormDivider)
    {
        loginFormDivider = [CALayer layer];
        CGFloat userNameHeight = CGRectGetHeight([[self loginEmailTextField] frame]) - 0.5;
        CGFloat userNameWidth = CGRectGetWidth([[self loginEmailTextField] frame]);
        
        loginFormDivider.frame = CGRectMake(10, userNameHeight, userNameWidth, 0.5);
        loginFormDivider.backgroundColor = [[UIColor lightGrayColor]CGColor];
        [self.loginEmailTextField.layer addSublayer: loginFormDivider];
        [loginFormDivider setNeedsDisplay];
    }
    return loginFormDivider;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
- (IBAction)signinButton:(id)sender
{
    [self.view endEditing:YES];
    [hud setLabelText:NSLocalizedString(@"Logging in...", @"Logging in...")];
    [hud show:YES];
    
    TRMLoginDAO *loginDAO = [[TRMLoginDAO alloc] init];
    [loginDAO login:_loginEmailTextField.text withPassword:_loginPasswordTextField.text completionHandler:^(BOOL successful, NSError *error)
    {
        [hud hide:YES];
        if (!error) {
            
        }
    }];
    
}

- (IBAction)forgotPasswordButton:(id)sender
{
    
}

#pragma mark TextField Helpers/Delegates
- (void)keyboardWasShown:(NSNotification *)aNotification
{
    [[self loginScrollView] setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 200)];
}


- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.4 animations:^{
        [[self loginScrollView] setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 200)];
    }];
}

#pragma textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self scrollViewToCenterOfScreen:textField];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    //keyboard will hide
    [_loginScrollView scrollRectToVisible:[textField frame] animated:YES];
    
}

- (BOOL)textFieldShouldReturn:(TRMIndentTextField *)textField
{
    if ([[textField placeholder] isEqualToString:@"password"]) {
        [self signinButton:nil];
        return YES;
    }else
    {
        [_loginPasswordTextField becomeFirstResponder];
        return YES;
    }
}

- (void)scrollViewToCenterOfScreen:(UIView *)currentView
{
    CGFloat viewCenterY      = currentView.center.y;
    CGRect  applicationFrame = [[UIScreen mainScreen] applicationFrame];
    //remove area covered by keyboard
    CGFloat availableHeight  = applicationFrame.size.height - 200;
    CGFloat y                = viewCenterY - availableHeight / 2.0;
    
    if (y < 0)
    {
        y = 0;
    }
    [self.loginScrollView setContentOffset:CGPointMake(0, y) animated:YES];
}

- (IBAction)didTapScreen:(id)sender
{
    [self.view endEditing:YES];
}

@end
