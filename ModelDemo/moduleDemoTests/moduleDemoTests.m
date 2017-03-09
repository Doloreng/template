//
//  moduleDemoTests.m
//  moduleDemoTests
//
//  Created by hongkunpeng on 15/4/8.
//  Copyright (c) 2015年 hongkunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NSString+Encryption.h"
#import "AESEnryption.h"
#import "SysCommunication.h"
#import "NSDownLoaderManger.h"
@interface moduleDemoTests : XCTestCase

@end

@implementation moduleDemoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testAES{
    NSString *sourcestr=@"这是我的测试";
    NSString *key=@"ddfffaa";
    NSData *sourceData=[sourcestr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encodeData= [AESEnryption encryptAES256WithKey:key sourceData:sourceData];
    NSData *decode=[AESEnryption decryptAES256WithKey:key sourceData:encodeData];
    
}
-(void)testDownloadTask{
    //http://pic.miercn.com/uploads/allimg/150609/40-150609151941.jpg
    NSString *urlstr=@"http://pic.miercn.com/uploads/allimg/150609/40-150609151941.jpg";
    NSProgress *progres=[NSProgress progressWithTotalUnitCount:10000.0];;
    [progres addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
    NSDownLoaderManger *manager=[NSDownLoaderManger new];
    [manager downloadFileWithUrl:urlstr filePathURL:nil saveName:@"beautiful.jpg" progress:progres success:^(id successObj) {
        //
        NSURL *path=successObj;
        NSLog(@"下载成功了 %@",path);
    } failure:^(NSError *error) {
        //
        NSLog(@"下载失败了 %@",error);
    }];
    [self untilDateFun];
}
// 监听到了属性改变会调用这个方法

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context

{
    NSProgress*progress=object;
    NSLog(@"image downprogress =  %f",progress.fractionCompleted);
    
}
-(void)testTouchEnable{
    [SysCommunication touchAuthenticateWithMessage:@"请输入Touch密码" onSuccess:^(id obj) {
        //
        NSString *result=obj;
        NSLog(@"result %@",result);
    } onError:^(NSError *error) {
        //
        NSLog(@"error %@",error);
    }];
    [self untilDateFun];
}
-(void)testBase64{
    NSString *str=@"abcdef";
    str= [str encodeBase64String];
    NSLog(@"encode str %@",str);
    str= [str decodeBase64String];
    NSLog(@"decode str %@",str);
}
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}
-(void)untilDateFun{
    NSDate *untilDate;
    while (true)
        
    {
        untilDate = [NSDate dateWithTimeIntervalSinceNow:10.0];
        [[NSRunLoop currentRunLoop] runUntilDate:untilDate];
        NSLog(@"Polling...");
        break;
    }
    
}
@end
