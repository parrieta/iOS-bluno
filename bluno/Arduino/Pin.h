//
//  Pin.h
//  bluno
//
//  Created by Pavel Tsybulin on 13.05.17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "arduino.h"

@interface Pin : NSObject

@property (nonatomic, strong, readonly) NSString *name ;
@property (nonatomic, readonly) PinType type ;
@property (nonatomic, readonly) byte num ;
@property (nonatomic, readonly) BOOL pwmEnabled ;
@property (nonatomic) PinMode mode ;
@property (nonatomic) BOOL pwmMode ;
@property (nonatomic) NSInteger value ;

- (instancetype)initWithNum:(byte)num type:(PinType)type pwm:(BOOL)pwm NS_DESIGNATED_INITIALIZER ;

@end
