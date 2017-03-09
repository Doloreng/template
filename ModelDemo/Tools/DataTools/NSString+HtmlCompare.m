//
//  NSString+HtmlCompare.m
//  moduleDemo
//
//  Created by hongkunpeng on 15/12/24.
//  Copyright © 2015年 hongkunpeng. All rights reserved.
//

#import "NSString+HtmlCompare.h"

@implementation NSString(HtmlCompare)
//过滤图片数组
-(NSMutableArray*)imageArrayHtml{
    //http://([^"]+(?:jpg|gif|png|bmp|jpeg))
    ///^.*\.(jpg|gif|png|bmp)$/i
    
    //    NSString *str=@"<img.*src\\s*=\\s*(.*?)[^>]*?>";
    NSString *str=@"<img(.*?)src=\"(.*?)\"";
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:str options:NSRegularExpressionCaseInsensitive error:nil];
    
    // 提取图片
    NSArray *results = [regex matchesInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, self.length)];
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:results.count];
    for (NSTextCheckingResult *res in results) {
        NSString *sub = [self substringWithRange:[res rangeAtIndex:0]];
        //        [arr addObject:sub];
        NSArray *subArr=[sub componentsSeparatedByString:@"\""];
        //        NSLog(@"subArr %@",subArr);
        [arr addObject:subArr[1]];
        NSLog(@"截取后的image %@",subArr[1]);
        //        NSLog(@"sub str %@",sub);
        //        if (![sub hasSuffix:@"articleLogo.png"]) {
        //            [arr addObject:sub];
        //        }
    }
    NSLog(@"统配图片数组 %@",arr);
    return arr;
}
@end
