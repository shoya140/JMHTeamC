//
//  JMMonitoringViewController.h
//  JMHTeamC
//
//  Created by Shoya Ishimaru on 2015/04/25.
//  Copyright (c) 2015年 shoya140. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MEMELib/MEMELib.h>

@interface JMMonitoringViewController : UIViewController

- (void) memeRealTimeModeDataReceived: (MEMERealTimeData *)data;

@end
