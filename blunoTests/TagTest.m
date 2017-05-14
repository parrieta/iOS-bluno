//
//  TagTest.m
//  bluno-packet
//
//  Created by Pavel Tsybulin on 11.05.17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import <XCTest/XCTest.h>

#include "tlv_tag.h"

@interface TagTest : XCTestCase

@end

@implementation TagTest

- (void)setUp {
    [super setUp] ;
}

- (void)tearDown {
    [super tearDown] ;
}

- (BOOL)tagTest:(tlv_tag_t) tag {
    const byte BUFFER_LENGTH = 2 ;
    byte buffer[BUFFER_LENGTH] ;
    
    char sz = tlv_tag_serialize(tag, buffer, BUFFER_LENGTH) ;
    
    tlv_tag_t t = 0 ;
    sz = tlv_tag_fetch(buffer, sz, &t) ;

    if (tag == t) {
        return YES ;
    }

    NSLog(@"tagTest %02X FAIL", tag) ;
    return NO ;
}

- (void)testTags {
    BOOL result = true ;
    tlv_tag_t t = 0 ;
    for (int i = 0 ; i <= 0xff; i++, t++) {
        result = result && [self tagTest:t] ;
    }
    assert(result) ;
}

@end
