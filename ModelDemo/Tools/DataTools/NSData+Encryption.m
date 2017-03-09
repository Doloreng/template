//
//  Encryption.m
//  moduleDemo
//
//  Created by hongkunpeng on 15/4/8.
//  Copyright (c) 2015年 hongkunpeng. All rights reserved.
//

#import "NSData+Encryption.h"
@implementation NSData(Encryption)
//加密 Base64
-(NSData*)encodeBase64Data{
    
    // Convert to Base64 data
    NSData *base64Data = [self base64EncodedDataWithOptions:0];
    return base64Data;
}
//解密 Base64
-(NSData*)decodeBase64Data{
    NSData *base64Decoded = [self initWithBase64EncodedData:self options:0];
    return base64Decoded;
}
//输出dataToUTF8Sting
-(NSString*)OutputDataToUTF8String
{
    NSString *string = [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    if (string) {
        printf("aes Data string %s\n", [string UTF8String]);
    }
    else {
        string=[self base64EncodedStringWithOptions:0];
        printf("aes Data string %s\n",[string UTF8String]);
        
    }
    return string;
}

@end