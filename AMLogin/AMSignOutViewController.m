//
//  AMSignOutViewController.m
//  AMLogin
//
//  Created by Arman Markosyan on 3/22/16.
//  Copyright © 2016 Arman Markosyan. All rights reserved.
//

#import "AMSignOutViewController.h"

#import "Defines.h"

@interface AMSignOutViewController ()

@end

@implementation AMSignOutViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (IBAction)signOutButtonAction:(UIButton *)sender {
    
    [self removeCheckInfo];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)removeCheckInfo {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setBool:NO forKey:CheckedKey];
    
    [userDefaults setObject:@"" forKey:AutoUsernameKey];
    [userDefaults setObject:@"" forKey:AutoPasswordkey];
    
}

@end
