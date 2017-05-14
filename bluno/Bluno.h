//
//  Bluno.h
//  bluno
//
//  Created by Pavel Tsybulin on 13.05.17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFBlunoManager.h"
#import "Pin.h"

@protocol BlunoDelegate <NSObject>

- (void)didConnectDevice ;
- (void)didDisconnectDevice ;
- (void)didChangeMode:(Pin *)pin ;
- (void)didChangeValue:(Pin *)pin ;

@end

@interface Bluno : NSObject

@property (nonatomic, strong) NSMutableArray<DFBlunoDevice *> *devices ;
@property (nonatomic, strong) id<BlunoDelegate> delegate ;

- (instancetype)init NS_UNAVAILABLE ;
+ (instancetype)bluno ;

- (NSArray<Pin*> *)pins ;

- (void)close ;
- (void)disconnect ;

- (void)setMode:(PinMode)mode forPin:(Pin *)pin ;
- (void)setValue:(NSInteger)value forPin:(Pin *)pin ;
- (void)getValueforPin:(Pin *)pin ;

@end
