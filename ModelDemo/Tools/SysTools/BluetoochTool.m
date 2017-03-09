//
//  BluetoochTool.m
//  bluetoochOne
//
//  Created by hongkunpeng on 15/7/14.
//  Copyright (c) 2015年 hongkunpeng. All rights reserved.
//

#import "BluetoochTool.h"

@interface BluetoochTool()<CBCentralManagerDelegate, CBPeripheralDelegate>
{
    SuccessBlock success;
    BlueErrorBlock failure;
}
@property (nonatomic, strong)CBCentralManager *centralManager;
@property (nonatomic, strong)CBPeripheral	*servicePeripheral;

@property (nonatomic, strong)CBService		*cardInfoService;

@property (nonatomic, strong)CBCharacteristic    *cardInfoCharacteristic;
@property (nonatomic, strong) CBUUID       *cardInfoServiceUUID;
@property (nonatomic, strong) CBUUID       *cardInfoCharacteristicUUID;
@property (nonatomic, strong) NSMutableData *cardReturnData;
@end

@implementation BluetoochTool
@synthesize centralManager,foundPeripherals,connectedServices,cardInfoCharacteristicUUID,cardInfoServiceUUID,servicePeripheral,cardInfoService,cardInfoCharacteristic;
+ (id) sharedInstance
{
    static BluetoochTool	*this	= nil;
    
    if (!this)
        this = [[BluetoochTool alloc] init];
    
    return this;
}


