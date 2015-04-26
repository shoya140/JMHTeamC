//
//  JMSettingsViewController.m
//  JMHTeamC
//
//  Created by Shoya Ishimaru on 2015/04/26.
//  Copyright (c) 2015年 shoya140. All rights reserved.
//

#import "JMSettingsViewController.h"

@interface JMSettingsViewController ()

@end

@implementation JMSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.uuidTextField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setValue:textField.text forKey:@"uuid"];
    [textField resignFirstResponder];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
