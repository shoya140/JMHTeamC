//
//  JMInitialViewController.h
//  JMHTeamC
//
//  Created by Shoya Ishimaru on 2015/04/26.
//  Copyright (c) 2015年 shoya140. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatUIKit.h"

#import "MEME.h"

@interface JMInitialViewController : UIViewController<MEMEDelegate>
@property (weak, nonatomic) IBOutlet FUIButton *startButton;
@property (weak, nonatomic) IBOutlet FUIButton *settingsButton;

@end
