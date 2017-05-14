//
//  ViewController.m
//  bluno
//
//  Created by Pavel Tsybulin on 23.04.17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import "ViewController.h"
#import "ScanController.h"
#import "Bluno.h"
#import "PinCell.h"

@interface ViewController () <BlunoDelegate, PinCellDelegate, UITableViewDataSource, UITableViewDelegate> {
    BOOL connected ;
}

@property (weak, nonatomic) IBOutlet UILabel *lblStatus ;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) Bluno *bluno ;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    connected = NO ;
    self.lblStatus.text = @"Not Ready" ;
    self.bluno = [Bluno bluno] ;
    self.bluno.delegate = self ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)onScan:(id)sender {
    [self.bluno close] ;
    [self performSegueWithIdentifier:@"scan" sender:self] ;
}

- (IBAction)onClose:(id)sender {
    [self.bluno disconnect] ;
}

#pragma mark - <PinCellDelegate>

- (void)pinCell:(PinCell *)pinCell didChangeMode:(PinMode)mode {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.bluno setMode:mode forPin:pinCell.pin] ;
    }) ;
}

- (void)pinCell:(PinCell *)pinCell didChangeValue:(NSUInteger)value {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.bluno setValue:value forPin:pinCell.pin] ;
    }) ;
}

- (void)pinCell:(PinCell *)pinCell didRequestValue:(id)__ {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.bluno getValueforPin:pinCell.pin] ;
    }) ;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"scan"]) {
        ((ScanController *)segue.destinationViewController).devices = self.bluno.devices ;
    }
}

#pragma mark - <BlunoDelegate>

- (void)didConnectDevice {
    self.lblStatus.text = @"Ready" ;
    connected = YES ;
    [self.tableView reloadData] ;
}

- (void)didDisconnectDevice {
    connected = NO ;
    self.lblStatus.text = @"Not Ready" ;
    [self.tableView reloadData] ;
}

- (void)tableView:(UITableView *)tableView reloadPin:(Pin *)pin {
    if (!pin) {
        return ;
    }
    
    NSIndexPath *pathToReload = [NSIndexPath indexPathForRow:[self.bluno.pins indexOfObject:pin] inSection:0] ;
    [self.tableView beginUpdates] ;
    [tableView reloadRowsAtIndexPaths:@[pathToReload] withRowAnimation:UITableViewRowAnimationNone] ;
    [self.tableView endUpdates] ;
}

- (void)didChangeMode:(Pin *)pin {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self tableView:self.tableView reloadPin:pin] ;
    }) ;
}

- (void)didChangeValue:(Pin *)pin {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self tableView:self.tableView reloadPin:pin] ;
    }) ;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numOfSections = 0 ;
    if (connected) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine ;
        numOfSections = 1 ;
        self.tableView.backgroundView = nil ;
    } else {
        UILabel *noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height)] ;
        noDataLabel.text = @"No pins available" ;
        noDataLabel.textColor        = [UIColor blackColor] ;
        noDataLabel.textAlignment    = NSTextAlignmentCenter ;
        self.tableView.backgroundView = noDataLabel ;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    }
    
    return numOfSections ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return connected && section == 0 ? self.bluno.pins.count : 0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PinCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PinCell"] ;
    cell.pin = self.bluno.pins[indexPath.row] ;
    cell.delegate = self ;
    return cell ;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [(PinCell *)cell updateCell] ;
}

@end
