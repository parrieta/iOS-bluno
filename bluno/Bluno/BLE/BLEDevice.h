#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


@interface BLEDevice : NSObject

@property (strong,nonatomic) CBPeripheral* peripheral ;
@property (strong,nonatomic) CBCentralManager* centralManager ;
@property (strong,nonatomic) NSMutableDictionary* dicSetupData ;
@property (strong,nonatomic) NSMutableArray* aryResources ;

@end

