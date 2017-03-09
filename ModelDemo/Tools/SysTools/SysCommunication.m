//
//  SysCommunication.m
//  moduleDemo
//
//  Created by hongkunpeng on 15/4/8.
//  Copyright (c) 2015年 hongkunpeng. All rights reserved.
//

#import "SysCommunication.h"
#import "AppDelegate.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>
#import <MobileCoreServices/MobileCoreServices.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen]bounds].size.height-(double)480)< DBL_EPSILON)
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen]bounds].size.height-(double)568)< DBL_EPSILON)
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen]bounds].size.height-(double)667)< DBL_EPSILON)
#define IS_IPHONE_6_Plus (fabs((double)[[UIScreen mainScreen]bounds].size.height-(double)736)< DBL_EPSILON)
@implementation SysCommunication
//打电话
+(void)telephoneWithPhoneNum:(NSString*)phone{
    NSString *phonestr=[NSString stringWithFormat:@"tel://%@",phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phonestr]];
}
//发短信
+(void)messageWithPhoneNum:(NSString*)phone{
    NSString *phonestr=[NSString stringWithFormat:@"sms://%@",phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phonestr]];
}
//发邮件
+(void)emailWithAddress:(NSString*)address{
    NSString *phonestr=[NSString stringWithFormat:@"mailto://%@",address];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phonestr]];
}
//touch授权
+(void)touchAuthenticateWithMessage:(NSString*)message onSuccess:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock{
    if (message==nil) {
        NSError *error=[[NSError alloc]initWithDomain:@"请输入提示语" code:200 userInfo:nil];
        errorBlock(error);
    }else{
        LAContext *myContext = [[LAContext alloc] init];
        NSError *authError = nil;
        NSString *myLocalizedReasonString = message;
        
        if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
            [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                      localizedReason:myLocalizedReasonString
                                reply:^(BOOL success, NSError *error) {
                                    if (success) {
                                        successBlock(@"验证成功了");
                                    } else {
                                        // User did not authenticate successfully, look at error and take appropriate action
                                        errorBlock(error);
                                    }
                                }];
        } else {
            // Could not evaluate policy; look at authError and present an appropriate message to user
            errorBlock(authError);
        }
    }
}
//检查麦克风可用
+(BOOL)microphoneAvailable{
    return [AVAudioSession sharedInstance].inputAvailable;
}
//检查是否存在摄像头
+(BOOL)cameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}
//检查是否存在前置摄像头
+(BOOL)frontCameraAvailable{
#ifndef __IPHONE_4_0

    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
#else
    return NO;
#endif
}
//检测照片库可用
+(BOOL)photoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}
//检查是否支持视频录制
+(BOOL)videoCameraAvailable{
//    UIImagePickerController*picker=[[UIImagePickerController alloc] init];
    if (![SysCommunication cameraAvailable]) return NO;
    NSArray *sourceTypes=[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    if (![sourceTypes containsObject:(NSString*)kUTTypeMovie]) {
        return NO;
    }
    return YES;
}
//检测摄像头闪光灯是否存在
+(BOOL)cameraFlashAvailable{
    return [UIImagePickerController isFlashAvailableForCameraDevice:UIImagePickerControllerCameraDeviceRear];
}
//检测陀螺仪是否存在
+(BOOL)gyroscopeAvailable{
    CMMotionManager *motionManager=[[CMMotionManager alloc]init];
    BOOL gyroAvailable=motionManager.gyroAvailable;
    return gyroAvailable;
}
//检查设备使用的是否视网膜屏
+(BOOL)retinaDisplayCapable{
    int scale=1.0;
    UIScreen *screen=[UIScreen mainScreen];
    if ([screen respondsToSelector:@selector(scale)]) {
        scale=screen.scale;
    }
    if (scale == 2.0f) return YES;
    else return NO;
}
//获取系统版本
+(NSString*)sysVersion{
    return [[UIDevice currentDevice]systemVersion];
}
//获取app版本
+(NSString*)appVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}
//获取BundleId
+(NSString*)appBundleIdentifier{
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    return identifier;
}
//屏幕尺寸
+(NSString*)resolution{
    NSString* resolution = [NSString string];
    if (IS_IPHONE_4) {
        resolution = @"960*640";
    }else if (IS_IPHONE_5){
        resolution = @"1136*640";
    }else if (IS_IPHONE_6){
        resolution = @"1334*750";
    }else if (IS_IPHONE_6_Plus){
        resolution = @"1920*1080";
    }else if (isPad){
        resolution = @"960*640";
    }
    return resolution;
}

//获得设备型号
+ (NSString *)currentDeviceModel
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}
@end
