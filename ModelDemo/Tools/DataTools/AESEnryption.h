//
//  AESEnryption.h
//  moduleDemo
//
//  Created by hongkunpeng on 15/6/8.
//  Copyright (c) 2015年 hongkunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AESEnryption : NSObject
//加密 AES
+ (NSData *)encryptAES256WithKey:(NSString *)password sourceData:(NSData*)sourceData;
//解密 AES
+ (NSData *)decryptAES256WithKey:(NSString *)password sourceData:(NSData*)sourceData;
@end
