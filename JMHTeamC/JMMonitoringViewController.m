//
//  JMMonitoringViewController.m
//  JMHTeamC
//
//  Created by Shoya Ishimaru on 2015/04/25.
//  Copyright (c) 2015年 shoya140. All rights reserved.
//

#import "JMMonitoringViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface JMMonitoringViewController (){
    SystemSoundID _hakusyuSound;
}

@end

@implementation JMMonitoringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"hakusyu" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(url), &_hakusyuSound);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)memeRealTimeModeDataReceived: (MEMERealTimeData *)data
{
    NSLog(@"%.2d",data.blinkStrength);
    if (data.blinkStrength > 0) {
        AudioServicesPlaySystemSound(_hakusyuSound);
    }
}

- (BOOL)noddingDetection
{
    return YES;
}


@end
