//
//  InfoController.m
//  bluno
//
//  Created by Pavel Tsybulin on 14.05.17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import "InfoController.h"
#import "Bluno.h"
#import "ScanController.h"

@interface InfoController () <BlunoDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (nonatomic, strong) Bluno *bluno ;

@end

@implementation InfoController

- (void)viewDidLoad {
    [super viewDidLoad] ;
    self.bluno = [Bluno bluno] ;
    self.bluno.delegate = self ;
    self.lblStatus.text = @"Not Ready" ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning] ;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    self.bluno.delegate = self ;
    
    self.lblStatus.text  = [self.bluno connected] ? @"Ready" : @"Not Ready" ;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"scan"]) {
        ((ScanController *)segue.destinationViewController).devices = self.bluno.devices ;
    }
}

#pragma mark - Actions


- (IBAction)onClose {
    [self.bluno disconnect] ;
}

- (IBAction)onScan {
    [self.bluno close] ;
    [self performSegueWithIdentifier:@"scan" sender:self] ;
}

#pragma mark - <BlunoDelegate>

- (void)didConnectDevice {
    self.lblStatus.text = @"Ready" ;
}

- (void)didDisconnectDevice {
    self.lblStatus.text = @"Not Ready" ;
}

@end
