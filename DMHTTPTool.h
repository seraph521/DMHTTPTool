//
//  DMHTTPTool.h
//
//  Created by Seraphic on 16/9/19.
//  Copyright © 2016年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kTimeOutInterval 60 // 请求超时的时间
#define BASE_REQUEST_URL  @"https://api.xxx.com/"

typedef void (^RequestSuccess)(id jsonData);//请求成功Block
typedef void (^RequestFailure)(NSError * error);//请求失败Block
typedef void (^Progress)(CGFloat progress);//下载上传进度

@interface DMHTTPTool : NSObject

//GET请求
+ (void)GET:(NSString *)url params:(NSDictionary *)params
                           success:(RequestSuccess)success
                           failure:(RequestFailure)failure;

//POST请求
+ (void)POST:(NSString *)url params:(NSDictionary *)params
                            success:(RequestSuccess)success
                            failure:(RequestFailure)failure;

//POST请求(上传文件)
+ (void)POST:(NSString *)url params:(NSDictionary *)params
                       withFileData:(NSData *)data
                   andFileParamName:(NSString *)fileParamName
                           progress:(Progress)progress
                            success:(RequestSuccess)success
                            failure:(RequestFailure)failure;

//下载
+ (NSURLSessionDownloadTask *)downloadWithUrl:(NSString *)url
                                     SavePath:(NSString *)savePath
                                     progress:(Progress)progress
                                      success:(RequestSuccess)success
                                      failure:(RequestFailure)failure;

//监听网络状态
+ (void)AFNetworkStatus;
@end
