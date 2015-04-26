//
//  JMInitialViewController.m
//  JMHTeamC
//
//  Created by Shoya Ishimaru on 2015/04/26.
//  Copyright (c) 2015年 shoya140. All rights reserved.
//

#import "JMInitialViewController.h"
#import "JMMonitoringViewController.h"
#import "SVProgressHUD.h"

@interface JMInitialViewController ()

@end

@implementation JMInitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MEME sharedManager].delegate = self;
    
    self.startButton.buttonColor = [UIColor alizarinColor];
    self.startButton.shadowColor = [UIColor pomegranateColor];
    self.startButton.shadowHeight = 3.0f;
    self.startButton.cornerRadius = 6.0f;
    self.startButton.titleLabel.font = [UIFont boldFlatFontOfSize:18];
    [self.startButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.startButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
    self.settingsButton.buttonColor = [UIColor carrotColor];
    self.settingsButton.shadowColor = [UIColor pumpkinColor];
    self.settingsButton.shadowHeight = 3.0f;
    self.settingsButton.cornerRadius = 6.0f;
    self.settingsButton.titleLabel.font = [UIFont boldFlatFontOfSize:18];
    [self.settingsButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.settingsButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)startButtonWasPressed:(id)sender {
    [[MEME sharedManager] disconnectDevice];
    [[MEME sharedManager] scanDevice];
    [SVProgressHUD showWithStatus:@"デバイスを検索中"];
    NSTimer *resetTimer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(resetScan:) userInfo:nil repeats:NO];
}

- (void)resetScan:(NSTimer *)timer{
    [SVProgressHUD dismiss];
}

- (void)memeConnected{
    [SVProgressHUD showSuccessWithStatus:@"接続完了"];
    JMMonitoringViewController *monitoringVC = [self.storyboard instantiateViewControllerWithIdentifier:@"JMMonitoringViewController"];
    [self.navigationController pushViewController:monitoringVC animated:YES];
}

- (void)memeRealTimeModeDataReceived:(MEMERealTimeData *)data
{
    
}

@end
