//
//  UserPlatformClient.m
//  userPlatform
//
//  Created by pengnan on 15/5/4.
//  Copyright (c) 2015年 pengnan. All rights reserved.
//

#import "UserPlatformClient.h"
#import "NSDataAES.h"
#import "SecurityUtil.h"
#import "SysCommunication.h"
#define ChinaAppKey @"1m3h5k7t*C3f8a9@" //请替换为您的appKey
#define ChinaAppId @"zhengzhou" //

#import "Reachability.h"
#define Host_url @"http://passport.china.com/chinaapi"
//#define Host_url @"http://192.168.24.94/chinaapi"
@interface UserPlatformClient()
@end
@implementation UserPlatformClient

/*手机号码正则表达式验证 MODIFIED BY HELENSONG*/
+(BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10 * 中国移动：China Mobile
     11 * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12 */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15 * 中国联通：China Unicom
     16 * 130,131,132,152,155,156,185,186
     17 */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20 * 中国电信：China Telecom
     21 * 133,1349,153,180,189
     22 */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25 * 大陆地区固话及小灵通
     26 * 区号：010,020,021,022,023,024,025,027,028,029
     27 * 号码：七位或八位
     28 */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//unicode编码以\u开头
+(NSString *)replaceUnicode:(NSString *)unicodeStr
{
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

//utf-8转Unicode
+(NSString *) utf8ToUnicode:(NSString *)string

{
    
    NSUInteger length = [string length];
    
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    
    for (int i = 0;i < length; i++)
        
    {
        
        unichar _char = [string characterAtIndex:i];
        
        //判断是否为英文和数字
        
        if (_char <= '9' && _char >= '0')
            
        {
            
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
            
        }
        
        else if(_char >= 'a' && _char <= 'z')
            
        {
            
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
            
            
            
        }
        
        else if(_char >= 'A' && _char <= 'Z')
            
        {
            
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
            
            
            
        }
        
        else
            
        {
            
            [s appendFormat:@"\\u%x",[string characterAtIndex:i]];
            
        }
        
    }
    
    return s;
    
}

// NSDate 字符串 生日时间转换
+(NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:date];
//    NSLog(@"%@", strDate);
    
    return strDate;
    
}
+(NSString*)networkingState{
    NSString *netString=@"无";
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            // 没有网络连接
            netString=@"无";
            break;
        case ReachableViaWWAN:
            // 使用3G网络
            netString=@"3G/4G";
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
            netString=@"WiFi";
            break;
    }
    return netString;
}
//拼接字符字典
+(NSDictionary*)phoneInfo{
    NSString *identification=[SysCommunication appBundleIdentifier];
//    identification=[self utf8ToUnicode:identification];
    NSString *model=[SysCommunication currentDeviceModel];
    NSString *networktype=[UserPlatformClient networkingState];
//    networktype=[self utf8ToUnicode:networktype];
    NSString *platform=@"IOS";
    NSString *resolution=[SysCommunication resolution];
    NSString *version=[SysCommunication appVersion];
    NSDictionary* phoneInfo = @{@"identification":identification,@"model":model,@"networkType":networktype,@"platform":platform,@"resolution":resolution,@"version":version};
//    NSLog(@"phoneinfo %@",phoneInfo);
    return  phoneInfo;
}
//添加统一参数
+(NSDictionary*)appendParam:(NSDictionary*)source{
   // @"paramEncode":[self utf8ToUnicode:@"unicode"]
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]initWithDictionary:source];
    [dict setObject:@"unicode" forKey:@"paramEncode"];
    return dict;
}
//解析数据
+(id)decodeResponseData:(id)data{
    NSString *json =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"未解析的数据：\n%@", json);
    
    NSData* dataF = [[NSData alloc]initWithBase64EncodedString:json options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSDictionary* finalJson;
    @try {
        // 可能会出现崩溃的代码
        finalJson = [SecurityUtil decryptAESData:dataF app_key:ChinaAppKey];
    }
    @catch (NSException *exception) {
        // 捕获到的异常exception
//        NSLog(@"解析出错 %@",exception);
    }
    
//    NSLog(@"解析后的数据：\n %@",finalJson);
    
    return finalJson;
}

