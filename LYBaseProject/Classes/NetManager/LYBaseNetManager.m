//
//  LYBaseNetManager.m
//  Example
//
//  Created by damu on 2022/3/14.
//  Copyright © 2022 babo. All rights reserved.
//

#import "LYBaseNetManager.h"

@interface LYBaseNetManager ()

@end

@implementation LYBaseNetManager

- (LYURLSessionTask *)ly_formGet:(NSString *)url parameters:(NSDictionary *)params headers:(NSDictionary *)headers successBlock:(LYResponseSuccessBlock)successBlock
      failureBlock:(LYResponseFailBlock)failureBlock
{
    LYDataEntity *entity = [[LYDataEntity alloc] init];
    entity.urlString = url;
    entity.parameters = params;
    entity.headers = headers;
    
    return [self ly_request_GETWithEntity:entity successBlock:successBlock failureBlock:failureBlock progressBlock:nil];
}

- (LYURLSessionTask *)ly_formPost:(NSString *)url parameters:(NSDictionary *)params headers:(NSDictionary *)headers successBlock:(LYResponseSuccessBlock)successBlock
       failureBlock:(LYResponseFailBlock)failureBlock
{
    LYDataEntity *entity = [[LYDataEntity alloc] init];
    entity.urlString = url;
    entity.parameters = params;
    entity.headers = headers;
    
    return [self ly_request_POSTWithEntity:entity successBlock:successBlock failureBlock:failureBlock progressBlock:nil];
}

- (LYURLSessionTask *)ly_request_GETWithEntity:(LYDataEntity *)entity
                                  successBlock:(LYResponseSuccessBlock)successBlock
                                  failureBlock:(LYResponseFailBlock)failureBlock
                                 progressBlock:(LYDownloadProgressBlock)progressBlock {
    if (!entity || ![entity isKindOfClass:[LYDataEntity class]]) {
        return nil;
    }
    return [self ly_requestWithType:LYHttpRequestTypeGet entity:entity successBlock:successBlock failureBlock:failureBlock progressBlock:progressBlock];
}

- (LYURLSessionTask *)ly_request_POSTWithEntity:(LYDataEntity *)entity
                                   successBlock:(LYResponseSuccessBlock)successBlock
                                   failureBlock:(LYResponseFailBlock)failureBlock
                                  progressBlock:(LYDownloadProgressBlock)progressBlock {
    if (!entity || ![entity isKindOfClass:[LYDataEntity class]]) {
        return nil;
    }
    return [self ly_requestWithType:LYHttpRequestTypePost entity:entity successBlock:successBlock failureBlock:failureBlock progressBlock:progressBlock];
}

/*!
 *  网络请求的实例方法
 *
 *  @param type         get / post / put / delete
 *  @param entity    entity
 *  @param successBlock 请求成功的回调
 *  @param failureBlock 请求失败的回调
 *  @param progressBlock 进度
 */
- (LYURLSessionTask *)ly_requestWithType:(LYHttpRequestType)type
                                  entity:(LYDataEntity *)entity
                            successBlock:(LYResponseSuccessBlock)successBlock
                            failureBlock:(LYResponseFailBlock)failureBlock
                           progressBlock:(LYDownloadProgressBlock)progressBlock {
    if ( entity.urlString == nil) {
        return nil;
    }
    
    LYWeak;
    /*! 检查地址中是否有中文 */
    NSString *URLString = [NSURL URLWithString:entity.urlString] ? entity.urlString : [self strUTF8Encoding:entity.urlString];
    
    NSString *requestType;
    switch (type) {
        case 0:
            requestType = @"GET";
            break;
        case 1:
            requestType = @"POST";
            break;
        default:
            break;
    }
    
    AFHTTPSessionManager *current_sessionManger = self.sessionManager;
    
    if (entity.isSetQueryStringSerialization) {
        [current_sessionManger.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
            return parameters;
        }];
    }
    LYURLSessionTask *sessionTask = nil;

    if (type == LYHttpRequestTypeGet) {
        sessionTask = [current_sessionManger GET:URLString parameters:entity.parameters headers:entity.headers progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (successBlock) {
                successBlock(responseObject);
            }
            // 对数据进行异步缓存
            [[weakSelf tasks] removeObject:sessionTask];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (failureBlock) {
                failureBlock(error);
            }
            [[weakSelf tasks] removeObject:sessionTask];
            
        }];
    } else if (type == LYHttpRequestTypePost) {
        sessionTask = [current_sessionManger POST:URLString parameters:entity.parameters headers:entity.headers progress:^(NSProgress * _Nonnull uploadProgress) {
//            NSLog(@"上传进度--%lld, 总进度---%lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
            /*! 回到主线程刷新UI */
            dispatch_async(dispatch_get_main_queue(), ^{
                if (progressBlock) {
                    progressBlock(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
                }
            });
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlock) {
                successBlock(responseObject);
            }
            [[weakSelf tasks] removeObject:sessionTask];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failureBlock) {
                failureBlock(error);
            }
            [[weakSelf tasks] removeObject:sessionTask];
            
        }];
    }
    
    if (sessionTask) {
        [[weakSelf tasks] addObject:sessionTask];
    }
    
    return sessionTask;
}

#pragma mark - url 中文格式化
- (NSString *)strUTF8Encoding:(NSString *)str {
    /*! ios9适配的话 打开第一个 */
    return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
}
//
//+ (NSMutableArray *)tasks {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        NSLog(@"创建数组");
//        _tasks = [[NSMutableArray alloc] init];
//    });
//    return _tasks;
//}

- (NSMutableArray *)tasks
{
    if (!_tasks) {
        _tasks = [NSMutableArray array];
    }
    return _tasks;
}

#pragma mark - 取消 Http 请求
/*!
 *  取消所有 Http 请求
 */
- (void)ly_cancelAllRequest {
    // 锁操作
    @synchronized(self) {
        [[self tasks] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [[self tasks] removeAllObjects];
    }
}
//
///*!
// *  取消指定 URL 的 Http 请求
// */
//+ (void)ly_cancelRequestWithURL:(NSString *)URL {
//    if (!URL) {
//        return;
//    }
//    @synchronized (self) {
//        [[self tasks] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
//
//            if ([task.currentRequest.URL.absoluteString hasPrefix:URL]) {
//                [task cancel];
//                [[self tasks] removeObject:task];
//                *stop = YES;
//            }
//        }];
//    }
//}

@end
