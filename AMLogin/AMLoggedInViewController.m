//
//  AMLoggedInViewController.m
//  AMLogin
//
//  Created by Arman Markosyan on 3/16/16.
//  Copyright © 2016 Arman Markosyan. All rights reserved.
//

#import "AMLoggedInViewController.h"

#import "Defines.h"

@interface AMLoggedInViewController () <UITextFieldDelegate>

@property (weak, nonatomic) UITextField *currentTextField;

@end

@implementation AMLoggedInViewController {
    BOOL checked;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [NSUserDefaults resetStandardUserDefaults];
    
    checked = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSDictionary *user = [self loadCheckInfo];
    if (user) {
        // Get all users from NSUserDefaults
        [self performSegueWithIdentifier:@"OpenLogin" sender:nil];
        
    } else {
        [self.usernameField becomeFirstResponder];
    }
    
}

#pragma mark - Save and Load check info

- (void)saveCheckInfo {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setBool:checked forKey:CheckedKey];
    
    if (checked) {
        [userDefaults setObject:self.usernameField.text forKey:AutoUsernameKey];
        [userDefaults setObject:self.passwordField.text forKey:AutoPasswordkey];
    }
    
}

- (NSDictionary *)loadCheckInfo {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults boolForKey:CheckedKey]) {
        NSDictionary *user = @{UsernameKey: [userDefaults objectForKey:AutoUsernameKey],
                               Passwordkey: [userDefaults objectForKey:AutoPasswordkey]};
        
        return user;
    }
    
    return nil;
}

#pragma mark - Action

- (IBAction)dismissKeyboardGesture:(UITapGestureRecognizer *)sender {
    if ([self.currentTextField isFirstResponder]) {
        [self.currentTextField resignFirstResponder];
    }
}

- (IBAction)actionTextChanged:(UITextField *)sender {
    
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentTextField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:self.usernameField]) {
        [self.passwordField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return NO;
}

- (IBAction)checkButton:(UIButton *)sender {
    
    if (!checked) {
        [self.checkBoxButton setImage:[UIImage imageNamed:@"checkboxCheckedGray"]
                             forState:UIControlStateNormal];
        
        checked = YES;
        
    } else {
        [self.checkBoxButton setImage:[UIImage imageNamed:@"checkboxUncheckedGray"]
                             forState:UIControlStateNormal];
        
        checked = NO;
    }
}

- (void)showAlert {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                   message:@"Invalid login or password."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)logInAction:(UIButton *)sender {
    
    if ([self isLoginAndPasswordCorrect]) {
        [self saveCheckInfo];
        [self performSegueWithIdentifier:@"OpenLogin" sender:nil];
        
    } else {
        [self showAlert];
    }
}

- (BOOL)isLoginAndPasswordCorrect {
    
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    // Get all users from NSUserDefaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *allUsers = [userDefaults mutableArrayValueForKey:@"users"];
    
    // Create dictionary of user to save
    NSDictionary *user = @{UsernameKey: username, Passwordkey: password};
    
    // Show alert if user already exists
    for (NSDictionary *user_ in allUsers) {
        if ([user_[UsernameKey] isEqualToString:user[UsernameKey]] &&
            [user_[Passwordkey] isEqualToString:user[Passwordkey]]) {
            return YES;
        }
    }
    
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
