//
//  AESEnryption.m
//  moduleDemo
//
//  Created by hongkunpeng on 15/6/8.
//  Copyright (c) 2015年 hongkunpeng. All rights reserved.
//

#import "AESEnryption.h"
#import "RNCryptor.h"
#import "RNEncryptor.h"
#import "RNDecryptor.h"
@implementation AESEnryption
//加密 AES
+ (NSData *)encryptAES256WithKey:(NSString *)password sourceData:(NSData*)sourceData
{
    if (sourceData==nil|password==nil) {
        return nil;
    }
    NSError *error;
    NSData *encryptedData = [RNEncryptor encryptData:sourceData
                                        withSettings:kRNCryptorAES256Settings
                                            password:password
                                               error:&error];
    OutputData(encryptedData);
    return encryptedData;
    
}

+ (NSData *)decryptAES256WithKey:(NSString *)password sourceData:(NSData*)sourceData
{
    if (sourceData==nil||password==nil) {
        return nil;
    }
    NSError *error;
    NSData *decryptedData = [RNDecryptor decryptData:sourceData
                                        withPassword:password
                                               error:&error];
    OutputData(decryptedData);
    return decryptedData;
    
}
void OutputData(NSData *data)
{
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (string) {
        printf("aes Data string %s\n", [string UTF8String]);
    }
    else {
        printf("aes Data string %s\n", [[data base64EncodedStringWithOptions:0] UTF8String]);
    }
}
@end
