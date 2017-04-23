#import <Foundation/Foundation.h>

@interface DFBlunoDevice : NSObject

@property(strong, nonatomic) NSString* identifier ;
@property(strong, nonatomic) NSString* name ;
@property(assign, nonatomic) BOOL bReadyToWrite ;

@end
