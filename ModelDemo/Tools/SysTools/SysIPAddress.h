//
//  SysIPAddress.h
//  ambulance
//
//  Created by hongkunpeng on 15/8/3.
//  Copyright (c) 2015年 hongkunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SysIPAddress : NSObject
+ (NSString *)getIPAddress:(BOOL)preferIPv4;
@end
