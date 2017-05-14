//
//  PinCell.m
//  bluno
//
//  Created by Pavel Tsybulin on 13.05.17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import "PinCell.h"

@interface PinCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sgMode;
@property (weak, nonatomic) IBOutlet UISlider *slValue;
@property (weak, nonatomic) IBOutlet UIButton *btnGet;

@end

@implementation PinCell

- (void)awakeFromNib {
    [super awakeFromNib] ;
}

- (void)updateCell {
    self.lblName.text = self.pin.name ;
    
    self.slValue.maximumValue = self.pin.type == PinTypeAnalog || self.pin.pwmMode ? 255 : 1 ;
    self.slValue.value = self.pin.value ;
    
    if (self.pin.mode == PinModeInput) {
        self.sgMode.selectedSegmentIndex = 0 ;
        self.btnGet.enabled = YES ;
    } else {
        self.btnGet.enabled = NO ;

        if (self.pin.pwmMode) {
            self.sgMode.selectedSegmentIndex = 2 ;
        } else {
            self.sgMode.selectedSegmentIndex = 1 ;
        }
    }
    
    if (self.pin.type == PinTypeDigital) {
        [self.sgMode setEnabled:YES forSegmentAtIndex:1] ;
        [self.sgMode setEnabled:self.pin.pwmEnabled forSegmentAtIndex:2] ;
        self.slValue.enabled = self.pin.mode == PinModeOutput ;
    } else {
        self.sgMode.selectedSegmentIndex = 0 ;
        [self.sgMode setEnabled:NO forSegmentAtIndex:1] ;
        [self.sgMode setEnabled:NO forSegmentAtIndex:2] ;
        self.slValue.enabled = NO ;
    }
    
}

- (IBAction)onModeChanged:(id)sender {
    PinMode mode ;
    if (self.sgMode.selectedSegmentIndex == 2) {
        self.pin.pwmMode = YES ;
        mode = PinModeOutput ;
    } else {
        self.pin.pwmMode = NO ;
        mode = self.sgMode.selectedSegmentIndex ;
    }
    
    if (self.delegate) {
        [self.delegate pinCell:self didChangeMode:mode] ;
    }
}

- (IBAction)onValueChanged:(id)sender {
    NSUInteger step = 1 ;
    NSUInteger value = round((self.slValue.value - self.slValue.minimumValue) / step) ;
    self.slValue.value = value ;

    if (self.delegate) {
        [self.delegate pinCell:self didChangeValue:value] ;
    }
}

- (IBAction)onRequestValue:(id)sender {
    if (self.delegate) {
        [self.delegate pinCell:self didRequestValue:nil] ;
    }
}

@end
