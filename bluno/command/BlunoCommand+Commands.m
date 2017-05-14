//
//  BlunoCommand+Commands.m
//  bluno
//
//  Created by Pavel Tsybulin on 13.05.17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import "BlunoCommand+Commands.h"

@implementation BlunoCommand (Commands)

// BLE max packet size is 20 bytes
#define NOTIFY_MTU 20

- (void)manager:(DFBlunoManager *)manager writeDataToDevice:(NSData*)data Device:(DFBlunoDevice*)dev {
    NSUInteger loc = 0 ;
    while (loc < data.length) {
        NSUInteger length = data.length - loc ;
        if (length > NOTIFY_MTU) {
            length = NOTIFY_MTU ;
        }
        [manager writeDataToDevice:[data subdataWithRange:NSMakeRange(loc, length)] Device:dev] ;
        loc += length ;
    }
}

- (void)manager:(DFBlunoManager *)manager setMode:(PinMode)mode forPin:(Pin *)pin device:(DFBlunoDevice *)device {
    if (pin.type == PinTypeAnalog) {
        return ;
    }
    
    Command_t cmd ;
    cmd.command = CommandTypePinSetMode ;
    Arg_t arg ;
    arg.arg1 = pin.num ;
    arg.arg2 = &mode ;
    arg.arg3 = 0 ;
    cmd.args = &arg ;
    NSData *data = [self dataFromCommand:&cmd] ;
    [self manager:manager writeDataToDevice:data Device:device] ;
}

- (void)manager:(DFBlunoManager *)manager setValue:(NSInteger)value forPin:(Pin *)pin device:(DFBlunoDevice *)device {
    if (pin.mode == PinModeInput) {
        return ;
    }
    
    byte val = value ;

    Command_t cmd ;
    cmd.command = CommandTypePinSetValue ;
    Arg_t arg ;
    arg.arg1 = pin.num ;
    arg.arg2 = &val ;
    arg.arg3 = 0 ;
    cmd.args = &arg ;
    NSData *data = [self dataFromCommand:&cmd] ;
    [self manager:manager writeDataToDevice:data Device:device] ;
}

- (void)manager:(DFBlunoManager *)manager getValueforPin:(Pin *)pin device:(DFBlunoDevice *)device {
    Command_t cmd ;
    cmd.command = pin.type == PinTypeDigital ? CommandTypePinGetValueDigital : CommandTypePinGetValueAnalog ;
    Arg_t arg ;
    arg.arg1 = pin.num ;
    arg.arg2 = 0 ;
    arg.arg3 = 0 ;
    cmd.args = &arg ;
    NSData *data = [self dataFromCommand:&cmd] ;
    [self manager:manager writeDataToDevice:data Device:device] ;
}

@end