- (id) init
{
    self = [super init];
    if (self) {
        centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
        foundPeripherals = [[NSMutableArray alloc] init];
        connectedServices = [[NSMutableArray alloc] init];
//        cardInfoServiceUUID=[CBUUID UUIDWithString:kCardReadCBServiceUUID];
//        cardInfoCharacteristicUUID=[CBUUID UUIDWithString:kCardReadCBCharacteristicUUID];
        
    }
    return self;
}
/****************************************************************************/
/*								Actions										*/
/****************************************************************************/
- (void) startScanningForUUIDString:(NSString *)uuidString onSuccess:(SuccessBlock)successblock onError:(BlueErrorBlock)errorblock{
    [self.foundPeripherals removeAllObjects];
    success=successblock;
    failure=errorblock;
    NSDictionary *options	= [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    NSArray *uuidArray;
    if (uuidString) {
        uuidArray= [NSArray arrayWithObjects:[CBUUID UUIDWithString:uuidString], nil];
    }
    [centralManager scanForPeripheralsWithServices:uuidArray options:options];
    
}
- (void) stopScanning{
    [centralManager stopScan];
}
/****************************************************************************/
/*						Connection/Disconnection                            */
/****************************************************************************/
- (void) connectPeripheral:(CBPeripheral*)peripheral onSuccess:(SuccessBlock)successblock onError:(BlueErrorBlock)errorblock
{
    success=successblock;
    failure=errorblock;
    if ([peripheral state]==CBPeripheralStateDisconnected) {
        servicePeripheral=peripheral;
        [centralManager connectPeripheral:peripheral options:nil];
    }else{
        NSDictionary *dict=[self splitReslutDictWithState:0 message:@"未连接该外设" advertisementData:nil error:nil];
        failure(dict);
    }
}


- (void) disconnectPeripheral:(CBPeripheral*)peripheral
{
    if(peripheral){
        [centralManager cancelPeripheralConnection:peripheral];
    }else if(servicePeripheral){
        [centralManager cancelPeripheralConnection:self.servicePeripheral];
    }
    
}

//解析后的输出
//拼接返回字典
-(NSDictionary*)splitReslutDictWithState:(NSInteger)state message:(NSString*)message advertisementData:(NSDictionary*)advertisementData error:(NSError*)error{
    NSString *statestr=[NSString stringWithFormat:@"%li",(long)state];
    if (advertisementData) {
        return [[NSDictionary alloc]initWithObjectsAndKeys:statestr,@"state",message,@"message",advertisementData,@"advertisementData",error,@"error", nil];
    }
    return [[NSDictionary alloc]initWithObjectsAndKeys:statestr,@"state",message,@"message",error,@"error",advertisementData,@"advertisementData", nil];
}

#pragma mark CBCentralManagerDelegate
//搜索到蓝牙设备列表
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
//    static int i = 0;
    NSString *str = [NSString stringWithFormat:@"Did discover peripheral. peripheral: %@ rssi: %@, UUID: %@ advertisementData: %@ ", peripheral, RSSI, peripheral.identifier.UUIDString, advertisementData];
    NSLog(@"外设:\n %@",str);
    if (![foundPeripherals containsObject:peripheral]) {
        [foundPeripherals addObject:peripheral];
        NSString *state=[NSString stringWithFormat:@"扫描到新的设备"];
        NSDictionary *dict=[self splitReslutDictWithState:1 message:state advertisementData:advertisementData error:nil];
        success(dict);
        
    }
//    if (self.isSigle) {
//        NSArray *kCBAdvDataServiceUUIDs=[advertisementData objectForKey:@"kCBAdvDataServiceUUIDs"];
//        __block BOOL thatDevice=NO;
//        [kCBAdvDataServiceUUIDs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            //
//            CBUUID *uidid=obj;
//            NSString *udid=[uidid UUIDString];
//            if ([udid isEqual:kCBAdvDataServiceUUIDOne]) {
//                thatDevice=YES;
//            }
//        }];
//        if (thatDevice) {
//            if ([peripheral state]==CBPeripheralStateDisconnected) {
//                servicePeripheral=peripheral;
//                [centralManager connectPeripheral:peripheral options:nil];
//                NSString *state=[NSString stringWithFormat:@"扫描到新的设备"];
//                NSDictionary *dict=[self splitReslutDictWithState:1 message:state advertisementData:advertisementData error:nil];
//                success(dict);
//            }
//    }
}
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSString * state = nil;
    
    switch ([central state])
    {
        case CBCentralManagerStateUnsupported:
        {
            state = @"硬件不支持低电量蓝牙";
            NSError *error=[[NSError alloc]initWithDomain:state code:1 userInfo:nil];
            NSDictionary *dict=[self splitReslutDictWithState:0 message:state advertisementData:nil error:error];
            if(failure){
                failure(dict);
            }
            
        }
            
            
            break;
        case CBCentralManagerStateUnauthorized:
        {
            state = @"这个应用程序未被授权使用蓝牙";
            NSError *error=[[NSError alloc]initWithDomain:state code:2 userInfo:nil];
            NSDictionary *dict=[self splitReslutDictWithState:0 message:state advertisementData:nil error:error];
            if(failure){
                failure(dict);
            }
        }
            break;
        case CBCentralManagerStatePoweredOff:
        {
            state = @"蓝牙处于未开启，请开启蓝牙";
            NSError *error=[[NSError alloc]initWithDomain:state code:3 userInfo:nil];
            NSDictionary *dict=[self splitReslutDictWithState:0 message:state advertisementData:nil error:error];
            if(failure){
                failure(dict);
            }
        }
            break;
        case CBCentralManagerStatePoweredOn:
        {
            state = @"work";
        }
            break;
        case CBCentralManagerStateUnknown:
        default:
        {
            state = @"未知名错误";
            NSDictionary *dict=[self splitReslutDictWithState:0 message:state advertisementData:nil error:nil];
            if(failure){
                failure(dict);
            }
        }
            break;
    }
    
//    NSLog(@"Central manager state: %@", state);
}


/*
 Invoked whenever a connection is succesfully created with the peripheral.
 Discover available services on the peripheral
 */
