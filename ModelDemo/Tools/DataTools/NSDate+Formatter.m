//
//  Formatter.m
//  moduleDemo
//
//  Created by hongkunpeng on 15/4/27.
//  Copyright (c) 2015年 hongkunpeng. All rights reserved.
//

#import "NSDate+Formatter.h"

@implementation NSDate(Formatter)
//Nsstring 转换为date 例如：yyyy-MM-dd HH:mm:ss
+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString*)format
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    dateFormat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSDate *date = [dateFormat dateFromString:dateString];
    return date;
    
}
//带样式的时间转换成字符串
+ (NSString *)dateFromStringWithDateStyle:(NSDateFormatterStyle)dateStyle date:(NSDate*)date
{
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.dateStyle = dateStyle;
    fmt.timeStyle = dateStyle;
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSString* dateString = [fmt stringFromDate:date];
    return dateString;
    
}
//自定义样式时间转为字符串
+(NSString*)stringFromDate:(NSDate*)date withFormString:(NSString*)format{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    NSString *srting = [dateFormat stringFromDate:date];
    return srting;
}
//当前手机系统时区的时间
+(NSDate*)getLocalDate:(NSDate*)date{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: date];
    
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    //    NSLog(@"localedate date____________ %@",localeDate);
    return localeDate;
}
//获取相邻几天的日期 default format :yyyy-MM-dd
+(NSString*)getDateSinceDay:(NSInteger)dayNum format:(NSString *)format date:(NSDate*)date{
    if (format==nil) {
        format=@"yyyy-MM-dd";
    }
    if (date==nil) {
         date=[NSDate date];
    }
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    if (dayNum) {
        NSDate *newDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date timeIntervalSinceReferenceDate] + dayNum*24*3600)];
        date=newDate;
    }
    NSString *returnstr=[formatter stringFromDate:date];
    return returnstr;
}
@end
