//
//  BYTE_STRINGTest.m
//  bluno-packet
//
//  Created by Pavel Tsybulin on 11.05.17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import <XCTest/XCTest.h>
#include "BYTE_STRING.h"

@interface BYTE_STRINGTest : XCTestCase

@end

@implementation BYTE_STRINGTest

- (void)setUp {
    [super setUp] ;
}

- (void)tearDown {
    [super tearDown] ;
}

- (BOOL)BYTE_STRINGtest:(byte *)b len:(uint8_t)len {
    NSMutableData *data = [NSMutableData data] ;
    
    app_consume_bytes_b consume_bytes = ^char (const void *buffer, uint8_t size, void *application_specific_key) {
        [data appendData:[NSData dataWithBytes:buffer length:size]] ;
        return size ;
    } ;

    BYTE_STRING_t bs1 ;
    bs1.size = len ;
    bs1.buf = b ;
    encode(&DEF_BYTE_STRING, &bs1, consume_bytes, 0) ;
    BYTE_STRING_t bs2 ;
    bs2.size = 0 ;
    void *bbs2 = &bs2 ;
    const char *c = [data bytes] ;
    decode(0, &DEF_BYTE_STRING, &bbs2, c, data.length) ;
    BOOL result =  bs1.size == bs2.size && memcmp(bs1.buf, bs2.buf, bs1.size) == 0 ;
    
    ((struct_free_f *)DEF_BYTE_STRING.free_struct)(&DEF_BYTE_STRING, &bs2, 1) ;
    
    return result ;
}

- (void)testBYTE_STRINGs {
    BOOL result = true ;
    byte b[] = { 0, 1, 2, 3, 4, 5, 6 } ;
    result = result && [self BYTE_STRINGtest:&b[0] len:sizeof(b)] ;
}


@end
