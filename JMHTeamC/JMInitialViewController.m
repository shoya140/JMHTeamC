//
//  JMInitialViewController.m
//  JMHTeamC
//
//  Created by Shoya Ishimaru on 2015/04/26.
//  Copyright (c) 2015年 shoya140. All rights reserved.
//

#import "JMInitialViewController.h"
#import "JMMonitoringViewController.h"

@interface JMInitialViewController ()

@end

@implementation JMInitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MEME sharedManager].delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)startButtonWasPressed:(id)sender {
    [[MEME sharedManager] scanDevice];
}

- (void)memeConnected{
    JMMonitoringViewController *monitoringVC = [self.storyboard instantiateViewControllerWithIdentifier:@"JMMonitoringViewController"];
    [self.navigationController pushViewController:monitoringVC animated:YES];
}

@end
