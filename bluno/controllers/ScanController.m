//
//  ScanController.m
//  bluno
//
//  Created by Pavel Tsybulin on 23.04.17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import "ScanController.h"

@interface ScanController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ScanController

- (void)viewDidLoad {
    [super viewDidLoad] ;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDiscoverDevice:) name:@"bdDidDiscoverDevice" object:nil] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"bdDidDiscoverDevice" object:nil] ;
}

- (void)didDiscoverDevice:(NSNotification *)notification {
    [self.tableView reloadData] ;
}

- (IBAction)onCancel:(id)sender {
    [[DFBlunoManager sharedInstance] stop] ;
    [self dismissViewControllerAnimated:YES completion:nil] ;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.devices.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:@"Device" forIndexPath:indexPath] ;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = [self.devices objectAtIndex:indexPath.row].name ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DFBlunoDevice *dev = [self.devices objectAtIndex:indexPath.row] ;
    
    if ([dev isEqual:self.device]) {
        if (!dev.bReadyToWrite) {
            [[DFBlunoManager sharedInstance] connectToDevice:dev] ;
        }
    } else if (!self.device) {
        [[DFBlunoManager sharedInstance] connectToDevice:dev] ;
    } else {
        if (self.device.bReadyToWrite) {
            [[DFBlunoManager sharedInstance] disconnectToDevice:self.device] ;
        }
        self.device = nil ;
        [[DFBlunoManager sharedInstance] connectToDevice:dev] ;
    }

    [self dismissViewControllerAnimated:YES completion:nil] ;
}

@end
