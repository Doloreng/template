//
//  DataEngine.h
//  moduleDemo
//
//  Created by hongkunpeng on 15/6/5.
//  Copyright (c) 2015年 hongkunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^VoidBlock)(void);
typedef void (^SuccessBlock)(id successObj);
typedef void (^ErrorBlock)(NSError *error);
@interface DataEngine : NSObject
//get 请求
-(void)getRequest:(NSString*)urlstr postDic:(NSDictionary*)dict onSuccess:(SuccessBlock)successedBlock onError:(ErrorBlock)errorBlock;
//发送file post请求
-(void)postFileDataRequest:(NSString*)urlstr postDic:(NSDictionary*)dict file:(NSData*)data name:(NSString*)name fileName:(NSString*)fileName type:(NSString*)type onSuccess:(SuccessBlock)successedBlock onError:(ErrorBlock)errorBlock;
//发送post请求
-(void)postRequest:(NSString*)urlstr postDic:(NSDictionary*)dict onSuccess:(SuccessBlock)successedBlock onError:(ErrorBlock)errorBlock;
@end
