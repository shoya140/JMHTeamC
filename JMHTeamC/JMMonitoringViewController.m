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
    NSMutableArray *pitchValues;
    BOOL isNodding;
}

@end

@implementation JMMonitoringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MEME sharedManager].delegate = self;
    
    pitchValues = [NSMutableArray array];
    isNodding = NO;
    
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

- (void)noddingDetection
{
    if (pitchValues.count < 10) {
        return;
    }
    
    float mean = [[pitchValues valueForKeyPath:@"@avg.self"] floatValue];
    float var = 0.0;
    for (NSNumber *val in pitchValues) {
        var += pow(pow([val floatValue] - mean, 2.0), 0.5);
    }
    var = var/pitchValues.count;
    if (!isNodding && var > 6.0) {
        AudioServicesPlaySystemSound(_hakusyuSound);
        isNodding = YES;
        NSTimer *resetTimer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(resetNodding:) userInfo:nil repeats:NO];
    }
}

- (void)resetNodding:(NSTimer *)timer
{
    isNodding = NO;
}

# pragma mark - MEME Delegate

- (void)memeRealTimeModeDataReceived:(MEMERealTimeData *)data
{
    self.debugLabel.text = [NSString stringWithFormat:@"pitch: %.2f", data.pitch];
    
    [pitchValues insertObject:[NSNumber numberWithFloat:data.pitch] atIndex:0];
    if (pitchValues.count > 10) {
        [pitchValues removeLastObject];
    }
    [self noddingDetection];
}


@end
