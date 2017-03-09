//
//  Encryption.h
//  moduleDemo
//
//  Created by hongkunpeng on 15/4/8.
//  Copyright (c) 2015年 hongkunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSData(Encryption)
//加密 Base64
-(NSData*)encodeBase64Data;
//解密 Base64
-(NSData*)decodeBase64Data;
//输出dataToUTF8Sting
-(NSString*)OutputDataToUTF8String;

@end