/*
1.接口地址：http://passport.china.com//chinaapi/appUserRegisterServlet
2.入口参数名：param
3.错误码如下：
13--同一个IP地址5秒内只能请求一次
12--同一个IP地址5分钟内只能注册1个账号
11--参数值为空
10--json对象为空
9--缺失设备信息
8--无效的key值
7--解密错误或json解析错误
6--APPID失效或错误
5--设备唯一标识为空
4--验证码错误
3--必须为11位有效手机号码
2--用户名不得为空
1--创建邮箱失败
0--注册成功
-1--用户已存在
-2--用户名中含有禁词
-3--密码强度不够
*/
/*
 BOOL isPhoneNumberTure = [UserPlatformClient isMobileNumber:phonenumber];
 if (isPhoneNumberTure&&password.length>=8&&password.length<=20) {
 
 
 
 }else{
 if (!isPhoneNumberTure) {
 NSString* erros =@"账号输入错误";
 formatError(erros);
 }else if (!(password.length>=8&&password.length<=20)){
 NSString* erros =@"密码格式不正确";
 formatError(erros);
 }
 
 }
 */

//注册请求方法
 +(void)appUserRegisterServletPhoneNumber:(NSString*)phonenumber passWord:(NSString*)password verifyCode:(NSString*)verifycode onSuccess:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock{
     NSDictionary* phoneInfo =[UserPlatformClient phoneInfo];
     NSDictionary* dic =@{@"phoneNumber":phonenumber,@"password":password,@"verifyCode":verifycode,@"phoneInfo":phoneInfo};
     dic=[self appendParam:dic];
     NSError* error;
     NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
     NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
     NSString* JsonStr = [SecurityUtil encryptAESData:json app_key:ChinaAppKey];
//     NSLog(@"发送的数据：\n %@",JsonStr);
     NSDictionary* dicParam =@{@"param":JsonStr,@"appID":ChinaAppId};
     NSString *urlstr=[NSString stringWithFormat:@"%@/appUserRegisterServlet",Host_url];
     
     //URL编码
     urlstr = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     [self postRequestWith:urlstr param:dicParam onSuccess:successBlock onFaile:errorBlock];

}
/*
1.接口地址：http://passport.china.com/chinaapi/appSendCheckCodeServlet
2.入口参数名：param
3.错误码如下：
13--同一个IP地址5秒内只能请求一次
12--同一个号码1分钟内只能发送一次验证码
11--参数值为空
10--json对象为空
9--缺失设备信息
8--无效的key值
7--解密错误或json解析错误
6--APPID失效或错误
5--设备唯一标识为空
4--该号码已被认证，请使用其他号码
3--必须为11位有效手机号码
2--手机号码未被认证
1--type值错误
0--发送成功
-1--今天验证码发送次数达到上限
-2--发送失败
*/
/*
 type:
 1：注册
 2：修改密码
 3：找回密码
*/
//获取验证码
 +(void)appSendCheckCodeServletPhoneNumber:(NSString*)phonenumber Type:(NSString*)type onSuccess:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock{
     //    appID = [appID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     NSDictionary* phoneInfo =[UserPlatformClient phoneInfo];
     NSDictionary* dic =@{@"phoneNumber":phonenumber,@"type":type,@"phoneInfo":phoneInfo};
     dic=[self appendParam:dic];
     NSError* error;
     NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
     NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
     NSString* JsonStr = [SecurityUtil encryptAESData:json app_key:ChinaAppKey];
//     NSLog(@"发送的数据：\n %@",JsonStr);
     NSDictionary* dicParam =@{@"param":JsonStr,@"appID":ChinaAppId};
     NSString* urlstr =[NSString stringWithFormat:@"%@/appSendCheckCodeServlet",Host_url] ;
     //URL编码
     urlstr = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     
     [self postRequestWith:urlstr param:dicParam onSuccess:successBlock onFaile:errorBlock];
    
}

