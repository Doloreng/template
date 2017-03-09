//
//  DataEngine.m
//  moduleDemo
//
//  Created by hongkunpeng on 15/6/5.
//  Copyright (c) 2015年 hongkunpeng. All rights reserved.
//

#import "DataEngine.h"
#import "AFNetworking.h"
@implementation DataEngine



//得到afnet
+(AFHTTPRequestOperationManager*)getAFManager{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    return manager;
}
//发送post请求
-(void)postRequest:(NSString*)urlstr postDic:(NSDictionary*)dict onSuccess:(SuccessBlock)successedBlock onError:(ErrorBlock)errorBlock{
    AFHTTPRequestOperationManager *manager=[DataEngine getAFManager];
    [manager POST:urlstr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        [self logDataString:responseObject];
        NSError *error;
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                   options:kNilOptions error:&error];
        //        NSLog(@"resposnse %@  error %@",resultJSON,error);
        
        if (error) {
            errorBlock(error);
        }else{
            successedBlock(resultJSON);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        //        NSLog(@"error %@",error);
        errorBlock(error);
    }];
}
//发送file post请求
-(void)postFileDataRequest:(NSString*)urlstr postDic:(NSDictionary*)dict file:(NSData*)data name:(NSString*)name fileName:(NSString*)fileName type:(NSString*)type onSuccess:(SuccessBlock)successedBlock onError:(ErrorBlock)errorBlock{
    AFHTTPRequestOperationManager *manager=[DataEngine getAFManager];
    [manager POST:urlstr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //
        if (data) {
            [formData appendPartWithFileData:data name:name fileName:fileName mimeType:type];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                   options:kNilOptions error:&error];
        //        NSLog(@"resposnse %@  error %@",resultJSON,error);
        if (error) {
            errorBlock(error);
        }else{
            successedBlock(resultJSON);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        NSLog(@"error %@",error);
        errorBlock(error);
    }];
}
//get 请求
-(void)getRequest:(NSString*)urlstr postDic:(NSDictionary*)dict onSuccess:(SuccessBlock)successedBlock onError:(ErrorBlock)errorBlock{
    AFHTTPRequestOperationManager *manager=[DataEngine getAFManager];
    [manager GET:urlstr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
        NSError *error;
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                   options:kNilOptions error:&error];
        if (error) {
            errorBlock(error);
        }else{
            successedBlock(resultJSON);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        //        NSLog(@"error %@",error);
        errorBlock(error);
    }];
}
@end
