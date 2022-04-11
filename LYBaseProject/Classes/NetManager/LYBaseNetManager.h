//
//  LYBaseNetManager.h
//  Example
//
//  Created by damu on 2022/3/14.
//  Copyright © 2022 babo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LYDataEntity.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>


#define LYWeak  __weak __typeof(self) weakSelf = self

/*! 过期属性或方法名提醒 */
#define LYNetManagerDeprecated(instead) __deprecated_msg(instead)

/*! 使用枚举NS_ENUM:区别可判断编译器是否支持新式枚举,支持就使用新的,否则使用旧的 */
typedef NS_ENUM(NSUInteger, LYNetworkStatus) {
    /*! 未知网络 */
    LYNetworkStatusUnknown           = 0,
    /*! 没有网络 */
    LYNetworkStatusNotReachable,
    /*! 手机 3G/4G 网络 */
    LYNetworkStatusReachableViaWWAN,
    /*! wifi 网络 */
    LYNetworkStatusReachableViaWiFi
};

/*！定义请求类型的枚举 */
typedef NS_ENUM(NSUInteger, LYHttpRequestType) {
    /*! get请求 */
    LYHttpRequestTypeGet = 0,
    /*! post请求 */
    LYHttpRequestTypePost,
};

/*! 实时监测网络状态的 block */
typedef void(^LYNetworkStatusBlock)(LYNetworkStatus status);

/*! 定义请求成功的 block */
typedef void( ^ LYResponseSuccessBlock)(id response);
/*! 定义请求失败的 block */
typedef void( ^ LYResponseFailBlock)(NSError *error);

/*! 定义上传进度 block */
typedef void( ^ LYUploadProgressBlock)(int64_t bytesProgress,
int64_t totalBytesProgress);
/*! 定义下载进度 block */
typedef void( ^ LYDownloadProgressBlock)(int64_t bytesProgress,
int64_t totalBytesProgress);

/*!
 *  方便管理请求任务。执行取消，暂停，继续等任务.
 *  - (void)cancel，取消任务
 *  - (void)suspend，暂停任务
 *  - (void)resume，继续任务
 */
typedef NSURLSessionTask LYURLSessionTask;

@class LYDataEntity;

@interface LYBaseNetManager : NSObject

@property(nonatomic, strong) AFHTTPSessionManager *sessionManager;

@property (strong, nonatomic) NSMutableArray *tasks;

/**
 创建的请求的超时间隔（以秒为单位），此设置为全局统一设置一次即可，默认超时时间间隔为15秒。
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/**
 自定义请求头：httpHeaderField
 */
@property(nonatomic, strong) NSDictionary *httpHeaderFieldDictionary;

#pragma mark - 网络请求的类方法 --- get / post / put / delete
/**
 网络请求的实例方法 get

 @param entity 请求信息载体
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 @param progressBlock 进度回调
 @return LYURLSessionTask
 */
- (LYURLSessionTask *)ly_request_GETWithEntity:(LYDataEntity *)entity
                                  successBlock:(LYResponseSuccessBlock)successBlock
                                  failureBlock:(LYResponseFailBlock)failureBlock
                                 progressBlock:(LYDownloadProgressBlock)progressBlock;

/**
 网络请求的实例方法 post

 @param entity 请求信息载体
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 @param progressBlock 进度
 @return LYURLSessionTask
 */
- (LYURLSessionTask *)ly_request_POSTWithEntity:(LYDataEntity *)entity
                                   successBlock:(LYResponseSuccessBlock)successBlock
                                   failureBlock:(LYResponseFailBlock)failureBlock
                                  progressBlock:(LYDownloadProgressBlock)progressBlock;

- (LYURLSessionTask *)ly_formGet:(NSString *)url
                      parameters:(NSDictionary *)params
                         headers:(NSDictionary *)headers
                    successBlock:(LYResponseSuccessBlock)successBlock
                    failureBlock:(LYResponseFailBlock)failureBlock;

- (LYURLSessionTask *)ly_formPost:(NSString *)url
                       parameters:(NSDictionary *)params
                          headers:(NSDictionary *)headers
                     successBlock:(LYResponseSuccessBlock)successBlock
                     failureBlock:(LYResponseFailBlock)failureBlock;

#pragma mark - 自定义请求头
/**
 *  自定义请求头
 */
+ (void)ly_setValue:(NSString *)value forHTTPHeaderKey:(NSString *)HTTPHeaderKey;
/**
 删除所有请求头
 */
+ (void)ly_clearAuthorizationHeader;

#pragma mark - 取消 Http 请求
/*!
 *  取消所有 Http 请求
 */
+ (void)ly_cancelAllRequest;

/*!
 *  取消指定 URL 的 Http 请求
 */
+ (void)ly_cancelRequestWithURL:(NSString *)URL;

/**
 清空缓存：此方法可能会阻止调用线程，直到文件删除完成。
 */
- (void)ly_clearAllHttpCache;

@end
