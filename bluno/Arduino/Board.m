//
//  Board.m
//  bluno
//
//  Created by Pavel Tsybulin on 13.05.17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import "Board.h"

@implementation Board

- (instancetype)init {
    if (self = [super init]) {
        _pins = @[
            [[Pin alloc] initWithNum:2 type:PinTypeDigital  pwm:NO],
            [[Pin alloc] initWithNum:3 type:PinTypeDigital  pwm:YES],
            [[Pin alloc] initWithNum:4 type:PinTypeDigital  pwm:NO],
            [[Pin alloc] initWithNum:5 type:PinTypeDigital  pwm:YES],
            [[Pin alloc] initWithNum:6 type:PinTypeDigital  pwm:YES],
            [[Pin alloc] initWithNum:7 type:PinTypeDigital  pwm:NO],
            [[Pin alloc] initWithNum:8 type:PinTypeDigital  pwm:NO],
            [[Pin alloc] initWithNum:9 type:PinTypeDigital  pwm:YES],
            [[Pin alloc] initWithNum:10 type:PinTypeDigital pwm:YES],
            [[Pin alloc] initWithNum:11 type:PinTypeDigital pwm:YES],
            [[Pin alloc] initWithNum:12 type:PinTypeDigital pwm:NO],
            [[Pin alloc] initWithNum:13 type:PinTypeDigital pwm:NO],
            [[Pin alloc] initWithNum:0 type:PinTypeAnalog   pwm:NO],
            [[Pin alloc] initWithNum:1 type:PinTypeAnalog   pwm:NO],
            [[Pin alloc] initWithNum:2 type:PinTypeAnalog   pwm:NO],
            [[Pin alloc] initWithNum:3 type:PinTypeAnalog   pwm:NO],
            [[Pin alloc] initWithNum:4 type:PinTypeAnalog   pwm:NO],
            [[Pin alloc] initWithNum:5 type:PinTypeAnalog   pwm:NO]
        ] ;
    }
    
    return self ;
}

- (Pin *)setMode:(PinMode)mode pin:(byte)num {
    if (num < 2 || num > 13) {
        return nil ;
    }
    
    self.pins[num - 2].mode = mode ;
    return self.pins[num - 2] ;
}

- (Pin *)setValue:(byte)value pin:(byte)num {
    if (num < 2 || num > 13) {
        return nil ;
    }
    
    if (self.pins[num - 2].mode != PinModeOutput) {
        return nil ;
    }
    
    self.pins[num - 2].value = value ;
    return self.pins[num - 2] ;
}

- (Pin *)inputValueDigital:(byte)value pin:(byte)num {
    if (num < 2 || num > 13) {
        return nil ;
    }
    
    if (self.pins[num - 2].mode != PinModeInput) {
        return nil ;
    }

    self.pins[num - 2].value = value ;
    return self.pins[num - 2] ;
}

- (Pin *)inputValueAnalog:(byte)value pin:(byte)num {
    if (num > 5) {
        return nil ;
    }
    
    self.pins[num + 12].value = value ;
    return self.pins[num + 12] ;
}

@end
