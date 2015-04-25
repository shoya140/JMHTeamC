//
//  JMSettingsViewController.m
//  JMHTeamC
//
//  Created by Shoya Ishimaru on 2015/04/25.
//  Copyright (c) 2015年 shoya140. All rights reserved.
//

#import "JMSettingsViewController.h"
#import "JMMonitoringViewController.h"

@interface JMSettingsViewController (){
    NSMutableArray *_peripheralsFound;
    JMMonitoringViewController *_monitoringVC;
}

@end

@implementation JMSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MEMELib sharedInstance].delegate = self;
    [[MEMELib sharedInstance] addObserver: self forKeyPath: @"centralManagerEnabled" options: NSKeyValueObservingOptionNew context:nil];
    _peripheralsFound = @[].mutableCopy;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[MEMELib sharedInstance] disconnectPeripheral];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
}

- (IBAction)scanButtonPressed:(id)sender {
    MEMEStatus status = [[MEMELib sharedInstance] startScanningPeripherals];
    [self checkMEMEStatus: status];
}

- (void) checkMEMEStatus: (MEMEStatus) status
{
    if (status == MEME_ERROR_APP_AUTH){
        [[[UIAlertView alloc] initWithTitle: @"App Auth Failed" message: @"Invalid Application ID or Client Secret " delegate: nil cancelButtonTitle: nil otherButtonTitles: @"OK", nil] show];
    } else if (status == MEME_ERROR_SDK_AUTH){
        [[[UIAlertView alloc] initWithTitle: @"SDK Auth Failed" message: @"Invalid SDK. Please update to the latest SDK." delegate: nil cancelButtonTitle: nil otherButtonTitles: @"OK", nil] show];
    } else if (status == MEME_OK){
        NSLog(@"Status: MEME_OK");
    }
}

#pragma mark MEMELib Delegates

- (void) memePeripheralFound: (CBPeripheral *) peripheral;
{
    [_peripheralsFound addObject: peripheral];
    NSLog(@"peripheral found %@", [peripheral.identifier UUIDString]);
    [self.peripheralListTableView reloadData];
}

- (void) memePeripheralConnected: (CBPeripheral *)peripheral
{
    NSLog(@"MEME Device Connected!");
    [[MEMELib sharedInstance] changeDataMode: MEME_COM_REALTIME];
    _monitoringVC = [self.storyboard instantiateViewControllerWithIdentifier:@"JMMonitoringViewController"];
    [self.navigationController pushViewController:_monitoringVC animated:YES];
}

- (void) memePeripheralDisconnected: (CBPeripheral *)peripheral
{
    NSLog(@"MEME Device Disconnected");
}

- (void) memeStandardModeDataReceived: (MEMEStandardData *) data
{
    
}


- (void) memeRealTimeModeDataReceived: (MEMERealTimeData *) data
{
    if (_monitoringVC) [_monitoringVC memeRealTimeModeDataReceived: data];
}

- (void) memeDataModeChanged:(MEMEDataMode)mode
{
    
}

- (void) memeAppAuthorized:(MEMEStatus)status
{
    [self checkMEMEStatus: status];
}

#pragma mark UITableViewControlelr Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_peripheralsFound count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellID];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellID];
    }
    
    CBPeripheral *peripheral = [_peripheralsFound objectAtIndex: indexPath.row];
    cell.textLabel.text = [peripheral.identifier UUIDString];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBPeripheral *peripheral = [_peripheralsFound objectAtIndex: indexPath.row];
    MEMEStatus status = [[MEMELib sharedInstance] connectPeripheral: peripheral ];
    [self checkMEMEStatus: status];
    NSLog(@"Start connecting to MEME Device...");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
