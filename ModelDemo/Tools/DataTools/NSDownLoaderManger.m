//
//  NSDownLoaderManger.m
//  moduleDemo
//
//  Created by hongkunpeng on 15/6/8.
//  Copyright (c) 2015年 hongkunpeng. All rights reserved.
//

#import "NSDownLoaderManger.h"
#import "AFNetworking.h"

@implementation NSDownLoaderManger
//下载文件
-(void)downloadFileWithUrl:(NSString*)urlstr filePathURL:(NSURL*)filePathURL saveName:(NSString*)name  progress:(NSProgress*)progress success:(SuccessBlock)successBlock failure:(ErrorBlock)errorBlock{
    if (urlstr==nil||name==nil) {
        NSError *error=[[NSError alloc]initWithDomain:@"请传入URL和文件保存名字" code:200 userInfo:nil];
        errorBlock(error);
        return;
    }
    if (!filePathURL) {
        filePathURL= [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        
    }
    filePathURL=[filePathURL URLByAppendingPathComponent:name];
    NSURL *URL = [NSURL URLWithString:urlstr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
//    __autoreleasing NSProgress *autoProgress=progress;
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return filePathURL;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        if (filePath) {
            successBlock(filePath);
        }else{
            errorBlock(error);
        }
        
    }];
    [downloadTask resume];
}

//上传文件
-(void)uploadFileWithFilePath:(NSURL*)filePath hostUrl:(NSString*)url  progress:(NSProgress*)progress success:(SuccessBlock)successBlock failure:(ErrorBlock)errorBlock{
    
    if (filePath==nil||url==nil) {
        NSError *error=[[NSError alloc]initWithDomain:@"请传入URL和文件路径" code:200 userInfo:nil];
        errorBlock(error);
        return;
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//    __autoreleasing NSProgress *autoProgress=progress;
//    NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:filePath progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            errorBlock(error);
        } else {
            NSLog(@"Success: %@ %@", response, responseObject);
            successBlock(responseObject);
        }
    }];
    [uploadTask resume];
}
@end
