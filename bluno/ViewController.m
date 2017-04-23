//
//  ViewController.m
//  bluno
//
//  Created by Pavel Tsybulin on 23.04.17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import "ViewController.h"
#import "DFBlunoManager.h"
#import "ScanController.h"

@interface ViewController () <DFBlunoDelegate> {
    DFBlunoManager *blunoManager ;
    NSMutableArray<DFBlunoDevice *> *blunoDevices ;
    DFBlunoDevice *blunoDevice ;
}

@property (weak, nonatomic) IBOutlet UILabel *lblStatus ;
@property (weak, nonatomic) IBOutlet UITextField *lblReply ;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    self.lblStatus.text = @"Not Ready" ;
    blunoDevices = [NSMutableArray array] ;
    
    blunoManager = [DFBlunoManager sharedInstance] ;
    blunoManager.delegate = self ;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)onScan:(id)sender {
    [blunoDevices removeAllObjects] ;
    [blunoManager scan] ;
    [self performSegueWithIdentifier:@"scan" sender:self] ;
}

- (IBAction)onButton:(id)sender {
    NSUInteger tag = ((UIButton *) sender).tag ;
    if (blunoDevice.bReadyToWrite) {
        [blunoManager writeDataToDevice:[[NSString stringWithFormat:@"D%02lu", (unsigned long)tag] dataUsingEncoding:NSUTF8StringEncoding] Device:blunoDevice] ;
    }
}
- (IBAction)onPoint:(id)sender {
    if (blunoDevice.bReadyToWrite) {
        [blunoManager writeDataToDevice:[@"P" dataUsingEncoding:NSUTF8StringEncoding] Device:blunoDevice] ;
    }
}

- (IBAction)onClear:(id)sender {
    if (blunoDevice.bReadyToWrite) {
        [blunoManager writeDataToDevice:[@"C" dataUsingEncoding:NSUTF8StringEncoding] Device:blunoDevice] ;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"scan"]) {
        ((ScanController *)segue.destinationViewController).devices = blunoDevices ;
    }
}

#pragma mark - <DFBlunoDelegate>

- (void)bleDidUpdateState:(BOOL)bleSupported {
    if (bleSupported) {
        [blunoManager scan] ;
    }
}

- (void)didDiscoverDevice:(DFBlunoDevice*)dev {
    BOOL repeat = NO ;
    for (DFBlunoDevice *device in blunoDevices) {
        if ([device isEqual:dev]) {
            repeat = YES ;
            break ;
        }
    }
    
    if (!repeat) {
        [blunoDevices addObject:dev] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"bdDidDiscoverDevice" object:dev] ;
    }
}

- (void)readyToCommunicate:(DFBlunoDevice*)dev  {
    blunoDevice = dev ;
    self.lblStatus.text = @"Ready" ;
}

- (void)didDisconnectDevice:(DFBlunoDevice*)dev {
    if ([dev isEqual:blunoDevice]) {
        self.lblStatus.text = @"Not Ready" ;
        blunoDevice = nil ;
    }
}

- (void)didWriteData:(DFBlunoDevice*)dev {
    
}

- (void)didReceiveData:(NSData*)data Device:(DFBlunoDevice*)dev {
    if ([dev isEqual:blunoDevice]) {
        self.lblReply.text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
    }
}

@end
