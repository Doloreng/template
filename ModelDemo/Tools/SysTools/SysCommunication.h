//
//  SysCommunication.h
//  moduleDemo
//
//  Created by hongkunpeng on 15/4/8.
//  Copyright (c) 2015年 hongkunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^voidBlock)(void);
typedef void (^ErrorBlock)(NSError *error);
typedef void (^SuccessBlock)(id obj);
@interface SysCommunication : NSObject
//获取系统版本
+(NSString*)sysVersion;
//获取app版本
+(NSString*)appVersion;
//打电话
+(void)telephoneWithPhoneNum:(NSString*)phone;
//发短信
+(void)messageWithPhoneNum:(NSString*)phone;
//发邮件
+(void)emailWithAddress:(NSString*)address;
//touch授权
+(void)touchAuthenticateWithMessage:(NSString*)message onSuccess:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
//检查麦克风可用
+(BOOL)microphoneAvailable;
//检查是否存在摄像头
+(BOOL)cameraAvailable;
//检查是否存在前置摄像头
+(BOOL)frontCameraAvailable;
//检测照片库可用
+(BOOL)photoLibraryAvailable;
//检查是否支持视频录制
+(BOOL)videoCameraAvailable;
//检测摄像头闪光灯是否存在
+(BOOL)cameraFlashAvailable;
//检测陀螺仪是否存在
+(BOOL)gyroscopeAvailable;
//检查设备使用的是否视网膜屏
+(BOOL)retinaDisplayCapable;
//获取BundleId
+(NSString*)appBundleIdentifier;
//获得设备型号
+ (NSString *)currentDeviceModel;
//屏幕尺寸
+(NSString*)resolution;

@end
