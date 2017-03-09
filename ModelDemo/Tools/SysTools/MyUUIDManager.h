//
//  MyUUIDManager.h
//  coreOne
//
//  Created by hongkunpeng on 16/3/3.
//  Copyright © 2016年 hongkunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyUUIDManager: NSObject

+(void)saveUUID:(NSString *)uuid;

+(NSString *)getUUID;

+(void)deleteUUID;

@end