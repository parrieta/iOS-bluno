//
//  ArgTest.m
//  bluno-packet
//
//  Created by Pavel Tsybulin on 11.05.17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Arg.h"

@interface ArgTest : XCTestCase

@end

@implementation ArgTest

- (void)setUp {
    [super setUp] ;
}

- (void)tearDown {
    [super tearDown] ;
}

- (BOOL)argTest:(Arg_t)arg {
    NSMutableData *data = [NSMutableData data] ;
    
    app_consume_bytes_b consume_bytes = ^char (const void *buffer, uint8_t size, void *application_specific_key) {
        [data appendData:[NSData dataWithBytes:buffer length:size]] ;
        return size ;
    } ;

    enc_rval_t eval = encode(&DEF_Arg, &arg, consume_bytes, 0) ;
    Arg_t argN ;
    argN.arg1 = 0 ;
    argN.arg2 = 0 ;
    argN.arg3 = 0 ;
    
    memset(&argN._ctx, 0, sizeof(argN._ctx)) ;
    
    void *aarg = &argN ;
    
    const char *c = [data bytes] ;
    dec_rval_t rval = decode(0, &DEF_Arg, &aarg, c, data.length) ;
    
    BOOL result = true ;
    result = result && eval.encoded == rval.consumed &&
    arg.arg1 == argN.arg1 &&
    *(arg.arg2) == *(argN.arg2) &&
    arg.arg3->size == argN.arg3->size &&
    memcmp(arg.arg3->buf, argN.arg3->buf, arg.arg3->size) == 0
    ;
    
    ((struct_free_f *)DEF_Arg.free_struct)(&DEF_Arg, aarg, 1) ;
    
    return result ;
    
}

- (void)testArgs {
    Arg_t arg ;
    arg.arg1 = 0x2 ;
    
    arg.arg2 = 0 ;
    byte arg2 = 0x9a ;
    arg.arg2 = &arg2 ;
    
    arg.arg3 = 0 ;
    byte tmp[] = { 'A', 'r', 'd', 'u', 'i', 'n', 'o' } ;
    BYTE_STRING_t arg3 ;
    arg3.size = sizeof(tmp) ;
    arg3.buf = tmp ;
    arg.arg3 = &arg3 ;
    
    BOOL result = [self argTest:arg] ;
    assert(result) ;
}

@end
