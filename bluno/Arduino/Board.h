//
//  Board.h
//  bluno
//
//  Created by Pavel Tsybulin on 13.05.17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pin.h"

@interface Board : NSObject

@property (nonatomic, readonly) NSArray<Pin*> *pins ;

- (Pin *)setMode:(PinMode)mode pin:(byte)num ;
- (Pin *)setValue:(byte)value pin:(byte)num ;
- (Pin *)inputValueDigital:(byte)value pin:(byte)num ;
- (Pin *)inputValueAnalog:(byte)value pin:(byte)num ;

@end