/*
1、接口地址：http://passport.china.com/chinaapi/appUserLogonServlet
2、入口参数名：param
3、状态码如下：
16--用户名暂时不可用请您与管理员联系
15--用户名或密码错误
14--用户名被禁用
13--IP地址被禁用
12--您的请求太频繁，已经被服务器拒绝。请稍后再试！
11--参数值为空
10--json对象为空
9--缺失设备信息
8--无效的key值
7--解密错误或json解析错误
6--APPID失效或错误
5--设备唯一标识为空
4--您已连续5次账号或密码输入错误，请稍后再试!
3--注册邮箱或手机号码为空
2--密码不能为空
1--未完成注册
0--登录成功
*/
//登陆方法
 +(void)appUserLogonServletPhoneNumber:(NSString*)phonenumber passWord:(NSString*)password onSuccess:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock{
    
     NSDictionary* phoneInfo = [UserPlatformClient phoneInfo];
     NSDictionary* dic =@{@"phoneNumber":phonenumber,@"password":password,@"phoneInfo":phoneInfo};
     dic=[self appendParam:dic];
     NSLog(@"发送的数据：\n %@",dic);
     NSError* error;
     NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
     
     NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
     NSString* JsonStr = [SecurityUtil encryptAESData:json app_key:ChinaAppKey];
     
     NSString * appID = [UserPlatformClient utf8ToUnicode:ChinaAppId];
     NSDictionary* dicParam =@{@"param":JsonStr,@"appID":appID};
     
     NSString* urlstr = [NSString stringWithFormat:@"%@/appUserLogonServlet",Host_url];
     //URL编码
     urlstr = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//     NSLog(@"请求的url\n %@",urlstr);
//     NSLog(@"发送的数据：\n %@",dicParam);
     [self postRequestWith:urlstr param:dicParam onSuccess:successBlock onFaile:errorBlock];
}

/*
 1、接口地址：http://passport.china.com/chinaapi/appModefyPasswordServlet
 2、入口参数名：param，appID
 3、状态码如下：
 AppIdError--APPID失效或错误
 13--同一个IP地址5秒内只能请求一次
 11--参数值为空
 10--json对象为空
 9--缺失设备信息
 8--无效的key值
 7--解密错误
 4--验证码错误
 3--注册邮箱或手机号码为空
 2--session值为空
 1--旧密码或新密码有空值
 5--设备唯一标识为空
 1--账号或旧密码错误
 0--密码修改成功
 -2--密码修改失败
 -1--请登录后再修改密码
*/
//修改密码方法
 +(void)appModefyPasswordServletNewPassWord:(NSString*)newpassword Session:(NSString*)session onSuccess:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock{
     NSDictionary* phoneInfo =[UserPlatformClient phoneInfo];
     NSDictionary* dic =@{@"newPassword":newpassword,@"session":session,@"phoneInfo":phoneInfo};
     dic=[self appendParam:dic];
     NSError* error;
     NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
     NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
     NSString* JsonStr = [SecurityUtil encryptAESData:json app_key:ChinaAppKey];
//     NSLog(@"发送的数据：\n %@",JsonStr);
     NSDictionary* dicParam =@{@"param":JsonStr,@"appID":ChinaAppId};
     NSString* urlstr = [NSString stringWithFormat:@"%@/appModefyPasswordServlet",Host_url];
     //URL编码
     urlstr = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     
     [self postRequestWith:urlstr param:dicParam onSuccess:successBlock onFaile:errorBlock];
}
/*
1、接口地址：http://passport.china.com/chinaapi/appFindPasswordServlet
2、入口参数名：param，appID
3、状态码如下：
AppIdError--APPID失效或错误
13--同一个IP地址5秒内只能请求一次
11--参数值为空
10--json对象为空
9--缺失设备信息
8--无效的key值
7--解密错误
5--设备唯一标识为空
4--验证码错误
3--必须为11位有效手机号码
2--新密码有空值
1--该手机号码未被认证
0--密码重置成功
-3--密码强度不够
-2--密码重置失败
*/
//找回密码方法
 +(void)appFindPasswordServletPhoneNumber:(NSString*)phonenumber newPassWord:(NSString*)newpassword verifyCode:(NSString*)verifycode onSuccess:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock{
    
//    BOOL isPhoneNumberTure = [UserPlatformClient isMobileNumber:phonenumber];
//    if (isPhoneNumberTure&&newpassword.length>=8&&newpassword.length<=20) {
//        
//    }else{
//        if(!isPhoneNumberTure){
//            NSString* erros =@"账号输入错误";
//            formatError(erros);
//        }else if (!(newpassword.length>=8&&newpassword.length<=20)){
//            NSString* erros =@"密码格式不正确";
//            formatError(erros);
//        }
//    }
     NSDictionary* phoneInfo =[UserPlatformClient phoneInfo];
     NSDictionary* dic =@{@"phoneNumber":phonenumber,@"newPassword":newpassword,@"verifyCode":verifycode,@"phoneInfo":phoneInfo};
     dic=[self appendParam:dic];
//      NSLog(@"发送的数据：\n %@",dic);
     NSError* error;
     NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
     NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
     NSString* JsonStr = [SecurityUtil encryptAESData:json app_key:ChinaAppKey];
    
     NSDictionary* dicParam =@{@"param":JsonStr,@"appID":ChinaAppId};
     NSString* urlstr = [NSString stringWithFormat:@"%@/appFindPasswordServlet",Host_url];
     //URL编码
     urlstr = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//      NSLog(@"加密的数据：\n %@",dicParam);
     [self postRequestWith:urlstr param:dicParam onSuccess:successBlock onFaile:errorBlock];
}

