//
//  JMMonitoringViewController.m
//  JMHTeamC
//
//  Created by Shoya Ishimaru on 2015/04/25.
//  Copyright (c) 2015年 shoya140. All rights reserved.
//

#import "JMMonitoringViewController.h"

@interface JMMonitoringViewController ()

@end

@implementation JMMonitoringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) memeRealTimeModeDataReceived: (MEMERealTimeData *)data
{
    NSLog(@"RealTime Data Received %@", [data description]);
}


@end