#pragma mark CBPeripheralDelegate
//连接成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Did connect to peripheral: %@", peripheral);
//    self.servicePeripheral=peripheral;
    [self stopScanning];
    peripheral.delegate = self;
    NSArray		*uuids	= [NSArray arrayWithObjects:cardInfoServiceUUID,
                           nil];
    [peripheral discoverServices:uuids];
    
    
}
#pragma mark
//
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSArray		*services	= nil;
    NSArray		*uuids	= [NSArray arrayWithObjects:cardInfoCharacteristicUUID,
                           nil]; // Current Temp
    
    if (peripheral != self.servicePeripheral) {
        NSLog(@"Wrong Peripheral.\n");
        NSDictionary *dict=[self splitReslutDictWithState:0 message:@"连接失败了" advertisementData:nil error:nil];
        failure(dict);
        return ;
    }
    
    if (error != nil) {
        NSLog(@"Error %@\n", error);
        NSDictionary *dict=[self splitReslutDictWithState:0 message:@"连接失败了" advertisementData:nil error:error];
        failure(dict);
        return ;
    }
    
    services = [peripheral services];
    if (!services || ![services count]) {
        NSDictionary *dict=[self splitReslutDictWithState:0 message:@"没有找到该硬件的蓝牙读写服务" advertisementData:nil error:error];
        failure(dict);
        return ;
    }
    
    cardInfoService = nil;
    
    for (CBService *service in services) {
        if ([[service UUID] isEqual:cardInfoServiceUUID]) {
            cardInfoService = service;
            break;
        }
    }
    
    if (cardInfoService) {
        [peripheral discoverCharacteristics:uuids forService:cardInfoService];
    }else{
        NSDictionary *dict=[self splitReslutDictWithState:0 message:@"该硬件的蓝牙读写服务不正确" advertisementData:nil error:error];
        failure(dict);
    }

    
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSArray		*characteristics	= [service characteristics];
    CBCharacteristic *characteristic;
    if (peripheral != servicePeripheral) {
        NSLog(@"Wrong Peripheral.\n");
        NSDictionary *dict=[self splitReslutDictWithState:0 message:@"连接失败了" advertisementData:nil error:nil];
        failure(dict);
        return ;
    }
    
    if (service != cardInfoService) {
        NSLog(@"Wrong Service.\n");
        NSDictionary *dict=[self splitReslutDictWithState:0 message:@"该硬件的蓝牙读写服务不正确" advertisementData:nil error:error];
        failure(dict);
        return ;
    }
    
    if (error != nil) {
        NSLog(@"Error %@\n", error);
        NSDictionary *dict=[self splitReslutDictWithState:0 message:@"连接失败了" advertisementData:nil error:error];
        failure(dict);
        return ;
    }
    
    for (characteristic in characteristics) {
        NSLog(@"discovered characteristic %@", [characteristic UUID]);
        
        if ([[characteristic UUID] isEqual:cardInfoCharacteristicUUID]) { // Min Temperature.
            NSLog(@"发现了读写 Characteristic");
            cardInfoCharacteristic=characteristic;
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
//            NSString *state=[NSString stringWithFormat:@"连接成功可以进行读写了"];
//            NSDictionary *dict=[self splitReslutDictWithState:1 message:state error:nil];
//            success(dict);
            
        } 
    }
    if (!cardInfoCharacteristic) {
        NSDictionary *dict=[self splitReslutDictWithState:0 message:@"没有找到该硬件的蓝牙读写服务的读写特性" advertisementData:nil error:error];
        failure(dict);
    }
//    self.selectCharacteristic=service.characteristics.firstObject;
//    [self.selectPeripheral setNotifyValue:YES forCharacteristic:self.selectCharacteristic];
}
#pragma mark
//与外设做数据交互(读 与 写)
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        NSLog(@"Error updating value for characteristic %@ error: %@", characteristic.UUID, [error localizedDescription]);
        NSDictionary *dict=[self splitReslutDictWithState:0 message:@"连接失败了" advertisementData:nil error:error];
        failure(dict);
        return;
    }
    NSLog(@"收到的数据：%@",characteristic);
    [self.cardReturnData appendData:characteristic.value];
    //    [self decodeData:characteristic.value];
}
-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error)
    {
        NSLog(@"Error updating value for characteristic %@ error: %@", characteristic.UUID, [error localizedDescription]);
        NSDictionary *dict=[self splitReslutDictWithState:0 message:@"连接失败了" advertisementData:nil error:error];
        failure(dict);
        return;
    }
    
    NSLog(@"状态的数据：%@",characteristic);
}
-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error)
    {
        NSLog(@"Error updating value for characteristic %@ error: %@", characteristic.UUID, [error localizedDescription]);
        NSLog(@"Error %@\n", error);
        NSDictionary *dict=[self splitReslutDictWithState:0 message:@"连接失败了" advertisementData:nil error:error];
        failure(dict);
        return;
    }
    
    NSLog(@"写入的数据：%@",characteristic);
}

@end
