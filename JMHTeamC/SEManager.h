//
//  SEManager.h
//  JMHTeamC
//
//  Created by Shoya Ishimaru on 2015/04/26.
//  Copyright (c) 2015年 shoya140. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SEManager : NSObject{
    NSMutableArray *soundArray;
}

@property(nonatomic) float soundVolume;

+ (SEManager *)sharedManager;
- (void)playSound:(NSString *)soundName;

@end
