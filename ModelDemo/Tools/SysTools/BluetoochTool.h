//
//  BluetoochTool.h
//  bluetoochOne
//
//  Created by hongkunpeng on 15/7/14.
//  Copyright (c) 2015年 hongkunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
typedef void (^SuccessBlock) (id successObj);
typedef void (^BlueErrorBlock) (id errorObj);
@interface BluetoochTool : NSObject
//@property (nonatomic, assign) BOOL isSigle;

+ (id) sharedInstance;
/****************************************************************************/
/*								Actions										*/
/****************************************************************************/
- (void) startScanningForUUIDString:(NSString *)uuidString onSuccess:(SuccessBlock)successblock onError:(BlueErrorBlock)errorblock;
- (void) stopScanning;

- (void) connectPeripheral:(CBPeripheral*)peripheral onSuccess:(SuccessBlock)successblock onError:(BlueErrorBlock)errorblock;
- (void) disconnectPeripheral:(CBPeripheral*)peripheral;


/****************************************************************************/
/*							Access to the devices							*/
/****************************************************************************/
@property (retain, nonatomic) NSMutableArray    *foundPeripherals;
@property (retain, nonatomic) NSMutableArray	*connectedServices;	// Array of LeTemperatureAlarmService
//读取身份证
//-(void)readIDCardResultData:(NSMutableData*)sourceData onSuccess:(SuccessBlock)successblock onError:(BlueErrorBlock)errorblock;
@end
