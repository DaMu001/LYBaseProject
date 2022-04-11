//
//  LYJsonNetManager.m
//  Example
//
//  Created by damu on 2022/3/14.
//  Copyright © 2022 babo. All rights reserved.
//

#import "LYJsonNetManager.h"

@interface LYJsonNetManager ()

@end

@implementation LYJsonNetManager

+ (instancetype)sharedJsonNetManager
{
    /*! 为单例对象创建的静态实例，置为nil，因为对象的唯一性，必须是static类型 */
    static id sharedJsonNetManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedJsonNetManager = [[super allocWithZone:NULL] init];
    });
    return sharedJsonNetManager;
}

+ (void)initialize {
    [self setupJsonNetManager];
}

+ (void)setupJsonNetManager
{
    LYJsonNetManager.sharedJsonNetManager.sessionManager = [AFHTTPSessionManager manager];
    /*! 设置请求超时时间，默认：30秒 */
    LYJsonNetManager.sharedJsonNetManager.timeoutInterval = 15;
    /*! 打开状态栏的等待菊花 */
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    /*! 设置响应数据的基本类型 */
    LYJsonNetManager.sharedJsonNetManager.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/css", @"text/xml", @"text/plain", @"application/javascript", @"application/x-www-form-urlencoded", @"image/*", nil];
    
    LYJsonNetManager.sharedJsonNetManager.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    LYJsonNetManager.sharedJsonNetManager.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [self ly_setValue:@"application/json" forHTTPHeaderKey:@"Accept"]; // application/json text/javascript **/*//*; q=0.01
    [self ly_setValue:@"application/json" forHTTPHeaderKey:@"Content-Type"]; //application/json; charset=utf-8
}

+ (LYBaseNetManager *)getAFHTTPSessionManager
{
    return LYJsonNetManager.sharedJsonNetManager;
}

/**
 *  自定义请求头
 */
+ (void)ly_setValue:(NSString *)value forHTTPHeaderKey:(NSString *)HTTPHeaderKey
{
    [LYJsonNetManager.sharedJsonNetManager.sessionManager.requestSerializer setValue:value forHTTPHeaderField:HTTPHeaderKey];
}

- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval
{
    [super setTimeoutInterval:timeoutInterval];
    LYJsonNetManager.sharedJsonNetManager.sessionManager.requestSerializer.timeoutInterval = timeoutInterval;
}

- (void)setHttpHeaderFieldDictionary:(NSDictionary *)httpHeaderFieldDictionary
{
    [super setHttpHeaderFieldDictionary:httpHeaderFieldDictionary];
    if (![httpHeaderFieldDictionary isKindOfClass:[NSDictionary class]]) {
        NSLog(@"请求头数据有误，请检查！");
        return;
    }
    NSArray *keyArray = httpHeaderFieldDictionary.allKeys;
    
    if (keyArray.count <= 0) {
        NSLog(@"请求头数据有误，请检查！");
        return;
    }
    
    for (NSInteger i = 0; i < keyArray.count; i ++) {
        NSString *keyString = keyArray[i];
        NSString *valueString = httpHeaderFieldDictionary[keyString];
        
        [LYJsonNetManager ly_setValue:valueString forHTTPHeaderKey:keyString];
    }
}

/**
 删除所有请求头
 */
+ (void)ly_clearAuthorizationHeader {
    [LYJsonNetManager.sharedJsonNetManager.sessionManager.requestSerializer clearAuthorizationHeader];
}

@end
