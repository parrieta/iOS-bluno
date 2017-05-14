//
//  LenTest.m
//  bluno-packet
//
//  Created by Pavel Tsybulin on 11.05.17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import <XCTest/XCTest.h>

#include "tlv_len.h"

@interface LenTest : XCTestCase

@end

@implementation LenTest

- (void)setUp {
    [super setUp] ;
}

- (void)tearDown {
    [super tearDown] ;
}

- (BOOL)lenTest:(tlv_len_t)len {
    const byte BUFFER_LENGTH = 2 ;
    byte buffer[BUFFER_LENGTH] ;
    
    char sz = tlv_len_serialize(len, buffer, BUFFER_LENGTH) ;

    tlv_len_t l = 0 ;
    sz = tlv_len_fetch(true, buffer, sz, &l) ;

    if (len == l) {
        return YES ;
    }
    
    NSLog(@"lenTest %02X FAIL", len) ;
    return NO ;
}

- (void)testLens {
    boolean result = true ;
    tlv_len_t l = 0 ;
    for (int i = 0 ; i <= 0xff; i++, l++) {
        result = result && [self lenTest:l] ;
    }
    assert(result) ;
}


@end
