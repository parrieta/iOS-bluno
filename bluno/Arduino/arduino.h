//
//  arduino.h
//  bluno
//
//  Created by Pavel Tsybulin on 12.05.17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#ifndef arduino_h
#define arduino_h

#import "common.h"

#define PIN_STATE_HIGH 0x1
#define PIN_STATE_LOW  0x0

#define PIN_MODE_INPUT 0x0
#define PIN_MODE_OUTPUT 0x1
#define PIN_MODE_INPUT_PULLUP 0x2

typedef NS_ENUM(byte, PinState) {
    PinStateHigh = PIN_STATE_HIGH,
    PinStateLow = PIN_STATE_LOW
} ;

typedef NS_ENUM(byte, PinMode) {
    PinModeInput = PIN_MODE_INPUT,
    PinModeOutput = PIN_MODE_OUTPUT,
    PinModeInputPullUp = PIN_MODE_INPUT_PULLUP
} ;

typedef NS_ENUM(NSInteger, PinType) {
    PinTypeDigital,
    PinTypeAnalog
} ;

#endif
