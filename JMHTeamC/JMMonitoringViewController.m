//
//  JMMonitoringViewController.m
//  JMHTeamC
//
//  Created by Shoya Ishimaru on 2015/04/25.
//  Copyright (c) 2015年 shoya140. All rights reserved.
//

#import "JMMonitoringViewController.h"

#import <AudioToolbox/AudioToolbox.h>

#define THRESHOLD_FOCUS_BLINK_FREQUENCY_HIGH 0.1
#define THRESHOLD_FOCUS_BLINK_FREQUENCY_MEDIUM 0.4

#define THRESHOLD_SLEEP_BLINK_SPEED_HIGH 80
#define THRESHOLD_SLEEP_BLINK_SPEED_MEDIDUM 140

#define THRESHOLD_PITCH_VARIANCE 6.0
#define THRESHOLD_PITCH_DISTANCE 30

typedef NS_ENUM (NSUInteger, kFocus) {
    kFocusHigh,
    kFocusMediam,
    kFocusLow
};

typedef NS_ENUM (NSUInteger, kSleepy) {
    kSleepyHigh,
    kSleepyMediam,
    kSleepyLow
};

typedef NS_ENUM (NSUInteger, kNodding) {
    kYES,
    kNO
};

@interface JMMonitoringViewController (){
    SystemSoundID _hakusyuSound;
    NSMutableArray *_pitchValues;
    NSMutableArray *_blinkFrequencies;
    NSMutableArray *_blinkSpeeds;
    BOOL _isDetectingFocus;
    BOOL _isDetectingSleepy;
    double _lastBlinkTimeStamp;
    kFocus _focusStatus;
    kSleepy _sleepyStatus;
    kNodding _noddingStatus;
}

@end

@implementation JMMonitoringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MEME sharedManager].delegate = self;
    
    _blinkFrequencies = [NSMutableArray array];
    _noddingStatus = kNO;
    
    _pitchValues = [NSMutableArray array];
    _lastBlinkTimeStamp = [[NSDate date] timeIntervalSince1970];
    _isDetectingFocus = NO;
    _focusStatus = kFocusMediam;
    
    _blinkSpeeds = [NSMutableArray array];
    _isDetectingSleepy = NO;
    _sleepyStatus = kSleepyMediam;
    
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

- (void)resetNodding:(NSTimer *)timer
{
    _noddingStatus = kNO;
}

- (void)noddingDetection:(MEMERealTimeData *)data
{
    [_pitchValues insertObject:[NSNumber numberWithFloat:data.pitch] atIndex:0];
    if (_pitchValues.count < 30) {
        return;
    }
    [_pitchValues removeLastObject];
    
    float var = [self calcVariance:_pitchValues];
    if (_noddingStatus == kNO && var > THRESHOLD_PITCH_VARIANCE && [_pitchValues[15] floatValue] - [_pitchValues[16] floatValue] > THRESHOLD_PITCH_DISTANCE) {
        AudioServicesPlaySystemSound(_hakusyuSound);
        _noddingStatus = kYES;
        NSTimer *resetTimer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(resetNodding:) userInfo:nil repeats:NO];
    }
}

- (void)focusDetection:(MEMERealTimeData *)data
{
    if (data.blinkStrength <= 0) {
        return;
    }
    
    double timestamp = [[NSDate date] timeIntervalSince1970];
    float blinkFrequency = 1.0/(timestamp - _lastBlinkTimeStamp);
    [_blinkFrequencies insertObject:[NSNumber numberWithDouble:blinkFrequency] atIndex:0];
    _lastBlinkTimeStamp = timestamp;
    if (_blinkFrequencies.count < 10) {
        return;
    }
    [_blinkFrequencies removeLastObject];
    _isDetectingFocus = YES;
    
    float var = [self calcVariance:_blinkFrequencies];
    if (var < THRESHOLD_FOCUS_BLINK_FREQUENCY_HIGH) {
        _focusStatus = kFocusHigh;
    }else if (var < THRESHOLD_FOCUS_BLINK_FREQUENCY_MEDIUM) {
        _focusStatus = kFocusMediam;
    }else{
        _focusStatus = kFocusLow;
    }
}

- (void)sleepyDetection:(MEMERealTimeData *)data
{
    if (data.blinkStrength <= 0) {
        return;
    }
    float speed = (float)data.blinkSpeed;
    [_blinkSpeeds insertObject:[NSNumber numberWithFloat:speed] atIndex:0];
    if (_blinkSpeeds.count < 10) {
        return;
    }
    [_blinkSpeeds removeLastObject];
    _isDetectingSleepy = YES;
    
    float mean = [[_blinkSpeeds valueForKeyPath:@"@avg.self"] floatValue];
    if (mean < THRESHOLD_SLEEP_BLINK_SPEED_HIGH) {
        _sleepyStatus = kSleepyHigh;
    } else if (mean < THRESHOLD_FOCUS_BLINK_FREQUENCY_MEDIUM) {
        _sleepyStatus = kSleepyMediam;
    } else {
        _sleepyStatus = kSleepyLow;
    }
}

- (float)calcVariance:(NSArray *)values
{
    float mean = [[values valueForKeyPath:@"@avg.self"] floatValue];
    float sum = 0.0;
    for (NSNumber *val in values) {
        sum += pow(pow([val floatValue] - mean, 2.0), 0.5);
    }
    return sum/values.count;
}

# pragma mark - MEME Delegate

- (void)memeRealTimeModeDataReceived:(MEMERealTimeData *)data
{
    [self noddingDetection:data];
    [self focusDetection:data];
    [self sleepyDetection:data];
    
    switch (_noddingStatus) {
        case kYES:
            self.noddingDebugLabel.text = @"nodding:Yes";
            break;
        case kNO:
            self.noddingDebugLabel.text = @"nodding:No";
            break;
        default:
            break;
    }
    
    if (_isDetectingSleepy && _isDetectingFocus) {
        
        switch (_focusStatus) {
            case kFocusHigh:
                self.focusDebugLabel.text = @"focus:High";
                break;
            case kFocusMediam:
                self.focusDebugLabel.text = @"focus:Medium";
                break;
            case kFocusLow:
                self.focusDebugLabel.text = @"focus:Low";
                break;
            default:
                break;
        }
        
        switch (_sleepyStatus) {
            case kSleepyHigh:
                self.sleepyDebugLabel.text = @"sleepy:High";
                break;
            case kSleepyMediam:
                self.sleepyDebugLabel.text = @"sleepy:Medium";
                break;
            case kSleepyLow:
                self.sleepyDebugLabel.text = @"sleepy:Low";
                break;
            default:
                break;
        }
    }
}


@end
