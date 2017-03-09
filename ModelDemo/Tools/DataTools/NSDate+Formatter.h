//
//  Formatter.h
//  moduleDemo
//
//  Created by hongkunpeng on 15/4/27.
//  Copyright (c) 2015年 hongkunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(Formatter)
//Nsstring 转换为date 例如：yyyy-MM-dd HH:mm:ss
+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString*)format;
//带样式的时间转换成字符串
+ (NSString *)dateFromStringWithDateStyle:(NSDateFormatterStyle)dateStyle date:(NSDate*)date;
//自定义样式时间转为字符串
+(NSString*)stringFromDate:(NSDate*)date withFormString:(NSString*)format;
//当前手机语言时区的时间
+(NSDate*)getLocalDate:(NSDate*)date;
//获取相邻几天的日期 default format :yyyy-MM-dd
+(NSString*)getDateSinceDay:(NSInteger)dayNum format:(NSString *)format date:(NSDate*)date;
@end
