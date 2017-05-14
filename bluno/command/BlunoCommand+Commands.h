//
//  BlunoCommand+Commands.h
//  bluno
//
//  Created by Pavel Tsybulin on 13.05.17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import "BlunoCommand.h"
#import "Pin.h"
#import "DFBlunoManager.h"

typedef NS_ENUM(byte, CommandType) {
    CommandTypePinSetMode  = 'M',
    CommandTypePinSetValue = 'V',
    CommandTypePinGetValueDigital = 'v',
    CommandTypePinGetValueAnalog  = 'a'
} ;

@interface BlunoCommand (Commands)

- (void)manager:(DFBlunoManager *)manager setMode:(PinMode)mode forPin:(Pin *)pin device:(DFBlunoDevice *)device ;
- (void)manager:(DFBlunoManager *)manager setValue:(NSInteger)value forPin:(Pin *)pin device:(DFBlunoDevice *)device ;
- (void)manager:(DFBlunoManager *)manager getValueforPin:(Pin *)pin device:(DFBlunoDevice *)device ;

@end
