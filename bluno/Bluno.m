//
//  Bluno.m
//  bluno
//
//  Created by Pavel Tsybulin on 13.05.17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import "Bluno.h"
#import "BlunoCommand+Commands.h"
#import "Board.h"

@interface Bluno () <DFBlunoDelegate> {

}

@property (nonatomic, strong) DFBlunoManager *manager ;
@property (nonatomic, strong) DFBlunoDevice *device ;
@property (nonatomic, strong) NSMutableData *data ;
@property (nonatomic, strong) BlunoCommand *blunoCommand ;
@property (nonatomic, strong) Board *board ;

@end

@implementation Bluno

- (instancetype)init_ {
    if (self = [super init]) {
    }

    return self ;
}

+ (instancetype)bluno {
    static Bluno *instance = nil ;
    
    if (!instance) {
        instance = [[Bluno alloc] init_] ;
        instance.manager = [DFBlunoManager sharedInstance] ;
        instance.manager.delegate = instance ;
        instance.devices = [NSMutableArray array] ;
        instance.data = [NSMutableData data] ;
        instance.blunoCommand = [[BlunoCommand alloc] init] ;
        instance.board = [[Board alloc] init] ;
    }
    
    return instance ;
}

- (void)close {
    [self.devices removeAllObjects] ;
    [self.manager scan] ;
}

- (void)disconnect {
    if (self.device) {
        [self.manager disconnectToDevice:self.device] ;
    }
}

- (BOOL)connected {
    return self.device != nil ;
}

- (NSArray<Pin*> *)pins {
    return self.device ? self.board.pins : nil ;
}

- (void)didReceiveCommand:(Command_t *)cmd {
    if (cmd->command == CommandTypePinSetMode) {
        if (!cmd->args || !cmd->args->arg2) {
            return ;
        }

        Pin *pin = [self.board setMode:*(cmd->args->arg2) pin:cmd->args->arg1] ;
        if (self.delegate && pin && [self.delegate respondsToSelector:@selector(didChangeMode:)]) {
            [self.delegate didChangeMode:pin] ;
        }
        
        return ;
    }
    
    if (cmd->command == CommandTypePinSetValue) {
        if (!cmd->args || !cmd->args->arg2) {
            return ;
        }
        
        Pin *pin = [self.board setValue:*(cmd->args->arg2) pin:cmd->args->arg1] ;
        if (self.delegate && pin && [self.delegate respondsToSelector:@selector(didChangeValue:)]) {
            [self.delegate didChangeValue:pin] ;
        }
        
        return ;
    }

    if (cmd->command == CommandTypePinGetValueDigital) {
        if (!cmd->args || !cmd->args->arg2) {
            return ;
        }
        
        Pin *pin = [self.board inputValueDigital:*(cmd->args->arg2) pin:cmd->args->arg1] ;
        if (self.delegate && pin && [self.delegate respondsToSelector:@selector(didChangeValue:)]) {
            [self.delegate didChangeValue:pin] ;
        }
        
        return ;
    }

    if (cmd->command == CommandTypePinGetValueAnalog) {
        if (!cmd->args || !cmd->args->arg2) {
            return ;
        }
        
        Pin *pin = [self.board inputValueAnalog:*(cmd->args->arg2) pin:cmd->args->arg1] ;
        if (self.delegate && pin && [self.delegate respondsToSelector:@selector(didChangeValue:)]) {
            [self.delegate didChangeValue:pin] ;
        }
        
        return ;
    }
}

#pragma mark - <DFBlunoDelegate>

- (void)bleDidUpdateState:(BOOL)bleSupported {
    if (bleSupported) {
        [self.manager scan] ;
    }
}

- (void)didDiscoverDevice:(DFBlunoDevice*)dev {
    BOOL repeat = NO ;
    for (DFBlunoDevice *device in self.devices) {
        if ([device isEqual:dev]) {
            repeat = YES ;
            break ;
        }
    }
    
    if (!repeat) {
        [self.devices addObject:dev] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"bdDidDiscoverDevice" object:dev] ;
    }
}

- (void)readyToCommunicate:(DFBlunoDevice*)dev  {
    self.device = dev ;

    if (self.delegate) {
        [self.delegate didConnectDevice] ;
    }
}

- (void)didDisconnectDevice:(DFBlunoDevice*)dev {
    if ([dev isEqual:self.device]) {
        self.device = nil ;

        if (self.delegate) {
            [self.delegate didDisconnectDevice] ;
        }
    }
}

- (void)didWriteData:(DFBlunoDevice*)dev {
    
}

- (void)didReceiveData:(NSData*)data Device:(DFBlunoDevice*)dev {
    if (![dev isEqual:self.device]) {
        return ;
    }
    
    [self.data appendData:data] ;
    
    while (self.data.length > 0) {
        DecodeResult *decoded = [self.blunoCommand commandFromData:self.data] ;
        
        if (decoded.code == RC_FAIL) {
            self.data.length = 0 ;
            return ;
        }
        
        if (decoded.code == RC_WMORE) {
            break ;
        }
        
        Command_t *cmd = decoded.command ;
        
        if (cmd) {
            [self didReceiveCommand:cmd] ;
            [self.blunoCommand freeCommand:cmd] ;
        }
        
        if (self.data.length == decoded.consumed) {
            self.data.length = 0 ;
        } else if (self.data.length > decoded.consumed) {
            NSData *rest = [self.data subdataWithRange:NSMakeRange(decoded.consumed, self.data.length - decoded.consumed)] ;
            [self.data setData:rest] ;
        } else {
            self.data.length = 0 ;
        }
    }
}

- (void)setMode:(PinMode)mode forPin:(Pin *)pin {
    [self.blunoCommand manager:self.manager setMode:mode forPin:pin device:self.device] ;
}

- (void)setValue:(NSInteger)value forPin:(Pin *)pin {
    [self.blunoCommand manager:self.manager setValue:value forPin:pin device:self.device] ;
}

- (void)getValueforPin:(Pin *)pin {
    [self.blunoCommand manager:self.manager getValueforPin:pin device:self.device] ;
}

@end
