//
//  BlunoCommand.m
//  bluno
//
//  Created by Pavel Tsybulin on 11.05.17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import "BlunoCommand.h"

@implementation DecodeResult

- (instancetype)init {
    if (self = [super init]) {
        self.command = 0 ;
        self.code = RC_FAIL ;
        self.consumed = 0 ;
    }
    
    return self ;
}

@end

@implementation BlunoCommand

- (NSData*)dataFromCommand:(Command_t *)command {
    NSMutableData *data = [NSMutableData data] ;

    app_consume_bytes_b consume_bytes = ^char (const void *buffer, uint8_t size, void *application_specific_key) {
        [data appendData:[NSData dataWithBytes:buffer length:size]] ;
        return size ;
    } ;

    enc_rval_t eval = encode(&DEF_Command, command, consume_bytes, 0) ;
    return eval.encoded > 0 ? data : nil ;
}

- (DecodeResult *)commandFromData:(NSData *)data {
    Command_t *cmd = calloc(1, sizeof(Command_t)) ;
    cmd->command = 0 ;
    cmd->args = 0 ;
    memset(&cmd->_ctx, 0, sizeof(cmd->_ctx)) ;
    
    const char *c = [data bytes] ;
    dec_rval_t rval = decode(0, &DEF_Command, (void**)&cmd, c, data.length) ;
    
    DecodeResult *result = [[DecodeResult alloc] init] ;
    result.code = rval.code ;
    result.consumed = rval.consumed ;
    result.command = cmd ;
    return result ;
}

- (void)freeCommand:(Command_t *)cmd {
    ((struct_free_f *)DEF_Command.free_struct)(&DEF_Command, cmd, 1) ;
}

@end