/*
1、接口地址：http://passport.china.com/chinaapi/appGetUserInfoServlet
2、入口参数名：param，appID
3、状态码如下：
AppIdError--APPID失效或错误
"11", "参数值为空"
"10", "json对象为空"
"9", "缺失设备信息"
"8", "无效的key值"
"7", "解密错误"
"6", "请登录后再修改密码"
"5", "设备唯一标识为空"
"3", "用户ID为空"
"2", "session为空"
"1", "用户不存在"
"0", "成功"
*/
//获取用户个人信息接口
 +(void)appGetUserInfoServletSession:(NSString*)session  onSuccess:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock {
    NSDictionary* phoneInfo =[UserPlatformClient phoneInfo];
    NSDictionary* dic =@{@"session":session,@"phoneInfo":phoneInfo};
    dic=[self appendParam:dic];
    NSError* error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString* JsonStr = [SecurityUtil encryptAESData:json app_key:ChinaAppKey];
//    NSLog(@"发送的数据：\n %@",JsonStr);
    NSDictionary* dicParam =@{@"param":JsonStr,@"appID":ChinaAppId};
    NSString* urlstr = [NSString stringWithFormat:@"%@/appGetUserInfoServlet",Host_url];
    //URL编码
    urlstr = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self postRequestWith:urlstr param:dicParam onSuccess:successBlock onFaile:errorBlock];
    
}

/*
 1、接口地址：http://passport.china.com/chinaapi/appThe3UserLogonServlet
 2、入口参数名：param，appID
 3、状态码如下：
 AppIdError--APPID失效或错误
 17—昵称重复
 16--登录失败
 15--from值为空
 14--第三方用户唯一标识
 12--您的请求太频繁，已经被服务器拒绝。请稍后再试！
 11--参数值为空
 10--json对象为空
 9--缺失设备信息
 8--无效的key值
 7--解密错误
 5--设备唯一标识为空
 0--登录成功
*/
//用户第三方登录
 +(void)appThe3UserLogonServletFrom:(NSString*)from Token:(NSString*)token NickName:(NSString*)nickname HeadiconUrl:(NSString*)headiconUrl onSuccess:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock{
    
    NSDictionary* phoneInfo =[UserPlatformClient phoneInfo];
    NSDictionary* dic =@{@"from":from,@"userID":token,@"phoneInfo":phoneInfo,@"nickname":nickname,@"headiconUrl":headiconUrl};
     dic=[self appendParam:dic];
    NSError* error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString* JsonStr = [SecurityUtil encryptAESData:json app_key:ChinaAppKey];
//    NSLog(@"发送的数据：\n %@",JsonStr);
    NSDictionary* dicParam =@{@"param":JsonStr,@"appID":ChinaAppId};
    NSString* urlstr = [NSString stringWithFormat:@"%@/appThe3UserLogonServlet",Host_url];
    //URL编码
    urlstr = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self postRequestWith:urlstr param:dicParam onSuccess:successBlock onFaile:errorBlock];
    
}

