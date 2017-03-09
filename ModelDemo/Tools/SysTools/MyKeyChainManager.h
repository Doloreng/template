//
//  MyKeyChainManager.h
//  coreOne
//
//  Created by hongkunpeng on 16/3/3.
//  Copyright © 2016年 hongkunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyKeyChainManager : NSObject

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service;

+ (void)save:(NSString *)service data:(id)data;

+ (id)load:(NSString *)service;

+ (void)delete:(NSString *)service;

@end
