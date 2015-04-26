//
//  SEManager.m
//  JMHTeamC
//
//  Created by Shoya Ishimaru on 2015/04/26.
//  Copyright (c) 2015年 shoya140. All rights reserved.
//

#import "SEManager.h"
#import "AVFoundation/AVFoundation.h"

@implementation SEManager

static SEManager *sharedData_ = nil;

+ (SEManager *)sharedManager{
    @synchronized(self){
        if (!sharedData_) {
            sharedData_ = [[SEManager alloc]init];
        }
    }
    return sharedData_;
}

- (id)init
{
    self = [super init];
    if (self) {
        soundArray = [[NSMutableArray alloc] init];
        _soundVolume = 0.2;
    }
    return self;
}

- (void)playSound:(NSString *)soundName{
    NSString *soundPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:soundName];
    NSURL *urlOfSound = [NSURL fileURLWithPath:soundPath];
    
    AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithContentsOfURL:urlOfSound error:nil];
    [player setNumberOfLoops:-1];
    player.volume = _soundVolume;
    player.delegate = (id)self;
    [soundArray insertObject:player atIndex:0];
    [player prepareToPlay];
    [player play];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [soundArray removeObject:player];
}

@end
