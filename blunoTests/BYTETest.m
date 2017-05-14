//
//  BYTETest.m
//  bluno-packet
//
//  Created by Pavel Tsybulin on 11.05.17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import <XCTest/XCTest.h>
#include "BYTE.h"
#include "pt_coder.h"

@interface BYTETest : XCTestCase

@end

@implementation BYTETest

- (void)setUp {
    [super setUp] ;
}

- (void)tearDown {
    [super tearDown] ;
}

- (BOOL)byteTest:(byte)b {
    NSMutableData *data = [NSMutableData data] ;

    app_consume_bytes_b consume_bytes = ^char (const void *buffer, uint8_t size, void *application_specific_key) {
        [data appendData:[NSData dataWithBytes:buffer length:size]] ;
        return size ;
    } ;
    
    encode(&DEF_BYTE, &b, consume_bytes, 0) ;
    byte bt ;
    void *bbt = &bt ;
    
    const char *c = [data bytes] ;
    
    
    decode(0, &DEF_BYTE, &bbt, c, data.length) ;
    return b == bt ;
}

- (void)testBYTEs {
    BOOL result = true ;
    byte b = 0 ;
    for (int i = 0; i <= 0xff; i++, b++) {
        result = result && [self byteTest:b] ;
    }
    assert(result) ;
}


@end
