//
//  JMMonitoringViewController.m
//  JMHTeamC
//
//  Created by Shoya Ishimaru on 2015/04/25.
//  Copyright (c) 2015年 shoya140. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "JMMonitoringViewController.h"

@interface JMMonitoringViewController (){
    SystemSoundID _hakusyuSound;
}

@end

@implementation JMMonitoringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MEME sharedManager].delegate = self;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"hakusyu" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(url), &_hakusyuSound);
}

- (void)viewDidDisappear:(BOOL)animated{
    [[MEME sharedManager] disconnectDevice];
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)noddingDetection
{
    return YES;
}

# pragma mark - MEME Delegate

- (void)memeRealTimeModeDataReceived:(MEMERealTimeData *)data
{
    NSLog(@"%.2d",data.blinkStrength);
    if (data.blinkStrength > 0) {
        AudioServicesPlaySystemSound(_hakusyuSound);
    }
}


@end
