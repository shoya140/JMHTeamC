//
//  JMMonitoringViewController.h
//  JMHTeamC
//
//  Created by Shoya Ishimaru on 2015/04/25.
//  Copyright (c) 2015年 shoya140. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MEME.h"

@interface JMMonitoringViewController : UIViewController<MEMEDelegate>
@property (weak, nonatomic) IBOutlet UILabel *noddingDebugLabel;
@property (weak, nonatomic) IBOutlet UILabel *focusDebugLabel;
@property (weak, nonatomic) IBOutlet UILabel *sleepyDebugLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;

@end
