//
//  BlunoCommand.h
//  bluno
//
//  Created by Pavel Tsybulin on 11.05.17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Command.h"

@interface DecodeResult : NSObject

@property(nonatomic) Command_t *command ;
@property(nonatomic) enum dec_rval_code_e code ;
@property(nonatomic) uint8_t consumed ;

@end

@interface BlunoCommand : NSObject

- (NSData*)dataFromCommand:(Command_t *)command ;
- (DecodeResult *)commandFromData:(NSData *)data ;
- (void)freeCommand:(Command_t *)cmd ;

@end
