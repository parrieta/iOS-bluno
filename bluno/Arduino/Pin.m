//
//  Pin.m
//  bluno
//
//  Created by Pavel Tsybulin on 13.05.17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import "Pin.h"

@implementation Pin

- (instancetype)init {
    self = [self initWithNum:0 type:PinTypeDigital pwm:NO] ;
    return self;
}

- (instancetype)initWithNum:(byte)num type:(PinType)type pwm:(BOOL)pwm {
    self = [super init] ;
    if (self = [super init]) {
        _num = num ;
        _type = type ;
        _pwmEnabled = pwm ;
        _pwmMode = NO ;
        _name = [NSString stringWithFormat:@"Pin %@%d", type == PinTypeDigital ? @"D" : @"A", num] ;
        self.mode = type == PinTypeDigital ? PinModeOutput : PinModeInput ;
        self.value = 0 ;
    }
    return self ;
}

@end
