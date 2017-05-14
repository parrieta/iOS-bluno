//
//  ScanController.h
//  bluno
//
//  Created by Pavel Tsybulin on 23.04.17.
//  Copyright © 2017 Pavel Tsybulin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFBlunoManager.h"

@interface ScanController : UIViewController

@property (nonatomic, strong) NSMutableArray<DFBlunoDevice *> *devices ;
@property (nonatomic, strong) DFBlunoDevice *device ;

@end
