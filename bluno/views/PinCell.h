//
//  PinCell.h
//  bluno
//
//  Created by Pavel Tsybulin on 13.05.17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pin.h"

@class PinCell ;

@protocol PinCellDelegate <NSObject>

- (void)pinCell:(PinCell *)pinCell didChangeMode:(PinMode)mode ;
- (void)pinCell:(PinCell *)pinCell didChangeValue:(NSUInteger)value ;
- (void)pinCell:(PinCell *)pinCell didRequestValue:(id)__ ;

@end

@interface PinCell : UITableViewCell

@property (nonatomic, strong) Pin *pin ;
@property (nonatomic, strong) id<PinCellDelegate> delegate ;

- (void)updateCell ;

@end
