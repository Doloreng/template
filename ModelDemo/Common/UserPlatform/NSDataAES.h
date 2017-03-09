//
//  NSDataAES.h
//  chinaUserPlaform
//
//  Created by hongkunpeng on 15/7/17.
//  Copyright (c) 2015年 hongkunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDataAES : NSObject
+ (NSData *)AES128EncryptWithKey:(NSString *)key source:(NSData*)source;   //加密
+ (NSData *)AES128DecryptWithKey:(NSString *)key source:(NSData*)source;   //解密
@end
