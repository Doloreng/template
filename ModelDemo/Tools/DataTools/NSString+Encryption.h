//
//  Encryption.h
//  moduleDemo
//
//  Created by hongkunpeng on 15/4/8.
//  Copyright (c) 2015年 hongkunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#define Defult

@interface NSString(Encryption)
//md5
-(NSString*) md5;
//哈希算法
- (NSString*) sha1;
//哈希算法(256)
- (NSString*) sha256;
//加密 Base64
-(NSString*)encodeBase64String;
//解密 Base64
-(NSString*)decodeBase64String;
//过滤字符串
-(NSString*)characterSet:(NSString*)characterString;
//将数组和字典转换为json字符串
-(NSString*)jsonStingWithData:(id)obj;
//16进制转换为十进制
-(int)scanner16T10:(NSString*)source;
@end