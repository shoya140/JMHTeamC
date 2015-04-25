//
//  MEME.h
//  JMHTeamC
//
//  Created by Shoya Ishimaru on 2015/04/26.
//  Copyright (c) 2015年 shoya140. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MEMELib/MEMELib.h>

@protocol MEMEDelegate <NSObject>

@optional
- (void)memeConnected;
- (void)memeDisconnected;
- (void)memeRealTimeModeDataReceived: (MEMERealTimeData *) data;

@end

@interface MEME : NSObject <MEMELibDelegate>

@property (weak, nonatomic) id<MEMEDelegate> delegate;

+ (MEME *)sharedManager;
- (void)scanDevice;
- (void)disconnectDevice;

@end
