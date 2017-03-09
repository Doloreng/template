//
//  UserPlatformClient.h
//  userPlatform
//
//  Created by pengnan on 15/5/4.
//  Copyright (c) 2015年 pengnan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^voidBlock)(void);
typedef void(^SuccessBlock)(id successObj);
typedef void(^ErrorBlock)(NSError *engineError);
@interface UserPlatformClient : NSObject
//unicode编码以\u开头
+(NSString *)replaceUnicode:(NSString *)unicodeStr;
//注册请求方法
/*
 PhoneNumber    手机号(11位手机号)
 passWord       密码(8-20位阿拉伯数字英文)
 verifyCode     验证码(短信验证码)
 Identification 唯一标识(自动生成)
 Model          型号(手机型号)
 networkType    联网方式(2G,3G，4G，Wifi)
 platForm       平台(Android，Iphone，Ipad)
 Resolution     分辨率(如：1920X1080)
 Version        纬度(版本号)
 AppID          软件ID
 
 错误码如下：
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
 +(void)appUserRegisterServletPhoneNumber:(NSString*)phonenumber passWord:(NSString*)password verifyCode:(NSString*)verifycode onSuccess:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock;

//获取验证码
/*
 PhoneNumber      手机号(11位手机号)
 Type             验证码类型(1：注册 2：修改密码 3：找回密码)
 Identification   唯一标识(自动生成)
 Model            型号(手机型号)
 networkType      联网方式(2G,3G，4G，Wifi)
 platForm         平台(Android，Iphone，Ipad)
 Resolution       分辨率(如：1920X1080)
 Version          纬度(版本号)
 AppID            软件ID

错误码如下：
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
 +(void)appSendCheckCodeServletPhoneNumber:(NSString*)phonenumber Type:(NSString*)type onSuccess:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock;

//用户登录
/*
 PhoneNumber    手机号(11位手机号)
 passWord       密码(8-20位阿拉伯数字英文)
 Identification 唯一标识(自动生成)
 Model          型号(手机型号)
 networkType    联网方式(2G,3G，4G，Wifi)
 platForm       平台(Android，Iphone，Ipad)
 Resolution     分辨率(如：1920X1080)
 Version        纬度(版本号)
 AppID          软件ID
 
状态码如下：
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
 +(void)appUserLogonServletPhoneNumber:(NSString*)phonenumber passWord:(NSString*)password onSuccess:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock;

//修改密码
/*
 PhoneNumber      手机号(11位手机号)
 newPassWord      新密码(8-20位阿拉伯数字英文)
 Session          session
 Identification   唯一标识(自动生成)
 Model            型号(手机型号)
 networkType      联网方式(2G,3G，4G，Wifi)
 platForm         平台(Android，Iphone，Ipad)
 Resolution       分辨率(如：1920X1080)
 Version          纬度(版本号)
 AppID            软件ID
 
状态码如下：
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
 +(void)appModefyPasswordServletNewPassWord:(NSString*)newpassword Session:(NSString*)session onSuccess:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock;

//找回密码
/*
 PhoneNumber      手机号(11位手机号)
 newPassWord      新密码(8-20位阿拉伯数字英文)
 verifyCode       验证码(短信验证码)
 Identification   唯一标识(自动生成)
 Model            型号(手机型号)
 networkType      联网方式(2G,3G，4G，Wifi)
 platForm         平台(Android，Iphone，Ipad)
 Resolution       分辨率(如：1920X1080)
 Version          纬度(版本号)
 AppID            软件ID
 
状态码如下：
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
 +(void)appFindPasswordServletPhoneNumber:(NSString*)phonenumber newPassWord:(NSString*)newpassword verifyCode:(NSString*)verifycode onSuccess:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock;

//获取用户个人信息
/*
 UserID           用户ID(13718187045@mail.china.com)
 Session          session
 Identification   唯一标识(自动生成)
 Model            型号(手机型号)
 networkType      联网方式(2G,3G，4G，Wifi)
 platForm         平台(Android，Iphone，Ipad)
 Resolution       分辨率(如：1920X1080)
 Version          纬度(版本号)
 AppID            软件ID
 
状态码如下：
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
 +(void)appGetUserInfoServletSession:(NSString*)session onSuccess:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock;

//第三方登录
/*
 From             来自哪里(QQ，WeiBo)
 Token            第三方用户唯一标识
 Identification   唯一标识(自动生成)
 Model            型号(手机型号)
 networkType      联网方式(2G,3G，4G，Wifi)
 platForm         平台(Android，Iphone，Ipad)
 Resolution       分辨率(如：1920X1080)
 Version          纬度(版本号)
 AppID            软件ID
 
状态码如下：
AppIdError--APPID失效或错误
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
 +(void)appThe3UserLogonServletFrom:(NSString*)from Token:(NSString*)token NickName:(NSString*)nickname HeadiconUrl:(NSString*)headiconUrl onSuccess:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock;

//用户修改信息
/*
 UserName         用户名
 NickName         昵称
 Birthday         生日(以NSDate方式传值)
 Email            联系邮箱(即绑定邮箱，对于修改基本信息时，认证手机，不在此做处理)
 Name             姓名
 Sex              性别(0:女;1:男;2:其他)
 Address          地址
 Tel              联系电话
 PhoneNumber      用户认证手机(即绑定邮箱，对于修改基本信息时，认证手机，不在此做处理)
 HeadiconImage    用户头像(以UIImage方式传值)
 PostCode         邮编
 CertificateType  证件类型(0:身份证;1:学生证;2:军人证;3:护照)
 CertificateCode  证件号码
 Province         省份(对应值，请参考附录)
 Session          session
 Identification   唯一标识(自动生成)
 Model            型号(手机型号)
 networkType      联网方式(2G,3G，4G，Wifi)
 platForm         平台(Android，Iphone，Ipad)
 Resolution       分辨率(如：1920X1080)
 Version          纬度(版本号)
 AppID            软件ID
 
状态码如下：
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
 +(void)appModefyUserInfoServletUserName:(NSString*)username NickName:(NSString*)nickname Birthday:(NSDate*)birthday Email:(NSString*)email Name:(NSString*)name Sex:(NSString*)sex Address:(NSString*)address Tel:(NSString*)tel PhoneNumber:(NSString*)phoneNumber HeadiconImage:(NSData*)headiconimage PostCode:(NSString*)postCode CertificateType:(NSString*)certificateType CertificateCode:(NSString*)certificateCode Province:(NSString*)province Session:(NSString*)session   onSuccess:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock;

//验证session是否有效
/*
session        session
Identification 唯一标识(自动生成)
Model          型号(手机型号)
networkType    联网方式(2G,3G，4G，Wifi)
platForm       平台(Android，Iphone，Ipad)
Resolution     分辨率(如：1920X1080)
Version        纬度(版本号)
AppID          软件ID
 
 状态码如下：
 state:
     0 有效
     1 无效
*/
 +(void)appSessionServletSession:(NSString*)session onSuccess:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock;

//注销
/*
 session        session
 Identification 唯一标识(自动生成)
 Model          型号(手机型号)
 networkType    联网方式(2G,3G，4G，Wifi)
 platForm       平台(Android，Iphone，Ipad)
 Resolution     分辨率(如：1920X1080)
 Version        纬度(版本号)
 AppID          软件ID
 
 状态码如下：
 state:
 0：注销成功
 1：注销失败
 */
 +(void)appExitServletSession:(NSString*)session onSuccess:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock;

//修改昵称
/*
state 状态
12--您的请求太频繁，已经被服务器拒绝。请稍后再试！
11--参数值为空
10--json对象为空
9--缺失设备信息
8--无效的key值
7--解密错误
6--session值为空
5--设备唯一标识为空
4--昵称为空
3--session已失效
2--昵称重复
1--修改失败
0--修改成功
message
响应描述
String
响应描述（失败信息直接在手机端显示给用户）
 */
 +(void)appChangeNickSession:(NSString*)session NickName:(NSString*)nickName onSuccess:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
@end
