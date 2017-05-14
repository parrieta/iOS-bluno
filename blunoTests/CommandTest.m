//
//  CommandTest.m
//  bluno-packet
//
//  Created by Pavel Tsybulin on 11.05.17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Command.h"

@interface CommandTest : XCTestCase

@end

@implementation CommandTest

- (void)setUp {
    [super setUp] ;
}

- (void)tearDown {
    [super tearDown] ;
}

- (BOOL)commandTest:(Command_t)cmd {
    NSMutableData *data = [NSMutableData data] ;
    
    app_consume_bytes_b consume_bytes = ^char (const void *buffer, uint8_t size, void *application_specific_key) {
        [data appendData:[NSData dataWithBytes:buffer length:size]] ;
        return size ;
    } ;

    BOOL result = true ;
    enc_rval_t eval = encode(&DEF_Command, &cmd, consume_bytes, 0) ;
    
    Command_t cmdN ;
    cmdN.command = 0 ;
    cmdN.args = 0 ;
    memset(&cmdN._ctx, 0, sizeof(cmdN._ctx)) ;
    void *acmd = &cmdN ;

    const char *c = [data bytes] ;
    dec_rval_t rval = decode(0, &DEF_Command, &acmd, c, data.length) ;
    
    result = result
    && eval.encoded == rval.consumed
    && cmd.command == cmdN.command
    && cmd.args->arg1 == cmdN.args->arg1
    && *(cmd.args->arg2) == *(cmdN.args->arg2)
    && memcmp(cmd.args->arg3->buf, cmdN.args->arg3->buf, cmd.args->arg3->size) == 0
    ;
    
    ((struct_free_f *)DEF_Command.free_struct)(&DEF_Command, acmd, 1) ;
    
    return result ;
}

- (void)testCommands {
    BOOL result = true ;
    
    Command_t cmd ;
    cmd.command = 0x01 ;
    cmd.args = 0 ;
    
    Arg_t arg ;
    arg.arg1 = 0x2 ;
    arg.arg2 = 0 ;
    arg.arg3 = 0 ;
    
    byte arg2 = 0x9a ;
    arg.arg2 = &arg2 ;
    
    byte tmp[] = { 0x55, 0x66 } ;
    BYTE_STRING_t arg3 ;
    arg3.size = sizeof(tmp) ;
    arg3.buf = tmp ;
    arg.arg3 = &arg3 ;
    
    cmd.args = &arg ;
    
    result = result && [self commandTest:cmd] ;
    assert(result) ;
}

@end
