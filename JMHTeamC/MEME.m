//
//  MEME.m
//  JMHTeamC
//
//  Created by Shoya Ishimaru on 2015/04/26.
//  Copyright (c) 2015年 shoya140. All rights reserved.
//

#import "MEME.h"

@implementation MEME

static MEME *sharedData = nil;

+ (MEME *)sharedManager{
    @synchronized(self){
        if (!sharedData) {
            sharedData = [[MEME alloc] init];
        }
    }
    return sharedData;
}

- (id)init
{
    self = [super init];
    if (self) {
        //Initialization
        [MEMELib sharedInstance].delegate = self;
    }
    return self;
}

- (void)checkMEMEStatus: (MEMEStatus) status
{
    if (status == MEME_ERROR_APP_AUTH){
        NSLog(@"Status: MEME_ERROR_APP_AUTH");
    } else if (status == MEME_ERROR_SDK_AUTH){
        NSLog(@"Status: MEME_ERROR_SDK_AUTH");
    } else if (status == MEME_OK){
        NSLog(@"Status: MEME_OK");
    }
}

- (void)scanDevice
{
    MEMEStatus status = [[MEMELib sharedInstance] startScanningPeripherals];
    [self checkMEMEStatus: status];
}

- (void)disconnectDevice
{
    [[MEMELib sharedInstance] disconnectPeripheral];
}

#pragma mark - MEMELib Delegates

- (void)memePeripheralFound: (CBPeripheral *) peripheral;
{
    NSString *uuid = [peripheral.identifier UUIDString];
    NSLog(@"peripheral found %@", uuid);
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ([uuid isEqualToString:[ud stringForKey:@"uuid"]]) {
        MEMEStatus status = [[MEMELib sharedInstance] connectPeripheral: peripheral];
        [self checkMEMEStatus: status];
    }
}

- (void)memePeripheralConnected: (CBPeripheral *)peripheral
{
    NSLog(@"MEME Device Connected!");
    [[MEMELib sharedInstance] changeDataMode: MEME_COM_REALTIME];
    [self.delegate memeConnected];
}

- (void)memePeripheralDisconnected: (CBPeripheral *)peripheral
{
    NSLog(@"MEME Device Disconnected");
}

- (void)memeStandardModeDataReceived: (MEMEStandardData *) data
{
    
}

- (void)memeRealTimeModeDataReceived: (MEMERealTimeData *) data
{
    [self.delegate memeRealTimeModeDataReceived:data];
}

- (void)memeDataModeChanged:(MEMEDataMode)mode
{
    
}

- (void)memeAppAuthorized:(MEMEStatus)status
{
    [self checkMEMEStatus: status];
}


@end
