//
//  SignUpViewController.m
//  AMLogin
//
//  Created by Arman Markosyan on 3/18/16.
//  Copyright © 2016 Arman Markosyan. All rights reserved.
//

#import "SignUpViewController.h"

#import "Defines.h"

@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelButtonBottomConstraint;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(notificationKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(notificationKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.firstNameField becomeFirstResponder];
}


#pragma mark - Actions


- (IBAction)cancelButtonAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)signUpAction:(id)sender {
    
    if ([self addUser]) {
        [self performSegueWithIdentifier:@"OpenLogin" sender:nil];
        
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                       message:@"User already exists"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (BOOL)addUser {
    
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    // Get all users from NSUserDefaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *allUsers = [userDefaults mutableArrayValueForKey:@"users"];
    
    if (!allUsers) {
        // If users array is nil create empty array
        allUsers = [NSMutableArray array];
    }
    
    // Create dictionary of user to save
    NSDictionary *user = @{UsernameKey: username, Passwordkey: password};
    
    // Show alert if user already exists
    for (NSDictionary *user_ in allUsers) {
        if ([user_[UsernameKey] isEqualToString:user[UsernameKey]]) {
            return NO;
        }
    }
    
    // Add current user in users array
    [allUsers addObject:user];
    
    // Save users array with new user in NSUserDefaults
    [userDefaults setObject:allUsers forKey:@"users"];
    
    return YES;
}

- (void)notificationKeyboardWillShow:(NSNotification*)notification {
    CGRect keyboardBounds = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    self.cancelButtonBottomConstraint.constant = 16 + keyboardBounds.size.height;
    [self.view layoutIfNeeded];
    NSLog(@"notificationKeyboardWillShow %@",notification.userInfo);
}

- (void)notificationKeyboardWillHide:(NSNotification*)notification {
    
    self.cancelButtonBottomConstraint.constant = 16;
    [self.view layoutIfNeeded];
    NSLog(@"notificationKeyboardWillHide %@",notification.userInfo);
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:self.firstNameField]) {
        [self.lastNameField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    
    return NO;
    
}


@end
