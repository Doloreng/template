//
//  Encryption.m
//  moduleDemo
//
//  Created by hongkunpeng on 15/4/8.
//  Copyright (c) 2015年 hongkunpeng. All rights reserved.
//

#import "NSString+Encryption.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
@implementation NSString(Encryption)
//16进制转换为十进制
-(int)scanner16T10:(NSString*)source{
    unsigned int outVal;
    NSScanner* scanner = [NSScanner scannerWithString:source];
    [scanner scanHexInt:&outVal];
    return outVal;
}
//md5
-(NSString*) md5
{

    const char * cStrValue = [self UTF8String];
    NSLog(@"%s",cStrValue);
    unsigned char theResult[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStrValue, (CC_LONG)strlen(cStrValue), theResult);
    
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            theResult[0], theResult[1], theResult[2], theResult[3],
            theResult[4], theResult[5], theResult[6], theResult[7],
            theResult[8], theResult[9], theResult[10], theResult[11],
            theResult[12], theResult[13], theResult[14], theResult[15]];
}
//哈希算法
- (NSString*) sha1
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_LONG len=(unsigned int) data.length;
    CC_SHA1(data.bytes, len, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}
//哈希算法(256)
- (NSString*) sha256
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    CC_LONG len=(unsigned int) data.length;
    CC_SHA256(data.bytes, len, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}
//加密 Base64
-(NSString*)encodeBase64String{
    NSData *nsdata = [self
                      dataUsingEncoding:NSUTF8StringEncoding];
    
    // Get NSString from NSData object in Base64
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    
    // Print the Base64 encoded string
//    NSLog(@"Encoded: %@", base64Encoded);
    return base64Encoded;
}
//解密 Base64
-(NSString*)decodeBase64String{
    // NSData from the Base64 encoded str
    NSData *nsdataFromBase64String = [[NSData alloc]
                                      initWithBase64EncodedString:self options:0];
    
    // Decoded NSString from the NSData
    NSString *base64Decoded = [[NSString alloc]
                               initWithData:nsdataFromBase64String encoding:NSUTF8StringEncoding];
    
//    NSLog(@"Decoded: %@", base64Decoded);
    return base64Decoded;
}
//过滤字符串
-(NSString*)characterSet:(NSString*)characterString{
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:characterString];
    NSString *trimmedString = [self stringByTrimmingCharactersInSet:set];
    return trimmedString;
}
//将数组和字典转换为json字符串
-(NSString*)jsonStingWithData:(id)obj{
    NSError*error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
    NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return json;
}
@end