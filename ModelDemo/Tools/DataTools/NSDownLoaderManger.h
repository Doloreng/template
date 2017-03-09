//
//  NSDownLoaderManger.h
//  moduleDemo
//
//  Created by hongkunpeng on 15/6/8.
//  Copyright (c) 2015年 hongkunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^SuccessBlock)(id successObj);
typedef void (^ErrorBlock)(NSError *error);
typedef void (^VoidBlock)(void);
@interface NSDownLoaderManger : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
//下载文件
-(void)downloadFileWithUrl:(NSString*)urlstr filePathURL:(NSURL*)filePathURL saveName:(NSString*)name  progress:(NSProgress*)progress success:(SuccessBlock)successBlock failure:(ErrorBlock)errorBlock;
//上传文件
-(void)uploadFileWithFilePath:(NSURL*)filePath hostUrl:(NSString*)url  progress:(NSProgress*)progress success:(SuccessBlock)successBlock failure:(ErrorBlock)errorBlock;
@end