/*
 1、接口地址：http://passport.china.com/chinaapi/appModefyUserInfoServlet
 2、入口参数名：param，appID
 3、状态码如下：
 AppIdError--APPID失效或错误
 17--图片只能是png/jpg/gif格式的
 13--同一个IP地址5秒内只能请求一次
 11--参数值为空
 10--json对象为空
 9--缺失设备信息
 8--无效的key值
 7--解密错误
 6--输入的身份证号有误
 5--设备唯一标识为空
 2--session值为空
 1--账号错误
 0--修改成功
 -1--请登录后再修改密码
 -2--修改失败
 -3--姓名中含有关键字
*/
//用户修改信息 上传用户信息
 +(void)appModefyUserInfoServletUserName:(NSString*)username NickName:(NSString*)nickname Birthday:(NSDate*)birthday Email:(NSString*)email Name:(NSString*)name Sex:(NSString*)sex Address:(NSString*)address Tel:(NSString*)tel PhoneNumber:(NSString*)phoneNumber HeadiconImage:(NSData*)headiconimage PostCode:(NSString*)postCode CertificateType:(NSString*)certificateType CertificateCode:(NSString*)certificateCode Province:(NSString*)province Session:(NSString*)session  onSuccess:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock{
    
    NSString* birthdayStr = [UserPlatformClient stringFromDate:birthday];
    
    username = [UserPlatformClient utf8ToUnicode:username];
    nickname = [UserPlatformClient utf8ToUnicode:nickname];
    name = [UserPlatformClient utf8ToUnicode:name];
    address = [UserPlatformClient utf8ToUnicode:address];
    province = [UserPlatformClient utf8ToUnicode:province];
    
    sex = [UserPlatformClient utf8ToUnicode:sex];
    
    NSDictionary* phoneInfo =[UserPlatformClient phoneInfo];
    NSDictionary* userInfo = @{@"username":username,@"nickname":nickname,@"birthday":birthdayStr,@"email":email,@"name":name,@"sex":sex,@"address":address,@"tel":tel,@"phoneNumber":phoneNumber,@"postCode":postCode,@"certificateType":certificateType,@"certificateCode":certificateCode,@"province":province};
    NSDictionary* dic =@{@"userInfo":userInfo,@"phoneInfo":phoneInfo,@"session":session};
     dic=[self appendParam:dic];
    NSError* error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString* JsonStr = [SecurityUtil encryptAESData:json app_key:ChinaAppKey];
//    NSLog(@"发送的数据：\n %@",JsonStr);
    NSDictionary* dicParam =@{@"param":JsonStr,@"appID":ChinaAppId};
    NSString* urlstr = [NSString stringWithFormat:@"%@/appModefyUserInfoServlet",Host_url];
    //URL编码
    urlstr = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *imgData = headiconimage;
     [self postFileDataRequest:urlstr postDic:dicParam file:imgData name:@"headIcon" fileName:@"headIcon.jpg" type:@"image/jpg" onSuccess:successBlock onError:errorBlock];
/*
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager POST:urlstr parameters:dicParam constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //
        if (imgData) {
            [formData appendPartWithFileData:imgData name:@"picture" fileName:@"picture.jpg" mimeType:@"image/jpg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id finalJson= [self decodeResponseData:responseObject];
        //成功回传参数封装类
        if (finalJson) {
            successBlock(finalJson);
        }else{
            NSError *error=[[NSError alloc]initWithDomain:@"未知错误" code:121 userInfo:nil];
            errorBlock(error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error %@",error);
        errorBlock(error);
    }];
   */
}

//接口地址：http://passport.china.com/chinaapi/appValidateSidServlet
//验证session是否有效
 +(void)appSessionServletSession:(NSString*)session onSuccess:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock{
    
    NSDictionary* phoneInfo = [UserPlatformClient phoneInfo];
    NSDictionary* dic =@{@"session":session,@"phoneInfo":phoneInfo};
     dic=[self appendParam:dic];
    NSError* error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString* JsonStr = [SecurityUtil encryptAESData:json app_key:ChinaAppKey];
//    NSLog(@"发送的数据：\n %@",JsonStr);
    NSDictionary* dicParam =@{@"param":JsonStr,@"appID":ChinaAppId};
    NSString *urlstr=[NSString stringWithFormat:@"%@/appValidateSidServlet",Host_url];
    
    //URL编码
    urlstr = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self postRequestWith:urlstr param:dicParam onSuccess:successBlock onFaile:errorBlock];

}

//接口地址：http://passport.china.com/chinaapi/appUserLogoutServlet
//注销
 +(void)appExitServletSession:(NSString*)session onSuccess:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock{
    
    NSDictionary* phoneInfo = [UserPlatformClient phoneInfo];
    NSDictionary* dic =@{@"session":session,@"phoneInfo":phoneInfo};
     dic=[self appendParam:dic];
    NSError* error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString* JsonStr = [SecurityUtil encryptAESData:json app_key:ChinaAppKey];
//    NSLog(@"发送的数据：\n %@",JsonStr);
    NSDictionary* dicParam =@{@"param":JsonStr,@"appID":ChinaAppId};
    NSString *urlstr=[NSString stringWithFormat:@"%@/appUserLogoutServlet",Host_url];
    
    //URL编码
    urlstr = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self postRequestWith:urlstr param:dicParam onSuccess:successBlock onFaile:errorBlock];
    
}


