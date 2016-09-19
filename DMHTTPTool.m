//
//  DMHTTPTool.m
//  GapDay
//
//  Created by Seraphic on 16/9/19.
//  Copyright © 2016年 eva. All rights reserved.
//

#import "DMHTTPTool.h"
#import "AFNetworking.h"

static DMHTTPTool * httpTool;
static AFHTTPSessionManager * sessionManager;

@implementation DMHTTPTool

#pragma mark - Singleton

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpTool = [super allocWithZone:zone];
    });
    return httpTool;
}

+(instancetype)sharedInstance
{
    return [[self alloc] init];
}

- (AFHTTPSessionManager *)getSessionManager{

    if(!sessionManager){
        sessionManager = [AFHTTPSessionManager manager];
    }
    //超时时间
    sessionManager.requestSerializer.timeoutInterval = kTimeOutInterval;
    //支持https
    sessionManager.securityPolicy.allowInvalidCertificates = YES;
    //最大并发数
    sessionManager.operationQueue.maxConcurrentOperationCount = 3;
    
    return sessionManager;
}

//GET请求
+ (void)GET:(NSString *)url params:(NSDictionary *)params
                           success:(RequestSuccess)success
                           failure:(RequestFailure)failure
{
    AFHTTPSessionManager * sessionManager = [[self sharedInstance] getSessionManager];
    [sessionManager GET:[NSString stringWithFormat:@"%@%@",BASE_REQUEST_URL,url] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];

}

//POST请求
+ (void)POST:(NSString *)url params:(NSDictionary *)params
                            success:(RequestSuccess)success
                            failure:(RequestFailure)failure
{
    AFHTTPSessionManager * sessionManager = [[self sharedInstance] getSessionManager];
    [sessionManager POST:[NSString stringWithFormat:@"%@%@",BASE_REQUEST_URL,url] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
   
}

//POST请求(上传文件)
+ (void)POST:(NSString *)url params:(NSDictionary *)params
                       withFileData:(NSData *)data
                   andFileParamName:(NSString *)fileParamName
                           progress:(Progress)progress
                            success:(RequestSuccess)success
                            failure:(RequestFailure)failure
{
    AFHTTPSessionManager * sessionManager = [[self sharedInstance] getSessionManager];
    [sessionManager POST:[NSString stringWithFormat:@"%@%@",BASE_REQUEST_URL,url] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSString * fileName = [NSString stringWithFormat:@"%@.jpg",@"123"];
        //添加上传数据
        [formData appendPartWithHeaders:@{} body:data];
        [formData appendPartWithFileData:data name:fileParamName fileName:fileName mimeType:@"image/jpeg"];

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
       
}

//下载
+ (NSURLSessionDownloadTask *)downloadWithUrl:(NSString *)url
                                     SavePath:(NSString *)savePath
                                     progress:(Progress)progress
                                      success:(RequestSuccess)success
                                      failure:(RequestFailure)failure
{
    AFHTTPSessionManager * sessionManager = [[self sharedInstance] getSessionManager];
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSURLSessionDownloadTask * task = [sessionManager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        
        progress(1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        return [NSURL fileURLWithPath:savePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if(error==nil){
            success(filePath.absoluteString);
        }else{
            failure(error);
        }
    }];
    
    [task resume]; 
    return task;
}

//监听网络状态
+ (void)AFNetworkStatus
{
    AFNetworkReachabilityManager * manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {

        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络状态");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"无网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"蜂窝数据网");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi网络");
                
                break;
                
            default:
                break;
        }
        
    }] ;
}


@end