//接口地址:http://passport.china.com/chinaapi/appModefyUserNameServlet
//修改昵称
 +(void)appChangeNickSession:(NSString*)session NickName:(NSString*)nickName onSuccess:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock{
    
    NSDictionary* phoneInfo = [UserPlatformClient phoneInfo];
    NSDictionary* dic =@{@"session":session,@"phoneInfo":phoneInfo,@"nickname":nickName};
     dic=[self appendParam:dic];
    NSError* error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString* JsonStr = [SecurityUtil encryptAESData:json app_key:ChinaAppKey];
//    NSLog(@"发送的数据：\n %@",JsonStr);
    NSDictionary* dicParam =@{@"param":JsonStr,@"appID":ChinaAppId};
    NSString *urlstr=[NSString stringWithFormat:@"%@/appModefyUserNameServlet",Host_url];
    
    //URL编码
    urlstr = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     [self postRequestWith:urlstr param:dicParam onSuccess:successBlock onFaile:errorBlock];
     
     
     
    [self postRequestWith:urlstr param:dicParam onSuccess:successBlock onFaile:errorBlock];
}
//字典转换字符串
+(NSString *)HTTPBodyWithParameters:(NSDictionary *)parameters
{
    NSMutableArray *parametersArray = [[NSMutableArray alloc]init];
    
    for (NSString *key in [parameters allKeys]) {
        id value = [parameters objectForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
//            NSString*unicode=[UserPlatformClient utf8ToUnicode:value];
//            NSString *source=value;
//            NSString *str=[source stringByReplacingOccurrencesOfString:@"+" withString:@"="];
            [parametersArray addObject:[NSString stringWithFormat:@"%@=%@",key,value]];
        }
        
    }
    return [parametersArray componentsJoinedByString:@"&"];
}
//输出datalog
+(void)logDataString:(id)responseObject{
    NSData*data=responseObject;
    NSString *json=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"request log %@",json);
}
//拼接返回字典
+(NSDictionary*)splitReslutDictWithState:(NSInteger)state message:(NSString*)message error:(NSError*)error{
    NSString *statestr=[NSString stringWithFormat:@"%li",(long)state];
    return [[NSDictionary alloc]initWithObjectsAndKeys:statestr,@"state",message,@"message",error,@"error", nil];
}
//发送post请求
+(void)postRequestWith:(NSString*)urlstr param:(NSDictionary*)dict onSuccess:(SuccessBlock)success onFaile:(ErrorBlock)failure{
    //    2.创建请求对象
    NSURL *url=[NSURL URLWithString:urlstr];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    [request setHTTPMethod:@"POST"];
    NSString *param=[self HTTPBodyWithParameters:dict];
//        NSLog(@"param %@",param);
    NSData *data=[param dataUsingEncoding:NSUTF8StringEncoding];
//    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    NSError *error;
//    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    NSData *data=[json dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSOperationQueue *queue=[NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //
        if (connectionError) {
            failure(connectionError);
        }else{
            [self logDataString:data];
            id finalJson= [self decodeResponseData:data];
            //成功回传参数封装类
            if (finalJson) {
                success(finalJson);
            }else{
                NSError *error=[[NSError alloc]initWithDomain:@"未知错误" code:121 userInfo:nil];
                failure(error);
            }
        }
        
    }];
}
//发送post请求
+(void)postFileDataRequest:(NSString*)urlstr postDic:(NSDictionary*)dict file:(NSData*)filedata name:(NSString*)name fileName:(NSString*)fileName type:(NSString*)type onSuccess:(SuccessBlock)successedBlock onError:(ErrorBlock)errorBlock{
    NSURL *url=[NSURL URLWithString:urlstr];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    [request setHTTPMethod:@"POST"];
    NSString *param=[self HTTPBodyWithParameters:dict];
    //        NSLog(@"param %@",param);
    NSData *dictparam=[param dataUsingEncoding:NSUTF8StringEncoding];
    //    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //    NSError *error;
    //    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    //    NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //    NSData *data=[json dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:dictparam];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
                                                               fromData:filedata
                                                      completionHandler:
                                          ^(NSData *data, NSURLResponse *response, NSError *error) {
                                              // ...
                                              if (error) {
                                                  NSLog(@"error %@",error);
                                                  NSError *retun=[[NSError alloc]initWithDomain:error.description code:121 userInfo:nil];
                                                  errorBlock(retun);
                                              }else{
                                                  [self logDataString:data];
                                                  id finalJson= [self decodeResponseData:data];
                                                  //成功回传参数封装类
                                                  if (finalJson) {
                                                      successedBlock(finalJson);
                                                  }else{
                                                      NSError *error=[[NSError alloc]initWithDomain:@"未知错误" code:121 userInfo:nil];
                                                      errorBlock(error);
                                                  }
                                              }
                                          }];
    
    [uploadTask resume];
}
@end
